Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:48528 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaLULoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 06:44:02 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Rob Herring <rob.herring@linaro.org>,
	John Stultz <john.stultz@linaro.org>
Subject: [PATCH 03/10] brcmfmac: Add support for bcm43340/1 wireless chipsets
Date: Sun, 21 Dec 2014 12:43:46 +0100
Message-ID: <1419162233-19492-4-git-send-email-arend@broadcom.com> (sfid-20141221_124417_997216_B0632AF1)
In-Reply-To: <1419162233-19492-1-git-send-email-arend@broadcom.com>
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for the bcm43340 and bcm43341 wireless
chipsets. These two chipsets are identical from wireless parts
perspective. As such they use the same firmware image.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Rob Herring <rob.herring@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
[arend@broadcom.com: squash to single commit, remove 43341 chipid]
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c     | 2 ++
 drivers/net/wireless/brcm80211/brcmfmac/chip.c       | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c       | 5 +++++
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h | 3 +++
 include/linux/mmc/sdio_ids.h                         | 2 ++
 5 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 9583dcd..7cf42e56 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1005,6 +1005,8 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	BRCMF_SDIO_DEVICE(BRCM_SDIO_4329_DEVICE_ID),
 	BRCMF_SDIO_DEVICE(BRCM_SDIO_4330_DEVICE_ID),
 	BRCMF_SDIO_DEVICE(BRCM_SDIO_4334_DEVICE_ID),
+	BRCMF_SDIO_DEVICE(BRCM_SDIO_43340_DEVICE_ID),
+	BRCMF_SDIO_DEVICE(BRCM_SDIO_43341_DEVICE_ID),
 	BRCMF_SDIO_DEVICE(BRCM_SDIO_43362_DEVICE_ID),
 	BRCMF_SDIO_DEVICE(BRCM_SDIO_4335_4339_DEVICE_ID),
 	BRCMF_SDIO_DEVICE(BRCM_SDIO_4354_DEVICE_ID),
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index ddae0b5..0393d84 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -495,6 +495,7 @@ static void brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 		ci->pub.ramsize = 0x48000;
 		break;
 	case BRCM_CC_4334_CHIP_ID:
+	case BRCM_CC_43340_CHIP_ID:
 		ci->pub.ramsize = 0x80000;
 		break;
 	case BRCM_CC_4335_CHIP_ID:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 0b0d51a..551da35 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -608,6 +608,8 @@ static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
 #define BCM4330_NVRAM_NAME		"brcm/brcmfmac4330-sdio.txt"
 #define BCM4334_FIRMWARE_NAME		"brcm/brcmfmac4334-sdio.bin"
 #define BCM4334_NVRAM_NAME		"brcm/brcmfmac4334-sdio.txt"
+#define BCM43340_FIRMWARE_NAME		"brcm/brcmfmac43340-sdio.bin"
+#define BCM43340_NVRAM_NAME		"brcm/brcmfmac43340-sdio.txt"
 #define BCM4335_FIRMWARE_NAME		"brcm/brcmfmac4335-sdio.bin"
 #define BCM4335_NVRAM_NAME		"brcm/brcmfmac4335-sdio.txt"
 #define BCM43362_FIRMWARE_NAME		"brcm/brcmfmac43362-sdio.bin"
@@ -629,6 +631,8 @@ MODULE_FIRMWARE(BCM4330_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4330_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4334_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4334_NVRAM_NAME);
+MODULE_FIRMWARE(BCM43340_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM43340_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4335_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4335_NVRAM_NAME);
 MODULE_FIRMWARE(BCM43362_FIRMWARE_NAME);
@@ -660,6 +664,7 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BRCM_CC_4329_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4329) },
 	{ BRCM_CC_4330_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4330) },
 	{ BRCM_CC_4334_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4334) },
+	{ BRCM_CC_43340_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM43340) },
 	{ BRCM_CC_4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) },
 	{ BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, BRCMF_FIRMWARE_NVRAM(BCM43362) },
 	{ BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) },
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 6996fcc..00215ef 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -34,6 +34,7 @@
 #define BRCM_CC_4329_CHIP_ID		0x4329
 #define BRCM_CC_4330_CHIP_ID		0x4330
 #define BRCM_CC_4334_CHIP_ID		0x4334
+#define BRCM_CC_43340_CHIP_ID		43340
 #define BRCM_CC_43362_CHIP_ID		43362
 #define BRCM_CC_4335_CHIP_ID		0x4335
 #define BRCM_CC_4339_CHIP_ID		0x4339
@@ -51,6 +52,8 @@
 #define BRCM_SDIO_4329_DEVICE_ID	BRCM_CC_4329_CHIP_ID
 #define BRCM_SDIO_4330_DEVICE_ID	BRCM_CC_4330_CHIP_ID
 #define BRCM_SDIO_4334_DEVICE_ID	BRCM_CC_4334_CHIP_ID
+#define BRCM_SDIO_43340_DEVICE_ID	BRCM_CC_43340_CHIP_ID
+#define BRCM_SDIO_43341_DEVICE_ID	43341
 #define BRCM_SDIO_43362_DEVICE_ID	BRCM_CC_43362_CHIP_ID
 #define BRCM_SDIO_4335_4339_DEVICE_ID	BRCM_CC_4335_CHIP_ID
 #define BRCM_SDIO_4354_DEVICE_ID	BRCM_CC_4354_CHIP_ID
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 0f01fe0..61f8318 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -29,6 +29,8 @@
 #define SDIO_DEVICE_ID_BROADCOM_4329		0x4329
 #define SDIO_DEVICE_ID_BROADCOM_4330		0x4330
 #define SDIO_DEVICE_ID_BROADCOM_4334		0x4334
+#define SDIO_DEVICE_ID_BROADCOM_43340		43340
+#define SDIO_DEVICE_ID_BROADCOM_43341		43341
 #define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
 #define SDIO_DEVICE_ID_BROADCOM_43362		43362
 #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
-- 
1.9.1

