Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3746 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/19] brcm80211: fmac: add iscoreup function for
 bcm4330 chip
Date: Thu, 10 Nov 2011 20:30:21 +0100
Message-ID: <1320953434-16859-8-git-send-email-arend@broadcom.com> (sfid-20111110_203055_210559_9A65AF1D)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

New type of backplane interconnect support is needed
for bcm4330

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    4 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   50 ++++++++++++++++++--
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    6 ++-
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 43b4496..5b81336 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3120,9 +3120,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 					 (u8 *)&zeros, 4);
 		}
 	} else {
-		idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_INTERNAL_MEM);
-		if (!brcmf_sdio_chip_iscoreup(bus->sdiodev,
-					      ci->c_inf[idx].base)) {
+		if (!ci->iscoreup(bus->sdiodev, ci, BCMA_CORE_INTERNAL_MEM)) {
 			brcmf_dbg(ERROR, "SOCRAM core is down after reset?\n");
 			bcmerror = -EBADE;
 			goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 99d00dd..263ad0c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -45,6 +45,10 @@
 	((((sbidh) & SSB_IDHIGH_RCHI) >> SSB_IDHIGH_RCHI_SHIFT) | \
 	  ((sbidh) & SSB_IDHIGH_RCLO))
 
+/* SOC Interconnect types (aka chip types) */
+#define SOCI_SB		0
+#define SOCI_AI		1
+
 #define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 /* SDIO Pad drive strength to select value mappings */
 struct sdiod_drive_str {
@@ -106,19 +110,44 @@ brcmf_sdio_chip_corerev(struct brcmf_sdio_dev *sdiodev,
 	return SBCOREREV(regdata);
 }
 
-bool
-brcmf_sdio_chip_iscoreup(struct brcmf_sdio_dev *sdiodev,
-			 u32 corebase)
+static bool
+brcmf_sdio_sb_iscoreup(struct brcmf_sdio_dev *sdiodev,
+		       struct chip_info *ci, u16 coreid)
 {
 	u32 regdata;
+	u8 idx;
+
+	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4);
+			CORE_SB(ci->c_inf[idx].base, sbtmstatelow), 4);
 	regdata &= (SSB_TMSLOW_RESET | SSB_TMSLOW_REJECT |
 		    SSB_IMSTATE_REJECT | SSB_TMSLOW_CLOCK);
 	return (SSB_TMSLOW_CLOCK == regdata);
 }
 
+static bool
+brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
+		       struct chip_info *ci, u16 coreid)
+{
+	u32 regdata;
+	u8 idx;
+	bool ret;
+
+	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					ci->c_inf[idx].wrapbase+BCMA_IOCTL, 4);
+	ret = (regdata & (BCMA_IOCTL_FGC | BCMA_IOCTL_CLK)) == BCMA_IOCTL_CLK;
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+					4);
+	ret = ret && ((regdata & BCMA_RESET_CTL_RESET) == 0);
+
+	return ret;
+}
+
 void
 brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 {
@@ -258,6 +287,7 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 			CORE_CC_REG(ci->c_inf[0].base, chipid), 4);
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
+	ci->socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
 
 	brcmf_dbg(INFO, "chipid=0x%x chiprev=%d\n", ci->chip, ci->chiprev);
 
@@ -277,6 +307,18 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		return -ENODEV;
 	}
 
+	switch (ci->socitype) {
+	case SOCI_SB:
+		ci->iscoreup = brcmf_sdio_sb_iscoreup;
+		break;
+	case SOCI_AI:
+		ci->iscoreup = brcmf_sdio_ai_iscoreup;
+		break;
+	default:
+		brcmf_dbg(ERROR, "socitype %u not supported\n", ci->socitype);
+		return -ENODEV;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 0ee37ae..557c80d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -65,12 +65,16 @@ struct chip_core_info {
 struct chip_info {
 	u32 chip;
 	u32 chiprev;
+	u32 socitype;
 	/* core info */
 	/* always put chipcommon core at 0, bus core at 1 */
 	struct chip_core_info c_inf[BRCMF_MAX_CORENUM];
 	u32 pmurev;
 	u32 pmucaps;
 	u32 ramsize;
+
+	bool (*iscoreup)(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
+			 u16 coreid);
 };
 
 struct sbconfig {
@@ -115,8 +119,6 @@ struct sbconfig {
 
 extern void brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev,
 				      u32 corebase);
-extern bool brcmf_sdio_chip_iscoreup(struct brcmf_sdio_dev *sdiodev,
-				     u32 corebase);
 extern void brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev,
 					u32 corebase);
 extern int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-- 
1.7.5.4


