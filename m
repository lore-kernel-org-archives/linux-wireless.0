Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:55894 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaGLGtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:49:45 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/9] brcmfmac: Cleanup used device IDs.
Date: Sat, 12 Jul 2014 08:49:34 +0200
Message-ID: <1405147782-12768-2-git-send-email-arend@broadcom.com> (sfid-20140712_085011_206565_D58A566D)
In-Reply-To: <1405147782-12768-1-git-send-email-arend@broadcom.com>
References: <1405147782-12768-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

This patch cleans up used broadcom IDs, device IDs for all the
bus layers and uses consistent naming for all IDs.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   | 23 +++++----
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     | 28 +++++-----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 32 ++++++------
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      | 49 +++++++++---------
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   | 60 +++++++++++++++-------
 5 files changed, 107 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index a16e644..f467caf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -25,7 +25,6 @@
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/core.h>
 #include <linux/mmc/sdio_func.h>
-#include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 #include <linux/platform_device.h>
@@ -979,18 +978,20 @@ out:
 	return ret;
 }
 
+#define BRCMF_SDIO_DEVICE(dev_id)	\
+	{SDIO_DEVICE(BRCM_SDIO_VENDOR_ID_BROADCOM, dev_id)}
+
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43143)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43241)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43362)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM,
-		     SDIO_DEVICE_ID_BROADCOM_4335_4339)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4354)},
-	{ /* end: all zeroes */ },
+	BRCMF_SDIO_DEVICE(BRCM_SDIO_43143_DEVICE_ID),
+	BRCMF_SDIO_DEVICE(BRCM_SDIO_43241_DEVICE_ID),
+	BRCMF_SDIO_DEVICE(BRCM_SDIO_4329_DEVICE_ID),
+	BRCMF_SDIO_DEVICE(BRCM_SDIO_4330_DEVICE_ID),
+	BRCMF_SDIO_DEVICE(BRCM_SDIO_4334_DEVICE_ID),
+	BRCMF_SDIO_DEVICE(BRCM_SDIO_43362_DEVICE_ID),
+	BRCMF_SDIO_DEVICE(BRCM_SDIO_4335_4339_DEVICE_ID),
+	BRCMF_SDIO_DEVICE(BRCM_SDIO_4354_DEVICE_ID),
+	{ /* end: all zeroes */ }
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index c7c9f15..96800db 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -482,30 +482,30 @@ static inline int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 static void brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 {
 	switch (ci->pub.chip) {
-	case BCM4329_CHIP_ID:
+	case BRCM_CC_4329_CHIP_ID:
 		ci->pub.ramsize = BCM4329_RAMSIZE;
 		break;
-	case BCM43143_CHIP_ID:
+	case BRCM_CC_43143_CHIP_ID:
 		ci->pub.ramsize = BCM43143_RAMSIZE;
 		break;
-	case BCM43241_CHIP_ID:
+	case BRCM_CC_43241_CHIP_ID:
 		ci->pub.ramsize = 0x90000;
 		break;
-	case BCM4330_CHIP_ID:
+	case BRCM_CC_4330_CHIP_ID:
 		ci->pub.ramsize = 0x48000;
 		break;
-	case BCM4334_CHIP_ID:
+	case BRCM_CC_4334_CHIP_ID:
 		ci->pub.ramsize = 0x80000;
 		break;
-	case BCM4335_CHIP_ID:
+	case BRCM_CC_4335_CHIP_ID:
 		ci->pub.ramsize = 0xc0000;
 		ci->pub.rambase = 0x180000;
 		break;
-	case BCM43362_CHIP_ID:
+	case BRCM_CC_43362_CHIP_ID:
 		ci->pub.ramsize = 0x3c000;
 		break;
-	case BCM4339_CHIP_ID:
-	case BCM4354_CHIP_ID:
+	case BRCM_CC_4339_CHIP_ID:
+	case BRCM_CC_4354_CHIP_ID:
 		ci->pub.ramsize = 0xc0000;
 		ci->pub.rambase = 0x180000;
 		break;
@@ -682,7 +682,7 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 		  ci->pub.chiprev);
 
 	if (socitype == SOCI_SB) {
-		if (ci->pub.chip != BCM4329_CHIP_ID) {
+		if (ci->pub.chip != BRCM_CC_4329_CHIP_ID) {
 			brcmf_err("SB chip is not supported\n");
 			return -ENODEV;
 		}
@@ -1008,13 +1008,13 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 	chip = container_of(pub, struct brcmf_chip_priv, pub);
 
 	switch (pub->chip) {
-	case BCM4354_CHIP_ID:
+	case BRCM_CC_4354_CHIP_ID:
 		/* explicitly check SR engine enable bit */
 		pmu_cc3_mask = BIT(2);
 		/* fall-through */
-	case BCM43241_CHIP_ID:
-	case BCM4335_CHIP_ID:
-	case BCM4339_CHIP_ID:
+	case BRCM_CC_43241_CHIP_ID:
+	case BRCM_CC_4335_CHIP_ID:
+	case BRCM_CC_4339_CHIP_ID:
 		/* read PMU chipcontrol register 3 */
 		addr = CORE_CC_REG(base, chipcontrol_addr);
 		chip->ops->write32(chip->ctx, addr, 3);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 8fa0dbb..bf9bc2d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -620,16 +620,16 @@ enum brcmf_firmware_type {
 	name ## _FIRMWARE_NAME, name ## _NVRAM_NAME
 
 static const struct brcmf_firmware_names brcmf_fwname_data[] = {
-	{ BCM43143_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM43143) },
-	{ BCM43241_CHIP_ID, 0x0000001F, BRCMF_FIRMWARE_NVRAM(BCM43241B0) },
-	{ BCM43241_CHIP_ID, 0xFFFFFFE0, BRCMF_FIRMWARE_NVRAM(BCM43241B4) },
-	{ BCM4329_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4329) },
-	{ BCM4330_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4330) },
-	{ BCM4334_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4334) },
-	{ BCM4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) },
-	{ BCM43362_CHIP_ID, 0xFFFFFFFE, BRCMF_FIRMWARE_NVRAM(BCM43362) },
-	{ BCM4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) },
-	{ BCM4354_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4354) }
+	{ BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM43143) },
+	{ BRCM_CC_43241_CHIP_ID, 0x0000001F, BRCMF_FIRMWARE_NVRAM(BCM43241B0) },
+	{ BRCM_CC_43241_CHIP_ID, 0xFFFFFFE0, BRCMF_FIRMWARE_NVRAM(BCM43241B4) },
+	{ BRCM_CC_4329_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4329) },
+	{ BRCM_CC_4330_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4330) },
+	{ BRCM_CC_4334_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4334) },
+	{ BRCM_CC_4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) },
+	{ BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, BRCMF_FIRMWARE_NVRAM(BCM43362) },
+	{ BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) },
+	{ BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4354) }
 };
 
 static const char *brcmf_sdio_get_fwname(struct brcmf_chip *ci,
@@ -3598,17 +3598,17 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		return;
 
 	switch (SDIOD_DRVSTR_KEY(ci->chip, ci->pmurev)) {
-	case SDIOD_DRVSTR_KEY(BCM4330_CHIP_ID, 12):
+	case SDIOD_DRVSTR_KEY(BRCM_CC_4330_CHIP_ID, 12):
 		str_tab = sdiod_drvstr_tab1_1v8;
 		str_mask = 0x00003800;
 		str_shift = 11;
 		break;
-	case SDIOD_DRVSTR_KEY(BCM4334_CHIP_ID, 17):
+	case SDIOD_DRVSTR_KEY(BRCM_CC_4334_CHIP_ID, 17):
 		str_tab = sdiod_drvstr_tab6_1v8;
 		str_mask = 0x00001800;
 		str_shift = 11;
 		break;
-	case SDIOD_DRVSTR_KEY(BCM43143_CHIP_ID, 17):
+	case SDIOD_DRVSTR_KEY(BRCM_CC_43143_CHIP_ID, 17):
 		/* note: 43143 does not support tristate */
 		i = ARRAY_SIZE(sdiod_drvstr_tab2_3v3) - 1;
 		if (drivestrength >= sdiod_drvstr_tab2_3v3[i].strength) {
@@ -3619,7 +3619,7 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 			brcmf_err("Invalid SDIO Drive strength for chip %s, strength=%d\n",
 				  ci->name, drivestrength);
 		break;
-	case SDIOD_DRVSTR_KEY(BCM43362_CHIP_ID, 13):
+	case SDIOD_DRVSTR_KEY(BRCM_CC_43362_CHIP_ID, 13):
 		str_tab = sdiod_drive_strength_tab5_1v8;
 		str_mask = 0x00003800;
 		str_shift = 11;
@@ -3720,12 +3720,12 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 	u32 val, rev;
 
 	val = brcmf_sdiod_regrl(sdiodev, addr, NULL);
-	if (sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 &&
+	if (sdiodev->func[0]->device == BRCM_SDIO_4335_4339_DEVICE_ID &&
 	    addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
 		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
 		if (rev >= 2) {
 			val &= ~CID_ID_MASK;
-			val |= BCM4339_CHIP_ID;
+			val |= BRCM_CC_4339_CHIP_ID;
 		}
 	}
 	return val;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index b732a99..dc13591 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -21,6 +21,7 @@
 #include <linux/vmalloc.h>
 
 #include <brcmu_utils.h>
+#include <brcm_hw_ids.h>
 #include <brcmu_wifi.h>
 #include <dhd_bus.h>
 #include <dhd_dbg.h>
@@ -913,16 +914,16 @@ static int brcmf_usb_dlrun(struct brcmf_usbdev_info *devinfo)
 static bool brcmf_usb_chip_support(int chipid, int chiprev)
 {
 	switch(chipid) {
-	case 43143:
+	case BRCM_CC_43143_CHIP_ID:
 		return true;
-	case 43235:
-	case 43236:
-	case 43238:
+	case BRCM_CC_43235_CHIP_ID:
+	case BRCM_CC_43236_CHIP_ID:
+	case BRCM_CC_43238_CHIP_ID:
 		return (chiprev == 3);
-	case 43242:
+	case BRCM_CC_43242_CHIP_ID:
 		return true;
-	case 43566:
-	case 43569:
+	case BRCM_CC_43566_CHIP_ID:
+	case BRCM_CC_43569_CHIP_ID:
 		return true;
 	default:
 		break;
@@ -1016,16 +1017,16 @@ static int check_file(const u8 *headers)
 static const char *brcmf_usb_get_fwname(struct brcmf_usbdev_info *devinfo)
 {
 	switch (devinfo->bus_pub.devid) {
-	case 43143:
+	case BRCM_CC_43143_CHIP_ID:
 		return BRCMF_USB_43143_FW_NAME;
-	case 43235:
-	case 43236:
-	case 43238:
+	case BRCM_CC_43235_CHIP_ID:
+	case BRCM_CC_43236_CHIP_ID:
+	case BRCM_CC_43238_CHIP_ID:
 		return BRCMF_USB_43236_FW_NAME;
-	case 43242:
+	case BRCM_CC_43242_CHIP_ID:
 		return BRCMF_USB_43242_FW_NAME;
-	case 43566:
-	case 43569:
+	case BRCM_CC_43566_CHIP_ID:
+	case BRCM_CC_43569_CHIP_ID:
 		return BRCMF_USB_43569_FW_NAME;
 	default:
 		return NULL;
@@ -1366,21 +1367,17 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
 				      brcmf_usb_probe_phase2);
 }
 
-#define BRCMF_USB_VENDOR_ID_BROADCOM	0x0a5c
-#define BRCMF_USB_DEVICE_ID_43143	0xbd1e
-#define BRCMF_USB_DEVICE_ID_43236	0xbd17
-#define BRCMF_USB_DEVICE_ID_43242	0xbd1f
-#define BRCMF_USB_DEVICE_ID_43569	0xbd27
-#define BRCMF_USB_DEVICE_ID_BCMFW	0x0bdc
+#define BRCMF_USB_DEVICE(dev_id)	\
+	{ USB_DEVICE(BRCM_USB_VENDOR_ID_BROADCOM, dev_id) }
 
 static struct usb_device_id brcmf_usb_devid_table[] = {
-	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43143) },
-	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43236) },
-	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43242) },
-	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_43569) },
+	BRCMF_USB_DEVICE(BRCM_USB_43143_DEVICE_ID),
+	BRCMF_USB_DEVICE(BRCM_USB_43236_DEVICE_ID),
+	BRCMF_USB_DEVICE(BRCM_USB_43242_DEVICE_ID),
+	BRCMF_USB_DEVICE(BRCM_USB_43569_DEVICE_ID),
 	/* special entry for device with firmware loaded and running */
