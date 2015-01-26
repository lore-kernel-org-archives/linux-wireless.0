Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:46374 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbAZW1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 17:27:00 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: Replace ioread with wmb for data sync
Date: Mon, 26 Jan 2015 14:25:18 -0800
Message-ID: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com> (sfid-20150126_232704_088501_BB1F803F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using ioread() to perform data sync is excessive.
Use compact API, wmb(), that intended to be used for the case.
It reduces total 14 CPU clocks per interrupt.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 3b40a86..c353a2c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -346,10 +346,8 @@ static void ath10k_pci_disable_and_clear_legacy_irq(struct ath10k *ar)
 	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_CLR_ADDRESS,
 			   PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_ALL);
 
-	/* IMPORTANT: this extra read transaction is required to
-	 * flush the posted write buffer. */
-	(void)ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
-				PCIE_INTR_ENABLE_ADDRESS);
+	/* invoke data sync barrier */
+	wmb();
 }
 
 static void ath10k_pci_enable_legacy_irq(struct ath10k *ar)
@@ -358,10 +356,8 @@ static void ath10k_pci_enable_legacy_irq(struct ath10k *ar)
 			   PCIE_INTR_ENABLE_ADDRESS,
 			   PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_ALL);
 
-	/* IMPORTANT: this extra read transaction is required to
-	 * flush the posted write buffer. */
-	(void)ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
-				PCIE_INTR_ENABLE_ADDRESS);
+	/* invoke data sync barrier */
+	wmb();
 }
 
 static inline const char *ath10k_pci_get_irq_method(struct ath10k *ar)
-- 
1.9.1

