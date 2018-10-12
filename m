Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440B0C6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 06:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 077A2206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 06:03:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="exuV+WEe";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="exuV+WEe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 077A2206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbeJLNe1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 09:34:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbeJLNe1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 09:34:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6FE3560C62; Fri, 12 Oct 2018 06:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539324217;
        bh=FV4vPwUbrinK6mzsodiXjaNC/+XJ+DMkWCjWVm/QyaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exuV+WEegjbqZEj+ylUXmD675weVRtoFG2LpoSGAxdVjA4nCaeBsfW+KwlLzCXBZR
         IOeyMB8zKIMK6/NTWfdufu+0w/0h8H+ZkG876fdcszQjje8tZNjpyb2NH2So5HYreW
         8m2LOB0al2H3e3eiErlAlFLLL1z/p32pDdk//3ek=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: akolli@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6E5176072E;
        Fri, 12 Oct 2018 06:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539324217;
        bh=FV4vPwUbrinK6mzsodiXjaNC/+XJ+DMkWCjWVm/QyaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exuV+WEegjbqZEj+ylUXmD675weVRtoFG2LpoSGAxdVjA4nCaeBsfW+KwlLzCXBZR
         IOeyMB8zKIMK6/NTWfdufu+0w/0h8H+ZkG876fdcszQjje8tZNjpyb2NH2So5HYreW
         8m2LOB0al2H3e3eiErlAlFLLL1z/p32pDdk//3ek=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6E5176072E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=akolli@codeaurora.org
From:   Anilkumar Kolli <akolli@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH 2/2] ath10k: assign proper firmware crash dump structure
Date:   Fri, 12 Oct 2018 11:36:37 +0530
Message-Id: <1539324397-10597-2-git-send-email-akolli@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1539324397-10597-1-git-send-email-akolli@codeaurora.org>
References: <1539324397-10597-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ar->target_version is same for QCA99x0, QCA4019, QCA9888
and QCA9984, this eneded up in assgning the wrong hw_mem_layouts.
This patch adds additional hw_rev check to assign correct
hw_mem_layouts.

