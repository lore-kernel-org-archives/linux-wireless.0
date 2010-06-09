Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0FIPUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 11:20:35 -0400
Subject: [PATCH] cfg80211/mac80211: allow action frame TX/RX in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 17:20:33 +0200
Message-ID: <1276096833.14580.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When in IBSS mode, currently action frame TX and RX
cannot be used. Allow using it to talk to any peer,
or for public action frames. Also, while at it,
restructure the code in mac80211 to make it easier
to add this for other interface types in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   52 ++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/ieee80211_i.h |    5 ----
 net/mac80211/mlme.c        |   38 --------------------------------
 net/mac80211/rx.c          |    3 --
 net/wireless/mlme.c        |    5 ++--
 net/wireless/nl80211.c     |    6 +++--
 6 files changed, 57 insertions(+), 52 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2010-06-09 13:32:10.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-06-09 17:17:56.000000000 +0200
@@ -846,8 +846,9 @@ int cfg80211_mlme_action(struct cfg80211
 		if (!wdev->current_bss ||
 		    memcmp(wdev->current_bss->pub.bssid, mgmt->bssid,
 			   ETH_ALEN) != 0 ||
-		    memcmp(wdev->current_bss->pub.bssid, mgmt->da,
-			   ETH_ALEN) != 0)
+		    (wdev->iftype == NL80211_IFTYPE_STATION &&
+		     memcmp(wdev->current_bss->pub.bssid, mgmt->da,
+			    ETH_ALEN) != 0))
 			return -ENOTCONN;
 	}
 
--- wireless-testing.orig/net/wireless/nl80211.c	2010-06-09 13:32:10.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-06-09 17:17:56.000000000 +0200
@@ -4653,7 +4653,8 @@ static int nl80211_register_action(struc
 	if (err)
 		goto unlock_rtnl;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4703,7 +4704,8 @@ static int nl80211_action(struct sk_buff
 		goto out;
 	}
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
--- wireless-testing.orig/net/mac80211/cfg.c	2010-06-09 13:32:10.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-06-09 17:17:56.000000000 +0200
@@ -1555,9 +1555,55 @@ static int ieee80211_action(struct wiphy
 			    bool channel_type_valid,
 			    const u8 *buf, size_t len, u64 *cookie)
 {
-	return ieee80211_mgd_action(IEEE80211_DEV_TO_SUB_IF(dev), chan,
-				    channel_type, channel_type_valid,
-				    buf, len, cookie);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct sta_info *sta;
+	const struct ieee80211_mgmt *mgmt = (void *)buf;
+	u32 flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
+		    IEEE80211_TX_CTL_REQ_TX_STATUS;
+
+	/* Check that we are on the requested channel for transmission */
+	if (chan != local->tmp_channel &&
+	    chan != local->oper_channel)
+		return -EBUSY;
+	if (channel_type_valid &&
+	    (channel_type != local->tmp_channel_type &&
+	     channel_type != local->_oper_channel_type))
+		return -EBUSY;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_ADHOC:
+		if (mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)
+			break;
+		rcu_read_lock();
+		sta = sta_info_get(sdata, mgmt->da);
+		rcu_read_unlock();
+		if (!sta)
+			return -ENOLINK;
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (!(sdata->u.mgd.flags & IEEE80211_STA_MFP_ENABLED))
+			flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + len);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	memcpy(skb_put(skb, len), buf, len);
+
+	IEEE80211_SKB_CB(skb)->flags = flags;
+
+	skb->dev = sdata->dev;
+	ieee80211_tx_skb(sdata, skb);
+
+	*cookie = (unsigned long) skb;
+	return 0;
 }
 
 struct cfg80211_ops mac80211_config_ops = {
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-09 17:17:20.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-09 17:18:05.000000000 +0200
@@ -986,11 +986,6 @@ int ieee80211_mgd_deauth(struct ieee8021
 int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_disassoc_request *req,
 			   void *cookie);
-int ieee80211_mgd_action(struct ieee80211_sub_if_data *sdata,
-			 struct ieee80211_channel *chan,
-			 enum nl80211_channel_type channel_type,
-			 bool channel_type_valid,
-			 const u8 *buf, size_t len, u64 *cookie);
 ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 					  struct sk_buff *skb);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
--- wireless-testing.orig/net/mac80211/mlme.c	2010-06-09 17:17:20.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-06-09 17:17:56.000000000 +0200
@@ -2390,44 +2390,6 @@ int ieee80211_mgd_disassoc(struct ieee80
 	return 0;
 }
 
-int ieee80211_mgd_action(struct ieee80211_sub_if_data *sdata,
-			 struct ieee80211_channel *chan,
-			 enum nl80211_channel_type channel_type,
-			 bool channel_type_valid,
-			 const u8 *buf, size_t len, u64 *cookie)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct sk_buff *skb;
-
-	/* Check that we are on the requested channel for transmission */
-	if (chan != local->tmp_channel &&
-	    chan != local->oper_channel)
-		return -EBUSY;
-	if (channel_type_valid &&
-	    (channel_type != local->tmp_channel_type &&
-	     channel_type != local->_oper_channel_type))
-		return -EBUSY;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + len);
-	if (!skb)
-		return -ENOMEM;
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	memcpy(skb_put(skb, len), buf, len);
-
-	if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
-		IEEE80211_SKB_CB(skb)->flags |=
-			IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_NL80211_FRAME_TX |
-		IEEE80211_TX_CTL_REQ_TX_STATUS;
-	skb->dev = sdata->dev;
-	ieee80211_tx_skb(sdata, skb);
-
-	*cookie = (unsigned long) skb;
-	return 0;
-}
-
 void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       enum nl80211_cqm_rssi_threshold_event rssi_event,
 			       gfp_t gfp)
--- wireless-testing.orig/net/mac80211/rx.c	2010-06-09 17:17:18.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-06-09 17:17:56.000000000 +0200
@@ -2045,8 +2045,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 	 */
 	status = IEEE80211_SKB_RXCB(rx->skb);
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    cfg80211_rx_action(rx->sdata->dev, status->freq,
+	if (cfg80211_rx_action(rx->sdata->dev, status->freq,
 			       rx->skb->data, rx->skb->len,
 			       GFP_ATOMIC))
 		goto handled;


