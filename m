Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35340 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbcEEAz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2016 20:55:28 -0400
Received: by mail-pa0-f51.google.com with SMTP id iv1so29724213pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2016 17:55:28 -0700 (PDT)
From: Christian Daudt <csd@broadcom.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Daudt <csd@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: [PATCH] brcmfmac: Add 4356 sdio support
Date: Wed,  4 May 2016 17:55:20 -0700
Message-Id: <1462409720-5641-1-git-send-email-csd@broadcom.com> (sfid-20160505_025532_482700_C704DA1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for the 4356-sdio wireless chip.

Signed-off-by: Christian Daudt <csd@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 4 +++-
 include/linux/mmc/sdio_ids.h                              | 1 +
 4 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index da0cdd3..a01039a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1098,6 +1098,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43430),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4345),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
 	{ /* end: all zeroes */ }
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 0e8f2a0..d3fd6b1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1333,6 +1333,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 
 	switch (pub->chip) {
 	case BRCM_CC_4354_CHIP_ID:
+	case BRCM_CC_4356_CHIP_ID:
 		/* explicitly check SR engine enable bit */
 		pmu_cc3_mask = BIT(2);
 		/* fall-through */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 43fd3f4..da8abff 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -612,6 +612,7 @@ BRCMF_FW_NVRAM_DEF(4339, "brcmfmac4339-sdio.bin", "brcmfmac4339-sdio.txt");
 BRCMF_FW_NVRAM_DEF(43430, "brcmfmac43430-sdio.bin", "brcmfmac43430-sdio.txt");
 BRCMF_FW_NVRAM_DEF(43455, "brcmfmac43455-sdio.bin", "brcmfmac43455-sdio.txt");
 BRCMF_FW_NVRAM_DEF(4354, "brcmfmac4354-sdio.bin", "brcmfmac4354-sdio.txt");
+BRCMF_FW_NVRAM_DEF(4356, "brcmfmac4356-sdio.bin", "brcmfmac4356-sdio.txt");
 
 static struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
@@ -627,7 +628,8 @@ static struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, 4339),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43430_CHIP_ID, 0xFFFFFFFF, 43430),
 	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFFC0, 43455),
-	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354)
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
+	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356)
 };
 
 static void pkt_align(struct sk_buff *p, int len, int align)
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 83430f2..0d126ae 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -36,6 +36,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_43430		0xa9a6
 #define SDIO_DEVICE_ID_BROADCOM_4345		0x4345
 #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
+#define SDIO_DEVICE_ID_BROADCOM_4356		0x4356
 
 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
-- 
1.9.1

