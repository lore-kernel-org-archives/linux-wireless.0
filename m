Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2164 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/23] brcm80211: fmac: add bcm4330 support
Date: Thu, 8 Dec 2011 15:06:39 -0800
Message-ID: <1323385619-7454-4-git-send-email-frankyl@broadcom.com> (sfid-20111209_000827_447715_AFFBD544)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for bcm4330 chip which has a SDIO device
id 0x4330. All basic functionalities of bcm4330 are supported by
brcmfmac after this patch.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   34 ++++++++++++++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index bc99267..b895f19 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -40,6 +40,7 @@
 #define DMA_ALIGN_MASK	0x03
 
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
+#define SDIO_DEVICE_ID_BROADCOM_4330	0x4330
 
 #define SDIO_FUNC1_BLOCKSIZE		64
 #define SDIO_FUNC2_BLOCKSIZE		512
@@ -47,6 +48,7 @@
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
 	{ /* end: all zeroes */ },
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 18597fe..43ba0dd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3636,6 +3636,8 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 {
 	if (chipid == BCM4329_CHIP_ID)
 		return true;
+	if (chipid == BCM4330_CHIP_ID)
+		return true;
 	return false;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index f6b1822..d299059 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -91,6 +91,18 @@ static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
 	0, 0x0}
 	};
 
+/* SDIO Drive Strength to sel value table for PMU Rev 11 (1.8V) */
+static const struct sdiod_drive_str sdiod_drvstr_tab4_1v8[] = {
+	{32, 0x6},
+	{26, 0x7},
+	{22, 0x4},
+	{16, 0x5},
+	{12, 0x2},
+	{8, 0x3},
+	{4, 0x0},
+	{0, 0x1}
+};
+
 u8
 brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid)
 {
@@ -396,6 +408,23 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[3].base = BCM4329_CORE_ARM_BASE;
 		ci->ramsize = BCM4329_RAMSIZE;
 		break;
+	case BCM4330_CHIP_ID:
+		ci->c_inf[0].wrapbase = 0x18100000;
+		ci->c_inf[0].cib = 0x27004211;
+		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+		ci->c_inf[1].base = 0x18002000;
+		ci->c_inf[1].wrapbase = 0x18102000;
+		ci->c_inf[1].cib = 0x07004211;
+		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+		ci->c_inf[2].base = 0x18004000;
+		ci->c_inf[2].wrapbase = 0x18104000;
+		ci->c_inf[2].cib = 0x0d080401;
+		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+		ci->c_inf[3].base = 0x18003000;
+		ci->c_inf[3].wrapbase = 0x18103000;
+		ci->c_inf[3].cib = 0x03004211;
+		ci->ramsize = 0x48000;
+		break;
 	default:
 		brcmf_dbg(ERROR, "chipid 0x%x is not supported\n", ci->chip);
 		return -ENODEV;
@@ -585,6 +614,11 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		str_mask = 0x00003800;
 		str_shift = 11;
 		break;
+	case SDIOD_DRVSTR_KEY(BCM4330_CHIP_ID, 12):
+		str_tab = (struct sdiod_drive_str *)&sdiod_drvstr_tab4_1v8;
+		str_mask = 0x00003800;
+		str_shift = 11;
+		break;
 	default:
 		brcmf_dbg(ERROR, "No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
 			  brcmf_sdio_chip_name(ci->chip, chn, 8),
-- 
1.7.5.4


