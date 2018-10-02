Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F861C004D2
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 18:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE55F2082A
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 18:04:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UyBCqR8M";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XGsJw6Ib"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE55F2082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbeJCAsf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 20:48:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57142 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbeJCAsf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 20:48:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6BF9960C4F; Tue,  2 Oct 2018 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538503438;
        bh=xb7vgrkeH0nFWwjSvXFpAM+nyJfqsjn2kMwp/r7X/J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyBCqR8MtQb6RnWJZAGrPHdl+97qYJHZeE3fPa3bz4jHhpmgmoOlyB4+8WvKXeACn
         DxQdnEYFFfXx4vbGUZbB8kUIuvLRFDgAd4vR6t0YaO/eRwxYbxSXv4Mhz8CIAdSG/K
         VvKX+fmW+QqitX1RpDHiSMC5YM6YjfuNjYIRktUY=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5962660C1D;
        Tue,  2 Oct 2018 18:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538503437;
        bh=xb7vgrkeH0nFWwjSvXFpAM+nyJfqsjn2kMwp/r7X/J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGsJw6IbvVp3I/oBFMwwZ/cBk/6Z9QT+oREBmnOVp5Fz16Sbh9r0CIMFOvdw2Exti
         lDFdWRe9UAfnRVYiXHWMfJDUMUx7WoZ5/yXDCmAxmkXC6uj+GM94Bqm4IqMBRY4zVW
         W+3tqCtxHBIQsfw9niYvhGiE6RPSW1BhJyI+zvi8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5962660C1D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Handle bundled tx completion for managenent frames
Date:   Tue,  2 Oct 2018 23:33:40 +0530
Message-Id: <1538503421-17607-2-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1538503421-17607-1-git-send-email-pillair@codeaurora.org>
References: <1538503421-17607-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 supports sending tx completion for multiple
management frames bundled together in a single event.

Add support to handle the bundled tx completion
event for WCN3990.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 13 +++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 63 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c     | 26 +++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  7 ++++
 5 files changed, 110 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 7fd63bb..b460993 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -33,6 +33,9 @@ struct wmi_ops {
 			    struct wmi_mgmt_rx_ev_arg *arg);
 	int (*pull_mgmt_tx_compl)(struct ath10k *ar, struct sk_buff *skb,
 				  struct wmi_tlv_mgmt_tx_compl_ev_arg *arg);
+	int (*pull_mgmt_tx_bundle_compl)(
+				struct ath10k *ar, struct sk_buff *skb,
+				struct wmi_tlv_mgmt_tx_bundle_compl_ev_arg *arg);
 	int (*pull_ch_info)(struct ath10k *ar, struct sk_buff *skb,
 			    struct wmi_ch_info_ev_arg *arg);
 	int (*pull_vdev_start)(struct ath10k *ar, struct sk_buff *skb,
@@ -274,6 +277,16 @@ ath10k_wmi_pull_mgmt_tx_compl(struct ath10k *ar, struct sk_buff *skb,
 }
 
 static inline int
+ath10k_wmi_pull_mgmt_tx_bundle_compl(struct ath10k *ar, struct sk_buff *skb,
+				     struct wmi_tlv_mgmt_tx_bundle_compl_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_mgmt_tx_bundle_compl)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_mgmt_tx_bundle_compl(ar, skb, arg);
+}
+
+static inline int
 ath10k_wmi_pull_mgmt_rx(struct ath10k *ar, struct sk_buff *skb,
 			struct wmi_mgmt_rx_ev_arg *arg)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 731ceae..f7d4f01 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -620,6 +620,9 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TLV_MGMT_TX_COMPLETION_EVENTID:
 		ath10k_wmi_event_mgmt_tx_compl(ar, skb);
 		break;
