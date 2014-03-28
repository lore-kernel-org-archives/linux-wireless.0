Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:56753 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaC1HcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:32:24 -0400
Subject: [PATCH v2 1/8] ath10k: cleanup ath10k_pci_wait_for_target_init()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 09:32:21 +0200
Message-ID: <20140328073221.30438.67531.stgit@potku.adurom.net> (sfid-20140328_083226_572695_2898E860)
In-Reply-To: <20140328073040.30438.17966.stgit@potku.adurom.net>
References: <20140328073040.30438.17966.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_pci_wait_for_target_init() did really follow the style used elsewhere in
ath10k. Use ath10k_pci_read/write() wrappers, simplify the while loop and
improve warning messages.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   40 ++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 9d242d801d9d..43d63677b133 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -48,6 +48,9 @@ MODULE_PARM_DESC(ath10k_target_ps, "Enable ath10k Target (SoC) PS option");
 module_param_named(irq_mode, ath10k_pci_irq_mode, uint, 0644);
 MODULE_PARM_DESC(irq_mode, "0: auto, 1: legacy, 2: msi (default: 0)");
 
+/* how long wait to wait for target to initialise, in ms */
+#define ATH10K_PCI_TARGET_WAIT 3000
+
 #define QCA988X_2_0_DEVICE_ID	(0x003c)
 
 static DEFINE_PCI_DEVICE_TABLE(ath10k_pci_id_table) = {
@@ -2385,30 +2388,41 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
 static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int wait_limit = 300; /* 3 sec */
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
+	timeout = jiffies + msecs_to_jiffies(ATH10K_PCI_TARGET_WAIT);
+
+	do {
+		val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
+
+		/* target should never return this */
+		if (val == 0xffffffff)
+			continue;
+
+		if (val & FW_IND_INITIALIZED)
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
+	if (val == 0xffffffff || !(val & FW_IND_INITIALIZED)) {
+		ath10k_err("failed to receive initialized event from target: %08x\n",
+			   val);
+		ret = -ETIMEDOUT;
 		goto out;
 	}
 

