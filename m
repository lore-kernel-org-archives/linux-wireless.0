Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163149AbeE1NfT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 09:35:19 -0400
From: Sriram R <srirrama@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [RFCv2 2/2] mac80211: Add support for per-rate rx statistics
Date: Mon, 28 May 2018 19:04:39 +0530
Message-Id: <1527514479-6696-3-git-send-email-srirrama@codeaurora.org> (sfid-20180528_153607_815747_63340DEC)
In-Reply-To: <1527514479-6696-1-git-send-email-srirrama@codeaurora.org>
References: <1527514479-6696-1-git-send-email-srirrama@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for the mac80211 to collect rx statistics
(Packet count and total bytes received) per-rate, per-station when
subscribed by user space clients.

Note that the rate field passed on to the userspace from mac80211
is an encoded value where different rate attributes such as
type(VHT/HT/Legacy), MCS, BW, NSS, GI are collectively used to encode to
this rate and the userspace has to take care of decoding it.This is
done so as to allow scalability in future.

Once subscribers to the rate stats exist, each packet received is recorded
per rate and stored as an entry(per rate) in a hashtable with the encoded rate
being the key for the hashtable. As the rate changes, new entries gets added
into this table and this information will be populated and sent back
to userspace whenever a certain limit is hit , Say when Packet count is greater
than 65000 or the number of rate entries exceed say a count of 10,after
which these entries are cleared and new stats gets collected.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 net/mac80211/cfg.c         |  36 ++++++++
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/main.c        |   2 +
 net/mac80211/rx.c          |  10 ++-
 net/mac80211/sta_info.c    | 212 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h    |  20 +++++
 6 files changed, 280 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bdf6fa7..03a2dab 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3803,6 +3803,41 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	return ret;
 }
 
+static void
+ieee80211_rate_stats(struct wiphy *wiphy, enum cfg80211_rate_stats_ops ops)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct sta_info *sta;
+
+	mutex_lock(&local->sta_mtx);
+
+	switch (ops) {
+	case CFG80211_RATE_STATS_START:
+		local->rate_stats_active = true;
+		list_for_each_entry(sta, &local->sta_list, list) {
+			ieee80211_sta_rate_table_init(sta);
+		}
+		break;
+
+	case CFG80211_RATE_STATS_STOP:
+		local->rate_stats_active = false;
+		list_for_each_entry(sta, &local->sta_list, list) {
+			ieee80211_sta_rate_table_free(sta->rate_table);
+			RCU_INIT_POINTER(sta->rate_table, NULL);
+		}
+		break;
+
+	case CFG80211_RATE_STATS_DUMP:
+		list_for_each_entry(sta, &local->sta_list, list) {
+				    ieee80211_queue_work(&local->hw,
+				    &sta->rate_stats_dump_wk);
+		}
+		break;
+	}
+
+	mutex_unlock(&local->sta_mtx);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3897,4 +3932,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
 	.tx_control_port = ieee80211_tx_control_port,
 	.get_txq_stats = ieee80211_get_txq_stats,
+	.rate_stats = ieee80211_rate_stats,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d1978aa..60810e1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1384,6 +1384,8 @@ struct ieee80211_local {
 	/* TDLS channel switch */
 	struct work_struct tdls_chsw_work;
 	struct sk_buff_head skb_queue_tdls_chsw;
+
+	bool rate_stats_active;
 };
 
 static inline struct ieee80211_sub_if_data *
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4d2e797..030d19f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -570,6 +570,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_RRM);
 
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_RATE_STATS);
+
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss);
 
 	local = wiphy_priv(wiphy);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0a38cc1..0f63b18 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1561,9 +1561,11 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		    test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
 			sta->rx_stats.last_rx = jiffies;
 			if (ieee80211_is_data(hdr->frame_control) &&
-			    !is_multicast_ether_addr(hdr->addr1))
+			    !is_multicast_ether_addr(hdr->addr1)) {
 				sta->rx_stats.last_rate =
 					sta_stats_encode_rate(status);
+				ieee80211_sta_update_rate_stats(&sta);
+			}
 		}
 	} else if (rx->sdata->vif.type == NL80211_IFTYPE_OCB) {
 		sta->rx_stats.last_rx = jiffies;
@@ -1573,8 +1575,10 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		 * match the current local configuration when processed.
 		 */
 		sta->rx_stats.last_rx = jiffies;
-		if (ieee80211_is_data(hdr->frame_control))
+		if (ieee80211_is_data(hdr->frame_control)) {
 			sta->rx_stats.last_rate = sta_stats_encode_rate(status);
+			ieee80211_sta_update_rate_stats(&sta);
+		}
 	}
 
 	if (rx->sdata->vif.type == NL80211_IFTYPE_STATION)
