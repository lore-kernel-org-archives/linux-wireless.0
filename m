Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3706 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab1KDVYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/16] brcm80211: fmac: abstract chip core revision
 function
Date: Fri, 4 Nov 2011 22:23:37 +0100
Message-ID: <1320441822-4615-12-git-send-email-arend@broadcom.com> (sfid-20111104_222425_023905_9B33603E)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Prepare for adding backplane interconnect type support

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    4 +---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   18 ++++++++++++++----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 30802a0..84b10f1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3914,9 +3914,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 
 	brcmf_sdbrcm_sdiod_drive_strength_init(bus, SDIO_DRIVE_STRENGTH);
 
-	/* Get info on the ARM and SOCRAM cores... */
-	brcmf_sdcard_reg_read(bus->sdiodev,
-		  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
+	/* Get info on the SOCRAM cores... */
 	bus->ramsize = bus->ci->ramsize;
 	if (!(bus->ramsize)) {
 		brcmf_dbg(ERROR, "failed to find SOCRAM memory!\n");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index e0c22c4..5d788a6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -52,6 +52,17 @@
 #define	SBIDH_VC_MASK		0xffff0000	/* vendor code */
 #define	SBIDH_VC_SHIFT		16
 
+static u32
+brcmf_sdio_chip_corerev(struct brcmf_sdio_dev *sdiodev,
+			u32 corebase)
+{
+	u32 regdata;
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbidhigh), 4);
+	return SBCOREREV(regdata);
+}
+
 bool
 brcmf_sdio_chip_iscoreup(struct brcmf_sdio_dev *sdiodev,
 			 u32 corebase)
@@ -234,9 +245,7 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 	u32 regdata;
 
 	/* get chipcommon rev */
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(ci->cccorebase, sbidhigh), 4);
-	ci->ccrev = SBCOREREV(regdata);
+	ci->ccrev = brcmf_sdio_chip_corerev(sdiodev, ci->cccorebase);
 
 	/* get chipcommon capabilites */
 	ci->cccaps = brcmf_sdcard_reg_read(sdiodev,
@@ -249,9 +258,10 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 		ci->pmurev = ci->pmucaps & PCAP_REV_MASK;
 	}
 
+
+	ci->buscorerev = brcmf_sdio_chip_corerev(sdiodev, ci->buscorebase);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 					CORE_SB(ci->buscorebase, sbidhigh), 4);
-	ci->buscorerev = SBCOREREV(regdata);
 	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
 
 	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
-- 
1.7.4.1


