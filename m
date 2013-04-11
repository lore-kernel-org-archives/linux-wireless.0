Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4978 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/15] brcmfmac: add BCM4335 sdio interface support
Date: Thu, 11 Apr 2013 13:28:53 +0200
Message-ID: <1365679740-25679-9-git-send-email-arend@broadcom.com> (sfid-20130411_133112_852190_B66B6536)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

BCM4335 is an a/b/g/n/ac WiFi chip that supports up to 80MHz channel. This patch
adds support for this chip through SDIO interface.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c     |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   14 ++++++++++++++
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 4 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 7165489..c273ae6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -44,6 +44,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 #define SDIO_DEVICE_ID_BROADCOM_4330	0x4330
 #define SDIO_DEVICE_ID_BROADCOM_4334	0x4334
+#define SDIO_DEVICE_ID_BROADCOM_4335	0x4335
 
 #define SDIO_FUNC1_BLOCKSIZE		64
 #define SDIO_FUNC2_BLOCKSIZE		512
@@ -54,6 +55,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4335)},
 	{ /* end: all zeroes */ },
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index c06bb08..07eb24f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3558,6 +3558,8 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 		return true;
 	if (chipid == BCM4334_CHIP_ID)
 		return true;
+	if (chipid == BCM4335_CHIP_ID)
+		return true;
 	return false;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 5db985c..3975b5a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -493,6 +493,20 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[3].cib = 0x07004211;
 		ci->ramsize = 0x80000;
 		break;
+	case BCM4335_CHIP_ID:
+		ci->c_inf[0].wrapbase = 0x18100000;
+		ci->c_inf[0].cib = 0x2b084411;
+		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+		ci->c_inf[1].base = 0x18005000;
+		ci->c_inf[1].wrapbase = 0x18105000;
+		ci->c_inf[1].cib = 0x0f004211;
+		ci->c_inf[2].id = BCMA_CORE_ARM_CR4;
+		ci->c_inf[2].base = 0x18002000;
+		ci->c_inf[2].wrapbase = 0x18102000;
+		ci->c_inf[2].cib = 0x01084411;
+		ci->ramsize = 0xc0000;
+		ci->rambase = 0x180000;
+		break;
 	default:
 		brcmf_err("chipid 0x%x is not supported\n", ci->chip);
 		return -ENODEV;
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index e868285..12c4956 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -39,5 +39,6 @@
 #define BCM4330_CHIP_ID		0x4330
 #define BCM4331_CHIP_ID		0x4331
 #define BCM4334_CHIP_ID		0x4334
+#define BCM4335_CHIP_ID		0x4335
 
 #endif				/* _BRCM_HW_IDS_H_ */
-- 
1.7.10.4


