Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E73FC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 06:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 063A4206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 06:03:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="goijiLqw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="goijiLqw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 063A4206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbeJLNeQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 09:34:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38348 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbeJLNeP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 09:34:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BE28360C72; Fri, 12 Oct 2018 06:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539324205;
        bh=FqaoSBWvfkfNpaqEdxtYbB33p87DCux4QmKZ4iVv7cI=;
        h=From:To:Cc:Subject:Date:From;
        b=goijiLqwvhWYQD+Hv6mlE4s6mDf2uTwlDeT4Qy0Jw1YHCCJtHmjX6pcJth/rn2a16
         H2qkSBKMplVBPBMKrqjHrR69c5qW/ptSjd0f/JI3kb4onaJuzbjD2xy4onjEUWofIt
         dmJsCFpbS6D0l9kPADLtvgDbW+Di+ucTJ/5xHvFE=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: akolli@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 591786072E;
        Fri, 12 Oct 2018 06:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539324205;
        bh=FqaoSBWvfkfNpaqEdxtYbB33p87DCux4QmKZ4iVv7cI=;
        h=From:To:Cc:Subject:Date:From;
        b=goijiLqwvhWYQD+Hv6mlE4s6mDf2uTwlDeT4Qy0Jw1YHCCJtHmjX6pcJth/rn2a16
         H2qkSBKMplVBPBMKrqjHrR69c5qW/ptSjd0f/JI3kb4onaJuzbjD2xy4onjEUWofIt
         dmJsCFpbS6D0l9kPADLtvgDbW+Di+ucTJ/5xHvFE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 591786072E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=akolli@codeaurora.org
From:   Anilkumar Kolli <akolli@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Add memory dump support for QCA4019
Date:   Fri, 12 Oct 2018 11:36:36 +0530
Message-Id: <1539324397-10597-1-git-send-email-akolli@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch adds firmware crash memory dump support for QCA4019.

Tested on:

QCA4019 firmware 10.4-3.2.1.1-00017

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/coredump.c |  103 +++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 4d28063052fe..1ccc73c6ef12 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -867,6 +867,101 @@
 	},
 };
 
+static const struct ath10k_mem_section ipq4019_soc_reg_range[] = {
+	{0x080000, 0x080004},
+	{0x080020, 0x080024},
+	{0x080028, 0x080050},
+	{0x0800d4, 0x0800ec},
+	{0x08010c, 0x080118},
+	{0x080284, 0x080290},
+	{0x0802a8, 0x0802b8},
+	{0x0802dc, 0x08030c},
+	{0x082000, 0x083fff}
+};
+
+static const struct ath10k_mem_region qca4019_hw10_mem_regions[] = {
+	{
+		.type = ATH10K_MEM_REGION_TYPE_DRAM,
+		.start = 0x400000,
+		.len = 0x68000,
+		.name = "DRAM",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_REG,
+		.start = 0xC0000,
+		.len = 0x40000,
+		.name = "SRAM",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_REG,
+		.start = 0x98000,
+		.len = 0x50000,
+		.name = "IRAM",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_IOREG,
+		.start = 0x30000,
+		.len = 0x7000,
+		.name = "APB REG 1",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_IOREG,
+		.start = 0x3f000,
+		.len = 0x3000,
+		.name = "APB REG 2",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_IOREG,
+		.start = 0x43000,
+		.len = 0x3000,
+		.name = "WIFI REG",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_IOREG,
+		.start = 0x4A000,
+		.len = 0x5000,
+		.name = "CE REG",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_REG,
+		.start = 0x080000,
+		.len = 0x083fff - 0x080000,
+		.name = "REG_TOTAL",
+		.section_table = {
+			.sections = ipq4019_soc_reg_range,
+			.size = ARRAY_SIZE(ipq4019_soc_reg_range),
+		},
+	},
+};
+
 static const struct ath10k_hw_mem_layout hw_mem_layouts[] = {
 	{
 		.hw_id = QCA6174_HW_1_0_VERSION,
@@ -945,7 +1040,13 @@
 			.size = ARRAY_SIZE(qca99x0_hw20_mem_regions),
 		},
 	},
-
+	{
+		.hw_id = QCA4019_HW_1_0_DEV_VERSION,
+		.region_table = {
+			.regions = qca4019_hw10_mem_regions,
+			.size = ARRAY_SIZE(qca4019_hw10_mem_regions),
+		},
+	},
 };
 
 static u32 ath10k_coredump_get_ramdump_size(struct ath10k *ar)
-- 
1.7.9.5

