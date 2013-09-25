Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2144 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab3IYLGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 07:06:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/7] brcmfmac: add BCM4339 SDIO interface support
Date: Wed, 25 Sep 2013 13:05:41 +0200
Message-ID: <1380107146-24026-3-git-send-email-arend@broadcom.com> (sfid-20130925_130612_121105_412092EC)
In-Reply-To: <1380107146-24026-1-git-send-email-arend@broadcom.com>
References: <1380107146-24026-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

BCM4339 is an a/b/g/n/ac 1x1 WiFi chip. This patch adds support for it through
SDIO interface.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c   |   11 +++--------
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c  |   18 ++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h  |    8 ++++++++
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h |    1 +
 4 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 64f4a2b..f849d73 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -34,6 +34,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include "sdio_host.h"
+#include "sdio_chip.h"
 #include "dhd_dbg.h"
 #include "dhd_bus.h"
 
@@ -41,13 +42,6 @@
 
 #define DMA_ALIGN_MASK	0x03
 
-#define SDIO_DEVICE_ID_BROADCOM_43143	43143
-#define SDIO_DEVICE_ID_BROADCOM_43241	0x4324
-#define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
-#define SDIO_DEVICE_ID_BROADCOM_4330	0x4330
-#define SDIO_DEVICE_ID_BROADCOM_4334	0x4334
-#define SDIO_DEVICE_ID_BROADCOM_4335	0x4335
-
 #define SDIO_FUNC1_BLOCKSIZE		64
 #define SDIO_FUNC2_BLOCKSIZE		512
 
@@ -58,7 +52,8 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4335)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM,
+		     SDIO_DEVICE_ID_BROADCOM_4335_4339)},
 	{ /* end: all zeroes */ },
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index ca72177..023ddcb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/mmc/card.h>
+#include <linux/mmc/sdio_func.h>
 #include <linux/ssb/ssb_regs.h>
 #include <linux/bcma/bcma.h>
 
@@ -444,6 +445,9 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 				   NULL);
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
+	if (sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 &&
+	    ci->chiprev >= 2)
+		ci->chip = BCM4339_CHIP_ID;
 	ci->socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
 
 	brcmf_dbg(INFO, "chipid=0x%x chiprev=%d\n", ci->chip, ci->chiprev);
@@ -541,6 +545,20 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->ramsize = 0xc0000;
 		ci->rambase = 0x180000;
 		break;
+	case BCM4339_CHIP_ID:
+		ci->c_inf[0].wrapbase = 0x18100000;
+		ci->c_inf[0].cib = 0x2e084411;
+		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+		ci->c_inf[1].base = 0x18005000;
+		ci->c_inf[1].wrapbase = 0x18105000;
+		ci->c_inf[1].cib = 0x15004211;
+		ci->c_inf[2].id = BCMA_CORE_ARM_CR4;
+		ci->c_inf[2].base = 0x18002000;
+		ci->c_inf[2].wrapbase = 0x18102000;
+		ci->c_inf[2].cib = 0x04084411;
+		ci->ramsize = 0xc0000;
+		ci->rambase = 0x180000;
+		break;
 	default:
 		brcmf_err("chipid 0x%x is not supported\n", ci->chip);
 		return -ENODEV;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 83c041f..076b83c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -54,6 +54,14 @@
 
 #define BRCMF_MAX_CORENUM	6
 
+/* SDIO device ID */
+#define SDIO_DEVICE_ID_BROADCOM_43143		43143
+#define SDIO_DEVICE_ID_BROADCOM_43241		0x4324
+#define SDIO_DEVICE_ID_BROADCOM_4329		0x4329
+#define SDIO_DEVICE_ID_BROADCOM_4330		0x4330
+#define SDIO_DEVICE_ID_BROADCOM_4334		0x4334
+#define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
+
 struct chip_core_info {
 	u16 id;
 	u16 rev;
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index c1fe245..84113ea 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -41,5 +41,6 @@
 #define BCM4331_CHIP_ID		0x4331
 #define BCM4334_CHIP_ID		0x4334
 #define BCM4335_CHIP_ID		0x4335
+#define BCM4339_CHIP_ID		0x4339
 
 #endif				/* _BRCM_HW_IDS_H_ */
-- 
1.7.10.4


