Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:37601 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaHISIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 14:08:51 -0400
Subject: [PATCH v6 7/8] ath10k: rename ath10k_pci_hif_dump_area() to
 ath10k_pci_firmware_crashed()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 09 Aug 2014 21:08:46 +0300
Message-ID: <20140809180846.29215.34726.stgit@potku.adurom.net> (sfid-20140809_200853_535335_8164E1DF)
In-Reply-To: <20140809180552.29215.58612.stgit@potku.adurom.net>
References: <20140809180552.29215.58612.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Better to have a clear name for the function. While at it, clear up the title
for the register dump.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index deebd30aa182..7fc2f02f53c4 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1040,7 +1040,7 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 
 	BUILD_BUG_ON(REG_DUMP_COUNT_QCA988X % 4);
 
-	ath10k_err("target Register Dump\n");
+	ath10k_err("firmware register dump:\n");
 	for (i = 0; i < REG_DUMP_COUNT_QCA988X; i += 4)
 		ath10k_err("[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X\n",
 			   i,
@@ -1053,7 +1053,7 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 	       sizeof(crash_data->reg_dump_values));
 }
 
-static void ath10k_pci_hif_dump_area(struct ath10k *ar)
+static void ath10k_pci_firmware_crashed(struct ath10k *ar)
 {
 	struct ath10k_fw_crash_data *crash_data;
 	char uuid[50];
@@ -2007,7 +2007,7 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 				   fw_indicator & ~FW_IND_EVENT_PENDING);
 
 		if (ar_pci->started) {
-			ath10k_pci_hif_dump_area(ar);
+			ath10k_pci_firmware_crashed(ar);
 		} else {
 			/*
 			 * Probable Target failure before we're prepared
@@ -2458,7 +2458,7 @@ static void ath10k_pci_early_irq_tasklet(unsigned long data)
 	if (fw_ind & FW_IND_EVENT_PENDING) {
 		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
 				   fw_ind & ~FW_IND_EVENT_PENDING);
-		ath10k_pci_hif_dump_area(ar);
+		ath10k_pci_firmware_crashed(ar);
 	}
 
 	ath10k_pci_sleep(ar);
@@ -2737,7 +2737,7 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		ath10k_warn("device has crashed during init\n");
 		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
 				   val & ~FW_IND_EVENT_PENDING);
-		ath10k_pci_hif_dump_area(ar);
+		ath10k_pci_firmware_crashed(ar);
 		ret = -ECOMM;
 		goto out;
 	}

