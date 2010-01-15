Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758510Ab0AOVnr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:47 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/9] iwlwifi: format and show statistics counter from uCode
Date: Fri, 15 Jan 2010 13:43:34 -0800
Message-Id: <1263591821-14867-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
References: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

To help debug uCode related problem, adding "delta" and "max"
information in debugfs statistics counters display.

Those information show the delta between two statistics report from
uCode, user can monitor the counters for any "un-normal" behavior.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Jay Sternberg<jay.e.sternberg@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |  850 +++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-rx.c      |   19 +-
 3 files changed, 545 insertions(+), 326 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 4a2ac93..2264cbd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1081,6 +1081,12 @@ static int iwl_dbgfs_statistics_flag(struct iwl_priv *priv, char *buf,
 	return p;
 }
 
+static const char ucode_stats_header[] =
+	"%-32s     current  acumulative       delta         max\n";
+static const char ucode_stats_short_format[] =
+	"  %-30s %10u\n";
+static const char ucode_stats_format[] =
+	"  %-30s %10u  %10u  %10u  %10u\n";
 
 static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 					char __user *user_buf,
@@ -1089,14 +1095,15 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 	struct iwl_priv *priv = file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = sizeof(struct statistics_rx_phy) * 20 +
-		sizeof(struct statistics_rx_non_phy) * 20 +
-		sizeof(struct statistics_rx_ht_phy) * 20 + 400;
+	int bufsz = sizeof(struct statistics_rx_phy) * 40 +
+		sizeof(struct statistics_rx_non_phy) * 40 +
+		sizeof(struct statistics_rx_ht_phy) * 40 + 400;
 	ssize_t ret;
-	struct statistics_rx_phy *ofdm, *accum_ofdm;
-	struct statistics_rx_phy *cck, *accum_cck;
+	struct statistics_rx_phy *ofdm, *accum_ofdm, *delta_ofdm, *max_ofdm;
+	struct statistics_rx_phy *cck, *accum_cck, *delta_cck, *max_cck;
 	struct statistics_rx_non_phy *general, *accum_general;
-	struct statistics_rx_ht_phy *ht, *accum_ht;
+	struct statistics_rx_non_phy *delta_general, *max_general;
+	struct statistics_rx_ht_phy *ht, *accum_ht, *delta_ht, *max_ht;
 
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
@@ -1129,267 +1136,401 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 	accum_cck = &priv->accum_statistics.rx.cck;
 	accum_general = &priv->accum_statistics.rx.general;
 	accum_ht = &priv->accum_statistics.rx.ofdm_ht;
+	delta_ofdm = &priv->delta_statistics.rx.ofdm;
+	delta_cck = &priv->delta_statistics.rx.cck;
+	delta_general = &priv->delta_statistics.rx.general;
+	delta_ht = &priv->delta_statistics.rx.ofdm_ht;
+	max_ofdm = &priv->max_delta.rx.ofdm;
+	max_cck = &priv->max_delta.rx.cck;
+	max_general = &priv->max_delta.rx.general;
+	max_ht = &priv->max_delta.rx.ofdm_ht;
+
 	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
-	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - OFDM:\n");
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"\t\t\tcurrent\t\t\taccumulative\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "ina_cnt:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(ofdm->ina_cnt), accum_ofdm->ina_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "fina_cnt:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(ofdm->fina_cnt), accum_ofdm->fina_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(ofdm->plcp_err), accum_ofdm->plcp_err);
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(ofdm->crc32_err), accum_ofdm->crc32_err);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "overrun_err:\t\t%u\t\t\t%u\n",
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_header,
+			 "Statistics_Rx - OFDM:");
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "ina_cnt:", le32_to_cpu(ofdm->ina_cnt),
+			 accum_ofdm->ina_cnt,
+			 delta_ofdm->ina_cnt, max_ofdm->ina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "fina_cnt:",
+			 le32_to_cpu(ofdm->fina_cnt), accum_ofdm->fina_cnt,
+			 delta_ofdm->fina_cnt, max_ofdm->fina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "plcp_err:",
+			 le32_to_cpu(ofdm->plcp_err), accum_ofdm->plcp_err,
+			 delta_ofdm->plcp_err, max_ofdm->plcp_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "crc32_err:",
+			 le32_to_cpu(ofdm->crc32_err), accum_ofdm->crc32_err,
+			 delta_ofdm->crc32_err, max_ofdm->crc32_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "overrun_err:",
 			 le32_to_cpu(ofdm->overrun_err),
-			 accum_ofdm->overrun_err);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "early_overrun_err:\t%u\t\t\t%u\n",
+			 accum_ofdm->overrun_err,
+			 delta_ofdm->overrun_err, max_ofdm->overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "early_overrun_err:",
 			 le32_to_cpu(ofdm->early_overrun_err),
-			 accum_ofdm->early_overrun_err);
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good:\t\t%u\t\t\t%u\n",
+			 accum_ofdm->early_overrun_err,
+			 delta_ofdm->early_overrun_err,
+			 max_ofdm->early_overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "crc32_good:",
 			 le32_to_cpu(ofdm->crc32_good),
-			 accum_ofdm->crc32_good);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "false_alarm_cnt:\t%u\t\t\t%u\n",
+			 accum_ofdm->crc32_good,
+			 delta_ofdm->crc32_good, max_ofdm->crc32_good);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "false_alarm_cnt:",
 			 le32_to_cpu(ofdm->false_alarm_cnt),
