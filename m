Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628Ab0D3XAh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 19:00:37 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/8] iwl3945: add ucode statistics
Date: Fri, 30 Apr 2010 16:00:22 -0700
Message-Id: <1272668425-3753-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
References: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Add general, rx and tx uCode statistics to 3945. This will help
in debugging

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile           |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c |  500 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h |   60 +++
 drivers/net/wireless/iwlwifi/iwl-3945.c         |   72 ++++-
 drivers/net/wireless/iwlwifi/iwl-3945.h         |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c      |   18 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h          |    5 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c     |    2 +-
 8 files changed, 646 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 5ed2dcb..7c72353 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -22,5 +22,6 @@ iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 # 3945
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o iwl-3945-led.o
+iwl3945-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-3945-debugfs.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c
new file mode 100644
index 0000000..6a9c64a
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c
@@ -0,0 +1,500 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+
+#include "iwl-3945-debugfs.h"
+
+ssize_t iwl3945_ucode_rx_stats_read(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	int pos = 0;
+	char *buf;
+	int bufsz = sizeof(struct iwl39_statistics_rx_phy) * 40 +
+		    sizeof(struct iwl39_statistics_rx_non_phy) * 40 + 400;
+	ssize_t ret;
+	struct iwl39_statistics_rx_phy *ofdm, *accum_ofdm, *delta_ofdm, *max_ofdm;
+	struct iwl39_statistics_rx_phy *cck, *accum_cck, *delta_cck, *max_cck;
+	struct iwl39_statistics_rx_non_phy *general, *accum_general;
+	struct iwl39_statistics_rx_non_phy *delta_general, *max_general;
+
+	if (!iwl_is_alive(priv))
+		return -EAGAIN;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * The statistic information display here is based on
+	 * the last statistics notification from uCode
+	 * might not reflect the current uCode activity
+	 */
+	ofdm = &priv->_3945.statistics.rx.ofdm;
+	cck = &priv->_3945.statistics.rx.cck;
+	general = &priv->_3945.statistics.rx.general;
+	accum_ofdm = &priv->_3945.accum_statistics.rx.ofdm;
+	accum_cck = &priv->_3945.accum_statistics.rx.cck;
+	accum_general = &priv->_3945.accum_statistics.rx.general;
+	delta_ofdm = &priv->_3945.delta_statistics.rx.ofdm;
+	delta_cck = &priv->_3945.delta_statistics.rx.cck;
+	delta_general = &priv->_3945.delta_statistics.rx.general;
+	max_ofdm = &priv->_3945.max_delta.rx.ofdm;
+	max_cck = &priv->_3945.max_delta.rx.cck;
+	max_general = &priv->_3945.max_delta.rx.general;
+
+	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
+			 "acumulative       delta         max\n",
+			 "Statistics_Rx - OFDM:");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "ina_cnt:", le32_to_cpu(ofdm->ina_cnt),
+			 accum_ofdm->ina_cnt,
+			 delta_ofdm->ina_cnt, max_ofdm->ina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "fina_cnt:",
+			 le32_to_cpu(ofdm->fina_cnt), accum_ofdm->fina_cnt,
+			 delta_ofdm->fina_cnt, max_ofdm->fina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n", "plcp_err:",
+			 le32_to_cpu(ofdm->plcp_err), accum_ofdm->plcp_err,
+			 delta_ofdm->plcp_err, max_ofdm->plcp_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",  "crc32_err:",
+			 le32_to_cpu(ofdm->crc32_err), accum_ofdm->crc32_err,
+			 delta_ofdm->crc32_err, max_ofdm->crc32_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n", "overrun_err:",
+			 le32_to_cpu(ofdm->overrun_err),
+			 accum_ofdm->overrun_err, delta_ofdm->overrun_err,
+			 max_ofdm->overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "early_overrun_err:",
+			 le32_to_cpu(ofdm->early_overrun_err),
+			 accum_ofdm->early_overrun_err,
+			 delta_ofdm->early_overrun_err,
+			 max_ofdm->early_overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "crc32_good:", le32_to_cpu(ofdm->crc32_good),
+			 accum_ofdm->crc32_good, delta_ofdm->crc32_good,
+			 max_ofdm->crc32_good);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n", "false_alarm_cnt:",
+			 le32_to_cpu(ofdm->false_alarm_cnt),
+			 accum_ofdm->false_alarm_cnt,
+			 delta_ofdm->false_alarm_cnt,
+			 max_ofdm->false_alarm_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "fina_sync_err_cnt:",
+			 le32_to_cpu(ofdm->fina_sync_err_cnt),
+			 accum_ofdm->fina_sync_err_cnt,
+			 delta_ofdm->fina_sync_err_cnt,
+			 max_ofdm->fina_sync_err_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "sfd_timeout:",
+			 le32_to_cpu(ofdm->sfd_timeout),
+			 accum_ofdm->sfd_timeout,
+			 delta_ofdm->sfd_timeout,
+			 max_ofdm->sfd_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "fina_timeout:",
+			 le32_to_cpu(ofdm->fina_timeout),
+			 accum_ofdm->fina_timeout,
+			 delta_ofdm->fina_timeout,
+			 max_ofdm->fina_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "unresponded_rts:",
+			 le32_to_cpu(ofdm->unresponded_rts),
+			 accum_ofdm->unresponded_rts,
+			 delta_ofdm->unresponded_rts,
+			 max_ofdm->unresponded_rts);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "rxe_frame_lmt_ovrun:",
+			 le32_to_cpu(ofdm->rxe_frame_limit_overrun),
+			 accum_ofdm->rxe_frame_limit_overrun,
+			 delta_ofdm->rxe_frame_limit_overrun,
+			 max_ofdm->rxe_frame_limit_overrun);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "sent_ack_cnt:",
+			 le32_to_cpu(ofdm->sent_ack_cnt),
+			 accum_ofdm->sent_ack_cnt,
+			 delta_ofdm->sent_ack_cnt,
+			 max_ofdm->sent_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "sent_cts_cnt:",
+			 le32_to_cpu(ofdm->sent_cts_cnt),
+			 accum_ofdm->sent_cts_cnt,
+			 delta_ofdm->sent_cts_cnt, max_ofdm->sent_cts_cnt);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
+			 "acumulative       delta         max\n",
+			 "Statistics_Rx - CCK:");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "ina_cnt:",
+			 le32_to_cpu(cck->ina_cnt), accum_cck->ina_cnt,
+			 delta_cck->ina_cnt, max_cck->ina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "fina_cnt:",
+			 le32_to_cpu(cck->fina_cnt), accum_cck->fina_cnt,
+			 delta_cck->fina_cnt, max_cck->fina_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "plcp_err:",
+			 le32_to_cpu(cck->plcp_err), accum_cck->plcp_err,
+			 delta_cck->plcp_err, max_cck->plcp_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "crc32_err:",
+			 le32_to_cpu(cck->crc32_err), accum_cck->crc32_err,
+			 delta_cck->crc32_err, max_cck->crc32_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "overrun_err:",
+			 le32_to_cpu(cck->overrun_err),
+			 accum_cck->overrun_err,
+			 delta_cck->overrun_err, max_cck->overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "early_overrun_err:",
+			 le32_to_cpu(cck->early_overrun_err),
+			 accum_cck->early_overrun_err,
+			 delta_cck->early_overrun_err,
+			 max_cck->early_overrun_err);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "crc32_good:",
+			 le32_to_cpu(cck->crc32_good), accum_cck->crc32_good,
+			 delta_cck->crc32_good,
+			 max_cck->crc32_good);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "false_alarm_cnt:",
+			 le32_to_cpu(cck->false_alarm_cnt),
+			 accum_cck->false_alarm_cnt,
+			 delta_cck->false_alarm_cnt, max_cck->false_alarm_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "fina_sync_err_cnt:",
+			 le32_to_cpu(cck->fina_sync_err_cnt),
+			 accum_cck->fina_sync_err_cnt,
+			 delta_cck->fina_sync_err_cnt,
+			 max_cck->fina_sync_err_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "sfd_timeout:",
+			 le32_to_cpu(cck->sfd_timeout),
+			 accum_cck->sfd_timeout,
+			 delta_cck->sfd_timeout, max_cck->sfd_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "fina_timeout:",
+			 le32_to_cpu(cck->fina_timeout),
+			 accum_cck->fina_timeout,
+			 delta_cck->fina_timeout, max_cck->fina_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "unresponded_rts:",
+			 le32_to_cpu(cck->unresponded_rts),
+			 accum_cck->unresponded_rts,
+			 delta_cck->unresponded_rts,
+			 max_cck->unresponded_rts);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "rxe_frame_lmt_ovrun:",
+			 le32_to_cpu(cck->rxe_frame_limit_overrun),
+			 accum_cck->rxe_frame_limit_overrun,
+			 delta_cck->rxe_frame_limit_overrun,
+			 max_cck->rxe_frame_limit_overrun);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "sent_ack_cnt:",
+			 le32_to_cpu(cck->sent_ack_cnt),
+			 accum_cck->sent_ack_cnt,
+			 delta_cck->sent_ack_cnt,
+			 max_cck->sent_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "sent_cts_cnt:",
+			 le32_to_cpu(cck->sent_cts_cnt),
+			 accum_cck->sent_cts_cnt,
+			 delta_cck->sent_cts_cnt,
+			 max_cck->sent_cts_cnt);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
+			 "acumulative       delta         max\n",
+			 "Statistics_Rx - GENERAL:");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "bogus_cts:",
+			 le32_to_cpu(general->bogus_cts),
+			 accum_general->bogus_cts,
+			 delta_general->bogus_cts, max_general->bogus_cts);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "bogus_ack:",
+			 le32_to_cpu(general->bogus_ack),
+			 accum_general->bogus_ack,
+			 delta_general->bogus_ack, max_general->bogus_ack);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "non_bssid_frames:",
+			 le32_to_cpu(general->non_bssid_frames),
+			 accum_general->non_bssid_frames,
+			 delta_general->non_bssid_frames,
+			 max_general->non_bssid_frames);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "filtered_frames:",
+			 le32_to_cpu(general->filtered_frames),
+			 accum_general->filtered_frames,
+			 delta_general->filtered_frames,
+			 max_general->filtered_frames);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "non_channel_beacons:",
+			 le32_to_cpu(general->non_channel_beacons),
+			 accum_general->non_channel_beacons,
+			 delta_general->non_channel_beacons,
+			 max_general->non_channel_beacons);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+ssize_t iwl3945_ucode_tx_stats_read(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	int pos = 0;
+	char *buf;
+	int bufsz = (sizeof(struct iwl39_statistics_tx) * 48) + 250;
+	ssize_t ret;
+	struct iwl39_statistics_tx *tx, *accum_tx, *delta_tx, *max_tx;
+
+	if (!iwl_is_alive(priv))
+		return -EAGAIN;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * The statistic information display here is based on
+	 * the last statistics notification from uCode
+	 * might not reflect the current uCode activity
+	 */
+	tx = &priv->_3945.statistics.tx;
+	accum_tx = &priv->_3945.accum_statistics.tx;
+	delta_tx = &priv->_3945.delta_statistics.tx;
+	max_tx = &priv->_3945.max_delta.tx;
+	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
+			 "acumulative       delta         max\n",
+			 "Statistics_Tx:");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "preamble:",
+			 le32_to_cpu(tx->preamble_cnt),
+			 accum_tx->preamble_cnt,
+			 delta_tx->preamble_cnt, max_tx->preamble_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "rx_detected_cnt:",
+			 le32_to_cpu(tx->rx_detected_cnt),
+			 accum_tx->rx_detected_cnt,
+			 delta_tx->rx_detected_cnt, max_tx->rx_detected_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "bt_prio_defer_cnt:",
+			 le32_to_cpu(tx->bt_prio_defer_cnt),
+			 accum_tx->bt_prio_defer_cnt,
+			 delta_tx->bt_prio_defer_cnt,
+			 max_tx->bt_prio_defer_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "bt_prio_kill_cnt:",
+			 le32_to_cpu(tx->bt_prio_kill_cnt),
+			 accum_tx->bt_prio_kill_cnt,
+			 delta_tx->bt_prio_kill_cnt,
+			 max_tx->bt_prio_kill_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "few_bytes_cnt:",
+			 le32_to_cpu(tx->few_bytes_cnt),
+			 accum_tx->few_bytes_cnt,
+			 delta_tx->few_bytes_cnt, max_tx->few_bytes_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "cts_timeout:",
+			 le32_to_cpu(tx->cts_timeout), accum_tx->cts_timeout,
+			 delta_tx->cts_timeout, max_tx->cts_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "ack_timeout:",
+			 le32_to_cpu(tx->ack_timeout),
+			 accum_tx->ack_timeout,
+			 delta_tx->ack_timeout, max_tx->ack_timeout);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "expected_ack_cnt:",
+			 le32_to_cpu(tx->expected_ack_cnt),
+			 accum_tx->expected_ack_cnt,
+			 delta_tx->expected_ack_cnt,
+			 max_tx->expected_ack_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "actual_ack_cnt:",
+			 le32_to_cpu(tx->actual_ack_cnt),
+			 accum_tx->actual_ack_cnt,
+			 delta_tx->actual_ack_cnt,
+			 max_tx->actual_ack_cnt);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+ssize_t iwl3945_ucode_general_stats_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	int pos = 0;
+	char *buf;
+	int bufsz = sizeof(struct iwl39_statistics_general) * 10 + 300;
+	ssize_t ret;
+	struct iwl39_statistics_general *general, *accum_general;
+	struct iwl39_statistics_general *delta_general, *max_general;
+	struct statistics_dbg *dbg, *accum_dbg, *delta_dbg, *max_dbg;
+	struct iwl39_statistics_div *div, *accum_div, *delta_div, *max_div;
+
+	if (!iwl_is_alive(priv))
+		return -EAGAIN;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * The statistic information display here is based on
+	 * the last statistics notification from uCode
+	 * might not reflect the current uCode activity
+	 */
+	general = &priv->_3945.statistics.general;
+	dbg = &priv->_3945.statistics.general.dbg;
+	div = &priv->_3945.statistics.general.div;
+	accum_general = &priv->_3945.accum_statistics.general;
+	delta_general = &priv->_3945.delta_statistics.general;
+	max_general = &priv->_3945.max_delta.general;
+	accum_dbg = &priv->_3945.accum_statistics.general.dbg;
+	delta_dbg = &priv->_3945.delta_statistics.general.dbg;
+	max_dbg = &priv->_3945.max_delta.general.dbg;
+	accum_div = &priv->_3945.accum_statistics.general.div;
+	delta_div = &priv->_3945.delta_statistics.general.div;
+	max_div = &priv->_3945.max_delta.general.div;
+	pos += iwl_dbgfs_statistics_flag(priv, buf, bufsz);
+	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
+			 "acumulative       delta         max\n",
+			 "Statistics_General:");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "burst_check:",
+			 le32_to_cpu(dbg->burst_check),
+			 accum_dbg->burst_check,
+			 delta_dbg->burst_check, max_dbg->burst_check);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "burst_count:",
+			 le32_to_cpu(dbg->burst_count),
+			 accum_dbg->burst_count,
+			 delta_dbg->burst_count, max_dbg->burst_count);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "sleep_time:",
+			 le32_to_cpu(general->sleep_time),
+			 accum_general->sleep_time,
+			 delta_general->sleep_time, max_general->sleep_time);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "slots_out:",
+			 le32_to_cpu(general->slots_out),
+			 accum_general->slots_out,
+			 delta_general->slots_out, max_general->slots_out);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "slots_idle:",
+			 le32_to_cpu(general->slots_idle),
+			 accum_general->slots_idle,
+			 delta_general->slots_idle, max_general->slots_idle);
+	pos += scnprintf(buf + pos, bufsz - pos, "ttl_timestamp:\t\t\t%u\n",
+			 le32_to_cpu(general->ttl_timestamp));
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "tx_on_a:",
+			 le32_to_cpu(div->tx_on_a), accum_div->tx_on_a,
+			 delta_div->tx_on_a, max_div->tx_on_a);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "tx_on_b:",
+			 le32_to_cpu(div->tx_on_b), accum_div->tx_on_b,
+			 delta_div->tx_on_b, max_div->tx_on_b);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "exec_time:",
+			 le32_to_cpu(div->exec_time), accum_div->exec_time,
+			 delta_div->exec_time, max_div->exec_time);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "probe_time:",
+			 le32_to_cpu(div->probe_time), accum_div->probe_time,
+			 delta_div->probe_time, max_div->probe_time);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h b/drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h
new file mode 100644
index 0000000..70809c5
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h
@@ -0,0 +1,60 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-debug.h"
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+ssize_t iwl3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos);
+ssize_t iwl3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos);
+ssize_t iwl3945_ucode_general_stats_read(struct file *file,
+					 char __user *user_buf, size_t count,
+					 loff_t *ppos);
+#else
+static ssize_t iwl3945_ucode_rx_stats_read(struct file *file,
+					   char __user *user_buf, size_t count,
+					   loff_t *ppos)
+{
+	return 0;
+}
+static ssize_t iwl3945_ucode_tx_stats_read(struct file *file,
+					   char __user *user_buf, size_t count,
+					   loff_t *ppos)
+{
+	return 0;
+}
+static ssize_t iwl3945_ucode_general_stats_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	return 0;
+}
+#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d10e59d..9dad867 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -49,6 +49,7 @@
 #include "iwl-helpers.h"
 #include "iwl-led.h"
 #include "iwl-3945-led.h"
