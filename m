Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3755 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538Ab1D0RWx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 13:22:53 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	brudley@broadcom.com, henryp@broadcom.com, hharte@broadcom.com
Subject: [PATCH] staging: brcm80211: Change print macro for debug only
 code
Date: Wed, 27 Apr 2011 10:22:31 -0700
Message-ID: <1303924951-30821-1-git-send-email-frankyl@broadcom.com> (sfid-20110427_192256_876994_009B4A54)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the debug macro from DHD_ERROR to DHD_INFO in
dhdsdio_sdiod_drive_strength_init to fix a compile error when
BCM_DEBUG is not turned on

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 6debc1e..299efa0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -6363,7 +6363,7 @@ dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 		str_shift = 11;
 		break;
 	default:
-		DHD_ERROR(("No SDIO Drive strength init"
+		DHD_INFO(("No SDIO Drive strength init"
 			"done for chip %s rev %d pmurev %d\n",
 			bcm_chipname(bus->ci->chip, chn, 8),
 			bus->ci->chiprev, bus->ci->pmurev));
-- 
1.7.1