-			 accum_ofdm->false_alarm_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "fina_sync_err_cnt:\t%u\t\t\t%u\n",
+			 accum_ofdm->false_alarm_cnt,
+			 delta_ofdm->false_alarm_cnt,
+			 max_ofdm->false_alarm_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "fina_sync_err_cnt:",
 			 le32_to_cpu(ofdm->fina_sync_err_cnt),
-			 accum_ofdm->fina_sync_err_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "sfd_timeout:\t\t%u\t\t\t%u\n",
+			 accum_ofdm->fina_sync_err_cnt,
+			 delta_ofdm->fina_sync_err_cnt,
+			 max_ofdm->fina_sync_err_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "sfd_timeout:",
 			 le32_to_cpu(ofdm->sfd_timeout),
-			 accum_ofdm->sfd_timeout);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "fina_timeout:\t\t%u\t\t\t%u\n",
+			 accum_ofdm->sfd_timeout,
+			 delta_ofdm->sfd_timeout,
+			 max_ofdm->sfd_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "fina_timeout:",
 			 le32_to_cpu(ofdm->fina_timeout),
-			 accum_ofdm->fina_timeout);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "unresponded_rts:\t%u\t\t\t%u\n",
+			 accum_ofdm->fina_timeout,
+			 delta_ofdm->fina_timeout,
+			 max_ofdm->fina_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "unresponded_rts:",
 			 le32_to_cpu(ofdm->unresponded_rts),
-			 accum_ofdm->unresponded_rts);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"rxe_frame_lmt_ovrun:\t%u\t\t\t%u\n",
+			 accum_ofdm->unresponded_rts,
+			 delta_ofdm->unresponded_rts,
+			 max_ofdm->unresponded_rts);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			"rxe_frame_lmt_ovrun:",
 			 le32_to_cpu(ofdm->rxe_frame_limit_overrun),
-			 accum_ofdm->rxe_frame_limit_overrun);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "sent_ack_cnt:\t\t%u\t\t\t%u\n",
+			 accum_ofdm->rxe_frame_limit_overrun,
+			 delta_ofdm->rxe_frame_limit_overrun,
+			 max_ofdm->rxe_frame_limit_overrun);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "sent_ack_cnt:",
 			 le32_to_cpu(ofdm->sent_ack_cnt),
-			 accum_ofdm->sent_ack_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "sent_cts_cnt:\t\t%u\t\t\t%u\n",
+			 accum_ofdm->sent_ack_cnt,
+			 delta_ofdm->sent_ack_cnt,
+			 max_ofdm->sent_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "sent_cts_cnt:",
 			 le32_to_cpu(ofdm->sent_cts_cnt),
-			 accum_ofdm->sent_cts_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "sent_ba_rsp_cnt:\t%u\t\t\t%u\n",
+			 accum_ofdm->sent_cts_cnt,
+			 delta_ofdm->sent_cts_cnt, max_ofdm->sent_cts_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "sent_ba_rsp_cnt:",
 			 le32_to_cpu(ofdm->sent_ba_rsp_cnt),
-			 accum_ofdm->sent_ba_rsp_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "dsp_self_kill:\t\t%u\t\t\t%u\n",
+			 accum_ofdm->sent_ba_rsp_cnt,
+			 delta_ofdm->sent_ba_rsp_cnt,
+			 max_ofdm->sent_ba_rsp_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "dsp_self_kill:",
 			 le32_to_cpu(ofdm->dsp_self_kill),
-			 accum_ofdm->dsp_self_kill);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "mh_format_err:\t\t%u\t\t\t%u\n",
+			 accum_ofdm->dsp_self_kill,
+			 delta_ofdm->dsp_self_kill,
+			 max_ofdm->dsp_self_kill);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "mh_format_err:",
 			 le32_to_cpu(ofdm->mh_format_err),
-			 accum_ofdm->mh_format_err);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "re_acq_main_rssi_sum:\t%u\t\t\t%u\n",
+			 accum_ofdm->mh_format_err,
+			 delta_ofdm->mh_format_err,
+			 max_ofdm->mh_format_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "re_acq_main_rssi_sum:",
 			 le32_to_cpu(ofdm->re_acq_main_rssi_sum),
-			 accum_ofdm->re_acq_main_rssi_sum);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - CCK:\n");
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"\t\t\tcurrent\t\t\taccumulative\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "ina_cnt:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(cck->ina_cnt), accum_cck->ina_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "fina_cnt:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(cck->fina_cnt), accum_cck->fina_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(cck->plcp_err), accum_cck->plcp_err);
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(cck->crc32_err), accum_cck->crc32_err);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "overrun_err:\t\t%u\t\t\t%u\n",
+			 accum_ofdm->re_acq_main_rssi_sum,
+			 delta_ofdm->re_acq_main_rssi_sum,
+			max_ofdm->re_acq_main_rssi_sum);
+
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_header,
+			 "Statistics_Rx - CCK:");
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "ina_cnt:",
+			 le32_to_cpu(cck->ina_cnt), accum_cck->ina_cnt,
+			 delta_cck->ina_cnt, max_cck->ina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "fina_cnt:",
+			 le32_to_cpu(cck->fina_cnt), accum_cck->fina_cnt,
+			 delta_cck->fina_cnt, max_cck->fina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "plcp_err:",
+			 le32_to_cpu(cck->plcp_err), accum_cck->plcp_err,
+			 delta_cck->plcp_err, max_cck->plcp_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "crc32_err:",
+			 le32_to_cpu(cck->crc32_err), accum_cck->crc32_err,
+			 delta_cck->crc32_err, max_cck->crc32_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "overrun_err:",
 			 le32_to_cpu(cck->overrun_err),
