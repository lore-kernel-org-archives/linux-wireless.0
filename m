Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2803 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab1HHN7b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:31 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 46/82] staging: brcm80211: remove code for unsupported
 chip
Date: Mon, 8 Aug 2011 15:58:30 +0200
Message-ID: <1312811946-16713-47-git-send-email-arend@broadcom.com> (sfid-20110808_160133_549470_9303DC13)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Currently fullmac only support bcm4329. Remove dead code for
unsupported chip.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   40 +-------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   17 +--------
 2 files changed, 3 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index d6f0f92..846b6be 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -34,36 +34,17 @@
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
 
-#define BLOCK_SIZE_64 64
-#define BLOCK_SIZE_512 512
-#define BLOCK_SIZE_4318 64
-#define BLOCK_SIZE_4328 512
-
-/* private bus modes */
-#define SDIOH_MODE_SD4		2
-
 #define CLIENT_INTR		0x100	/* Get rid of this! */
 
 #if !defined(SDIO_VENDOR_ID_BROADCOM)
 #define SDIO_VENDOR_ID_BROADCOM		0x02d0
 #endif				/* !defined(SDIO_VENDOR_ID_BROADCOM) */
 
-#define SDIO_DEVICE_ID_BROADCOM_DEFAULT	0x0000
-
 #define DMA_ALIGN_MASK	0x03
 
-#if !defined(SDIO_DEVICE_ID_BROADCOM_4325_SDGWB)
-#define SDIO_DEVICE_ID_BROADCOM_4325_SDGWB	0x0492	/* BCM94325SDGWB */
-#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4325_SDGWB) */
-#if !defined(SDIO_DEVICE_ID_BROADCOM_4325)
-#define SDIO_DEVICE_ID_BROADCOM_4325	0x0493
-#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4325) */
 #if !defined(SDIO_DEVICE_ID_BROADCOM_4329)
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 #endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
-#if !defined(SDIO_DEVICE_ID_BROADCOM_4319)
-#define SDIO_DEVICE_ID_BROADCOM_4319	0x4319
-#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
 
 /* Common msglevel constants */
 #define SDH_ERROR_VAL		0x0001	/* Error */
@@ -136,12 +117,6 @@ uint sd_f2_blocksize = 512;	/* Default blocksize */
 
 uint sd_msglevel = 0x01;
 
-/* module param defaults */
-static int clockoverride;
-
-module_param(clockoverride, int, 0644);
-MODULE_PARM_DESC(clockoverride, "SDIO card clock override");
-
 struct brcmf_sdmmc_instance *gInstance;
 static atomic_t brcmf_mmc_suspend;
 
@@ -149,12 +124,7 @@ struct device sdmmc_dev;
 
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_DEFAULT)},
-	{SDIO_DEVICE
-	 (SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4325_SDGWB)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4325)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4319)},
 	{ /* end: all zeroes */ },
 };
 
@@ -498,10 +468,10 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 				maxsize = 32;
 				break;
 			case 1:
-				maxsize = BLOCK_SIZE_4318;
+				maxsize = 64;
 				break;
 			case 2:
-				maxsize = BLOCK_SIZE_4328;
+				maxsize = 512;
 				break;
 			default:
 				maxsize = 0;
@@ -1058,12 +1028,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		sdio_func_0.num = 0;
 		sdio_func_0.card = func->card;
 		gInstance->func[0] = &sdio_func_0;
-		if (func->device == 0x4) {	/* 4318 */
-			gInstance->func[2] = NULL;
-			sd_trace(("NIC found, calling brcmf_sdio_probe...\n"));
-			ret = brcmf_sdio_probe(&sdmmc_dev);
-		}
-		atomic_set(&brcmf_mmc_suspend, false);
 	}
 
 	gInstance->func[func->num] = func;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 83bb0ea..c816339 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -1273,8 +1273,7 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 			SBSDIO_FORCE_HW_CLKREQ_OFF, NULL);
 
 		/* Isolate the bus */
-		if (bus->ci->chip != BCM4329_CHIP_ID
-		    && bus->ci->chip != BCM4319_CHIP_ID) {
+		if (bus->ci->chip != BCM4329_CHIP_ID) {
 			brcmf_sdcard_cfg_write(card, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL,
 				SBSDIO_DEVCTL_PADS_ISO, NULL);
@@ -5401,12 +5400,8 @@ done:
 
 static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 {
-	if (chipid == BCM4325_CHIP_ID)
-		return true;
 	if (chipid == BCM4329_CHIP_ID)
 		return true;
-	if (chipid == BCM4319_CHIP_ID)
-		return true;
 	return false;
 }
 
@@ -5461,22 +5456,12 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 
 	/* Check the Device ID and make sure it's one that we support */
 	switch (devid) {
-	case BCM4325_D11DUAL_ID:	/* 4325 802.11a/g id */
-	case BCM4325_D11G_ID:	/* 4325 802.11g 2.4Ghz band id */
-	case BCM4325_D11A_ID:	/* 4325 802.11a 5Ghz band id */
-		BRCMF_INFO(("%s: found 4325 Dongle\n", __func__));
-		break;
 	case BCM4329_D11NDUAL_ID:	/* 4329 802.11n dualband device */
 	case BCM4329_D11N2G_ID:	/* 4329 802.11n 2.4G device */
 	case BCM4329_D11N5G_ID:	/* 4329 802.11n 5G device */
 	case 0x4329:
 		BRCMF_INFO(("%s: found 4329 Dongle\n", __func__));
 		break;
-	case BCM4319_D11N_ID:	/* 4319 802.11n id */
-	case BCM4319_D11N2G_ID:	/* 4319 802.11n2g id */
-	case BCM4319_D11N5G_ID:	/* 4319 802.11n5g id */
-		BRCMF_INFO(("%s: found 4319 Dongle\n", __func__));
-		break;
 	case 0:
 		BRCMF_INFO(("%s: allow device id 0, will check chip"
 			    " internals\n", __func__));
-- 
1.7.4.1


