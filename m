Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2037 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab1KDVX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:23:59 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/16] brcm80211: fmac: abstract chip buscore setup
 function
Date: Fri, 4 Nov 2011 22:23:30 +0100
Message-ID: <1320441822-4615-5-git-send-email-arend@broadcom.com> (sfid-20111104_222406_075092_266EFF53)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

This patch is part of the abstracting chip backplane handle code
series.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   53 ++++++++++++-------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    1 +
 2 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 7bf9778..1e01ae2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -83,26 +83,6 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		return -ENODEV;
 	}
 
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(ci->cccorebase, sbidhigh), 4);
-	ci->ccrev = SBCOREREV(regdata);
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_CC_REG(ci->cccorebase, pmucapabilities), 4);
-	ci->pmurev = regdata & PCAP_REV_MASK;
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					CORE_SB(ci->buscorebase, sbidhigh), 4);
-	ci->buscorerev = SBCOREREV(regdata);
-	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
-
-	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
-		  ci->ccrev, ci->pmurev, ci->buscorerev, ci->buscoretype);
-
-	/* get chipcommon capabilites */
-	ci->cccaps = brcmf_sdcard_reg_read(sdiodev,
-		CORE_CC_REG(ci->cccorebase, capabilities), 4);
-
 	return 0;
 }
 
@@ -154,6 +134,37 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 	return 0;
 }
 
+static void
+brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
+			     struct chip_info *ci)
+{
+	u32 regdata;
+
+	/* get chipcommon rev */
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+		CORE_SB(ci->cccorebase, sbidhigh), 4);
+	ci->ccrev = SBCOREREV(regdata);
+
+	/* get chipcommon capabilites */
+	ci->cccaps = brcmf_sdcard_reg_read(sdiodev,
+		CORE_CC_REG(ci->cccorebase, capabilities), 4);
+
+	/* get pmu caps & rev */
+	if (ci->cccaps & CC_CAP_PMU) {
+		ci->pmucaps = brcmf_sdcard_reg_read(sdiodev,
+			CORE_CC_REG(ci->cccorebase, pmucapabilities), 4);
+		ci->pmurev = ci->pmucaps & PCAP_REV_MASK;
+	}
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					CORE_SB(ci->buscorebase, sbidhigh), 4);
+	ci->buscorerev = SBCOREREV(regdata);
+	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
+
+	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
+		  ci->ccrev, ci->pmurev, ci->buscorerev, ci->buscoretype);
+}
+
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 			   struct chip_info *ci, u32 regs)
 {
@@ -167,5 +178,7 @@ int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 	if (ret != 0)
 		return ret;
 
+	brcmf_sdio_chip_buscoresetup(sdiodev, ci);
+
 	return ret;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 2d75b8c5..1985e36 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -64,6 +64,7 @@ struct chip_info {
 	u32 ramcorebase;
 	u32 armcorebase;
 	u32 pmurev;
+	u32 pmucaps;
 	u32 ramsize;
 };
 
-- 
1.7.4.1


