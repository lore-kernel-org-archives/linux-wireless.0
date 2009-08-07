Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1415 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZHGWl4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/16] iwlwifi: uCode statistics notification counter
Date: Fri,  7 Aug 2009 15:41:42 -0700
Message-Id: <1249684912-22936-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Display statistics notification information
The information break down into
    uCode_tx_stats
    uCode_rx_stats
    uCode_general_stats
and can be found in /sys/kernel/debug/ieee80211/phy0/iwlagn/debug
directory

The statistic information display in debugFs is based on the last
statistics notification from uCode; it might not reflect the current
uCode activity. Using "watch" command to monitor the uCode
activity should give up-to-date statistics provided by uCode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    3 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |  412 ++++++++++++++++++++++++++++
 2 files changed, 415 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index cad5e27..18b8cf7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -100,6 +100,9 @@ struct iwl_debugfs {
 		struct dentry *file_traffic_log;
 		struct dentry *file_rx_queue;
 		struct dentry *file_tx_queue;
+		struct dentry *file_ucode_rx_stats;
+		struct dentry *file_ucode_tx_stats;
+		struct dentry *file_ucode_general_stats;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d4109cb..20e4edb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -950,11 +950,410 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+#define UCODE_STATISTICS_CLEAR_MSK		(0x1 << 0)
+#define UCODE_STATISTICS_FREQUENCY_MSK		(0x1 << 1)
+#define UCODE_STATISTICS_NARROW_BAND_MSK	(0x1 << 2)
+
+static int iwl_dbgfs_statistics_flag(struct iwl_priv *priv, char *buf,
+				     int bufsz)
+{
+	int p = 0;
+
+	p += scnprintf(buf + p, bufsz - p,
+		"Statistics Flag(0x%X):\n",
+		le32_to_cpu(priv->statistics.flag));
+	if (le32_to_cpu(priv->statistics.flag) & UCODE_STATISTICS_CLEAR_MSK)
+		p += scnprintf(buf + p, bufsz - p,
+		"\tStatistics have been cleared\n");
+	p += scnprintf(buf + p, bufsz - p,
+		"\tOperational Frequency: %s\n",
+		(le32_to_cpu(priv->statistics.flag) &
+		UCODE_STATISTICS_FREQUENCY_MSK)
+		 ? "2.4 GHz" : "5.2 GHz");
+	p += scnprintf(buf + p, bufsz - p,
+		"\tTGj Narrow Band: %s\n",
+		(le32_to_cpu(priv->statistics.flag) &
+		UCODE_STATISTICS_NARROW_BAND_MSK)
+		 ? "enabled" : "disabled");
+	return p;
+}
+
+
+static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	char *buf;
+	int bufsz = sizeof(struct statistics_rx_phy) * 20 +
+		sizeof(struct statistics_rx_non_phy) * 20 +
+		sizeof(struct statistics_rx_ht_phy) * 20 + 400;
+	ssize_t ret;
+	struct statistics_rx_phy *ofdm;
+	struct statistics_rx_phy *cck;
+	struct statistics_rx_non_phy *general;
+	struct statistics_rx_ht_phy *ht;
+
+	if (!iwl_is_alive(priv))
+		return -EAGAIN;
+
+	/* make request to uCode to retrieve statistics information */
+	mutex_lock(&priv->mutex);
+	ret = iwl_send_statistics_request(priv, 0);
+	mutex_unlock(&priv->mutex);
+
+	if (ret) {
+		IWL_ERR(priv,
+			"Error sending statistics request: %zd\n", ret);
+		return -EAGAIN;
+	}
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	/* the statistic information display here is based on
+	 * the last statistics notification from uCode
+	 * might not reflect the current uCode activity
+	 */
+	ofdm = &priv->statistics.rx.ofdm;
+	cck = &priv->statistics.rx.cck;
+	general = &priv->statistics.rx.general;
+	ht = &priv->statistics.rx.ofdm_ht;
+	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - OFDM:\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "ina_cnt: %u\n",
+			 le32_to_cpu(ofdm->ina_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "fina_cnt: %u\n",
+			 le32_to_cpu(ofdm->fina_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err: %u\n",
+			 le32_to_cpu(ofdm->plcp_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err: %u\n",
+			 le32_to_cpu(ofdm->crc32_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "overrun_err: %u\n",
+			 le32_to_cpu(ofdm->overrun_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "early_overrun_err: %u\n",
+			 le32_to_cpu(ofdm->early_overrun_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good: %u\n",
+			 le32_to_cpu(ofdm->crc32_good));
+	pos += scnprintf(buf + pos, bufsz - pos, "false_alarm_cnt: %u\n",
+			 le32_to_cpu(ofdm->false_alarm_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "fina_sync_err_cnt: %u\n",
+			 le32_to_cpu(ofdm->fina_sync_err_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "sfd_timeout: %u\n",
+			 le32_to_cpu(ofdm->sfd_timeout));
+	pos += scnprintf(buf + pos, bufsz - pos, "fina_timeout: %u\n",
+			 le32_to_cpu(ofdm->fina_timeout));
+	pos += scnprintf(buf + pos, bufsz - pos, "unresponded_rts: %u\n",
+			 le32_to_cpu(ofdm->unresponded_rts));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"rxe_frame_limit_overrun: %u\n",
+			le32_to_cpu(ofdm->rxe_frame_limit_overrun));
+	pos += scnprintf(buf + pos, bufsz - pos, "sent_ack_cnt: %u\n",
+			 le32_to_cpu(ofdm->sent_ack_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "sent_cts_cnt: %u\n",
+			 le32_to_cpu(ofdm->sent_cts_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "sent_ba_rsp_cnt: %u\n",
+			 le32_to_cpu(ofdm->sent_ba_rsp_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "dsp_self_kill: %u\n",
+			 le32_to_cpu(ofdm->dsp_self_kill));
+	pos += scnprintf(buf + pos, bufsz - pos, "mh_format_err: %u\n",
+			 le32_to_cpu(ofdm->mh_format_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "re_acq_main_rssi_sum: %u\n",
+			 le32_to_cpu(ofdm->re_acq_main_rssi_sum));
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - CCK:\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "ina_cnt: %u\n",
+			 le32_to_cpu(cck->ina_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "fina_cnt: %u\n",
+			 le32_to_cpu(cck->fina_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err: %u\n",
+			 le32_to_cpu(cck->plcp_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err: %u\n",
+			 le32_to_cpu(cck->crc32_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "overrun_err: %u\n",
+			 le32_to_cpu(cck->overrun_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "early_overrun_err: %u\n",
+			 le32_to_cpu(cck->early_overrun_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good: %u\n",
+			 le32_to_cpu(cck->crc32_good));
+	pos += scnprintf(buf + pos, bufsz - pos, "false_alarm_cnt: %u\n",
+			 le32_to_cpu(cck->false_alarm_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "fina_sync_err_cnt: %u\n",
+			 le32_to_cpu(cck->fina_sync_err_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "sfd_timeout: %u\n",
+			 le32_to_cpu(cck->sfd_timeout));
+	pos += scnprintf(buf + pos, bufsz - pos, "fina_timeout: %u\n",
+			 le32_to_cpu(cck->fina_timeout));
+	pos += scnprintf(buf + pos, bufsz - pos, "unresponded_rts: %u\n",
+			 le32_to_cpu(cck->unresponded_rts));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"rxe_frame_limit_overrun: %u\n",
+			le32_to_cpu(cck->rxe_frame_limit_overrun));
+	pos += scnprintf(buf + pos, bufsz - pos, "sent_ack_cnt: %u\n",
+			 le32_to_cpu(cck->sent_ack_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "sent_cts_cnt: %u\n",
+			 le32_to_cpu(cck->sent_cts_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "sent_ba_rsp_cnt: %u\n",
+			 le32_to_cpu(cck->sent_ba_rsp_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "dsp_self_kill: %u\n",
+			 le32_to_cpu(cck->dsp_self_kill));
+	pos += scnprintf(buf + pos, bufsz - pos, "mh_format_err: %u\n",
+			 le32_to_cpu(cck->mh_format_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "re_acq_main_rssi_sum: %u\n",
+			 le32_to_cpu(cck->re_acq_main_rssi_sum));
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - GENERAL:\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "bogus_cts: %u\n",
+			 le32_to_cpu(general->bogus_cts));
+	pos += scnprintf(buf + pos, bufsz - pos, "bogus_ack: %u\n",
+			 le32_to_cpu(general->bogus_ack));
+	pos += scnprintf(buf + pos, bufsz - pos, "non_bssid_frames: %u\n",
+			 le32_to_cpu(general->non_bssid_frames));
+	pos += scnprintf(buf + pos, bufsz - pos, "filtered_frames: %u\n",
+			 le32_to_cpu(general->filtered_frames));
+	pos += scnprintf(buf + pos, bufsz - pos, "non_channel_beacons: %u\n",
+			 le32_to_cpu(general->non_channel_beacons));
+	pos += scnprintf(buf + pos, bufsz - pos, "channel_beacons: %u\n",
+			 le32_to_cpu(general->channel_beacons));
+	pos += scnprintf(buf + pos, bufsz - pos, "num_missed_bcon: %u\n",
+			 le32_to_cpu(general->num_missed_bcon));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"adc_rx_saturation_time: %u\n",
+			le32_to_cpu(general->adc_rx_saturation_time));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"ina_detection_search_time: %u\n",
+			le32_to_cpu(general->ina_detection_search_time));
+	pos += scnprintf(buf + pos, bufsz - pos, "beacon_silence_rssi_a: %u\n",
+			 le32_to_cpu(general->beacon_silence_rssi_a));
+	pos += scnprintf(buf + pos, bufsz - pos, "beacon_silence_rssi_b: %u\n",
+			 le32_to_cpu(general->beacon_silence_rssi_b));
+	pos += scnprintf(buf + pos, bufsz - pos, "beacon_silence_rssi_c: %u\n",
+			 le32_to_cpu(general->beacon_silence_rssi_c));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"interference_data_flag: %u\n",
+			le32_to_cpu(general->interference_data_flag));
+	pos += scnprintf(buf + pos, bufsz - pos, "channel_load: %u\n",
+			 le32_to_cpu(general->channel_load));
+	pos += scnprintf(buf + pos, bufsz - pos, "dsp_false_alarms: %u\n",
+			 le32_to_cpu(general->dsp_false_alarms));
+	pos += scnprintf(buf + pos, bufsz - pos, "beacon_rssi_a: %u\n",
+			 le32_to_cpu(general->beacon_rssi_a));
+	pos += scnprintf(buf + pos, bufsz - pos, "beacon_rssi_b: %u\n",
+			 le32_to_cpu(general->beacon_rssi_b));
+	pos += scnprintf(buf + pos, bufsz - pos, "beacon_rssi_c: %u\n",
+			 le32_to_cpu(general->beacon_rssi_c));
+	pos += scnprintf(buf + pos, bufsz - pos, "beacon_energy_a: %u\n",
+			 le32_to_cpu(general->beacon_energy_a));
+	pos += scnprintf(buf + pos, bufsz - pos, "beacon_energy_b: %u\n",
+			 le32_to_cpu(general->beacon_energy_b));
+	pos += scnprintf(buf + pos, bufsz - pos, "beacon_energy_c: %u\n",
+			 le32_to_cpu(general->beacon_energy_c));
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - OFDM_HT:\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err: %u\n",
+			 le32_to_cpu(ht->plcp_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "overrun_err: %u\n",
+			 le32_to_cpu(ht->overrun_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "early_overrun_err: %u\n",
+			 le32_to_cpu(ht->early_overrun_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good: %u\n",
+			 le32_to_cpu(ht->crc32_good));
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err: %u\n",
+			 le32_to_cpu(ht->crc32_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "mh_format_err: %u\n",
+			 le32_to_cpu(ht->mh_format_err));
+	pos += scnprintf(buf + pos, bufsz - pos, "agg_crc32_good: %u\n",
+			 le32_to_cpu(ht->agg_crc32_good));
+	pos += scnprintf(buf + pos, bufsz - pos, "agg_mpdu_cnt: %u\n",
+			 le32_to_cpu(ht->agg_mpdu_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "agg_cnt: %u\n",
+			 le32_to_cpu(ht->agg_cnt));
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	char *buf;
+	int bufsz = (sizeof(struct statistics_tx) * 24) + 250;
+	ssize_t ret;
+	struct statistics_tx *tx;
+
+	if (!iwl_is_alive(priv))
+		return -EAGAIN;
+
+	/* make request to uCode to retrieve statistics information */
+	mutex_lock(&priv->mutex);
+	ret = iwl_send_statistics_request(priv, 0);
+	mutex_unlock(&priv->mutex);
+
+	if (ret) {
+		IWL_ERR(priv,
+			"Error sending statistics request: %zd\n", ret);
+		return -EAGAIN;
+	}
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	/* the statistic information display here is based on
+	 * the last statistics notification from uCode
+	 * might not reflect the current uCode activity
+	 */
+	tx = &priv->statistics.tx;
+	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Tx:\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "preamble: %u\n",
+			 le32_to_cpu(tx->preamble_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "rx_detected_cnt: %u\n",
+			 le32_to_cpu(tx->rx_detected_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "bt_prio_defer_cnt: %u\n",
+			 le32_to_cpu(tx->bt_prio_defer_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "bt_prio_kill_cnt: %u\n",
+			 le32_to_cpu(tx->bt_prio_kill_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "few_bytes_cnt: %u\n",
+			 le32_to_cpu(tx->few_bytes_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "cts_timeout: %u\n",
+			 le32_to_cpu(tx->cts_timeout));
+	pos += scnprintf(buf + pos, bufsz - pos, "ack_timeout: %u\n",
+			 le32_to_cpu(tx->ack_timeout));
+	pos += scnprintf(buf + pos, bufsz - pos, "expected_ack_cnt: %u\n",
+			 le32_to_cpu(tx->expected_ack_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "actual_ack_cnt: %u\n",
+			 le32_to_cpu(tx->actual_ack_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "dump_msdu_cnt: %u\n",
+			 le32_to_cpu(tx->dump_msdu_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"burst_abort_next_frame_mismatch_cnt: %u\n",
+			le32_to_cpu(tx->burst_abort_next_frame_mismatch_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"burst_abort_missing_next_frame_cnt: %u\n",
+			le32_to_cpu(tx->burst_abort_missing_next_frame_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "cts_timeout_collision: %u\n",
+			 le32_to_cpu(tx->cts_timeout_collision));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"ack_or_ba_timeout_collision: %u\n",
+			le32_to_cpu(tx->ack_or_ba_timeout_collision));
+	pos += scnprintf(buf + pos, bufsz - pos, "agg ba_timeout: %u\n",
+			 le32_to_cpu(tx->agg.ba_timeout));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"agg ba_reschedule_frames: %u\n",
+			le32_to_cpu(tx->agg.ba_reschedule_frames));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"agg scd_query_agg_frame_cnt: %u\n",
+			le32_to_cpu(tx->agg.scd_query_agg_frame_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos, "agg scd_query_no_agg: %u\n",
+			 le32_to_cpu(tx->agg.scd_query_no_agg));
+	pos += scnprintf(buf + pos, bufsz - pos, "agg scd_query_agg: %u\n",
+			 le32_to_cpu(tx->agg.scd_query_agg));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"agg scd_query_mismatch: %u\n",
+			le32_to_cpu(tx->agg.scd_query_mismatch));
+	pos += scnprintf(buf + pos, bufsz - pos, "agg frame_not_ready: %u\n",
+			 le32_to_cpu(tx->agg.frame_not_ready));
+	pos += scnprintf(buf + pos, bufsz - pos, "agg underrun: %u\n",
+			 le32_to_cpu(tx->agg.underrun));
+	pos += scnprintf(buf + pos, bufsz - pos, "agg bt_prio_kill: %u\n",
+			 le32_to_cpu(tx->agg.bt_prio_kill));
+	pos += scnprintf(buf + pos, bufsz - pos, "agg rx_ba_rsp_cnt: %u\n",
+			 le32_to_cpu(tx->agg.rx_ba_rsp_cnt));
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	char *buf;
+	int bufsz = sizeof(struct statistics_general) * 4 + 250;
+	ssize_t ret;
+	struct statistics_general *general;
+	struct statistics_dbg *dbg;
+	struct statistics_div *div;
+
+	if (!iwl_is_alive(priv))
+		return -EAGAIN;
+
+	/* make request to uCode to retrieve statistics information */
+	mutex_lock(&priv->mutex);
+	ret = iwl_send_statistics_request(priv, 0);
+	mutex_unlock(&priv->mutex);
+
+	if (ret) {
+		IWL_ERR(priv,
+			"Error sending statistics request: %zd\n", ret);
+		return -EAGAIN;
+	}
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	/* the statistic information display here is based on
+	 * the last statistics notification from uCode
+	 * might not reflect the current uCode activity
+	 */
+	general = &priv->statistics.general;
+	dbg = &priv->statistics.general.dbg;
+	div = &priv->statistics.general.div;
+	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_General:\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "temperature: %u\n",
+			 le32_to_cpu(general->temperature));
+	pos += scnprintf(buf + pos, bufsz - pos, "temperature_m: %u\n",
+			 le32_to_cpu(general->temperature_m));
+	pos += scnprintf(buf + pos, bufsz - pos, "burst_check: %u\n",
+			 le32_to_cpu(dbg->burst_check));
+	pos += scnprintf(buf + pos, bufsz - pos, "burst_count: %u\n",
+			 le32_to_cpu(dbg->burst_count));
+	pos += scnprintf(buf + pos, bufsz - pos, "sleep_time: %u\n",
+			 le32_to_cpu(general->sleep_time));
+	pos += scnprintf(buf + pos, bufsz - pos, "slots_out: %u\n",
+			 le32_to_cpu(general->slots_out));
+	pos += scnprintf(buf + pos, bufsz - pos, "slots_idle: %u\n",
+			 le32_to_cpu(general->slots_idle));
+	pos += scnprintf(buf + pos, bufsz - pos, "ttl_timestamp: %u\n",
+			 le32_to_cpu(general->ttl_timestamp));
+	pos += scnprintf(buf + pos, bufsz - pos, "tx_on_a: %u\n",
+			 le32_to_cpu(div->tx_on_a));
+	pos += scnprintf(buf + pos, bufsz - pos, "tx_on_b: %u\n",
+			 le32_to_cpu(div->tx_on_b));
+	pos += scnprintf(buf + pos, bufsz - pos, "exec_time: %u\n",
+			 le32_to_cpu(div->exec_time));
+	pos += scnprintf(buf + pos, bufsz - pos, "probe_time: %u\n",
+			 le32_to_cpu(div->probe_time));
+	pos += scnprintf(buf + pos, bufsz - pos, "rx_enable_counter: %u\n",
+			 le32_to_cpu(general->rx_enable_counter));
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(rx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
 DEBUGFS_READ_FILE_OPS(rx_queue);
 DEBUGFS_READ_FILE_OPS(tx_queue);
+DEBUGFS_READ_FILE_OPS(ucode_rx_stats);
+DEBUGFS_READ_FILE_OPS(ucode_tx_stats);
+DEBUGFS_READ_FILE_OPS(ucode_general_stats);
 
 /*
  * Create the debugfs files and directories
@@ -1001,6 +1400,11 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(traffic_log, debug);
 	DEBUGFS_ADD_FILE(rx_queue, debug);
 	DEBUGFS_ADD_FILE(tx_queue, debug);
+	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
+		DEBUGFS_ADD_FILE(ucode_rx_stats, debug);
+		DEBUGFS_ADD_FILE(ucode_tx_stats, debug);
+		DEBUGFS_ADD_FILE(ucode_general_stats, debug);
+	}
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
@@ -1045,6 +1449,14 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_traffic_log);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_rx_queue);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_queue);
+	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
+		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
+			file_ucode_rx_stats);
+		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
+			file_ucode_tx_stats);
+		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
+			file_ucode_general_stats);
+	}
 	DEBUGFS_REMOVE(priv->dbgfs->dir_debug);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
-- 
1.5.6.3

