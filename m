Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51135 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbaIWVSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 17:18:09 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 03/10] ath10k: support ethtool stats.
Date: Tue, 23 Sep 2014 14:17:18 -0700
Message-Id: <1411507045-18973-3-git-send-email-greearb@candelatech.com> (sfid-20140923_231825_427312_5655AFA8)
In-Reply-To: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Add support for reading firmware stats through the ethtool
API.  This may be easier for applications to manipulate
compared to parsing a text based debugfs file.

This patch also adds and reports firmware reset and
crash counters.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Add data-lock around assignment of the stats.
     Update changelog to mention firmware reset/crash
     counters.

 drivers/net/wireless/ath/ath10k/core.h  |   4 +
 drivers/net/wireless/ath/ath10k/debug.c | 146 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |   9 ++
 drivers/net/wireless/ath/ath10k/mac.c   |   5 ++
 drivers/net/wireless/ath/ath10k/pci.c   |   4 +
 5 files changed, 168 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2f1d509..7b220b1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -541,6 +541,10 @@ struct ath10k {
 
 	struct dfs_pattern_detector *dfs_detector;
 
+	u32 fw_crash_counter;
+	u32 fw_warm_reset_counter;
+	u32 fw_cold_reset_counter;
+
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index c2c02ce..af1ca3e 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1037,6 +1037,152 @@ exit:
 	return ret;
 }
 
+#ifdef CONFIG_ATH10K_DEBUGFS
+/* TODO:  Would be nice to always support ethtool stats, would need to
+ * move the stats storage out of ath10k_debug, or always have ath10k_debug
+ * struct available..
+ */
+
+/* This generally cooresponds to the debugfs fw_stats file */
+static const char ath10k_gstrings_stats[][ETH_GSTRING_LEN] = {
+	"tx_pkts_nic",
+	"tx_bytes_nic",
+	"rx_pkts_nic",
+	"rx_bytes_nic",
+	"d_noise_floor",
+	"d_cycle_count",
+	"d_phy_error",
+	"d_rts_bad",
+	"d_rts_good",
+	"d_tx_power", /* in .5 dbM I think */
+	"d_rx_crc_err", /* fcs_bad */
+	"d_no_beacon",
+	"d_tx_mpdus_queued",
+	"d_tx_msdu_queued",
+	"d_tx_msdu_dropped",
+	"d_local_enqued",
+	"d_local_freed",
+	"d_tx_ppdu_hw_queued",
+	"d_tx_ppdu_reaped",
+	"d_tx_fifo_underrun",
+	"d_tx_ppdu_abort",
+	"d_tx_mpdu_requed",
+	"d_tx_excessive_retries",
+	"d_tx_hw_rate",
+	"d_tx_dropped_sw_retries",
+	"d_tx_illegal_rate",
+	"d_tx_continuous_xretries",
+	"d_tx_timeout",
+	"d_tx_mpdu_txop_limit",
+	"d_pdev_resets",
+	"d_rx_mid_ppdu_route_change",
+	"d_rx_status",
+	"d_rx_extra_frags_ring0",
+	"d_rx_extra_frags_ring1",
+	"d_rx_extra_frags_ring2",
+	"d_rx_extra_frags_ring3",
+	"d_rx_msdu_htt",
+	"d_rx_mpdu_htt",
+	"d_rx_msdu_stack",
+	"d_rx_mpdu_stack",
+	"d_rx_phy_err",
+	"d_rx_phy_err_drops",
+	"d_rx_mpdu_errors", /* FCS, MIC, ENC */
+	"d_fw_crash_count",
+	"d_fw_warm_reset_count",
+	"d_fw_cold_reset_count",
+};
+#define ATH10K_SSTATS_LEN ARRAY_SIZE(ath10k_gstrings_stats)
+
+void ath10k_get_et_strings(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   u32 sset, u8 *data)
+{
+	if (sset == ETH_SS_STATS)
+		memcpy(data, *ath10k_gstrings_stats,
+		       sizeof(ath10k_gstrings_stats));
+}
+
+int ath10k_get_et_sset_count(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif, int sset)
+{
+	if (sset == ETH_SS_STATS)
+		return ATH10K_SSTATS_LEN;
+	return 0;
+}
+
+void ath10k_get_et_stats(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 struct ethtool_stats *stats, u64 *data)
+{
+	struct ath10k *ar = hw->priv;
+	int i = 0;
+	struct ath10k_target_stats *fw_stats;
+
+	fw_stats = &ar->debug.target_stats;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state == ATH10K_STATE_ON)
+		ath10k_refresh_peer_stats(ar);
+
+	mutex_unlock(&ar->conf_mutex);
+
+	spin_lock_bh(&ar->data_lock);
+	data[i++] = fw_stats->hw_reaped; /* ppdu reaped */
+	data[i++] = 0; /* tx bytes */
+	data[i++] = fw_stats->htt_mpdus;
+	data[i++] = 0; /* rx bytes */
+	data[i++] = fw_stats->ch_noise_floor;
+	data[i++] = fw_stats->cycle_count;
+	data[i++] = fw_stats->phy_err_count;
+	data[i++] = fw_stats->rts_bad;
+	data[i++] = fw_stats->rts_good;
+	data[i++] = fw_stats->chan_tx_power;
+	data[i++] = fw_stats->fcs_bad;
+	data[i++] = fw_stats->no_beacons;
+	data[i++] = fw_stats->mpdu_enqued;
+	data[i++] = fw_stats->msdu_enqued;
+	data[i++] = fw_stats->wmm_drop;
+	data[i++] = fw_stats->local_enqued;
+	data[i++] = fw_stats->local_freed;
+	data[i++] = fw_stats->hw_queued;
+	data[i++] = fw_stats->hw_reaped;
+	data[i++] = fw_stats->underrun;
+	data[i++] = fw_stats->tx_abort;
+	data[i++] = fw_stats->mpdus_requed;
+	data[i++] = fw_stats->tx_ko;
+	data[i++] = fw_stats->data_rc;
+	data[i++] = fw_stats->sw_retry_failure;
+	data[i++] = fw_stats->illgl_rate_phy_err;
+	data[i++] = fw_stats->pdev_cont_xretry;
+	data[i++] = fw_stats->pdev_tx_timeout;
+	data[i++] = fw_stats->txop_ovf;
+	data[i++] = fw_stats->pdev_resets;
+	data[i++] = fw_stats->mid_ppdu_route_change;
+	data[i++] = fw_stats->status_rcvd;
+	data[i++] = fw_stats->r0_frags;
+	data[i++] = fw_stats->r1_frags;
+	data[i++] = fw_stats->r2_frags;
+	data[i++] = fw_stats->r3_frags;
+	data[i++] = fw_stats->htt_msdus;
+	data[i++] = fw_stats->htt_mpdus;
+	data[i++] = fw_stats->loc_msdus;
+	data[i++] = fw_stats->loc_mpdus;
+	data[i++] = fw_stats->phy_errs;
+	data[i++] = fw_stats->phy_err_drop;
+	data[i++] = fw_stats->mpdu_errs;
+	data[i++] = ar->fw_crash_counter;
+	data[i++] = ar->fw_warm_reset_counter;
+	data[i++] = ar->fw_cold_reset_counter;
+
+	spin_unlock_bh(&ar->data_lock);
+
+	WARN_ON(i != ATH10K_SSTATS_LEN);
+}
+
+#endif
+
 static const struct file_operations fops_fw_dbglog = {
 	.read = ath10k_read_fw_dbglog,
 	.write = ath10k_write_fw_dbglog,
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index ba6d280..39032e9 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -64,6 +64,15 @@ void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer, int len);
 
 #define ATH10K_DFS_STAT_INC(ar, c) (ar->debug.dfs_stats.c++)
 
