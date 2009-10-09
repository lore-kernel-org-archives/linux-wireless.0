Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761386AbZJIUWq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/17] iwlwifi: showing accumulative ucode statistics counters
Date: Fri,  9 Oct 2009 13:20:29 -0700
Message-Id: <1255119634-3060-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding accumulative statistics counters in iwlwifi driver.
Statistics counters are reported by uCode every beacon interval; but can
be reset by uCode when needed. The accumulative statistics counters is
maintained by driver to keep track of the history of all the counters.

Update the ucode stats files in debugfs to display both latest and
accumulative counters.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    2 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |  629 ++++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c      |   41 ++
 4 files changed, 447 insertions(+), 229 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 314cae7..cee03e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -361,8 +361,6 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 	memcpy(&priv->statistics_39, pkt->u.raw, sizeof(priv->statistics_39));
 
 	iwl_leds_background(priv);
-
-	priv->last_statistics_time = jiffies;
 }
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 028d4bf..2cd11ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1079,10 +1079,10 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 		sizeof(struct statistics_rx_non_phy) * 20 +
 		sizeof(struct statistics_rx_ht_phy) * 20 + 400;
 	ssize_t ret;
-	struct statistics_rx_phy *ofdm;
-	struct statistics_rx_phy *cck;
-	struct statistics_rx_non_phy *general;
-	struct statistics_rx_ht_phy *ht;
+	struct statistics_rx_phy *ofdm, *accum_ofdm;
+	struct statistics_rx_phy *cck, *accum_cck;
+	struct statistics_rx_non_phy *general, *accum_general;
+	struct statistics_rx_ht_phy *ht, *accum_ht;
 
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
@@ -1111,155 +1111,268 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 	cck = &priv->statistics.rx.cck;
 	general = &priv->statistics.rx.general;
 	ht = &priv->statistics.rx.ofdm_ht;
+	accum_ofdm = &priv->accum_statistics.rx.ofdm;
+	accum_cck = &priv->accum_statistics.rx.cck;
+	accum_general = &priv->accum_statistics.rx.general;
+	accum_ht = &priv->accum_statistics.rx.ofdm_ht;
 	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - OFDM:\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "ina_cnt: %u\n",