-			 accum_cck->overrun_err);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "early_overrun_err:\t%u\t\t\t%u\n",
+			 accum_cck->overrun_err,
+			 delta_cck->overrun_err, max_cck->overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "early_overrun_err:",
 			 le32_to_cpu(cck->early_overrun_err),
-			 accum_cck->early_overrun_err);
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(cck->crc32_good), accum_cck->crc32_good);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "false_alarm_cnt:\t%u\t\t\t%u\n",
+			 accum_cck->early_overrun_err,
+			 delta_cck->early_overrun_err,
+			 max_cck->early_overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "crc32_good:",
+			 le32_to_cpu(cck->crc32_good), accum_cck->crc32_good,
+			 delta_cck->crc32_good,
+			 max_cck->crc32_good);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "false_alarm_cnt:",
 			 le32_to_cpu(cck->false_alarm_cnt),
-			 accum_cck->false_alarm_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "fina_sync_err_cnt:\t%u\t\t\t%u\n",
+			 accum_cck->false_alarm_cnt,
+			 delta_cck->false_alarm_cnt, max_cck->false_alarm_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "fina_sync_err_cnt:",
 			 le32_to_cpu(cck->fina_sync_err_cnt),
-			 accum_cck->fina_sync_err_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "sfd_timeout:\t\t%u\t\t\t%u\n",
+			 accum_cck->fina_sync_err_cnt,
+			 delta_cck->fina_sync_err_cnt,
+			 max_cck->fina_sync_err_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "sfd_timeout:",
 			 le32_to_cpu(cck->sfd_timeout),
-			 accum_cck->sfd_timeout);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "fina_timeout:\t\t%u\t\t\t%u\n",
+			 accum_cck->sfd_timeout,
+			 delta_cck->sfd_timeout, max_cck->sfd_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "fina_timeout:",
 			 le32_to_cpu(cck->fina_timeout),
-			 accum_cck->fina_timeout);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "unresponded_rts:\t%u\t\t\t%u\n",
+			 accum_cck->fina_timeout,
+			 delta_cck->fina_timeout, max_cck->fina_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "unresponded_rts:",
 			 le32_to_cpu(cck->unresponded_rts),
-			 accum_cck->unresponded_rts);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"rxe_frame_lmt_ovrun:\t%u\t\t\t%u\n",
+			 accum_cck->unresponded_rts,
+			 delta_cck->unresponded_rts,
+			 max_cck->unresponded_rts);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			"rxe_frame_lmt_ovrun:",
 			 le32_to_cpu(cck->rxe_frame_limit_overrun),
-			 accum_cck->rxe_frame_limit_overrun);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "sent_ack_cnt:\t\t%u\t\t\t%u\n",
+			 accum_cck->rxe_frame_limit_overrun,
+			 delta_cck->rxe_frame_limit_overrun,
+			 max_cck->rxe_frame_limit_overrun);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "sent_ack_cnt:",
 			 le32_to_cpu(cck->sent_ack_cnt),
-			 accum_cck->sent_ack_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "sent_cts_cnt:\t\t%u\t\t\t%u\n",
+			 accum_cck->sent_ack_cnt,
+			 delta_cck->sent_ack_cnt,
+			 max_cck->sent_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "sent_cts_cnt:",
 			 le32_to_cpu(cck->sent_cts_cnt),
-			 accum_cck->sent_cts_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "sent_ba_rsp_cnt:\t%u\t\t\t%u\n",
+			 accum_cck->sent_cts_cnt,
+			 delta_cck->sent_cts_cnt,
+			 max_cck->sent_cts_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "sent_ba_rsp_cnt:",
 			 le32_to_cpu(cck->sent_ba_rsp_cnt),
-			 accum_cck->sent_ba_rsp_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "dsp_self_kill:\t\t%u\t\t\t%u\n",
+			 accum_cck->sent_ba_rsp_cnt,
+			 delta_cck->sent_ba_rsp_cnt,
+			 max_cck->sent_ba_rsp_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "dsp_self_kill:",
 			 le32_to_cpu(cck->dsp_self_kill),
-			 accum_cck->dsp_self_kill);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "mh_format_err:\t\t%u\t\t\t%u\n",
+			 accum_cck->dsp_self_kill,
+			 delta_cck->dsp_self_kill,
+			 max_cck->dsp_self_kill);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "mh_format_err:",
 			 le32_to_cpu(cck->mh_format_err),
-			 accum_cck->mh_format_err);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "re_acq_main_rssi_sum:\t%u\t\t\t%u\n",
+			 accum_cck->mh_format_err,
+			 delta_cck->mh_format_err, max_cck->mh_format_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "re_acq_main_rssi_sum:",
 			 le32_to_cpu(cck->re_acq_main_rssi_sum),
-			 accum_cck->re_acq_main_rssi_sum);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - GENERAL:\n");
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"\t\t\tcurrent\t\t\taccumulative\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "bogus_cts:\t\t%u\t\t\t%u\n",
+			 accum_cck->re_acq_main_rssi_sum,
+			 delta_cck->re_acq_main_rssi_sum,
+			 max_cck->re_acq_main_rssi_sum);
+
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_header,
+			"Statistics_Rx - GENERAL:");
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "bogus_cts:",
 			 le32_to_cpu(general->bogus_cts),
