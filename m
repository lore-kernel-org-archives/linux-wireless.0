Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35982 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbZGATfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:35:47 -0400
Message-Id: <20090701193419.439633223@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/20 v4] cfg80211: use proper allocation flags
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of hardcoding GFP_ATOMIC everywhere, add a
new function parameter that gets the flags from the
caller. Obviously then I need to update all callers
(all of them in mac80211), and it turns out that now
it's ok to use GFP_KERNEL in almost all places.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |   21 +++++++++++++------
 net/mac80211/event.c       |    5 ++--
 net/mac80211/ieee80211_i.h |    3 +-
 net/mac80211/mlme.c        |   30 +++++++++++++++++-----------
 net/mac80211/rx.c          |    3 +-
 net/mac80211/wpa.c         |    3 +-
 net/wireless/mlme.c        |   30 ++++++++++++++--------------
 net/wireless/nl80211.c     |   48 +++++++++++++++++++++++++--------------------
 net/wireless/nl80211.h     |   14 ++++++-------
 9 files changed, 91 insertions(+), 66 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-07-01 08:55:07.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-01 09:01:15.000000000 +0200
@@ -1572,64 +1572,70 @@ void cfg80211_unlink_bss(struct wiphy *w
  * @dev: network device
  * @buf: authentication frame (header + body)
  * @len: length of the frame data
+ * @gfp: allocation flags
  *
  * This function is called whenever an authentication has been processed in
  * station mode. The driver is required to call either this function or
  * cfg80211_send_auth_timeout() to indicate the result of cfg80211_ops::auth()
  * call.
  */
-void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
+void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp);
 
 /**
  * cfg80211_send_auth_timeout - notification of timed out authentication
  * @dev: network device
  * @addr: The MAC address of the device with which the authentication timed out
+ * @gfp: allocation flags
  */
-void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr);
+void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr, gfp_t gfp);
 
 /**
  * cfg80211_send_rx_assoc - notification of processed association
  * @dev: network device
  * @buf: (re)association response frame (header + body)
  * @len: length of the frame data
+ * @gfp: allocation flags
  *
  * This function is called whenever a (re)association response has been
  * processed in station mode. The driver is required to call either this
  * function or cfg80211_send_assoc_timeout() to indicate the result of
  * cfg80211_ops::assoc() call.
  */
-void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len);
+void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp);
 
 /**
  * cfg80211_send_assoc_timeout - notification of timed out association
  * @dev: network device
  * @addr: The MAC address of the device with which the association timed out
+ * @gfp: allocation flags
  */
-void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr);
+void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr, gfp_t gfp);
 
 /**
  * cfg80211_send_deauth - notification of processed deauthentication
  * @dev: network device
  * @buf: deauthentication frame (header + body)
  * @len: length of the frame data
+ * @gfp: allocation flags
  *
  * This function is called whenever deauthentication has been processed in
  * station mode. This includes both received deauthentication frames and
  * locally generated ones.
  */
-void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len);
+void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp);
 
 /**
  * cfg80211_send_disassoc - notification of processed disassociation
  * @dev: network device
  * @buf: disassociation response frame (header + body)
  * @len: length of the frame data
+ * @gfp: allocation flags
  *
  * This function is called whenever disassociation has been processed in
  * station mode. This includes both received disassociation frames and locally
  * generated ones.
  */
-void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len);
+void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp);
 
 /**
  * cfg80211_hold_bss - exclude bss from expiration
@@ -1655,6 +1661,7 @@ void cfg80211_unhold_bss(struct cfg80211
  * @key_type: The key type that the received frame used
  * @key_id: Key identifier (0..3)
  * @tsc: The TSC value of the frame that generated the MIC failure (6 octets)
+ * @gfp: allocation flags
  *
  * This function is called whenever the local MAC detects a MIC failure in a
  * received frame. This matches with MLME-MICHAELMICFAILURE.indication()
@@ -1662,7 +1669,7 @@ void cfg80211_unhold_bss(struct cfg80211
  */
 void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
 				  enum nl80211_key_type key_type, int key_id,
