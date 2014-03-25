Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:54376 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaCYJPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 05:15:07 -0400
Subject: [PATCH 1/8] ath10k: cleanup ath10k_pci_wait_for_target_init()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Mar 2014 11:15:05 +0200
Message-ID: <20140325091505.16651.15554.stgit@potku.adurom.net> (sfid-20140325_101513_237738_A31D04B2)
In-Reply-To: <20140325091311.16651.15747.stgit@potku.adurom.net>
References: <20140325091311.16651.15747.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_pci_wait_for_target_init() did really follow the style used elsewhere in
ath10k. Use ath10k_pci_read/write() wrappers, simplify the while loop and
improve warning messages.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 9d242d801d9d..0425c76daf3f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2385,30 +2385,37 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
 static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int wait_limit = 300; /* 3 sec */
+	const int wait = 3000; /* ms */
+	unsigned long timeout;
 	int ret;
+	u32 val;
 
 	ret = ath10k_pci_wake(ar);
 	if (ret) {
-		ath10k_err("failed to wake up target: %d\n", ret);
+		ath10k_err("failed to wake up target for init: %d\n", ret);
 		return ret;
 	}
 
-	while (wait_limit-- &&
-	       !(ioread32(ar_pci->mem + FW_INDICATOR_ADDRESS) &
-		 FW_IND_INITIALIZED)) {
+	timeout = jiffies + msecs_to_jiffies(wait);
+
+	do {
+		val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
+		if (val == FW_IND_INITIALIZED)
+			break;
+
 		if (ar_pci->num_msi_intrs == 0)
 			/* Fix potential race by repeating CORE_BASE writes */
-			iowrite32(PCIE_INTR_FIRMWARE_MASK |
-				  PCIE_INTR_CE_MASK_ALL,
-				  ar_pci->mem + (SOC_CORE_BASE_ADDRESS |
-						 PCIE_INTR_ENABLE_ADDRESS));
+			ath10k_pci_soc_write32(ar, PCIE_INTR_ENABLE_ADDRESS,
+					       PCIE_INTR_FIRMWARE_MASK |
+					       PCIE_INTR_CE_MASK_ALL);
+
 		mdelay(10);
-	}
+	} while (time_before(jiffies, timeout));
 
-	if (wait_limit < 0) {
-		ath10k_err("target stalled\n");
-		ret = -EIO;
+	if (val != FW_IND_INITIALIZED) {
+		ath10k_err("failed to receive initialized event from target after %d ms: %d\n",
+			   wait, val);
+		ret = -ETIMEDOUT;
 		goto out;
 	}
 