-			 accum_general->bogus_cts);
-	pos += scnprintf(buf + pos, bufsz - pos, "bogus_ack:\t\t%u\t\t\t%u\n",
+			 accum_general->bogus_cts,
+			 delta_general->bogus_cts, max_general->bogus_cts);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "bogus_ack:",
 			 le32_to_cpu(general->bogus_ack),
-			 accum_general->bogus_ack);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "non_bssid_frames:\t%u\t\t\t%u\n",
+			 accum_general->bogus_ack,
+			 delta_general->bogus_ack, max_general->bogus_ack);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "non_bssid_frames:",
 			 le32_to_cpu(general->non_bssid_frames),
-			 accum_general->non_bssid_frames);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "filtered_frames:\t%u\t\t\t%u\n",
+			 accum_general->non_bssid_frames,
+			 delta_general->non_bssid_frames,
+			 max_general->non_bssid_frames);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "filtered_frames:",
 			 le32_to_cpu(general->filtered_frames),
-			 accum_general->filtered_frames);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "non_channel_beacons:\t%u\t\t\t%u\n",
+			 accum_general->filtered_frames,
+			 delta_general->filtered_frames,
+			 max_general->filtered_frames);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "non_channel_beacons:",
 			 le32_to_cpu(general->non_channel_beacons),
-			 accum_general->non_channel_beacons);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "channel_beacons:\t%u\t\t\t%u\n",
+			 accum_general->non_channel_beacons,
+			 delta_general->non_channel_beacons,
+			 max_general->non_channel_beacons);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "channel_beacons:",
 			 le32_to_cpu(general->channel_beacons),
-			 accum_general->channel_beacons);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "num_missed_bcon:\t%u\t\t\t%u\n",
+			 accum_general->channel_beacons,
+			 delta_general->channel_beacons,
+			 max_general->channel_beacons);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "num_missed_bcon:",
 			 le32_to_cpu(general->num_missed_bcon),
-			 accum_general->num_missed_bcon);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"adc_rx_saturation_time:\t%u\t\t\t%u\n",
+			 accum_general->num_missed_bcon,
+			 delta_general->num_missed_bcon,
+			 max_general->num_missed_bcon);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			"adc_rx_saturation_time:",
 			 le32_to_cpu(general->adc_rx_saturation_time),
-			 accum_general->adc_rx_saturation_time);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"ina_detect_search_tm:\t%u\t\t\t%u\n",
+			 accum_general->adc_rx_saturation_time,
+			 delta_general->adc_rx_saturation_time,
+			 max_general->adc_rx_saturation_time);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			"ina_detect_search_tm:",
 			 le32_to_cpu(general->ina_detection_search_time),
-			 accum_general->ina_detection_search_time);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "beacon_silence_rssi_a:\t%u\t\t\t%u\n",
+			 accum_general->ina_detection_search_time,
+			 delta_general->ina_detection_search_time,
+			 max_general->ina_detection_search_time);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "beacon_silence_rssi_a:",
 			 le32_to_cpu(general->beacon_silence_rssi_a),
-			 accum_general->beacon_silence_rssi_a);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "beacon_silence_rssi_b:\t%u\t\t\t%u\n",
+			 accum_general->beacon_silence_rssi_a,
+			 delta_general->beacon_silence_rssi_a,
+			 max_general->beacon_silence_rssi_a);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "beacon_silence_rssi_b:",
 			 le32_to_cpu(general->beacon_silence_rssi_b),
-			 accum_general->beacon_silence_rssi_b);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "beacon_silence_rssi_c:\t%u\t\t\t%u\n",
+			 accum_general->beacon_silence_rssi_b,
+			 delta_general->beacon_silence_rssi_b,
+			 max_general->beacon_silence_rssi_b);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "beacon_silence_rssi_c:",
 			 le32_to_cpu(general->beacon_silence_rssi_c),
-			 accum_general->beacon_silence_rssi_c);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"interference_data_flag:\t%u\t\t\t%u\n",
+			 accum_general->beacon_silence_rssi_c,
+			 delta_general->beacon_silence_rssi_c,
+			 max_general->beacon_silence_rssi_c);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			"interference_data_flag:",
 			 le32_to_cpu(general->interference_data_flag),
-			 accum_general->interference_data_flag);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "channel_load:\t\t%u\t\t\t%u\n",
+			 accum_general->interference_data_flag,
+			 delta_general->interference_data_flag,
+			 max_general->interference_data_flag);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "channel_load:",
 			 le32_to_cpu(general->channel_load),
-			 accum_general->channel_load);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "dsp_false_alarms:\t%u\t\t\t%u\n",
+			 accum_general->channel_load,
+			 delta_general->channel_load,
+			 max_general->channel_load);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "dsp_false_alarms:",
 			 le32_to_cpu(general->dsp_false_alarms),
-			 accum_general->dsp_false_alarms);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "beacon_rssi_a:\t\t%u\t\t\t%u\n",
+			 accum_general->dsp_false_alarms,
+			 delta_general->dsp_false_alarms,
+			 max_general->dsp_false_alarms);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "beacon_rssi_a:",
 			 le32_to_cpu(general->beacon_rssi_a),
-			 accum_general->beacon_rssi_a);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "beacon_rssi_b:\t\t%u\t\t\t%u\n",
+			 accum_general->beacon_rssi_a,
+			 delta_general->beacon_rssi_a,
+			 max_general->beacon_rssi_a);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "beacon_rssi_b:",
 			 le32_to_cpu(general->beacon_rssi_b),
