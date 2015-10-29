Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:9595 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185AbbJ2Tnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 15:43:50 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/9] brcmfmac: Add support for the BCM4359 11ac RSDB PCIE device.
Date: Thu, 29 Oct 2015 20:33:11 +0100
Message-ID: <1446147199-21671-2-git-send-email-arend@broadcom.com> (sfid-20151029_204356_784676_6D9AFCED)
In-Reply-To: <1446147199-21671-1-git-send-email-arend@broadcom.com>
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c       | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c       | 9 +++++++++
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index f04833d..82e4382 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -681,6 +681,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_43569_CHIP_ID:
 	case BRCM_CC_43570_CHIP_ID:
 	case BRCM_CC_4358_CHIP_ID:
+	case BRCM_CC_4359_CHIP_ID:
 	case BRCM_CC_43602_CHIP_ID:
 	case BRCM_CC_4371_CHIP_ID:
 		return 0x180000;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 83d8042..7982d4d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -55,6 +55,8 @@ enum brcmf_pcie_state {
 #define BRCMF_PCIE_43570_NVRAM_NAME		"brcm/brcmfmac43570-pcie.txt"
 #define BRCMF_PCIE_4358_FW_NAME			"brcm/brcmfmac4358-pcie.bin"
 #define BRCMF_PCIE_4358_NVRAM_NAME		"brcm/brcmfmac4358-pcie.txt"
+#define BRCMF_PCIE_4359_FW_NAME			"brcm/brcmfmac4359-pcie.bin"
+#define BRCMF_PCIE_4359_NVRAM_NAME		"brcm/brcmfmac4359-pcie.txt"
 #define BRCMF_PCIE_4365_FW_NAME			"brcm/brcmfmac4365b-pcie.bin"
 #define BRCMF_PCIE_4365_NVRAM_NAME		"brcm/brcmfmac4365b-pcie.txt"
 #define BRCMF_PCIE_4366_FW_NAME			"brcm/brcmfmac4366b-pcie.bin"
@@ -210,6 +212,8 @@ MODULE_FIRMWARE(BRCMF_PCIE_43570_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43570_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4358_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4358_NVRAM_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4359_FW_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4359_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4365_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4365_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4366_FW_NAME);
@@ -1517,6 +1521,10 @@ static int brcmf_pcie_get_fwnames(struct brcmf_pciedev_info *devinfo)
 		fw_name = BRCMF_PCIE_4358_FW_NAME;
 		nvram_name = BRCMF_PCIE_4358_NVRAM_NAME;
 		break;
+	case BRCM_CC_4359_CHIP_ID:
+		fw_name = BRCMF_PCIE_4359_FW_NAME;
+		nvram_name = BRCMF_PCIE_4359_NVRAM_NAME;
+		break;
 	case BRCM_CC_4365_CHIP_ID:
 		fw_name = BRCMF_PCIE_4365_FW_NAME;
 		nvram_name = BRCMF_PCIE_4365_NVRAM_NAME;
@@ -2058,6 +2066,7 @@ static struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4358_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4359_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_2G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_5G_DEVICE_ID),
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index aa06ea2..4092d27 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -47,6 +47,7 @@
 #define BRCM_CC_43569_CHIP_ID		43569
 #define BRCM_CC_43570_CHIP_ID		43570
 #define BRCM_CC_4358_CHIP_ID		0x4358
+#define BRCM_CC_4359_CHIP_ID		0x4359
 #define BRCM_CC_43602_CHIP_ID		43602
 #define BRCM_CC_4365_CHIP_ID		0x4365
 #define BRCM_CC_4366_CHIP_ID		0x4366
@@ -66,6 +67,7 @@
 #define BRCM_PCIE_43567_DEVICE_ID	0x43d3
 #define BRCM_PCIE_43570_DEVICE_ID	0x43d9
 #define BRCM_PCIE_4358_DEVICE_ID	0x43e9
+#define BRCM_PCIE_4359_DEVICE_ID	0x43ef
 #define BRCM_PCIE_43602_DEVICE_ID	0x43ba
 #define BRCM_PCIE_43602_2G_DEVICE_ID	0x43bb
 #define BRCM_PCIE_43602_5G_DEVICE_ID	0x43bc
-- 
1.9.1

