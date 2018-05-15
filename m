Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbeEOFSj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 01:18:39 -0400
From: Sriram R <srirrama@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [RFC 2/2] mac80211: Add support for per-rate rx statistics
Date: Tue, 15 May 2018 10:48:01 +0530
Message-Id: <1526361481-7159-3-git-send-email-srirrama@codeaurora.org> (sfid-20180515_071853_701506_A168BEA0)
In-Reply-To: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
References: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for the mac80211 to collect
rx statistics (Packet count and total bytes received)
per-rate, per-station when enabled by a user space application.

Note that the rate field passed on to the userspace from mac80211
is an encoded value where different rate attributes such as
type(VHT/HT/Legacy), MCS, BW, NSS, GI are collectively used to encode to
this rate and the userspace has to take care of decoding it.This is
done so as to allow scalability in future.

Once statistics collection is enabled, each packet received is recorded
per rate and stored as an entry(per rate) in a hashtable with the encoded rate being
the key for the hashtable.As the rate changes, new entries gets added
into this table and this information will be populated and sent back
to userspace when requested. The lifetime of this table is from the enabling
of the per-rate stats feature to disabling it or when the sta gets disconnected.

Memory usage(on a 32-bit machine) by this feature would be,
	 96 bytes (static value, per STA for hash table usage)
	+28 bytes (increases per rate entry)
	+ 4 bytes (increases per hash bucket and rate is used as key.
		   Default is 16 buckets)

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 net/mac80211/cfg.c      |  47 ++++++++++++++
 net/mac80211/rx.c       |  10 ++-
 net/mac80211/sta_info.c | 165 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h |  17 +++++
 4 files changed, 237 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5ce9d12..abee3ff 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -703,6 +703,30 @@ static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static int
