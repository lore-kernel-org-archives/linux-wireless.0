Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56651 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbbKDMGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 07:06:42 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V2 1/3] ath10k: Fix peer assoc complete WMI command for 10.4
Date: Wed, 4 Nov 2015 17:35:35 +0530
Message-ID: <1446638737-7953-2-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20151104_130645_697151_FA05A197)
In-Reply-To: <1446638737-7953-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1446638737-7953-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is an extra 4-byte member when compared to WMI 10.2 added to
assoc complete command in WMI 10.4. This new member is used for 160Mhz
related configuration. This WMI command mismatch between host and
firmware does not cause any real issues because this new member is not
used in 10.4 firmwares so far (10.4.1.00030-1). This difference in WMI
command interface brings in a new wmi_ops for 10.4 gen_peer_assoc().
No noticeable functionality differences with this change can be seen
with the current 10.4 firmwares, but the WMI interface has to be
fixed to work with future 10.4 firmwares which may be using this new
member.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 37 ++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h |  5 +++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 7569db0..e8614ab 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6328,6 +6328,16 @@ ath10k_wmi_peer_assoc_fill_10_2(struct ath10k *ar, void *buf,
 	cmd->info0 = __cpu_to_le32(info0);
 }
 
+static void
+ath10k_wmi_peer_assoc_fill_10_4(struct ath10k *ar, void *buf,
+				const struct wmi_peer_assoc_complete_arg *arg)
+{
+	struct wmi_10_4_peer_assoc_complete_cmd *cmd = buf;
+
+	ath10k_wmi_peer_assoc_fill_10_2(ar, buf, arg);
+	cmd->peer_bw_rxnss_override = 0;
+}
+
 static int
 ath10k_wmi_peer_assoc_check_arg(const struct wmi_peer_assoc_complete_arg *arg)
 {
@@ -6417,6 +6427,31 @@ ath10k_wmi_10_2_op_gen_peer_assoc(struct ath10k *ar,
 }
 
 static struct sk_buff *
+ath10k_wmi_10_4_op_gen_peer_assoc(struct ath10k *ar,
+				  const struct wmi_peer_assoc_complete_arg *arg)
+{
+	size_t len = sizeof(struct wmi_10_4_peer_assoc_complete_cmd);
+	struct sk_buff *skb;
+	int ret;
+
+	ret = ath10k_wmi_peer_assoc_check_arg(arg);
+	if (ret)
+		return ERR_PTR(ret);
+
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ath10k_wmi_peer_assoc_fill_10_4(ar, skb->data, arg);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi peer assoc vdev %d addr %pM (%s)\n",
+		   arg->vdev_id, arg->addr,
+		   arg->peer_reassoc ? "reassociate" : "new");
+	return skb;
+}
+
+static struct sk_buff *
 ath10k_wmi_10_2_op_gen_pdev_get_temperature(struct ath10k *ar)
 {
 	struct sk_buff *skb;
@@ -7536,6 +7571,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.gen_peer_delete = ath10k_wmi_op_gen_peer_delete,
 	.gen_peer_flush = ath10k_wmi_op_gen_peer_flush,
 	.gen_peer_set_param = ath10k_wmi_op_gen_peer_set_param,
+	.gen_peer_assoc = ath10k_wmi_10_4_op_gen_peer_assoc,
 	.gen_set_psmode = ath10k_wmi_op_gen_set_psmode,
 	.gen_set_sta_ps = ath10k_wmi_op_gen_set_sta_ps,
 	.gen_set_ap_ps = ath10k_wmi_op_gen_set_ap_ps,
@@ -7555,7 +7591,6 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.fw_stats_fill = ath10k_wmi_10_4_op_fw_stats_fill,
 
 	/* shared with 10.2 */
-	.gen_peer_assoc = ath10k_wmi_10_2_op_gen_peer_assoc,
 	.gen_request_stats = ath10k_wmi_op_gen_request_stats,
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index a8ea93e..ab6d218 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5741,6 +5741,11 @@ struct wmi_10_2_peer_assoc_complete_cmd {
 	__le32 info0; /* WMI_PEER_ASSOC_INFO0_ */
 } __packed;
 
+struct wmi_10_4_peer_assoc_complete_cmd {
+	struct wmi_10_2_peer_assoc_complete_cmd cmd;
+	__le32 peer_bw_rxnss_override;
+} __packed;
+
 struct wmi_peer_assoc_complete_arg {
 	u8 addr[ETH_ALEN];
 	u32 vdev_id;
-- 
1.9.1