@@ -4067,6 +4071,8 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	stats->last_rx = jiffies;
 	stats->last_rate = sta_stats_encode_rate(status);
 
+	ieee80211_sta_update_rate_stats(&sta);
+
 	stats->fragments++;
 	stats->packets++;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6428f1a..b460f0d6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -31,6 +31,8 @@
 #include "mesh.h"
 #include "wme.h"
 
+void ieee80211_rate_stats_dump(struct work_struct *wk);
+
 /**
  * DOC: STA information lifetime rules
  *
@@ -324,6 +326,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	spin_lock_init(&sta->ps_lock);
 	INIT_WORK(&sta->drv_deliver_wk, sta_deliver_ps_frames);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
+	INIT_WORK(&sta->rate_stats_dump_wk, ieee80211_rate_stats_dump);
 	mutex_init(&sta->ampdu_mlme.mtx);
 #ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
@@ -609,6 +612,11 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
 
+	RCU_INIT_POINTER(sta->rate_table, NULL);
+
+	if (local->rate_stats_active)
+		ieee80211_sta_rate_table_init(sta);
+
 	return 0;
  out_remove:
 	sta_info_hash_del(local, sta);
@@ -1006,6 +1014,10 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
 
+	ieee80211_sta_rate_table_free(sta->rate_table);
+
+	RCU_INIT_POINTER(sta->rate_table, NULL);
+
 	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
 	if (sinfo)
 		sta_set_sinfo(sta, sinfo, true);
@@ -2371,3 +2383,203 @@ void ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
 
 	sta_update_codel_params(sta, thr);
 }
+
+static u32 rate_table_hash(const void *rate, u32 len, u32 seed)
+{
+	return jhash_1word(*(u32 *)rate, seed);
+}
+
+static const struct rhashtable_params rate_rht_params = {
+	.nelem_hint = 5,
+	.automatic_shrinking = true,
+	.key_len = IEEE80211_ENCODED_RATE_LEN,
+	.key_offset = offsetof(struct ieee80211_sta_rate_entry, rate),
+	.head_offset = offsetof(struct ieee80211_sta_rate_entry, rhash),
+	.hashfn = rate_table_hash,
+};
+
+int ieee80211_sta_rate_table_init(struct sta_info *sta)
+{
+	struct rhashtable *new_rt;
+
+	new_rt = kmalloc(sizeof(*sta->rate_table), GFP_KERNEL);
+	rcu_assign_pointer(sta->rate_table, new_rt);
+
+	if (!sta->rate_table)
+		return -ENOMEM;
+
+	return rhashtable_init(sta->rate_table, &rate_rht_params);
+}
+
+static struct ieee80211_sta_rate_entry*
+ieee80211_sta_rate_table_lookup(struct rhashtable *rate_table, u32 rate)
+{
+	if (!rate_table)
+		return NULL;
+
+	return rhashtable_lookup_fast(rate_table, &rate, rate_rht_params);
+}
+
+static int
+ieee80211_sta_rate_entry_insert(struct rhashtable *rate_table,
+				struct ieee80211_sta_rate_entry *entry)
+{
+	if (!rate_table)
+		return -EINVAL;
+
+	return rhashtable_lookup_insert_fast(rate_table, &entry->rhash,
+					     rate_rht_params);
+}
+
+static void ieee80211_sta_rate_entry_free(void *ptr, void *arg)
+{
+	struct ieee80211_sta_rate_entry *entry = ptr;
+
+	kfree_rcu(entry, rcu);
+}
+
+void ieee80211_sta_rate_table_free(struct rhashtable *rate_table)
+{
+	if (!rate_table)
+		return;
+	rhashtable_free_and_destroy(rate_table,
+				    ieee80211_sta_rate_entry_free, NULL);
+	kfree(rate_table);
+}
+
+static int
+ieee80211_sta_get_rate_stats_report(struct rhashtable *rate_table,
+				    struct cfg80211_rate_stats **report_buf,
+				    int *len)
+{
+	int i = 0, ret, rt_len;
+	struct ieee80211_sta_rate_entry *entry = NULL;
+	struct rhashtable_iter iter;
+	struct cfg80211_rate_stats *report;
+
+	if (!rate_table)
+		return -EINVAL;
+
+	ret = rhashtable_walk_init(rate_table, &iter, GFP_KERNEL);
+
+	if (ret)
+		return -EINVAL;
+
+	rhashtable_walk_start(&iter);
+
+	rt_len = atomic_read(&(iter.ht->nelems));
+
+	/* Caller should take care of freeing this memory */
+	*report_buf = kzalloc(sizeof(struct cfg80211_rate_stats) * rt_len,
+			      GFP_KERNEL);
+
+	if (*report_buf  == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	while ((entry = rhashtable_walk_next(&iter))) {
+		if (IS_ERR(entry) && PTR_ERR(entry) == -EAGAIN)
+			continue;
+		if (IS_ERR(entry))
+			break;
+		if (i >= rt_len)
+			break;
+
+		report = *report_buf + i++;
+		report->rate = entry->rate;
+		report->packets = entry->packets;
+		report->bytes = entry->bytes;
+	}
+
+	*len = i;
+err:
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+	return ret;
+}
+
+void ieee80211_rate_stats_dump(struct work_struct *wk)
+{
+	struct sta_info *sta;
+	struct cfg80211_rate_stats *report_buf = NULL;
+	struct rhashtable *old_rate_table;
+	unsigned int len = 0;
+
+	sta = container_of(wk, struct sta_info, rate_stats_dump_wk);
+
+	if (sta->dead)
+		return;
+
+	synchronize_net();
+	mutex_lock(&sta->local->sta_mtx);
+	old_rate_table = rcu_dereference(sta->rate_table);
+	if (!old_rate_table) {
+		mutex_unlock(&sta->local->sta_mtx);
+		return;
+	}
+
+	ieee80211_sta_rate_table_init(sta);
+	mutex_unlock(&sta->local->sta_mtx);
+
+	ieee80211_sta_get_rate_stats_report(old_rate_table, &report_buf, &len);
+
+	cfg80211_report_rate_stats(sta->local->hw.wiphy, &sta->sdata->wdev,
+				   sta->sta.addr, len, report_buf,
+				   GFP_KERNEL);
+
+	ieee80211_sta_rate_table_free(old_rate_table);
+	kfree(report_buf);
+}
+
+void ieee80211_sta_update_rate_stats(struct sta_info **sta_ptr)
+{
+	struct ieee80211_sta_rate_entry *entry;
+	struct sta_info *sta = *sta_ptr;
+	struct rhashtable *current_rate_table;
+	struct ieee80211_rx_data *rx;
+	u32 rx_pkt_len;
+	u32 rate;
+	int ret;
+
+	if (!sta->local->rate_stats_active)
+		return;
+
+	rx = container_of(sta_ptr, struct ieee80211_rx_data, sta);
+
+	rx_pkt_len = rx->skb->len;
+	rate = sta->rx_stats.last_rate;
+
+	if (!sta->rate_table)
+		return;
+
+	rcu_read_lock();
+
+	current_rate_table = rcu_dereference(sta->rate_table);
+
+	entry = ieee80211_sta_rate_table_lookup(current_rate_table, rate);
+	if (!entry) {
+		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry) {
+			rcu_read_unlock();
+			return;
+		}
+		entry->rate = rate;
+		ret = ieee80211_sta_rate_entry_insert(current_rate_table, entry);
+		if (ret) {
+			kfree(entry);
+			rcu_read_unlock();
+			return;
+		}
+	}
+
+	entry->packets++;
+	entry->bytes += rx_pkt_len;
+
+	if ((atomic_read(&(current_rate_table->nelems)) >= MAX_RATE_TABLE_ELEMS)
+	    || (entry->packets >= MAX_RATE_TABLE_PACKETS)) {
+		ieee80211_queue_work(&sta->sdata->local->hw,
+				     &sta->rate_stats_dump_wk);
+	}
+	rcu_read_unlock();
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 81b35f6..8754e39 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -583,10 +583,25 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	struct rhashtable *rate_table;
+	struct work_struct rate_stats_dump_wk;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
 
+#define IEEE80211_ENCODED_RATE_LEN 4
+#define MAX_RATE_TABLE_ELEMS	   10
+#define MAX_RATE_TABLE_PACKETS	   65000
+
+struct ieee80211_sta_rate_entry {
+	u32 rate;
+	u32 bytes;
+	struct rcu_head rcu;
+	struct rhash_head rhash;
+	u16 packets;
+};
+
 static inline enum nl80211_plink_state sta_plink_state(struct sta_info *sta)
 {
 #ifdef CONFIG_MAC80211_MESH
@@ -759,6 +774,11 @@ void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 
 unsigned long ieee80211_sta_last_active(struct sta_info *sta);
 
+void ieee80211_sta_rate_table_free(struct rhashtable *rate_table);
+int ieee80211_sta_rate_table_init(struct sta_info *sta);
+void ieee80211_rate_stats_dump(struct work_struct *wk);
+void ieee80211_sta_update_rate_stats(struct sta_info **sta_ptr);
+
 enum sta_stats_type {
 	STA_STATS_RATE_TYPE_INVALID = 0,
 	STA_STATS_RATE_TYPE_LEGACY,
-- 
2.7.4
