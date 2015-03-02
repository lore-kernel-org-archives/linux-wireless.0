Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:45542 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbCBLd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 06:33:28 -0500
Received: by lbiz12 with SMTP id z12so1404937lbi.12
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 03:33:26 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: implement wmi roam event
Date: Mon,  2 Mar 2015 12:32:11 +0100
Message-Id: <1425295932-10386-1-git-send-email-michal.kazior@tieto.com> (sfid-20150302_123331_269795_87AE390C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be used to implement offloaded rssi
threshold, beacon miss or even automatic
in-firmware BSS roaming in the future.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 12 +++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 32 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  6 ++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 55 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     | 22 +++++++++++++
 5 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index c8b64e7..f0a8b8d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -45,6 +45,8 @@ struct wmi_ops {
 			struct wmi_rdy_ev_arg *arg);
 	int (*pull_fw_stats)(struct ath10k *ar, struct sk_buff *skb,
 			     struct ath10k_fw_stats *stats);
+	int (*pull_roam_ev)(struct ath10k *ar, struct sk_buff *skb,
+			    struct wmi_roam_ev_arg *arg);
 
 	struct sk_buff *(*gen_pdev_suspend)(struct ath10k *ar, u32 suspend_opt);
 	struct sk_buff *(*gen_pdev_resume)(struct ath10k *ar);
@@ -274,6 +276,16 @@ ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
 }
 
 static inline int
+ath10k_wmi_pull_roam_ev(struct ath10k *ar, struct sk_buff *skb,
+			struct wmi_roam_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_roam_ev)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_roam_ev(ar, skb, arg);
+}
+
+static inline int
 ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(msdu);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index f34baa0..8cc4a38 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -62,6 +62,8 @@ static const struct wmi_tlv_policy wmi_tlv_policies[] = {
 		= { .min_len = sizeof(struct wmi_tlv_bcn_tx_status_ev) },
 	[WMI_TLV_TAG_STRUCT_DIAG_DATA_CONTAINER_EVENT]
 		= { .min_len = sizeof(struct wmi_tlv_diag_data_ev) },
+	[WMI_TLV_TAG_STRUCT_ROAM_EVENT]
+		= { .min_len = sizeof(struct wmi_tlv_roam_ev) },
 };
 
 static int
@@ -1012,6 +1014,35 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 	return 0;
 }
 
