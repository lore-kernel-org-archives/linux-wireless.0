Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1JUOZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:25:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RHG2M-0008VC-06
	for linux-wireless@vger.kernel.org; Fri, 21 Oct 2011 16:25:30 +0200
Message-Id: <20111021142429.002962879@sipsolutions.net> (sfid-20111021_162538_302866_0EACF483)
Date: Fri, 21 Oct 2011 16:23:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 07/12] mac80211: support client probe
References: <20111021142322.229128720@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Support probing clients with null data frames
in AP mode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: update to use cfg80211_probe_status

 net/mac80211/cfg.c    |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/status.c |   45 +++++++++++++++++++--------------
 2 files changed, 95 insertions(+), 18 deletions(-)

--- a/net/mac80211/cfg.c	2011-10-21 12:07:38.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-10-21 12:07:42.000000000 +0200
@@ -2507,6 +2507,73 @@ static int ieee80211_tdls_oper(struct wi
 	return 0;
 }
 
+static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
+				  const u8 *peer, u64 *cookie)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_qos_hdr *nullfunc;
+	struct sk_buff *skb;
+	int size = sizeof(*nullfunc);
+	__le16 fc;
+	bool qos;
+	struct ieee80211_tx_info *info;
+	struct sta_info *sta;
+
+	rcu_read_lock();
+	sta = sta_info_get(sdata, peer);
+	if (sta)
+		qos = test_sta_flag(sta, WLAN_STA_WME);
+	rcu_read_unlock();
+
+	if (!sta)
+		return -ENOLINK;
+
+	if (qos) {
+		fc = cpu_to_le16(IEEE80211_FTYPE_DATA |
+				 IEEE80211_STYPE_QOS_NULLFUNC |
+				 IEEE80211_FCTL_FROMDS);
+	} else {
+		size -= 2;
+		fc = cpu_to_le16(IEEE80211_FTYPE_DATA |
+				 IEEE80211_STYPE_NULLFUNC |
+				 IEEE80211_FCTL_FROMDS);
+	}
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + size);
+	if (!skb)
+		return -ENOMEM;
+
+	skb->dev = dev;
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	nullfunc = (void *) skb_put(skb, size);
+	nullfunc->frame_control = fc;
+	nullfunc->duration_id = 0;
+	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
+	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, sdata->vif.addr, ETH_ALEN);
+	nullfunc->seq_ctrl = 0;
+
+	info = IEEE80211_SKB_CB(skb);
+
+	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
+		       IEEE80211_TX_INTFL_NL80211_FRAME_TX;
+
+	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
+	skb->priority = 7;
+	if (qos)
+		nullfunc->qos_ctrl = cpu_to_le16(7);
+
+	local_bh_disable();
+	ieee80211_xmit(sdata, skb);
+	local_bh_enable();
+
+	*cookie = (unsigned long) skb;
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -2572,4 +2639,5 @@ struct cfg80211_ops mac80211_config_ops
 	.set_rekey_data = ieee80211_set_rekey_data,
 	.tdls_oper = ieee80211_tdls_oper,
 	.tdls_mgmt = ieee80211_tdls_mgmt,
+	.probe_client = ieee80211_probe_client,
 };
--- a/net/mac80211/status.c	2011-10-21 12:07:38.000000000 +0200
+++ b/net/mac80211/status.c	2011-10-21 12:07:42.000000000 +0200
@@ -516,27 +516,36 @@ void ieee80211_tx_status(struct ieee8021
 	}
 
 	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
-		struct ieee80211_work *wk;
 		u64 cookie = (unsigned long)skb;
 
-		rcu_read_lock();
-		list_for_each_entry_rcu(wk, &local->work_list, list) {
-			if (wk->type != IEEE80211_WORK_OFFCHANNEL_TX)
-				continue;
-			if (wk->offchan_tx.frame != skb)
-				continue;
-			wk->offchan_tx.status = true;
-			break;
-		}
-		rcu_read_unlock();
-		if (local->hw_roc_skb_for_status == skb) {
-			cookie = local->hw_roc_cookie ^ 2;
-			local->hw_roc_skb_for_status = NULL;
-		}
+		if (ieee80211_is_nullfunc(hdr->frame_control) ||
+		    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+		    	bool acked = info->flags & IEEE80211_TX_STAT_ACK;
+			cfg80211_probe_status(skb->dev, hdr->addr1,
+					      cookie, acked, GFP_ATOMIC);
+		} else {
+			struct ieee80211_work *wk;
 
-		cfg80211_mgmt_tx_status(
-			skb->dev, cookie, skb->data, skb->len,
-			!!(info->flags & IEEE80211_TX_STAT_ACK), GFP_ATOMIC);
+			rcu_read_lock();
+			list_for_each_entry_rcu(wk, &local->work_list, list) {
+				if (wk->type != IEEE80211_WORK_OFFCHANNEL_TX)
+					continue;
+				if (wk->offchan_tx.frame != skb)
+					continue;
+				wk->offchan_tx.status = true;
+				break;
+			}
+			rcu_read_unlock();
+			if (local->hw_roc_skb_for_status == skb) {
+				cookie = local->hw_roc_cookie ^ 2;
+				local->hw_roc_skb_for_status = NULL;
+			}
+
+			cfg80211_mgmt_tx_status(
+				skb->dev, cookie, skb->data, skb->len,
+				!!(info->flags & IEEE80211_TX_STAT_ACK),
+				GFP_ATOMIC);
+		}
 	}
 
 	/* this was a transmitted frame, but now we want to reuse it */