-			 accum_general->beacon_rssi_b);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "beacon_rssi_c:\t\t%u\t\t\t%u\n",
+			 accum_general->beacon_rssi_b,
+			 delta_general->beacon_rssi_b,
+			 max_general->beacon_rssi_b);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "beacon_rssi_c:",
 			 le32_to_cpu(general->beacon_rssi_c),
-			 accum_general->beacon_rssi_c);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "beacon_energy_a:\t%u\t\t\t%u\n",
+			 accum_general->beacon_rssi_c,
+			 delta_general->beacon_rssi_c,
+			 max_general->beacon_rssi_c);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "beacon_energy_a:",
 			 le32_to_cpu(general->beacon_energy_a),
-			 accum_general->beacon_energy_a);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "beacon_energy_b:\t%u\t\t\t%u\n",
+			 accum_general->beacon_energy_a,
+			 delta_general->beacon_energy_a,
+			 max_general->beacon_energy_a);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "beacon_energy_b:",
 			 le32_to_cpu(general->beacon_energy_b),
-			 accum_general->beacon_energy_b);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "beacon_energy_c:\t%u\t\t\t%u\n",
+			 accum_general->beacon_energy_b,
+			 delta_general->beacon_energy_b,
+			 max_general->beacon_energy_b);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "beacon_energy_c:",
 			 le32_to_cpu(general->beacon_energy_c),
-			 accum_general->beacon_energy_c);
+			 accum_general->beacon_energy_c,
+			 delta_general->beacon_energy_c,
+			 max_general->beacon_energy_c);
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Rx - OFDM_HT:\n");
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"\t\t\tcurrent\t\t\taccumulative\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "plcp_err:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(ht->plcp_err), accum_ht->plcp_err);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "overrun_err:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(ht->overrun_err), accum_ht->overrun_err);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "early_overrun_err:\t%u\t\t\t%u\n",
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_header,
+			"Statistics_Rx - OFDM_HT:");
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "plcp_err:",
+			 le32_to_cpu(ht->plcp_err), accum_ht->plcp_err,
+			 delta_ht->plcp_err, max_ht->plcp_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "overrun_err:",
+			 le32_to_cpu(ht->overrun_err), accum_ht->overrun_err,
+			 delta_ht->overrun_err, max_ht->overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "early_overrun_err:",
 			 le32_to_cpu(ht->early_overrun_err),
-			 accum_ht->early_overrun_err);
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_good:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(ht->crc32_good), accum_ht->crc32_good);
-	pos += scnprintf(buf + pos, bufsz - pos, "crc32_err:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(ht->crc32_err), accum_ht->crc32_err);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "mh_format_err:\t\t%u\t\t\t%u\n",
+			 accum_ht->early_overrun_err,
+			 delta_ht->early_overrun_err,
+			 max_ht->early_overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "crc32_good:",
+			 le32_to_cpu(ht->crc32_good), accum_ht->crc32_good,
+			 delta_ht->crc32_good, max_ht->crc32_good);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "crc32_err:",
+			 le32_to_cpu(ht->crc32_err), accum_ht->crc32_err,
+			 delta_ht->crc32_err, max_ht->crc32_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "mh_format_err:",
 			 le32_to_cpu(ht->mh_format_err),
-			 accum_ht->mh_format_err);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "agg_crc32_good:\t\t%u\t\t\t%u\n",
+			 accum_ht->mh_format_err,
+			 delta_ht->mh_format_err, max_ht->mh_format_err);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "agg_crc32_good:",
 			 le32_to_cpu(ht->agg_crc32_good),
-			 accum_ht->agg_crc32_good);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "agg_mpdu_cnt:\t\t%u\t\t\t%u\n",
+			 accum_ht->agg_crc32_good,
+			 delta_ht->agg_crc32_good, max_ht->agg_crc32_good);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "agg_mpdu_cnt:",
 			 le32_to_cpu(ht->agg_mpdu_cnt),
-			 accum_ht->agg_mpdu_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "agg_cnt:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(ht->agg_cnt), accum_ht->agg_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "unsupport_mcs:\t\t%u\t\t\t%u\n",
+			 accum_ht->agg_mpdu_cnt,
+			 delta_ht->agg_mpdu_cnt, max_ht->agg_mpdu_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "agg_cnt:",
+			 le32_to_cpu(ht->agg_cnt), accum_ht->agg_cnt,
+			 delta_ht->agg_cnt, max_ht->agg_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "unsupport_mcs:",
 			 le32_to_cpu(ht->unsupport_mcs),
-			 accum_ht->unsupport_mcs);
+			 accum_ht->unsupport_mcs,
+			 delta_ht->unsupport_mcs, max_ht->unsupport_mcs);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
@@ -1403,9 +1544,9 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	struct iwl_priv *priv = file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = (sizeof(struct statistics_tx) * 24) + 250;
+	int bufsz = (sizeof(struct statistics_tx) * 48) + 250;
 	ssize_t ret;
-	struct statistics_tx *tx, *accum_tx;
+	struct statistics_tx *tx, *accum_tx, *delta_tx, *max_tx;
 
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
@@ -1432,106 +1573,148 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	 */
 	tx = &priv->statistics.tx;
 	accum_tx = &priv->accum_statistics.tx;
+	delta_tx = &priv->delta_statistics.tx;
+	max_tx = &priv->max_delta.tx;
 	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
