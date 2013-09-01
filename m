Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:51183 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3IAHB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 03:01:56 -0400
Subject: [PATCH v2 4/7] ath10k: convert ath10k_pci_reg_read/write32() to take
 struct ath10k
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 01 Sep 2013 10:01:53 +0300
Message-ID: <20130901070153.14695.6127.stgit@localhost6.localdomain6> (sfid-20130901_090158_797816_77EC862D)
In-Reply-To: <20130901070020.14695.16694.stgit@localhost6.localdomain6>
References: <20130901070020.14695.16694.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is consistent with all other functions.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   19 +++++++------------
 drivers/net/wireless/ath/ath10k/pci.h |   12 ++++++++----
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 418de1e..e0cf75f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2323,18 +2323,13 @@ static int ath10k_pci_reset_target(struct ath10k *ar)
 
 static void ath10k_pci_device_reset(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	void __iomem *mem = ar_pci->mem;
 	int i;
 	u32 val;
 
 	if (!SOC_GLOBAL_RESET_ADDRESS)
 		return;
 
-	if (!mem)
-		return;
-
-	ath10k_pci_reg_write32(mem, PCIE_SOC_WAKE_ADDRESS,
+	ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS,
 			       PCIE_SOC_WAKE_V_MASK);
 	for (i = 0; i < ATH_PCI_RESET_WAIT_MAX; i++) {
 		if (ath10k_pci_target_is_awake(ar))
@@ -2343,12 +2338,12 @@ static void ath10k_pci_device_reset(struct ath10k *ar)
 	}
 
 	/* Put Target, including PCIe, into RESET. */
-	val = ath10k_pci_reg_read32(mem, SOC_GLOBAL_RESET_ADDRESS);
+	val = ath10k_pci_reg_read32(ar, SOC_GLOBAL_RESET_ADDRESS);
 	val |= 1;
-	ath10k_pci_reg_write32(mem, SOC_GLOBAL_RESET_ADDRESS, val);
+	ath10k_pci_reg_write32(ar, SOC_GLOBAL_RESET_ADDRESS, val);
 
 	for (i = 0; i < ATH_PCI_RESET_WAIT_MAX; i++) {
-		if (ath10k_pci_reg_read32(mem, RTC_STATE_ADDRESS) &
+		if (ath10k_pci_reg_read32(ar, RTC_STATE_ADDRESS) &
 					  RTC_STATE_COLD_RESET_MASK)
 			break;
 		msleep(1);
@@ -2356,16 +2351,16 @@ static void ath10k_pci_device_reset(struct ath10k *ar)
 
 	/* Pull Target, including PCIe, out of RESET. */
 	val &= ~1;
-	ath10k_pci_reg_write32(mem, SOC_GLOBAL_RESET_ADDRESS, val);
+	ath10k_pci_reg_write32(ar, SOC_GLOBAL_RESET_ADDRESS, val);
 
 	for (i = 0; i < ATH_PCI_RESET_WAIT_MAX; i++) {
-		if (!(ath10k_pci_reg_read32(mem, RTC_STATE_ADDRESS) &
+		if (!(ath10k_pci_reg_read32(ar, RTC_STATE_ADDRESS) &
 					    RTC_STATE_COLD_RESET_MASK))
 			break;
 		msleep(1);
 	}
 
-	ath10k_pci_reg_write32(mem, PCIE_SOC_WAKE_ADDRESS, PCIE_SOC_WAKE_RESET);
+	ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS, PCIE_SOC_WAKE_RESET);
 }
 
 static void ath10k_pci_dump_features(struct ath10k_pci *ar_pci)
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 2a6cb09..395f610 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -240,14 +240,18 @@ static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
 	return ar->hif.priv;
 }
 
-static inline u32 ath10k_pci_reg_read32(void __iomem *mem, u32 addr)
+static inline u32 ath10k_pci_reg_read32(struct ath10k *ar, u32 addr)
 {
-	return ioread32(mem + PCIE_LOCAL_BASE_ADDRESS + addr);
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	return ioread32(ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS + addr);
 }
 
-static inline void ath10k_pci_reg_write32(void __iomem *mem, u32 addr, u32 val)
+static inline void ath10k_pci_reg_write32(struct ath10k *ar, u32 addr, u32 val)
 {
-	iowrite32(val, mem + PCIE_LOCAL_BASE_ADDRESS + addr);
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	iowrite32(val, ar_pci->mem + PCIE_LOCAL_BASE_ADDRESS + addr);
 }
 
 #define ATH_PCI_RESET_WAIT_MAX 10 /* ms */

