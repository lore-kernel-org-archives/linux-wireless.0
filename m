Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4068 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab2FZT1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:27:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>
Subject: [PATCH 6/7] brcmfmac: add BCM4334 support
Date: Tue, 26 Jun 2012 21:26:39 +0200
Message-ID: <1340738800-14087-7-git-send-email-arend@broadcom.com> (sfid-20120626_212736_811084_6BA8C80E)
In-Reply-To: <1340738800-14087-1-git-send-email-arend@broadcom.com>
References: <1340738800-14087-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

BCM4334 is a dualband a/b/g/n WiFi chip support 20MHz/40MHz
channels. This patch adds support for its SDIO interface.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 ++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   17 +++++++++++++++++
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 4 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 82f51db..49765d3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -44,6 +44,7 @@
 
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 #define SDIO_DEVICE_ID_BROADCOM_4330	0x4330
+#define SDIO_DEVICE_ID_BROADCOM_4334	0x4334
 
 #define SDIO_FUNC1_BLOCKSIZE		64
 #define SDIO_FUNC2_BLOCKSIZE		512
@@ -52,6 +53,7 @@
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},
 	{ /* end: all zeroes */ },
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2ee19c1..5c5f1cd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3885,6 +3885,8 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 		return true;
 	if (chipid == BCM4330_CHIP_ID)
 		return true;
+	if (chipid == BCM4334_CHIP_ID)
+		return true;
 	return false;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index f8e1f1c..58155e2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -403,6 +403,23 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[3].cib = 0x03004211;
 		ci->ramsize = 0x48000;
 		break;
+	case BCM4334_CHIP_ID:
+		ci->c_inf[0].wrapbase = 0x18100000;
+		ci->c_inf[0].cib = 0x29004211;
+		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+		ci->c_inf[1].base = 0x18002000;
+		ci->c_inf[1].wrapbase = 0x18102000;
+		ci->c_inf[1].cib = 0x0d004211;
+		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+		ci->c_inf[2].base = 0x18004000;
+		ci->c_inf[2].wrapbase = 0x18104000;
+		ci->c_inf[2].cib = 0x13080401;
+		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+		ci->c_inf[3].base = 0x18003000;
+		ci->c_inf[3].wrapbase = 0x18103000;
+		ci->c_inf[3].cib = 0x07004211;
+		ci->ramsize = 0x80000;
+		break;
 	default:
 		brcmf_dbg(ERROR, "chipid 0x%x is not supported\n", ci->chip);
 		return -ENODEV;
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 333193f..bcc79b4 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -37,5 +37,6 @@
 #define BCM4329_CHIP_ID		0x4329
 #define BCM4330_CHIP_ID		0x4330
 #define BCM4331_CHIP_ID		0x4331
+#define BCM4334_CHIP_ID		0x4334
 
 #endif				/* _BRCM_HW_IDS_H_ */
-- 
1.7.9.5