Tested on:
QCA4019 firmware 10.4-3.2.1.1-00017
QCA9984 firmware 10.4-3.5.3-00057

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/coredump.c |   15 ++++++++++++++-
 drivers/net/wireless/ath/ath10k/coredump.h |    1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 1ccc73c6ef12..eadae2f9206b 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -965,6 +965,7 @@
 static const struct ath10k_hw_mem_layout hw_mem_layouts[] = {
 	{
 		.hw_id = QCA6174_HW_1_0_VERSION,
+		.hw_rev = ATH10K_HW_QCA6174,
 		.region_table = {
 			.regions = qca6174_hw10_mem_regions,
 			.size = ARRAY_SIZE(qca6174_hw10_mem_regions),
@@ -972,6 +973,7 @@
 	},
 	{
 		.hw_id = QCA6174_HW_1_1_VERSION,
+		.hw_rev = ATH10K_HW_QCA6174,
 		.region_table = {
 			.regions = qca6174_hw10_mem_regions,
 			.size = ARRAY_SIZE(qca6174_hw10_mem_regions),
@@ -979,6 +981,7 @@
 	},
 	{
 		.hw_id = QCA6174_HW_1_3_VERSION,
+		.hw_rev = ATH10K_HW_QCA6174,
 		.region_table = {
 			.regions = qca6174_hw10_mem_regions,
 			.size = ARRAY_SIZE(qca6174_hw10_mem_regions),
@@ -986,6 +989,7 @@
 	},
 	{
 		.hw_id = QCA6174_HW_2_1_VERSION,
+		.hw_rev = ATH10K_HW_QCA6174,
 		.region_table = {
 			.regions = qca6174_hw21_mem_regions,
 			.size = ARRAY_SIZE(qca6174_hw21_mem_regions),
@@ -993,6 +997,7 @@
 	},
 	{
 		.hw_id = QCA6174_HW_3_0_VERSION,
+		.hw_rev = ATH10K_HW_QCA6174,
 		.region_table = {
 			.regions = qca6174_hw30_mem_regions,
 			.size = ARRAY_SIZE(qca6174_hw30_mem_regions),
@@ -1000,6 +1005,7 @@
 	},
 	{
 		.hw_id = QCA6174_HW_3_2_VERSION,
+		.hw_rev = ATH10K_HW_QCA6174,
 		.region_table = {
 			.regions = qca6174_hw30_mem_regions,
 			.size = ARRAY_SIZE(qca6174_hw30_mem_regions),
@@ -1007,6 +1013,7 @@
 	},
 	{
 		.hw_id = QCA9377_HW_1_1_DEV_VERSION,
+		.hw_rev = ATH10K_HW_QCA9377,
 		.region_table = {
 			.regions = qca6174_hw30_mem_regions,
 			.size = ARRAY_SIZE(qca6174_hw30_mem_regions),
@@ -1014,6 +1021,7 @@
 	},
 	{
 		.hw_id = QCA988X_HW_2_0_VERSION,
+		.hw_rev = ATH10K_HW_QCA988X,
 		.region_table = {
 			.regions = qca988x_hw20_mem_regions,
 			.size = ARRAY_SIZE(qca988x_hw20_mem_regions),
@@ -1021,6 +1029,7 @@
 	},
 	{
 		.hw_id = QCA9984_HW_1_0_DEV_VERSION,
+		.hw_rev = ATH10K_HW_QCA9984,
 		.region_table = {
 			.regions = qca9984_hw10_mem_regions,
 			.size = ARRAY_SIZE(qca9984_hw10_mem_regions),
@@ -1028,6 +1037,7 @@
 	},
 	{
 		.hw_id = QCA9888_HW_2_0_DEV_VERSION,
+		.hw_rev = ATH10K_HW_QCA9888,
 		.region_table = {
 			.regions = qca9984_hw10_mem_regions,
 			.size = ARRAY_SIZE(qca9984_hw10_mem_regions),
@@ -1035,6 +1045,7 @@
 	},
 	{
 		.hw_id = QCA99X0_HW_2_0_DEV_VERSION,
+		.hw_rev = ATH10K_HW_QCA99X0,
 		.region_table = {
 			.regions = qca99x0_hw20_mem_regions,
 			.size = ARRAY_SIZE(qca99x0_hw20_mem_regions),
@@ -1042,6 +1053,7 @@
 	},
 	{
 		.hw_id = QCA4019_HW_1_0_DEV_VERSION,
+		.hw_rev = ATH10K_HW_QCA4019,
 		.region_table = {
 			.regions = qca4019_hw10_mem_regions,
 			.size = ARRAY_SIZE(qca4019_hw10_mem_regions),
@@ -1088,7 +1100,8 @@ const struct ath10k_hw_mem_layout *ath10k_coredump_get_mem_layout(struct ath10k
 		return NULL;
 
 	for (i = 0; i < ARRAY_SIZE(hw_mem_layouts); i++) {
-		if (ar->target_version == hw_mem_layouts[i].hw_id)
+		if (ar->target_version == hw_mem_layouts[i].hw_id &&
+		    ar->hw_rev == hw_mem_layouts[i].hw_rev)
 			return &hw_mem_layouts[i];
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/coredump.h b/drivers/net/wireless/ath/ath10k/coredump.h
index 3baaf9d2cbcd..5dac653e1649 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.h
+++ b/drivers/net/wireless/ath/ath10k/coredump.h
@@ -165,6 +165,7 @@ struct ath10k_mem_region {
  */
 struct ath10k_hw_mem_layout {
 	u32 hw_id;
+	u32 hw_rev;
 
 	struct {
 		const struct ath10k_mem_region *regions;
-- 
1.7.9.5

