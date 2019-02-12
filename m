Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E79C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 12:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2082214DA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 12:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="k1duEWFi";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o42drAQ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfBLMkK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:40:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbfBLMkK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 07:40:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 65F096074F; Tue, 12 Feb 2019 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549975208;
        bh=lQsxaliQ06VLmMnb9zJAkfI/F5diRvM6rREhMb6ZZMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1duEWFihgEA72BHqxzhKrmun8jLiftPc0S4+Gb3KTcf8c/L7kV2gVsvPTOkPqo5Y
         8rPNNQTDakyRXCp3vk1FFEKr06DfbElB7Fa4TgbcTUSgrgEd1nM6Em6voZjEzfMkq1
         yWTa9Jb/v+1u3SvMYpecJKyb0VGfJFA50EkcvBdI=
Received: from aambure-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aambure@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F1FAC605FC;
        Tue, 12 Feb 2019 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549975207;
        bh=lQsxaliQ06VLmMnb9zJAkfI/F5diRvM6rREhMb6ZZMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o42drAQ/+9puhJ7qlBDpLlPypYPVdnOmHZsokW9d6x3pon7QSgQTz5cr3T8VaMS51
         TE4MKGlvC8bjeO9rXNCjlEessnciDJsPPwXSAWqyZ4bGTSt5n6/jCoYEFw+NnD+Wyf
         3I7vaQDFdfl97q3zPs3u+ce0yrLh6gvH/k+XG6CA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F1FAC605FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=aambure@codeaurora.org
From:   Abhishek Ambure <aambure@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
Subject: [PATCH v2 1/2] ath10k: Add support for ack rssi value of management tx packets
Date:   Tue, 12 Feb 2019 18:09:50 +0530
Message-Id: <1549975191-20912-2-git-send-email-aambure@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1549975191-20912-1-git-send-email-aambure@codeaurora.org>
References: <1549975191-20912-1-git-send-email-aambure@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In WCN3990, WMI_TLV_SERVICE_TX_DATA_MGMT_ACK_RSSI service Indicates that
the firmware has the capability to send the RSSI value of the ACK for all
data and management packets transmitted.

