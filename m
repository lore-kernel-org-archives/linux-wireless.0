Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4628 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/19] brcm80211: fmac: add corerev function for bcm4330
 chip
Date: Thu, 10 Nov 2011 20:30:22 +0100
Message-ID: <1320953434-16859-9-git-send-email-arend@broadcom.com> (sfid-20111110_203059_778082_9E28860E)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

This patch is part of the series adding new backplane support

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   31 ++++++++++++++++----
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    3 ++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 263ad0c..85b665e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -49,6 +49,10 @@
 #define SOCI_SB		0
 #define SOCI_AI		1
 
+/* EROM CompIdentB */
+#define CIB_REV_MASK		0xff000000
+#define CIB_REV_SHIFT		24
+
 #define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 /* SDIO Pad drive strength to select value mappings */
 struct sdiod_drive_str {
@@ -100,16 +104,30 @@ brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid)
 }
 
 static u32
-brcmf_sdio_chip_corerev(struct brcmf_sdio_dev *sdiodev,
-			u32 corebase)
+brcmf_sdio_sb_corerev(struct brcmf_sdio_dev *sdiodev,
+		      struct chip_info *ci, u16 coreid)
 {
 	u32 regdata;
+	u8 idx;
+
+	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbidhigh), 4);
+			CORE_SB(ci->c_inf[idx].base, sbidhigh), 4);
 	return SBCOREREV(regdata);
 }
 
+static u32
+brcmf_sdio_ai_corerev(struct brcmf_sdio_dev *sdiodev,
+		      struct chip_info *ci, u16 coreid)
+{
+	u8 idx;
+
+	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
+
+	return (ci->c_inf[idx].cib & CIB_REV_MASK) >> CIB_REV_SHIFT;
+}
+
 static bool
 brcmf_sdio_sb_iscoreup(struct brcmf_sdio_dev *sdiodev,
 		       struct chip_info *ci, u16 coreid)
@@ -310,9 +328,11 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	switch (ci->socitype) {
 	case SOCI_SB:
 		ci->iscoreup = brcmf_sdio_sb_iscoreup;
+		ci->corerev = brcmf_sdio_sb_corerev;
 		break;
 	case SOCI_AI:
 		ci->iscoreup = brcmf_sdio_ai_iscoreup;
+		ci->corerev = brcmf_sdio_ai_corerev;
 		break;
 	default:
 		brcmf_dbg(ERROR, "socitype %u not supported\n", ci->socitype);
@@ -378,8 +398,7 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 	u8 idx;
 
 	/* get chipcommon rev */
-	ci->c_inf[0].rev =
-		brcmf_sdio_chip_corerev(sdiodev, ci->c_inf[0].base);
+	ci->c_inf[0].rev = ci->corerev(sdiodev, ci, ci->c_inf[0].id);
 
 	/* get chipcommon capabilites */
 	ci->c_inf[0].caps =
@@ -393,7 +412,7 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 		ci->pmurev = ci->pmucaps & PCAP_REV_MASK;
 	}
 
-	ci->c_inf[1].rev = brcmf_sdio_chip_corerev(sdiodev, ci->c_inf[1].base);
+	ci->c_inf[1].rev = ci->corerev(sdiodev, ci, ci->c_inf[1].id);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(ci->c_inf[1].base, sbidhigh), 4);
 	ci->c_inf[1].id = (regdata & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 557c80d..ea91e60 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -60,6 +60,7 @@ struct chip_core_info {
 	u32 base;
 	u32 wrapbase;
 	u32 caps;
+	u32 cib;
 };
 
 struct chip_info {
@@ -75,6 +76,8 @@ struct chip_info {
 
 	bool (*iscoreup)(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 			 u16 coreid);
+	u32 (*corerev)(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
+			 u16 coreid);
 };
 
 struct sbconfig {
-- 
1.7.5.4


