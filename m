Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62470 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbaAHJtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 04:49:39 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <linux-sunxi@googlegroups.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] brcmfmac: add support for bcm43362 device
Date: Wed, 8 Jan 2014 10:49:33 +0100
Message-ID: <1389174573-5204-1-git-send-email-arend@broadcom.com> (sfid-20140108_104944_422019_AE960239)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for the bcm43362 1x1 11n chipset. This
chipset is used in AP6210 wifi module found on Cubieboard [1].

[1] http://cubieboard.org/

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

Here a straggler for new device support that people
playing with Cubieboards have been asking for. Intended
for v3.14 kernel.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 +++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   33 ++++++++++++++++++++
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 4 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 68dd999..34c993d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -945,6 +945,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43362)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM,
 		     SDIO_DEVICE_ID_BROADCOM_4335_4339)},
 	{ /* end: all zeroes */ },
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2bf4757..9c7f08a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -509,6 +509,8 @@ enum brcmf_sdio_frmtype {
 #define BCM4334_NVRAM_NAME		"brcm/brcmfmac4334-sdio.txt"
 #define BCM4335_FIRMWARE_NAME		"brcm/brcmfmac4335-sdio.bin"
 #define BCM4335_NVRAM_NAME		"brcm/brcmfmac4335-sdio.txt"
+#define BCM43362_FIRMWARE_NAME		"brcm/brcmfmac43362-sdio.bin"
+#define BCM43362_NVRAM_NAME		"brcm/brcmfmac43362-sdio.txt"
 #define BCM4339_FIRMWARE_NAME		"brcm/brcmfmac4339-sdio.bin"
 #define BCM4339_NVRAM_NAME		"brcm/brcmfmac4339-sdio.txt"
 
@@ -526,6 +528,8 @@ MODULE_FIRMWARE(BCM4334_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4334_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4335_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4335_NVRAM_NAME);
+MODULE_FIRMWARE(BCM43362_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM43362_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4339_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4339_NVRAM_NAME);
 
@@ -552,6 +556,7 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BCM4330_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4330) },
 	{ BCM4334_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4334) },
 	{ BCM4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) },
+	{ BCM43362_CHIP_ID, 0xFFFFFFFE, BRCMF_FIRMWARE_NVRAM(BCM43362) },
 	{ BCM4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) }
 };
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index a0b8409..9fd4067 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -84,6 +84,17 @@ static const struct sdiod_drive_str sdiod_drvstr_tab1_1v8[] = {
 	{0, 0x1}
 };
 
+/* SDIO Drive Strength to sel value table for PMU Rev 13 (1.8v) */
+static const struct sdiod_drive_str sdiod_drive_strength_tab5_1v8[] = {
+        {6, 0x7},
+        {5, 0x6},
+        {4, 0x5},
+        {3, 0x4},
+        {2, 0x2},
+        {1, 0x1},
+        {0, 0x0}
+};
+
 /* SDIO Drive Strength to sel value table for PMU Rev 17 (1.8v) */
 static const struct sdiod_drive_str sdiod_drvstr_tab6_1v8[] = {
 	{3, 0x3},
@@ -577,6 +588,23 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->ramsize = 0xc0000;
 		ci->rambase = 0x180000;
 		break;
+	case BCM43362_CHIP_ID:
+		ci->c_inf[0].wrapbase = 0x18100000;
+		ci->c_inf[0].cib = 0x27004211;
+		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+		ci->c_inf[1].base = 0x18002000;
+		ci->c_inf[1].wrapbase = 0x18102000;
+		ci->c_inf[1].cib = 0x0a004211;
+		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+		ci->c_inf[2].base = 0x18004000;
+		ci->c_inf[2].wrapbase = 0x18104000;
+		ci->c_inf[2].cib = 0x08080401;
+		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+		ci->c_inf[3].base = 0x18003000;
+		ci->c_inf[3].wrapbase = 0x18103000;
+		ci->c_inf[3].cib = 0x03004211;
+		ci->ramsize = 0x3C000;
+		break;
 	default:
 		brcmf_err("chipid 0x%x is not supported\n", ci->chip);
 		return -ENODEV;
@@ -782,6 +810,11 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 				  brcmf_sdio_chip_name(ci->chip, chn, 8),
 				  drivestrength);
 		break;
+	case SDIOD_DRVSTR_KEY(BCM43362_CHIP_ID, 13):
+		str_tab = sdiod_drive_strength_tab5_1v8;
+		str_mask = 0x00003800;
+		str_shift = 11;
+		break;
 	default:
 		brcmf_err("No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
 			  brcmf_sdio_chip_name(ci->chip, chn, 8),
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 84113ea..6fa5d48 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -41,6 +41,7 @@
 #define BCM4331_CHIP_ID		0x4331
 #define BCM4334_CHIP_ID		0x4334
 #define BCM4335_CHIP_ID		0x4335
+#define BCM43362_CHIP_ID	43362
 #define BCM4339_CHIP_ID		0x4339
 
 #endif				/* _BRCM_HW_IDS_H_ */
-- 
1.7.10.4

