Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34440 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbbAVUeP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:15 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/38] iwlwifi: mvm: generate statistics debugfs code
Date: Thu, 22 Jan 2015 22:33:11 +0200
Message-Id: <1421958809-3371-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214447_634368_76B21E28)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to duplicate the structure field name in the string,
just generate the string in the macro that's there anyway. To keep
the debugfs output the same, rename one (otherwise unused) field.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      | 162 +++++++++++-------------
 drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h |   2 +-
 2 files changed, 78 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index afd1986..82c09d8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -654,10 +654,10 @@ out:
 	return ret ?: count;
 }
 
-#define PRINT_STATS_LE32(_str, _val)					\
+#define PRINT_STATS_LE32(_struct, _memb)				\
 			 pos += scnprintf(buf + pos, bufsz - pos,	\
-					  fmt_table, _str,		\
-					  le32_to_cpu(_val))
+					  fmt_table, #_memb,		\
+					  le32_to_cpu(_struct->_memb))
 
 static ssize_t iwl_dbgfs_fw_rx_stats_read(struct file *file,
 					  char __user *user_buf, size_t count,
@@ -692,97 +692,89 @@ static ssize_t iwl_dbgfs_fw_rx_stats_read(struct file *file,
 
 	pos += scnprintf(buf + pos, bufsz - pos, fmt_header,
 			 "Statistics_Rx - OFDM");
-	PRINT_STATS_LE32("ina_cnt", ofdm->ina_cnt);
-	PRINT_STATS_LE32("fina_cnt", ofdm->fina_cnt);
-	PRINT_STATS_LE32("plcp_err", ofdm->plcp_err);
-	PRINT_STATS_LE32("crc32_err", ofdm->crc32_err);
-	PRINT_STATS_LE32("overrun_err", ofdm->overrun_err);
-	PRINT_STATS_LE32("early_overrun_err", ofdm->early_overrun_err);
-	PRINT_STATS_LE32("crc32_good", ofdm->crc32_good);
-	PRINT_STATS_LE32("false_alarm_cnt", ofdm->false_alarm_cnt);
-	PRINT_STATS_LE32("fina_sync_err_cnt", ofdm->fina_sync_err_cnt);
-	PRINT_STATS_LE32("sfd_timeout", ofdm->sfd_timeout);
-	PRINT_STATS_LE32("fina_timeout", ofdm->fina_timeout);
-	PRINT_STATS_LE32("unresponded_rts", ofdm->unresponded_rts);
-	PRINT_STATS_LE32("rxe_frame_lmt_overrun",
-			 ofdm->rxe_frame_limit_overrun);
-	PRINT_STATS_LE32("sent_ack_cnt", ofdm->sent_ack_cnt);
-	PRINT_STATS_LE32("sent_cts_cnt", ofdm->sent_cts_cnt);
-	PRINT_STATS_LE32("sent_ba_rsp_cnt", ofdm->sent_ba_rsp_cnt);
-	PRINT_STATS_LE32("dsp_self_kill", ofdm->dsp_self_kill);
-	PRINT_STATS_LE32("mh_format_err", ofdm->mh_format_err);
-	PRINT_STATS_LE32("re_acq_main_rssi_sum", ofdm->re_acq_main_rssi_sum);
-	PRINT_STATS_LE32("reserved", ofdm->reserved);
+	PRINT_STATS_LE32(ofdm, ina_cnt);
+	PRINT_STATS_LE32(ofdm, fina_cnt);
+	PRINT_STATS_LE32(ofdm, plcp_err);
+	PRINT_STATS_LE32(ofdm, crc32_err);
+	PRINT_STATS_LE32(ofdm, overrun_err);
+	PRINT_STATS_LE32(ofdm, early_overrun_err);
+	PRINT_STATS_LE32(ofdm, crc32_good);
+	PRINT_STATS_LE32(ofdm, false_alarm_cnt);
+	PRINT_STATS_LE32(ofdm, fina_sync_err_cnt);
+	PRINT_STATS_LE32(ofdm, sfd_timeout);
+	PRINT_STATS_LE32(ofdm, fina_timeout);
+	PRINT_STATS_LE32(ofdm, unresponded_rts);
+	PRINT_STATS_LE32(ofdm, rxe_frame_lmt_overrun);
+	PRINT_STATS_LE32(ofdm, sent_ack_cnt);
+	PRINT_STATS_LE32(ofdm, sent_cts_cnt);
+	PRINT_STATS_LE32(ofdm, sent_ba_rsp_cnt);
+	PRINT_STATS_LE32(ofdm, dsp_self_kill);
+	PRINT_STATS_LE32(ofdm, mh_format_err);
+	PRINT_STATS_LE32(ofdm, re_acq_main_rssi_sum);
+	PRINT_STATS_LE32(ofdm, reserved);
 
 	pos += scnprintf(buf + pos, bufsz - pos, fmt_header,
 			 "Statistics_Rx - CCK");
-	PRINT_STATS_LE32("ina_cnt", cck->ina_cnt);
-	PRINT_STATS_LE32("fina_cnt", cck->fina_cnt);
-	PRINT_STATS_LE32("plcp_err", cck->plcp_err);
-	PRINT_STATS_LE32("crc32_err", cck->crc32_err);
-	PRINT_STATS_LE32("overrun_err", cck->overrun_err);
-	PRINT_STATS_LE32("early_overrun_err", cck->early_overrun_err);
-	PRINT_STATS_LE32("crc32_good", cck->crc32_good);
-	PRINT_STATS_LE32("false_alarm_cnt", cck->false_alarm_cnt);
-	PRINT_STATS_LE32("fina_sync_err_cnt", cck->fina_sync_err_cnt);
-	PRINT_STATS_LE32("sfd_timeout", cck->sfd_timeout);
-	PRINT_STATS_LE32("fina_timeout", cck->fina_timeout);
-	PRINT_STATS_LE32("unresponded_rts", cck->unresponded_rts);
-	PRINT_STATS_LE32("rxe_frame_lmt_overrun",
-			 cck->rxe_frame_limit_overrun);
-	PRINT_STATS_LE32("sent_ack_cnt", cck->sent_ack_cnt);
-	PRINT_STATS_LE32("sent_cts_cnt", cck->sent_cts_cnt);
-	PRINT_STATS_LE32("sent_ba_rsp_cnt", cck->sent_ba_rsp_cnt);
-	PRINT_STATS_LE32("dsp_self_kill", cck->dsp_self_kill);
-	PRINT_STATS_LE32("mh_format_err", cck->mh_format_err);
-	PRINT_STATS_LE32("re_acq_main_rssi_sum", cck->re_acq_main_rssi_sum);
-	PRINT_STATS_LE32("reserved", cck->reserved);
+	PRINT_STATS_LE32(cck, ina_cnt);
+	PRINT_STATS_LE32(cck, fina_cnt);
+	PRINT_STATS_LE32(cck, plcp_err);
+	PRINT_STATS_LE32(cck, crc32_err);
+	PRINT_STATS_LE32(cck, overrun_err);
+	PRINT_STATS_LE32(cck, early_overrun_err);
+	PRINT_STATS_LE32(cck, crc32_good);
+	PRINT_STATS_LE32(cck, false_alarm_cnt);
+	PRINT_STATS_LE32(cck, fina_sync_err_cnt);
+	PRINT_STATS_LE32(cck, sfd_timeout);
+	PRINT_STATS_LE32(cck, fina_timeout);
+	PRINT_STATS_LE32(cck, unresponded_rts);
+	PRINT_STATS_LE32(cck, rxe_frame_lmt_overrun);
+	PRINT_STATS_LE32(cck, sent_ack_cnt);
+	PRINT_STATS_LE32(cck, sent_cts_cnt);
+	PRINT_STATS_LE32(cck, sent_ba_rsp_cnt);
+	PRINT_STATS_LE32(cck, dsp_self_kill);
+	PRINT_STATS_LE32(cck, mh_format_err);
+	PRINT_STATS_LE32(cck, re_acq_main_rssi_sum);
+	PRINT_STATS_LE32(cck, reserved);
 
 	pos += scnprintf(buf + pos, bufsz - pos, fmt_header,
 			 "Statistics_Rx - GENERAL");
-	PRINT_STATS_LE32("bogus_cts", general->bogus_cts);
-	PRINT_STATS_LE32("bogus_ack", general->bogus_ack);
-	PRINT_STATS_LE32("non_bssid_frames", general->non_bssid_frames);
-	PRINT_STATS_LE32("filtered_frames", general->filtered_frames);
-	PRINT_STATS_LE32("non_channel_beacons", general->non_channel_beacons);
-	PRINT_STATS_LE32("channel_beacons", general->channel_beacons);
-	PRINT_STATS_LE32("num_missed_bcon", general->num_missed_bcon);
-	PRINT_STATS_LE32("adc_rx_saturation_time",
-			 general->adc_rx_saturation_time);
-	PRINT_STATS_LE32("ina_detection_search_time",
-			 general->ina_detection_search_time);
-	PRINT_STATS_LE32("beacon_silence_rssi_a",
-			 general->beacon_silence_rssi_a);
-	PRINT_STATS_LE32("beacon_silence_rssi_b",
-			 general->beacon_silence_rssi_b);
-	PRINT_STATS_LE32("beacon_silence_rssi_c",
-			 general->beacon_silence_rssi_c);
-	PRINT_STATS_LE32("interference_data_flag",
-			 general->interference_data_flag);
-	PRINT_STATS_LE32("channel_load", general->channel_load);
-	PRINT_STATS_LE32("dsp_false_alarms", general->dsp_false_alarms);
-	PRINT_STATS_LE32("beacon_rssi_a", general->beacon_rssi_a);
-	PRINT_STATS_LE32("beacon_rssi_b", general->beacon_rssi_b);
-	PRINT_STATS_LE32("beacon_rssi_c", general->beacon_rssi_c);
-	PRINT_STATS_LE32("beacon_energy_a", general->beacon_energy_a);
-	PRINT_STATS_LE32("beacon_energy_b", general->beacon_energy_b);
-	PRINT_STATS_LE32("beacon_energy_c", general->beacon_energy_c);
-	PRINT_STATS_LE32("num_bt_kills", general->num_bt_kills);
-	PRINT_STATS_LE32("mac_id", general->mac_id);
-	PRINT_STATS_LE32("directed_data_mpdu", general->directed_data_mpdu);
+	PRINT_STATS_LE32(general, bogus_cts);
+	PRINT_STATS_LE32(general, bogus_ack);
+	PRINT_STATS_LE32(general, non_bssid_frames);
+	PRINT_STATS_LE32(general, filtered_frames);
+	PRINT_STATS_LE32(general, non_channel_beacons);
+	PRINT_STATS_LE32(general, channel_beacons);
+	PRINT_STATS_LE32(general, num_missed_bcon);
+	PRINT_STATS_LE32(general, adc_rx_saturation_time);
+	PRINT_STATS_LE32(general, ina_detection_search_time);
+	PRINT_STATS_LE32(general, beacon_silence_rssi_a);
+	PRINT_STATS_LE32(general, beacon_silence_rssi_b);
+	PRINT_STATS_LE32(general, beacon_silence_rssi_c);
+	PRINT_STATS_LE32(general, interference_data_flag);
+	PRINT_STATS_LE32(general, channel_load);
+	PRINT_STATS_LE32(general, dsp_false_alarms);
+	PRINT_STATS_LE32(general, beacon_rssi_a);
+	PRINT_STATS_LE32(general, beacon_rssi_b);
+	PRINT_STATS_LE32(general, beacon_rssi_c);
+	PRINT_STATS_LE32(general, beacon_energy_a);
+	PRINT_STATS_LE32(general, beacon_energy_b);
+	PRINT_STATS_LE32(general, beacon_energy_c);
+	PRINT_STATS_LE32(general, num_bt_kills);
+	PRINT_STATS_LE32(general, mac_id);
+	PRINT_STATS_LE32(general, directed_data_mpdu);
 
 	pos += scnprintf(buf + pos, bufsz - pos, fmt_header,
 			 "Statistics_Rx - HT");
-	PRINT_STATS_LE32("plcp_err", ht->plcp_err);
-	PRINT_STATS_LE32("overrun_err", ht->overrun_err);
-	PRINT_STATS_LE32("early_overrun_err", ht->early_overrun_err);
-	PRINT_STATS_LE32("crc32_good", ht->crc32_good);
-	PRINT_STATS_LE32("crc32_err", ht->crc32_err);
-	PRINT_STATS_LE32("mh_format_err", ht->mh_format_err);
-	PRINT_STATS_LE32("agg_crc32_good", ht->agg_crc32_good);
-	PRINT_STATS_LE32("agg_mpdu_cnt", ht->agg_mpdu_cnt);
-	PRINT_STATS_LE32("agg_cnt", ht->agg_cnt);
-	PRINT_STATS_LE32("unsupport_mcs", ht->unsupport_mcs);
+	PRINT_STATS_LE32(ht, plcp_err);
+	PRINT_STATS_LE32(ht, overrun_err);
+	PRINT_STATS_LE32(ht, early_overrun_err);
+	PRINT_STATS_LE32(ht, crc32_good);
+	PRINT_STATS_LE32(ht, crc32_err);
+	PRINT_STATS_LE32(ht, mh_format_err);
+	PRINT_STATS_LE32(ht, agg_crc32_good);
+	PRINT_STATS_LE32(ht, agg_mpdu_cnt);
+	PRINT_STATS_LE32(ht, agg_cnt);
+	PRINT_STATS_LE32(ht, unsupport_mcs);
 
 	mutex_unlock(&mvm->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
index bda3a36..928168b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
@@ -131,7 +131,7 @@ struct mvm_statistics_rx_phy {
 	__le32 sfd_timeout;
 	__le32 fina_timeout;
 	__le32 unresponded_rts;
-	__le32 rxe_frame_limit_overrun;
+	__le32 rxe_frame_lmt_overrun;
 	__le32 sent_ack_cnt;
 	__le32 sent_cts_cnt;
 	__le32 sent_ba_rsp_cnt;
-- 
1.9.1