+void ath10k_get_et_strings(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   u32 sset, u8 *data);
+int ath10k_get_et_sset_count(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif, int sset);
+void ath10k_get_et_stats(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 struct ethtool_stats *stats, u64 *data);
+
 #else
 static inline int ath10k_debug_start(struct ath10k *ar)
 {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 02e0a45..4bb3ef6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4515,6 +4515,11 @@ static const struct ieee80211_ops ath10k_ops = {
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
 #endif
+#ifdef CONFIG_ATH10K_DEBUGFS
+	.get_et_sset_count  = ath10k_get_et_sset_count,
+	.get_et_stats       = ath10k_get_et_stats,
+	.get_et_strings     = ath10k_get_et_strings,
+#endif
 };
 
 #define RATETAB_ENT(_rate, _rateid, _flags) { \
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 59e0ea8..38f7386 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -986,6 +986,8 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 
 	spin_lock_bh(&ar->data_lock);
 
+	ar->fw_crash_counter++;
+
 	crash_data = ath10k_debug_get_new_fw_crash_data(ar);
 
 	if (crash_data)
@@ -1671,6 +1673,7 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 	u32 val;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot warm reset\n");
+	ar->fw_warm_reset_counter++;
 
 	/* debug */
 	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
@@ -2286,6 +2289,7 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 	u32 val;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cold reset\n");
+	ar->fw_cold_reset_counter++;
 
 	/* Put Target, including PCIe, into RESET. */
 	val = ath10k_pci_reg_read32(ar, SOC_GLOBAL_RESET_ADDRESS);
-- 
1.7.11.7

