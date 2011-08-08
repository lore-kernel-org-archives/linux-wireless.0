Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3133 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab1HHN7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 41/82] staging: brcm80211: removed global variable
 from sdio fullmac
Date: Mon, 8 Aug 2011 15:58:25 +0200
Message-ID: <1312811946-16713-42-git-send-email-arend@broadcom.com> (sfid-20110808_160122_078994_BDB81ADE)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. bus->card is assigned in brcmf_sdbrcm_probe (before
brcmf_sdbrcm_probe_attach()). Since w_sdreg32() and r_sdreg32() are called
only after that assignment, they can safely use bus->card. Thus there
is no instance left where brcmf_sdcard_reg_read() or brcmf_sdcard_reg_write()
is called with a NULL parameter, so the mechanism in bcmsdh.c that deals with
a NULL pointer could be deleted.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c   |   31 -------------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    9 ++++---
 2 files changed, 5 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index fb3ab63..916d41f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -89,9 +89,6 @@ struct sdio_hc {
 	bool oob_irq_registered;
 };
 
-/* local copy of bcm sd handler */
-static struct brcmf_sdio_card *l_card;
-
 const uint brcmf_sdio_msglevel = BRCMF_SD_ERROR_VAL;
 
 static struct sdio_hc *sdhcinfo;
@@ -116,9 +113,6 @@ brcmf_sdcard_attach(void *cfghdl, u32 *regsva, uint irq)
 		return NULL;
 	}
 
-	/* save the handler locally */
-	l_card = card;
-
 	card->sdioh = brcmf_sdioh_attach(cfghdl, irq);
 	if (!card->sdioh) {
 		brcmf_sdcard_detach(card);
@@ -144,7 +138,6 @@ int brcmf_sdcard_detach(struct brcmf_sdio_card *card)
 		kfree(card);
 	}
 
-	l_card = NULL;
 	return 0;
 }
 
@@ -184,9 +177,6 @@ u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 	s32 retry = 0;
 	u8 data = 0;
 
-	if (!card)
-		card = l_card;
-
 	do {
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			udelay(1000);
@@ -211,9 +201,6 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 	int status;
 	s32 retry = 0;
 
-	if (!card)
-		card = l_card;
-
 	do {
 		if (retry)	/* wait for 1 ms till bus get settled down */
 			udelay(1000);
@@ -235,9 +222,6 @@ u32 brcmf_sdcard_cfg_read_word(struct brcmf_sdio_card *card, uint fnc_num,
 	int status;
 	u32 data = 0;
 
-	if (!card)
-		card = l_card;
-
 	status = brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
 		SDIOH_READ, fnc_num, addr, &data, 4);
 
@@ -256,9 +240,6 @@ brcmf_sdcard_cfg_write_word(struct brcmf_sdio_card *card, uint fnc_num,
 {
 	int status;
 
-	if (!card)
-		card = l_card;
-
 	status =
 	    brcmf_sdioh_request_word(card->sdioh, SDIOH_CMD_TYPE_NORMAL,
 			       SDIOH_WRITE, fnc_num, addr, &data, 4);
@@ -280,9 +261,6 @@ int brcmf_sdcard_cis_read(struct brcmf_sdio_card *card, uint func, u8 * cis,
 	bool ascii = func & ~0xf;
 	func &= 0x7;
 
-	if (!card)
-		card = l_card;
-
 	status = brcmf_sdioh_cis_read(card->sdioh, func, cis, length);
 
 	if (ascii) {
@@ -334,9 +312,6 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_card *card, u32 addr, uint size)
 
 	BRCMF_SD_INFO(("%s:fun = 1, addr = 0x%x, ", __func__, addr));
 
-	if (!card)
-		card = l_card;
-
 	if (bar0 != card->sbwad) {
 		if (brcmf_sdcard_set_sbaddr_window(card, bar0))
 			return 0xFFFFFFFF;
@@ -386,9 +361,6 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_card *card, u32 addr, uint size,
 	BRCMF_SD_INFO(("%s:fun = 1, addr = 0x%x, uint%ddata = 0x%x\n",
 		     __func__, addr, size * 8, data));
 
-	if (!card)
-		card = l_card;
-
 	if (bar0 != card->sbwad) {
 		err = brcmf_sdcard_set_sbaddr_window(card, bar0);
 		if (err)
@@ -522,9 +494,6 @@ int brcmf_sdcard_query_device(struct brcmf_sdio_card *card)
 
 u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card)
 {
-	if (!card)
-		card = l_card;
-
 	return card->sbwad;
 }
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 346274b..8d4c48f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -889,7 +889,7 @@ r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 {
 	*retryvar = 0;
 	do {
-		*regvar = brcmf_sdcard_reg_read(NULL,
+		*regvar = brcmf_sdcard_reg_read(bus->card,
 				bus->ci->buscorebase + reg_offset, sizeof(u32));
 	} while (brcmf_sdcard_regfail(bus->card) &&
 		 (++(*retryvar) <= retry_limit));
@@ -907,7 +907,8 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 {
 	*retryvar = 0;
 	do {
-		brcmf_sdcard_reg_write(NULL, bus->ci->buscorebase + reg_offset,
+		brcmf_sdcard_reg_write(bus->card,
+				       bus->ci->buscorebase + reg_offset,
 				       sizeof(u32), regval);
 	} while (brcmf_sdcard_regfail(bus->card) &&
 		 (++(*retryvar) <= retry_limit));
@@ -5682,8 +5683,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, u32 regsva,
 	/* Set core control so an SDIO reset does a backplane reset */
 	reg_addr = bus->ci->buscorebase +
 		   offsetof(struct sdpcmd_regs, corecontrol);
-	reg_val = brcmf_sdcard_reg_read(NULL, reg_addr, sizeof(u32));
-	brcmf_sdcard_reg_write(NULL, reg_addr, sizeof(u32),
+	reg_val = brcmf_sdcard_reg_read(bus->card, reg_addr, sizeof(u32));
+	brcmf_sdcard_reg_write(bus->card, reg_addr, sizeof(u32),
 			       reg_val | CC_BPRESEN);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
-- 
1.7.4.1