+ieee80211_dump_sta_rate_stats(struct wiphy *wiphy, struct net_device *dev,
+			      int idx, u8 *mac,
+			      struct sta_rate_stats **rate_stats_buf, int *len)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	int ret = -ENOENT;
+
+	mutex_lock(&local->sta_mtx);
+
+	sta = sta_info_get_by_idx(sdata, idx);
+	if (sta) {
+		memcpy(mac, sta->sta.addr, ETH_ALEN);
+		ret = ieee80211_sta_get_rate_stats_report(sta, rate_stats_buf,
+							  len);
+	}
+
+	mutex_unlock(&local->sta_mtx);
+
+	return ret;
+}
+
 static int ieee80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 				 int idx, struct survey_info *survey)
 {
@@ -732,6 +756,27 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static int
+ieee80211_get_sta_rate_stats(struct wiphy *wiphy, struct net_device *dev,
+			     const u8 *mac,
+			     struct sta_rate_stats **rate_stats_buf, int *len)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	int ret = -ENOENT;
+
+	mutex_lock(&local->sta_mtx);
+
+	sta = sta_info_get_bss(sdata, mac);
+	if (sta)
+		ret = ieee80211_sta_get_rate_stats_report(sta, rate_stats_buf,
+							  len);
+	mutex_unlock(&local->sta_mtx);
+
+	return ret;
+}
+
 static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 					 struct cfg80211_chan_def *chandef)
 {
@@ -3822,6 +3867,8 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.change_station = ieee80211_change_station,
 	.get_station = ieee80211_get_station,
 	.dump_station = ieee80211_dump_station,
+	.get_sta_rate_stats = ieee80211_get_sta_rate_stats,
+	.dump_sta_rate_stats = ieee80211_dump_sta_rate_stats,
 	.dump_survey = ieee80211_dump_survey,
 #ifdef CONFIG_MAC80211_MESH
 	.add_mpath = ieee80211_add_mpath,
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
index 43f34aa..7df30e7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -31,6 +31,8 @@
 #include "mesh.h"
 #include "wme.h"
 
+static void ieee80211_sta_rate_table_free(struct sta_info *sta);
+
 /**
  * DOC: STA information lifetime rules
  *
@@ -609,6 +611,11 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
 
+	/* Rate table can be allocated and initialized during rx
+	 * if rate stats collection is enabled.
+	 */
+	sta->rate_table = NULL;
+
 	return 0;
  out_remove:
 	sta_info_hash_del(local, sta);
@@ -1006,6 +1013,8 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
 
+	ieee80211_sta_rate_table_free(sta);
+
 	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
 	if (sinfo)
 		sta_set_sinfo(sta, sinfo);
@@ -2369,3 +2378,159 @@ void ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
 
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
+static int
+ieee80211_sta_rate_table_init(struct sta_info *sta)
+{
+	sta->rate_table = kmalloc(sizeof(*sta->rate_table), GFP_KERNEL);
+
+	if (!sta->rate_table)
+		return -ENOMEM;
+
+	return rhashtable_init(sta->rate_table, &rate_rht_params);
+}
+
+static struct ieee80211_sta_rate_entry*
+ieee80211_sta_rate_table_lookup(struct sta_info *sta, u32 rate)
+{
+	if (!sta->rate_table)
+		return NULL;
+
+	return rhashtable_lookup_fast(sta->rate_table, &rate, rate_rht_params);
+}
+
+static int
+ieee80211_sta_rate_entry_insert(struct sta_info *sta,
+				struct ieee80211_sta_rate_entry *entry)
+{
+	if (!sta->rate_table)
+		return -EINVAL;
+
+	return rhashtable_lookup_insert_fast(sta->rate_table, &entry->rhash,
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
+static void ieee80211_sta_rate_table_free(struct sta_info *sta)
+{
+	if (!sta->rate_table)
+		return;
+
+	rhashtable_free_and_destroy(sta->rate_table,
+				    ieee80211_sta_rate_entry_free, NULL);
+	kfree(sta->rate_table);
+}
+
+int ieee80211_sta_get_rate_stats_report(struct sta_info *sta,
+					struct sta_rate_stats **report_buf,
+					int *len)
+{
+	int i = 0, ret, rate_table_len;
+	struct ieee80211_sta_rate_entry *entry = NULL;
+	struct rhashtable_iter iter;
+	struct sta_rate_stats *report;
+
+	if (!sta->rate_table)
+		return -EINVAL;
+
+	ret = rhashtable_walk_init(sta->rate_table, &iter, GFP_KERNEL);
+
+	if (ret)
+		return -EINVAL;
+
+	rhashtable_walk_start(&iter);
+
+	rate_table_len = atomic_read(&sta->rate_table->nelems);
+
+	/* Caller should take care of freeing this memory */
+	*report_buf =  kzalloc(sizeof(struct sta_rate_stats) * rate_table_len,
+			       GFP_KERNEL);
+
+	if (report_buf  == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	while ((entry = rhashtable_walk_next(&iter))) {
+		if (IS_ERR(entry) && PTR_ERR(entry) == -EAGAIN)
+			continue;
+		if (IS_ERR(entry))
+			break;
+		if (i >= rate_table_len)
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
+void ieee80211_sta_update_rate_stats(struct sta_info **sta_ptr)
+{
+	struct ieee80211_sta_rate_entry *entry;
+	struct sta_info *sta = *sta_ptr;
+	struct ieee80211_rx_data *rx;
+	u64 rx_pkt_len;
+	u32 rate;
+	int ret;
+
+	/* TODO CHECK rate_stats collection is enabled(via debugfs?(TODO))
+	 * and return if it's not enabled
+	 */
+
+	rx = container_of(sta_ptr, struct ieee80211_rx_data, sta);
+
+	rx_pkt_len = rx->skb->len;
+	rate = sta->rx_stats.last_rate;
+
+	if (!sta->rate_table) {
+		ret = ieee80211_sta_rate_table_init(sta);
+		if (ret)
+			return;
+	}
+
+	rcu_read_lock();
+	entry = ieee80211_sta_rate_table_lookup(sta, rate);
+	if (!entry) {
+		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry)
+			return;
+		entry->rate = rate;
+		ret = ieee80211_sta_rate_entry_insert(sta, entry);
+		if (ret) {
+			kfree(entry);
+			return;
+		}
+	}
+
+	entry->packets++;
+	entry->bytes += rx_pkt_len;
+	rcu_read_unlock();
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d79bd6e..ff3dcea 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -583,10 +583,22 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	struct rhashtable *rate_table;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
 
+#define IEEE80211_ENCODED_RATE_LEN 4
+
+struct ieee80211_sta_rate_entry {
+	u32 rate;
+	u32 packets;
+	u64 bytes;
+	struct rcu_head rcu;
+	struct rhash_head rhash;
+};
+
 static inline enum nl80211_plink_state sta_plink_state(struct sta_info *sta)
 {
 #ifdef CONFIG_MAC80211_MESH
@@ -758,6 +770,11 @@ void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 
 unsigned long ieee80211_sta_last_active(struct sta_info *sta);
 
+int ieee80211_sta_get_rate_stats_report(struct sta_info *sta,
+					struct sta_rate_stats **report_buf,
+					int *len);
+void ieee80211_sta_update_rate_stats(struct sta_info **sta_ptr);
+
 enum sta_stats_type {
 	STA_STATS_RATE_TYPE_INVALID = 0,
 	STA_STATS_RATE_TYPE_LEGACY,
-- 
2.7.4