-	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_Tx:\n");
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"\t\t\tcurrent\t\t\taccumulative\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "preamble:\t\t\t%u\t\t\t%u\n",
+	pos += scnprintf(buf + pos, bufsz - pos,  ucode_stats_header,
+			"Statistics_Tx:");
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "preamble:",
 			 le32_to_cpu(tx->preamble_cnt),
-			 accum_tx->preamble_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "rx_detected_cnt:\t\t%u\t\t\t%u\n",
+			 accum_tx->preamble_cnt,
+			 delta_tx->preamble_cnt, max_tx->preamble_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "rx_detected_cnt:",
 			 le32_to_cpu(tx->rx_detected_cnt),
-			 accum_tx->rx_detected_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "bt_prio_defer_cnt:\t\t%u\t\t\t%u\n",
+			 accum_tx->rx_detected_cnt,
+			 delta_tx->rx_detected_cnt, max_tx->rx_detected_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "bt_prio_defer_cnt:",
 			 le32_to_cpu(tx->bt_prio_defer_cnt),
-			 accum_tx->bt_prio_defer_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "bt_prio_kill_cnt:\t\t%u\t\t\t%u\n",
+			 accum_tx->bt_prio_defer_cnt,
+			 delta_tx->bt_prio_defer_cnt,
+			 max_tx->bt_prio_defer_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "bt_prio_kill_cnt:",
 			 le32_to_cpu(tx->bt_prio_kill_cnt),
-			 accum_tx->bt_prio_kill_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "few_bytes_cnt:\t\t\t%u\t\t\t%u\n",
+			 accum_tx->bt_prio_kill_cnt,
+			 delta_tx->bt_prio_kill_cnt,
+			 max_tx->bt_prio_kill_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "few_bytes_cnt:",
 			 le32_to_cpu(tx->few_bytes_cnt),
-			 accum_tx->few_bytes_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "cts_timeout:\t\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(tx->cts_timeout), accum_tx->cts_timeout);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "ack_timeout:\t\t\t%u\t\t\t%u\n",
+			 accum_tx->few_bytes_cnt,
+			 delta_tx->few_bytes_cnt, max_tx->few_bytes_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "cts_timeout:",
+			 le32_to_cpu(tx->cts_timeout), accum_tx->cts_timeout,
+			 delta_tx->cts_timeout, max_tx->cts_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "ack_timeout:",
 			 le32_to_cpu(tx->ack_timeout),
-			 accum_tx->ack_timeout);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "expected_ack_cnt:\t\t%u\t\t\t%u\n",
+			 accum_tx->ack_timeout,
+			 delta_tx->ack_timeout, max_tx->ack_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "expected_ack_cnt:",
 			 le32_to_cpu(tx->expected_ack_cnt),
-			 accum_tx->expected_ack_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "actual_ack_cnt:\t\t\t%u\t\t\t%u\n",
+			 accum_tx->expected_ack_cnt,
+			 delta_tx->expected_ack_cnt,
+			 max_tx->expected_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "actual_ack_cnt:",
 			 le32_to_cpu(tx->actual_ack_cnt),
-			 accum_tx->actual_ack_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "dump_msdu_cnt:\t\t\t%u\t\t\t%u\n",
+			 accum_tx->actual_ack_cnt,
+			 delta_tx->actual_ack_cnt,
+			 max_tx->actual_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "dump_msdu_cnt:",
 			 le32_to_cpu(tx->dump_msdu_cnt),
-			 accum_tx->dump_msdu_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "abort_nxt_frame_mismatch:"
-			 "\t%u\t\t\t%u\n",
+			 accum_tx->dump_msdu_cnt,
+			 delta_tx->dump_msdu_cnt,
+			 max_tx->dump_msdu_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "abort_nxt_frame_mismatch:",
 			 le32_to_cpu(tx->burst_abort_next_frame_mismatch_cnt),
-			 accum_tx->burst_abort_next_frame_mismatch_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "abort_missing_nxt_frame:"
-			 "\t%u\t\t\t%u\n",
+			 accum_tx->burst_abort_next_frame_mismatch_cnt,
+			 delta_tx->burst_abort_next_frame_mismatch_cnt,
+			 max_tx->burst_abort_next_frame_mismatch_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "abort_missing_nxt_frame:",
 			 le32_to_cpu(tx->burst_abort_missing_next_frame_cnt),
-			 accum_tx->burst_abort_missing_next_frame_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "cts_timeout_collision:\t\t%u\t\t\t%u\n",
+			 accum_tx->burst_abort_missing_next_frame_cnt,
+			 delta_tx->burst_abort_missing_next_frame_cnt,
+			 max_tx->burst_abort_missing_next_frame_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "cts_timeout_collision:",
 			 le32_to_cpu(tx->cts_timeout_collision),
-			 accum_tx->cts_timeout_collision);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"ack_ba_timeout_collision:\t%u\t\t\t%u\n",
+			 accum_tx->cts_timeout_collision,
+			 delta_tx->cts_timeout_collision,
+			 max_tx->cts_timeout_collision);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			"ack_ba_timeout_collision:",
 			 le32_to_cpu(tx->ack_or_ba_timeout_collision),
-			 accum_tx->ack_or_ba_timeout_collision);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "agg ba_timeout:\t\t\t%u\t\t\t%u\n",
+			 accum_tx->ack_or_ba_timeout_collision,
+			 delta_tx->ack_or_ba_timeout_collision,
+			 max_tx->ack_or_ba_timeout_collision);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "agg ba_timeout:",
 			 le32_to_cpu(tx->agg.ba_timeout),
