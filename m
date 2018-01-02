Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42174 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeABTsV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jan 2018 14:48:21 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Report and display mem use for 10.4, 10.2 firmware.
Date: Tue,  2 Jan 2018 11:48:16 -0800
Message-Id: <1514922496-7952-1-git-send-email-greearb@candelatech.com> (sfid-20180102_204824_833778_45621589)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The 10.4 'mem' reporting struct had the wrong order vs the 10.2,
so just make a new _10_4 specific struct.  Save these reported
values and make them available via debugfs.

Stock 10.4 firmware probably reports zero values
for this currently, but they will be notified of a fix
for this shortly.

I did not test 10.2 firmware, so not sure what it reports.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  5 +++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 13 +++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h  |  9 +++++++--
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1aacc9b8..bcee3ec 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -289,6 +289,11 @@ struct ath10k_fw_stats_pdev {
 	s32 mpdu_errs;
 	s32 rx_ovfl_errs;
 	s32 rx_timeout_errs;
+
+	/* Other PDEV stats */
+	s32 dram_free;
+	s32 iram_free;
+	s32 sram_free;
 };
 
 struct ath10k_fw_stats {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index cba6dad..f29ce83 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3046,6 +3046,9 @@ static int ath10k_wmi_10_2_op_pull_fw_stats(struct ath10k *ar,
 		ath10k_wmi_pull_pdev_stats_base(&src->base, dst);
 		ath10k_wmi_pull_pdev_stats_tx(&src->tx, dst);
 		ath10k_wmi_pull_pdev_stats_rx(&src->rx, dst);
+		dst->rx_timeout_errs = __le32_to_cpu(src->pdev_rx_timeout);
+		dst->dram_free = __le32_to_cpu(src->mem.dram_free);
+		dst->iram_free = __le32_to_cpu(src->mem.iram_free);
 		ath10k_wmi_pull_pdev_stats_extra(&src->extra, dst);
 		/* FIXME: expose 10.2 specific values */
 
@@ -3219,6 +3222,9 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
 		ath10k_wmi_pull_pdev_stats_rx(&src->rx, dst);
 		dst->rx_timeout_errs = __le32_to_cpu(src->pdev_rx_timeout);
 		dst->rx_ovfl_errs = __le32_to_cpu(src->rx_ovfl_errs);
+		dst->dram_free = __le32_to_cpu(src->mem.dram_free);
+		dst->iram_free = __le32_to_cpu(src->mem.iram_free);
+		dst->sram_free = __le32_to_cpu(src->mem.sram_free);
 		ath10k_wmi_pull_pdev_stats_extra(&src->extra, dst);
 
 		list_add_tail(&dst->list, &stats->pdevs);
@@ -8249,6 +8255,13 @@ void ath10k_wmi_10_4_op_fw_stats_fill(struct ath10k *ar,
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
 			"Num Rx Overflow errors", pdev->rx_ovfl_errs);
 
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "DRAM Free", pdev->dram_free);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "IRAM Free", pdev->iram_free);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			 "SRAM Free", pdev->sram_free);
+
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
 			"ath10k VDEV stats", num_vdevs);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 93ca8e8..a3ba191 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4419,6 +4419,12 @@ struct wmi_pdev_stats_mem {
 	__le32 iram_free;
 } __packed;
 
+struct wmi_pdev_stats_mem_10_4 {
+	__le32 iram_free;
+	__le32 dram_free;
+	__le32 sram_free;
+} __packed;
+
 struct wmi_10_2_pdev_stats {
 	struct wmi_pdev_stats_base base;
 	struct wmi_pdev_stats_tx tx;
@@ -4436,8 +4442,7 @@ struct wmi_10_4_pdev_stats {
 	struct wmi_pdev_stats_rx rx;
 	__le32 pdev_rx_timeout;
 	__le32 rx_ovfl_errs;
-	struct wmi_pdev_stats_mem mem;
-	__le32 sram_free_size;
+	struct wmi_pdev_stats_mem_10_4 mem;
 	struct wmi_pdev_stats_extra extra;
 } __packed;
 
-- 
2.4.11
