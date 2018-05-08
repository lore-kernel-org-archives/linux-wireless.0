Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34788 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbeEHMJX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 08:09:23 -0400
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: add fw crash dump support for QCA9888 and QCA99X0
Date: Tue,  8 May 2018 17:41:36 +0530
Message-Id: <1525781496-14776-1-git-send-email-akolli@codeaurora.org> (sfid-20180508_140927_169317_5124B8A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds crash dump support for QCA9888 and QCA99X0

Tested On: QCA9888, Firmware Version: 10.4-3.5.3-00053
Tested on QCA99X0, Firmware Version: 10.4.1.00030-1

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/coredump.c |   98 ++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index f90cec0ebb1c..e0eb2eb1a66d 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -701,6 +701,89 @@
 	},
 };
 
+static const struct ath10k_mem_region qca99X0_hw20_mem_regions[] = {
+	{
+		.type = ATH10K_MEM_REGION_TYPE_DRAM,
+		.start = 0x400000,
+		.len = 0x60000,
+		.name = "DRAM",
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
+		.type = ATH10K_MEM_REGION_TYPE_IOSRAM,
+		.start = 0xC0000,
+		.len = 0x40000,
+		.name = "SRAM",
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
+		.type = ATH10K_MEM_REGION_TYPE_IOREG,
+		.start = 0x80000,
+		.len = 0x6000,
+		.name = "SOC REG",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+};
+
 static const struct ath10k_mem_region qca9984_hw10_mem_regions[] = {
 	{
 		.type = ATH10K_MEM_REGION_TYPE_DRAM,
@@ -848,6 +931,21 @@
 			.size = ARRAY_SIZE(qca9984_hw10_mem_regions),
 		},
 	},
+	{
+		.hw_id = QCA9888_HW_2_0_DEV_VERSION,
+		.region_table = {
+			.regions = qca9984_hw10_mem_regions,
+			.size = ARRAY_SIZE(qca9984_hw10_mem_regions),
+		},
+	},
+	{
+		.hw_id = QCA99X0_HW_2_0_DEV_VERSION,
+		.region_table = {
+			.regions = qca99X0_hw20_mem_regions,
+			.size = ARRAY_SIZE(qca99X0_hw20_mem_regions),
+		},
+	},
+
 };
 
 static u32 ath10k_coredump_get_ramdump_size(struct ath10k *ar)
-- 
1.7.9.5
