Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37110 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbeCEG7B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 01:59:01 -0500
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Add WMI FWTEST command support
Date: Mon,  5 Mar 2018 12:29:07 +0530
Message-Id: <1520233148-26050-2-git-send-email-akolli@codeaurora.org> (sfid-20180305_075904_546688_EA69118B)
In-Reply-To: <1520233148-26050-1-git-send-email-akolli@codeaurora.org>
References: <1520233148-26050-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sathishkumar Muruganandam <murugana@codeaurora.org>

This patch adds support for WMI_FWTEST_CMD.
This command is used for setting the wifi parameters.

Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   18 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   24 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     |    7 +++++++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 14093cfdc505..5b710c64493d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -125,6 +126,8 @@ struct wmi_ops {
 					     enum wmi_force_fw_hang_type type,
 					     u32 delay_ms);
 	struct sk_buff *(*gen_mgmt_tx)(struct ath10k *ar, struct sk_buff *skb);
+	struct sk_buff *(*gen_fw_test)(struct ath10k *ar, u32 param_id,
+				       u32 param_value);
 	struct sk_buff *(*gen_dbglog_cfg)(struct ath10k *ar, u64 module_enable,
 					  u32 log_level);
 	struct sk_buff *(*gen_pktlog_enable)(struct ath10k *ar, u32 filter);
@@ -959,6 +962,21 @@ struct wmi_ops {
 }
 
 static inline int
+ath10k_wmi_fw_test(struct ath10k *ar, u32 param_id, u32 param_value)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_fw_test)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_fw_test(ar, param_id, param_value);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->fwtest_cmdid);
+}
+
+static inline int
 ath10k_wmi_dbglog_cfg(struct ath10k *ar, u64 module_enable, u32 log_level)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 58dc2189ba49..09ffc188e5f5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -511,7 +512,7 @@
 	.pdev_ratepwr_chainmsk_table_cmdid = WMI_CMD_UNSUPPORTED,
 	.pdev_fips_cmdid = WMI_CMD_UNSUPPORTED,
 	.tt_set_conf_cmdid = WMI_CMD_UNSUPPORTED,
-	.fwtest_cmdid = WMI_CMD_UNSUPPORTED,
+	.fwtest_cmdid = WMI_10_2_FWTEST_CMDID,
 	.vdev_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
 	.peer_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
 	.pdev_get_ani_cck_config_cmdid = WMI_CMD_UNSUPPORTED,
@@ -7092,6 +7093,25 @@ void ath10k_wmi_set_wmm_param(struct wmi_wmm_params *params,
 }
 
 static struct sk_buff *
+ath10k_wmi_op_gen_fw_test(struct ath10k *ar, u32 param_id, u32 param_value)
+{
+	struct wmi_fw_test_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_fw_test_cmd *)skb->data;
+	cmd->param_id = __cpu_to_le32(param_id);
+	cmd->param_value = __cpu_to_le32(param_value);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi fw_test %d %d",
+		   param_id, param_value);
+	return skb;
+}
+
+static struct sk_buff *
 ath10k_wmi_op_gen_dbglog_cfg(struct ath10k *ar, u64 module_enable,
 			     u32 log_level)
 {
@@ -8368,6 +8388,7 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
 	/* .gen_adaptive_qcs not implemented */
+	.gen_fw_test = ath10k_wmi_op_gen_fw_test,
 };
 
 static const struct wmi_ops wmi_10_4_ops = {
@@ -8418,6 +8439,7 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	.gen_pdev_set_wmm = ath10k_wmi_op_gen_pdev_set_wmm,
 	.gen_force_fw_hang = ath10k_wmi_op_gen_force_fw_hang,
 	.gen_mgmt_tx = ath10k_wmi_op_gen_mgmt_tx,
+	.gen_fw_test = ath10k_wmi_op_gen_fw_test,
 	.gen_dbglog_cfg = ath10k_wmi_10_4_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index c7b30ed9015d..1cb410ab6f8f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -1558,6 +1559,7 @@ enum wmi_10_2_cmd_id {
 	WMI_10_2_SET_LTEU_CONFIG_CMDID,
 	WMI_10_2_SET_CCA_PARAMS,
 	WMI_10_2_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
+	WMI_10_2_FWTEST_CMDID,
 	WMI_10_2_PDEV_UTF_CMDID = WMI_10_2_END_CMDID - 1,
 };
 
@@ -6366,6 +6368,11 @@ struct wmi_force_fw_hang_cmd {
 	__le32 delay_ms;
 } __packed;
 
+struct wmi_fw_test_cmd {
+	__le32 param_id;
+	__le32 param_value;
+} __packed;
+
 enum ath10k_dbglog_level {
 	ATH10K_DBGLOG_LEVEL_VERBOSE = 0,
 	ATH10K_DBGLOG_LEVEL_INFO = 1,
-- 
1.7.9.5
