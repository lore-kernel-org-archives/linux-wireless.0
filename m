Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:32911 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdHAJjf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:39:35 -0400
From: Wright Feng <wright.feng@cypress.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Subject: [PATCH 2/3] brcmfmac: Add support for CYW4373 SDIO/USB chipset
Date: Tue,  1 Aug 2017 16:48:06 +0800
Message-Id: <1501577287-28904-2-git-send-email-wright.feng@cypress.com> (sfid-20170801_113940_474761_972E0694)
In-Reply-To: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>

These changes add support for CYW4373 SDIO/USB chipset.

Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c     | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c       | 4 +++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c        | 9 ++++++++-
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 3 +++
 include/linux/mmc/sdio_ids.h                                  | 1 +
 6 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9b970dc..ea47f75 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1108,6 +1108,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_4373),
 	{ /* end: all zeroes */ }
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 05f22ff..c5d1a1c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -690,6 +690,8 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_4365_CHIP_ID:
 	case BRCM_CC_4366_CHIP_ID:
 		return 0x200000;
+	case CY_CC_4373_CHIP_ID:
+		return 0x160000;
 	default:
 		brcmf_err("unknown chip: %s\n", ci->pub.name);
 		break;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 5653d6d..b1789b1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -616,6 +616,7 @@ struct sdiod_drive_str {
 BRCMF_FW_NVRAM_DEF(43455, "brcmfmac43455-sdio.bin", "brcmfmac43455-sdio.txt");
 BRCMF_FW_NVRAM_DEF(4354, "brcmfmac4354-sdio.bin", "brcmfmac4354-sdio.txt");
 BRCMF_FW_NVRAM_DEF(4356, "brcmfmac4356-sdio.bin", "brcmfmac4356-sdio.txt");
+BRCMF_FW_NVRAM_DEF(4373, "brcmfmac4373-sdio.bin", "brcmfmac4373-sdio.txt");
 
 static struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
@@ -633,7 +634,8 @@ struct sdiod_drive_str {
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43430_CHIP_ID, 0xFFFFFFFF, 43430),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFFC0, 43455),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
-	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356)
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356),
+	BRCMF_FW_NVRAM_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373)
 };
 
 static void pkt_align(struct sk_buff *p, int len, int align)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 0eea48e..8f20a4b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -50,6 +50,7 @@
 BRCMF_FW_DEF(43236B, "brcmfmac43236b.bin");
 BRCMF_FW_DEF(43242A, "brcmfmac43242a.bin");
 BRCMF_FW_DEF(43569, "brcmfmac43569.bin");
+BRCMF_FW_DEF(4373, "brcmfmac4373.bin");
 
 static struct brcmf_firmware_mapping brcmf_usb_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
@@ -58,7 +59,8 @@
 	BRCMF_FW_ENTRY(BRCM_CC_43238_CHIP_ID, 0x00000008, 43236B),
 	BRCMF_FW_ENTRY(BRCM_CC_43242_CHIP_ID, 0xFFFFFFFF, 43242A),
 	BRCMF_FW_ENTRY(BRCM_CC_43566_CHIP_ID, 0xFFFFFFFF, 43569),
-	BRCMF_FW_ENTRY(BRCM_CC_43569_CHIP_ID, 0xFFFFFFFF, 43569)
+	BRCMF_FW_ENTRY(BRCM_CC_43569_CHIP_ID, 0xFFFFFFFF, 43569),
+	BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373)
 };
 
 #define TRX_MAGIC		0x30524448	/* "HDR0" */
@@ -1463,15 +1465,20 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
 #define LINKSYS_USB_DEVICE(dev_id)	\
 	{ USB_DEVICE(BRCM_USB_VENDOR_ID_LINKSYS, dev_id) }
 
+#define CYPRESS_USB_DEVICE(dev_id)	\
+	{ USB_DEVICE(CY_USB_VENDOR_ID_CYPRESS, dev_id) }
+
 static struct usb_device_id brcmf_usb_devid_table[] = {
 	BRCMF_USB_DEVICE(BRCM_USB_43143_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43236_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43242_DEVICE_ID),
 	BRCMF_USB_DEVICE(BRCM_USB_43569_DEVICE_ID),
 	LINKSYS_USB_DEVICE(BRCM_USB_43235_LINKSYS_DEVICE_ID),
+	CYPRESS_USB_DEVICE(CY_USB_4373_DEVICE_ID),
 	{ USB_DEVICE(BRCM_USB_VENDOR_ID_LG, BRCM_USB_43242_LG_DEVICE_ID) },
 	/* special entry for device with firmware loaded and running */
 	BRCMF_USB_DEVICE(BRCM_USB_BCMFW_DEVICE_ID),
+	CYPRESS_USB_DEVICE(BRCM_USB_BCMFW_DEVICE_ID),
 	{ /* end: all zeroes */ }
 };
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index f1fb8a3..57544a3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -23,6 +23,7 @@
 #define BRCM_USB_VENDOR_ID_BROADCOM	0x0a5c
 #define BRCM_USB_VENDOR_ID_LG		0x043e
 #define BRCM_USB_VENDOR_ID_LINKSYS	0x13b1
+#define CY_USB_VENDOR_ID_CYPRESS	0x04b4
 #define BRCM_PCIE_VENDOR_ID_BROADCOM	PCI_VENDOR_ID_BROADCOM
 
 /* Chipcommon Core Chip IDs */
@@ -57,6 +58,7 @@
 #define BRCM_CC_4365_CHIP_ID		0x4365
 #define BRCM_CC_4366_CHIP_ID		0x4366
 #define BRCM_CC_4371_CHIP_ID		0x4371
+#define CY_CC_4373_CHIP_ID		0x4373
 
 /* USB Device IDs */
 #define BRCM_USB_43143_DEVICE_ID	0xbd1e
@@ -66,6 +68,7 @@
 #define BRCM_USB_43242_LG_DEVICE_ID	0x3101
 #define BRCM_USB_43569_DEVICE_ID	0xbd27
 #define BRCM_USB_BCMFW_DEVICE_ID	0x0bdc
+#define CY_USB_4373_DEVICE_ID		0xbd29
 
 /* PCIE Device IDs */
 #define BRCM_PCIE_4350_DEVICE_ID	0x43a3
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index b733eb4..abacd54 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -39,6 +39,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
 #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
 #define SDIO_DEVICE_ID_BROADCOM_4356		0x4356
+#define SDIO_DEVICE_ID_CYPRESS_4373		0x4373
 
 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
-- 
1.9.1