-			 le32_to_cpu(ofdm->ina_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "fina_cnt: %u\n",
-			 le32_to_cpu(ofdm->fina_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err: %u\n",
-			 le32_to_cpu(ofdm->plcp_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err: %u\n",
-			 le32_to_cpu(ofdm->crc32_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "overrun_err: %u\n",
-			 le32_to_cpu(ofdm->overrun_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "early_overrun_err: %u\n",
-			 le32_to_cpu(ofdm->early_overrun_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good: %u\n",
-			 le32_to_cpu(ofdm->crc32_good));
-	pos += scnprintf(buf + pos, bufsz - pos, "false_alarm_cnt: %u\n",
-			 le32_to_cpu(ofdm->false_alarm_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "fina_sync_err_cnt: %u\n",
-			 le32_to_cpu(ofdm->fina_sync_err_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "sfd_timeout: %u\n",
-			 le32_to_cpu(ofdm->sfd_timeout));
-	pos += scnprintf(buf + pos, bufsz - pos, "fina_timeout: %u\n",
-			 le32_to_cpu(ofdm->fina_timeout));
-	pos += scnprintf(buf + pos, bufsz - pos, "unresponded_rts: %u\n",
-			 le32_to_cpu(ofdm->unresponded_rts));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"rxe_frame_limit_overrun: %u\n",
-			le32_to_cpu(ofdm->rxe_frame_limit_overrun));
-	pos += scnprintf(buf + pos, bufsz - pos, "sent_ack_cnt: %u\n",
-			 le32_to_cpu(ofdm->sent_ack_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "sent_cts_cnt: %u\n",
-			 le32_to_cpu(ofdm->sent_cts_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "sent_ba_rsp_cnt: %u\n",
-			 le32_to_cpu(ofdm->sent_ba_rsp_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "dsp_self_kill: %u\n",
-			 le32_to_cpu(ofdm->dsp_self_kill));
-	pos += scnprintf(buf + pos, bufsz - pos, "mh_format_err: %u\n",
-			 le32_to_cpu(ofdm->mh_format_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "re_acq_main_rssi_sum: %u\n",
-			 le32_to_cpu(ofdm->re_acq_main_rssi_sum));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\t\t\tcurrent\t\t\taccumulative\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "ina_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->ina_cnt), accum_ofdm->ina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "fina_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->fina_cnt), accum_ofdm->fina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->plcp_err), accum_ofdm->plcp_err);
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->crc32_err), accum_ofdm->crc32_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "overrun_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->overrun_err),
+			 accum_ofdm->overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "early_overrun_err:\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->early_overrun_err),
+			 accum_ofdm->early_overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->crc32_good),
+			 accum_ofdm->crc32_good);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "false_alarm_cnt:\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->false_alarm_cnt),
+			 accum_ofdm->false_alarm_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "fina_sync_err_cnt:\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->fina_sync_err_cnt),
+			 accum_ofdm->fina_sync_err_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "sfd_timeout:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->sfd_timeout),
+			 accum_ofdm->sfd_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "fina_timeout:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->fina_timeout),
+			 accum_ofdm->fina_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "unresponded_rts:\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->unresponded_rts),
+			 accum_ofdm->unresponded_rts);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"rxe_frame_lmt_ovrun:\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->rxe_frame_limit_overrun),
+			 accum_ofdm->rxe_frame_limit_overrun);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "sent_ack_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->sent_ack_cnt),
+			 accum_ofdm->sent_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "sent_cts_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->sent_cts_cnt),
+			 accum_ofdm->sent_cts_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "sent_ba_rsp_cnt:\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->sent_ba_rsp_cnt),
+			 accum_ofdm->sent_ba_rsp_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "dsp_self_kill:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->dsp_self_kill),
+			 accum_ofdm->dsp_self_kill);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "mh_format_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->mh_format_err),
+			 accum_ofdm->mh_format_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "re_acq_main_rssi_sum:\t%u\t\t\t%u\n",
+			 le32_to_cpu(ofdm->re_acq_main_rssi_sum),
+			 accum_ofdm->re_acq_main_rssi_sum);
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - CCK:\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "ina_cnt: %u\n",
-			 le32_to_cpu(cck->ina_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "fina_cnt: %u\n",
-			 le32_to_cpu(cck->fina_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err: %u\n",
-			 le32_to_cpu(cck->plcp_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err: %u\n",
-			 le32_to_cpu(cck->crc32_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "overrun_err: %u\n",
-			 le32_to_cpu(cck->overrun_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "early_overrun_err: %u\n",
-			 le32_to_cpu(cck->early_overrun_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good: %u\n",
-			 le32_to_cpu(cck->crc32_good));
-	pos += scnprintf(buf + pos, bufsz - pos, "false_alarm_cnt: %u\n",
-			 le32_to_cpu(cck->false_alarm_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "fina_sync_err_cnt: %u\n",
-			 le32_to_cpu(cck->fina_sync_err_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "sfd_timeout: %u\n",
-			 le32_to_cpu(cck->sfd_timeout));
-	pos += scnprintf(buf + pos, bufsz - pos, "fina_timeout: %u\n",
-			 le32_to_cpu(cck->fina_timeout));
-	pos += scnprintf(buf + pos, bufsz - pos, "unresponded_rts: %u\n",
-			 le32_to_cpu(cck->unresponded_rts));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"rxe_frame_limit_overrun: %u\n",
-			le32_to_cpu(cck->rxe_frame_limit_overrun));
-	pos += scnprintf(buf + pos, bufsz - pos, "sent_ack_cnt: %u\n",
-			 le32_to_cpu(cck->sent_ack_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "sent_cts_cnt: %u\n",
-			 le32_to_cpu(cck->sent_cts_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "sent_ba_rsp_cnt: %u\n",
-			 le32_to_cpu(cck->sent_ba_rsp_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "dsp_self_kill: %u\n",
-			 le32_to_cpu(cck->dsp_self_kill));
-	pos += scnprintf(buf + pos, bufsz - pos, "mh_format_err: %u\n",
-			 le32_to_cpu(cck->mh_format_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "re_acq_main_rssi_sum: %u\n",
-			 le32_to_cpu(cck->re_acq_main_rssi_sum));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\t\t\tcurrent\t\t\taccumulative\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "ina_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->ina_cnt), accum_cck->ina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "fina_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->fina_cnt), accum_cck->fina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->plcp_err), accum_cck->plcp_err);
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->crc32_err), accum_cck->crc32_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "overrun_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->overrun_err),
+			 accum_cck->overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "early_overrun_err:\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->early_overrun_err),
+			 accum_cck->early_overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->crc32_good), accum_cck->crc32_good);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "false_alarm_cnt:\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->false_alarm_cnt),
+			 accum_cck->false_alarm_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "fina_sync_err_cnt:\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->fina_sync_err_cnt),
+			 accum_cck->fina_sync_err_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "sfd_timeout:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->sfd_timeout),
+			 accum_cck->sfd_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "fina_timeout:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->fina_timeout),
+			 accum_cck->fina_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "unresponded_rts:\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->unresponded_rts),
+			 accum_cck->unresponded_rts);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"rxe_frame_lmt_ovrun:\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->rxe_frame_limit_overrun),
+			 accum_cck->rxe_frame_limit_overrun);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "sent_ack_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->sent_ack_cnt),
+			 accum_cck->sent_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "sent_cts_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->sent_cts_cnt),
+			 accum_cck->sent_cts_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "sent_ba_rsp_cnt:\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->sent_ba_rsp_cnt),
+			 accum_cck->sent_ba_rsp_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "dsp_self_kill:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->dsp_self_kill),
+			 accum_cck->dsp_self_kill);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "mh_format_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->mh_format_err),
+			 accum_cck->mh_format_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "re_acq_main_rssi_sum:\t%u\t\t\t%u\n",
+			 le32_to_cpu(cck->re_acq_main_rssi_sum),
+			 accum_cck->re_acq_main_rssi_sum);
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - GENERAL:\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "bogus_cts: %u\n",
-			 le32_to_cpu(general->bogus_cts));
-	pos += scnprintf(buf + pos, bufsz - pos, "bogus_ack: %u\n",
-			 le32_to_cpu(general->bogus_ack));
-	pos += scnprintf(buf + pos, bufsz - pos, "non_bssid_frames: %u\n",
-			 le32_to_cpu(general->non_bssid_frames));
-	pos += scnprintf(buf + pos, bufsz - pos, "filtered_frames: %u\n",
-			 le32_to_cpu(general->filtered_frames));
-	pos += scnprintf(buf + pos, bufsz - pos, "non_channel_beacons: %u\n",
-			 le32_to_cpu(general->non_channel_beacons));
-	pos += scnprintf(buf + pos, bufsz - pos, "channel_beacons: %u\n",
-			 le32_to_cpu(general->channel_beacons));
-	pos += scnprintf(buf + pos, bufsz - pos, "num_missed_bcon: %u\n",
-			 le32_to_cpu(general->num_missed_bcon));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"adc_rx_saturation_time: %u\n",
-			le32_to_cpu(general->adc_rx_saturation_time));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"ina_detection_search_time: %u\n",
-			le32_to_cpu(general->ina_detection_search_time));
-	pos += scnprintf(buf + pos, bufsz - pos, "beacon_silence_rssi_a: %u\n",
-			 le32_to_cpu(general->beacon_silence_rssi_a));
-	pos += scnprintf(buf + pos, bufsz - pos, "beacon_silence_rssi_b: %u\n",
-			 le32_to_cpu(general->beacon_silence_rssi_b));
-	pos += scnprintf(buf + pos, bufsz - pos, "beacon_silence_rssi_c: %u\n",
-			 le32_to_cpu(general->beacon_silence_rssi_c));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"interference_data_flag: %u\n",
-			le32_to_cpu(general->interference_data_flag));
-	pos += scnprintf(buf + pos, bufsz - pos, "channel_load: %u\n",
-			 le32_to_cpu(general->channel_load));
-	pos += scnprintf(buf + pos, bufsz - pos, "dsp_false_alarms: %u\n",
-			 le32_to_cpu(general->dsp_false_alarms));
-	pos += scnprintf(buf + pos, bufsz - pos, "beacon_rssi_a: %u\n",
-			 le32_to_cpu(general->beacon_rssi_a));
-	pos += scnprintf(buf + pos, bufsz - pos, "beacon_rssi_b: %u\n",
-			 le32_to_cpu(general->beacon_rssi_b));
-	pos += scnprintf(buf + pos, bufsz - pos, "beacon_rssi_c: %u\n",
-			 le32_to_cpu(general->beacon_rssi_c));
-	pos += scnprintf(buf + pos, bufsz - pos, "beacon_energy_a: %u\n",
-			 le32_to_cpu(general->beacon_energy_a));
-	pos += scnprintf(buf + pos, bufsz - pos, "beacon_energy_b: %u\n",
-			 le32_to_cpu(general->beacon_energy_b));
-	pos += scnprintf(buf + pos, bufsz - pos, "beacon_energy_c: %u\n",
-			 le32_to_cpu(general->beacon_energy_c));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\t\t\tcurrent\t\t\taccumulative\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "bogus_cts:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->bogus_cts),
+			 accum_general->bogus_cts);
+	pos += scnprintf(buf + pos, bufsz - pos, "bogus_ack:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->bogus_ack),
+			 accum_general->bogus_ack);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "non_bssid_frames:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->non_bssid_frames),
+			 accum_general->non_bssid_frames);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "filtered_frames:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->filtered_frames),
+			 accum_general->filtered_frames);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "non_channel_beacons:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->non_channel_beacons),
+			 accum_general->non_channel_beacons);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "channel_beacons:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->channel_beacons),
+			 accum_general->channel_beacons);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "num_missed_bcon:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->num_missed_bcon),
+			 accum_general->num_missed_bcon);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"adc_rx_saturation_time:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->adc_rx_saturation_time),
+			 accum_general->adc_rx_saturation_time);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"ina_detect_search_tm:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->ina_detection_search_time),
+			 accum_general->ina_detection_search_time);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "beacon_silence_rssi_a:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->beacon_silence_rssi_a),
+			 accum_general->beacon_silence_rssi_a);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "beacon_silence_rssi_b:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->beacon_silence_rssi_b),
+			 accum_general->beacon_silence_rssi_b);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "beacon_silence_rssi_c:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->beacon_silence_rssi_c),
+			 accum_general->beacon_silence_rssi_c);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"interference_data_flag:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->interference_data_flag),
+			 accum_general->interference_data_flag);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "channel_load:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->channel_load),
+			 accum_general->channel_load);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "dsp_false_alarms:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->dsp_false_alarms),
+			 accum_general->dsp_false_alarms);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "beacon_rssi_a:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->beacon_rssi_a),
+			 accum_general->beacon_rssi_a);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "beacon_rssi_b:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->beacon_rssi_b),
+			 accum_general->beacon_rssi_b);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "beacon_rssi_c:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->beacon_rssi_c),
+			 accum_general->beacon_rssi_c);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "beacon_energy_a:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->beacon_energy_a),
+			 accum_general->beacon_energy_a);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "beacon_energy_b:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->beacon_energy_b),
+			 accum_general->beacon_energy_b);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "beacon_energy_c:\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->beacon_energy_c),
+			 accum_general->beacon_energy_c);
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - OFDM_HT:\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err: %u\n",
-			 le32_to_cpu(ht->plcp_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "overrun_err: %u\n",
-			 le32_to_cpu(ht->overrun_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "early_overrun_err: %u\n",
-			 le32_to_cpu(ht->early_overrun_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good: %u\n",
-			 le32_to_cpu(ht->crc32_good));
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err: %u\n",
-			 le32_to_cpu(ht->crc32_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "mh_format_err: %u\n",
-			 le32_to_cpu(ht->mh_format_err));
-	pos += scnprintf(buf + pos, bufsz - pos, "agg_crc32_good: %u\n",
-			 le32_to_cpu(ht->agg_crc32_good));
-	pos += scnprintf(buf + pos, bufsz - pos, "agg_mpdu_cnt: %u\n",
-			 le32_to_cpu(ht->agg_mpdu_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "agg_cnt: %u\n",
-			 le32_to_cpu(ht->agg_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\t\t\tcurrent\t\t\taccumulative\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ht->plcp_err), accum_ht->plcp_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "overrun_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ht->overrun_err), accum_ht->overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "early_overrun_err:\t%u\t\t\t%u\n",
+			 le32_to_cpu(ht->early_overrun_err),
+			 accum_ht->early_overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ht->crc32_good), accum_ht->crc32_good);
+	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ht->crc32_err), accum_ht->crc32_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "mh_format_err:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ht->mh_format_err),
+			 accum_ht->mh_format_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "agg_crc32_good:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ht->agg_crc32_good),
+			 accum_ht->agg_crc32_good);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "agg_mpdu_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ht->agg_mpdu_cnt),
+			 accum_ht->agg_mpdu_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "agg_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ht->agg_cnt), accum_ht->agg_cnt);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
@@ -1275,7 +1388,7 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	char *buf;
 	int bufsz = (sizeof(struct statistics_tx) * 24) + 250;
 	ssize_t ret;
