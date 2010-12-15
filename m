Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48060 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691Ab0LOWwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 17:52:47 -0500
Date: Thu, 16 Dec 2010 00:52:40 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v3] nl80211: Add notification for dropped Deauth/Disassoc
Message-ID: <20101215225240.GB19473@jm.kir.nu>
References: <20101213220048.GA24752@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101213220048.GA24752@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new notification to indicate that a received, unprotected
Deauthentication or Disassociation frame was dropped due to
management frame protection being in use. This notification is
needed to allow user space (e.g., wpa_supplicant) to implement
SA Query procedure to recover from association state mismatch
between an AP and STA.

This is needed to avoid getting stuck in non-working state when MFP
(IEEE 802.11w) is used and a protected Deauthentication or
Disassociation frame is dropped for any reason. After that, the
station would silently discard any unprotected Deauthentication or
Disassociation frame that could be indicating that the AP does not
have association for the STA (when the Reason Code would be 6 or 7).
IEEE Std 802.11w-2009, 11.13 describes this recovery mechanism.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 include/linux/nl80211.h |   10 ++++++++++
 include/net/cfg80211.h  |   26 ++++++++++++++++++++++++++
 net/mac80211/rx.c       |   22 ++++++++++++++++++++--
 net/wireless/mlme.c     |   22 ++++++++++++++++++++++
 net/wireless/nl80211.c  |   16 ++++++++++++++++
 net/wireless/nl80211.h  |    6 ++++++
 6 files changed, 100 insertions(+), 2 deletions(-)

v3: Include the forgotten include/net/cfg80211.h changes


--- wireless-testing.orig/include/linux/nl80211.h	2010-12-16 00:45:15.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2010-12-16 00:45:18.000000000 +0200
@@ -394,6 +394,13 @@
  *
  * @NL80211_CMD_SET_WDS_PEER: Set the MAC address of the peer on a WDS interface.
  *
+ * @NL80211_CMD_UNPROT_DEAUTHENTICATE: Unprotected deauthentication frame
+ *	notification. This event is used to indicate that an unprotected
+ *	deauthentication frame was dropped when MFP is in use.
+ * @NL80211_CMD_UNPROT_DISASSOCIATE: Unprotected disassociation frame
+ *	notification. This event is used to indicate that an unprotected
+ *	disassociation frame was dropped when MFP is in use.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -500,6 +507,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_FRAME_WAIT_CANCEL,
 
