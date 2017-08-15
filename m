Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:59216 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751611AbdHOIYJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 04:24:09 -0400
Subject: [PATCH 6/6] ath10k: add memory dump support QCA988X
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 15 Aug 2017 11:23:59 +0300
Message-ID: <150278543889.22482.337673352002345856.stgit@potku.adurom.net> (sfid-20170815_102413_411126_6E66B0EE)
In-Reply-To: <150278532045.22482.14490702801292107536.stgit@potku.adurom.net>
References: <150278532045.22482.14490702801292107536.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Copy two regions of registers and bigger DRAM region to the dump file.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/coredump.c |   40 ++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index d61a36911558..644e01361df8 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -667,6 +667,39 @@ static const struct ath10k_mem_region qca6174_hw30_mem_regions[] = {
 	},
 };
 
+static const struct ath10k_mem_region qca988x_hw20_mem_regions[] = {
+	{
+		.type = ATH10K_MEM_REGION_TYPE_DRAM,
+		.start = 0x400000,
+		.len = 0x50000,
+		.name = "DRAM",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_REG,
+		.start = 0x4000,
+		.len = 0x2000,
+		.name = "REG_PART1",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+	{
+		.type = ATH10K_MEM_REGION_TYPE_REG,
+		.start = 0x8000,
+		.len = 0x58000,
+		.name = "REG_PART2",
+		.section_table = {
+			.sections = NULL,
+			.size = 0,
+		},
+	},
+};
+
 static const struct ath10k_hw_mem_layout hw_mem_layouts[] = {
 	{
 		.hw_id = QCA6174_HW_1_0_VERSION,
@@ -717,6 +750,13 @@ static const struct ath10k_hw_mem_layout hw_mem_layouts[] = {
 			.size = ARRAY_SIZE(qca6174_hw30_mem_regions),
 		},
 	},
+	{
+		.hw_id = QCA988X_HW_2_0_VERSION,
+		.region_table = {
+			.regions = qca988x_hw20_mem_regions,
+			.size = ARRAY_SIZE(qca988x_hw20_mem_regions),
+		},
+	},
 };
 
 static u32 ath10k_coredump_get_ramdump_size(struct ath10k *ar)
