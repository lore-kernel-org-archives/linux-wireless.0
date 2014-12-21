Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:5290 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaLULoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 06:44:02 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/10] brcmfmac: get rid of duplicate SDIO device identifiers
Date: Sun, 21 Dec 2014 12:43:47 +0100
Message-ID: <1419162233-19492-5-git-send-email-arend@broadcom.com> (sfid-20141221_124411_804461_84AC65C5)
In-Reply-To: <1419162233-19492-1-git-send-email-arend@broadcom.com>
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of defining SDIO device identifier in brcm80211 code use
the defintions in linux/mmc/sdio_ids.h directly.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   | 22 +++++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     |  2 +-
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   | 13 -------------
 3 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 7cf42e56..eaead8b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -996,20 +996,20 @@ out:
 }
 
 #define BRCMF_SDIO_DEVICE(dev_id)	\
-	{SDIO_DEVICE(BRCM_SDIO_VENDOR_ID_BROADCOM, dev_id)}
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, dev_id)}
 
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
-	BRCMF_SDIO_DEVICE(BRCM_SDIO_43143_DEVICE_ID),
-	BRCMF_SDIO_DEVICE(BRCM_SDIO_43241_DEVICE_ID),
-	BRCMF_SDIO_DEVICE(BRCM_SDIO_4329_DEVICE_ID),
-	BRCMF_SDIO_DEVICE(BRCM_SDIO_4330_DEVICE_ID),
-	BRCMF_SDIO_DEVICE(BRCM_SDIO_4334_DEVICE_ID),
-	BRCMF_SDIO_DEVICE(BRCM_SDIO_43340_DEVICE_ID),
-	BRCMF_SDIO_DEVICE(BRCM_SDIO_43341_DEVICE_ID),
-	BRCMF_SDIO_DEVICE(BRCM_SDIO_43362_DEVICE_ID),
-	BRCMF_SDIO_DEVICE(BRCM_SDIO_4335_4339_DEVICE_ID),
-	BRCMF_SDIO_DEVICE(BRCM_SDIO_4354_DEVICE_ID),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43143),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43241),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4329),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4330),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4334),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43340),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43341),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43362),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4335_4339),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
 	{ /* end: all zeroes */ }
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 551da35..99a3776 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -3816,7 +3816,7 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
 	u32 val, rev;
 
 	val = brcmf_sdiod_regrl(sdiodev, addr, NULL);
-	if (sdiodev->func[0]->device == BRCM_SDIO_4335_4339_DEVICE_ID &&
+	if (sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 &&
 	    addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
 		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
 		if (rev >= 2) {
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 00215ef..2124a17 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -22,7 +22,6 @@
 
 #define BRCM_USB_VENDOR_ID_BROADCOM	0x0a5c
 #define BRCM_PCIE_VENDOR_ID_BROADCOM	PCI_VENDOR_ID_BROADCOM
-#define BRCM_SDIO_VENDOR_ID_BROADCOM	SDIO_VENDOR_ID_BROADCOM
 
 /* Chipcommon Core Chip IDs */
 #define BRCM_CC_43143_CHIP_ID		43143
@@ -46,18 +45,6 @@
 #define BRCM_CC_43570_CHIP_ID		43570
 #define BRCM_CC_43602_CHIP_ID		43602
 
-/* SDIO Device IDs */
-#define BRCM_SDIO_43143_DEVICE_ID	BRCM_CC_43143_CHIP_ID
-#define BRCM_SDIO_43241_DEVICE_ID	BRCM_CC_43241_CHIP_ID
-#define BRCM_SDIO_4329_DEVICE_ID	BRCM_CC_4329_CHIP_ID
-#define BRCM_SDIO_4330_DEVICE_ID	BRCM_CC_4330_CHIP_ID
-#define BRCM_SDIO_4334_DEVICE_ID	BRCM_CC_4334_CHIP_ID
-#define BRCM_SDIO_43340_DEVICE_ID	BRCM_CC_43340_CHIP_ID
-#define BRCM_SDIO_43341_DEVICE_ID	43341
-#define BRCM_SDIO_43362_DEVICE_ID	BRCM_CC_43362_CHIP_ID
-#define BRCM_SDIO_4335_4339_DEVICE_ID	BRCM_CC_4335_CHIP_ID
-#define BRCM_SDIO_4354_DEVICE_ID	BRCM_CC_4354_CHIP_ID
-
 /* USB Device IDs */
 #define BRCM_USB_43143_DEVICE_ID	0xbd1e
 #define BRCM_USB_43236_DEVICE_ID	0xbd17
-- 
1.9.1

