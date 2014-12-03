Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6017 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaLCUFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 15:05:39 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/7] brcmfmac: switch to single message MSI
Date: Wed, 3 Dec 2014 21:05:30 +0100
Message-ID: <1417637133-6966-5-git-send-email-arend@broadcom.com> (sfid-20141203_210545_105759_38AB3E11)
In-Reply-To: <1417637133-6966-1-git-send-email-arend@broadcom.com>
References: <1417637133-6966-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use single message MSI to replace legacy interrupt.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index b87b727..a664819 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -798,12 +798,14 @@ static int brcmf_pcie_request_irq(struct brcmf_pciedev_info *devinfo)
 	brcmf_dbg(PCIE, "Enter\n");
 	/* is it a v1 or v2 implementation */
 	devinfo->irq_requested = false;
+	pci_enable_msi(pdev);
 	if (devinfo->generic_corerev == BRCMF_PCIE_GENREV1) {
 		if (request_threaded_irq(pdev->irq,
 					 brcmf_pcie_quick_check_isr_v1,
 					 brcmf_pcie_isr_thread_v1,
 					 IRQF_SHARED, "brcmf_pcie_intr",
 					 devinfo)) {
+			pci_disable_msi(pdev);
 			brcmf_err("Failed to request IRQ %d\n", pdev->irq);
 			return -EIO;
 		}
@@ -813,6 +815,7 @@ static int brcmf_pcie_request_irq(struct brcmf_pciedev_info *devinfo)
 					 brcmf_pcie_isr_thread_v2,
 					 IRQF_SHARED, "brcmf_pcie_intr",
 					 devinfo)) {
+			pci_disable_msi(pdev);
 			brcmf_err("Failed to request IRQ %d\n", pdev->irq);
 			return -EIO;
 		}
@@ -839,6 +842,7 @@ static void brcmf_pcie_release_irq(struct brcmf_pciedev_info *devinfo)
 		return;
 	devinfo->irq_requested = false;
 	free_irq(pdev->irq, devinfo);
+	pci_disable_msi(pdev);
 
 	msleep(50);
 	count = 0;
-- 
1.9.1