-	struct statistics_tx *tx;
+	struct statistics_tx *tx, *accum_tx;
 
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
@@ -1301,62 +1414,107 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	 * might not reflect the current uCode activity
 	 */
 	tx = &priv->statistics.tx;
+	accum_tx = &priv->accum_statistics.tx;
 	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Tx:\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "preamble: %u\n",
-			 le32_to_cpu(tx->preamble_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "rx_detected_cnt: %u\n",
-			 le32_to_cpu(tx->rx_detected_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "bt_prio_defer_cnt: %u\n",
-			 le32_to_cpu(tx->bt_prio_defer_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "bt_prio_kill_cnt: %u\n",
-			 le32_to_cpu(tx->bt_prio_kill_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "few_bytes_cnt: %u\n",
-			 le32_to_cpu(tx->few_bytes_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "cts_timeout: %u\n",
-			 le32_to_cpu(tx->cts_timeout));
-	pos += scnprintf(buf + pos, bufsz - pos, "ack_timeout: %u\n",
-			 le32_to_cpu(tx->ack_timeout));
-	pos += scnprintf(buf + pos, bufsz - pos, "expected_ack_cnt: %u\n",
-			 le32_to_cpu(tx->expected_ack_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "actual_ack_cnt: %u\n",
-			 le32_to_cpu(tx->actual_ack_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "dump_msdu_cnt: %u\n",
-			 le32_to_cpu(tx->dump_msdu_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"burst_abort_next_frame_mismatch_cnt: %u\n",
-			le32_to_cpu(tx->burst_abort_next_frame_mismatch_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"burst_abort_missing_next_frame_cnt: %u\n",
-			le32_to_cpu(tx->burst_abort_missing_next_frame_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "cts_timeout_collision: %u\n",
-			 le32_to_cpu(tx->cts_timeout_collision));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"ack_or_ba_timeout_collision: %u\n",
-			le32_to_cpu(tx->ack_or_ba_timeout_collision));
-	pos += scnprintf(buf + pos, bufsz - pos, "agg ba_timeout: %u\n",
-			 le32_to_cpu(tx->agg.ba_timeout));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"agg ba_reschedule_frames: %u\n",
-			le32_to_cpu(tx->agg.ba_reschedule_frames));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"agg scd_query_agg_frame_cnt: %u\n",
-			le32_to_cpu(tx->agg.scd_query_agg_frame_cnt));
-	pos += scnprintf(buf + pos, bufsz - pos, "agg scd_query_no_agg: %u\n",
-			 le32_to_cpu(tx->agg.scd_query_no_agg));
-	pos += scnprintf(buf + pos, bufsz - pos, "agg scd_query_agg: %u\n",
-			 le32_to_cpu(tx->agg.scd_query_agg));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"agg scd_query_mismatch: %u\n",
-			le32_to_cpu(tx->agg.scd_query_mismatch));
-	pos += scnprintf(buf + pos, bufsz - pos, "agg frame_not_ready: %u\n",
-			 le32_to_cpu(tx->agg.frame_not_ready));
-	pos += scnprintf(buf + pos, bufsz - pos, "agg underrun: %u\n",
-			 le32_to_cpu(tx->agg.underrun));
-	pos += scnprintf(buf + pos, bufsz - pos, "agg bt_prio_kill: %u\n",
-			 le32_to_cpu(tx->agg.bt_prio_kill));
-	pos += scnprintf(buf + pos, bufsz - pos, "agg rx_ba_rsp_cnt: %u\n",
-			 le32_to_cpu(tx->agg.rx_ba_rsp_cnt));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\t\t\tcurrent\t\t\taccumulative\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "preamble:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->preamble_cnt),
+			 accum_tx->preamble_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "rx_detected_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->rx_detected_cnt),
+			 accum_tx->rx_detected_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "bt_prio_defer_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->bt_prio_defer_cnt),
+			 accum_tx->bt_prio_defer_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "bt_prio_kill_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->bt_prio_kill_cnt),
+			 accum_tx->bt_prio_kill_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "few_bytes_cnt:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->few_bytes_cnt),
+			 accum_tx->few_bytes_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "cts_timeout:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->cts_timeout), accum_tx->cts_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "ack_timeout:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->ack_timeout),
+			 accum_tx->ack_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "expected_ack_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->expected_ack_cnt),
+			 accum_tx->expected_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "actual_ack_cnt:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->actual_ack_cnt),
+			 accum_tx->actual_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "dump_msdu_cnt:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->dump_msdu_cnt),
+			 accum_tx->dump_msdu_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "abort_nxt_frame_mismatch:"
+			 "\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->burst_abort_next_frame_mismatch_cnt),
+			 accum_tx->burst_abort_next_frame_mismatch_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "abort_missing_nxt_frame:"
+			 "\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->burst_abort_missing_next_frame_cnt),
+			 accum_tx->burst_abort_missing_next_frame_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "cts_timeout_collision:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->cts_timeout_collision),
+			 accum_tx->cts_timeout_collision);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"ack_ba_timeout_collision:\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->ack_or_ba_timeout_collision),
+			 accum_tx->ack_or_ba_timeout_collision);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "agg ba_timeout:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->agg.ba_timeout),
+			 accum_tx->agg.ba_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"agg ba_resched_frames:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->agg.ba_reschedule_frames),
+			 accum_tx->agg.ba_reschedule_frames);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"agg scd_query_agg_frame:\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->agg.scd_query_agg_frame_cnt),
+			 accum_tx->agg.scd_query_agg_frame_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "agg scd_query_no_agg:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->agg.scd_query_no_agg),
+			 accum_tx->agg.scd_query_no_agg);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "agg scd_query_agg:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->agg.scd_query_agg),
+			 accum_tx->agg.scd_query_agg);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"agg scd_query_mismatch:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->agg.scd_query_mismatch),
+			 accum_tx->agg.scd_query_mismatch);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "agg frame_not_ready:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->agg.frame_not_ready),
+			 accum_tx->agg.frame_not_ready);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "agg underrun:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->agg.underrun),
+			 accum_tx->agg.underrun);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "agg bt_prio_kill:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->agg.bt_prio_kill),
+			 accum_tx->agg.bt_prio_kill);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "agg rx_ba_rsp_cnt:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(tx->agg.rx_ba_rsp_cnt),
+			 accum_tx->agg.rx_ba_rsp_cnt);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
@@ -1372,9 +1530,9 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 	char *buf;
 	int bufsz = sizeof(struct statistics_general) * 4 + 250;
 	ssize_t ret;
