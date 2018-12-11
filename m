Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F86C07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 05:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46AD2054F
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 05:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jmC7jOl4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eB6InnYq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A46AD2054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbeLKFE4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 00:04:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44570 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbeLKFE4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 00:04:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2726C60795; Tue, 11 Dec 2018 05:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544504695;
        bh=nR0od2JpPE9vz2BzKjGTmfUhzvZVVwJop3NwPmzBd9A=;
        h=From:To:Cc:Subject:Date:From;
        b=jmC7jOl4JZs2xlNWcLNE+rZBGTBqLnl4Kk7AtxT9hd4xXBF5lqefguRVzVIHipNKL
         MTAGyf/OhKso6cvjrzJVNRuay1RSGtDmaifSbYhQrKZsaWwjwwMFVlvQYVoS1TEJZ3
         6oyFya19mVAA9fHjaFtXvBXQy4tre+yL0/UW5UuI=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3C7F6019F;
        Tue, 11 Dec 2018 05:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544504694;
        bh=nR0od2JpPE9vz2BzKjGTmfUhzvZVVwJop3NwPmzBd9A=;
        h=From:To:Cc:Subject:Date:From;
        b=eB6InnYq81osqkuhtJs9w3tlY2eq99iz20KwZ2IBpDEDhqIAq/x4s4HB0VQBgbe4J
         N842MnGqp9uJGxJ14DAIh8hVfulInDFm7fM+J+DKrgKq+3U5gyKlTVgRML1/Vpco6y
         GMq97fT0N5Qbwv6HfwoYcgyUC2zZkZLH/1gY4xy0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D3C7F6019F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH] ath10k: Add support to provide higher range mem chunks in wmi init command
Date:   Tue, 11 Dec 2018 10:34:35 +0530
Message-Id: <1544504675-6905-1-git-send-email-svishnoi@codeaurora.org>
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
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 26 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  3 +++
 3 files changed, 35 insertions(+)

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
index bf8a432..d3f1bd0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1394,6 +1394,27 @@ enum wmi_tlv_service {
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
+	WMI_TLV_SERVICE_SUPPORT_EXTEND_ADDRESS = 176,
 
 	WMI_TLV_MAX_EXT_SERVICE = 256,
 };
@@ -1564,6 +1585,11 @@ enum wmi_tlv_service {
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

