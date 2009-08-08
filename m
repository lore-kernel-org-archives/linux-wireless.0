Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:31433 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316AbZHHDuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 23:50:09 -0400
Received: by rv-out-0506.google.com with SMTP id f6so563910rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 20:50:09 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH 3/8] mac80211: Simulate transmission losses on plinks to aid in testing mesh metrics.
Date: Fri,  7 Aug 2009 20:38:26 -0700
Message-Id: <1249702711-32737-4-git-send-email-javier@cozybit.com>
In-Reply-To: <1249702711-32737-3-git-send-email-javier@cozybit.com>
References: <>
 <1249702711-32737-1-git-send-email-javier@cozybit.com>
 <1249702711-32737-2-git-send-email-javier@cozybit.com>
 <1249702711-32737-3-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables us to specify a simulated loss probability per mesh peer link.
Useful to simulate and test different mesh topologies and test different mesh
metrics.

The simulated loss rate setting can be configured as a plink action.  The
intended use is:

iw dev mesh station set <MAC> plink_action loss 25

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h   |    4 +++
 include/net/cfg80211.h    |    4 +++
 net/mac80211/cfg.c        |    6 +++++
 net/mac80211/mesh.c       |    1 +
 net/mac80211/mesh.h       |    1 +
 net/mac80211/mesh_hwmp.c  |    1 +
 net/mac80211/mesh_plink.c |    6 +++++
 net/mac80211/sta_info.h   |    1 +
 net/mac80211/tx.c         |   54 +++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.c    |    9 +++++++
 10 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a8d71ed..3de615b 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -713,6 +713,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_KEYS,
 
 	NL80211_ATTR_PID,
