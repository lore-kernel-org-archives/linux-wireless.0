Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59270 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755142AbeBOIuI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 03:50:08 -0500
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 10/13] ath10k: Add support to get target info from hif ops
Date: Thu, 15 Feb 2018 14:20:03 +0530
Message-Id: <1518684603-5812-1-git-send-email-govinds@codeaurora.org> (sfid-20180215_095011_836679_4A69C02B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rakesh Pillai <pillair@codeaurora.org>

wcn3990 does not use bmi.
Add support to get target info from hif ops.

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c |  8 ++++++++
 drivers/net/wireless/ath/ath10k/hif.h  | 13 +++++++++++++
 drivers/net/wireless/ath/ath10k/snoc.c | 10 ++++++++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 51444d3..bcce875 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2437,6 +2437,14 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		ar->hw->wiphy->hw_version = target_info.version;
 		break;
 	case ATH10K_BUS_SNOC:
+		memset(&target_info, 0, sizeof(target_info));
+		ret = ath10k_hif_get_target_info(ar, &target_info);
+		if (ret) {
+			ath10k_err(ar, "could not get target info (%d)\n", ret);
+			goto err_power_down;
+		}
+		ar->target_version = target_info.version;
+		ar->hw->wiphy->hw_version = target_info.version;
 		break;
 	default:
 		ath10k_err(ar, "incorrect hif bus type: %d\n", ar->hif.bus);
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 7abb13c..1a59ea0 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include "core.h"
+#include "bmi.h"
 #include "debug.h"
 
 struct ath10k_hif_sg_item {
@@ -93,6 +94,9 @@ struct ath10k_hif_ops {
 	/* fetch calibration data from target eeprom */
 	int (*fetch_cal_eeprom)(struct ath10k *ar, void **data,
 				size_t *data_len);
+
+	int (*get_target_info)(struct ath10k *ar,
+			       struct bmi_target_info *target_info);
 };
 
 static inline int ath10k_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
@@ -218,4 +222,13 @@ static inline int ath10k_hif_fetch_cal_eeprom(struct ath10k *ar,
 	return ar->hif.ops->fetch_cal_eeprom(ar, data, data_len);
 }
 
+static inline int ath10k_hif_get_target_info(struct ath10k *ar,
+					     struct bmi_target_info *tgt_info)
+{
+	if (!ar->hif.ops->get_target_info)
+		return -EOPNOTSUPP;
+
+	return ar->hif.ops->get_target_info(ar, tgt_info);
+}
+
 #endif /* _HIF_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 6d9ccce..1ef0d3b 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -528,6 +528,15 @@ static int ath10k_snoc_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 	return err;
 }
 
+static int ath10k_snoc_hif_get_target_info(struct ath10k *ar,
+					   struct bmi_target_info *target_info)
+{
+	target_info->version = ATH10K_HW_WCN3990;
+	target_info->type = ATH10K_HW_WCN3990;
+
+	return 0;
+}
+
 static u16 ath10k_snoc_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
@@ -787,6 +796,7 @@ static int ath10k_snoc_hif_power_up(struct ath10k *ar)
 	.tx_sg			= ath10k_snoc_hif_tx_sg,
 	.send_complete_check	= ath10k_snoc_hif_send_complete_check,
 	.get_free_queue_number	= ath10k_snoc_hif_get_free_queue_number,
+	.get_target_info	= ath10k_snoc_hif_get_target_info,
 };
 
 static const struct ath10k_bus_ops ath10k_snoc_bus_ops = {
-- 
1.9.1
