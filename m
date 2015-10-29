Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:61989 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105AbbJ2Tnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 15:43:42 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/9] brcmfmac: Remove unncessary variable irq_requested.
Date: Thu, 29 Oct 2015 20:33:14 +0100
Message-ID: <1446147199-21671-5-git-send-email-arend@broadcom.com> (sfid-20151029_204345_466435_355AFC15)
In-Reply-To: <1446147199-21671-1-git-send-email-arend@broadcom.com>
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The variable irq_requested is unneeded as the functionality
it is providing, is also provided by the variable irq_allocated.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 7982d4d..0edaaf5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -257,7 +257,6 @@ struct brcmf_pcie_core_info {
 struct brcmf_pciedev_info {
 	enum brcmf_pcie_state state;
 	bool in_irq;
-	bool irq_requested;
 	struct pci_dev *pdev;
 	char fw_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
 	char nvram_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
@@ -889,7 +888,6 @@ static int brcmf_pcie_request_irq(struct brcmf_pciedev_info *devinfo)
 
 	brcmf_dbg(PCIE, "Enter\n");
 	/* is it a v1 or v2 implementation */
-	devinfo->irq_requested = false;
 	pci_enable_msi(pdev);
 	if (devinfo->generic_corerev == BRCMF_PCIE_GENREV1) {
 		if (request_threaded_irq(pdev->irq,
@@ -912,7 +910,6 @@ static int brcmf_pcie_request_irq(struct brcmf_pciedev_info *devinfo)
 			return -EIO;
 		}
 	}
-	devinfo->irq_requested = true;
 	devinfo->irq_allocated = true;
 	return 0;
 }
@@ -930,9 +927,6 @@ static void brcmf_pcie_release_irq(struct brcmf_pciedev_info *devinfo)
 	pdev = devinfo->pdev;
 
 	brcmf_pcie_intr_disable(devinfo);
-	if (!devinfo->irq_requested)
-		return;
-	devinfo->irq_requested = false;
 	free_irq(pdev->irq, devinfo);
 	pci_disable_msi(pdev);
 
-- 
1.9.1

