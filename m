Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977B6C07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 10:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F4F82082F
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 10:39:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X2DPxta7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CzuP93Sk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F4F82082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbeLKKjN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 05:39:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48984 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbeLKKjM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 05:39:12 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9BE7B607DC; Tue, 11 Dec 2018 10:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544524751;
        bh=HRL9BU9jFYGXAARdzOTO8VTyuTS1q4CazJuDiJ7AjOs=;
        h=From:To:Cc:Subject:Date:From;
        b=X2DPxta78c4lCxeLXS6NIFIunIFr2QBYIEL8I5jt2olSPUVutCAJumWtnXPBYypup
         2CCJLZCwOH+t3imCJPioUFn0M6YGxWIfguY9DYwR8HIecifDwlbOJubsf/jr8GPsXs
         yrv3VBNwTPrZctLilPhGbUjmF7+zkXfStMCvW/yM=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 54E9B601B4;
        Tue, 11 Dec 2018 10:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544524750;
        bh=HRL9BU9jFYGXAARdzOTO8VTyuTS1q4CazJuDiJ7AjOs=;
        h=From:To:Cc:Subject:Date:From;
        b=CzuP93SkpKUR3hoT+aOh4t2gfq8dpFW0iZYpJtr96YRIzcX3tZVPO60tAJJRz9JA1
         rTpqvn/cK/ABsBaklthIeaMzoPFG1WwWKrnazFiEGeaP4k0g4aO2xGbCwMSeYWIZuP
         Y9fu6WhIH42pC1cHvN4cwifz+EaqIwWO/G3i/Aik=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 54E9B601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH v2] ath10k: Add support to provide higher range mem chunks in wmi init command
Date:   Tue, 11 Dec 2018 16:09:00 +0530
Message-Id: <1544524740-31372-1-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

With the current implementation of wmi init command,
there is no provision for the host driver to provide mem
chunks addresses with more than 32-bit, to the firmware.
WCN3990 is a 35-bit target and can accept mem chunks addresses
which are above 32-bit.

If firmware supports address range more than 32 bit, it
advertises the support by setting the WMI_SERVICE_EXTEND_ADDRESS
service. Based on this service fill the upper bits of paddr while
providing the mem chunks in the wmi init command.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01552-QCAHLSWMTPL-1

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  6 ++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  3 +++
 3 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 64e856c..57d1f01 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1538,6 +1538,12 @@ static enum wmi_txbf_conf ath10k_wmi_tlv_txbf_conf_scheme(struct ath10k *ar)
 		chunk->size = __cpu_to_le32(ar->wmi.mem_chunks[i].len);
 		chunk->req_id = __cpu_to_le32(ar->wmi.mem_chunks[i].req_id);
 
+		if (test_bit(WMI_SERVICE_SUPPORT_EXTEND_ADDRESS,
+			     ar->wmi.svc_map))
+			chunk->ptr_high = __cpu_to_le32
+					 (upper_32_bits
+					 (ar->wmi.mem_chunks[i].paddr));
+
 		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "wmi-tlv chunk %d len %d, addr 0x%llx, id 0x%x\n",
 			   i,
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index bf8a432..51e7aaa 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1394,6 +1394,30 @@ enum wmi_tlv_service {
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
+	WMI_TLV_SERVICE_NAN_DISABLE_SUPPORT = 175,
+	WMI_TLV_SERVICE_HTT_H2T_NO_HTC_HDR_LEN_IN_MSG_LEN = 176,
+	WMI_TLV_SERVICE_COEX_SUPPORT_UNEQUAL_ISOLATION = 177,
+	WMI_TLV_SERVICE_HW_DB2DBM_CONVERSION_SUPPORT = 178,
+	WMI_TLV_SERVICE_SUPPORT_EXTEND_ADDRESS = 179,
 
 	WMI_TLV_MAX_EXT_SERVICE = 256,
 };
@@ -1564,6 +1588,11 @@ enum wmi_tlv_service {
 	SVCMAP(WMI_TLV_SERVICE_SPOOF_MAC_SUPPORT,
 	       WMI_SERVICE_SPOOF_MAC_SUPPORT,
 	       WMI_TLV_MAX_SERVICE);
+
+	SVCMAP(WMI_TLV_SERVICE_SUPPORT_EXTEND_ADDRESS,
+	       WMI_SERVICE_SUPPORT_EXTEND_ADDRESS,
+	       WMI_TLV_MAX_SERVICE);
+
 }
 
 #undef SVCMAP
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 58e33ab..ec2bfcf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -205,6 +205,7 @@ enum wmi_service {
 	WMI_SERVICE_SPOOF_MAC_SUPPORT,
 	WMI_SERVICE_TX_DATA_ACK_RSSI,
 	WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+	WMI_SERVICE_SUPPORT_EXTEND_ADDRESS,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -2990,6 +2991,8 @@ struct host_memory_chunk {
 	__le32 ptr;
 	/* size of the chunk */
 	__le32 size;
+	/* the upper 32 bit address valid only for more than 32 bit target */
+	__le32 ptr_high;
 } __packed;
 
 struct wmi_host_mem_chunks {
-- 
1.9.1

