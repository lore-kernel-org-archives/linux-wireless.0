Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3078 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1HHN7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 40/82] staging: brcm80211: removed R_REG and OR_REG
 macro's from fullmac
Date: Mon, 8 Aug 2011 15:58:24 +0200
Message-ID: <1312811946-16713-41-git-send-email-arend@broadcom.com> (sfid-20110808_160238_440476_513354E6)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Macro invocations have been substituted with macro expansion.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 77ac59f..346274b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -34,13 +34,6 @@
 #include <soc.h>
 #include "sdio_host.h"
 
-/* register access macros */
-#define R_REG(r, typ) \
-	brcmf_sdcard_reg_read(NULL, (r), sizeof(typ))
-
-#define OR_REG(r, v, typ) \
-	brcmf_sdcard_reg_write(NULL, (r), sizeof(typ), R_REG(r, typ) | (v))
-
 #ifdef BCMDBG
 
 /* ARM trap handling */
@@ -896,7 +889,8 @@ r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 {
 	*retryvar = 0;
 	do {
-		*regvar = R_REG(bus->ci->buscorebase + reg_offset, u32);
+		*regvar = brcmf_sdcard_reg_read(NULL,
+				bus->ci->buscorebase + reg_offset, sizeof(u32));
 	} while (brcmf_sdcard_regfail(bus->card) &&
 		 (++(*retryvar) <= retry_limit));
 	if (*retryvar) {
@@ -5618,6 +5612,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
 {
 	u8 clkctl = 0;
 	int err = 0;
+	int reg_addr;
+	u32 reg_val;
 
 	bus->alp_only = true;
 
@@ -5684,9 +5680,11 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
 	}
 
 	/* Set core control so an SDIO reset does a backplane reset */
-	OR_REG(bus->ci->buscorebase + offsetof(struct sdpcmd_regs,
-						       corecontrol),
-	       CC_BPRESEN, u32);
+	reg_addr = bus->ci->buscorebase +
+		   offsetof(struct sdpcmd_regs, corecontrol);
+	reg_val = brcmf_sdcard_reg_read(NULL, reg_addr, sizeof(u32));
+	brcmf_sdcard_reg_write(NULL, reg_addr, sizeof(u32),
+			       reg_val | CC_BPRESEN);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
-- 
1.7.4.1


