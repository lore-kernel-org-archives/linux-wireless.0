Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7892 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLXH7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 02:59:43 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 1/8] ath10k: add wmi support for addba_clear_resp
Date: Wed, 24 Dec 2014 13:29:02 +0530
Message-ID: <1419407949-32367-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141224_090003_942727_09E5D53D)
In-Reply-To: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WMI support for clearing addba response before switching aggregation
mode (auto/manual) for debugging purpose.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 18 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c     | 28 ++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 20e2c30..b161043 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -119,6 +119,8 @@ struct wmi_ops {
 						   u32 next_offset,
 						   u32 enabled);
 	struct sk_buff *(*gen_pdev_get_temperature)(struct ath10k *ar);
+	struct sk_buff *(*gen_addba_clear_resp)(struct ath10k *ar, u32 vdev_id,
+						const u8 *mac);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -857,4 +859,20 @@ ath10k_wmi_pdev_get_temperature(struct ath10k *ar)
 				   ar->wmi.cmd->pdev_get_temperature_cmdid);
 }
 
+static inline int
+ath10k_wmi_addba_clear_resp(struct ath10k *ar, u32 vdev_id, const u8 *mac)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_addba_clear_resp)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_addba_clear_resp(ar, vdev_id, mac);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->addba_clear_resp_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 4c050ce..499a779 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2207,6 +2207,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_pktlog_disable = ath10k_wmi_tlv_op_gen_pktlog_disable,
 	/* .gen_pdev_set_quiet_mode not implemented */
 	/* .gen_pdev_get_temperature not implemented */
+	/* .gen_addba_clear_resp not implemented */
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ac74290..4bd38a6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4877,6 +4877,30 @@ ath10k_wmi_op_gen_pdev_set_quiet_mode(struct ath10k *ar, u32 period,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_op_gen_addba_clear_resp(struct ath10k *ar, u32 vdev_id,
+				   const u8 *mac)
+{
+	struct wmi_addba_clear_resp_cmd *cmd;
+	struct sk_buff *skb;
+
+	if (!mac)
+		return ERR_PTR(-EINVAL);
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_addba_clear_resp_cmd *)skb->data;
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	ether_addr_copy(cmd->peer_macaddr.addr, mac);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi addba clear resp vdev_id 0x%X mac_addr %pM\n",
+		   vdev_id, mac);
+	return skb;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -4928,6 +4952,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	/* .gen_pdev_get_temperature not implemented */
+	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -4982,6 +5007,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
+	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -5037,6 +5063,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
+	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
 };
 
 static const struct wmi_ops wmi_10_2_4_ops = {
@@ -5092,6 +5119,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
+	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
2.2.1