If WMI_RSRC_CFG_FLAG_TX_ACK_RSSI is set in host capability then firmware
sends RSSI value in "management" tx completion event. Host extracts ack
rssi values of management packets from their tx completion event.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1

Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
V2: Tested HW & Tested FW added
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 26 ++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 25 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 40 +++++++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/wmi.h     | 11 +++++++++
 4 files changed, 88 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 6075daf..b03ed58 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -623,6 +623,10 @@ static int ath10k_wmi_tlv_op_pull_scan_ev(struct ath10k *ar,
 	arg->desc_id = ev->desc_id;
 	arg->status = ev->status;
 	arg->pdev_id = ev->pdev_id;
+	arg->ppdu_id = ev->ppdu_id;
+
+	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
+		arg->ack_rssi = ev->ack_rssi;
 
 	kfree(tb);
 	return 0;
@@ -632,8 +636,12 @@ struct wmi_tlv_tx_bundle_compl_parse {
 	const __le32 *num_reports;
 	const __le32 *desc_ids;
 	const __le32 *status;
+	const __le32 *ppdu_ids;
+	const __le32 *ack_rssi;
 	bool desc_ids_done;
 	bool status_done;
+	bool ppdu_ids_done;
+	bool ack_rssi_done;
 };
 
 static int
@@ -653,6 +661,12 @@ struct wmi_tlv_tx_bundle_compl_parse {
 		} else if (!bundle_tx_compl->status_done) {
 			bundle_tx_compl->status_done = true;
 			bundle_tx_compl->status = ptr;
+		} else if (!bundle_tx_compl->ppdu_ids_done) {
+			bundle_tx_compl->ppdu_ids_done = true;
+			bundle_tx_compl->ppdu_ids = ptr;
+		} else if (!bundle_tx_compl->ack_rssi_done) {
+			bundle_tx_compl->ack_rssi_done = true;
+			bundle_tx_compl->ack_rssi = ptr;
 		}
 		break;
 	default:
@@ -683,6 +697,10 @@ static int ath10k_wmi_tlv_op_pull_mgmt_tx_bundle_compl_ev(
 	arg->num_reports = *bundle_tx_compl.num_reports;
 	arg->desc_ids = bundle_tx_compl.desc_ids;
 	arg->status = bundle_tx_compl.status;
+	arg->ppdu_ids = bundle_tx_compl.ppdu_ids;
+
+	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
+		arg->ack_rssi = bundle_tx_compl.ack_rssi;
 
 	return 0;
 }
@@ -1619,7 +1637,9 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->num_ocb_vdevs = __cpu_to_le32(0);
 	cfg->num_ocb_channels = __cpu_to_le32(0);
 	cfg->num_ocb_schedules = __cpu_to_le32(0);
-	cfg->host_capab = __cpu_to_le32(0);
+
+	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
+		cfg->host_capab = __cpu_to_le32(WMI_RSRC_CFG_FLAG_TX_ACK_RSSI);
 
 	ath10k_wmi_put_host_mem_chunks(ar, chunks);
 
@@ -2723,7 +2743,9 @@ static void *ath10k_wmi_tlv_put_wmm(void *ptr,
 	arvif = (void *)cb->vif->drv_priv;
 	vdev_id = arvif->vdev_id;
 
-	if (WARN_ON_ONCE(!ieee80211_is_mgmt(hdr->frame_control)))
+	if (WARN_ON_ONCE(!ieee80211_is_mgmt(hdr->frame_control) &&
+			 (!(ieee80211_is_nullfunc(hdr->frame_control) ||
+			 ieee80211_is_qos_nullfunc(hdr->frame_control)))))
 		return ERR_PTR(-EINVAL);
 
 	len = sizeof(*cmd) + 2 * sizeof(*tlv);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 7a58c76..4803fca 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -24,6 +24,8 @@
 #define WMI_TLV_VDEV_PARAM_UNSUPPORTED 0
 #define WMI_TLV_MGMT_TX_FRAME_MAX_LEN	64
 
+#define WMI_RSRC_CFG_FLAG_TX_ACK_RSSI		BIT(18)
+
 enum wmi_tlv_grp_id {
 	WMI_TLV_GRP_START = 0x3,
 	WMI_TLV_GRP_SCAN = WMI_TLV_GRP_START,
@@ -1408,6 +1410,25 @@ enum wmi_tlv_service {
 	WMI_TLV_SERVICE_AP_TWT = 153,
 	WMI_TLV_SERVICE_GMAC_OFFLOAD_SUPPORT = 154,
 	WMI_TLV_SERVICE_SPOOF_MAC_SUPPORT = 155,
+	WMI_TLV_SERVICE_PEER_TID_CONFIGS_SUPPORT = 156,
+	WMI_TLV_SERVICE_VDEV_SWRETRY_PER_AC_CONFIG_SUPPORT = 157,
+	WMI_TLV_SERVICE_DUAL_BEACON_ON_SINGLE_MAC_SCC_SUPPORT = 158,
+	WMI_TLV_SERVICE_DUAL_BEACON_ON_SINGLE_MAC_MCC_SUPPORT = 159,
+	WMI_TLV_SERVICE_MOTION_DET = 160,
+	WMI_TLV_SERVICE_INFRA_MBSSID = 161,
+	WMI_TLV_SERVICE_OBSS_SPATIAL_REUSE = 162,
+	WMI_TLV_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT = 163,
+	WMI_TLV_SERVICE_NAN_DBS_SUPPORT = 164,
+	WMI_TLV_SERVICE_NDI_DBS_SUPPORT = 165,
+	WMI_TLV_SERVICE_NAN_SAP_SUPPORT = 166,
+	WMI_TLV_SERVICE_NDI_SAP_SUPPORT = 167,
+	WMI_TLV_SERVICE_CFR_CAPTURE_SUPPORT = 168,
+	WMI_TLV_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_1 = 169,
+	WMI_TLV_SERVICE_ESP_SUPPORT = 170,
+	WMI_TLV_SERVICE_PEER_CHWIDTH_CHANGE = 171,
+	WMI_TLV_SERVICE_WLAN_HPCS_PULSE = 172,
+	WMI_TLV_SERVICE_PER_VDEV_CHAINMASK_CONFIG_SUPPORT = 173,
+	WMI_TLV_SERVICE_TX_DATA_MGMT_ACK_RSSI = 174,
 
 	WMI_TLV_MAX_EXT_SERVICE = 256,
 };
@@ -1578,6 +1599,8 @@ enum wmi_tlv_service {
 	SVCMAP(WMI_TLV_SERVICE_SPOOF_MAC_SUPPORT,
 	       WMI_SERVICE_SPOOF_MAC_SUPPORT,
 	       WMI_TLV_MAX_SERVICE);
+	SVCMAP(WMI_TLV_SERVICE_TX_DATA_MGMT_ACK_RSSI,
+	       WMI_SERVICE_TX_DATA_ACK_RSSI, WMI_TLV_MAX_SERVICE);
 }
 
 #undef SVCMAP
@@ -1607,6 +1630,8 @@ struct wmi_tlv_mgmt_tx_compl_ev {
 	__le32 desc_id;
 	__le32 status;
 	__le32 pdev_id;
+	__le32 ppdu_id;
+	__le32 ack_rssi;
 };
 
 #define WMI_TLV_MGMT_RX_NUM_RSSI 4
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2ba733f..2de8c9b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2345,8 +2345,8 @@ static bool ath10k_wmi_rx_is_decrypted(struct ath10k *ar,
 	return true;
 }
 
-static int wmi_process_mgmt_tx_comp(struct ath10k *ar, u32 desc_id,
-				    u32 status)
+static int
+wmi_process_mgmt_tx_comp(struct ath10k *ar, struct mgmt_tx_compl_params *param)
 {
 	struct ath10k_mgmt_tx_pkt_addr *pkt_addr;
 	struct ath10k_wmi *wmi = &ar->wmi;
@@ -2356,10 +2356,10 @@ static int wmi_process_mgmt_tx_comp(struct ath10k *ar, u32 desc_id,
 
 	spin_lock_bh(&ar->data_lock);
 
-	pkt_addr = idr_find(&wmi->mgmt_pending_tx, desc_id);
+	pkt_addr = idr_find(&wmi->mgmt_pending_tx, param->desc_id);
 	if (!pkt_addr) {
 		ath10k_warn(ar, "received mgmt tx completion for invalid msdu_id: %d\n",
-			    desc_id);
+			    param->desc_id);
 		ret = -ENOENT;
 		goto out;
 	}
@@ -2369,17 +2369,21 @@ static int wmi_process_mgmt_tx_comp(struct ath10k *ar, u32 desc_id,
 			 msdu->len, DMA_FROM_DEVICE);
 	info = IEEE80211_SKB_CB(msdu);
 
-	if (status)
+	if (param->status) {
 		info->flags &= ~IEEE80211_TX_STAT_ACK;
-	else
+	} else {
 		info->flags |= IEEE80211_TX_STAT_ACK;
+		info->status.ack_signal = ATH10K_DEFAULT_NOISE_FLOOR +
+					  param->ack_rssi;
+		info->status.is_valid_ack_signal = true;
+	}
 
 	ieee80211_tx_status_irqsafe(ar->hw, msdu);
 
 	ret = 0;
 
 out:
-	idr_remove(&wmi->mgmt_pending_tx, desc_id);
+	idr_remove(&wmi->mgmt_pending_tx, param->desc_id);
 	spin_unlock_bh(&ar->data_lock);
 	return ret;
 }
@@ -2387,6 +2391,7 @@ static int wmi_process_mgmt_tx_comp(struct ath10k *ar, u32 desc_id,
 int ath10k_wmi_event_mgmt_tx_compl(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_tlv_mgmt_tx_compl_ev_arg arg;
+	struct mgmt_tx_compl_params param;
 	int ret;
 
 	ret = ath10k_wmi_pull_mgmt_tx_compl(ar, skb, &arg);
@@ -2395,8 +2400,12 @@ int ath10k_wmi_event_mgmt_tx_compl(struct ath10k *ar, struct sk_buff *skb)
 		return ret;
 	}
 
-	wmi_process_mgmt_tx_comp(ar, __le32_to_cpu(arg.desc_id),
-				 __le32_to_cpu(arg.status));
+	memset(&param, 0, sizeof(struct mgmt_tx_compl_params));
+	param.desc_id = __le32_to_cpu(arg.desc_id);
+	param.status = __le32_to_cpu(arg.status);
+	param.ack_rssi = __le32_to_cpu(arg.ack_rssi);
+
+	wmi_process_mgmt_tx_comp(ar, &param);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv evnt mgmt tx completion\n");
 
@@ -2406,6 +2415,7 @@ int ath10k_wmi_event_mgmt_tx_compl(struct ath10k *ar, struct sk_buff *skb)
 int ath10k_wmi_event_mgmt_tx_bundle_compl(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_tlv_mgmt_tx_bundle_compl_ev_arg arg;
+	struct mgmt_tx_compl_params param;
 	u32 num_reports;
 	int i, ret;
 
@@ -2417,9 +2427,15 @@ int ath10k_wmi_event_mgmt_tx_bundle_compl(struct ath10k *ar, struct sk_buff *skb
 
 	num_reports = __le32_to_cpu(arg.num_reports);
 
-	for (i = 0; i < num_reports; i++)
-		wmi_process_mgmt_tx_comp(ar, __le32_to_cpu(arg.desc_ids[i]),
-					 __le32_to_cpu(arg.status[i]));
+	for (i = 0; i < num_reports; i++) {
+		memset(&param, 0, sizeof(struct mgmt_tx_compl_params));
+		param.desc_id = __le32_to_cpu(arg.desc_ids[i]);
+		param.status = __le32_to_cpu(arg.desc_ids[i]);
+
+		if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
+			param.ack_rssi = __le32_to_cpu(arg.ack_rssi[i]);
+		wmi_process_mgmt_tx_comp(ar, &param);
+	}
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv event bundle mgmt tx completion\n");
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 25bb04b..7a50ad6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6708,16 +6708,27 @@ struct wmi_scan_ev_arg {
 	__le32 vdev_id;
 };
 
+struct mgmt_tx_compl_params {
+	u32 desc_id;
+	u32 status;
+	u32 ppdu_id;
+	int ack_rssi;
+};
+
 struct wmi_tlv_mgmt_tx_compl_ev_arg {
 	__le32 desc_id;
 	__le32 status;
 	__le32 pdev_id;
+	__le32 ppdu_id;
+	__le32 ack_rssi;
 };
 
 struct wmi_tlv_mgmt_tx_bundle_compl_ev_arg {
 	__le32 num_reports;
 	const __le32 *desc_ids;
 	const __le32 *status;
+	const __le32 *ppdu_ids;
+	const __le32 *ack_rssi;
 };
 
 struct wmi_mgmt_rx_ev_arg {
-- 
1.9.1

