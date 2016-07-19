Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33105 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbcGSKce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 06:32:34 -0400
Received: by mail-lf0-f41.google.com with SMTP id b199so10170789lfe.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 03:32:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	marek.puzyniak@tieto.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/4] ath10k: implement wmi echo event
Date: Tue, 19 Jul 2016 12:34:10 +0200
Message-Id: <1468924452-23877-3-git-send-email-michal.kazior@tieto.com> (sfid-20160719_123240_409693_1DB912AA)
In-Reply-To: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com>
References: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Will be useful for implementing command barriers.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 12 ++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 28 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 29 ++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     |  4 ++++
 4 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index b1d88fa60d11..c67eda78b69e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -51,6 +51,8 @@ struct wmi_ops {
 			    struct wmi_roam_ev_arg *arg);
 	int (*pull_wow_event)(struct ath10k *ar, struct sk_buff *skb,
 			      struct wmi_wow_ev_arg *arg);
+	int (*pull_echo_ev)(struct ath10k *ar, struct sk_buff *skb,
+			    struct wmi_echo_ev_arg *arg);
 	enum wmi_txbf_conf (*get_txbf_conf_scheme)(struct ath10k *ar);
 
 	struct sk_buff *(*gen_pdev_suspend)(struct ath10k *ar, u32 suspend_opt);
@@ -350,6 +352,16 @@ ath10k_wmi_pull_wow_event(struct ath10k *ar, struct sk_buff *skb,
 	return ar->wmi.ops->pull_wow_event(ar, skb, arg);
 }
 
+static inline int
+ath10k_wmi_pull_echo_ev(struct ath10k *ar, struct sk_buff *skb,
+			struct wmi_echo_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_echo_ev)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_echo_ev(ar, skb, arg);
+}
+
 static inline enum wmi_txbf_conf
 ath10k_wmi_get_txbf_conf_scheme(struct ath10k *ar)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index cd595855af36..a42f52dd9a36 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1223,6 +1223,33 @@ ath10k_wmi_tlv_op_pull_wow_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
+static int ath10k_wmi_tlv_op_pull_echo_ev(struct ath10k *ar,
+					  struct sk_buff *skb,
+					  struct wmi_echo_ev_arg *arg)
+{
+	const void **tb;
+	const struct wmi_echo_event *ev;
+	int ret;
+
+	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ret = PTR_ERR(tb);
+		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
+		return ret;
+	}
+
+	ev = tb[WMI_TLV_TAG_STRUCT_ECHO_EVENT];
+	if (!ev) {
+		kfree(tb);
+		return -EPROTO;
+	}
+
+	arg->value = ev->value;
+
+	kfree(tb);
+	return 0;
+}
+
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_pdev_suspend(struct ath10k *ar, u32 opt)
 {
@@ -3457,6 +3484,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.pull_fw_stats = ath10k_wmi_tlv_op_pull_fw_stats,
 	.pull_roam_ev = ath10k_wmi_tlv_op_pull_roam_ev,
 	.pull_wow_event = ath10k_wmi_tlv_op_pull_wow_ev,
+	.pull_echo_ev = ath10k_wmi_tlv_op_pull_echo_ev,
 	.get_txbf_conf_scheme = ath10k_wmi_tlv_txbf_conf_scheme,
 
 	.gen_pdev_suspend = ath10k_wmi_tlv_op_gen_pdev_suspend,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 9ae4aacadb38..8ca76ecd7e9b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2495,7 +2495,18 @@ exit:
 
 void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_ECHO_EVENTID\n");
+	struct wmi_echo_ev_arg arg = {};
+	int ret;
+
+	ret = ath10k_wmi_pull_echo_ev(ar, skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse echo: %d\n", ret);
+		return;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi event echo value 0x%08x\n",
+		   le32_to_cpu(arg.value));
 }
 
 int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
@@ -4792,6 +4803,17 @@ static int ath10k_wmi_op_pull_roam_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
+static int ath10k_wmi_op_pull_echo_ev(struct ath10k *ar,
+				      struct sk_buff *skb,
+				      struct wmi_echo_ev_arg *arg)
+{
+	struct wmi_echo_event *ev = (void *)skb->data;
+
+	arg->value = ev->value;
+
+	return 0;
+}
+
 int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_rdy_ev_arg arg = {};
@@ -7683,6 +7705,7 @@ static const struct wmi_ops wmi_ops = {
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_fw_stats = ath10k_wmi_main_op_pull_fw_stats,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
+	.pull_echo_ev = ath10k_wmi_op_pull_echo_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
@@ -7757,6 +7780,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
+	.pull_echo_ev = ath10k_wmi_op_pull_echo_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
@@ -7828,6 +7852,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
+	.pull_echo_ev = ath10k_wmi_op_pull_echo_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
@@ -7895,6 +7920,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
+	.pull_echo_ev = ath10k_wmi_op_pull_echo_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
@@ -8002,6 +8028,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.ext_resource_config = ath10k_wmi_10_4_ext_resource_config,
 
 	/* shared with 10.2 */
+	.pull_echo_ev = ath10k_wmi_op_pull_echo_ev,
 	.gen_request_stats = ath10k_wmi_op_gen_request_stats,
 	.gen_pdev_get_temperature = ath10k_wmi_10_2_op_gen_pdev_get_temperature,
 	.get_vdev_subtype = ath10k_wmi_10_4_op_get_vdev_subtype,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 3ef468893b3f..086d78807d2f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6296,6 +6296,10 @@ struct wmi_roam_ev_arg {
 	__le32 rssi;
 };
 
+struct wmi_echo_ev_arg {
+	__le32 value;
+};
+
 struct wmi_pdev_temperature_event {
 	/* temperature value in Celcius degree */
 	__le32 temperature;
-- 
2.1.4

