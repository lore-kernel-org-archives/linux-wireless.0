Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:56207 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab3GPH4A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:56:00 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 2/3] ath10k: implement fw crash simulation command
Date: Tue, 16 Jul 2013 09:54:36 +0200
Message-ID: <1373961277-14784-3-git-send-email-michal.kazior@tieto.com> (sfid-20130716_095659_174138_D311FB23)
In-Reply-To: <1373961277-14784-1-git-send-email-michal.kazior@tieto.com>
References: <1372148011-28234-1-git-send-email-michal.kazior@tieto.com>
 <1373961277-14784-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful to test FW crash handling.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   19 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h |   19 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 0d25cd7..5e42460 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2092,3 +2092,22 @@ int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi request stats %d\n", (int)stats_id);
 	return ath10k_wmi_cmd_send(ar, skb, WMI_REQUEST_STATS_CMDID);
 }
+
+int ath10k_wmi_force_fw_hang(struct ath10k *ar,
+			     enum wmi_force_fw_hang_type type, u32 delay_ms)
+{
+	struct wmi_force_fw_hang_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_force_fw_hang_cmd *)skb->data;
+	cmd->type = __cpu_to_le32(type);
+	cmd->delay_ms = __cpu_to_le32(delay_ms);
+
+	ath10k_dbg(ATH10K_DBG_WMI, "wmi force fw hang %d delay %d\n",
+		   type, delay_ms);
+	return ath10k_wmi_cmd_send(ar, skb, WMI_FORCE_FW_HANG_CMDID);
+}
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 9555f5a..da3b2bc 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -416,6 +416,7 @@ enum wmi_cmd_id {
 	WMI_PDEV_FTM_INTG_CMDID,
 	WMI_VDEV_SET_KEEPALIVE_CMDID,
 	WMI_VDEV_GET_KEEPALIVE_CMDID,
+	WMI_FORCE_FW_HANG_CMDID,
 
 	/* GPIO Configuration */
 	WMI_GPIO_CONFIG_CMDID = WMI_CMD_GRP(WMI_GRP_GPIO),
@@ -2972,6 +2973,22 @@ struct wmi_sta_keepalive_cmd {
 	struct wmi_sta_keepalive_arp_resp arp_resp;
 } __packed;
 
+enum wmi_force_fw_hang_type {
+	WMI_FORCE_FW_HANG_ASSERT = 1,
+	WMI_FORCE_FW_HANG_NO_DETECT,
+	WMI_FORCE_FW_HANG_CTRL_EP_FULL,
+	WMI_FORCE_FW_HANG_EMPTY_POINT,
+	WMI_FORCE_FW_HANG_STACK_OVERFLOW,
+	WMI_FORCE_FW_HANG_INFINITE_LOOP,
+};
+
+#define WMI_FORCE_FW_HANG_RANDOM_TIME 0xFFFFFFFF
+
+struct wmi_force_fw_hang_cmd {
+	__le32 type;
+	__le32 delay_ms;
+} __packed;
+
 #define ATH10K_RTS_MAX		2347
 #define ATH10K_FRAGMT_THRESHOLD_MIN	540
 #define ATH10K_FRAGMT_THRESHOLD_MAX	2346
@@ -3048,5 +3065,7 @@ int ath10k_wmi_beacon_send(struct ath10k *ar, const struct wmi_bcn_tx_arg *arg);
 int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
 			const struct wmi_pdev_set_wmm_params_arg *arg);
 int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id);
+int ath10k_wmi_force_fw_hang(struct ath10k *ar,
+			     enum wmi_force_fw_hang_type type, u32 delay_ms);
 
 #endif /* _WMI_H_ */
-- 
1.7.9.5

