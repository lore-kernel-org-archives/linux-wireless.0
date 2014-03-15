Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45742 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbaCOQSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 12:18:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/5] brcmfmac: add BCM4354 SDIO interface support
Date: Sat, 15 Mar 2014 17:18:17 +0100
Message-ID: <1394900301-15417-2-git-send-email-arend@broadcom.com> (sfid-20140315_171839_092706_00491337)
In-Reply-To: <1394900301-15417-1-git-send-email-arend@broadcom.com>
References: <1394900301-15417-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

BCM4354 is an a/b/g/n/ac 2x2 WiFi chip. This patch adds support for it through
SDIO interface.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     |    5 +++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    7 ++++++-
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 include/linux/mmc/sdio_ids.h                       |    1 +
 5 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index d737cf7..6e8718b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -988,6 +988,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43362)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM,
 		     SDIO_DEVICE_ID_BROADCOM_4335_4339)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4354)},
 	{ /* end: all zeroes */ },
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index a07b95e..df130ef 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -504,6 +504,7 @@ static void brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 		ci->pub.ramsize = 0x3c000;
 		break;
 	case BCM4339_CHIP_ID:
+	case BCM4354_CHIP_ID:
 		ci->pub.ramsize = 0xc0000;
 		ci->pub.rambase = 0x180000;
 		break;
@@ -1006,6 +1007,10 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 	chip = container_of(pub, struct brcmf_chip_priv, pub);
 
 	switch (pub->chip) {
+	case BCM4354_CHIP_ID:
+		/* explicitly check SR engine enable bit */
+		pmu_cc3_mask = BIT(2);
+		/* fall-through */
 	case BCM43241_CHIP_ID:
 	case BCM4335_CHIP_ID:
 	case BCM4339_CHIP_ID:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a111b6f..4aa8678 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -578,6 +578,8 @@ static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
 #define BCM43362_NVRAM_NAME		"brcm/brcmfmac43362-sdio.txt"
 #define BCM4339_FIRMWARE_NAME		"brcm/brcmfmac4339-sdio.bin"
 #define BCM4339_NVRAM_NAME		"brcm/brcmfmac4339-sdio.txt"
+#define BCM4354_FIRMWARE_NAME		"brcm/brcmfmac4354-sdio.bin"
+#define BCM4354_NVRAM_NAME		"brcm/brcmfmac4354-sdio.txt"
 
 MODULE_FIRMWARE(BCM43143_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM43143_NVRAM_NAME);
@@ -597,6 +599,8 @@ MODULE_FIRMWARE(BCM43362_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM43362_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4339_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4339_NVRAM_NAME);
+MODULE_FIRMWARE(BCM4354_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM4354_NVRAM_NAME);
 
 struct brcmf_firmware_names {
 	u32 chipid;
@@ -622,7 +626,8 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BCM4334_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4334) },
 	{ BCM4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) },
 	{ BCM43362_CHIP_ID, 0xFFFFFFFE, BRCMF_FIRMWARE_NVRAM(BCM43362) },
-	{ BCM4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) }
+	{ BCM4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) },
+	{ BCM4354_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4354) }
 };
 
 
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 6fa5d48..d816270 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -43,5 +43,6 @@
 #define BCM4335_CHIP_ID		0x4335
 #define BCM43362_CHIP_ID	43362
 #define BCM4339_CHIP_ID		0x4339
+#define BCM4354_CHIP_ID		0x4354
 
 #endif				/* _BRCM_HW_IDS_H_ */
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index d883662..0f01fe0 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -31,6 +31,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_4334		0x4334
 #define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
 #define SDIO_DEVICE_ID_BROADCOM_43362		43362
+#define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
 
 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
-- 
1.7.9.5

