Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54204 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaCYKt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 06:49:58 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so269056pdj.36
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 03:49:58 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath10k: add extra pdev stats on 10.1 firmware
Date: Tue, 25 Mar 2014 18:49:33 +0800
Message-Id: <1395744573-13691-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140325_115425_214616_FA5C0179)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As pointed out by Michal Kazior, add extra pdev stats
for 10.1 firmware.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    6 ++++++
 drivers/net/wireless/ath/ath10k/debug.c |   27 ++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h   |   19 ++++++++++++++++++-
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8c5e84c..50fa048 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -131,6 +131,12 @@ struct ath10k_target_stats {
 	u32 cycle_count;
 	u32 phy_err_count;
 	u32 chan_tx_power;
+	u32 ack_rx_bad;
+	u32 rts_bad;
+	u32 rts_good;
+	u32 fcs_bad;
+	u32 no_beacons;
+	u32 mib_int_count;
 
 	/* PDEV TX stats */
 	s32 comp_queued;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 4a4072e..64335dd 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -161,7 +161,7 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 	u8 *tmp = ev->data;
 	struct ath10k_target_stats *stats;
 	int num_pdev_stats, num_vdev_stats, num_peer_stats;
-	struct wmi_pdev_stats *ps;
+	struct wmi_pdev_stats_10x *ps;
 	int i;
 
 	spin_lock_bh(&ar->data_lock);
@@ -173,7 +173,7 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats); /* 0 or max peers */
 
 	if (num_pdev_stats) {
-		ps = (struct wmi_pdev_stats *)tmp;
+		ps = (struct wmi_pdev_stats_10x *)tmp;
 
 		stats->ch_noise_floor = __le32_to_cpu(ps->chan_nf);
 		stats->tx_frame_count = __le32_to_cpu(ps->tx_frame_count);
@@ -228,7 +228,18 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 		stats->phy_err_drop = __le32_to_cpu(ps->wal.rx.phy_err_drop);
 		stats->mpdu_errs = __le32_to_cpu(ps->wal.rx.mpdu_errs);
 
-		tmp += sizeof(struct wmi_pdev_stats);
+		if (test_bit(ATH10K_FW_FEATURE_WMI_10X,
+			     ar->fw_features)) {
+			stats->ack_rx_bad = __le32_to_cpu(ps->ack_rx_bad);
+			stats->rts_bad = __le32_to_cpu(ps->rts_bad);
+			stats->rts_good = __le32_to_cpu(ps->rts_good);
+			stats->fcs_bad = __le32_to_cpu(ps->fcs_bad);
+			stats->no_beacons = __le32_to_cpu(ps->no_beacons);
+			stats->mib_int_count = __le32_to_cpu(ps->mib_int_count);
+			tmp += sizeof(struct wmi_pdev_stats_10x);
+		} else {
+			tmp += sizeof(struct wmi_pdev_stats_old);
+		}
 	}
 
 	/* 0 or max vdevs */
@@ -334,6 +345,16 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 			 "Cycle count", fw_stats->cycle_count);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
 			 "PHY error count", fw_stats->phy_err_count);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			 "RTS bad count", fw_stats->rts_bad);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			 "RTS good count", fw_stats->rts_good);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			 "FCS bad count", fw_stats->fcs_bad);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			 "No beacon count", fw_stats->no_beacons);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
+			 "MIB int count", fw_stats->mib_int_count);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	len += scnprintf(buf + len, buf_len - len, "%30s\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ff69a1b..f6dc92e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2833,7 +2833,7 @@ struct wmi_stats_event {
  * PDEV statistics
  * TODO: add all PDEV stats here
  */
-struct wmi_pdev_stats {
+struct wmi_pdev_stats_old {
 	__le32 chan_nf;        /* Channel noise floor */
 	__le32 tx_frame_count; /* TX frame count */
 	__le32 rx_frame_count; /* RX frame count */
@@ -2844,6 +2844,23 @@ struct wmi_pdev_stats {
 	struct wal_dbg_stats wal; /* WAL dbg stats */
 } __packed;
 
+struct wmi_pdev_stats_10x {
+	__le32 chan_nf;        /* Channel noise floor */
+	__le32 tx_frame_count; /* TX frame count */
+	__le32 rx_frame_count; /* RX frame count */
+	__le32 rx_clear_count; /* rx clear count */
+	__le32 cycle_count;    /* cycle count */
+	__le32 phy_err_count;  /* Phy error count */
+	__le32 chan_tx_pwr;    /* channel tx power */
+	struct wal_dbg_stats wal; /* WAL dbg stats */
+	__le32 ack_rx_bad;
+	__le32 rts_bad;
+	__le32 rts_good;
+	__le32 fcs_bad;
+	__le32 no_beacons;
+	__le32 mib_int_count;
+} __packed;
+
 /*
  * VDEV statistics
  * TODO: add all VDEV stats here
-- 
1.7.9.5

