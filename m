Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:25353 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340AbbCRMZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 08:25:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 8/8] brcmfmac: remove support for unreleased BCM4354 PCIe
Date: Wed, 18 Mar 2015 13:25:28 +0100
Message-ID: <1426681528-15831-9-git-send-email-arend@broadcom.com> (sfid-20150318_132558_984173_83B157C6)
In-Reply-To: <1426681528-15831-1-git-send-email-arend@broadcom.com>
References: <1426681528-15831-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are no known BCM4354 PCIe devices released so removing
support from the driver until proven otherwise.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index d4066e8..1831ecd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -47,8 +47,6 @@ enum brcmf_pcie_state {
 
 #define BRCMF_PCIE_43602_FW_NAME		"brcm/brcmfmac43602-pcie.bin"
 #define BRCMF_PCIE_43602_NVRAM_NAME		"brcm/brcmfmac43602-pcie.txt"
-#define BRCMF_PCIE_4354_FW_NAME			"brcm/brcmfmac4354-pcie.bin"
-#define BRCMF_PCIE_4354_NVRAM_NAME		"brcm/brcmfmac4354-pcie.txt"
 #define BRCMF_PCIE_4356_FW_NAME			"brcm/brcmfmac4356-pcie.bin"
 #define BRCMF_PCIE_4356_NVRAM_NAME		"brcm/brcmfmac4356-pcie.txt"
 #define BRCMF_PCIE_43570_FW_NAME		"brcm/brcmfmac43570-pcie.bin"
@@ -187,8 +185,6 @@ enum brcmf_pcie_state {
 
 MODULE_FIRMWARE(BRCMF_PCIE_43602_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43602_NVRAM_NAME);
-MODULE_FIRMWARE(BRCMF_PCIE_4354_FW_NAME);
-MODULE_FIRMWARE(BRCMF_PCIE_4354_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4356_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4356_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43570_FW_NAME);
@@ -1327,10 +1323,6 @@ static int brcmf_pcie_get_fwnames(struct brcmf_pciedev_info *devinfo)
 		fw_name = BRCMF_PCIE_43602_FW_NAME;
 		nvram_name = BRCMF_PCIE_43602_NVRAM_NAME;
 		break;
-	case BRCM_CC_4354_CHIP_ID:
-		fw_name = BRCMF_PCIE_4354_FW_NAME;
-		nvram_name = BRCMF_PCIE_4354_NVRAM_NAME;
-		break;
 	case BRCM_CC_4356_CHIP_ID:
 		fw_name = BRCMF_PCIE_4356_FW_NAME;
 		nvram_name = BRCMF_PCIE_4356_NVRAM_NAME;
@@ -1855,7 +1847,6 @@ cleanup:
 	PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_NETWORK_OTHER << 8, 0xffff00, 0 }
 
 static struct pci_device_id brcmf_pcie_devid_table[] = {
-	BRCMF_PCIE_DEVICE(BRCM_PCIE_4354_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4356_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID),
-- 
1.9.1

