Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:53197 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbbCFRlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 12:41:00 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Syed Asifful Dayyan <syedd@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/5] brcmfmac: Add support for BCM4345 SDIO chipset.
Date: Fri, 6 Mar 2015 18:40:42 +0100
Message-ID: <1425663642-19725-6-git-send-email-arend@broadcom.com> (sfid-20150306_184105_785432_B2E1D73F)
In-Reply-To: <1425663642-19725-1-git-send-email-arend@broadcom.com>
References: <1425663642-19725-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Syed Asifful Dayyan <syedd@broadcom.com>

These changes add support for BCM4345 SDIO chipset.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Syed Asifful Dayyan <syedd@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c     | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/chip.c       | 4 ++++
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c       | 5 +++++
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h | 1 +
 include/linux/mmc/sdio_ids.h                         | 1 +
 5 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index ffb0e2d..4399530 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1096,6 +1096,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43341),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43362),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4335_4339),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4345),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
 	{ /* end: all zeroes */ }
 };
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index 04d2ca0..e679edc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -491,6 +491,10 @@ static void brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 	case BRCM_CC_43362_CHIP_ID:
 		ci->pub.ramsize = 0x3c000;
 		break;
+	case BRCM_CC_4345_CHIP_ID:
+		ci->pub.ramsize = 0xc8000;
+		ci->pub.rambase = 0x198000;
+		break;
 	case BRCM_CC_4339_CHIP_ID:
 	case BRCM_CC_4354_CHIP_ID:
 	case BRCM_CC_4356_CHIP_ID:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index c9a9ff1..973fa2a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -617,6 +617,8 @@ static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
 #define BCM43362_NVRAM_NAME		"brcm/brcmfmac43362-sdio.txt"
 #define BCM4339_FIRMWARE_NAME		"brcm/brcmfmac4339-sdio.bin"
 #define BCM4339_NVRAM_NAME		"brcm/brcmfmac4339-sdio.txt"
+#define BCM4345_FIRMWARE_NAME		"brcm/brcmfmac4345-sdio.bin"
+#define BCM4345_NVRAM_NAME		"brcm/brcmfmac4345-sdio.txt"
 #define BCM4354_FIRMWARE_NAME		"brcm/brcmfmac4354-sdio.bin"
 #define BCM4354_NVRAM_NAME		"brcm/brcmfmac4354-sdio.txt"
 
@@ -640,6 +642,8 @@ MODULE_FIRMWARE(BCM43362_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM43362_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4339_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4339_NVRAM_NAME);
+MODULE_FIRMWARE(BCM4345_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM4345_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4354_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4354_NVRAM_NAME);
 
@@ -669,6 +673,7 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BRCM_CC_4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) },
 	{ BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, BRCMF_FIRMWARE_NVRAM(BCM43362) },
 	{ BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) },
+	{ BRCM_CC_4345_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4345) },
 	{ BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4354) }
 };
 
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 2124a17..b599e7e 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -37,6 +37,7 @@
 #define BRCM_CC_43362_CHIP_ID		43362
 #define BRCM_CC_4335_CHIP_ID		0x4335
 #define BRCM_CC_4339_CHIP_ID		0x4339
+#define BRCM_CC_4345_CHIP_ID		0x4345
 #define BRCM_CC_4354_CHIP_ID		0x4354
 #define BRCM_CC_4356_CHIP_ID		0x4356
 #define BRCM_CC_43566_CHIP_ID		43566
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 9968079..9139785 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -33,6 +33,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_43341		0xa94d
 #define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
 #define SDIO_DEVICE_ID_BROADCOM_43362		0xa962
+#define SDIO_DEVICE_ID_BROADCOM_4345		0x4345
 #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
 
 #define SDIO_VENDOR_ID_INTEL			0x0089
-- 
1.9.1