-				  const u8 *tsc);
+				  const u8 *tsc, gfp_t gfp);
 
 /**
  * cfg80211_ibss_joined - notify cfg80211 that device joined an IBSS
--- wireless-testing.orig/net/wireless/mlme.c	2009-07-01 08:55:07.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-01 09:01:15.000000000 +0200
@@ -12,35 +12,35 @@
 #include "core.h"
 #include "nl80211.h"
 
-void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
+void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	nl80211_send_rx_auth(rdev, dev, buf, len);
+	nl80211_send_rx_auth(rdev, dev, buf, len, gfp);
 }
 EXPORT_SYMBOL(cfg80211_send_rx_auth);
 
-void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len)
+void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	nl80211_send_rx_assoc(rdev, dev, buf, len);
+	nl80211_send_rx_assoc(rdev, dev, buf, len, gfp);
 }
 EXPORT_SYMBOL(cfg80211_send_rx_assoc);
 
-void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len)
+void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	nl80211_send_deauth(rdev, dev, buf, len);
+	nl80211_send_deauth(rdev, dev, buf, len, gfp);
 }
 EXPORT_SYMBOL(cfg80211_send_deauth);
 
-void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len)
+void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	nl80211_send_disassoc(rdev, dev, buf, len);
+	nl80211_send_disassoc(rdev, dev, buf, len, gfp);
 }
 EXPORT_SYMBOL(cfg80211_send_disassoc);
 
@@ -53,33 +53,33 @@ static void cfg80211_wext_disconnected(s
 #endif
 }
 
-void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
+void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	nl80211_send_auth_timeout(rdev, dev, addr);
+	nl80211_send_auth_timeout(rdev, dev, addr, gfp);
 	cfg80211_wext_disconnected(dev);
 }
 EXPORT_SYMBOL(cfg80211_send_auth_timeout);
 
-void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
+void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	nl80211_send_assoc_timeout(rdev, dev, addr);
+	nl80211_send_assoc_timeout(rdev, dev, addr, gfp);
 	cfg80211_wext_disconnected(dev);
 }
 EXPORT_SYMBOL(cfg80211_send_assoc_timeout);
 
 void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
 				  enum nl80211_key_type key_type, int key_id,
-				  const u8 *tsc)
+				  const u8 *tsc, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 #ifdef CONFIG_WIRELESS_EXT
 	union iwreq_data wrqu;
-	char *buf = kmalloc(128, GFP_ATOMIC);
+	char *buf = kmalloc(128, gfp);
 
 	if (buf) {
 		sprintf(buf, "MLME-MICHAELMICFAILURE.indication("
@@ -93,6 +93,6 @@ void cfg80211_michael_mic_failure(struct
 	}
 #endif
 
-	nl80211_michael_mic_failure(rdev, dev, addr, key_type, key_id, tsc);
+	nl80211_michael_mic_failure(rdev, dev, addr, key_type, key_id, tsc, gfp);
 }
 EXPORT_SYMBOL(cfg80211_michael_mic_failure);
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-01 08:56:30.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-01 09:01:15.000000000 +0200
@@ -3831,12 +3831,12 @@ nla_put_failure:
 static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
 				    struct net_device *netdev,
 				    const u8 *buf, size_t len,
-				    enum nl80211_commands cmd)
+				    enum nl80211_commands cmd, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
 	if (!msg)
 		return;
 
@@ -3855,7 +3855,7 @@ static void nl80211_send_mlme_event(stru
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_ATOMIC);
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
@@ -3864,42 +3864,45 @@ static void nl80211_send_mlme_event(stru
 }
 
 void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
-			  struct net_device *netdev, const u8 *buf, size_t len)
+			  struct net_device *netdev, const u8 *buf,
+			  size_t len, gfp_t gfp)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_AUTHENTICATE);
+				NL80211_CMD_AUTHENTICATE, gfp);
 }
 
 void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev, const u8 *buf,
-			   size_t len)
+			   size_t len, gfp_t gfp)
 {
-	nl80211_send_mlme_event(rdev, netdev, buf, len, NL80211_CMD_ASSOCIATE);
+	nl80211_send_mlme_event(rdev, netdev, buf, len,
+				NL80211_CMD_ASSOCIATE, gfp);
 }
 
 void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
-			 struct net_device *netdev, const u8 *buf, size_t len)
+			 struct net_device *netdev, const u8 *buf,
+			 size_t len, gfp_t gfp)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_DEAUTHENTICATE);
+				NL80211_CMD_DEAUTHENTICATE, gfp);
 }
 
 void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev, const u8 *buf,
-			   size_t len)
+			   size_t len, gfp_t gfp)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_DISASSOCIATE);
+				NL80211_CMD_DISASSOCIATE, gfp);
 }
 
 static void nl80211_send_mlme_timeout(struct cfg80211_registered_device *rdev,
 				      struct net_device *netdev, int cmd,
-				      const u8 *addr)
+				      const u8 *addr, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
 	if (!msg)
 		return;
 
@@ -3919,7 +3922,7 @@ static void nl80211_send_mlme_timeout(st
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_ATOMIC);
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
@@ -3928,16 +3931,19 @@ static void nl80211_send_mlme_timeout(st
 }
 
 void nl80211_send_auth_timeout(struct cfg80211_registered_device *rdev,
-			       struct net_device *netdev, const u8 *addr)
+			       struct net_device *netdev, const u8 *addr,
+			       gfp_t gfp)
 {
 	nl80211_send_mlme_timeout(rdev, netdev, NL80211_CMD_AUTHENTICATE,
-				  addr);
+				  addr, gfp);
 }
 
 void nl80211_send_assoc_timeout(struct cfg80211_registered_device *rdev,
-				struct net_device *netdev, const u8 *addr)
+				struct net_device *netdev, const u8 *addr,
+				gfp_t gfp)
 {
-	nl80211_send_mlme_timeout(rdev, netdev, NL80211_CMD_ASSOCIATE, addr);
+	nl80211_send_mlme_timeout(rdev, netdev, NL80211_CMD_ASSOCIATE,
+				  addr, gfp);
 }
 
 void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
@@ -3977,12 +3983,12 @@ void nl80211_send_ibss_bssid(struct cfg8
 void nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev, const u8 *addr,
 				 enum nl80211_key_type key_type, int key_id,
-				 const u8 *tsc)
+				 const u8 *tsc, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
 	if (!msg)
 		return;
 
@@ -4006,7 +4012,7 @@ void nl80211_michael_mic_failure(struct 
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_ATOMIC);
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
--- wireless-testing.orig/net/wireless/nl80211.h	2009-07-01 08:59:44.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.h	2009-07-01 09:01:15.000000000 +0200
@@ -15,27 +15,27 @@ void nl80211_send_scan_aborted(struct cf
 void nl80211_send_reg_change_event(struct regulatory_request *request);
 void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 			  struct net_device *netdev,
-			  const u8 *buf, size_t len);
+			  const u8 *buf, size_t len, gfp_t gfp);
 void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev,
-			   const u8 *buf, size_t len);
+			   const u8 *buf, size_t len, gfp_t gfp);
 void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
 			 struct net_device *netdev,
-			 const u8 *buf, size_t len);
+			 const u8 *buf, size_t len, gfp_t gfp);
 void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev,
-			   const u8 *buf, size_t len);
+			   const u8 *buf, size_t len, gfp_t gfp);
 void nl80211_send_auth_timeout(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev,
-			       const u8 *addr);
+			       const u8 *addr, gfp_t gfp);
 void nl80211_send_assoc_timeout(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev,
-				const u8 *addr);
+				const u8 *addr, gfp_t gfp);
 void
 nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev, const u8 *addr,
 			    enum nl80211_key_type key_type,
-			    int key_id, const u8 *tsc);
+			    int key_id, const u8 *tsc, gfp_t gfp);
 
 void
 nl80211_send_beacon_hint_event(struct wiphy *wiphy,
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-01 08:55:07.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-01 09:01:15.000000000 +0200
@@ -419,9 +419,11 @@ static void ieee80211_send_deauth_disass
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
 	if (stype == IEEE80211_STYPE_DEAUTH)
-		cfg80211_send_deauth(sdata->dev, (u8 *) mgmt, skb->len);
+		cfg80211_send_deauth(sdata->dev, (u8 *) mgmt, skb->len,
+				     GFP_KERNEL);
 	else
-		cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt, skb->len);
+		cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt, skb->len,
+				       GFP_KERNEL);
 	ieee80211_tx_skb(sdata, skb, ifmgd->flags & IEEE80211_STA_MFP_ENABLED);
 }
 
@@ -1006,7 +1008,8 @@ static void ieee80211_direct_probe(struc
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
 		ieee80211_recalc_idle(local);
-		cfg80211_send_auth_timeout(sdata->dev, ifmgd->bssid);
+		cfg80211_send_auth_timeout(sdata->dev, ifmgd->bssid,
+					   GFP_KERNEL);
 
 		/*
 		 * Most likely AP is not in the range so remove the
@@ -1055,7 +1058,8 @@ static void ieee80211_authenticate(struc
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
 		ieee80211_recalc_idle(local);
-		cfg80211_send_auth_timeout(sdata->dev, ifmgd->bssid);
+		cfg80211_send_auth_timeout(sdata->dev, ifmgd->bssid,
+					   GFP_KERNEL);
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
 				ifmgd->ssid, ifmgd->ssid_len);
@@ -1243,7 +1247,8 @@ static void ieee80211_associate(struct i
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
 		ieee80211_recalc_idle(local);
-		cfg80211_send_assoc_timeout(sdata->dev, ifmgd->bssid);
+		cfg80211_send_assoc_timeout(sdata->dev, ifmgd->bssid,
+					    GFP_KERNEL);
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
 				ifmgd->ssid, ifmgd->ssid_len);
@@ -1517,12 +1522,14 @@ static void ieee80211_rx_mgmt_auth(struc
 	case WLAN_AUTH_LEAP:
 	case WLAN_AUTH_FT:
 		ieee80211_auth_completed(sdata);
-		cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len);
+		cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len,
+				      GFP_KERNEL);
 		break;
 	case WLAN_AUTH_SHARED_KEY:
 		if (ifmgd->auth_transaction == 4) {
 			ieee80211_auth_completed(sdata);
-			cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len);
+			cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len,
+					      GFP_KERNEL);
 		} else
 			ieee80211_auth_challenge(sdata, mgmt, len);
 		break;
@@ -1560,7 +1567,7 @@ static void ieee80211_rx_mgmt_deauth(str
 
 	ieee80211_set_disassoc(sdata, true, false, 0);
 	ifmgd->flags &= ~IEEE80211_STA_AUTHENTICATED;
-	cfg80211_send_deauth(sdata->dev, (u8 *) mgmt, len);
+	cfg80211_send_deauth(sdata->dev, (u8 *) mgmt, len, GFP_KERNEL);
 }
 
 
@@ -1591,7 +1598,7 @@ static void ieee80211_rx_mgmt_disassoc(s
 	}
 
 	ieee80211_set_disassoc(sdata, false, false, reason_code);
-	cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt, len);
+	cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt, len, GFP_KERNEL);
 }
 
 
@@ -1660,7 +1667,8 @@ static void ieee80211_rx_mgmt_assoc_resp
 		 * association next time. This works around some broken APs
 		 * which do not correctly reject reassociation requests. */
 		ifmgd->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