-	{ USB_DEVICE(BRCMF_USB_VENDOR_ID_BROADCOM, BRCMF_USB_DEVICE_ID_BCMFW) },
-	{ }
+	BRCMF_USB_DEVICE(BRCM_USB_BCMFW_DEVICE_ID),
+	{ /* end: all zeroes */ }
 };
 
 MODULE_DEVICE_TABLE(usb, brcmf_usb_devid_table);
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index d816270..64d1a7b 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -17,32 +17,56 @@
 #ifndef	_BRCM_HW_IDS_H_
 #define	_BRCM_HW_IDS_H_
 
-#define BCM4313_D11N2G_ID	0x4727	/* 4313 802.11n 2.4G device */
+#include <linux/pci_ids.h>
+#include <linux/mmc/sdio_ids.h>
+
+#define BRCM_USB_VENDOR_ID_BROADCOM	0x0a5c
+#define BRCM_PCIE_VENDOR_ID_BROADCOM	PCI_VENDOR_ID_BROADCOM
+#define BRCM_SDIO_VENDOR_ID_BROADCOM	SDIO_VENDOR_ID_BROADCOM
+
+/* Chipcommon Core Chip IDs */
+#define BRCM_CC_43143_CHIP_ID		43143
+#define BRCM_CC_43235_CHIP_ID		43235
+#define BRCM_CC_43236_CHIP_ID		43236
+#define BRCM_CC_43238_CHIP_ID		43238
+#define BRCM_CC_43241_CHIP_ID		0x4324
+#define BRCM_CC_43242_CHIP_ID		43242
+#define BRCM_CC_4329_CHIP_ID		0x4329
+#define BRCM_CC_4330_CHIP_ID		0x4330
+#define BRCM_CC_4334_CHIP_ID		0x4334
+#define BRCM_CC_43362_CHIP_ID		43362
+#define BRCM_CC_4335_CHIP_ID		0x4335
+#define BRCM_CC_4339_CHIP_ID		0x4339
+#define BRCM_CC_4354_CHIP_ID		0x4354
+#define BRCM_CC_43566_CHIP_ID		43566
+#define BRCM_CC_43569_CHIP_ID		43569
+
+/* SDIO Device IDs */
+#define BRCM_SDIO_43143_DEVICE_ID	BRCM_CC_43143_CHIP_ID
+#define BRCM_SDIO_43241_DEVICE_ID	BRCM_CC_43241_CHIP_ID
+#define BRCM_SDIO_4329_DEVICE_ID	BRCM_CC_4329_CHIP_ID
+#define BRCM_SDIO_4330_DEVICE_ID	BRCM_CC_4330_CHIP_ID
+#define BRCM_SDIO_4334_DEVICE_ID	BRCM_CC_4334_CHIP_ID
+#define BRCM_SDIO_43362_DEVICE_ID	BRCM_CC_43362_CHIP_ID
+#define BRCM_SDIO_4335_4339_DEVICE_ID	BRCM_CC_4335_CHIP_ID
+#define BRCM_SDIO_4354_DEVICE_ID	BRCM_CC_4354_CHIP_ID
 