+	case WMI_TLV_MGMT_TX_BUNDLE_COMPLETION_EVENTID:
+		ath10k_wmi_event_mgmt_tx_bundle_compl(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
@@ -686,6 +689,65 @@ ath10k_wmi_tlv_op_pull_mgmt_tx_compl_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
+struct wmi_tlv_tx_bundle_compl_parse {
+	const __le32 *num_reports;
+	const __le32 *desc_ids;
+	const __le32 *status;
+	bool desc_ids_done;
+	bool status_done;
+};
+
+static int
+ath10k_wmi_tlv_mgmt_tx_bundle_compl_parse(struct ath10k *ar, u16 tag, u16 len,
+					  const void *ptr, void *data)
+{
+	struct wmi_tlv_tx_bundle_compl_parse *bundle_tx_compl = data;
+
+	switch (tag) {
+	case WMI_TLV_TAG_STRUCT_MGMT_TX_COMPL_BUNDLE_EVENT:
+		bundle_tx_compl->num_reports = ptr;
+		break;
+	case WMI_TLV_TAG_ARRAY_UINT32:
+		if (!bundle_tx_compl->desc_ids_done) {
+			bundle_tx_compl->desc_ids_done = true;
+			bundle_tx_compl->desc_ids = ptr;
+		} else if (!bundle_tx_compl->status_done) {
+			bundle_tx_compl->status_done = true;
+			bundle_tx_compl->status = ptr;
+		}
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static int ath10k_wmi_tlv_op_pull_mgmt_tx_bundle_compl_ev(
+				struct ath10k *ar, struct sk_buff *skb,
+				struct wmi_tlv_mgmt_tx_bundle_compl_ev_arg *arg)
+{
+	struct wmi_tlv_tx_bundle_compl_parse bundle_tx_compl = { };
+	int ret;
+
+	ret = ath10k_wmi_tlv_iter(ar, skb->data, skb->len,
+				  ath10k_wmi_tlv_mgmt_tx_bundle_compl_parse,
+				  &bundle_tx_compl);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
+		return ret;
+	}
+
+	if (!bundle_tx_compl.num_reports || !bundle_tx_compl.desc_ids ||
+	    !bundle_tx_compl.status)
+		return -EPROTO;
+
+	arg->num_reports = __le32_to_cpu(*bundle_tx_compl.num_reports);
+	arg->desc_ids = (__le32 *)bundle_tx_compl.desc_ids;
+	arg->status = (__le32 *)bundle_tx_compl.status;
+
+	return 0;
+}
+
 static int ath10k_wmi_tlv_op_pull_mgmt_rx_ev(struct ath10k *ar,
 					     struct sk_buff *skb,
 					     struct wmi_mgmt_rx_ev_arg *arg)
@@ -3907,6 +3969,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.pull_scan = ath10k_wmi_tlv_op_pull_scan_ev,
 	.pull_mgmt_rx = ath10k_wmi_tlv_op_pull_mgmt_rx_ev,
 	.pull_mgmt_tx_compl = ath10k_wmi_tlv_op_pull_mgmt_tx_compl_ev,
+	.pull_mgmt_tx_bundle_compl = ath10k_wmi_tlv_op_pull_mgmt_tx_bundle_compl_ev,
 	.pull_ch_info = ath10k_wmi_tlv_op_pull_ch_info_ev,
 	.pull_vdev_start = ath10k_wmi_tlv_op_pull_vdev_start_ev,
 	.pull_peer_kick = ath10k_wmi_tlv_op_pull_peer_kick_ev,
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 4f0c20c..c575921 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -321,6 +321,7 @@ enum wmi_tlv_event_id {
 	WMI_TLV_OFFLOAD_BCN_TX_STATUS_EVENTID,
 	WMI_TLV_OFFLOAD_PROB_RESP_TX_STATUS_EVENTID,
 	WMI_TLV_MGMT_TX_COMPLETION_EVENTID,
+	WMI_TLV_MGMT_TX_BUNDLE_COMPLETION_EVENTID,
 	WMI_TLV_TX_DELBA_COMPLETE_EVENTID = WMI_TLV_EV(WMI_TLV_GRP_BA_NEG),
 	WMI_TLV_TX_ADDBA_COMPLETE_EVENTID,
 	WMI_TLV_BA_RSP_SSN_EVENTID,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 25e8fa7..8f62a85 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2378,6 +2378,32 @@ int ath10k_wmi_event_mgmt_tx_compl(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
+int ath10k_wmi_event_mgmt_tx_bundle_compl(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct wmi_tlv_mgmt_tx_bundle_compl_ev_arg arg;
+	u32 *desc_ids, *status;
+	u32 num_reports;
+	int i, ret;
+
+	ret = ath10k_wmi_pull_mgmt_tx_bundle_compl(ar, skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse bundle mgmt compl event: %d\n", ret);
+		return ret;
+	}
+
+	num_reports = __le32_to_cpu(arg.num_reports);
+	desc_ids = (u32 *)arg.desc_ids;
+	status = (u32 *)arg.status;
+
+	for (i = 0; i < num_reports; i++)
+		wmi_process_mgmt_tx_comp(ar, __le32_to_cpu(desc_ids[i]),
+					 __le32_to_cpu(status[i]));
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv event bundle mgmt tx completion\n");
+
+	return 0;
+}
+
 int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_mgmt_rx_ev_arg arg = {};
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index f67c527..1287687 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6649,6 +6649,12 @@ struct wmi_tlv_mgmt_tx_compl_ev_arg {
 	__le32 pdev_id;
 };
 
+struct wmi_tlv_mgmt_tx_bundle_compl_ev_arg {
+	__le32 num_reports;
+	__le32 *desc_ids;
+	__le32 *status;
+};
+
 struct wmi_mgmt_rx_ev_arg {
 	__le32 channel;
 	__le32 snr;
@@ -7127,6 +7133,7 @@ int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg);
 int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_event_mgmt_tx_compl(struct ath10k *ar, struct sk_buff *skb);
+int ath10k_wmi_event_mgmt_tx_bundle_compl(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb);
-- 
2.7.4

