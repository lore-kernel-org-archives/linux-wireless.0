Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12013 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaLQKWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:22:03 -0500
Subject: [PATCH v2 5/8] ath10k: add wmi support for pdev_set_quiet_mode
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 17 Dec 2014 12:21:40 +0200
Message-ID: <20141217102140.15964.63513.stgit@potku.adurom.net> (sfid-20141217_112207_401526_EFEC4DA5)
In-Reply-To: <20141217101755.15964.2625.stgit@potku.adurom.net>
References: <20141217101755.15964.2625.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Add WMI support to send pdev_set_quiet_mode command to target.
This will be used for thermal mitigation purpose.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   22 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    1 +
 drivers/net/wireless/ath/ath10k/wmi.c     |   28 ++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 1fbc5207b870..feed0fe5e117 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -114,6 +114,10 @@ struct wmi_ops {
 	struct sk_buff *(*gen_dbglog_cfg)(struct ath10k *ar, u32 module_enable);
 	struct sk_buff *(*gen_pktlog_enable)(struct ath10k *ar, u32 filter);
 	struct sk_buff *(*gen_pktlog_disable)(struct ath10k *ar);
+	struct sk_buff *(*gen_pdev_set_quiet_mode)(struct ath10k *ar,
+						   u32 period, u32 duration,
+						   u32 next_offset,
+						   u32 enabled);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -818,4 +822,22 @@ ath10k_wmi_pdev_pktlog_disable(struct ath10k *ar)
 				   ar->wmi.cmd->pdev_pktlog_disable_cmdid);
 }
 
+static inline int
+ath10k_wmi_pdev_set_quiet_mode(struct ath10k *ar, u32 period, u32 duration,
+			       u32 next_offset, u32 enabled)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_set_quiet_mode)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_set_quiet_mode(ar, period, duration,
+						   next_offset, enabled);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_set_quiet_mode_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 1627ec58a229..e203dadf1c0f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2204,6 +2204,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_dbglog_cfg = ath10k_wmi_tlv_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_tlv_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_tlv_op_gen_pktlog_disable,
+	/* .gen_pdev_set_quiet_mode not implemented */
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index cf9c727dc7d3..77bb3313ca47 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4821,6 +4821,30 @@ ath10k_wmi_op_gen_pktlog_disable(struct ath10k *ar)
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_op_gen_pdev_set_quiet_mode(struct ath10k *ar, u32 period,
+				      u32 duration, u32 next_offset,
+				      u32 enabled)
+{
+	struct wmi_pdev_set_quiet_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_pdev_set_quiet_cmd *)skb->data;
+	cmd->period = __cpu_to_le32(period);
+	cmd->duration = __cpu_to_le32(duration);
+	cmd->next_start = __cpu_to_le32(next_offset);
+	cmd->enabled = __cpu_to_le32(enabled);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi quiet param: period %u duration %u enabled %d\n",
+		   period, duration, enabled);
+	return skb;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -4870,6 +4894,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -4922,6 +4947,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -4975,6 +5001,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 };
 
 static const struct wmi_ops wmi_10_2_4_ops = {
@@ -5028,6 +5055,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)