+#include "iwl-3945-debugfs.h"
 
 #define IWL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,   \
@@ -292,7 +293,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
  * iwl3945_rx_reply_tx - Handle Tx response
  */
 static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
-			    struct iwl_rx_mem_buffer *rxb)
+				struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -350,18 +351,81 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
  *  RX handler implementations
  *
  *****************************************************************************/
+#ifdef CONFIG_IWLWIFI_DEBUG
+/*
+ *  based on the assumption of all statistics counter are in DWORD
+ *  FIXME: This function is for debugging, do not deal with
+ *  the case of counters roll-over.
+ */
+static void iwl3945_accumulative_statistics(struct iwl_priv *priv,
+					    __le32 *stats)
+{
+	int i;
+	__le32 *prev_stats;
+	u32 *accum_stats;
+	u32 *delta, *max_delta;
+
+	prev_stats = (__le32 *)&priv->_3945.statistics;
+	accum_stats = (u32 *)&priv->_3945.accum_statistics;
+	delta = (u32 *)&priv->_3945.delta_statistics;
+	max_delta = (u32 *)&priv->_3945.max_delta;
+
+	for (i = sizeof(__le32); i < sizeof(struct iwl3945_notif_statistics);
+	     i += sizeof(__le32), stats++, prev_stats++, delta++,
+	     max_delta++, accum_stats++) {
+		if (le32_to_cpu(*stats) > le32_to_cpu(*prev_stats)) {
+			*delta = (le32_to_cpu(*stats) -
+				le32_to_cpu(*prev_stats));
+			*accum_stats += *delta;
+			if (*delta > *max_delta)
+				*max_delta = *delta;
+		}
+	}
+
+	/* reset accumulative statistics for "no-counter" type statistics */
+	priv->_3945.accum_statistics.general.temperature =
+		priv->_3945.statistics.general.temperature;
+	priv->_3945.accum_statistics.general.ttl_timestamp =
+		priv->_3945.statistics.general.ttl_timestamp;
+}
+#endif
 
 void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 		struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct iwl3945_notif_statistics),
 		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