+/* USB Device IDs */
+#define BRCM_USB_43143_DEVICE_ID	0xbd1e
+#define BRCM_USB_43236_DEVICE_ID	0xbd17
+#define BRCM_USB_43242_DEVICE_ID	0xbd1f
+#define BRCM_USB_43569_DEVICE_ID	0xbd27
+#define BRCM_USB_BCMFW_DEVICE_ID	0x0bdc
+
+/* brcmsmac IDs */
+#define BCM4313_D11N2G_ID	0x4727	/* 4313 802.11n 2.4G device */
 #define BCM43224_D11N_ID	0x4353	/* 43224 802.11n dualband device */
 #define BCM43224_D11N_ID_VEN1	0x0576	/* Vendor specific 43224 802.11n db */
-
 #define BCM43225_D11N2G_ID	0x4357	/* 43225 802.11n 2.4GHz device */
-
 #define BCM43236_D11N_ID	0x4346	/* 43236 802.11n dualband device */
 #define BCM43236_D11N2G_ID	0x4347	/* 43236 802.11n 2.4GHz device */
 
-/* Chipcommon Core Chip IDs */
 #define BCM4313_CHIP_ID		0x4313
-#define BCM43143_CHIP_ID	43143
 #define BCM43224_CHIP_ID	43224
-#define BCM43225_CHIP_ID	43225
-#define BCM43235_CHIP_ID	43235
-#define BCM43236_CHIP_ID	43236
-#define BCM43238_CHIP_ID	43238
-#define BCM43241_CHIP_ID	0x4324
-#define BCM4329_CHIP_ID		0x4329
-#define BCM4330_CHIP_ID		0x4330
-#define BCM4331_CHIP_ID		0x4331
-#define BCM4334_CHIP_ID		0x4334
-#define BCM4335_CHIP_ID		0x4335
-#define BCM43362_CHIP_ID	43362
-#define BCM4339_CHIP_ID		0x4339
-#define BCM4354_CHIP_ID		0x4354
 
 #endif				/* _BRCM_HW_IDS_H_ */
-- 
1.9.1

