Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:27052 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbbIAGYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 02:24:01 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH] ath10k: Disable PCI power save for QCA99X0
Date: Tue, 1 Sep 2015 11:53:32 +0530
Message-ID: <1441088612-9517-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20150901_082405_858501_3B8F10A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

Frequent failures in waking up the target is observed during
interface (mostly observed with AP and Monitor mode) bring up
on x86, this failures lead to firmware crash. Disabling PCI
power save fixes this issue. Disabling ASPM also does not help,
as a work around disable PCI power save for QCA99X0.

The following kernel log is seen when this issue happens

kworker/dying (667) used greatest stack depth: 12208 bytes left
ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x00040050: -110
ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x0004a02c: -110
ath10k_pci 0000:07:00.0: failed to wake target for write32 of 0xfffffffe at 0x0004a02c: -110
ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x0004a034: -110
ath10k_pci 0000:07:00.0: failed to wake target for write32 of 0xfffff81f at 0x0004a034: -110
ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x0004a02c: -110
ath10k_pci 0000:07:00.0: failed to wake target for write32 of 0xffffffe1 at 0x0004a02c: -110
ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x0004a42c: -110
ath10k_pci 0000:07:00.0: failed to wake target for write32 of 0xfffffffe at 0x0004a42c: -110
ath10k_pci 0000:07:00.0: failed to wake target for read32 at 0x0004a434: -110
ath10k_pci 0000:07:00.0: firmware crashed! (uuid 40b345f1-db3d-4b97-bc54-6572994e02d5)

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1046ab6..1ab4ee7 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1640,6 +1640,10 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_pci_safe_chip_reset(ar);
 
 	ath10k_pci_irq_disable(ar);
+
+	if (QCA_REV_99X0(ar))
+		ath10k_pci_sleep(ar);
+
 	ath10k_pci_irq_sync(ar);
 	ath10k_pci_flush(ar);
 
@@ -2315,6 +2319,14 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power up\n");
 
+	if (QCA_REV_99X0(ar)) {
+		ret = ath10k_pci_wake(ar);
+		if (ret) {
+			ath10k_warn(ar, "failed to wake target for qca99x0: %d\n", ret);
+			return ret;
+		}
+	}
+
 	pcie_capability_read_word(ar_pci->pdev, PCI_EXP_LNKCTL,
 				  &ar_pci->link_ctl);
 	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
-- 
1.9.1

