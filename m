Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38374 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbbFRHDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 03:03:07 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V2 05/10] ath10k: Make target cpu address to CE address conversion chip specific
Date: Thu, 18 Jun 2015 12:31:05 +0530
Message-ID: <1434610870-5505-6-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150618_090311_969697_9A750F9A)
In-Reply-To: <1434610870-5505-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1434610870-5505-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the helper converting target virtual address space to CE address
space a target type specific to support QCA99X0. Also make this as
function instead of macro.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 25 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/pci.h | 12 ------------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c2aecfe..df7d74e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -755,6 +755,26 @@ static void ath10k_pci_rx_replenish_retry(unsigned long ptr)
 	ath10k_pci_rx_post(ar);
 }
 
+static u32 ath10k_pci_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
+{
+	u32 val = 0;
+
+	switch (ar->hw_rev) {
+	case ATH10K_HW_QCA988X:
+	case ATH10K_HW_QCA6174:
+		val = (ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
+					  CORE_CTRL_ADDRESS) &
+		       0x7fff) << 21;
+		break;
+	case ATH10K_HW_QCA99X0:
+		val = ath10k_pci_read32(ar, PCIE_BAR_REG_ADDRESS);
+		break;
+	}
+
+	val |= 0x100000 | (addr & 0xfffff);
+	return val;
+}
+
 /*
  * Diagnostic read/write access is provided for startup/config/debug usage.
  * Caller must guarantee proper alignment, when applicable, and single user
@@ -817,8 +837,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		 * convert it from Target CPU virtual address space
 		 * to CE address space
 		 */
-		address = TARG_CPU_SPACE_TO_CE_SPACE(ar, ar_pci->mem,
-						     address);
+		address = ath10k_pci_targ_cpu_to_ce_addr(ar, address);
 
 		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)address, nbytes, 0,
 					    0);
@@ -976,7 +995,7 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	 * to
 	 *    CE address space
 	 */
-	address = TARG_CPU_SPACE_TO_CE_SPACE(ar, ar_pci->mem, address);
+	address = ath10k_pci_targ_cpu_to_ce_addr(ar, address);
 
 	remaining_bytes = orig_nbytes;
 	ce_data = ce_data_base;
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index eea0a01..8d364fb 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -237,18 +237,6 @@ static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
 #define CDC_WAR_MAGIC_STR   0xceef0000
 #define CDC_WAR_DATA_CE     4
 
-/*
- * TODO: Should be a function call specific to each Target-type.
- * This convoluted macro converts from Target CPU Virtual Address Space to CE
- * Address Space. As part of this process, we conservatively fetch the current
- * PCIE_BAR. MOST of the time, this should match the upper bits of PCI space
- * for this device; but that's not guaranteed.
- */
-#define TARG_CPU_SPACE_TO_CE_SPACE(ar, pci_addr, addr)			\
-	(((ath10k_pci_read32(ar, (SOC_CORE_BASE_ADDRESS |		\
-	  CORE_CTRL_ADDRESS)) & 0x7ff) << 21) |				\
-	 0x100000 | ((addr) & 0xfffff))
-
 /* Wait up to this many Ms for a Diagnostic Access CE operation to complete */
 #define DIAG_ACCESS_CE_TIMEOUT_MS 10
 
-- 
1.9.1

