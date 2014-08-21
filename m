Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52707 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaHUMtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 08:49:20 -0400
Subject: [PATCH v8 3/4] ath10k: rename ath10k_pci_hif_dump_area() to
 ath10k_pci_fw_crashed_dump()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Aug 2014 15:49:16 +0300
Message-ID: <20140821124916.27159.2913.stgit@potku.adurom.net> (sfid-20140821_144923_187822_246D50D7)
In-Reply-To: <20140821124705.27159.67898.stgit@potku.adurom.net>
References: <20140821124705.27159.67898.stgit@potku.adurom.net>
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
index 36c4f4130027..bc8c3e3345c1 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -850,7 +850,7 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 
 	BUILD_BUG_ON(REG_DUMP_COUNT_QCA988X % 4);
 
-	ath10k_err("target Register Dump\n");
+	ath10k_err("firmware register dump:\n");
 	for (i = 0; i < REG_DUMP_COUNT_QCA988X; i += 4)
 		ath10k_err("[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X\n",
 			   i,
@@ -864,7 +864,7 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 		crash_data->registers[i] = cpu_to_le32(reg_dump_values[i]);
 }
 
-static void ath10k_pci_hif_dump_area(struct ath10k *ar)
+static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 {
 	struct ath10k_fw_crash_data *crash_data;
 	char uuid[50];
@@ -1811,7 +1811,7 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 				   fw_indicator & ~FW_IND_EVENT_PENDING);
 
 		if (ar_pci->started) {
-			ath10k_pci_hif_dump_area(ar);
+			ath10k_pci_fw_crashed_dump(ar);
 		} else {
 			/*
 			 * Probable Target failure before we're prepared
@@ -2232,7 +2232,7 @@ static void ath10k_pci_early_irq_tasklet(unsigned long data)
 	if (fw_ind & FW_IND_EVENT_PENDING) {
 		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
 				   fw_ind & ~FW_IND_EVENT_PENDING);
-		ath10k_pci_hif_dump_area(ar);
+		ath10k_pci_fw_crashed_dump(ar);
 	}
 
 	ath10k_pci_enable_legacy_irq(ar);
@@ -2483,7 +2483,7 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		ath10k_warn("device has crashed during init\n");
 		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
 				   val & ~FW_IND_EVENT_PENDING);
-		ath10k_pci_hif_dump_area(ar);
+		ath10k_pci_fw_crashed_dump(ar);
 		return -ECOMM;
 	}
 