+	NL80211_CMD_UNPROT_DEAUTHENTICATE,
+	NL80211_CMD_UNPROT_DISASSOCIATE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
--- wireless-testing.orig/net/mac80211/rx.c	2010-12-16 00:44:31.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-12-16 00:45:18.000000000 +0200
@@ -1539,12 +1539,30 @@ ieee80211_drop_unencrypted_mgmt(struct i
 	if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
 		if (unlikely(!ieee80211_has_protected(fc) &&
 			     ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
-			     rx->key))
+			     rx->key)) {
+			if (ieee80211_is_deauth(fc))
+				cfg80211_send_unprot_deauth(rx->sdata->dev,
+							    rx->skb->data,
+							    rx->skb->len);
+			else if (ieee80211_is_disassoc(fc))
+				cfg80211_send_unprot_disassoc(rx->sdata->dev,
+							      rx->skb->data,
+							      rx->skb->len);
 			return -EACCES;
+		}
 		/* BIP does not use Protected field, so need to check MMIE */
 		if (unlikely(ieee80211_is_multicast_robust_mgmt_frame(rx->skb) &&
-			     ieee80211_get_mmie_keyidx(rx->skb) < 0))
+			     ieee80211_get_mmie_keyidx(rx->skb) < 0)) {
+			if (ieee80211_is_deauth(fc))
+				cfg80211_send_unprot_deauth(rx->sdata->dev,
+							    rx->skb->data,
+							    rx->skb->len);
+			else if (ieee80211_is_disassoc(fc))
+				cfg80211_send_unprot_disassoc(rx->sdata->dev,
+							      rx->skb->data,
+							      rx->skb->len);
 			return -EACCES;
+		}
 		/*
 		 * When using MFP, Action frames are not allowed prior to
 		 * having configured keys.
--- wireless-testing.orig/net/wireless/mlme.c	2010-12-16 00:44:31.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-12-16 00:45:18.000000000 +0200
@@ -263,6 +263,28 @@ void cfg80211_send_disassoc(struct net_d
 }
 EXPORT_SYMBOL(cfg80211_send_disassoc);
 
+void cfg80211_send_unprot_deauth(struct net_device *dev, const u8 *buf,
+				 size_t len)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_send_unprot_deauth(rdev, dev, buf, len, GFP_ATOMIC);
+}
+EXPORT_SYMBOL(cfg80211_send_unprot_deauth);
+
+void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
+				   size_t len)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_send_unprot_disassoc(rdev, dev, buf, len, GFP_ATOMIC);
+}
+EXPORT_SYMBOL(cfg80211_send_unprot_disassoc);
+
 static void __cfg80211_auth_remove(struct wireless_dev *wdev, const u8 *addr)
 {
 	int i;
--- wireless-testing.orig/net/wireless/nl80211.c	2010-12-16 00:45:15.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-12-16 00:45:18.000000000 +0200
@@ -5333,6 +5333,22 @@ void nl80211_send_disassoc(struct cfg802
 				NL80211_CMD_DISASSOCIATE, gfp);
 }
 
+void nl80211_send_unprot_deauth(struct cfg80211_registered_device *rdev,
+				struct net_device *netdev, const u8 *buf,
+				size_t len, gfp_t gfp)
+{
+	nl80211_send_mlme_event(rdev, netdev, buf, len,
+				NL80211_CMD_UNPROT_DEAUTHENTICATE, gfp);
+}
+
+void nl80211_send_unprot_disassoc(struct cfg80211_registered_device *rdev,
+				  struct net_device *netdev, const u8 *buf,
+				  size_t len, gfp_t gfp)
+{
+	nl80211_send_mlme_event(rdev, netdev, buf, len,
+				NL80211_CMD_UNPROT_DISASSOCIATE, gfp);
+}
+
 static void nl80211_send_mlme_timeout(struct cfg80211_registered_device *rdev,
 				      struct net_device *netdev, int cmd,
 				      const u8 *addr, gfp_t gfp)
--- wireless-testing.orig/net/wireless/nl80211.h	2010-12-16 00:44:31.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.h	2010-12-16 00:45:18.000000000 +0200
@@ -25,6 +25,12 @@ void nl80211_send_deauth(struct cfg80211
 void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev,
 			   const u8 *buf, size_t len, gfp_t gfp);
+void nl80211_send_unprot_deauth(struct cfg80211_registered_device *rdev,
+				struct net_device *netdev,
+				const u8 *buf, size_t len, gfp_t gfp);
+void nl80211_send_unprot_disassoc(struct cfg80211_registered_device *rdev,
+				  struct net_device *netdev,
+				  const u8 *buf, size_t len, gfp_t gfp);
 void nl80211_send_auth_timeout(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev,
 			       const u8 *addr, gfp_t gfp);
--- wireless-testing.orig/include/net/cfg80211.h	2010-12-16 00:45:15.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-12-16 00:45:18.000000000 +0200
@@ -2318,6 +2318,32 @@ void __cfg80211_send_disassoc(struct net
 	size_t len);
 
 /**
+ * cfg80211_send_unprot_deauth - notification of unprotected deauthentication
+ * @dev: network device
+ * @buf: deauthentication frame (header + body)
+ * @len: length of the frame data
+ *
+ * This function is called whenever a received Deauthentication frame has been
+ * dropped in station mode because of MFP being used but the Deauthentication
+ * frame was not protected. This function may sleep.
+ */
+void cfg80211_send_unprot_deauth(struct net_device *dev, const u8 *buf,
+				 size_t len);
+
+/**
+ * cfg80211_send_unprot_disassoc - notification of unprotected disassociation
+ * @dev: network device
+ * @buf: disassociation frame (header + body)
+ * @len: length of the frame data
+ *
+ * This function is called whenever a received Disassociation frame has been
+ * dropped in station mode because of MFP being used but the Disassociation
+ * frame was not protected. This function may sleep.
+ */
+void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
+				   size_t len);
+
+/**
  * cfg80211_michael_mic_failure - notification of Michael MIC failure (TKIP)
  * @dev: network device
  * @addr: The source MAC address of the frame
 
-- 
Jouni Malinen                                            PGP id EFC895FA