-			 accum_tx->agg.ba_timeout);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"agg ba_resched_frames:\t\t%u\t\t\t%u\n",
+			 accum_tx->agg.ba_timeout,
+			 delta_tx->agg.ba_timeout,
+			 max_tx->agg.ba_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			"agg ba_resched_frames:",
 			 le32_to_cpu(tx->agg.ba_reschedule_frames),
-			 accum_tx->agg.ba_reschedule_frames);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"agg scd_query_agg_frame:\t%u\t\t\t%u\n",
+			 accum_tx->agg.ba_reschedule_frames,
+			 delta_tx->agg.ba_reschedule_frames,
+			 max_tx->agg.ba_reschedule_frames);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			"agg scd_query_agg_frame:",
 			 le32_to_cpu(tx->agg.scd_query_agg_frame_cnt),
-			 accum_tx->agg.scd_query_agg_frame_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "agg scd_query_no_agg:\t\t%u\t\t\t%u\n",
+			 accum_tx->agg.scd_query_agg_frame_cnt,
+			 delta_tx->agg.scd_query_agg_frame_cnt,
+			 max_tx->agg.scd_query_agg_frame_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "agg scd_query_no_agg:",
 			 le32_to_cpu(tx->agg.scd_query_no_agg),
-			 accum_tx->agg.scd_query_no_agg);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "agg scd_query_agg:\t\t%u\t\t\t%u\n",
+			 accum_tx->agg.scd_query_no_agg,
+			 delta_tx->agg.scd_query_no_agg,
+			 max_tx->agg.scd_query_no_agg);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "agg scd_query_agg:",
 			 le32_to_cpu(tx->agg.scd_query_agg),
-			 accum_tx->agg.scd_query_agg);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"agg scd_query_mismatch:\t\t%u\t\t\t%u\n",
+			 accum_tx->agg.scd_query_agg,
+			 delta_tx->agg.scd_query_agg,
+			 max_tx->agg.scd_query_agg);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			"agg scd_query_mismatch:",
 			 le32_to_cpu(tx->agg.scd_query_mismatch),
-			 accum_tx->agg.scd_query_mismatch);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "agg frame_not_ready:\t\t%u\t\t\t%u\n",
+			 accum_tx->agg.scd_query_mismatch,
+			 delta_tx->agg.scd_query_mismatch,
+			 max_tx->agg.scd_query_mismatch);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "agg frame_not_ready:",
 			 le32_to_cpu(tx->agg.frame_not_ready),
-			 accum_tx->agg.frame_not_ready);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "agg underrun:\t\t\t%u\t\t\t%u\n",
+			 accum_tx->agg.frame_not_ready,
+			 delta_tx->agg.frame_not_ready,
+			 max_tx->agg.frame_not_ready);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "agg underrun:",
 			 le32_to_cpu(tx->agg.underrun),
-			 accum_tx->agg.underrun);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "agg bt_prio_kill:\t\t%u\t\t\t%u\n",
+			 accum_tx->agg.underrun,
+			 delta_tx->agg.underrun, max_tx->agg.underrun);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "agg bt_prio_kill:",
 			 le32_to_cpu(tx->agg.bt_prio_kill),
-			 accum_tx->agg.bt_prio_kill);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "agg rx_ba_rsp_cnt:\t\t%u\t\t\t%u\n",
+			 accum_tx->agg.bt_prio_kill,
+			 delta_tx->agg.bt_prio_kill,
+			 max_tx->agg.bt_prio_kill);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "agg rx_ba_rsp_cnt:",
 			 le32_to_cpu(tx->agg.rx_ba_rsp_cnt),
-			 accum_tx->agg.rx_ba_rsp_cnt);
+			 accum_tx->agg.rx_ba_rsp_cnt,
+			 delta_tx->agg.rx_ba_rsp_cnt,
+			 max_tx->agg.rx_ba_rsp_cnt);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
@@ -1545,11 +1728,12 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 	struct iwl_priv *priv = file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = sizeof(struct statistics_general) * 4 + 250;
+	int bufsz = sizeof(struct statistics_general) * 8 + 250;
 	ssize_t ret;
 	struct statistics_general *general, *accum_general;
-	struct statistics_dbg *dbg, *accum_dbg;
-	struct statistics_div *div, *accum_div;
+	struct statistics_general *delta_general, *max_general;
+	struct statistics_dbg *dbg, *accum_dbg, *delta_dbg, *max_dbg;
+	struct statistics_div *div, *accum_div, *delta_div, *max_div;
 
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
@@ -1578,52 +1762,72 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 	dbg = &priv->statistics.general.dbg;
 	div = &priv->statistics.general.div;
 	accum_general = &priv->accum_statistics.general;
+	delta_general = &priv->delta_statistics.general;
+	max_general = &priv->max_delta.general;
 	accum_dbg = &priv->accum_statistics.general.dbg;
+	delta_dbg = &priv->delta_statistics.general.dbg;
+	max_dbg = &priv->max_delta.general.dbg;
 	accum_div = &priv->accum_statistics.general.div;
+	delta_div = &priv->delta_statistics.general.div;
+	max_div = &priv->max_delta.general.div;
 	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
-	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_General:\n");
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"\t\t\tcurrent\t\t\taccumulative\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "temperature:\t\t\t%u\n",
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_header,
+			"Statistics_General:");
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_short_format,
+			 "temperature:",
 			 le32_to_cpu(general->temperature));
