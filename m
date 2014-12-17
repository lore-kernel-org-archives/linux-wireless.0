Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34479 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaLQPWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 10:22:16 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so16131375wiv.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 07:22:15 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/5] ath10k: implement new beacon tx status event
Date: Wed, 17 Dec 2014 16:21:47 +0100
Message-Id: <1418829711-19713-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20141217_162220_464817_3E2F6731)
In-Reply-To: <1418829711-19713-1-git-send-email-bartosz.markowski@tieto.com>
References: <1418829711-19713-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

This event is delivered to host by firmware if it
supports beacon templates only.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 50 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 12 ++++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 1627ec5..0f7a3ae 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -58,6 +58,8 @@ static const struct wmi_tlv_policy wmi_tlv_policies[] = {
 		= { .min_len = sizeof(struct wlan_host_mem_req) },
 	[WMI_TLV_TAG_STRUCT_READY_EVENT]
 		= { .min_len = sizeof(struct wmi_tlv_rdy_ev) },
+	[WMI_TLV_TAG_STRUCT_OFFLOAD_BCN_TX_STATUS_EVENT]
+		= { .min_len = sizeof(struct wmi_tlv_bcn_tx_status_ev) },
 };
 
 static int
@@ -156,6 +158,51 @@ static u16 ath10k_wmi_tlv_len(const void *ptr)
 	return __le16_to_cpu((((const struct wmi_tlv *)ptr) - 1)->len);
 }
 
+/**************/
+/* TLV events */
+/**************/
+static int ath10k_wmi_tlv_event_bcn_tx_status(struct ath10k *ar,
+					      struct sk_buff *skb)
+{
+	const void **tb;
+	const struct wmi_tlv_bcn_tx_status_ev *ev;
+	u32 vdev_id, tx_status;
+	int ret;
+
+	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ret = PTR_ERR(tb);
+		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
+		return ret;
+	}
+
+	ev = tb[WMI_TLV_TAG_STRUCT_OFFLOAD_BCN_TX_STATUS_EVENT];
+	if (!ev) {
+		kfree(tb);
+		return -EPROTO;
+	}
+
+	tx_status = __le32_to_cpu(ev->tx_status);
+	vdev_id = __le32_to_cpu(ev->vdev_id);
+
+	switch (tx_status) {
+	case WMI_TLV_BCN_TX_STATUS_OK:
+		break;
+	case WMI_TLV_BCN_TX_STATUS_XRETRY:
+	case WMI_TLV_BCN_TX_STATUS_DROP:
+	case WMI_TLV_BCN_TX_STATUS_FILTERED:
+		/* FIXME: It's probably worth telling mac80211 to stop the
+		 * interface as it is crippled.
+		 */
+		ath10k_warn(ar, "received bcn tmpl tx status on vdev %i: %d",
+			    vdev_id, tx_status);
+		break;
+	}
+
+	kfree(tb);
+	return 0;
+}
+
 /***********/
 /* TLV ops */
 /***********/
@@ -268,6 +315,9 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TLV_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
 		break;
+	case WMI_TLV_OFFLOAD_BCN_TX_STATUS_EVENTID:
+		ath10k_wmi_tlv_event_bcn_tx_status(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 54ffa12..ee19353 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1375,6 +1375,18 @@ struct wmi_tlv_pktlog_disable {
 	__le32 reserved;
 } __packed;
 
+enum wmi_tlv_bcn_tx_status {
+	WMI_TLV_BCN_TX_STATUS_OK,
+	WMI_TLV_BCN_TX_STATUS_XRETRY,
+	WMI_TLV_BCN_TX_STATUS_DROP,
+	WMI_TLV_BCN_TX_STATUS_FILTERED,
+};
+
+struct wmi_tlv_bcn_tx_status_ev {
+	__le32 vdev_id;
+	__le32 tx_status;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
-- 
1.8.2

