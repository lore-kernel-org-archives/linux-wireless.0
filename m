Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYIRQPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 12:15:00 -0400
Subject: [PATCH] mac80211: clean up rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 18:14:18 +0200
Message-Id: <1221754458.9262.84.camel@johannes.berg> (sfid-20080918_181510_532376_1700ADBE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Long awaited, hard work. This patch totally cleans up the rate control
API to remove the requirement to include internal headers outside of
net/mac80211/.

There's one internal use in the PID algorithm left for mesh networking,
we'll have to figure out a way to clean that one up and decide how to
do the peer link evaluation, possibly independent of the rate control
algorithm or via new API.

Additionally, ath9k is left using the cross-inclusion hack for now, we
will add new API where necessary to make this work properly, but right
now I'm not expert enough to do it. It's still off better than before.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Quite some code removal too.

I have tested on b43 and ath9k (but without aggregation), but not on
iwlwifi, as iwlwifi fails to work on my machine alltogether with a
BUG_ON in an interrupt.

I have also been using this daily since I first posted an initial
version a week ago and feel it is, although quite a change, as safe
as I can personally make it without getting feedback from others.

 drivers/net/wireless/ath9k/rc.c             |   98 ++++++---------
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |  182 ++++++----------------------
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h  |    9 -
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    4 
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |  146 +++++++++-------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 -
 include/net/mac80211.h                      |   68 ++++++++++
 net/mac80211/cfg.c                          |    2 
 net/mac80211/ieee80211_i.h                  |    2 
 net/mac80211/main.c                         |    4 
 net/mac80211/mlme.c                         |    4 
 net/mac80211/rate.c                         |   71 ++++++++--
 net/mac80211/rate.h                         |  102 ++++-----------
 net/mac80211/rc80211_pid.h                  |    2 
 net/mac80211/rc80211_pid_algo.c             |  158 +++++++++---------------
 net/mac80211/sta_info.c                     |   17 --
 net/mac80211/sta_info.h                     |    2 
 net/mac80211/tx.c                           |    5 
 18 files changed, 373 insertions(+), 514 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-09-18 17:53:22.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-18 17:53:23.000000000 +0200
@@ -695,7 +695,7 @@ static int ieee80211_add_station(struct 
 
 	sta_apply_parameters(local, sta, params);
 
-	rate_control_rate_init(sta, local);
+	rate_control_rate_init(sta);
 
 	rcu_read_lock();
 
--- everything.orig/net/mac80211/main.c	2008-09-18 17:53:17.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-18 17:53:23.000000000 +0200
@@ -542,6 +542,7 @@ void ieee80211_tx_status(struct ieee8021
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	u16 frag, type;
 	__le16 fc;
+	struct ieee80211_supported_band *sband;
 	struct ieee80211_tx_status_rtap_hdr *rthdr;
 	struct ieee80211_sub_if_data *sdata;
 	struct net_device *prev_dev = NULL;
@@ -588,7 +589,8 @@ void ieee80211_tx_status(struct ieee8021
 			sta->tx_retry_count += info->status.retry_count;
 		}
 
-		rate_control_tx_status(local->mdev, skb);
+		sband = local->hw.wiphy->bands[info->band];
+		rate_control_tx_status(local, sband, sta, skb);
 	}
 
 	rcu_read_unlock();
--- everything.orig/net/mac80211/mlme.c	2008-09-18 17:53:17.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-18 17:53:23.000000000 +0200
@@ -1354,7 +1354,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 		ieee80211_handle_ht(local, 1, &sta->sta.ht_info, &bss_info);
 	}
 
-	rate_control_rate_init(sta, local);
+	rate_control_rate_init(sta);
 
 	if (elems.wmm_param) {
 		set_sta_flags(sta, WLAN_STA_WME);
@@ -2373,7 +2373,7 @@ struct sta_info *ieee80211_ibss_add_sta(
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
-	rate_control_rate_init(sta, local);
+	rate_control_rate_init(sta);
 
 	if (sta_info_insert(sta))
 		return NULL;
--- everything.orig/net/mac80211/rate.c	2008-09-18 17:53:17.000000000 +0200
+++ everything/net/mac80211/rate.c	2008-09-18 17:53:23.000000000 +0200
@@ -12,6 +12,7 @@
 #include <linux/rtnetlink.h>
 #include "rate.h"
 #include "ieee80211_i.h"
+#include "debugfs.h"
 
 struct rate_control_alg {
 	struct list_head list;
@@ -127,19 +128,46 @@ static void ieee80211_rate_control_ops_p
 	module_put(ops->module);
 }
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+static ssize_t rcname_read(struct file *file, char __user *userbuf,
+			   size_t count, loff_t *ppos)
+{
+	struct rate_control_ref *ref = file->private_data;
+	int len = strlen(ref->ops->name);
+
+	return simple_read_from_buffer(userbuf, count, ppos,
+				       ref->ops->name, len);
+}
+
+static const struct file_operations rcname_ops = {
+	.read = rcname_read,
+	.open = mac80211_open_file_generic,
+};
+#endif
+
 struct rate_control_ref *rate_control_alloc(const char *name,
 					    struct ieee80211_local *local)
 {
+	struct dentry *debugfsdir = NULL;
 	struct rate_control_ref *ref;
 
 	ref = kmalloc(sizeof(struct rate_control_ref), GFP_KERNEL);
 	if (!ref)
 		goto fail_ref;
 	kref_init(&ref->kref);
+	ref->local = local;
 	ref->ops = ieee80211_rate_control_ops_get(name);
 	if (!ref->ops)
 		goto fail_ops;
-	ref->priv = ref->ops->alloc(local);
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	debugfsdir = debugfs_create_dir("rc", local->hw.wiphy->debugfsdir);
+	local->debugfs.rcdir = debugfsdir;
+	local->debugfs.rcname = debugfs_create_file("name", 0400, debugfsdir,
+						    ref, &rcname_ops);
+#endif
+
+	ref->priv = ref->ops->alloc(&local->hw, debugfsdir);
 	if (!ref->priv)
 		goto fail_priv;
 	return ref;
@@ -158,29 +186,46 @@ static void rate_control_release(struct 
 
 	ctrl_ref = container_of(kref, struct rate_control_ref, kref);
 	ctrl_ref->ops->free(ctrl_ref->priv);
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	debugfs_remove(ctrl_ref->local->debugfs.rcname);
+	ctrl_ref->local->debugfs.rcname = NULL;
+	debugfs_remove(ctrl_ref->local->debugfs.rcdir);
+	ctrl_ref->local->debugfs.rcdir = NULL;
+#endif
+
 	ieee80211_rate_control_ops_put(ctrl_ref->ops);
 	kfree(ctrl_ref);
 }
 
-void rate_control_get_rate(struct net_device *dev,
+void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			   struct ieee80211_supported_band *sband,
-			   struct sk_buff *skb,
+			   struct sta_info *sta, struct sk_buff *skb,
 			   struct rate_selection *sel)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct rate_control_ref *ref = local->rate_ctrl;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct sta_info *sta;
+	struct rate_control_ref *ref = sdata->local->rate_ctrl;
+	void *priv_sta = NULL;
+	struct ieee80211_sta *ista = NULL;
 	int i;
 
-	rcu_read_lock();
-	sta = sta_info_get(local, hdr->addr1);
-
 	sel->rate_idx = -1;
 	sel->nonerp_idx = -1;
 	sel->probe_idx = -1;
+	sel->max_rate_idx = sdata->max_ratectrl_rateidx;
+
+	if (sta) {
+		ista = &sta->sta;
+		priv_sta = sta->rate_ctrl_priv;
+	}
+
+	if (sta && sdata->force_unicast_rateidx > -1)
+		sel->rate_idx = sdata->force_unicast_rateidx;
+	else
+		ref->ops->get_rate(ref->priv, sband, ista, priv_sta, skb, sel);
 
-	ref->ops->get_rate(ref->priv, dev, sband, skb, sel);
+	if (sdata->max_ratectrl_rateidx > -1 &&
+	    sel->rate_idx > sdata->max_ratectrl_rateidx)
+		sel->rate_idx = sdata->max_ratectrl_rateidx;
 
 	BUG_ON(sel->rate_idx < 0);
 
@@ -191,13 +236,11 @@ void rate_control_get_rate(struct net_de
 			if (sband->bitrates[sel->rate_idx].bitrate < rate->bitrate)
 				break;
 
-			if (rate_supported(sta, sband->band, i) &&
+			if (rate_supported(ista, sband->band, i) &&
 			    !(rate->flags & IEEE80211_RATE_ERP_G))
 				sel->nonerp_idx = i;
 		}
 	}
-
-	rcu_read_unlock();
 }
 
 struct rate_control_ref *rate_control_get(struct rate_control_ref *ref)
--- everything.orig/net/mac80211/rate.h	2008-09-18 17:53:17.000000000 +0200
+++ everything/net/mac80211/rate.h	2008-09-18 17:53:23.000000000 +0200
@@ -19,77 +19,48 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 
-/**
- * struct rate_selection - rate selection for rate control algos
- * @rate: selected transmission rate index
- * @nonerp: Non-ERP rate to use instead if ERP cannot be used
- * @probe: rate for probing (or -1)
- *
- */
-struct rate_selection {
-	s8 rate_idx, nonerp_idx, probe_idx;
-};
-
-struct rate_control_ops {
-	struct module *module;
-	const char *name;
-	void (*tx_status)(void *priv, struct net_device *dev,
-			  struct sk_buff *skb);
-	void (*get_rate)(void *priv, struct net_device *dev,
-			 struct ieee80211_supported_band *band,
-			 struct sk_buff *skb,
-			 struct rate_selection *sel);
-	void (*rate_init)(void *priv, void *priv_sta,
-			  struct ieee80211_local *local, struct sta_info *sta);
-	void (*clear)(void *priv);
-
-	void *(*alloc)(struct ieee80211_local *local);
-	void (*free)(void *priv);
-	void *(*alloc_sta)(void *priv, gfp_t gfp);
-	void (*free_sta)(void *priv, void *priv_sta);
-
-	int (*add_attrs)(void *priv, struct kobject *kobj);
-	void (*remove_attrs)(void *priv, struct kobject *kobj);
-	void (*add_sta_debugfs)(void *priv, void *priv_sta,
-				struct dentry *dir);
-	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
-};
-
 struct rate_control_ref {
+	struct ieee80211_local *local;
 	struct rate_control_ops *ops;
 	void *priv;
 	struct kref kref;
 };
 
-int ieee80211_rate_control_register(struct rate_control_ops *ops);
-void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
-
 /* Get a reference to the rate control algorithm. If `name' is NULL, get the
  * first available algorithm. */
 struct rate_control_ref *rate_control_alloc(const char *name,
 					    struct ieee80211_local *local);
-void rate_control_get_rate(struct net_device *dev,
+void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			   struct ieee80211_supported_band *sband,
-			   struct sk_buff *skb,
+			   struct sta_info *sta, struct sk_buff *skb,
 			   struct rate_selection *sel);
 struct rate_control_ref *rate_control_get(struct rate_control_ref *ref);
 void rate_control_put(struct rate_control_ref *ref);
 
-static inline void rate_control_tx_status(struct net_device *dev,
+static inline void rate_control_tx_status(struct ieee80211_local *local,
+					  struct ieee80211_supported_band *sband,
+					  struct sta_info *sta,
 					  struct sk_buff *skb)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct rate_control_ref *ref = local->rate_ctrl;
+	struct ieee80211_sta *ista = &sta->sta;
+	void *priv_sta = sta->rate_ctrl_priv;
 
-	ref->ops->tx_status(ref->priv, dev, skb);
+	ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
 }
 
 
-static inline void rate_control_rate_init(struct sta_info *sta,
-					  struct ieee80211_local *local)
+static inline void rate_control_rate_init(struct sta_info *sta)
 {
+	struct ieee80211_local *local = sta->sdata->local;
 	struct rate_control_ref *ref = sta->rate_ctrl;
-	ref->ops->rate_init(ref->priv, sta->rate_ctrl_priv, local, sta);
+	struct ieee80211_sta *ista = &sta->sta;
+	void *priv_sta = sta->rate_ctrl_priv;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
 }
 
 
@@ -100,15 +71,19 @@ static inline void rate_control_clear(st
 }
 
 static inline void *rate_control_alloc_sta(struct rate_control_ref *ref,
+					   struct ieee80211_sta *sta,
 					   gfp_t gfp)
 {
-	return ref->ops->alloc_sta(ref->priv, gfp);
+	return ref->ops->alloc_sta(ref->priv, sta, gfp);
 }
 
-static inline void rate_control_free_sta(struct rate_control_ref *ref,
-					 void *priv)
+static inline void rate_control_free_sta(struct sta_info *sta)
 {
-	ref->ops->free_sta(ref->priv, priv);
+	struct rate_control_ref *ref = sta->rate_ctrl;
+	struct ieee80211_sta *ista = &sta->sta;
+	void *priv_sta = sta->rate_ctrl_priv;
+
+	ref->ops->free_sta(ref->priv, ista, priv_sta);
 }
 
 static inline void rate_control_add_sta_debugfs(struct sta_info *sta)
@@ -130,31 +105,6 @@ static inline void rate_control_remove_s
 #endif
 }
 
-static inline int rate_supported(struct sta_info *sta,
-				 enum ieee80211_band band,
-				 int index)
-{
-	return (sta == NULL || sta->sta.supp_rates[band] & BIT(index));
-}
-
-static inline s8
-rate_lowest_index(struct ieee80211_local *local,
-		  struct ieee80211_supported_band *sband,
-		  struct sta_info *sta)
-{
-	int i;
-
-	for (i = 0; i < sband->n_bitrates; i++)
-		if (rate_supported(sta, sband->band, i))
-			return i;
-
-	/* warn when we cannot find a rate. */
-	WARN_ON(1);
-
-	return 0;
-}
-
-
 /* functions for rate control related to a device */
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name);
--- everything.orig/net/mac80211/sta_info.c	2008-09-18 17:53:17.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-09-18 17:53:23.000000000 +0200
@@ -93,8 +93,7 @@ static int sta_info_hash_del(struct ieee
 }
 
 /* protected by RCU */
-static struct sta_info *__sta_info_find(struct ieee80211_local *local,
-					const u8 *addr)
+struct sta_info *sta_info_get(struct ieee80211_local *local, const u8 *addr)
 {
 	struct sta_info *sta;
 
@@ -107,12 +106,6 @@ static struct sta_info *__sta_info_find(
 	return sta;
 }
 
-struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr)
-{
-	return __sta_info_find(local, addr);
-}
-EXPORT_SYMBOL(sta_info_get);
-
 struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int idx,
 				     struct net_device *dev)
 {
@@ -146,7 +139,7 @@ static void __sta_info_free(struct ieee8
 {
 	DECLARE_MAC_BUF(mbuf);
 
-	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
+	rate_control_free_sta(sta);
 	rate_control_put(sta->rate_ctrl);
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -244,7 +237,7 @@ struct sta_info *sta_info_alloc(struct i
 
 	sta->rate_ctrl = rate_control_get(local->rate_ctrl);
 	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl,
-						     gfp);
+						     &sta->sta, gfp);
 	if (!sta->rate_ctrl_priv) {
 		rate_control_put(sta->rate_ctrl);
 		kfree(sta);
@@ -308,7 +301,7 @@ int sta_info_insert(struct sta_info *sta
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
-	if (__sta_info_find(local, sta->sta.addr)) {
+	if (sta_info_get(local, sta->sta.addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 		err = -EEXIST;
 		goto out_free;
@@ -834,7 +827,7 @@ void ieee80211_sta_expire(struct ieee802
 struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
                                          const u8 *addr)
 {
-	struct sta_info *sta = __sta_info_find(hw_to_local(hw), addr);
+	struct sta_info *sta = sta_info_get(hw_to_local(hw), addr);
 
 	if (!sta)
 		return NULL;
--- everything.orig/net/mac80211/tx.c	2008-09-18 17:53:17.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-18 17:53:23.000000000 +0200
@@ -446,7 +446,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
 	if (likely(tx->rate_idx < 0)) {
-		rate_control_get_rate(tx->dev, sband, tx->skb, &rsel);
+		rate_control_get_rate(tx->sdata, sband, tx->sta,
+				      tx->skb, &rsel);
 		if (tx->sta)
 			tx->sta->last_txrate_idx = rsel.rate_idx;
 		tx->rate_idx = rsel.rate_idx;
@@ -1923,7 +1924,7 @@ struct sk_buff *ieee80211_beacon_get(str
 	skb->do_not_encrypt = 1;
 
 	info->band = band;
-	rate_control_get_rate(local->mdev, sband, skb, &rsel);
+	rate_control_get_rate(sdata, sband, NULL, skb, &rsel);
 
 	if (unlikely(rsel.rate_idx < 0)) {
 		if (net_ratelimit()) {
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-09-18 17:53:17.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-09-18 17:53:23.000000000 +0200
@@ -68,18 +68,14 @@
  * exhibited a worse failed frames behaviour and we'll choose the highest rate
  * whose failed frames behaviour is not worse than the one of the original rate
  * target. While at it, check that the new rate is valid. */
-static void rate_control_pid_adjust_rate(struct ieee80211_local *local,
-					 struct sta_info *sta, int adj,
+static void rate_control_pid_adjust_rate(struct ieee80211_supported_band *sband,
+					 struct ieee80211_sta *sta,
+					 struct rc_pid_sta_info *spinfo, int adj,
 					 struct rc_pid_rateinfo *rinfo)
 {
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_supported_band *sband;
 	int cur_sorted, new_sorted, probe, tmp, n_bitrates, band;
-	struct rc_pid_sta_info *spinfo = (void *)sta->rate_ctrl_priv;
 	int cur = spinfo->txrate_idx;
 
-	sdata = sta->sdata;
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	band = sband->band;
 	n_bitrates = sband->n_bitrates;
 
@@ -146,13 +142,11 @@ static void rate_control_pid_normalize(s
 }
 
 static void rate_control_pid_sample(struct rc_pid_info *pinfo,
-				    struct ieee80211_local *local,
-				    struct sta_info *sta)
+				    struct ieee80211_supported_band *sband,
+				    struct ieee80211_sta *sta,
+				    struct rc_pid_sta_info *spinfo)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct rc_pid_sta_info *spinfo = sta->rate_ctrl_priv;
 	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
-	struct ieee80211_supported_band *sband;
 	u32 pf;
 	s32 err_avg;
 	u32 err_prop;
@@ -161,9 +155,6 @@ static void rate_control_pid_sample(stru
 	int adj, i, j, tmp;
 	unsigned long period;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	spinfo = sta->rate_ctrl_priv;
-
 	/* In case nothing happened during the previous control interval, turn
 	 * the sharpening factor on. */
 	period = (HZ * pinfo->sampling_period + 500) / 1000;
@@ -179,11 +170,15 @@ static void rate_control_pid_sample(stru
 	if (unlikely(spinfo->tx_num_xmit == 0))
 		pf = spinfo->last_pf;
 	else {
+		/* XXX: BAD HACK!!! */
+		struct sta_info *si = container_of(sta, struct sta_info, sta);
+
 		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
-		if (ieee80211_vif_is_mesh(&sdata->vif) && pf == 100)
-			mesh_plink_broken(sta);
+
+		if (ieee80211_vif_is_mesh(&si->sdata->vif) && pf == 100)
+			mesh_plink_broken(si);
 		pf <<= RC_PID_ARITH_SHIFT;
-		sta->fail_avg = ((pf + (spinfo->last_pf << 3)) / 9)
+		si->fail_avg = ((pf + (spinfo->last_pf << 3)) / 9)
 					>> RC_PID_ARITH_SHIFT;
 	}
 
@@ -229,43 +224,25 @@ static void rate_control_pid_sample(stru
 
 	/* Change rate. */
 	if (adj)
-		rate_control_pid_adjust_rate(local, sta, adj, rinfo);
+		rate_control_pid_adjust_rate(sband, sta, spinfo, adj, rinfo);
 }
 
-static void rate_control_pid_tx_status(void *priv, struct net_device *dev,
+static void rate_control_pid_tx_status(void *priv, struct ieee80211_supported_band *sband,
+				       struct ieee80211_sta *sta, void *priv_sta,
 				       struct sk_buff *skb)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_sub_if_data *sdata;
 	struct rc_pid_info *pinfo = priv;
-	struct sta_info *sta;
-	struct rc_pid_sta_info *spinfo;
+	struct rc_pid_sta_info *spinfo = priv_sta;
 	unsigned long period;
-	struct ieee80211_supported_band *sband;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	rcu_read_lock();
-
-	sta = sta_info_get(local, hdr->addr1);
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	if (!sta)
-		goto unlock;
-
-	spinfo = sta->rate_ctrl_priv;
-
-	/* Don't update the state if we're not controlling the rate. */
-	sdata = sta->sdata;
-	if (sdata->force_unicast_rateidx > -1) {
-		spinfo->txrate_idx = sdata->max_ratectrl_rateidx;
-		goto unlock;
-	}
+	if (!spinfo)
+		return;
 
 	/* Ignore all frames that were sent with a different rate than the rate
 	 * we currently advise mac80211 to use. */
 	if (info->tx_rate_idx != spinfo->txrate_idx)
-		goto unlock;
+		return;
 
 	spinfo->tx_num_xmit++;
 
@@ -289,78 +266,63 @@ static void rate_control_pid_tx_status(v
 	if (!period)
 		period = 1;
 	if (time_after(jiffies, spinfo->last_sample + period))
-		rate_control_pid_sample(pinfo, local, sta);
-
- unlock:
-	rcu_read_unlock();
+		rate_control_pid_sample(pinfo, sband, sta, spinfo);
 }
 
-static void rate_control_pid_get_rate(void *priv, struct net_device *dev,
-				      struct ieee80211_supported_band *sband,
-				      struct sk_buff *skb,
-				      struct rate_selection *sel)
+static void
+rate_control_pid_get_rate(void *priv, struct ieee80211_supported_band *sband,
+			  struct ieee80211_sta *sta, void *priv_sta,
+			  struct sk_buff *skb,
+			  struct rate_selection *sel)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_sub_if_data *sdata;
-	struct rc_pid_sta_info *spinfo;
-	struct sta_info *sta;
+	struct rc_pid_sta_info *spinfo = priv_sta;
 	int rateidx;
 	u16 fc;
 
-	rcu_read_lock();
-
-	sta = sta_info_get(local, hdr->addr1);
-
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
 	fc = le16_to_cpu(hdr->frame_control);
-	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
-	    is_multicast_ether_addr(hdr->addr1) || !sta) {
-		sel->rate_idx = rate_lowest_index(local, sband, sta);
-		rcu_read_unlock();
+	if (!sta || !spinfo ||
+	    (fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
+	    is_multicast_ether_addr(hdr->addr1)) {
+		sel->rate_idx = rate_lowest_index(sband, sta);
 		return;
 	}
 
-	/* If a forced rate is in effect, select it. */
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	spinfo = (struct rc_pid_sta_info *)sta->rate_ctrl_priv;
-	if (sdata->force_unicast_rateidx > -1)
-		spinfo->txrate_idx = sdata->force_unicast_rateidx;
-
 	rateidx = spinfo->txrate_idx;
 
 	if (rateidx >= sband->n_bitrates)
 		rateidx = sband->n_bitrates - 1;
 
-	rcu_read_unlock();
-
 	sel->rate_idx = rateidx;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	rate_control_pid_event_tx_rate(
-		&((struct rc_pid_sta_info *) sta->rate_ctrl_priv)->events,
+	rate_control_pid_event_tx_rate(&spinfo->events,
 		rateidx, sband->bitrates[rateidx].bitrate);
 #endif
 }
 
-static void rate_control_pid_rate_init(void *priv, void *priv_sta,
-					  struct ieee80211_local *local,
-					  struct sta_info *sta)
+static void
+rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
+			   struct ieee80211_sta *sta, void *priv_sta)
 {
+	struct rc_pid_sta_info *spinfo = priv_sta;
+	struct sta_info *si;
+
 	/* TODO: This routine should consider using RSSI from previous packets
 	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
 	 * Until that method is implemented, we will use the lowest supported
 	 * rate as a workaround. */
-	struct ieee80211_supported_band *sband;
-	struct rc_pid_sta_info *spinfo = (void *)sta->rate_ctrl_priv;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	spinfo->txrate_idx = rate_lowest_index(local, sband, sta);
-	sta->fail_avg = 0;
+	spinfo->txrate_idx = rate_lowest_index(sband, sta);
+	/* HACK */
+	si = container_of(sta, struct sta_info, sta);
+	si->fail_avg = 0;
 }
 
-static void *rate_control_pid_alloc(struct ieee80211_local *local)
+static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
+				    struct dentry *debugfsdir)
 {
 	struct rc_pid_info *pinfo;
 	struct rc_pid_rateinfo *rinfo;
@@ -371,7 +333,7 @@ static void *rate_control_pid_alloc(stru
 	struct rc_pid_debugfs_entries *de;
 #endif
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = hw->wiphy->bands[hw->conf.channel->band];
 
 	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
 	if (!pinfo)
@@ -426,30 +388,28 @@ static void *rate_control_pid_alloc(stru
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	de = &pinfo->dentries;
-	de->dir = debugfs_create_dir("rc80211_pid",
-				     local->hw.wiphy->debugfsdir);
 	de->target = debugfs_create_u32("target_pf", S_IRUSR | S_IWUSR,
-					de->dir, &pinfo->target);
+					debugfsdir, &pinfo->target);
 	de->sampling_period = debugfs_create_u32("sampling_period",
-						 S_IRUSR | S_IWUSR, de->dir,
+						 S_IRUSR | S_IWUSR, debugfsdir,
 						 &pinfo->sampling_period);
 	de->coeff_p = debugfs_create_u32("coeff_p", S_IRUSR | S_IWUSR,
-					 de->dir, &pinfo->coeff_p);
+					 debugfsdir, &pinfo->coeff_p);
 	de->coeff_i = debugfs_create_u32("coeff_i", S_IRUSR | S_IWUSR,
-					 de->dir, &pinfo->coeff_i);
+					 debugfsdir, &pinfo->coeff_i);
 	de->coeff_d = debugfs_create_u32("coeff_d", S_IRUSR | S_IWUSR,
-					 de->dir, &pinfo->coeff_d);
+					 debugfsdir, &pinfo->coeff_d);
 	de->smoothing_shift = debugfs_create_u32("smoothing_shift",
-						 S_IRUSR | S_IWUSR, de->dir,
+						 S_IRUSR | S_IWUSR, debugfsdir,
 						 &pinfo->smoothing_shift);
 	de->sharpen_factor = debugfs_create_u32("sharpen_factor",
-					       S_IRUSR | S_IWUSR, de->dir,
+					       S_IRUSR | S_IWUSR, debugfsdir,
 					       &pinfo->sharpen_factor);
 	de->sharpen_duration = debugfs_create_u32("sharpen_duration",
-						  S_IRUSR | S_IWUSR, de->dir,
+						  S_IRUSR | S_IWUSR, debugfsdir,
 						  &pinfo->sharpen_duration);
 	de->norm_offset = debugfs_create_u32("norm_offset",
-					     S_IRUSR | S_IWUSR, de->dir,
+					     S_IRUSR | S_IWUSR, debugfsdir,
 					     &pinfo->norm_offset);
 #endif
 
@@ -471,7 +431,6 @@ static void rate_control_pid_free(void *
 	debugfs_remove(de->coeff_p);
 	debugfs_remove(de->sampling_period);
 	debugfs_remove(de->target);
-	debugfs_remove(de->dir);
 #endif
 
 	kfree(pinfo->rinfo);
@@ -482,7 +441,8 @@ static void rate_control_pid_clear(void 
 {
 }
 
-static void *rate_control_pid_alloc_sta(void *priv, gfp_t gfp)
+static void *rate_control_pid_alloc_sta(void *priv, struct ieee80211_sta *sta,
+					gfp_t gfp)
 {
 	struct rc_pid_sta_info *spinfo;
 
@@ -500,10 +460,10 @@ static void *rate_control_pid_alloc_sta(
 	return spinfo;
 }
 
-static void rate_control_pid_free_sta(void *priv, void *priv_sta)
+static void rate_control_pid_free_sta(void *priv, struct ieee80211_sta *sta,
+				      void *priv_sta)
 {
-	struct rc_pid_sta_info *spinfo = priv_sta;
-	kfree(spinfo);
+	kfree(priv_sta);
 }
 
 static struct rate_control_ops mac80211_rcpid = {
--- everything.orig/drivers/net/wireless/ath9k/rc.c	2008-09-18 17:53:17.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/rc.c	2008-09-18 18:04:56.000000000 +0200
@@ -20,6 +20,7 @@
  */
 
 #include "core.h"
+/* FIXME: remove this include! */
 #include "../net/mac80211/rate.h"
 
 static u32 tx_triglevel_max;
@@ -1812,20 +1813,18 @@ static void ath_rc_sib_init(struct ath_r
 }
 
 
-static void ath_setup_rates(struct ieee80211_local *local, struct sta_info *sta)
+static void ath_setup_rates(struct ath_softc *sc,
+			    struct ieee80211_supported_band *sband,
+			    struct ieee80211_sta *sta,
+			    struct ath_rate_node *rc_priv)
 
 {
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_hw *hw = local_to_hw(local);
-	struct ath_softc *sc = hw->priv;
-	struct ath_rate_node *rc_priv = sta->rate_ctrl_priv;
 	int i, j = 0;
 
 	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 
-	sband =  local->hw.wiphy->bands[local->hw.conf.channel->band];
 	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sta->sta.supp_rates[local->hw.conf.channel->band] & BIT(i)) {
+		if (sta->supp_rates[sband->band] & BIT(i)) {
 			rc_priv->neg_rates.rs_rates[j]
 				= (sband->bitrates[i].bitrate * 2) / 10;
 			j++;
@@ -1852,19 +1851,17 @@ void ath_rc_node_update(struct ieee80211
 }
 
 /* Rate Control callbacks */
-static void ath_tx_status(void *priv, struct net_device *dev,
+static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
+			  struct ieee80211_sta *sta, void *priv_sta,
 			  struct sk_buff *skb)
 {
 	struct ath_softc *sc = priv;
 	struct ath_tx_info_priv *tx_info_priv;
 	struct ath_node *an;
-	struct sta_info *sta;
-	struct ieee80211_local *local;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
 	__le16 fc;
 
-	local = hw_to_local(sc->hw);
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
 	tx_info_priv = (struct ath_tx_info_priv *)tx_info->driver_data[0];
@@ -1873,8 +1870,7 @@ static void ath_tx_status(void *priv, st
 	an = ath_node_find(sc, hdr->addr1);
 	spin_unlock_bh(&sc->node_lock);
 
-	sta = sta_info_get(local, hdr->addr1);
-	if (!an || !sta || !ieee80211_is_data(fc)) {
+	if (!an || !priv_sta || !ieee80211_is_data(fc)) {
 		if (tx_info->driver_data[0] != NULL) {
 			kfree(tx_info->driver_data[0]);
 			tx_info->driver_data[0] = NULL;
@@ -1882,24 +1878,22 @@ static void ath_tx_status(void *priv, st
 		return;
 	}
 	if (tx_info->driver_data[0] != NULL) {
-		ath_rate_tx_complete(sc, an, sta->rate_ctrl_priv, tx_info_priv);
+		ath_rate_tx_complete(sc, an, priv_sta, tx_info_priv);
 		kfree(tx_info->driver_data[0]);
 		tx_info->driver_data[0] = NULL;
 	}
 }
 
 static void ath_tx_aggr_resp(struct ath_softc *sc,
-			     struct sta_info *sta,
+			     struct ieee80211_supported_band *sband,
+			     struct ieee80211_sta *sta,
 			     struct ath_node *an,
 			     u8 tidno)
 {
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_local *local;
 	struct ath_atx_tid *txtid;
-	struct ieee80211_supported_band *sband;
 	u16 buffersize = 0;
 	int state;
-	DECLARE_MAC_BUF(mac);
+	struct sta_info *si;
 
 	if (!(sc->sc_flags & SC_OP_TXAGGR))
 		return;
@@ -1908,11 +1902,16 @@ static void ath_tx_aggr_resp(struct ath_
 	if (!txtid->paused)
 		return;
 
-	local = hw_to_local(sc->hw);
-	sband = hw->wiphy->bands[hw->conf.channel->band];
+	/*
+	 * XXX: This is entirely busted, we aren't supposed to
+	 *	access the sta from here because it's internal
+	 *	to mac80211, and looking at the state without
+	 *	locking is wrong too.
+	 */
+	si = container_of(sta, struct sta_info, sta);
 	buffersize = IEEE80211_MIN_AMPDU_BUF <<
 		sband->ht_info.ampdu_factor; /* FIXME */
-	state = sta->ampdu_mlme.tid_state_tx[tidno];
+	state = si->ampdu_mlme.tid_state_tx[tidno];
 
 	if (state & HT_ADDBA_RECEIVED_MSK) {
 		txtid->addba_exchangecomplete = 1;
@@ -1928,18 +1927,15 @@ static void ath_tx_aggr_resp(struct ath_
 	}
 }
 
-static void ath_get_rate(void *priv, struct net_device *dev,
-			 struct ieee80211_supported_band *sband,
-			 struct sk_buff *skb,
-			 struct rate_selection *sel)
+static void ath_get_rate(void *priv, struct ieee80211_supported_band *sband,
+			 struct ieee80211_sta *sta, void *priv_sta,
+			 struct sk_buff *skb, struct rate_selection *sel)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sta_info *sta;
-	struct ath_softc *sc = (struct ath_softc *)priv;
+	struct ath_softc *sc = priv;
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath_tx_info_priv *tx_info_priv;
-	struct ath_rate_node *ath_rc_priv;
+	struct ath_rate_node *ath_rc_priv = priv_sta;
 	struct ath_node *an;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	int is_probe = FALSE, chk, ret;
@@ -1955,8 +1951,7 @@ static void ath_get_rate(void *priv, str
 	ASSERT(tx_info->driver_data[0] != NULL);
 	tx_info_priv = (struct ath_tx_info_priv *)tx_info->driver_data[0];
 
-	sta = sta_info_get(local, hdr->addr1);
-	lowest_idx = rate_lowest_index(local, sband, sta);
+	lowest_idx = rate_lowest_index(sband, sta);
 	tx_info_priv->min_rate = (sband->bitrates[lowest_idx].bitrate * 2) / 10;
 	/* lowest rate for management and multicast/broadcast frames */
 	if (!ieee80211_is_data(fc) ||
@@ -1965,8 +1960,6 @@ static void ath_get_rate(void *priv, str
 		return;
 	}
 
-	ath_rc_priv = sta->rate_ctrl_priv;
-
 	/* Find tx rate for unicast frames */
 	ath_rate_findrate(sc, ath_rc_priv,
 			  ATH_11N_TXMAXTRY, 4,
@@ -1975,8 +1968,7 @@ static void ath_get_rate(void *priv, str
 			  &is_probe,
 			  false);
 	if (is_probe)
-		sel->probe_idx = ((struct ath_tx_ratectrl *)
-				  sta->rate_ctrl_priv)->probe_rate;
+		sel->probe_idx = ath_rc_priv->tx_ratectrl.probe_rate;
 
 	/* Ratecontrol sometimes returns invalid rate index */
 	if (tx_info_priv->rcs[0].rix != 0xff)
@@ -2020,37 +2012,31 @@ static void ath_get_rate(void *priv, str
 						__func__,
 						print_mac(mac, hdr->addr1));
 			} else if (chk == AGGR_EXCHANGE_PROGRESS)
-				ath_tx_aggr_resp(sc, sta, an, tid);
+				ath_tx_aggr_resp(sc, sband, sta, an, tid);
 		}
 	}
 }
 
-static void ath_rate_init(void *priv, void *priv_sta,
-			  struct ieee80211_local *local,
-			  struct sta_info *sta)
+static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
+                          struct ieee80211_sta *sta, void *priv_sta)
 {
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_hw *hw = local_to_hw(local);
-	struct ieee80211_conf *conf = &local->hw.conf;
-	struct ath_softc *sc = hw->priv;
+	struct ath_softc *sc = priv;
 	struct ath_rate_node *ath_rc_priv = priv_sta;
 	int i, j = 0;
 
 	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	ath_setup_rates(local, sta);
-	if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
+	ath_setup_rates(sc, sband, sta, ath_rc_priv);
+	if (sc->hw->conf.flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
 		for (i = 0; i < MCS_SET_SIZE; i++) {
-			if (conf->ht_conf.supp_mcs_set[i/8] & (1<<(i%8)))
+			if (sc->hw->conf.ht_conf.supp_mcs_set[i/8] & (1<<(i%8)))
 				ath_rc_priv->neg_ht_rates.rs_rates[j++] = i;
 			if (j == ATH_RATE_MAX)
 				break;
 		}
 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
 	}
-	ath_rc_node_update(hw, priv_sta);
+	ath_rc_node_update(sc->hw, priv_sta);
 }
 
 static void ath_rate_clear(void *priv)
@@ -2058,13 +2044,12 @@ static void ath_rate_clear(void *priv)
 	return;
 }
 
-static void *ath_rate_alloc(struct ieee80211_local *local)
+static void *ath_rate_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
-	struct ieee80211_hw *hw = local_to_hw(local);
 	struct ath_softc *sc = hw->priv;
 
 	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
-	return local->hw.priv;
+	return hw->priv;
 }
 
 static void ath_rate_free(void *priv)
@@ -2072,7 +2057,7 @@ static void ath_rate_free(void *priv)
 	return;
 }
 
-static void *ath_rate_alloc_sta(void *priv, gfp_t gfp)
+static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 {
 	struct ath_softc *sc = priv;
 	struct ath_vap *avp = sc->sc_vaps[0];
@@ -2092,7 +2077,8 @@ static void *ath_rate_alloc_sta(void *pr
 	return rate_priv;
 }
 
-static void ath_rate_free_sta(void *priv, void *priv_sta)
+static void ath_rate_free_sta(void *priv, struct ieee80211_sta *sta,
+			      void *priv_sta)
 {
 	struct ath_rate_node *rate_priv = priv_sta;
 	struct ath_softc *sc = priv;
@@ -2111,7 +2097,7 @@ static struct rate_control_ops ath_rate_
 	.alloc = ath_rate_alloc,
 	.free = ath_rate_free,
 	.alloc_sta = ath_rate_alloc_sta,
-	.free_sta = ath_rate_free_sta
+	.free_sta = ath_rate_free_sta,
 };
 
 int ath_rate_control_register(void)
--- everything.orig/include/net/mac80211.h	2008-09-18 17:53:16.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-18 17:53:23.000000000 +0200
@@ -1800,4 +1800,72 @@ void ieee80211_notify_mac(struct ieee802
 struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
 					 const u8 *addr);
 
+
+/* Rate control API */
+/**
+ * struct rate_selection - rate information for/from rate control algorithms
+ *
+ * @rate_idx: selected transmission rate index
+ * @nonerp_idx: Non-ERP rate to use instead if ERP cannot be used
+ * @probe_idx: rate for probing (or -1)
+ * @max_rate_idx: maximum rate index that can be used, this is
+ *	input to the algorithm and will be enforced
+ */
+struct rate_selection {
+	s8 rate_idx, nonerp_idx, probe_idx, max_rate_idx;
+};
+
+struct rate_control_ops {
+	struct module *module;
+	const char *name;
+	void *(*alloc)(struct ieee80211_hw *hw, struct dentry *debugfsdir);
+	void (*clear)(void *priv);
+	void (*free)(void *priv);
+
+	void *(*alloc_sta)(void *priv, struct ieee80211_sta *sta, gfp_t gfp);
+	void (*rate_init)(void *priv, struct ieee80211_supported_band *sband,
+			  struct ieee80211_sta *sta, void *priv_sta);
+	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
+			 void *priv_sta);
+
+	void (*tx_status)(void *priv, struct ieee80211_supported_band *sband,
+			  struct ieee80211_sta *sta, void *priv_sta,
+			  struct sk_buff *skb);
+	void (*get_rate)(void *priv, struct ieee80211_supported_band *sband,
+			 struct ieee80211_sta *sta, void *priv_sta,
+			 struct sk_buff *skb,
+			 struct rate_selection *sel);
+
+	void (*add_sta_debugfs)(void *priv, void *priv_sta,
+				struct dentry *dir);
+	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
+};
+
+static inline int rate_supported(struct ieee80211_sta *sta,
+				 enum ieee80211_band band,
+				 int index)
+{
+	return (sta == NULL || sta->supp_rates[band] & BIT(index));
+}
+
+static inline s8
+rate_lowest_index(struct ieee80211_supported_band *sband,
+		  struct ieee80211_sta *sta)
+{
+	int i;
+
+	for (i = 0; i < sband->n_bitrates; i++)
+		if (rate_supported(sta, sband->band, i))
+			return i;
+
+	/* warn when we cannot find a rate. */
+	WARN_ON(1);
+
+	return 0;
+}
+
+
+int ieee80211_rate_control_register(struct rate_control_ops *ops);
+void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
+
 #endif /* MAC80211_H */
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-09-18 17:53:17.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-09-18 17:53:23.000000000 +0200
@@ -36,8 +36,6 @@
 
 #include <linux/workqueue.h>
 
-#include "../net/mac80211/rate.h"
-
 #include "iwl-3945.h"
 
 #define RS_NAME "iwl-3945-rs"
@@ -319,10 +317,10 @@ static void iwl3945_collect_tx_data(stru
 	}
 }
 
-static void rs_rate_init(void *priv_rate, void *priv_sta,
-			 struct ieee80211_local *local, struct sta_info *sta)
+static void rs_rate_init(void *priv, struct ieee80211_supported_band *sband,
+			 struct ieee80211_sta *sta, void *priv_sta)
 {
-	struct iwl3945_rs_sta *rs_sta = (void *)sta->rate_ctrl_priv;
+	struct iwl3945_rs_sta *rs_sta = priv_sta;
 	int i;
 
 	IWL_DEBUG_RATE("enter\n");
@@ -333,22 +331,22 @@ static void rs_rate_init(void *priv_rate
 	 * after assoc.. */
 
 	for (i = IWL_RATE_COUNT - 1; i >= 0; i--) {
-		if (sta->sta.supp_rates[local->hw.conf.channel->band] & (1 << i)) {
+		if (sta->supp_rates[sband->band] & (1 << i)) {
 			rs_sta->last_txrate_idx = i;
 			break;
 		}
 	}
 
 	/* For 5 GHz band it start at IWL_FIRST_OFDM_RATE */
-	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
+	if (sband->band == IEEE80211_BAND_5GHZ)
 		rs_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 
 	IWL_DEBUG_RATE("leave\n");
 }
 
-static void *rs_alloc(struct ieee80211_local *local)
+static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
-	return local->hw.priv;
+	return hw->priv;
 }
 
 /* rate scale requires free function to be implemented */
@@ -356,17 +354,24 @@ static void rs_free(void *priv)
 {
 	return;
 }
+
 static void rs_clear(void *priv)
 {
 	return;
 }
 
 
-static void *rs_alloc_sta(void *priv, gfp_t gfp)
+static void *rs_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 {
 	struct iwl3945_rs_sta *rs_sta;
+	struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
 	int i;
 
+	/*
+	 * XXX: If it's using sta->drv_priv anyway, it might
+	 *	as well just put all the information there.
+	 */
+
 	IWL_DEBUG_RATE("enter\n");
 
 	rs_sta = kzalloc(sizeof(struct iwl3945_rs_sta), gfp);
@@ -375,6 +380,8 @@ static void *rs_alloc_sta(void *priv, gf
 		return NULL;
 	}
 
+	psta->rs_sta = rs_sta;
+
 	spin_lock_init(&rs_sta->lock);
 
 	rs_sta->start_rate = IWL_RATE_INVALID;
@@ -400,10 +407,14 @@ static void *rs_alloc_sta(void *priv, gf
 	return rs_sta;
 }
 
-static void rs_free_sta(void *priv, void *priv_sta)
+static void rs_free_sta(void *priv, struct ieee80211_sta *sta,
+			void *priv_sta)
 {
+	struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
 	struct iwl3945_rs_sta *rs_sta = priv_sta;
 
+	psta->rs_sta = NULL;
+
 	IWL_DEBUG_RATE("enter\n");
 	del_timer_sync(&rs_sta->rate_scale_flush);
 	kfree(rs_sta);
@@ -445,26 +456,19 @@ static int rs_adjust_next_rate(struct iw
  * NOTE: Uses iwl3945_priv->retry_rate for the # of retries attempted by
  * the hardware for each rate.
  */
-static void rs_tx_status(void *priv_rate,
-			 struct net_device *dev,
+static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband,
+			 struct ieee80211_sta *sta, void *priv_sta,
 			 struct sk_buff *skb)
 {
 	u8 retries, current_count;
 	int scale_rate_index, first_index, last_index;
 	unsigned long flags;
-	struct sta_info *sta;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct iwl3945_rs_sta *rs_sta;
-	struct ieee80211_supported_band *sband;
+	struct iwl3945_rs_sta *rs_sta = priv_sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	IWL_DEBUG_RATE("enter\n");
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-
 	retries = info->status.retry_count;
 	first_index = sband->bitrates[info->tx_rate_idx].hw_value;
 	if ((first_index < 0) || (first_index >= IWL_RATE_COUNT)) {
@@ -472,17 +476,11 @@ static void rs_tx_status(void *priv_rate
 		return;
 	}
 
-	rcu_read_lock();
-
-	sta = sta_info_get(local, hdr->addr1);
-	if (!sta || !sta->rate_ctrl_priv) {
-		rcu_read_unlock();
+	if (!priv_sta) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
 		return;
 	}
 
-	rs_sta = (void *)sta->rate_ctrl_priv;
-
 	rs_sta->tx_packets++;
 
 	scale_rate_index = first_index;
@@ -549,8 +547,6 @@ static void rs_tx_status(void *priv_rate
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
-	rcu_read_unlock();
-
 	IWL_DEBUG_RATE("leave\n");
 
 	return;
@@ -634,16 +630,15 @@ static u16 iwl3945_get_adjacent_rate(str
  * rate table and must reference the driver allocated rate table
  *
  */
-static void rs_get_rate(void *priv_rate, struct net_device *dev,
-			struct ieee80211_supported_band *sband,
-			struct sk_buff *skb,
-			struct rate_selection *sel)
+static void rs_get_rate(void *priv_r, struct ieee80211_supported_band *sband,
+			struct ieee80211_sta *sta, void *priv_sta,
+			struct sk_buff *skb, struct rate_selection *sel)
 {
 	u8 low = IWL_RATE_INVALID;
 	u8 high = IWL_RATE_INVALID;
 	u16 high_low;
 	int index;
-	struct iwl3945_rs_sta *rs_sta;
+	struct iwl3945_rs_sta *rs_sta = priv_sta;
 	struct iwl3945_rate_scale_data *window = NULL;
 	int current_tpt = IWL_INV_TPT;
 	int low_tpt = IWL_INV_TPT;
@@ -651,34 +646,25 @@ static void rs_get_rate(void *priv_rate,
 	u32 fail_count;
 	s8 scale_action = 0;
 	unsigned long flags;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct sta_info *sta;
 	u16 fc, rate_mask;
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_r;
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RATE("enter\n");
 
-	rcu_read_lock();
-
-	sta = sta_info_get(local, hdr->addr1);
-
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
 	fc = le16_to_cpu(hdr->frame_control);
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
 	    is_multicast_ether_addr(hdr->addr1) ||
-	    !sta || !sta->rate_ctrl_priv) {
+	    !sta || !priv_sta) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
-		sel->rate_idx = rate_lowest_index(local, sband, sta);
-		rcu_read_unlock();
+		sel->rate_idx = rate_lowest_index(sband, sta);
 		return;
 	}
 
-	rs_sta = (void *)sta->rate_ctrl_priv;
-
-	rate_mask = sta->sta.supp_rates[sband->band];
+	rate_mask = sta->supp_rates[sband->band];
 	index = min(rs_sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT - 1);
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
@@ -811,8 +797,6 @@ static void rs_get_rate(void *priv_rate,
 	else
 		sel->rate_idx = rs_sta->last_txrate_idx;
 
-	rcu_read_unlock();
-
 	IWL_DEBUG_RATE("leave: %d\n", index);
 }
 
@@ -829,114 +813,28 @@ static struct rate_control_ops rs_ops = 
 	.free_sta = rs_free_sta,
 };
 
-int iwl3945_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct iwl3945_priv *priv = hw->priv;
-	struct iwl3945_rs_sta *rs_sta;
-	struct sta_info *sta;
-	unsigned long flags;
-	int count = 0, i;
-	u32 samples = 0, success = 0, good = 0;
-	unsigned long now = jiffies;
-	u32 max_time = 0;
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, priv->stations[sta_id].sta.sta.addr);
-	if (!sta || !sta->rate_ctrl_priv) {
-		if (sta)
-			IWL_DEBUG_RATE("leave - no private rate data!\n");
-		else
-			IWL_DEBUG_RATE("leave - no station!\n");
-		rcu_read_unlock();
-		return sprintf(buf, "station %d not found\n", sta_id);
-	}
-
-	rs_sta = (void *)sta->rate_ctrl_priv;
-	spin_lock_irqsave(&rs_sta->lock, flags);
-	i = IWL_RATE_54M_INDEX;
-	while (1) {
-		u64 mask;
-		int j;
-
-		count +=
-		    sprintf(&buf[count], " %2dMbs: ", iwl3945_rates[i].ieee / 2);
-
-		mask = (1ULL << (IWL_RATE_MAX_WINDOW - 1));
-		for (j = 0; j < IWL_RATE_MAX_WINDOW; j++, mask >>= 1)
-			buf[count++] =
-			    (rs_sta->win[i].data & mask) ? '1' : '0';
-
-		samples += rs_sta->win[i].counter;
-		good += rs_sta->win[i].success_counter;
-		success += rs_sta->win[i].success_counter *
-						iwl3945_rates[i].ieee;
-
-		if (rs_sta->win[i].stamp) {
-			int delta =
-			    jiffies_to_msecs(now - rs_sta->win[i].stamp);
-
-			if (delta > max_time)
-				max_time = delta;
-
-			count += sprintf(&buf[count], "%5dms\n", delta);
-		} else
-			buf[count++] = '\n';
-
-		j = iwl3945_get_prev_ieee_rate(i);
-		if (j == i)
-			break;
-		i = j;
-	}
-	spin_unlock_irqrestore(&rs_sta->lock, flags);
-	rcu_read_unlock();
-
-	/* Display the average rate of all samples taken.
-	 *
-	 * NOTE:  We multiple # of samples by 2 since the IEEE measurement
-	 * added from iwl3945_rates is actually 2X the rate */
-	if (samples)
-		count += sprintf(
-			&buf[count],
-			"\nAverage rate is %3d.%02dMbs over last %4dms\n"
-			"%3d%% success (%d good packets over %d tries)\n",
-			success / (2 * samples), (success * 5 / samples) % 10,
-			max_time, good * 100 / samples, good, samples);
-	else
-		count += sprintf(&buf[count], "\nAverage rate: 0Mbs\n");
-
-	return count;
-}
-
 void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 {
 	struct iwl3945_priv *priv = hw->priv;
 	s32 rssi = 0;
 	unsigned long flags;
-	struct ieee80211_local *local = hw_to_local(hw);
 	struct iwl3945_rs_sta *rs_sta;
-	struct sta_info *sta;
+	struct ieee80211_sta *sta;
+	struct iwl3945_sta_priv *psta;
 
 	IWL_DEBUG_RATE("enter\n");
 
-	if (!local->rate_ctrl->ops->name ||
-	    strcmp(local->rate_ctrl->ops->name, RS_NAME)) {
-		IWL_WARNING("iwl-3945-rs not selected as rate control algo!\n");
-		IWL_DEBUG_RATE("leave - mac80211 picked the wrong RC algo.\n");
-		return;
-	}
-
 	rcu_read_lock();
 
-	sta = sta_info_get(local, priv->stations[sta_id].sta.sta.addr);
-	if (!sta || !sta->rate_ctrl_priv) {
+	sta = ieee80211_find_sta(hw, priv->stations[sta_id].sta.sta.addr);
+	psta = (void *) sta->drv_priv;
+	if (!sta || !psta) {
 		IWL_DEBUG_RATE("leave - no private rate data!\n");
 		rcu_read_unlock();
 		return;
 	}
 
-	rs_sta = (void *)sta->rate_ctrl_priv;
+	rs_sta = psta->rs_sta;
 
 	spin_lock_irqsave(&rs_sta->lock, flags);
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-18 17:53:17.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-18 17:53:23.000000000 +0200
@@ -35,8 +35,6 @@
 
 #include <linux/workqueue.h>
 
-#include "../net/mac80211/rate.h"
-
 #include "iwl-dev.h"
 #include "iwl-sta.h"
 #include "iwl-core.h"
@@ -169,9 +167,9 @@ struct iwl_lq_sta {
 };
 
 static void rs_rate_scale_perform(struct iwl_priv *priv,
-				   struct net_device *dev,
 				   struct ieee80211_hdr *hdr,
-				   struct sta_info *sta);
+				   struct ieee80211_sta *sta,
+				   struct iwl_lq_sta *lq_sta);
 static void rs_fill_link_cmd(const struct iwl_priv *priv,
 			     struct iwl_lq_sta *lq_sta, u32 rate_n_flags);
 
@@ -357,20 +355,20 @@ static u32 rs_tl_get_load(struct iwl_lq_
 
 static void rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 				      struct iwl_lq_sta *lq_data, u8 tid,
-				      struct sta_info *sta)
+				      struct ieee80211_sta *sta)
 {
 	DECLARE_MAC_BUF(mac);
 
 	if (rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
 		IWL_DEBUG_HT("Starting Tx agg: STA: %s tid: %d\n",
-				print_mac(mac, sta->sta.addr), tid);
-		ieee80211_start_tx_ba_session(priv->hw, sta->sta.addr, tid);
+				print_mac(mac, sta->addr), tid);
+		ieee80211_start_tx_ba_session(priv->hw, sta->addr, tid);
 	}
 }
 
 static void rs_tl_turn_on_agg(struct iwl_priv *priv, u8 tid,
 			      struct iwl_lq_sta *lq_data,
-			      struct sta_info *sta)
+			      struct ieee80211_sta *sta)
 {
 	if ((tid < TID_MAX_LOAD_COUNT))
 		rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta);
@@ -770,7 +768,8 @@ out:
 /*
  * mac80211 sends us Tx status
  */
-static void rs_tx_status(void *priv_rate, struct net_device *dev,
+static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
+			 struct ieee80211_sta *sta, void *priv_sta,
 			 struct sk_buff *skb)
 {
 	int status;
@@ -778,11 +777,9 @@ static void rs_tx_status(void *priv_rate
 	int rs_index, index = 0;
 	struct iwl_lq_sta *lq_sta;
 	struct iwl_link_quality_cmd *table;
-	struct sta_info *sta;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw *hw = local_to_hw(local);
+	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
+	struct ieee80211_hw *hw = priv->hw;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_rate_scale_data *window = NULL;
 	struct iwl_rate_scale_data *search_win = NULL;
@@ -808,15 +805,7 @@ static void rs_tx_status(void *priv_rate
 	if (retries > 15)
 		retries = 15;
 
-	rcu_read_lock();
-
-	sta = sta_info_get(local, hdr->addr1);
-
-	if (!sta || !sta->rate_ctrl_priv)
-		goto out;
-
-
-	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
+	lq_sta = (struct iwl_lq_sta *)priv_sta;
 
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !lq_sta->ibss_sta_added)
@@ -962,9 +951,8 @@ static void rs_tx_status(void *priv_rate
 	}
 
 	/* See if there's a better rate or modulation mode to try. */
-	rs_rate_scale_perform(priv, dev, hdr, sta);
+	rs_rate_scale_perform(priv, hdr, sta, lq_sta);
 out:
-	rcu_read_unlock();
 	return;
 }
 
@@ -1140,7 +1128,7 @@ static s32 rs_get_best_rate(struct iwl_p
 static int rs_switch_to_mimo2(struct iwl_priv *priv,
 			     struct iwl_lq_sta *lq_sta,
 			     struct ieee80211_conf *conf,
-			     struct sta_info *sta,
+			     struct ieee80211_sta *sta,
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
 	u16 rate_mask;
@@ -1148,10 +1136,10 @@ static int rs_switch_to_mimo2(struct iwl
 	s8 is_green = lq_sta->is_green;
 
 	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) ||
-	    !sta->sta.ht_info.ht_supported)
+	    !sta->ht_info.ht_supported)
 		return -1;
 
-	if (((sta->sta.ht_info.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
+	if (((sta->ht_info.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
 						== WLAN_HT_CAP_SM_PS_STATIC)
 		return -1;
 
@@ -1208,7 +1196,7 @@ static int rs_switch_to_mimo2(struct iwl
 static int rs_switch_to_siso(struct iwl_priv *priv,
 			     struct iwl_lq_sta *lq_sta,
 			     struct ieee80211_conf *conf,
-			     struct sta_info *sta,
+			     struct ieee80211_sta *sta,
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
 	u16 rate_mask;
@@ -1216,7 +1204,7 @@ static int rs_switch_to_siso(struct iwl_
 	s32 rate;
 
 	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) ||
-	    !sta->sta.ht_info.ht_supported)
+	    !sta->ht_info.ht_supported)
 		return -1;
 
 	IWL_DEBUG_RATE("LQ: try to switch to SISO\n");
@@ -1268,7 +1256,7 @@ static int rs_switch_to_siso(struct iwl_
 static int rs_move_legacy_other(struct iwl_priv *priv,
 				struct iwl_lq_sta *lq_sta,
 				struct ieee80211_conf *conf,
-				struct sta_info *sta,
+				struct ieee80211_sta *sta,
 				int index)
 {
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
@@ -1376,7 +1364,7 @@ out:
 static int rs_move_siso_to_other(struct iwl_priv *priv,
 				 struct iwl_lq_sta *lq_sta,
 				 struct ieee80211_conf *conf,
-				 struct sta_info *sta, int index)
+				 struct ieee80211_sta *sta, int index)
 {
 	u8 is_green = lq_sta->is_green;
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
@@ -1487,7 +1475,7 @@ static int rs_move_siso_to_other(struct 
 static int rs_move_mimo_to_other(struct iwl_priv *priv,
 				 struct iwl_lq_sta *lq_sta,
 				 struct ieee80211_conf *conf,
-				 struct sta_info *sta, int index)
+				 struct ieee80211_sta *sta, int index)
 {
 	s8 is_green = lq_sta->is_green;
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
@@ -1680,12 +1668,11 @@ static void rs_stay_in_table(struct iwl_
  * Do rate scaling and search for new modulation mode.
  */
 static void rs_rate_scale_perform(struct iwl_priv *priv,
-				  struct net_device *dev,
 				  struct ieee80211_hdr *hdr,
-				  struct sta_info *sta)
+				  struct ieee80211_sta *sta,
+				  struct iwl_lq_sta *lq_sta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw *hw = local_to_hw(local);
+	struct ieee80211_hw *hw = priv->hw;
 	struct ieee80211_conf *conf = &hw->conf;
 	int low = IWL_RATE_INVALID;
 	int high = IWL_RATE_INVALID;
@@ -1700,7 +1687,6 @@ static void rs_rate_scale_perform(struct
 	__le16 fc;
 	u16 rate_mask;
 	u8 update_lq = 0;
-	struct iwl_lq_sta *lq_sta;
 	struct iwl_scale_tbl_info *tbl, *tbl1;
 	u16 rate_scale_index_msk = 0;
 	u32 rate;
@@ -1721,11 +1707,10 @@ static void rs_rate_scale_perform(struct
 		return;
 	}
 
-	if (!sta || !sta->rate_ctrl_priv)
+	if (!sta || !lq_sta)
 		return;
 
-	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
-	lq_sta->supp_rates = sta->sta.supp_rates[lq_sta->band];
+	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
 
 	tid = rs_tl_add_packet(lq_sta, hdr);
 
@@ -2064,9 +2049,9 @@ out:
 
 static void rs_initialize_lq(struct iwl_priv *priv,
 			     struct ieee80211_conf *conf,
-			     struct sta_info *sta)
+			     struct ieee80211_sta *sta,
+			     struct iwl_lq_sta *lq_sta)
 {
-	struct iwl_lq_sta *lq_sta;
 	struct iwl_scale_tbl_info *tbl;
 	int rate_idx;
 	int i;
@@ -2075,10 +2060,9 @@ static void rs_initialize_lq(struct iwl_
 	u8 active_tbl = 0;
 	u8 valid_tx_ant;
 
-	if (!sta || !sta->rate_ctrl_priv)
+	if (!sta || !lq_sta)
 		goto out;
 
-	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
 	i = lq_sta->last_txrate_idx;
 
 	if ((lq_sta->lq.sta_id == 0xff) &&
@@ -2119,37 +2103,30 @@ static void rs_initialize_lq(struct iwl_
 	return;
 }
 
-static void rs_get_rate(void *priv_rate, struct net_device *dev,
-			struct ieee80211_supported_band *sband,
-			struct sk_buff *skb,
-			struct rate_selection *sel)
+static void rs_get_rate(void *priv_r, struct ieee80211_supported_band *sband,
+			struct ieee80211_sta *sta, void *priv_sta,
+			struct sk_buff *skb, struct rate_selection *sel)
 {
 
 	int i;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_conf *conf = &local->hw.conf;
+	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
+	struct ieee80211_conf *conf = &priv->hw->conf;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct sta_info *sta;
 	__le16 fc;
-	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
 	struct iwl_lq_sta *lq_sta;
 
 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
 
-	rcu_read_lock();
-
-	sta = sta_info_get(local, hdr->addr1);
-
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
 	fc = hdr->frame_control;
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
-	    !sta || !sta->rate_ctrl_priv) {
-		sel->rate_idx = rate_lowest_index(local, sband, sta);
-		goto out;
+	    !sta || !priv_sta) {
+		sel->rate_idx = rate_lowest_index(sband, sta);
+		return;
 	}
 
-	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
+	lq_sta = (struct iwl_lq_sta *)priv_sta;
 	i = lq_sta->last_txrate_idx;
 
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
@@ -2167,23 +2144,22 @@ static void rs_get_rate(void *priv_rate,
 			lq_sta->lq.sta_id = sta_id;
 			lq_sta->lq.rs_table[0].rate_n_flags = 0;
 			lq_sta->ibss_sta_added = 1;
-			rs_initialize_lq(priv, conf, sta);
+			rs_initialize_lq(priv, conf, sta, lq_sta);
 		}
 	}
 
 	if ((i < 0) || (i > IWL_RATE_COUNT)) {
-		sel->rate_idx = rate_lowest_index(local, sband, sta);
-		goto out;
+		sel->rate_idx = rate_lowest_index(sband, sta);
+		return;
 	}
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
 		i -= IWL_FIRST_OFDM_RATE;
 	sel->rate_idx = i;
-out:
-	rcu_read_unlock();
 }
 
-static void *rs_alloc_sta(void *priv_rate, gfp_t gfp)
+static void *rs_alloc_sta(void *priv_rate, struct ieee80211_sta *sta,
+			  gfp_t gfp)
 {
 	struct iwl_lq_sta *lq_sta;
 	struct iwl_priv *priv;
@@ -2206,20 +2182,16 @@ static void *rs_alloc_sta(void *priv_rat
 	return lq_sta;
 }
 
-static void rs_rate_init(void *priv_rate, void *priv_sta,
-			 struct ieee80211_local *local,
-			 struct sta_info *sta)
+static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
+			 struct ieee80211_sta *sta, void *priv_sta)
 {
 	int i, j;
-	struct ieee80211_conf *conf = &local->hw.conf;
-	struct ieee80211_supported_band *sband;
-	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
+	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
+	struct ieee80211_conf *conf = &priv->hw->conf;
 	struct iwl_lq_sta *lq_sta = priv_sta;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
 	lq_sta->flush_timer = 0;
-	lq_sta->supp_rates = sta->sta.supp_rates[sband->band];
+	lq_sta->supp_rates = sta->supp_rates[sband->band];
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
@@ -2232,17 +2204,17 @@ static void rs_rate_init(void *priv_rate
 
 	lq_sta->ibss_sta_added = 0;
 	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		u8 sta_id = iwl_find_station(priv, sta->sta.addr);
+		u8 sta_id = iwl_find_station(priv, sta->addr);
 		DECLARE_MAC_BUF(mac);
 
 		/* for IBSS the call are from tasklet */
 		IWL_DEBUG_RATE("LQ: ADD station %s\n",
-			     print_mac(mac, sta->sta.addr));
+			     print_mac(mac, sta->addr));
 
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE("LQ: ADD station %s\n",
-				       print_mac(mac, sta->sta.addr));
-			sta_id = iwl_add_station_flags(priv, sta->sta.addr,
+				       print_mac(mac, sta->addr));
+			sta_id = iwl_add_station_flags(priv, sta->addr,
 							0, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
@@ -2256,11 +2228,11 @@ static void rs_rate_init(void *priv_rate
 	/* Find highest tx rate supported by hardware and destination station */
 	lq_sta->last_txrate_idx = 3;
 	for (i = 0; i < sband->n_bitrates; i++)
-		if (sta->sta.supp_rates[sband->band] & BIT(i))
+		if (sta->supp_rates[sband->band] & BIT(i))
 			lq_sta->last_txrate_idx = i;
 
 	/* For MODE_IEEE80211A, skip over cck rates in global rate table */
-	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
+	if (sband->band == IEEE80211_BAND_5GHZ)
 		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 
 	lq_sta->is_dup = 0;
@@ -2301,7 +2273,7 @@ static void rs_rate_init(void *priv_rate
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
 	lq_sta->drv = priv;
 
-	rs_initialize_lq(priv, conf, sta);
+	rs_initialize_lq(priv, conf, sta, lq_sta);
 }
 
 static void rs_fill_link_cmd(const struct iwl_priv *priv,
@@ -2423,9 +2395,9 @@ static void rs_fill_link_cmd(const struc
 	lq_cmd->agg_params.agg_time_limit = cpu_to_le16(4000);
 }
 
-static void *rs_alloc(struct ieee80211_local *local)
+static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
-	return local->hw.priv;
+	return hw->priv;
 }
 /* rate scale requires free function to be implemented */
 static void rs_free(void *priv_rate)
@@ -2446,12 +2418,12 @@ static void rs_clear(void *priv_rate)
 #endif /* CONFIG_IWLWIFI_DEBUG */
 }
 
-static void rs_free_sta(void *priv_rate, void *priv_sta)
+static void rs_free_sta(void *priv_r, struct ieee80211_sta *sta,
+			void *priv_sta)
 {
 	struct iwl_lq_sta *lq_sta = priv_sta;
-	struct iwl_priv *priv;
+	struct iwl_priv *priv = priv_r;
 
-	priv = (struct iwl_priv *)priv_rate;
 	IWL_DEBUG_RATE("enter\n");
 	kfree(lq_sta);
 	IWL_DEBUG_RATE("leave\n");
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.h	2008-09-18 17:53:17.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.h	2008-09-18 17:53:23.000000000 +0200
@@ -176,15 +176,6 @@ static inline u8 iwl3945_get_prev_ieee_r
 }
 
 /**
- * iwl3945_fill_rs_info - Fill an output text buffer with the rate representation
- *
- * NOTE:  This is provided as a quick mechanism for a user to visualize
- * the performance of the rate control algorithm and is not meant to be
- * parsed software.
- */
-extern int iwl3945_fill_rs_info(struct ieee80211_hw *, char *buf, u8 sta_id);
-
-/**
  * iwl3945_rate_scale_init - Initialize the rate scale table based on assoc info
  *
  * The specific throughput table used is based on the type of network
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-09-18 17:53:17.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-09-18 17:53:23.000000000 +0200
@@ -7370,15 +7370,6 @@ static ssize_t show_temperature(struct d
 
 static DEVICE_ATTR(temperature, S_IRUGO, show_temperature, NULL);
 
-static ssize_t show_rs_window(struct device *d,
-			      struct device_attribute *attr,
-			      char *buf)
-{
-	struct iwl3945_priv *priv = d->driver_data;
-	return iwl3945_fill_rs_info(priv->hw, buf, IWL_AP_ID);
-}
-static DEVICE_ATTR(rs_window, S_IRUGO, show_rs_window, NULL);
-
 static ssize_t show_tx_power(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
@@ -7840,7 +7831,6 @@ static struct attribute *iwl3945_sysfs_e
 #endif
 	&dev_attr_power_level.attr,
 	&dev_attr_retry_rate.attr,
-	&dev_attr_rs_window.attr,
 	&dev_attr_statistics.attr,
 	&dev_attr_status.attr,
 	&dev_attr_temperature.attr,
@@ -7908,6 +7898,7 @@ static int iwl3945_pci_probe(struct pci_
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	hw->rate_control_algorithm = "iwl-3945-rs";
+	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
 
 	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
 	priv = hw->priv;
--- everything.orig/net/mac80211/rc80211_pid.h	2008-09-18 17:53:17.000000000 +0200
+++ everything/net/mac80211/rc80211_pid.h	2008-09-18 17:53:23.000000000 +0200
@@ -124,7 +124,6 @@ struct rc_pid_events_file_info {
  * struct rc_pid_debugfs_entries - tunable parameters
  *
  * Algorithm parameters, tunable via debugfs.
- * @dir: the debugfs directory for a specific phy
  * @target: target percentage for failed frames
  * @sampling_period: error sampling interval in milliseconds
  * @coeff_p: absolute value of the proportional coefficient
@@ -143,7 +142,6 @@ struct rc_pid_events_file_info {
  *	ordering of rates)
  */
 struct rc_pid_debugfs_entries {
-	struct dentry *dir;
 	struct dentry *target;
 	struct dentry *sampling_period;
 	struct dentry *coeff_p;
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-18 17:53:17.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-18 17:53:23.000000000 +0200
@@ -724,6 +724,8 @@ struct ieee80211_local {
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
+		struct dentry *rcdir;
+		struct dentry *rcname;
 		struct dentry *frequency;
 		struct dentry *antenna_sel_tx;
 		struct dentry *antenna_sel_rx;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-09-18 17:53:17.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-09-18 17:53:23.000000000 +0200
@@ -73,6 +73,10 @@ extern struct pci_device_id iwl3945_hw_c
 extern int iwl3945_param_hwcrypto;
 extern int iwl3945_param_queues_num;
 
+struct iwl3945_sta_priv {
+	struct iwl3945_rs_sta *rs_sta;
+};
+
 enum iwl3945_antenna {
 	IWL_ANTENNA_DIVERSITY,
 	IWL_ANTENNA_MAIN,
--- everything.orig/net/mac80211/sta_info.h	2008-09-18 17:53:16.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-09-18 17:53:23.000000000 +0200
@@ -416,7 +416,7 @@ static inline u32 get_sta_flags(struct s
 /*
  * Get a STA info, must have be under RCU read lock.
  */
-struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr);
+struct sta_info *sta_info_get(struct ieee80211_local *local, const u8 *addr);
 /*
  * Get STA info by index, BROKEN!
  */


