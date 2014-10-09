Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57328 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJIIdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:33:41 -0400
Received: by mail-wi0-f178.google.com with SMTP id cc10so1048699wib.5
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 01:33:40 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/5] ath10k: mask/unmask msi fw irq
Date: Thu,  9 Oct 2014 10:22:27 +0200
Message-Id: <1412842950-14098-3-git-send-email-michal.kazior@tieto.com> (sfid-20141009_103357_824587_AEEA6AEB)
In-Reply-To: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com>
References: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was the final missing bit to making sure the
device doesn't assert interrupts to host.

This should fix possible race when target crashes
during driver teardown.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  |  1 +
 drivers/net/wireless/ath/ath10k/pci.c | 25 +++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 5dd6551..6242319 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -289,6 +289,7 @@ struct ath10k_pktlog_hdr {
 #define SI_RX_DATA1_OFFSET			0x00000014
 
 #define CORE_CTRL_CPU_INTR_MASK			0x00002000
+#define CORE_CTRL_PCIE_REG_31_MASK		0x00000800
 #define CORE_CTRL_ADDRESS			0x0000
 #define PCIE_INTR_ENABLE_ADDRESS		0x0008
 #define PCIE_INTR_CAUSE_ADDRESS			0x000c
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 6077095..cdc03e4 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1143,6 +1143,26 @@ static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
 						 &dl_is_polled);
 }
 
+static void ath10k_pci_irq_msi_fw_mask(struct ath10k *ar)
+{
+	u32 val;
+
+	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS + CORE_CTRL_ADDRESS);
+	val &= ~CORE_CTRL_PCIE_REG_31_MASK;
+
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + CORE_CTRL_ADDRESS, val);
+}
+
+static void ath10k_pci_irq_msi_fw_unmask(struct ath10k *ar)
+{
+	u32 val;
+
+	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS + CORE_CTRL_ADDRESS);
+	val |= CORE_CTRL_PCIE_REG_31_MASK;
+
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + CORE_CTRL_ADDRESS, val);
+}
+
 static void ath10k_pci_irq_disable(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1150,7 +1170,7 @@ static void ath10k_pci_irq_disable(struct ath10k *ar)
 
 	ath10k_ce_disable_interrupts(ar);
 	ath10k_pci_disable_and_clear_legacy_irq(ar);
-	/* FIXME: How to mask all MSI interrupts? */
+	ath10k_pci_irq_msi_fw_mask(ar);
 
 	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
 		synchronize_irq(ar_pci->pdev->irq + i);
@@ -1160,7 +1180,7 @@ static void ath10k_pci_irq_enable(struct ath10k *ar)
 {
 	ath10k_ce_enable_interrupts(ar);
 	ath10k_pci_enable_legacy_irq(ar);
-	/* FIXME: How to unmask all MSI interrupts? */
+	ath10k_pci_irq_msi_fw_unmask(ar);
 }
 
 static int ath10k_pci_hif_start(struct ath10k *ar)
@@ -2285,6 +2305,7 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 	} while (time_before(jiffies, timeout));
 
 	ath10k_pci_disable_and_clear_legacy_irq(ar);
+	ath10k_pci_irq_msi_fw_mask(ar);
 
 	if (val == 0xffffffff) {
 		ath10k_err(ar, "failed to read device register, device is gone\n");
-- 
1.8.5.3

