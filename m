Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:38654 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaI2JmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 05:42:25 -0400
Subject: [PATCH v2 2/2] ath10k: support ethtool stats
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Sep 2014 12:42:21 +0300
Message-ID: <20140929094221.12889.84916.stgit@potku.adurom.net> (sfid-20140929_114252_694423_5BB428A4)
In-Reply-To: <20140929094214.12889.97523.stgit@potku.adurom.net>
References: <20140929094214.12889.97523.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Add support for reading firmware stats through the ethtool
API.  This may be easier for applications to manipulate
compared to parsing a text based debugfs file.

kvalo: remove unneeded ifdefs, call ath10k_debug_fw_stats_request() and added
simple error handling

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |  160 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |   13 +++
 drivers/net/wireless/ath/ath10k/mac.c   |    3 +
 3 files changed, 176 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8d3db1c3f4a8..2bb894f31337 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1130,6 +1130,166 @@ exit:
 	return ret;
 }
 
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
+
+#define ATH10K_SSTATS_LEN ARRAY_SIZE(ath10k_gstrings_stats)
+
+void ath10k_debug_get_et_strings(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 u32 sset, u8 *data)
+{
+	if (sset == ETH_SS_STATS)
+		memcpy(data, *ath10k_gstrings_stats,
+		       sizeof(ath10k_gstrings_stats));
+}
+
+int ath10k_debug_get_et_sset_count(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif, int sset)
+{
+	if (sset == ETH_SS_STATS)
+		return ATH10K_SSTATS_LEN;
+
+	return 0;
+}
+
+void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ethtool_stats *stats, u64 *data)
+{
+	struct ath10k *ar = hw->priv;
+	static const struct ath10k_fw_stats_pdev zero_stats = {};
+	const struct ath10k_fw_stats_pdev *pdev_stats;
+	int i = 0, ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state == ATH10K_STATE_ON) {
+		ret = ath10k_debug_fw_stats_request(ar);
+		if (ret) {
+			/* just print a warning and try to use older results */
+			ath10k_warn(ar,
+				    "failed to get fw stats for ethtool: %d\n",
+				    ret);
+		}
+	}
+
+	pdev_stats = list_first_entry_or_null(&ar->debug.fw_stats.pdevs,
+					      struct ath10k_fw_stats_pdev,
+					      list);
+	if (!pdev_stats) {
+		/* no results available so just return zeroes */
+		pdev_stats = &zero_stats;
+	}
+
+	spin_lock_bh(&ar->data_lock);
+
+	data[i++] = pdev_stats->hw_reaped; /* ppdu reaped */
+	data[i++] = 0; /* tx bytes */
+	data[i++] = pdev_stats->htt_mpdus;
+	data[i++] = 0; /* rx bytes */
+	data[i++] = pdev_stats->ch_noise_floor;
+	data[i++] = pdev_stats->cycle_count;
+	data[i++] = pdev_stats->phy_err_count;
+	data[i++] = pdev_stats->rts_bad;
+	data[i++] = pdev_stats->rts_good;
+	data[i++] = pdev_stats->chan_tx_power;
+	data[i++] = pdev_stats->fcs_bad;
+	data[i++] = pdev_stats->no_beacons;
+	data[i++] = pdev_stats->mpdu_enqued;
+	data[i++] = pdev_stats->msdu_enqued;
+	data[i++] = pdev_stats->wmm_drop;
+	data[i++] = pdev_stats->local_enqued;
+	data[i++] = pdev_stats->local_freed;
+	data[i++] = pdev_stats->hw_queued;
+	data[i++] = pdev_stats->hw_reaped;
+	data[i++] = pdev_stats->underrun;
+	data[i++] = pdev_stats->tx_abort;
+	data[i++] = pdev_stats->mpdus_requed;
+	data[i++] = pdev_stats->tx_ko;
+	data[i++] = pdev_stats->data_rc;
+	data[i++] = pdev_stats->sw_retry_failure;
+	data[i++] = pdev_stats->illgl_rate_phy_err;
+	data[i++] = pdev_stats->pdev_cont_xretry;
+	data[i++] = pdev_stats->pdev_tx_timeout;
+	data[i++] = pdev_stats->txop_ovf;
+	data[i++] = pdev_stats->pdev_resets;
+	data[i++] = pdev_stats->mid_ppdu_route_change;
+	data[i++] = pdev_stats->status_rcvd;
+	data[i++] = pdev_stats->r0_frags;
+	data[i++] = pdev_stats->r1_frags;
+	data[i++] = pdev_stats->r2_frags;
+	data[i++] = pdev_stats->r3_frags;
+	data[i++] = pdev_stats->htt_msdus;
+	data[i++] = pdev_stats->htt_mpdus;
+	data[i++] = pdev_stats->loc_msdus;
+	data[i++] = pdev_stats->loc_mpdus;
+	data[i++] = pdev_stats->phy_errs;
+	data[i++] = pdev_stats->phy_err_drop;
+	data[i++] = pdev_stats->mpdu_errs;
+	data[i++] = ar->stats.fw_crash_counter;
+	data[i++] = ar->stats.fw_warm_reset_counter;
+	data[i++] = ar->stats.fw_cold_reset_counter;
+
+	spin_unlock_bh(&ar->data_lock);
+
+	mutex_unlock(&ar->conf_mutex);
+
+	WARN_ON(i != ATH10K_SSTATS_LEN);
+}
+
 static const struct file_operations fops_fw_dbglog = {
 	.read = ath10k_read_fw_dbglog,
 	.write = ath10k_write_fw_dbglog,
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index efbcd29fe9a1..d6a565d2bb74 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -63,6 +63,15 @@ void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer, int len);
 
 #define ATH10K_DFS_STAT_INC(ar, c) (ar->debug.dfs_stats.c++)
 
+void ath10k_debug_get_et_strings(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 u32 sset, u8 *data);
+int ath10k_debug_get_et_sset_count(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif, int sset);
+void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ethtool_stats *stats, u64 *data);
+
 #else
 static inline int ath10k_debug_start(struct ath10k *ar)
 {
@@ -115,6 +124,10 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 
 #define ATH10K_DFS_STAT_INC(ar, c) do { } while (0)
 
+#define ath10k_debug_get_et_strings NULL
+#define ath10k_debug_get_et_sset_count NULL
+#define ath10k_debug_get_et_stats NULL
+
 #endif /* CONFIG_ATH10K_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a99d91947edc..4d1aef4b8cd4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4505,6 +4505,9 @@ static const struct ieee80211_ops ath10k_ops = {
 	.sta_rc_update			= ath10k_sta_rc_update,
 	.get_tsf			= ath10k_get_tsf,
 	.ampdu_action			= ath10k_ampdu_action,
+	.get_et_sset_count		= ath10k_debug_get_et_sset_count,
+	.get_et_stats			= ath10k_debug_get_et_stats,
+	.get_et_strings			= ath10k_debug_get_et_strings,
 
 	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
 

