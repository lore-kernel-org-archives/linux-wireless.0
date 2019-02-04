Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1D0C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 11:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE2F4207E0
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 11:56:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NNrQbTAI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UUyt+RDw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfBDL4G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 06:56:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53758 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbfBDL4G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 06:56:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E8BA760886; Mon,  4 Feb 2019 11:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549281364;
        bh=DqMToW/l2NlXAEvcvXcxNGVL7kYyaSqEiO2p96NGpwE=;
        h=From:To:Cc:Subject:Date:From;
        b=NNrQbTAIRXacUs7N3/jRmlfdZPvnqz3Fw0rTzH4CNrqkxMVR8kRt8Di1KAYw7nwJH
         l7MPsnb4JR5MXS/gw/N6If2TOFI3hZ6qhII3oloi6mYZJerKiialE9AXZHk0BlMyY2
         a5gQBHOf3rKO/RxkkQnxZ/NS2s9j2NizelA3G5y4=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7104860721;
        Mon,  4 Feb 2019 11:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549281363;
        bh=DqMToW/l2NlXAEvcvXcxNGVL7kYyaSqEiO2p96NGpwE=;
        h=From:To:Cc:Subject:Date:From;
        b=UUyt+RDw1bIVmQ/dHL69kKoh3sbC9q366Vb0HxnDougIFQq2574NNnUmTPdBBQdV2
         /iugb7Z1+N7VgYeHIFbeamNMZ8JDLrNWc0E3zAAa6h6t3C2f+RNw4m6WCPoigIXfqH
         HrptvoGIhxn+/sFJGjOZs4tA+YBxsO1o0MLWEsyE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7104860721
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 1/1] ath10k: update HOST capability qmi message
Date:   Mon,  4 Feb 2019 17:25:55 +0530
Message-Id: <20190204115555.17052-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

HOST capability interface data structures are updated
in HL3.1 fw version. Update the qmi host capability
members for compatibility across different firmware
versions.
Since this change breaks backward compatibility with
HL2.0 fw, HL2.0 fw upgrade to WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1
or later version is required.

Testing:
        Tested on QCS404 platform(WCN3990 HW).
        Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1,
                   WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1
---
 .../net/wireless/ath/ath10k/qmi_wlfw_v01.c    | 229 +++++++++++++++++-
 .../net/wireless/ath/ath10k/qmi_wlfw_v01.h    |  34 ++-
 2 files changed, 257 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
index ba79c2e4aed6..4102f7b0b5c3 100644
--- a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
+++ b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
@@ -1763,14 +1763,239 @@ struct qmi_elem_info wlfw_host_cap_req_msg_v01_ei[] = {
 					   daemon_support_valid),
 	},
 	{
-		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.data_type      = QMI_UNSIGNED_4_BYTE,
 		.elem_len       = 1,
-		.elem_size      = sizeof(u8),
+		.elem_size      = sizeof(u32),
 		.array_type     = NO_ARRAY,
 		.tlv_type       = 0x10,
 		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
 					   daemon_support),
 	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x11,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   wake_msi_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_4_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u32),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x11,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   wake_msi),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x12,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   gpios_valid),
+	},
+	{
+		.data_type      = QMI_DATA_LEN,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u32),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x12,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   gpios_len),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_4_BYTE,
+		.elem_len       = QMI_WLFW_MAX_NUM_GPIO_V01,
+		.elem_size      = sizeof(u32),
+		.array_type     = VAR_LEN_ARRAY,
+		.tlv_type       = 0x12,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   gpios),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x13,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   nm_modem_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x13,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   nm_modem),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x14,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   bdf_support_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x14,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   bdf_support),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x15,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   bdf_cache_support_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x15,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   bdf_cache_support),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x16,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   m3_support_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x16,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   m3_support),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x17,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   m3_cache_support_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x17,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   m3_cache_support),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x18,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   cal_filesys_support_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x18,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   cal_filesys_support),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x19,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   cal_cache_support_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x19,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   cal_cache_support),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x1A,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   cal_done_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x1A,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   cal_done),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x1B,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   mem_bucket_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_4_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u32),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x1B,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   mem_bucket),
+	},
+	{
+		.data_type      = QMI_OPT_FLAG,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x1C,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   mem_cfg_mode_valid),
+	},
+	{
+		.data_type      = QMI_UNSIGNED_1_BYTE,
+		.elem_len       = 1,
+		.elem_size      = sizeof(u8),
+		.array_type     = NO_ARRAY,
+		.tlv_type       = 0x1C,
+		.offset         = offsetof(struct wlfw_host_cap_req_msg_v01,
+					   mem_cfg_mode),
+	},
 	{}
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
index c5e3870b8871..ff668f5d8afd 100644
--- a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
+++ b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
@@ -553,12 +553,38 @@ struct wlfw_mac_addr_resp_msg_v01 {
 #define WLFW_MAC_ADDR_RESP_MSG_V01_MAX_MSG_LEN 7
 extern struct qmi_elem_info wlfw_mac_addr_resp_msg_v01_ei[];
 
+#define QMI_WLFW_MAX_NUM_GPIO_V01 32
 struct wlfw_host_cap_req_msg_v01 {
 	u8 daemon_support_valid;
-	u8 daemon_support;
-};
-
-#define WLFW_HOST_CAP_REQ_MSG_V01_MAX_MSG_LEN 4
+	u32 daemon_support;
+	u8 wake_msi_valid;
+	u32 wake_msi;
+	u8 gpios_valid;
+	u32 gpios_len;
+	u32 gpios[QMI_WLFW_MAX_NUM_GPIO_V01];
+	u8 nm_modem_valid;
+	u8 nm_modem;
+	u8 bdf_support_valid;
+	u8 bdf_support;
+	u8 bdf_cache_support_valid;
+	u8 bdf_cache_support;
+	u8 m3_support_valid;
+	u8 m3_support;
+	u8 m3_cache_support_valid;
+	u8 m3_cache_support;
+	u8 cal_filesys_support_valid;
+	u8 cal_filesys_support;
+	u8 cal_cache_support_valid;
+	u8 cal_cache_support;
+	u8 cal_done_valid;
+	u8 cal_done;
+	u8 mem_bucket_valid;
+	u32 mem_bucket;
+	u8 mem_cfg_mode_valid;
+	u8 mem_cfg_mode;
+};
+
+#define WLFW_HOST_CAP_REQ_MSG_V01_MAX_MSG_LEN 189
 extern struct qmi_elem_info wlfw_host_cap_req_msg_v01_ei[];
 
 struct wlfw_host_cap_resp_msg_v01 {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

