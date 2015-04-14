Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:36229 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbbDNSKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 14:10:51 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/10] brcmfmac: add support for BCM4358 PCIe device
Date: Tue, 14 Apr 2015 20:10:31 +0200
Message-ID: <1429035033-14076-9-git-send-email-arend@broadcom.com> (sfid-20150414_201113_820076_4B6EC99F)
In-Reply-To: <1429035033-14076-1-git-send-email-arend@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for the BCM4358 2x2 11ac device.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c       | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c       | 9 +++++++++
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index ab2fac8..288f831 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -649,6 +649,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_43567_CHIP_ID:
 	case BRCM_CC_43569_CHIP_ID:
 	case BRCM_CC_43570_CHIP_ID:
+	case BRCM_CC_4358_CHIP_ID:
 	case BRCM_CC_43602_CHIP_ID:
 		return 0x180000;
 	default:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 1831ecd..8815de7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -51,6 +51,8 @@ enum brcmf_pcie_state {
 #define BRCMF_PCIE_4356_NVRAM_NAME		"brcm/brcmfmac4356-pcie.txt"
 #define BRCMF_PCIE_43570_FW_NAME		"brcm/brcmfmac43570-pcie.bin"
 #define BRCMF_PCIE_43570_NVRAM_NAME		"brcm/brcmfmac43570-pcie.txt"
+#define BRCMF_PCIE_4358_FW_NAME			"brcm/brcmfmac4358-pcie.bin"
+#define BRCMF_PCIE_4358_NVRAM_NAME		"brcm/brcmfmac4358-pcie.txt"
 
 #define BRCMF_PCIE_FW_UP_TIMEOUT		2000 /* msec */
 
@@ -189,6 +191,8 @@ MODULE_FIRMWARE(BRCMF_PCIE_4356_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4356_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43570_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43570_NVRAM_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4358_FW_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4358_NVRAM_NAME);
 
 
 struct brcmf_pcie_console {
@@ -1333,6 +1337,10 @@ static int brcmf_pcie_get_fwnames(struct brcmf_pciedev_info *devinfo)
 		fw_name = BRCMF_PCIE_43570_FW_NAME;
 		nvram_name = BRCMF_PCIE_43570_NVRAM_NAME;
 		break;
+	case BRCM_CC_4358_CHIP_ID:
+		fw_name = BRCMF_PCIE_4358_FW_NAME;
+		nvram_name = BRCMF_PCIE_4358_NVRAM_NAME;
+		break;
 	default:
 		brcmf_err("Unsupported chip 0x%04x\n", devinfo->ci->chip);
 		return -ENODEV;
@@ -1850,6 +1858,7 @@ static struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4356_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4358_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_2G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_5G_DEVICE_ID),
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 4efdd51..2543282 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -45,6 +45,7 @@
 #define BRCM_CC_43567_CHIP_ID		43567
 #define BRCM_CC_43569_CHIP_ID		43569
 #define BRCM_CC_43570_CHIP_ID		43570
+#define BRCM_CC_4358_CHIP_ID		0x4358
 #define BRCM_CC_43602_CHIP_ID		43602
 
 /* USB Device IDs */
@@ -59,6 +60,7 @@
 #define BRCM_PCIE_4356_DEVICE_ID	0x43ec
 #define BRCM_PCIE_43567_DEVICE_ID	0x43d3
 #define BRCM_PCIE_43570_DEVICE_ID	0x43d9
+#define BRCM_PCIE_4358_DEVICE_ID	0x43e9
 #define BRCM_PCIE_43602_DEVICE_ID	0x43ba
 #define BRCM_PCIE_43602_2G_DEVICE_ID	0x43bb
 #define BRCM_PCIE_43602_5G_DEVICE_ID	0x43bc
-- 
1.9.1