+	NL80211_ATTR_SIM_LOSS,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -1198,6 +1199,8 @@ enum nl80211_mntr_flags {
  *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
+ * @NL80211_MESHCONF_SIM_LOSS_RATE: simulated loss rate at this MP.
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -1215,6 +1218,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
 	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+	NL80211_MESHCONF_SIM_LOSS_RATE,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5756c9..6bc5957 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -265,6 +265,7 @@ enum plink_actions {
 	PLINK_ACTION_INVALID,
 	PLINK_ACTION_OPEN,
 	PLINK_ACTION_BLOCK,
+	PLINK_ACTION_LOSS,
 };
 
 /**
@@ -282,6 +283,7 @@ enum plink_actions {
  *	(bitmask of BIT(NL80211_STA_FLAG_...))
  * @listen_interval: listen interval or -1 for no change
  * @aid: AID or zero for no change
+ * @sim_loss_rate: simulated TX probable loss percentage
  */
 struct station_parameters {
 	u8 *supported_rates;
@@ -292,6 +294,7 @@ struct station_parameters {
 	u8 supported_rates_len;
 	u8 plink_action;
 	struct ieee80211_ht_cap *ht_capa;
+	u8 sim_loss_rate;
 };
 
 /**
@@ -508,6 +511,7 @@ struct mesh_config {
 	u32 dot11MeshHWMPactivePathTimeout;
 	u16 dot11MeshHWMPpreqMinInterval;
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
+	u8 dot11MeshSimLossRate;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5608f6c..8067f66 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -693,6 +693,9 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 		case PLINK_ACTION_BLOCK:
 			mesh_plink_block(sta);
 			break;
+		case PLINK_ACTION_LOSS:
+			mesh_plink_sim_loss(sta, params->sim_loss_rate);
+			break;
 		}
 	}
 }
@@ -1043,6 +1046,9 @@ static int ieee80211_set_mesh_params(struct wiphy *wiphy,
 			   mask))
 		conf->dot11MeshHWMPnetDiameterTraversalTime =
 			nconf->dot11MeshHWMPnetDiameterTraversalTime;
+	if (_chg_mesh_attr(NL80211_MESHCONF_SIM_LOSS_RATE, mask))
+		conf->dot11MeshSimLossRate =
+			nconf->dot11MeshSimLossRate;
 	return 0;
 }
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8c068e2..d9292a9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -653,6 +653,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 		MESH_PATH_REFRESH_TIME;
 	ifmsh->mshcfg.min_discovery_timeout =
 		MESH_MIN_DISCOVERY_TIMEOUT;
+	ifmsh->mshcfg.dot11MeshSimLossRate = 0;
 	ifmsh->accepting_plinks = true;
 	ifmsh->preq_id = 0;
 	ifmsh->dsn = 0;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 6aaf1ec..8e70dae 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -238,6 +238,7 @@ void mesh_plink_broken(struct sta_info *sta);
 void mesh_plink_deactivate(struct sta_info *sta);
 int mesh_plink_open(struct sta_info *sta);
 void mesh_plink_block(struct sta_info *sta);
+void mesh_plink_sim_loss(struct sta_info *sta, u8 rate);
 void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len,
 			 struct ieee80211_rx_status *rx_status);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 1cd1e72..b4309b2 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -272,6 +272,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	}
 
 	last_hop_metric = airtime_link_metric_get(local, sta);
+	printk("XXX: last_hop_metric = %d\n", last_hop_metric);
 	/* Update and check originator routing info */
 	fresh_info = true;
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index cb14253..7c49c95 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -382,6 +382,12 @@ void mesh_plink_block(struct sta_info *sta)
 	spin_unlock_bh(&sta->lock);
 }
 
+void mesh_plink_sim_loss(struct sta_info *sta, u8 rate)
+{
+	spin_lock_bh(&sta->lock);
+	sta->plink_sim_loss = rate;
+	spin_unlock_bh(&sta->lock);
+}
 
 void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_mgmt *mgmt,
 			 size_t len, struct ieee80211_rx_status *rx_status)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ccc3adf..a248a8b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -294,6 +294,7 @@ struct sta_info {
 	bool ignore_plink_timer;
 	bool plink_timer_was_running;
 	enum plink_state plink_state;
+	u8 plink_sim_loss;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
 #endif
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c9be9dc..0df5a96 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -18,6 +18,7 @@
 #include <linux/etherdevice.h>
 #include <linux/bitmap.h>
 #include <linux/rcupdate.h>
+#include <linux/random.h>
 #include <net/net_namespace.h>
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
@@ -39,6 +40,47 @@
 
 /* misc utils */
 
+/* Decide whether we should simulate the loss of a frame based on the simulated
+ * plink loss probability and the frame's destination.  Used for testing.
+ *
+ * Must be invoked with the rcu read lock held.
+ * */
+static int random_tx_loss(struct ieee80211_sub_if_data *sdata, struct
+		ieee80211_hdr *hdr)
+{
+	struct sta_info *sta;
+	u8 r = 0;
+
+	get_random_bytes(&r, sizeof(r));
+
+	list_for_each_entry(sta, &sdata->local->sta_list, list) {
+		if (!memcmp(sta->sta.addr, hdr->addr1, 6))
+			if (r*25 < sta->plink_sim_loss*64)
+				return 1;
+	}
+
+	return 0;
+}
+
+
+static int simulate_tx_loss(struct ieee80211_sub_if_data *sdata,
+		struct ieee80211_hdr *hdr, struct sk_buff *skb)
+{
+	struct ieee80211_hw *hw = &sdata->local->hw;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	ieee80211_tx_info_clear_status(info);
+	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS;
+
+	info->status.rates[0].idx = 0;
+	info->status.rates[0].count = hw->max_rate_tries;
+
+	ieee80211_tx_status_irqsafe(hw, skb);
+
+	/* this will ensure that the frame is not queued in the tx path */
+	return IEEE80211_TX_OK;
+}
+
 static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 				 int next_frag_len)
 {
@@ -1244,6 +1286,7 @@ static void ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct sk_buff *next;
 	unsigned long flags;
 	int ret, retries;
@@ -1278,7 +1321,10 @@ static void ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 
 	retries = 0;
  retry:
-	ret = __ieee80211_tx(local, &tx.skb, tx.sta, txpending);
+	if (ieee80211_vif_is_mesh(&sdata->vif) && random_tx_loss(sdata, hdr))
+		ret = simulate_tx_loss(sdata, hdr, skb);
+	else
+		ret = __ieee80211_tx(local, &tx.skb, tx.sta, txpending);
 	switch (ret) {
 	case IEEE80211_TX_OK:
 		break;
@@ -1857,7 +1903,11 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		hdr = (struct ieee80211_hdr *)skb->data;
 		sta = sta_info_get(local, hdr->addr1);
 
-		ret = __ieee80211_tx(local, &skb, sta, true);
+		if (ieee80211_vif_is_mesh(&sdata->vif) &&
+				random_tx_loss(sdata, hdr))
+			ret = simulate_tx_loss(sdata, hdr, skb);
+		else
+			ret = __ieee80211_tx(local, &skb, sta, true);
 		if (ret != IEEE80211_TX_OK)
 			result = false;
 	}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 667a87d..1dfe8ea 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1878,6 +1878,10 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		params.plink_action =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
 
+	if (info->attrs[NL80211_ATTR_SIM_LOSS])
+		params.sim_loss_rate =
+			nla_get_u8(info->attrs[NL80211_ATTR_SIM_LOSS]);
+
 	rtnl_lock();
 
 	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
@@ -2619,6 +2623,8 @@ static int nl80211_get_mesh_params(struct sk_buff *skb,
 			cur_params.dot11MeshHWMPpreqMinInterval);
 	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 			cur_params.dot11MeshHWMPnetDiameterTraversalTime);
+	NLA_PUT_U8(msg, NL80211_MESHCONF_SIM_LOSS_RATE,
+			cur_params.dot11MeshSimLossRate);
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
 	err = genlmsg_reply(msg, info);
@@ -2661,6 +2667,7 @@ nl80211_meshconf_params_policy[NL80211_MESHCONF_ATTR_MAX+1] __read_mostly = {
 	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_SIM_LOSS_RATE] = { .type = NLA_U8 },
 };
 
 static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
@@ -2729,6 +2736,8 @@ static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
 			dot11MeshHWMPnetDiameterTraversalTime,
 			mask, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 			nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshSimLossRate,
+			mask, NL80211_MESHCONF_SIM_LOSS_RATE, nla_get_u8);
 
 	/* Apply changes */
 	err = rdev->ops->set_mesh_params(&rdev->wiphy, dev, &cfg, mask);
-- 
1.5.4.3

