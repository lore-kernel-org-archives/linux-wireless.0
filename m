Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:44493 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbbGTMaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 08:30:21 -0400
From: Vivek Natarajan <nataraja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: [PATCH] ath10k: Support different txbf configuration schemes
Date: Mon, 20 Jul 2015 18:00:00 +0530
Message-ID: <1437395401-2765-1-git-send-email-nataraja@qti.qualcomm.com> (sfid-20150720_143024_371366_5E24243A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca61x4 uses the vdev param as a sole sufficient configuration
for txbf while qca99x0 enables txbf during peer assoc by
combining the vdev param value with peer assoc's vht capabilities

This patch gets the appropriate txbf configuration scheme
before passing the wmi command to enable the same in the firmware.

Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     |  3 +++
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 10 ++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  6 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  6 ++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  6 ++++++
 5 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 524a894..0b31331 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2523,6 +2523,9 @@ static int ath10k_mac_vif_recalc_txbf(struct ath10k *ar,
 	u32 param;
 	u32 value;
 
+	if (ath10k_wmi_get_txbf_conf_scheme(ar) != WMI_TXBF_CONF_AFTER_ASSOC)
+		return 0;
+
 	if (!(ar->vht_cap_info &
 	      (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
 	       IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE |
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 04fe9d6..e1073cf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -49,6 +49,7 @@ struct wmi_ops {
 			    struct wmi_roam_ev_arg *arg);
 	int (*pull_wow_event)(struct ath10k *ar, struct sk_buff *skb,
 			      struct wmi_wow_ev_arg *arg);
+	enum wmi_txbf_conf (*get_txbf_conf_scheme)(struct ath10k *ar);
 
 	struct sk_buff *(*gen_pdev_suspend)(struct ath10k *ar, u32 suspend_opt);
 	struct sk_buff *(*gen_pdev_resume)(struct ath10k *ar);
@@ -340,6 +341,15 @@ ath10k_wmi_pull_wow_event(struct ath10k *ar, struct sk_buff *skb,
 	return ar->wmi.ops->pull_wow_event(ar, skb, arg);
 }
 
+static inline enum wmi_txbf_conf
+ath10k_wmi_get_txbf_conf_scheme(struct ath10k *ar)
+{
+	if (!ar->wmi.ops->get_txbf_conf_scheme)
+		return WMI_TXBF_CONF_UNSUPPORTED;
+
+	return ar->wmi.ops->get_txbf_conf_scheme(ar);
+}
+
 static inline int
 ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 8540c70..195fe39 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1257,6 +1257,11 @@ ath10k_wmi_tlv_op_gen_pdev_set_rd(struct ath10k *ar,
 	return skb;
 }
 
+static enum wmi_txbf_conf ath10k_wmi_tlv_txbf_conf_scheme(struct ath10k *ar)
+{
+        return WMI_TXBF_CONF_AFTER_ASSOC;
+}
+
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_pdev_set_param(struct ath10k *ar, u32 param_id,
 				     u32 param_value)
@@ -3386,6 +3391,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.pull_fw_stats = ath10k_wmi_tlv_op_pull_fw_stats,
 	.pull_roam_ev = ath10k_wmi_tlv_op_pull_roam_ev,
 	.pull_wow_event = ath10k_wmi_tlv_op_pull_wow_ev,
+	.get_txbf_conf_scheme = ath10k_wmi_tlv_txbf_conf_scheme,
 
 	.gen_pdev_suspend = ath10k_wmi_tlv_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_tlv_op_gen_pdev_resume,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 4a1f13b..4cd5599 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3153,6 +3153,11 @@ static int ath10k_wmi_10_4_op_pull_swba_ev(struct ath10k *ar,
 	return 0;
 }
 
+static enum wmi_txbf_conf ath10k_wmi_10_4_txbf_conf_scheme(struct ath10k *ar)
+{
+	return WMI_TXBF_CONF_BEFORE_ASSOC;
+}
+
 void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_swba_ev_arg arg = {};
@@ -6803,6 +6808,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.pull_swba = ath10k_wmi_10_4_op_pull_swba_ev,
 	.pull_svc_rdy = ath10k_wmi_main_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
+	.get_txbf_conf_scheme = ath10k_wmi_10_4_txbf_conf_scheme,
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ce69c9a..0a41ec4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6115,6 +6115,12 @@ struct wmi_pdev_set_cca_detect_params {
 	__le32 cca_detect_margin;
 } __packed;
 
+enum wmi_txbf_conf {
+	WMI_TXBF_CONF_UNSUPPORTED,
+	WMI_TXBF_CONF_BEFORE_ASSOC,
+	WMI_TXBF_CONF_AFTER_ASSOC,
+};
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
1.9.1

