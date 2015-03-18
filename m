Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:55701 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbbCRMZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 08:25:36 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/8] brcmfmac: add support for BCM43430 SDIO chipset
Date: Wed, 18 Mar 2015 13:25:26 +0100
Message-ID: <1426681528-15831-7-git-send-email-arend@broadcom.com> (sfid-20150318_132548_990233_8E0F400B)
In-Reply-To: <1426681528-15831-1-git-send-email-arend@broadcom.com>
References: <1426681528-15831-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch added support for the BCM43430 802.11n SDIO chipset.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c     |  1 +
 drivers/net/wireless/brcm80211/brcmfmac/chip.c       | 18 ++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c       |  5 +++++
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h |  1 +
 drivers/net/wireless/brcm80211/include/chipcommon.h  |  9 ++++++++-
 include/linux/mmc/sdio_ids.h                         |  1 +
 6 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 9667b6a..9b508bd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1098,6 +1098,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43341),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43362),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4335_4339),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43430),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4345),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
 	{ /* end: all zeroes */ }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index 7341725..ab2fac8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -600,6 +600,12 @@ static void brcmf_chip_socram_ramsize(struct brcmf_core_priv *sr, u32 *ramsize,
 		if (sr->chip->pub.chiprev < 2)
 			*srsize = (32 * 1024);
 		break;
+	case BRCM_CC_43430_CHIP_ID:
+		/* assume sr for now as we can not check
+		 * firmware sr capability at this point.
+		 */
+		*srsize = (64 * 1024);
+		break;
 	default:
 		break;
 	}
@@ -1072,6 +1078,7 @@ static void
 brcmf_chip_cm3_set_passive(struct brcmf_chip_priv *chip)
 {
 	struct brcmf_core *core;
+	struct brcmf_core_priv *sr;
 
 	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CM3);
 	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_80211);
@@ -1081,6 +1088,13 @@ brcmf_chip_cm3_set_passive(struct brcmf_chip_priv *chip)
 			     D11_BCMA_IOCTL_PHYCLOCKEN);
 	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_INTERNAL_MEM);
 	brcmf_chip_resetcore(core, 0, 0, 0);
+
+	/* disable bank #3 remap for this device */
+	if (chip->pub.chip == BRCM_CC_43430_CHIP_ID) {
+		sr = container_of(core, struct brcmf_core_priv, pub);
+		brcmf_chip_core_write32(sr, SOCRAMREGOFFS(bankidx), 3);
+		brcmf_chip_core_write32(sr, SOCRAMREGOFFS(bankpda), 0);
+	}
 }
 
 static bool brcmf_chip_cm3_set_active(struct brcmf_chip_priv *chip)
@@ -1188,6 +1202,10 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 		addr = CORE_CC_REG(base, chipcontrol_data);
 		reg = chip->ops->read32(chip->ctx, addr);
 		return (reg & pmu_cc3_mask) != 0;
+	case BRCM_CC_43430_CHIP_ID:
+		addr = CORE_CC_REG(base, sr_control1);
+		reg = chip->ops->read32(chip->ctx, addr);
+		return reg != 0;
 	default:
 		addr = CORE_CC_REG(base, pmucapabilities_ext);
 		reg = chip->ops->read32(chip->ctx, addr);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 38fa0e8..e162860 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -615,6 +615,8 @@ static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
 #define BCM43362_NVRAM_NAME		"brcm/brcmfmac43362-sdio.txt"
 #define BCM4339_FIRMWARE_NAME		"brcm/brcmfmac4339-sdio.bin"
 #define BCM4339_NVRAM_NAME		"brcm/brcmfmac4339-sdio.txt"
+#define BCM43430_FIRMWARE_NAME		"brcm/brcmfmac43430-sdio.bin"
+#define BCM43430_NVRAM_NAME		"brcm/brcmfmac43430-sdio.txt"
 #define BCM4345_FIRMWARE_NAME		"brcm/brcmfmac4345-sdio.bin"
 #define BCM4345_NVRAM_NAME		"brcm/brcmfmac4345-sdio.txt"
 #define BCM4354_FIRMWARE_NAME		"brcm/brcmfmac4354-sdio.bin"
@@ -640,6 +642,8 @@ MODULE_FIRMWARE(BCM43362_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM43362_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4339_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4339_NVRAM_NAME);
+MODULE_FIRMWARE(BCM43430_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM43430_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4345_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4345_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4354_FIRMWARE_NAME);
@@ -671,6 +675,7 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BRCM_CC_4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) },
 	{ BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, BRCMF_FIRMWARE_NVRAM(BCM43362) },
 	{ BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) },
+	{ BRCM_CC_43430_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM43430) },
 	{ BRCM_CC_4345_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4345) },
 	{ BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4354) }
 };
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index b599e7e..4efdd51 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -37,6 +37,7 @@
 #define BRCM_CC_43362_CHIP_ID		43362
 #define BRCM_CC_4335_CHIP_ID		0x4335
 #define BRCM_CC_4339_CHIP_ID		0x4339
+#define BRCM_CC_43430_CHIP_ID		43430
 #define BRCM_CC_4345_CHIP_ID		0x4345
 #define BRCM_CC_4354_CHIP_ID		0x4354
 #define BRCM_CC_4356_CHIP_ID		0x4356
diff --git a/drivers/net/wireless/brcm80211/include/chipcommon.h b/drivers/net/wireless/brcm80211/include/chipcommon.h
index d242333..e1fd499 100644
--- a/drivers/net/wireless/brcm80211/include/chipcommon.h
+++ b/drivers/net/wireless/brcm80211/include/chipcommon.h
@@ -183,7 +183,14 @@ struct chipcregs {
 	u8 uart1lsr;
 	u8 uart1msr;
 	u8 uart1scratch;
-	u32 PAD[126];
+	u32 PAD[62];
+
+	/* save/restore, corerev >= 48 */
+	u32 sr_capability;          /* 0x500 */
+	u32 sr_control0;            /* 0x504 */
+	u32 sr_control1;            /* 0x508 */
+	u32 gpio_control;           /* 0x50C */
+	u32 PAD[60];
 
 	/* PMU registers (corerev >= 20) */
 	u32 pmucontrol;	/* 0x600 */
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 9139785..83430f2 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -33,6 +33,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_43341		0xa94d
 #define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
 #define SDIO_DEVICE_ID_BROADCOM_43362		0xa962
+#define SDIO_DEVICE_ID_BROADCOM_43430		0xa9a6
 #define SDIO_DEVICE_ID_BROADCOM_4345		0x4345
 #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
 
-- 
1.9.1

