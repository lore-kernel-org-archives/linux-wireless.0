Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53649 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717AbZC0SyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 14:54:07 -0400
Date: Fri, 27 Mar 2009 20:53:56 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Generate deauth/disassoc event for locally
	generated frames
Message-ID: <20090327185356.GB11871@jm.kir.nu> (sfid-20090327_195410_784053_400A9E13)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, nl80211 mlme events were generated only for received
deauthentication and disassociation frames. We need to do the same for
locally generated ones in order to let applications know that we
disconnected (e.g., when AP does not reply to a probe). Rename the
nl80211 and cfg80211 functions (s/rx_//) to make it clearer that they
are used for both received and locally generated frames.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 include/net/cfg80211.h |   16 ++++++++--------
 net/mac80211/mlme.c    |    8 ++++++--
 net/wireless/mlme.c    |   13 ++++++-------
 net/wireless/nl80211.c |   11 +++++------
 net/wireless/nl80211.h |   12 ++++++------
 5 files changed, 31 insertions(+), 29 deletions(-)

--- uml.orig/include/net/cfg80211.h	2009-03-27 20:38:24.000000000 +0200
+++ uml/include/net/cfg80211.h	2009-03-27 20:39:22.000000000 +0200
@@ -918,28 +918,28 @@ void cfg80211_send_rx_auth(struct net_de
 void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
- * cfg80211_send_rx_deauth - notification of processed deauthentication
+ * cfg80211_send_deauth - notification of processed deauthentication
  * @dev: network device
  * @buf: deauthentication frame (header + body)
  * @len: length of the frame data
  *
  * This function is called whenever deauthentication has been processed in
- * station mode.
+ * station mode. This includes both received deauthentication frames and
+ * locally generated ones.
  */
-void cfg80211_send_rx_deauth(struct net_device *dev, const u8 *buf,
-			     size_t len);
+void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
- * cfg80211_send_rx_disassoc - notification of processed disassociation
+ * cfg80211_send_disassoc - notification of processed disassociation
  * @dev: network device
  * @buf: disassociation response frame (header + body)
  * @len: length of the frame data
  *
  * This function is called whenever disassociation has been processed in
- * station mode.
+ * station mode. This includes both received disassociation frames and locally
+ * generated ones.
  */
-void cfg80211_send_rx_disassoc(struct net_device *dev, const u8 *buf,
-			       size_t len);
+void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
  * cfg80211_hold_bss - exclude bss from expiration
--- uml.orig/net/wireless/mlme.c	2009-03-27 20:39:44.000000000 +0200
+++ uml/net/wireless/mlme.c	2009-03-27 20:40:16.000000000 +0200
@@ -28,19 +28,18 @@ void cfg80211_send_rx_assoc(struct net_d
 }
 EXPORT_SYMBOL(cfg80211_send_rx_assoc);
 
-void cfg80211_send_rx_deauth(struct net_device *dev, const u8 *buf, size_t len)
+void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	nl80211_send_rx_deauth(rdev, dev, buf, len);
+	nl80211_send_deauth(rdev, dev, buf, len);
 }
-EXPORT_SYMBOL(cfg80211_send_rx_deauth);
+EXPORT_SYMBOL(cfg80211_send_deauth);
 
-void cfg80211_send_rx_disassoc(struct net_device *dev, const u8 *buf,
-			       size_t len)
+void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	nl80211_send_rx_disassoc(rdev, dev, buf, len);
+	nl80211_send_disassoc(rdev, dev, buf, len);
 }
-EXPORT_SYMBOL(cfg80211_send_rx_disassoc);
+EXPORT_SYMBOL(cfg80211_send_disassoc);
--- uml.orig/net/wireless/nl80211.c	2009-03-27 20:40:34.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-03-27 20:41:04.000000000 +0200
@@ -3423,17 +3423,16 @@ void nl80211_send_rx_assoc(struct cfg802
 	nl80211_send_mlme_event(rdev, netdev, buf, len, NL80211_CMD_ASSOCIATE);
 }
 
-void nl80211_send_rx_deauth(struct cfg80211_registered_device *rdev,
-			    struct net_device *netdev, const u8 *buf,
-			    size_t len)
+void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
+			 struct net_device *netdev, const u8 *buf, size_t len)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
 				NL80211_CMD_DEAUTHENTICATE);
 }
 
-void nl80211_send_rx_disassoc(struct cfg80211_registered_device *rdev,
-			      struct net_device *netdev, const u8 *buf,
-			      size_t len)
+void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
+			   struct net_device *netdev, const u8 *buf,
+			   size_t len)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
 				NL80211_CMD_DISASSOCIATE);
--- uml.orig/net/wireless/nl80211.h	2009-03-27 20:40:36.000000000 +0200
+++ uml/net/wireless/nl80211.h	2009-03-27 20:40:49.000000000 +0200
@@ -17,11 +17,11 @@ extern void nl80211_send_rx_auth(struct 
 extern void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
 				  struct net_device *netdev,
 				  const u8 *buf, size_t len);
-extern void nl80211_send_rx_deauth(struct cfg80211_registered_device *rdev,
-				   struct net_device *netdev,
-				   const u8 *buf, size_t len);
-extern void nl80211_send_rx_disassoc(struct cfg80211_registered_device *rdev,
-				     struct net_device *netdev,
-				     const u8 *buf, size_t len);
+extern void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
+				struct net_device *netdev,
+				const u8 *buf, size_t len);
+extern void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
+				  struct net_device *netdev,
+				  const u8 *buf, size_t len);
 
 #endif /* __NET_WIRELESS_NL80211_H */
--- uml.orig/net/mac80211/mlme.c	2009-03-27 20:41:35.000000000 +0200
+++ uml/net/mac80211/mlme.c	2009-03-27 20:44:57.000000000 +0200
@@ -326,6 +326,10 @@ static void ieee80211_send_deauth_disass
 	/* u.deauth.reason_code == u.disassoc.reason_code */
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
+	if (stype == IEEE80211_STYPE_DEAUTH)
+		cfg80211_send_deauth(sdata->dev, (u8 *) mgmt, skb->len);
+	else
+		cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt, skb->len);
 	ieee80211_tx_skb(sdata, skb, ifmgd->flags & IEEE80211_STA_MFP_ENABLED);
 }
 
@@ -1176,7 +1180,7 @@ static void ieee80211_rx_mgmt_deauth(str
 
 	ieee80211_set_disassoc(sdata, true, false, 0);
 	ifmgd->flags &= ~IEEE80211_STA_AUTHENTICATED;
-	cfg80211_send_rx_deauth(sdata->dev, (u8 *) mgmt, len);
+	cfg80211_send_deauth(sdata->dev, (u8 *) mgmt, len);
 }
 
 
@@ -1207,7 +1211,7 @@ static void ieee80211_rx_mgmt_disassoc(s
 	}
 
 	ieee80211_set_disassoc(sdata, false, false, reason_code);
-	cfg80211_send_rx_disassoc(sdata->dev, (u8 *) mgmt, len);
+	cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt, len);
 }
 
 

-- 
Jouni Malinen                                            PGP id EFC895FA