+static int ath10k_wmi_tlv_op_pull_roam_ev(struct ath10k *ar,
+					  struct sk_buff *skb,
+					  struct wmi_roam_ev_arg *arg)
+{
+	const void **tb;
+	const struct wmi_tlv_roam_ev *ev;
+	int ret;
+
+	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ret = PTR_ERR(tb);
+		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
+		return ret;
+	}
+
+	ev = tb[WMI_TLV_TAG_STRUCT_ROAM_EVENT];
+	if (!ev) {
+		kfree(tb);
+		return -EPROTO;
+	}
+
+	arg->vdev_id = ev->vdev_id;
+	arg->reason = ev->reason;
+	arg->rssi = ev->rssi;
+
+	kfree(tb);
+	return 0;
+}
+
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_pdev_suspend(struct ath10k *ar, u32 opt)
 {
@@ -2741,6 +2772,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.pull_svc_rdy = ath10k_wmi_tlv_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_tlv_op_pull_rdy_ev,
 	.pull_fw_stats = ath10k_wmi_tlv_op_pull_fw_stats,
+	.pull_roam_ev = ath10k_wmi_tlv_op_pull_roam_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_tlv_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_tlv_op_gen_pdev_resume,
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index d7a31e1..632b813 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1448,6 +1448,12 @@ struct wmi_tlv_stats_ev {
 	__le32 num_chan_stats;
 } __packed;
 
+struct wmi_tlv_roam_ev {
+	__le32 vdev_id;
+	__le32 reason;
+	__le32 rssi;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c7ea77e..4bed11a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2872,7 +2872,41 @@ void ath10k_wmi_event_phyerr(struct ath10k *ar, struct sk_buff *skb)
 
 void ath10k_wmi_event_roam(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_ROAM_EVENTID\n");
+	struct wmi_roam_ev_arg arg = {};
+	int ret;
+	u32 vdev_id;
+	u32 reason;
+	s32 rssi;
+
+	ret = ath10k_wmi_pull_roam_ev(ar, skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse roam event: %d\n", ret);
+		return;
+	}
+
+	vdev_id = __le32_to_cpu(arg.vdev_id);
+	reason = __le32_to_cpu(arg.reason);
+	rssi = __le32_to_cpu(arg.rssi);
+	rssi += WMI_SPECTRAL_NOISE_FLOOR_REF_DEFAULT;
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi roam event vdev %u reason 0x%08x rssi %d\n",
+		   vdev_id, reason, rssi);
+
+	if (reason >= WMI_ROAM_REASON_MAX)
+		ath10k_warn(ar, "ignoring unknown roam event reason %d on vdev %i\n",
+			    reason, vdev_id);
+
+	switch (reason) {
+	case WMI_ROAM_REASON_BETTER_AP:
+	case WMI_ROAM_REASON_BEACON_MISS:
+	case WMI_ROAM_REASON_LOW_RSSI:
+	case WMI_ROAM_REASON_SUITABLE_AP_FOUND:
+	case WMI_ROAM_REASON_HO_FAILED:
+		ath10k_warn(ar, "ignoring not implemented roam event reason %d on vdev %i\n",
+			    reason, vdev_id);
+		break;
+	}
 }
 
 void ath10k_wmi_event_profile_match(struct ath10k *ar, struct sk_buff *skb)
@@ -3231,6 +3265,21 @@ static int ath10k_wmi_op_pull_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
+static int ath10k_wmi_op_pull_roam_ev(struct ath10k *ar, struct sk_buff *skb,
+				      struct wmi_roam_ev_arg *arg)
+{
+	struct wmi_roam_ev *ev = (void *)skb->data;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	skb_pull(skb, sizeof(*ev));
+	arg->vdev_id = ev->vdev_id;
+	arg->reason = ev->reason;
+
+	return 0;
+}
+
 int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_rdy_ev_arg arg = {};
@@ -5223,6 +5272,7 @@ static const struct wmi_ops wmi_ops = {
 	.pull_svc_rdy = ath10k_wmi_main_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.pull_fw_stats = ath10k_wmi_main_op_pull_fw_stats,
+	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
@@ -5290,6 +5340,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.pull_swba = ath10k_wmi_op_pull_swba_ev,
 	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
+	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
@@ -5353,6 +5404,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.pull_swba = ath10k_wmi_op_pull_swba_ev,
 	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
+	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
@@ -5413,6 +5465,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.pull_swba = ath10k_wmi_op_pull_swba_ev,
 	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
+	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 28c1822..70bfb2d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4768,6 +4768,22 @@ struct wmi_dbglog_cfg_cmd {
 	__le32 config_valid;
 } __packed;
 
+enum wmi_roam_reason {
+	WMI_ROAM_REASON_BETTER_AP = 1,
+	WMI_ROAM_REASON_BEACON_MISS = 2,
+	WMI_ROAM_REASON_LOW_RSSI = 3,
+	WMI_ROAM_REASON_SUITABLE_AP_FOUND = 4,
+	WMI_ROAM_REASON_HO_FAILED = 5,
+
+	/* keep last */
+	WMI_ROAM_REASON_MAX,
+};
+
+struct wmi_roam_ev {
+	__le32 vdev_id;
+	__le32 reason;
+} __packed;
+
 #define ATH10K_FRAGMT_THRESHOLD_MIN	540
 #define ATH10K_FRAGMT_THRESHOLD_MAX	2346
 
@@ -4856,6 +4872,12 @@ struct wmi_rdy_ev_arg {
 	const u8 *mac_addr;
 };
 
+struct wmi_roam_ev_arg {
+	__le32 vdev_id;
+	__le32 reason;
+	__le32 rssi;
+};
+
 struct wmi_pdev_temperature_event {
 	/* temperature value in Celcius degree */
 	__le32 temperature;
-- 
1.8.5.3

