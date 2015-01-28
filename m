Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18478 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbbA1UZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 15:25:06 -0500
Date: Wed, 28 Jan 2015 16:51:51 +0530
From: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: add log level configuration for fw_dbglog
Message-ID: <20150128112149.GA27237@senthilj-ThinkPad-L430> (sfid-20150128_230021_044924_A4BF779B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Introduce optional log level configuration for
existing debugfs fw_dbglog.

It allow users to configure desired log level
for firmware debugs.

To configure log level as WARN

echo 0xffffffff  2 > /sys/kernel/debug/ieee80211/phy0/ath10k/fw_dbglog

Loglevel	Value
VERBOSE		0
INFO		1
WARN		2
ERR		3

Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h    |  1 +
 drivers/net/wireless/ath/ath10k/debug.c   | 30 +++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  7 ++++---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  4 ++--
 drivers/net/wireless/ath/ath10k/wmi.c     |  5 +++--
 5 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2d9f871..b4aecbd 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -345,6 +345,7 @@ struct ath10k_debug {

 	/* protected by conf_mutex */
 	u32 fw_dbglog_mask;
+	u32 fw_dbglog_level;
 	u32 pktlog_filter;
 	u32 reg_addr;
 	u32 nf_cal_period;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 42b2e49..b77c51a 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1318,10 +1318,10 @@ static ssize_t ath10k_read_fw_dbglog(struct file *file,
 {
 	struct ath10k *ar = file->private_data;
 	unsigned int len;
-	char buf[32];
+	char buf[64];

-	len = scnprintf(buf, sizeof(buf), "0x%08x\n",
-			ar->debug.fw_dbglog_mask);
+	len = scnprintf(buf, sizeof(buf), "0x%08x %u\n",
+			ar->debug.fw_dbglog_mask, ar->debug.fw_dbglog_level);

 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
@@ -1331,19 +1331,30 @@ static ssize_t ath10k_write_fw_dbglog(struct file *file,
 				      size_t count, loff_t *ppos)
 {
 	struct ath10k *ar = file->private_data;
-	unsigned long mask;
 	int ret;
+	char buf[64];
+	unsigned int log_level, mask;

-	ret = kstrtoul_from_user(user_buf, count, 0, &mask);
-	if (ret)
-		return ret;
+	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+
+	/* make sure that buf is null terminated */
+	buf[sizeof(buf) - 1] = 0;
+
+	ret = sscanf(buf, "%x %u", &mask, &log_level);
+
+	if (!ret)
+		return -EINVAL;

 	mutex_lock(&ar->conf_mutex);

 	ar->debug.fw_dbglog_mask = mask;
+	ar->debug.fw_dbglog_level = (ret == 1) ? ATH10K_DBGLOG_LEVEL_WARN :
+				     log_level;
+

 	if (ar->state == ATH10K_STATE_ON) {
-		ret = ath10k_wmi_dbglog_cfg(ar, ar->debug.fw_dbglog_mask);
+		ret = ath10k_wmi_dbglog_cfg(ar, ar->debug.fw_dbglog_mask,
+					    ar->debug.fw_dbglog_level);
 		if (ret) {
 			ath10k_warn(ar, "dbglog cfg failed from debugfs: %d\n",
 				    ret);
@@ -1685,7 +1696,8 @@ int ath10k_debug_start(struct ath10k *ar)
 			    ret);

 	if (ar->debug.fw_dbglog_mask) {
-		ret = ath10k_wmi_dbglog_cfg(ar, ar->debug.fw_dbglog_mask);
+		ret = ath10k_wmi_dbglog_cfg(ar, ar->debug.fw_dbglog_mask,
+					    ATH10K_DBGLOG_LEVEL_WARN);
 		if (ret)
 			/* not serious */
 			ath10k_warn(ar, "failed to enable dbglog during start: %d",
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 80bd28a..4517993 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -111,7 +111,8 @@ struct wmi_ops {
 					     enum wmi_force_fw_hang_type type,
 					     u32 delay_ms);
 	struct sk_buff *(*gen_mgmt_tx)(struct ath10k *ar, struct sk_buff *skb);
-	struct sk_buff *(*gen_dbglog_cfg)(struct ath10k *ar, u32 module_enable);
+	struct sk_buff *(*gen_dbglog_cfg)(struct ath10k *ar, u32 module_enable,
+					  u32 log_level);
 	struct sk_buff *(*gen_pktlog_enable)(struct ath10k *ar, u32 filter);
 	struct sk_buff *(*gen_pktlog_disable)(struct ath10k *ar);
 	struct sk_buff *(*gen_pdev_set_quiet_mode)(struct ath10k *ar,
@@ -821,14 +822,14 @@ ath10k_wmi_force_fw_hang(struct ath10k *ar,
 }

 static inline int
-ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable)
+ath10k_wmi_dbglog_cfg(struct ath10k *ar, u32 module_enable, u32 log_level)
 {
 	struct sk_buff *skb;

 	if (!ar->wmi.ops->gen_dbglog_cfg)
 		return -EOPNOTSUPP;

-	skb = ar->wmi.ops->gen_dbglog_cfg(ar, module_enable);
+	skb = ar->wmi.ops->gen_dbglog_cfg(ar, module_enable, log_level);
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index d3cf91dc..d3d5aea 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2044,8 +2044,8 @@ ath10k_wmi_tlv_op_gen_force_fw_hang(struct ath10k *ar,
 }

 static struct sk_buff *
-ath10k_wmi_tlv_op_gen_dbglog_cfg(struct ath10k *ar, u32 module_enable)
-{
+ath10k_wmi_tlv_op_gen_dbglog_cfg(struct ath10k *ar, u32 module_enable,
+				 u32 log_level) {
 	struct wmi_tlv_dbglog_cmd *cmd;
 	struct wmi_tlv *tlv;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d340361..2fa68ad 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4960,7 +4960,8 @@ ath10k_wmi_op_gen_force_fw_hang(struct ath10k *ar,
 }

 static struct sk_buff *
-ath10k_wmi_op_gen_dbglog_cfg(struct ath10k *ar, u32 module_enable)
+ath10k_wmi_op_gen_dbglog_cfg(struct ath10k *ar, u32 module_enable,
+			     u32 log_level)
 {
 	struct wmi_dbglog_cfg_cmd *cmd;
 	struct sk_buff *skb;
@@ -4973,7 +4974,7 @@ ath10k_wmi_op_gen_dbglog_cfg(struct ath10k *ar, u32 module_enable)
 	cmd = (struct wmi_dbglog_cfg_cmd *)skb->data;

 	if (module_enable) {
-		cfg = SM(ATH10K_DBGLOG_LEVEL_VERBOSE,
+		cfg = SM(log_level,
 			 ATH10K_DBGLOG_CFG_LOG_LVL);
 	} else {
 		/* set back defaults, all modules with WARN level */
--
1.9.1

