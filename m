Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2193 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab2H3RnZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 13:43:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/5] brcmfmac: add BCM43241 sdio interface driver
 support
Date: Thu, 30 Aug 2012 19:42:59 +0200
Message-ID: <1346348582-20095-3-git-send-email-arend@broadcom.com> (sfid-20120830_194329_866227_AF8AD987)
In-Reply-To: <1346348582-20095-1-git-send-email-arend@broadcom.com>
References: <1346348582-20095-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

BCM43241 is an 11abg and 2x2 11n Wifi/BT/FM combo chip that
supports 40MHz channel width. This patch intends to enable
the driver support for the chip through SDIO bus interface.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 ++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   17 +++++++++++++++++
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 4 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 49765d3..e0b313c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -42,6 +42,7 @@
 
 #define DMA_ALIGN_MASK	0x03
 
+#define SDIO_DEVICE_ID_BROADCOM_43241	0x4324
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 #define SDIO_DEVICE_ID_BROADCOM_4330	0x4330
 #define SDIO_DEVICE_ID_BROADCOM_4334	0x4334
@@ -51,6 +52,7 @@
 
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43241)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 472f2ef..2dd6b48 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3881,6 +3881,8 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 
 static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 {
+	if (chipid == BCM43241_CHIP_ID)
+		return true;
 	if (chipid == BCM4329_CHIP_ID)
 		return true;
 	if (chipid == BCM4330_CHIP_ID)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 58155e2..9434440 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -377,6 +377,23 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 
 	/* Address of cores for new chips should be added here */
 	switch (ci->chip) {
+	case BCM43241_CHIP_ID:
+		ci->c_inf[0].wrapbase = 0x18100000;
+		ci->c_inf[0].cib = 0x2a084411;
+		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+		ci->c_inf[1].base = 0x18002000;
+		ci->c_inf[1].wrapbase = 0x18102000;
+		ci->c_inf[1].cib = 0x0e004211;
+		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+		ci->c_inf[2].base = 0x18004000;
+		ci->c_inf[2].wrapbase = 0x18104000;
+		ci->c_inf[2].cib = 0x14080401;
+		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+		ci->c_inf[3].base = 0x18003000;
+		ci->c_inf[3].wrapbase = 0x18103000;
+		ci->c_inf[3].cib = 0x07004211;
+		ci->ramsize = 0x90000;
+		break;
 	case BCM4329_CHIP_ID:
 		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
 		ci->c_inf[1].base = BCM4329_CORE_BUS_BASE;
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index bcc79b4..e868285 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -34,6 +34,7 @@
 #define BCM43235_CHIP_ID	43235
 #define BCM43236_CHIP_ID	43236
 #define BCM43238_CHIP_ID	43238
+#define BCM43241_CHIP_ID	0x4324
 #define BCM4329_CHIP_ID		0x4329
 #define BCM4330_CHIP_ID		0x4330
 #define BCM4331_CHIP_ID		0x4331
-- 
1.7.9.5