+#ifdef CONFIG_IWLWIFI_DEBUG
+	iwl3945_accumulative_statistics(priv, (__le32 *)&pkt->u.raw);
+#endif
 
 	memcpy(&priv->_3945.statistics, pkt->u.raw, sizeof(priv->_3945.statistics));
 }
 
+void iwl3945_reply_statistics(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	__le32 *flag = (__le32 *)&pkt->u.raw;
+
+	if (le32_to_cpu(*flag) & UCODE_STATISTICS_CLEAR_MSK) {
+#ifdef CONFIG_IWLWIFI_DEBUG
+		memset(&priv->_3945.accum_statistics, 0,
+			sizeof(struct iwl3945_notif_statistics));
+		memset(&priv->_3945.delta_statistics, 0,
+			sizeof(struct iwl3945_notif_statistics));
+		memset(&priv->_3945.max_delta, 0,
+			sizeof(struct iwl3945_notif_statistics));
+#endif
+		IWL_DEBUG_RX(priv, "Statistics have been cleared\n");
+	}
+	iwl3945_hw_rx_statistics(priv, rxb);
+}
+
+
 /******************************************************************************
  *
  * Misc. internal state and helper functions
@@ -2735,6 +2799,12 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.isr = iwl_isr_legacy,
 	.config_ap = iwl3945_config_ap,
 	.add_bcast_station = iwl3945_add_bcast_station,
+
+	.debugfs_ops = {
+		.rx_stats_read = iwl3945_ucode_rx_stats_read,
+		.tx_stats_read = iwl3945_ucode_tx_stats_read,
+		.general_stats_read = iwl3945_ucode_general_stats_read,
+	},
 };
 
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index e9674f0..643adb6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -264,6 +264,8 @@ extern int iwl3945_hw_reg_send_txpower(struct iwl_priv *priv);
 extern int iwl3945_hw_reg_set_txpower(struct iwl_priv *priv, s8 power);
 extern void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb);
+void iwl3945_reply_statistics(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb);
 extern void iwl3945_disable_events(struct iwl_priv *priv);
 extern int iwl4965_get_temperature(const struct iwl_priv *priv);
 extern void iwl3945_post_associate(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d789f8d..0aedbec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1053,10 +1053,8 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 					size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
-	if (priv->cfg->ops->lib->debugfs_ops.rx_stats_read)
-		return priv->cfg->ops->lib->debugfs_ops.rx_stats_read(file,
-						user_buf, count, ppos);
-	return 0;
+	return priv->cfg->ops->lib->debugfs_ops.rx_stats_read(file,
+			user_buf, count, ppos);
 }
 
 static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
@@ -1064,10 +1062,8 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 					size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
-	if (priv->cfg->ops->lib->debugfs_ops.tx_stats_read)
-		return priv->cfg->ops->lib->debugfs_ops.tx_stats_read(file,
-						user_buf, count, ppos);
-	return 0;
+	return priv->cfg->ops->lib->debugfs_ops.tx_stats_read(file,
+			user_buf, count, ppos);
 }
 
 static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
@@ -1075,10 +1071,8 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 					size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
-	if (priv->cfg->ops->lib->debugfs_ops.general_stats_read)
-		return priv->cfg->ops->lib->debugfs_ops.general_stats_read(file,
-						user_buf, count, ppos);
-	return 0;
+	return priv->cfg->ops->lib->debugfs_ops.general_stats_read(file,
+			user_buf, count, ppos);
 }
 
 static ssize_t iwl_dbgfs_sensitivity_read(struct file *file,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bdc60aa..58c69a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1202,6 +1202,11 @@ struct iwl_priv {
 			struct delayed_work rfkill_poll;
 
 			struct iwl3945_notif_statistics statistics;
+#ifdef CONFIG_IWLWIFI_DEBUG
+			struct iwl3945_notif_statistics accum_statistics;
+			struct iwl3945_notif_statistics delta_statistics;
+			struct iwl3945_notif_statistics max_delta;
+#endif
 
 			u32 sta_supp_rates;
 			int last_rx_rssi;	/* From Rx packet statistics */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 789480b..98055fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -956,7 +956,7 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 	 * statistics request from the host as well as for the periodic
 	 * statistics notifications (after received beacons) from the uCode.
 	 */
-	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl3945_hw_rx_statistics;
+	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl3945_reply_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl3945_hw_rx_statistics;
 
 	iwl_setup_rx_scan_handlers(priv);
-- 
1.6.3.3

