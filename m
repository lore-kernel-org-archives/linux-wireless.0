Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:4078 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaAMVUg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 16:20:36 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/8] brcmfmac: restructure brcmf_sdio_chip_recognition()
Date: Mon, 13 Jan 2014 22:20:26 +0100
Message-ID: <1389648029-23560-6-git-send-email-arend@broadcom.com> (sfid-20140113_222050_659540_271ED353)
In-Reply-To: <1389648029-23560-1-git-send-email-arend@broadcom.com>
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework function to allow only bcm4329 in case of chip backplane
type being sonics sillicon backplane.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  333 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    1 -
 2 files changed, 167 insertions(+), 167 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 909d720..fb2f918 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -455,70 +455,38 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 				       struct chip_info *ci)
 {
 	u32 regdata;
-	int ret;
+	u32 socitype;
 
 	/* Get CC core rev
-	 * Chipid is assume to be at offset 0 from regs arg
+	 * Chipid is assume to be at offset 0 from SI_ENUM_BASE
 	 * For different chiptypes or old sdio hosts w/o chipcommon,
 	 * other ways of recognition should be added here.
 	 */
-	ci->c_inf[0].id = BCMA_CORE_CHIPCOMMON;
-	ci->c_inf[0].base = SI_ENUM_BASE;
 	regdata = brcmf_sdiod_regrl(sdiodev,
-				    CORE_CC_REG(ci->c_inf[0].base, chipid),
+				    CORE_CC_REG(SI_ENUM_BASE, chipid),
 				    NULL);
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 	if (sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 &&
 	    ci->chiprev >= 2)
 		ci->chip = BCM4339_CHIP_ID;
-	ci->socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
+	socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
 
-	brcmf_dbg(INFO, "chipid=0x%x chiprev=%d\n", ci->chip, ci->chiprev);
+	brcmf_dbg(INFO, "found %s chip: id=0x%x, rev=%d\n",
+		  socitype == SOCI_SB ? "SB" : "AXI", ci->chip, ci->chiprev);
 
-	/* Address of cores for new chips should be added here */
-	switch (ci->chip) {
-	case BCM43143_CHIP_ID:
-		ci->c_inf[0].wrapbase = ci->c_inf[0].base + 0x00100000;
-		ci->c_inf[0].cib = 0x2b000000;
-		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-		ci->c_inf[1].base = BCM43143_CORE_BUS_BASE;
-		ci->c_inf[1].wrapbase = ci->c_inf[1].base + 0x00100000;
-		ci->c_inf[1].cib = 0x18000000;
-		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-		ci->c_inf[2].base = BCM43143_CORE_SOCRAM_BASE;
-		ci->c_inf[2].wrapbase = ci->c_inf[2].base + 0x00100000;
-		ci->c_inf[2].cib = 0x14000000;
-		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-		ci->c_inf[3].base = BCM43143_CORE_ARM_BASE;
-		ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
-		ci->c_inf[3].cib = 0x07000000;
-		ci->c_inf[4].id = BCMA_CORE_80211;
-		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-		ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
-		ci->ramsize = BCM43143_RAMSIZE;
-		break;
-	case BCM43241_CHIP_ID:
-		ci->c_inf[0].wrapbase = 0x18100000;
-		ci->c_inf[0].cib = 0x2a084411;
-		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-		ci->c_inf[1].base = 0x18002000;
-		ci->c_inf[1].wrapbase = 0x18102000;
-		ci->c_inf[1].cib = 0x0e004211;
-		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-		ci->c_inf[2].base = 0x18004000;
-		ci->c_inf[2].wrapbase = 0x18104000;
-		ci->c_inf[2].cib = 0x14080401;
-		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-		ci->c_inf[3].base = 0x18003000;
-		ci->c_inf[3].wrapbase = 0x18103000;
-		ci->c_inf[3].cib = 0x07004211;
-		ci->c_inf[4].id = BCMA_CORE_80211;
-		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-		ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
-		ci->ramsize = 0x90000;
-		break;
-	case BCM4329_CHIP_ID:
+	if (socitype == SOCI_SB) {
+		if (ci->chip != BCM4329_CHIP_ID) {
+			brcmf_err("SB chip is not supported\n");
+			return -ENODEV;
+		}
+		ci->iscoreup = brcmf_sdio_sb_iscoreup;
+		ci->corerev = brcmf_sdio_sb_corerev;
+		ci->coredisable = brcmf_sdio_sb_coredisable;
+		ci->resetcore = brcmf_sdio_sb_resetcore;
+
+		ci->c_inf[0].id = BCMA_CORE_CHIPCOMMON;
+		ci->c_inf[0].base = SI_ENUM_BASE;
 		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
 		ci->c_inf[1].base = BCM4329_CORE_BUS_BASE;
 		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
@@ -528,129 +496,162 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[4].id = BCMA_CORE_80211;
 		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
 		ci->ramsize = BCM4329_RAMSIZE;
-		break;
-	case BCM4330_CHIP_ID:
-		ci->c_inf[0].wrapbase = 0x18100000;
-		ci->c_inf[0].cib = 0x27004211;
-		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-		ci->c_inf[1].base = 0x18002000;
-		ci->c_inf[1].wrapbase = 0x18102000;
-		ci->c_inf[1].cib = 0x07004211;
-		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-		ci->c_inf[2].base = 0x18004000;
-		ci->c_inf[2].wrapbase = 0x18104000;
-		ci->c_inf[2].cib = 0x0d080401;
-		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-		ci->c_inf[3].base = 0x18003000;
-		ci->c_inf[3].wrapbase = 0x18103000;
-		ci->c_inf[3].cib = 0x03004211;
-		ci->c_inf[4].id = BCMA_CORE_80211;
-		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-		ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
-		ci->ramsize = 0x48000;
-		break;
-	case BCM4334_CHIP_ID:
-		ci->c_inf[0].wrapbase = 0x18100000;
-		ci->c_inf[0].cib = 0x29004211;
-		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-		ci->c_inf[1].base = 0x18002000;
-		ci->c_inf[1].wrapbase = 0x18102000;
-		ci->c_inf[1].cib = 0x0d004211;
-		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-		ci->c_inf[2].base = 0x18004000;
-		ci->c_inf[2].wrapbase = 0x18104000;
-		ci->c_inf[2].cib = 0x13080401;
-		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-		ci->c_inf[3].base = 0x18003000;
-		ci->c_inf[3].wrapbase = 0x18103000;
-		ci->c_inf[3].cib = 0x07004211;
-		ci->c_inf[4].id = BCMA_CORE_80211;
-		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-		ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
-		ci->ramsize = 0x80000;
-		break;
-	case BCM4335_CHIP_ID:
-		ci->c_inf[0].wrapbase = 0x18100000;
-		ci->c_inf[0].cib = 0x2b084411;
-		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-		ci->c_inf[1].base = 0x18005000;
-		ci->c_inf[1].wrapbase = 0x18105000;
-		ci->c_inf[1].cib = 0x0f004211;
-		ci->c_inf[2].id = BCMA_CORE_ARM_CR4;
-		ci->c_inf[2].base = 0x18002000;
-		ci->c_inf[2].wrapbase = 0x18102000;
-		ci->c_inf[2].cib = 0x01084411;
-		ci->c_inf[3].id = BCMA_CORE_80211;
-		ci->c_inf[3].base = BCM43xx_CORE_D11_BASE;
-		ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
-		ci->ramsize = 0xc0000;
-		ci->rambase = 0x180000;
-		break;
-	case BCM4339_CHIP_ID:
-		ci->c_inf[0].wrapbase = 0x18100000;
-		ci->c_inf[0].cib = 0x2e084411;
-		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-		ci->c_inf[1].base = 0x18005000;
-		ci->c_inf[1].wrapbase = 0x18105000;
-		ci->c_inf[1].cib = 0x15004211;
-		ci->c_inf[2].id = BCMA_CORE_ARM_CR4;
-		ci->c_inf[2].base = 0x18002000;
-		ci->c_inf[2].wrapbase = 0x18102000;
-		ci->c_inf[2].cib = 0x04084411;
-		ci->c_inf[3].id = BCMA_CORE_80211;
-		ci->c_inf[3].base = BCM43xx_CORE_D11_BASE;
-		ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
-		ci->ramsize = 0xc0000;
-		ci->rambase = 0x180000;
-		break;
-	case BCM43362_CHIP_ID:
-		ci->c_inf[0].wrapbase = 0x18100000;
-		ci->c_inf[0].cib = 0x27004211;
-		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-		ci->c_inf[1].base = 0x18002000;
-		ci->c_inf[1].wrapbase = 0x18102000;
-		ci->c_inf[1].cib = 0x0a004211;
-		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-		ci->c_inf[2].base = 0x18004000;
-		ci->c_inf[2].wrapbase = 0x18104000;
-		ci->c_inf[2].cib = 0x08080401;
-		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-		ci->c_inf[3].base = 0x18003000;
-		ci->c_inf[3].wrapbase = 0x18103000;
-		ci->c_inf[3].cib = 0x03004211;
-		ci->c_inf[4].id = BCMA_CORE_80211;
-		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-		ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
-		ci->ramsize = 0x3C000;
-		break;
-	default:
-		brcmf_err("chipid 0x%x is not supported\n", ci->chip);
-		return -ENODEV;
-	}
-
-	ret = brcmf_sdio_chip_cichk(ci);
-	if (ret)
-		return ret;
-
-	switch (ci->socitype) {
-	case SOCI_SB:
-		ci->iscoreup = brcmf_sdio_sb_iscoreup;
-		ci->corerev = brcmf_sdio_sb_corerev;
-		ci->coredisable = brcmf_sdio_sb_coredisable;
-		ci->resetcore = brcmf_sdio_sb_resetcore;
-		break;
-	case SOCI_AI:
+	} else if (socitype == SOCI_AI) {
 		ci->iscoreup = brcmf_sdio_ai_iscoreup;
 		ci->corerev = brcmf_sdio_ai_corerev;
 		ci->coredisable = brcmf_sdio_ai_coredisable;
 		ci->resetcore = brcmf_sdio_ai_resetcore;
-		break;
-	default:
-		brcmf_err("socitype %u not supported\n", ci->socitype);
+
+		ci->c_inf[0].id = BCMA_CORE_CHIPCOMMON;
+		ci->c_inf[0].base = SI_ENUM_BASE;
+
+		/* Address of cores for new chips should be added here */
+		switch (ci->chip) {
+		case BCM43143_CHIP_ID:
+			ci->c_inf[0].wrapbase = ci->c_inf[0].base + 0x00100000;
+			ci->c_inf[0].cib = 0x2b000000;
+			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+			ci->c_inf[1].base = BCM43143_CORE_BUS_BASE;
+			ci->c_inf[1].wrapbase = ci->c_inf[1].base + 0x00100000;
+			ci->c_inf[1].cib = 0x18000000;
+			ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+			ci->c_inf[2].base = BCM43143_CORE_SOCRAM_BASE;
+			ci->c_inf[2].wrapbase = ci->c_inf[2].base + 0x00100000;
+			ci->c_inf[2].cib = 0x14000000;
+			ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+			ci->c_inf[3].base = BCM43143_CORE_ARM_BASE;
+			ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
+			ci->c_inf[3].cib = 0x07000000;
+			ci->c_inf[4].id = BCMA_CORE_80211;
+			ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
+			ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
+			ci->ramsize = BCM43143_RAMSIZE;
+			break;
+		case BCM43241_CHIP_ID:
+			ci->c_inf[0].wrapbase = 0x18100000;
+			ci->c_inf[0].cib = 0x2a084411;
+			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+			ci->c_inf[1].base = 0x18002000;
+			ci->c_inf[1].wrapbase = 0x18102000;
+			ci->c_inf[1].cib = 0x0e004211;
+			ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+			ci->c_inf[2].base = 0x18004000;
+			ci->c_inf[2].wrapbase = 0x18104000;
+			ci->c_inf[2].cib = 0x14080401;
+			ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+			ci->c_inf[3].base = 0x18003000;
+			ci->c_inf[3].wrapbase = 0x18103000;
+			ci->c_inf[3].cib = 0x07004211;
+			ci->c_inf[4].id = BCMA_CORE_80211;
+			ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
+			ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
+			ci->ramsize = 0x90000;
+			break;
+		case BCM4330_CHIP_ID:
+			ci->c_inf[0].wrapbase = 0x18100000;
+			ci->c_inf[0].cib = 0x27004211;
+			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+			ci->c_inf[1].base = 0x18002000;
+			ci->c_inf[1].wrapbase = 0x18102000;
+			ci->c_inf[1].cib = 0x07004211;
+			ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+			ci->c_inf[2].base = 0x18004000;
+			ci->c_inf[2].wrapbase = 0x18104000;
+			ci->c_inf[2].cib = 0x0d080401;
+			ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+			ci->c_inf[3].base = 0x18003000;
+			ci->c_inf[3].wrapbase = 0x18103000;
+			ci->c_inf[3].cib = 0x03004211;
+			ci->c_inf[4].id = BCMA_CORE_80211;
+			ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
+			ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
+			ci->ramsize = 0x48000;
+			break;
+		case BCM4334_CHIP_ID:
+			ci->c_inf[0].wrapbase = 0x18100000;
+			ci->c_inf[0].cib = 0x29004211;
+			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+			ci->c_inf[1].base = 0x18002000;
+			ci->c_inf[1].wrapbase = 0x18102000;
+			ci->c_inf[1].cib = 0x0d004211;
+			ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+			ci->c_inf[2].base = 0x18004000;
+			ci->c_inf[2].wrapbase = 0x18104000;
+			ci->c_inf[2].cib = 0x13080401;
+			ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+			ci->c_inf[3].base = 0x18003000;
+			ci->c_inf[3].wrapbase = 0x18103000;
+			ci->c_inf[3].cib = 0x07004211;
+			ci->c_inf[4].id = BCMA_CORE_80211;
+			ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
+			ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
+			ci->ramsize = 0x80000;
+			break;
+		case BCM4335_CHIP_ID:
+			ci->c_inf[0].wrapbase = 0x18100000;
+			ci->c_inf[0].cib = 0x2b084411;
+			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+			ci->c_inf[1].base = 0x18005000;
+			ci->c_inf[1].wrapbase = 0x18105000;
+			ci->c_inf[1].cib = 0x0f004211;
+			ci->c_inf[2].id = BCMA_CORE_ARM_CR4;
+			ci->c_inf[2].base = 0x18002000;
+			ci->c_inf[2].wrapbase = 0x18102000;
+			ci->c_inf[2].cib = 0x01084411;
+			ci->c_inf[3].id = BCMA_CORE_80211;
+			ci->c_inf[3].base = BCM43xx_CORE_D11_BASE;
+			ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
+			ci->ramsize = 0xc0000;
+			ci->rambase = 0x180000;
+			break;
+		case BCM43362_CHIP_ID:
+			ci->c_inf[0].wrapbase = 0x18100000;
+			ci->c_inf[0].cib = 0x27004211;
+			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+			ci->c_inf[1].base = 0x18002000;
+			ci->c_inf[1].wrapbase = 0x18102000;
+			ci->c_inf[1].cib = 0x0a004211;
+			ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+			ci->c_inf[2].base = 0x18004000;
+			ci->c_inf[2].wrapbase = 0x18104000;
+			ci->c_inf[2].cib = 0x08080401;
+			ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+			ci->c_inf[3].base = 0x18003000;
+			ci->c_inf[3].wrapbase = 0x18103000;
+			ci->c_inf[3].cib = 0x03004211;
+			ci->c_inf[4].id = BCMA_CORE_80211;
+			ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
+			ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
+			ci->ramsize = 0x3C000;
+			break;
+		case BCM4339_CHIP_ID:
+			ci->c_inf[0].wrapbase = 0x18100000;
+			ci->c_inf[0].cib = 0x2e084411;
+			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+			ci->c_inf[1].base = 0x18005000;
+			ci->c_inf[1].wrapbase = 0x18105000;
+			ci->c_inf[1].cib = 0x15004211;
+			ci->c_inf[2].id = BCMA_CORE_ARM_CR4;
+			ci->c_inf[2].base = 0x18002000;
+			ci->c_inf[2].wrapbase = 0x18102000;
+			ci->c_inf[2].cib = 0x04084411;
+			ci->c_inf[3].id = BCMA_CORE_80211;
+			ci->c_inf[3].base = BCM43xx_CORE_D11_BASE;
+			ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
+			ci->ramsize = 0xc0000;
+			ci->rambase = 0x180000;
+			break;
+		default:
+			brcmf_err("AXI chip is not supported\n");
+			return -ENODEV;
+		}
+	} else {
+		brcmf_err("chip backplane type %u is not supported\n",
+			  socitype);
 		return -ENODEV;
 	}
 
-	return 0;
+	return brcmf_sdio_chip_cichk(ci);
 }
 
 static int
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 9a72b71..a1aadf4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -66,7 +66,6 @@ struct chip_core_info {
 struct chip_info {
 	u32 chip;
 	u32 chiprev;
-	u32 socitype;
 	/* core info */
 	/* always put chipcommon core at 0, bus core at 1 */
 	struct chip_core_info c_inf[BRCMF_MAX_CORENUM];
-- 
1.7.10.4

