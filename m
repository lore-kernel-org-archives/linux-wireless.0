Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:36323 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519AbZDVSin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 14:38:43 -0400
Date: Wed, 22 Apr 2009 21:38:25 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Add event for authentication/association timeout
Message-ID: <20090422183825.GA16766@jm.kir.nu> (sfid-20090422_203847_746556_9FE0C2E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SME needs to be notified when the authentication or association
attempt times out and MLME has stopped processing in order to allow
the SME to decide what to do next.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/nl80211.h |   13 ++++++++++--
 include/net/cfg80211.h  |   22 +++++++++++++++++++--
 net/mac80211/mlme.c     |    4 +--
 net/wireless/mlme.c     |   27 ++++++++++++++++++++++++++
 net/wireless/nl80211.c  |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    6 +++++
 6 files changed, 115 insertions(+), 6 deletions(-)

--- uml.orig/include/linux/nl80211.h	2009-04-22 20:46:34.000000000 +0300
+++ uml/include/linux/nl80211.h	2009-04-22 21:11:27.000000000 +0300
@@ -203,8 +203,12 @@
  *	frame, i.e., it was for the local STA and was received in correct
  *	state. This is similar to MLME-AUTHENTICATE.confirm primitive in the
  *	MLME SAP interface (kernel providing MLME, userspace SME). The
- *	included NL80211_ATTR_FRAME attribute contains the management frame
- *	(including both the header and frame body, but not FCS).
+ *	included %NL80211_ATTR_FRAME attribute contains the management frame
+ *	(including both the header and frame body, but not FCS). This event is
+ *	also used to indicate if the authentication attempt timed out. In that
+ *	case the %NL80211_ATTR_FRAME attribute is replaced with a
+ *	%NL80211_ATTR_TIMED_OUT flag (and %NL80211_ATTR_MAC to indicate which
+ *	pending authentication timed out).
  * @NL80211_CMD_ASSOCIATE: association request and notification; like
  *	NL80211_CMD_AUTHENTICATE but for Association and Reassociation
  *	(similar to MLME-ASSOCIATE.request, MLME-REASSOCIATE.request,
@@ -485,6 +489,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_FREQ_FIXED: a flag indicating the IBSS should not try to look
  *	for other networks on different channels
  *
+ * @NL80211_ATTR_TIMED_OUT: a flag indicating than an operation timed out; this
+ *	is used, e.g., with %NL80211_CMD_AUTHENTICATE event
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -585,6 +592,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
 	NL80211_ATTR_WIPHY_RTS_THRESHOLD,
 
+	NL80211_ATTR_TIMED_OUT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- uml.orig/include/net/cfg80211.h	2009-04-22 21:05:39.000000000 +0300
+++ uml/include/net/cfg80211.h	2009-04-22 21:09:40.000000000 +0300
@@ -1473,22 +1473,40 @@ void cfg80211_unlink_bss(struct wiphy *w
  * @len: length of the frame data
  *
  * This function is called whenever an authentication has been processed in
- * station mode.
+ * station mode. The driver is required to call either this function or
+ * cfg80211_send_auth_timeout() to indicate the result of cfg80211_ops::auth()
+ * call.
  */
 void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
+ * cfg80211_send_auth_timeout - notification of timed out authentication
+ * @dev: network device
+ * @addr: The MAC address of the device with which the authentication timed out
+ */
+void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr);
+
+/**
  * cfg80211_send_rx_assoc - notification of processed association
  * @dev: network device
  * @buf: (re)association response frame (header + body)
  * @len: length of the frame data
  *
  * This function is called whenever a (re)association response has been
- * processed in station mode.
+ * processed in station mode. The driver is required to call either this
+ * function or cfg80211_send_assoc_timeout() to indicate the result of
+ * cfg80211_ops::assoc() call.
  */
 void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
+ * cfg80211_send_assoc_timeout - notification of timed out association
+ * @dev: network device
+ * @addr: The MAC address of the device with which the association timed out
+ */
+void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr);
+
+/**
  * cfg80211_send_deauth - notification of processed deauthentication
  * @dev: network device
  * @buf: deauthentication frame (header + body)
--- uml.orig/net/mac80211/mlme.c	2009-04-22 21:04:47.000000000 +0300
+++ uml/net/mac80211/mlme.c	2009-04-22 21:10:57.000000000 +0300
@@ -920,7 +920,7 @@ static void ieee80211_authenticate(struc
 		       " timed out\n",
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_sta_send_apinfo(sdata);
+		cfg80211_send_auth_timeout(sdata->dev, ifmgd->bssid);
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
 				ifmgd->ssid, ifmgd->ssid_len);
@@ -1103,7 +1103,7 @@ static void ieee80211_associate(struct i
 		       " timed out\n",
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_sta_send_apinfo(sdata);
+		cfg80211_send_assoc_timeout(sdata->dev, ifmgd->bssid);
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
 				ifmgd->ssid, ifmgd->ssid_len);
--- uml.orig/net/wireless/mlme.c	2009-04-22 20:54:06.000000000 +0300
+++ uml/net/wireless/mlme.c	2009-04-22 21:05:04.000000000 +0300
@@ -44,6 +44,33 @@ void cfg80211_send_disassoc(struct net_d
 }
 EXPORT_SYMBOL(cfg80211_send_disassoc);
 
+static void cfg80211_wext_disconnected(struct net_device *dev)
+{
+#ifdef CONFIG_WIRELESS_EXT
+	union iwreq_data wrqu;
+	memset(&wrqu, 0, sizeof(wrqu));
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+#endif
+}
+
+void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	nl80211_send_auth_timeout(rdev, dev, addr);
+	cfg80211_wext_disconnected(dev);
+}
+EXPORT_SYMBOL(cfg80211_send_auth_timeout);
+
+void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	nl80211_send_assoc_timeout(rdev, dev, addr);
+	cfg80211_wext_disconnected(dev);
+}
+EXPORT_SYMBOL(cfg80211_send_assoc_timeout);
+
 void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
 				  enum nl80211_key_type key_type, int key_id,
 				  const u8 *tsc)
--- uml.orig/net/wireless/nl80211.c	2009-04-22 20:48:58.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-04-22 21:05:31.000000000 +0300
@@ -121,6 +121,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_AUTH_TYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_REASON_CODE] = { .type = NLA_U16 },
 	[NL80211_ATTR_FREQ_FIXED] = { .type = NLA_FLAG },
+	[NL80211_ATTR_TIMED_OUT] = { .type = NLA_FLAG },
 };
 
 /* IE validation */
@@ -3685,6 +3686,54 @@ void nl80211_send_disassoc(struct cfg802
 				NL80211_CMD_DISASSOCIATE);
 }
 