-	struct statistics_general *general;
-	struct statistics_dbg *dbg;
-	struct statistics_div *div;
+	struct statistics_general *general, *accum_general;
+	struct statistics_dbg *dbg, *accum_dbg;
+	struct statistics_div *div, *accum_div;
 
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
@@ -1402,34 +1560,53 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 	general = &priv->statistics.general;
 	dbg = &priv->statistics.general.dbg;
 	div = &priv->statistics.general.div;
+	accum_general = &priv->accum_statistics.general;
+	accum_dbg = &priv->accum_statistics.general.dbg;
+	accum_div = &priv->accum_statistics.general.div;
 	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_General:\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "temperature: %u\n",
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\t\t\tcurrent\t\t\taccumulative\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "temperature:\t\t\t%u\n",
 			 le32_to_cpu(general->temperature));
-	pos += scnprintf(buf + pos, bufsz - pos, "temperature_m: %u\n",
+	pos += scnprintf(buf + pos, bufsz - pos, "temperature_m:\t\t\t%u\n",
 			 le32_to_cpu(general->temperature_m));
-	pos += scnprintf(buf + pos, bufsz - pos, "burst_check: %u\n",
-			 le32_to_cpu(dbg->burst_check));
-	pos += scnprintf(buf + pos, bufsz - pos, "burst_count: %u\n",
-			 le32_to_cpu(dbg->burst_count));
-	pos += scnprintf(buf + pos, bufsz - pos, "sleep_time: %u\n",
-			 le32_to_cpu(general->sleep_time));
-	pos += scnprintf(buf + pos, bufsz - pos, "slots_out: %u\n",
-			 le32_to_cpu(general->slots_out));
-	pos += scnprintf(buf + pos, bufsz - pos, "slots_idle: %u\n",
-			 le32_to_cpu(general->slots_idle));
-	pos += scnprintf(buf + pos, bufsz - pos, "ttl_timestamp: %u\n",
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "burst_check:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(dbg->burst_check),
+			 accum_dbg->burst_check);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "burst_count:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(dbg->burst_count),
+			 accum_dbg->burst_count);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "sleep_time:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->sleep_time),
+			 accum_general->sleep_time);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "slots_out:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->slots_out),
+			 accum_general->slots_out);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "slots_idle:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->slots_idle),
+			 accum_general->slots_idle);
+	pos += scnprintf(buf + pos, bufsz - pos, "ttl_timestamp:\t\t\t%u\n",
 			 le32_to_cpu(general->ttl_timestamp));
