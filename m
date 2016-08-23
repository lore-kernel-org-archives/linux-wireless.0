Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25626 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756635AbcHWKFi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Aug 2016 06:05:38 -0400
From: <c_mkenna@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <mkenna@codeaurora.org>,
        "Maharaja Kennadyrajan" <c_mkenna@qti.qualcomm.com>
Subject: [PATCH] ath10k: Added support for extended dbglog module id for 10.4
Date: Tue, 23 Aug 2016 15:35:36 +0530
Message-ID: <1471946736-28214-1-git-send-email-c_mkenna@qti.qualcomm.com> (sfid-20160823_120630_251640_E257AB3F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

For 10.4 fw versions, dbglog module id has been extended from u32
to u64, hence this patch fixes the same in the ath10k driver side.

This patch doesn't break the older 10.4 releases. The FW change
is already present in the older FWs.

Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h    |    2 +-
 drivers/net/wireless/ath/ath10k/debug.c   |   11 ++++----
 drivers/net/wireless/ath/ath10k/wmi-ops.h |    4 +--
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c     |   42 +++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h     |   14 ++++++++++
 6 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 30ae5bf..b7670f4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -440,7 +440,7 @@ struct ath10k_debug {
 	struct completion tpc_complete;
 
 	/* protected by conf_mutex */
-	u32 fw_dbglog_mask;
+	u64 fw_dbglog_mask;
 	u32 fw_dbglog_level;
 	u32 pktlog_filter;
 	u32 reg_addr;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8f0fd41..832da6e 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1228,9 +1228,9 @@ static ssize_t ath10k_read_fw_dbglog(struct file *file,
 {
 	struct ath10k *ar = file->private_data;
 	unsigned int len;
-	char buf[64];
+	char buf[96];
 
-	len = scnprintf(buf, sizeof(buf), "0x%08x %u\n",
+	len = scnprintf(buf, sizeof(buf), "0x%16llx %u\n",
 			ar->debug.fw_dbglog_mask, ar->debug.fw_dbglog_level);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
@@ -1242,15 +1242,16 @@ static ssize_t ath10k_write_fw_dbglog(struct file *file,
 {
 	struct ath10k *ar = file->private_data;
 	int ret;
-	char buf[64];
-	unsigned int log_level, mask;
+	char buf[96];
+	unsigned int log_level;
+	u64 mask;
 
 	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
 
 	/* make sure that buf is null terminated */
 	buf[sizeof(buf) - 1] = 0;
 
-	ret = sscanf(buf, "%x %u", &mask, &log_level);
+	ret = sscanf(buf, "%llx %u", &mask, &log_level);
 
 	if (!ret)
 		return -EINVAL;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 64ebd30..e53a61a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -123,7 +123,7 @@ struct wmi_ops {
 					     enum wmi_force_fw_hang_type type,
 					     u32 delay_ms);
 	struct sk_buff *(*gen_mgmt_tx)(struct ath10k *ar, struct sk_buff *skb);
-	struct sk_buff *(*gen_dbglog_cfg)(struct ath10k *ar, u32 module_enable,
+	struct sk_buff *(*gen_dbglog_cfg)(struct ath10k *ar, u64 module_enable,
 					  u32 log_level);
 	struct sk_buff *(*gen_pktlog_enable)(struct ath10k *ar, u32 filter);
 	struct sk_buff *(*gen_pktlog_disable)(struct ath10k *ar);
@@ -932,7 +932,7 @@ ath10k_wmi_force_fw_hang(struct ath10k *ar,
 }
 
 static inline int
-ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable, u32 log_level)
+ath10k_wmi_dbglog_cfg(struct ath10k *ar, u64 module_enable, u32 log_level)
 {
 	struct sk_buff *skb;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index e09337e..fbeac30 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2441,7 +2441,7 @@ ath10k_wmi_tlv_op_gen_force_fw_hang(struct ath10k *ar,
 }
 
 static struct sk_buff *
-ath10k_wmi_tlv_op_gen_dbglog_cfg(struct ath10k *ar, u32 module_enable,
+ath10k_wmi_tlv_op_gen_dbglog_cfg(struct ath10k *ar, u64 module_enable,
 				 u32 log_level) {
 	struct wmi_tlv_dbglog_cmd *cmd;
 	struct wmi_tlv *tlv;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d246288..f54fe963 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6863,7 +6863,7 @@ ath10k_wmi_op_gen_force_fw_hang(struct ath10k *ar,
 }
 
 static struct sk_buff *
-ath10k_wmi_op_gen_dbglog_cfg(struct ath10k *ar, u32 module_enable,
+ath10k_wmi_op_gen_dbglog_cfg(struct ath10k *ar, u64 module_enable,
 			     u32 log_level)
 {
 	struct wmi_dbglog_cfg_cmd *cmd;
@@ -6901,6 +6901,44 @@ ath10k_wmi_op_gen_dbglog_cfg(struct ath10k *ar, u32 module_enable,
 }
 
 static struct sk_buff *
+ath10k_wmi_10_4_op_gen_dbglog_cfg(struct ath10k *ar, u64 module_enable,
+				  u32 log_level)
+{
+	struct wmi_10_4_dbglog_cfg_cmd *cmd;
+	struct sk_buff *skb;
+	u32 cfg;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_10_4_dbglog_cfg_cmd *)skb->data;
+
+	if (module_enable) {
+		cfg = SM(log_level,
+			 ATH10K_DBGLOG_CFG_LOG_LVL);
+	} else {
+		/* set back defaults, all modules with WARN level */
+		cfg = SM(ATH10K_DBGLOG_LEVEL_WARN,
+			 ATH10K_DBGLOG_CFG_LOG_LVL);
+		module_enable = ~0;
+	}
+
+	cmd->module_enable = __cpu_to_le64(module_enable);
+	cmd->module_valid = __cpu_to_le64(~0);
+	cmd->config_enable = __cpu_to_le32(cfg);
+	cmd->config_valid = __cpu_to_le32(ATH10K_DBGLOG_CFG_LOG_LVL_MASK);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi dbglog cfg modules 0x%016llx 0x%016llx config %08x %08x\n",
+		   __le64_to_cpu(cmd->module_enable),
+		   __le64_to_cpu(cmd->module_valid),
+		   __le32_to_cpu(cmd->config_enable),
+		   __le32_to_cpu(cmd->config_valid));
+	return skb;
+}
+
+static struct sk_buff *
 ath10k_wmi_op_gen_pktlog_enable(struct ath10k *ar, u32 ev_bitmap)
 {
 	struct wmi_pdev_pktlog_enable_cmd *cmd;
@@ -7968,7 +8006,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.gen_pdev_set_wmm = ath10k_wmi_op_gen_pdev_set_wmm,
 	.gen_force_fw_hang = ath10k_wmi_op_gen_force_fw_hang,
 	.gen_mgmt_tx = ath10k_wmi_op_gen_mgmt_tx,
-	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
+	.gen_dbglog_cfg = ath10k_wmi_10_4_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 3ef4688..b0460a4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6169,6 +6169,20 @@ struct wmi_dbglog_cfg_cmd {
 	__le32 config_valid;
 } __packed;
 
+struct wmi_10_4_dbglog_cfg_cmd {
+	/* bitmask to hold mod id config*/
+	__le64 module_enable;
+
+	/* see ATH10K_DBGLOG_CFG_ */
+	__le32 config_enable;
+
+	/* mask of module id bits to be changed */
+	__le64 module_valid;
+
+	/* mask of config bits to be changed, see ATH10K_DBGLOG_CFG_ */
+	__le32 config_valid;
+} __packed;
+
 enum wmi_roam_reason {
 	WMI_ROAM_REASON_BETTER_AP = 1,
 	WMI_ROAM_REASON_BEACON_MISS = 2,
-- 
1.7.9.5
