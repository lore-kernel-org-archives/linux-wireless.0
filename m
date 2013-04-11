Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1030 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/15] brcmfmac: Add 43143 SDIO support.
Date: Thu, 11 Apr 2013 13:28:54 +0200
Message-ID: <1365679740-25679-10-git-send-email-arend@broadcom.com> (sfid-20130411_133108_536806_0AD31295)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Added sdio device id to list of supported devices. 43143 is a new
802.11n single stream device.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 ++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   26 ++++++++++++++++++++
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 4 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index c273ae6..b1ea103 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -40,6 +40,7 @@
 
 #define DMA_ALIGN_MASK	0x03
 
+#define SDIO_DEVICE_ID_BROADCOM_43143	43143
 #define SDIO_DEVICE_ID_BROADCOM_43241	0x4324
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
 #define SDIO_DEVICE_ID_BROADCOM_4330	0x4330
@@ -51,6 +52,7 @@
 
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43143)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43241)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 07eb24f..fd697ce 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3550,6 +3550,8 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 
 static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 {
+	if (chipid == BCM43143_CHIP_ID)
+		return true;
 	if (chipid == BCM43241_CHIP_ID)
 		return true;
 	if (chipid == BCM4329_CHIP_ID)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 3975b5a..0ac048d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -40,6 +40,15 @@
 #define BCM4329_CORE_ARM_BASE		0x18002000
 #define BCM4329_RAMSIZE			0x48000
 
+/* bcm43143 */
+/* SDIO device core */
+#define BCM43143_CORE_BUS_BASE		0x18002000
+/* internal memory core */
+#define BCM43143_CORE_SOCRAM_BASE	0x18004000
+/* ARM Cortex M3 core, ID 0x82a */
+#define BCM43143_CORE_ARM_BASE		0x18003000
+#define BCM43143_RAMSIZE		0x70000
+
 #define	SBCOREREV(sbidh) \
 	((((sbidh) & SSB_IDHIGH_RCHI) >> SSB_IDHIGH_RCHI_SHIFT) | \
 	  ((sbidh) & SSB_IDHIGH_RCLO))
@@ -433,6 +442,23 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 
 	/* Address of cores for new chips should be added here */
 	switch (ci->chip) {
+	case BCM43143_CHIP_ID:
+		ci->c_inf[0].wrapbase = ci->c_inf[0].base + 0x00100000;
+		ci->c_inf[0].cib = 0x2b000000;
+		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+		ci->c_inf[1].base = BCM43143_CORE_BUS_BASE;
+		ci->c_inf[1].wrapbase = ci->c_inf[1].base + 0x00100000;
+		ci->c_inf[1].cib = 0x18000000;
+		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+		ci->c_inf[2].base = BCM43143_CORE_SOCRAM_BASE;
+		ci->c_inf[2].wrapbase = ci->c_inf[2].base + 0x00100000;
+		ci->c_inf[2].cib = 0x14000000;
+		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+		ci->c_inf[3].base = BCM43143_CORE_ARM_BASE;
+		ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
+		ci->c_inf[3].cib = 0x07000000;
+		ci->ramsize = BCM43143_RAMSIZE;
+		break;
 	case BCM43241_CHIP_ID:
 		ci->c_inf[0].wrapbase = 0x18100000;
 		ci->c_inf[0].cib = 0x2a084411;
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 12c4956..c1fe245 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -29,6 +29,7 @@
 
 /* Chipcommon Core Chip IDs */
 #define BCM4313_CHIP_ID		0x4313
+#define BCM43143_CHIP_ID	43143
 #define BCM43224_CHIP_ID	43224
 #define BCM43225_CHIP_ID	43225
 #define BCM43235_CHIP_ID	43235
-- 
1.7.10.4