-	pos += scnprintf(buf + pos, bufsz - pos, "tx_on_a: %u\n",
-			 le32_to_cpu(div->tx_on_a));
-	pos += scnprintf(buf + pos, bufsz - pos, "tx_on_b: %u\n",
-			 le32_to_cpu(div->tx_on_b));
-	pos += scnprintf(buf + pos, bufsz - pos, "exec_time: %u\n",
-			 le32_to_cpu(div->exec_time));
-	pos += scnprintf(buf + pos, bufsz - pos, "probe_time: %u\n",
-			 le32_to_cpu(div->probe_time));
-	pos += scnprintf(buf + pos, bufsz - pos, "rx_enable_counter: %u\n",
-			 le32_to_cpu(general->rx_enable_counter));
+	pos += scnprintf(buf + pos, bufsz - pos, "tx_on_a:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(div->tx_on_a), accum_div->tx_on_a);
+	pos += scnprintf(buf + pos, bufsz - pos, "tx_on_b:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(div->tx_on_b), accum_div->tx_on_b);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "exec_time:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(div->exec_time), accum_div->exec_time);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "probe_time:\t\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(div->probe_time), accum_div->probe_time);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "rx_enable_counter:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(general->rx_enable_counter),
+			 accum_general->rx_enable_counter);
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6d7c235..8d087f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1124,7 +1124,9 @@ struct iwl_priv {
 	struct iwl_tt_mgmt thermal_throttle;
 
 	struct iwl_notif_statistics statistics;
-	unsigned long last_statistics_time;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	struct iwl_notif_statistics accum_statistics;
+#endif
 
 	/* context information */
 	u16 rates_mask;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 493626b..7ad327e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -548,6 +548,44 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 			priv->last_rx_noise);
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+/*
+ *  based on the assumption of all statistics counter are in DWORD
+ *  FIXME: This function is for debugging, do not deal with
+ *  the case of counters roll-over.
+ */
+static void iwl_accumulative_statistics(struct iwl_priv *priv,
+					__le32 *stats)
+{
+	int i;
+	__le32 *prev_stats;
+	u32 *accum_stats;
+
+	prev_stats = (__le32 *)&priv->statistics;
+	accum_stats = (u32 *)&priv->accum_statistics;
+
+	for (i = sizeof(__le32); i < sizeof(struct iwl_notif_statistics);
+	     i += sizeof(__le32), stats++, prev_stats++, accum_stats++)
+		if (le32_to_cpu(*stats) > le32_to_cpu(*prev_stats))
+			*accum_stats += (le32_to_cpu(*stats) -
+				le32_to_cpu(*prev_stats));
+
+	/* reset accumulative statistics for "no-counter" type statistics */
+	priv->accum_statistics.general.temperature =
+		priv->statistics.general.temperature;
+	priv->accum_statistics.general.temperature_m =
+		priv->statistics.general.temperature_m;
+	priv->accum_statistics.general.ttl_timestamp =
+		priv->statistics.general.ttl_timestamp;
+	priv->accum_statistics.tx.tx_power.ant_a =
+		priv->statistics.tx.tx_power.ant_a;
+	priv->accum_statistics.tx.tx_power.ant_b =
+		priv->statistics.tx.tx_power.ant_b;
+	priv->accum_statistics.tx.tx_power.ant_c =
+		priv->statistics.tx.tx_power.ant_c;
+}
+#endif
+
 #define REG_RECALIB_PERIOD (60)
 
 void iwl_rx_statistics(struct iwl_priv *priv,
@@ -566,6 +604,9 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 		    STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
 		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
+#endif
 	memcpy(&priv->statistics, &pkt->u.stats, sizeof(priv->statistics));
 
 	set_bit(STATUS_STATISTICS, &priv->status);
-- 
1.5.6.3

