Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4432 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab1ISV0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:31 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/20] staging: brcm80211: remove fullmac module_param
 brcmf_dongle_memsize
Date: Mon, 19 Sep 2011 14:25:56 -0700
Message-ID: <1316467568-27683-9-git-send-email-frankyl@broadcom.com> (sfid-20110919_232828_235659_54FA34DC)
In-Reply-To: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove unused module parameter brcmf_dongle_memsize and related code

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h  |    3 --
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   35 +++---------------------
 2 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index aa05b1c..d02cb10 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -24,9 +24,6 @@
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
 
-/* dongle ram module parameter */
-extern int brcmf_dongle_memsize;
-
 /* Tx/Rx bounds module parameters */
 extern uint brcmf_txbound;
 extern uint brcmf_rxbound;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 9d4850d..7090a36 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -568,7 +568,6 @@ struct brcmf_bus {
 	uint varsz;		/* Size of variables buffer */
 
 	u32 ramsize;		/* Size of RAM in SOCRAM (bytes) */
-	u32 orig_ramsize;	/* Size of RAM in SOCRAM (bytes) */
 
 	u32 hostintmask;	/* Copy of Host Interrupt Mask */
 	u32 intstatus;	/* Intstatus bits (events) pending */
@@ -772,11 +771,6 @@ module_param(brcmf_poll, uint, 0);
 uint brcmf_intr = true;
 module_param(brcmf_intr, uint, 0);
 
-/* override the RAM size if possible */
-#define DONGLE_MIN_MEMSIZE (128 * 1024)
-int brcmf_dongle_memsize;
-module_param(brcmf_dongle_memsize, int, 0);
-
 #define RETRYCHAN(chan) ((chan) == SDPCM_EVENT_CHANNEL)
 
 /* Retry count for register access failures */
@@ -857,17 +851,6 @@ static void brcmf_sdbrcm_pktfree2(struct brcmf_bus *bus, struct sk_buff *pkt)
 		brcmu_pkt_buf_free_skb(pkt);
 }
 
-static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size)
-{
-	s32 min_size = DONGLE_MIN_MEMSIZE;
-	/* Restrict the memsize to user specified limit */
-	brcmf_dbg(ERROR, "user: Restrict the dongle ram size to %d, min %d\n",
-		  brcmf_dongle_memsize, min_size);
-	if ((brcmf_dongle_memsize > min_size) &&
-	    (brcmf_dongle_memsize < (s32) bus->orig_ramsize))
-		bus->ramsize = brcmf_dongle_memsize;
-}
-
 static void brcmf_sdbrcm_sdlock(struct brcmf_bus *bus)
 {
 	if (bus->threads_only)
@@ -3531,11 +3514,10 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 	}
 
 	/* adjust to the user specified RAM */
-	brcmf_dbg(INFO, "Physical memory size: %d, usable memory size: %d\n",
-		  bus->orig_ramsize, bus->ramsize);
+	brcmf_dbg(INFO, "Physical memory size: %d\n", bus->ramsize);
 	brcmf_dbg(INFO, "Vars are at %d, orig varsize is %d\n",
 		  varaddr, varsize);
-	varsize = ((bus->orig_ramsize - 4) - varaddr);
+	varsize = ((bus->ramsize - 4) - varaddr);
 
 	/*
 	 * Determine the length token:
@@ -3555,7 +3537,7 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 		  varsize, varsizew);
 
 	/* Write the length token to the last word */
-	bcmerror = brcmf_sdbrcm_membytes(bus, true, (bus->orig_ramsize - 4),
+	bcmerror = brcmf_sdbrcm_membytes(bus, true, (bus->ramsize - 4),
 					 (u8 *)&varsizew_le, 4);
 
 	return bcmerror;
@@ -4630,17 +4612,11 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 	/* Get info on the ARM and SOCRAM cores... */
 	brcmf_sdcard_reg_read(bus->sdiodev,
 		  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
-	bus->orig_ramsize = bus->ci->ramsize;
-	if (!(bus->orig_ramsize)) {
+	bus->ramsize = bus->ci->ramsize;
+	if (!(bus->ramsize)) {
 		brcmf_dbg(ERROR, "failed to find SOCRAM memory!\n");
 		goto fail;
 	}
-	bus->ramsize = bus->orig_ramsize;
-	if (brcmf_dongle_memsize)
-		brcmf_sdbrcm_setmemsize(bus, brcmf_dongle_memsize);
-
-	brcmf_dbg(ERROR, "DHD: dongle ram size is set to %d(orig %d)\n",
-		  bus->ramsize, bus->orig_ramsize);
 
 	/* Set core control so an SDIO reset does a backplane reset */
 	reg_addr = bus->ci->buscorebase +
@@ -4819,7 +4795,6 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	 */
 	brcmf_txbound = BRCMF_TXBOUND;
 	brcmf_rxbound = BRCMF_RXBOUND;
-	brcmf_dongle_memsize = 0;
 	brcmf_txminmax = BRCMF_TXMINMAX;
 
 	brcmf_c_init();
-- 
1.7.1


