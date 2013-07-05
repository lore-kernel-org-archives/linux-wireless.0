Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:43828 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab3GENPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 06/16] ath10k: fix typo in define name
Date: Fri,  5 Jul 2013 16:15:07 +0300
Message-Id: <1373030117-18077-7-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_152040_011328_0F17AA66)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |    2 +-
 drivers/net/wireless/ath/ath10k/pci.c |    6 +++---
 drivers/net/wireless/ath/ath10k/pci.h |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 61a8ac7..b407929 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -79,7 +79,7 @@ static inline void ath10k_ce_src_ring_write_index_set(struct ath10k *ar,
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	void __iomem *indicator_addr;
 
-	if (!test_bit(ATH10K_PCI_FEATURE_HW_1_0_WARKAROUND, ar_pci->features)) {
+	if (!test_bit(ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND, ar_pci->features)) {
 		ath10k_pci_write32(ar, ce_ctrl_addr + SR_WR_INDEX_ADDRESS, n);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index ab7e4a2..21ef88a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2116,7 +2116,7 @@ static void ath10k_pci_dump_features(struct ath10k_pci *ar_pci)
 		case ATH10K_PCI_FEATURE_MSI_X:
 			ath10k_dbg(ATH10K_DBG_PCI, "device supports MSI-X\n");
 			break;
-		case ATH10K_PCI_FEATURE_HW_1_0_WARKAROUND:
+		case ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND:
 			ath10k_dbg(ATH10K_DBG_PCI, "QCA988X_1.0 workaround enabled\n");
 			break;
 		}
@@ -2143,7 +2143,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	switch (pci_dev->device) {
 	case QCA988X_1_0_DEVICE_ID:
-		set_bit(ATH10K_PCI_FEATURE_HW_1_0_WARKAROUND, ar_pci->features);
+		set_bit(ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND, ar_pci->features);
 		break;
 	case QCA988X_2_0_DEVICE_ID:
 		set_bit(ATH10K_PCI_FEATURE_MSI_X, ar_pci->features);
@@ -2164,7 +2164,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Enable QCA988X_1.0 HW workarounds */
-	if (test_bit(ATH10K_PCI_FEATURE_HW_1_0_WARKAROUND, ar_pci->features))
+	if (test_bit(ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND, ar_pci->features))
 		spin_lock_init(&ar_pci->hw_v1_workaround_lock);
 
 	ar_pci->ar = ar;
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index d2a055a..d3a2e6c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -152,7 +152,7 @@ struct service_to_pipe {
 
 enum ath10k_pci_features {
 	ATH10K_PCI_FEATURE_MSI_X		= 0,
-	ATH10K_PCI_FEATURE_HW_1_0_WARKAROUND	= 1,
+	ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND	= 1,
 
 	/* keep last */
 	ATH10K_PCI_FEATURE_COUNT
@@ -311,7 +311,7 @@ static inline void ath10k_pci_write32(struct ath10k *ar, u32 offset,
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	void __iomem *addr = ar_pci->mem;
 
-	if (test_bit(ATH10K_PCI_FEATURE_HW_1_0_WARKAROUND, ar_pci->features)) {
+	if (test_bit(ATH10K_PCI_FEATURE_HW_1_0_WORKAROUND, ar_pci->features)) {
 		unsigned long irq_flags;
 
 		spin_lock_irqsave(&ar_pci->hw_v1_workaround_lock, irq_flags);
-- 
1.7.9.5

