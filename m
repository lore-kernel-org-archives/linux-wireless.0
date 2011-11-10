Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4624 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab1KJTaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:55 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/19] brcm80211: fmac: remove id retrieve code
Date: Thu, 10 Nov 2011 20:30:25 +0100
Message-ID: <1320953434-16859-12-git-send-email-arend@broadcom.com> (sfid-20111110_203110_661232_FB92A537)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

sdio_chip.c is dedicated to sdio bus chip. No need to retrieve id
for bus core

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index cef9abb..f6b1822 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -474,8 +474,6 @@ static void
 brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 			     struct chip_info *ci)
 {
-	u32 regdata;
-
 	/* get chipcommon rev */
 	ci->c_inf[0].rev = ci->corerev(sdiodev, ci, ci->c_inf[0].id);
 
@@ -492,9 +490,6 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 	}
 
 	ci->c_inf[1].rev = ci->corerev(sdiodev, ci, ci->c_inf[1].id);
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(ci->c_inf[1].base, sbidhigh), 4);
-	ci->c_inf[1].id = (regdata & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
 
 	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
 		  ci->c_inf[0].rev, ci->pmurev,
-- 
1.7.5.4