-	pos += scnprintf(buf + pos, bufsz - pos, "temperature_m:\t\t\t%u\n",
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_short_format,
+			 "temperature_m:",
 			 le32_to_cpu(general->temperature_m));
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "burst_check:\t\t\t%u\t\t\t%u\n",
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "burst_check:",
 			 le32_to_cpu(dbg->burst_check),
-			 accum_dbg->burst_check);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "burst_count:\t\t\t%u\t\t\t%u\n",
+			 accum_dbg->burst_check,
+			 delta_dbg->burst_check, max_dbg->burst_check);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "burst_count:",
 			 le32_to_cpu(dbg->burst_count),
-			 accum_dbg->burst_count);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "sleep_time:\t\t\t%u\t\t\t%u\n",
+			 accum_dbg->burst_count,
+			 delta_dbg->burst_count, max_dbg->burst_count);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "sleep_time:",
 			 le32_to_cpu(general->sleep_time),
-			 accum_general->sleep_time);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "slots_out:\t\t\t%u\t\t\t%u\n",
+			 accum_general->sleep_time,
+			 delta_general->sleep_time, max_general->sleep_time);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "slots_out:",
 			 le32_to_cpu(general->slots_out),
-			 accum_general->slots_out);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "slots_idle:\t\t\t%u\t\t\t%u\n",
+			 accum_general->slots_out,
+			 delta_general->slots_out, max_general->slots_out);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "slots_idle:",
 			 le32_to_cpu(general->slots_idle),
-			 accum_general->slots_idle);
+			 accum_general->slots_idle,
+			 delta_general->slots_idle, max_general->slots_idle);
 	pos += scnprintf(buf + pos, bufsz - pos, "ttl_timestamp:\t\t\t%u\n",
 			 le32_to_cpu(general->ttl_timestamp));
-	pos += scnprintf(buf + pos, bufsz - pos, "tx_on_a:\t\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(div->tx_on_a), accum_div->tx_on_a);
-	pos += scnprintf(buf + pos, bufsz - pos, "tx_on_b:\t\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(div->tx_on_b), accum_div->tx_on_b);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "exec_time:\t\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(div->exec_time), accum_div->exec_time);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "probe_time:\t\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(div->probe_time), accum_div->probe_time);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "rx_enable_counter:\t\t%u\t\t\t%u\n",
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "tx_on_a:",
+			 le32_to_cpu(div->tx_on_a), accum_div->tx_on_a,
+			 delta_div->tx_on_a, max_div->tx_on_a);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "tx_on_b:",
+			 le32_to_cpu(div->tx_on_b), accum_div->tx_on_b,
+			 delta_div->tx_on_b, max_div->tx_on_b);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "exec_time:",
+			 le32_to_cpu(div->exec_time), accum_div->exec_time,
+			 delta_div->exec_time, max_div->exec_time);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "probe_time:",
+			 le32_to_cpu(div->probe_time), accum_div->probe_time,
+			 delta_div->probe_time, max_div->probe_time);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "rx_enable_counter:",
 			 le32_to_cpu(general->rx_enable_counter),
-			 accum_general->rx_enable_counter);
+			 accum_general->rx_enable_counter,
+			 delta_general->rx_enable_counter,
+			 max_general->rx_enable_counter);
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 42f9b17..811bacf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1162,6 +1162,8 @@ struct iwl_priv {
 	struct iwl_notif_statistics statistics;
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_notif_statistics accum_statistics;
+	struct iwl_notif_statistics delta_statistics;
+	struct iwl_notif_statistics max_delta;
 #endif
 
 	/* context information */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 10db973..5bbe5f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -564,15 +564,24 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 	int i;
 	__le32 *prev_stats;
 	u32 *accum_stats;
+	u32 *delta, *max_delta;
 
 	prev_stats = (__le32 *)&priv->statistics;
 	accum_stats = (u32 *)&priv->accum_statistics;
+	delta = (u32 *)&priv->delta_statistics;
+	max_delta = (u32 *)&priv->max_delta;
 
 	for (i = sizeof(__le32); i < sizeof(struct iwl_notif_statistics);
-	     i += sizeof(__le32), stats++, prev_stats++, accum_stats++)
-		if (le32_to_cpu(*stats) > le32_to_cpu(*prev_stats))
-			*accum_stats += (le32_to_cpu(*stats) -
+	     i += sizeof(__le32), stats++, prev_stats++, delta++,
+	     max_delta++, accum_stats++) {
+		if (le32_to_cpu(*stats) > le32_to_cpu(*prev_stats)) {
+			*delta = (le32_to_cpu(*stats) -
 				le32_to_cpu(*prev_stats));
+			*accum_stats += *delta;
+			if (*delta > *max_delta)
+				*max_delta = *delta;
+		}
+	}
 
 	/* reset accumulative statistics for "no-counter" type statistics */
 	priv->accum_statistics.general.temperature =
@@ -641,6 +650,10 @@ void iwl_reply_statistics(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 		memset(&priv->accum_statistics, 0,
 			sizeof(struct iwl_notif_statistics));
+		memset(&priv->delta_statistics, 0,
+			sizeof(struct iwl_notif_statistics));
+		memset(&priv->max_delta, 0,
+			sizeof(struct iwl_notif_statistics));
 #endif
 		IWL_DEBUG_RX(priv, "Statistics have been cleared\n");
 	}
-- 
1.6.3.3