-		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len);
+		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len,
+				       GFP_KERNEL);
 		if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
 			/* Wait for SME to decide what to do next */
 			ifmgd->state = IEEE80211_STA_MLME_DISABLED;
@@ -1823,7 +1831,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	ifmgd->last_beacon = jiffies;
 
 	ieee80211_associated(sdata);
-	cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len);
+	cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len, GFP_KERNEL);
 }
 
 
--- wireless-testing.orig/net/mac80211/event.c	2009-07-01 08:55:07.000000000 +0200
+++ wireless-testing/net/mac80211/event.c	2009-07-01 09:01:15.000000000 +0200
@@ -16,11 +16,12 @@
  * driver or is still in the frame), it should provide that information.
  */
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
-				     struct ieee80211_hdr *hdr, const u8 *tsc)
+				     struct ieee80211_hdr *hdr, const u8 *tsc,
+				     gfp_t gfp)
 {
 	cfg80211_michael_mic_failure(sdata->dev, hdr->addr2,
 				     (hdr->addr1[0] & 0x01) ?
 				     NL80211_KEYTYPE_GROUP :
 				     NL80211_KEYTYPE_PAIRWISE,
-				     keyidx, tsc);
+				     keyidx, tsc, gfp);
 }
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-07-01 08:55:07.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-07-01 09:01:15.000000000 +0200
@@ -1085,7 +1085,8 @@ u8 *ieee80211_get_bssid(struct ieee80211
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
-				     struct ieee80211_hdr *hdr, const u8 *tsc);
+				     struct ieee80211_hdr *hdr, const u8 *tsc,
+				     gfp_t gfp);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
 void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		      int encrypt);
--- wireless-testing.orig/net/mac80211/rx.c	2009-07-01 08:55:07.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-07-01 09:01:15.000000000 +0200
@@ -1868,7 +1868,8 @@ static void ieee80211_rx_michael_mic_rep
 	    !ieee80211_is_auth(hdr->frame_control))
 		goto ignore;
 
-	mac80211_ev_michael_mic_failure(rx->sdata, keyidx, hdr, NULL);
+	mac80211_ev_michael_mic_failure(rx->sdata, keyidx, hdr, NULL,
+					GFP_ATOMIC);
  ignore:
 	dev_kfree_skb(rx->skb);
 	rx->skb = NULL;
--- wireless-testing.orig/net/mac80211/wpa.c	2009-07-01 08:55:07.000000000 +0200
+++ wireless-testing/net/mac80211/wpa.c	2009-07-01 09:01:15.000000000 +0200
@@ -122,7 +122,8 @@ ieee80211_rx_h_michael_mic_verify(struct
 			return RX_DROP_UNUSABLE;
 
 		mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
-						(void *) skb->data, NULL);
+						(void *) skb->data, NULL,
+						GFP_ATOMIC);
 		return RX_DROP_UNUSABLE;
 	}
 

-- 