+void nl80211_send_mlme_timeout(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev, int cmd,
+			       const u8 *addr)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, cmd);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT_FLAG(msg, NL80211_ATTR_TIMED_OUT);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, addr);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_ATOMIC);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+void nl80211_send_auth_timeout(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev, const u8 *addr)
+{
+	nl80211_send_mlme_timeout(rdev, netdev, NL80211_CMD_AUTHENTICATE,
+				  addr);
+}
+
+void nl80211_send_assoc_timeout(struct cfg80211_registered_device *rdev,
+				struct net_device *netdev, const u8 *addr)
+{
+	nl80211_send_mlme_timeout(rdev, netdev, NL80211_CMD_ASSOCIATE, addr);
+}
+
 void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, const u8 *bssid,
 			     gfp_t gfp)
--- uml.orig/net/wireless/nl80211.h	2009-04-22 20:53:32.000000000 +0300
+++ uml/net/wireless/nl80211.h	2009-04-22 20:56:47.000000000 +0300
@@ -23,6 +23,12 @@ extern void nl80211_send_deauth(struct c
 extern void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 				  struct net_device *netdev,
 				  const u8 *buf, size_t len);
+extern void nl80211_send_auth_timeout(struct cfg80211_registered_device *rdev,
+				      struct net_device *netdev,
+				      const u8 *addr);
+extern void nl80211_send_assoc_timeout(struct cfg80211_registered_device *rdev,
+				       struct net_device *netdev,
+				       const u8 *addr);
 extern void
 nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev, const u8 *addr,

-- 
Jouni Malinen                                            PGP id EFC895FA
