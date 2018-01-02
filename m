Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40176 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbeABSUf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jan 2018 13:20:35 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Report rx-timeout errors.
Date: Tue,  2 Jan 2018 10:20:29 -0800
Message-Id: <1514917229-7839-1-git-send-email-greearb@candelatech.com> (sfid-20180102_192039_548999_A302698E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The rx pdev related stats do not match the 10.4 firmware stats
struct.  The pdev-rx-timeout field needs to be added.

Stock firmware may not actually ever increment that value,
but this should at least help the other stats be aligned properly.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 1 +
 drivers/net/wireless/ath/ath10k/wmi.c  | 3 +++
 drivers/net/wireless/ath/ath10k/wmi.h  | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a6b0894..1aacc9b8 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -288,6 +288,7 @@ struct ath10k_fw_stats_pdev {
 	s32 phy_err_drop;
 	s32 mpdu_errs;
 	s32 rx_ovfl_errs;
+	s32 rx_timeout_errs;
 };
 
 struct ath10k_fw_stats {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f3e6c67..cba6dad 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3217,6 +3217,7 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
 		ath10k_wmi_pull_pdev_stats_base(&src->base, dst);
 		ath10k_wmi_10_4_pull_pdev_stats_tx(&src->tx, dst);
 		ath10k_wmi_pull_pdev_stats_rx(&src->rx, dst);
+		dst->rx_timeout_errs = __le32_to_cpu(src->pdev_rx_timeout);
 		dst->rx_ovfl_errs = __le32_to_cpu(src->rx_ovfl_errs);
 		ath10k_wmi_pull_pdev_stats_extra(&src->extra, dst);
 
@@ -8244,6 +8245,8 @@ void ath10k_wmi_10_4_op_fw_stats_fill(struct ath10k *ar,
 
 	ath10k_wmi_fw_pdev_rx_stats_fill(pdev, buf, &len);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
+			"Num Rx Timeout errors", pdev->rx_timeout_errs);
+	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
 			"Num Rx Overflow errors", pdev->rx_ovfl_errs);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 66b446d..93ca8e8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4434,6 +4434,7 @@ struct wmi_10_4_pdev_stats {
 	struct wmi_pdev_stats_base base;
 	struct wmi_10_4_pdev_stats_tx tx;
 	struct wmi_pdev_stats_rx rx;
+	__le32 pdev_rx_timeout;
 	__le32 rx_ovfl_errs;
 	struct wmi_pdev_stats_mem mem;
 	__le32 sram_free_size;
-- 
2.4.11
