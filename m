Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087DFC282DC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8C9B2073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:32:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LJUeq/tS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QqHyItOn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbfDQIcZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 04:32:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731341AbfDQIcY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 04:32:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 023146032C; Wed, 17 Apr 2019 08:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555489943;
        bh=KIyEOE1q3E40iBxvgWxRBztREeTWHQ1QwUsuISPgbrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJUeq/tSKaV+jjwDbYwyKdlPN7TeUCn9LDYIK5Ht8KEjKZmRMULRmo9idyXdN0rlH
         2GXxx8ajpCXuXRPfRtZdrfpgDfqs+LXy0uFHMj6fi4zOrpMzmGv9u8cRX0YrNuSCT7
         j9S7VnECmqRRTVXZgNql+SKJAHJDle7+lssQRlu4=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3A1D61515;
        Wed, 17 Apr 2019 08:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555489933;
        bh=KIyEOE1q3E40iBxvgWxRBztREeTWHQ1QwUsuISPgbrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqHyItOnbZ6/XicXiMIJHvicekr+9Ii0a8rdC6+KZAJxxMODe8qtIKX3JGT5epfJe
         /1oQny0WFL61QDPUN33jomN8swB+Y1LcS0jvwyG5a0VZsbWEnF/bNFf61SSB5SGohm
         Nav+/CC3NgtN1cc6x7N4YB2feRw+q61dCS4ewrzo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D3A1D61515
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 1/3] ath10k: Add wmi tlv vdev subtype for mesh in WCN3990
Date:   Wed, 17 Apr 2019 14:01:45 +0530
Message-Id: <1555489907-30117-2-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1555489907-30117-1-git-send-email-svishnoi@codeaurora.org>
References: <1555489907-30117-1-git-send-email-svishnoi@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is a disparity in wmi and wmi tlv vdev subtype
enum for WMI_VDEV_SUBTYPE_MESH_11S.

Add different enum for wmi tlv vdev subtype to support
vdev of subtype mesh 11s for WCN3990.

Tested HW: WCN3990

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 24 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 10 ++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 582fb11..a19f7e2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1905,6 +1905,28 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	return skb;
 }
 
+static int ath10k_wmi_tlv_op_get_vdev_subtype(struct ath10k *ar,
+					      enum wmi_vdev_subtype subtype)
+{
+	switch (subtype) {
+	case WMI_VDEV_SUBTYPE_NONE:
+		return WMI_TLV_VDEV_SUBTYPE_NONE;
+	case WMI_VDEV_SUBTYPE_P2P_DEVICE:
+		return WMI_TLV_VDEV_SUBTYPE_P2P_DEV;
+	case WMI_VDEV_SUBTYPE_P2P_CLIENT:
+		return WMI_TLV_VDEV_SUBTYPE_P2P_CLI;
+	case WMI_VDEV_SUBTYPE_P2P_GO:
+		return WMI_TLV_VDEV_SUBTYPE_P2P_GO;
+	case WMI_VDEV_SUBTYPE_PROXY_STA:
+		return WMI_TLV_VDEV_SUBTYPE_PROXY_STA;
+	case WMI_VDEV_SUBTYPE_MESH_11S:
+		return WMI_TLV_VDEV_SUBTYPE_MESH_11S;
+	case WMI_VDEV_SUBTYPE_MESH_NON_11S:
+		return -ENOTSUPP;
+	}
+	return -ENOTSUPP;
+}
+
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_vdev_create(struct ath10k *ar,
 				  u32 vdev_id,
@@ -4305,7 +4327,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_config_pno_stop(struct ath10k *ar,
 	.gen_tdls_peer_update = ath10k_wmi_tlv_op_gen_tdls_peer_update,
 	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
 	.fw_stats_fill = ath10k_wmi_main_op_fw_stats_fill,
-	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
+	.get_vdev_subtype = ath10k_wmi_tlv_op_get_vdev_subtype,
 	.gen_echo = ath10k_wmi_tlv_op_gen_echo,
 	.gen_vdev_spectral_conf = ath10k_wmi_tlv_op_gen_vdev_spectral_conf,
 	.gen_vdev_spectral_enable = ath10k_wmi_tlv_op_gen_vdev_spectral_enable,
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 65e6aa5..55da01f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1775,6 +1775,16 @@ struct wmi_tlv_start_scan_cmd {
 	struct wmi_mac_addr mac_mask;
 } __packed;
 
+enum wmi_tlv_vdev_subtype {
+	WMI_TLV_VDEV_SUBTYPE_NONE	= 0,
+	WMI_TLV_VDEV_SUBTYPE_P2P_DEV	= 1,
+	WMI_TLV_VDEV_SUBTYPE_P2P_CLI	= 2,
+	WMI_TLV_VDEV_SUBTYPE_P2P_GO	= 3,
+	WMI_TLV_VDEV_SUBTYPE_PROXY_STA	= 4,
+	WMI_TLV_VDEV_SUBTYPE_MESH	= 5,
+	WMI_TLV_VDEV_SUBTYPE_MESH_11S	= 6,
+};
+
 struct wmi_tlv_vdev_start_cmd {
 	__le32 vdev_id;
 	__le32 requestor_id;
-- 
1.9.1

