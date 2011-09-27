Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4760 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab1I0Rpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:52 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 07/26] staging: brcm80211: removed unused softmac
 workaround
Date: Tue, 27 Sep 2011 10:45:11 -0700
Message-ID: <1317145530-18839-8-git-send-email-frankyl@broadcom.com> (sfid-20110927_194609_185652_3BF2DAB0)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

WAR16165 is only used on older PCI chips, the driver does not support
these chips.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |    9 -------
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    2 -
 drivers/staging/brcm80211/brcmsmac/d11.h     |    3 +-
 drivers/staging/brcm80211/brcmsmac/main.c    |   31 --------------------------
 drivers/staging/brcm80211/brcmsmac/main.h    |    5 ----
 5 files changed, 1 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index d05c4ba..790fdce 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1852,15 +1852,6 @@ int ai_devpath(struct si_pub *sih, char *path, int size)
 	return 0;
 }
 
-bool ai_pci_war16165(struct si_pub *sih)
-{
-	struct si_info *sii;
-
-	sii = (struct si_info *)sih;
-
-	return PCI(sii) && (sih->buscorerev <= 10);
-}
-
 void ai_pci_up(struct si_pub *sih)
 {
 	struct si_info *sii;
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index a776945..3917192 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -322,8 +322,6 @@ extern void ai_write_wrap_reg(struct si_pub *sih, u32 offset, u32 val);
 extern struct si_pub *ai_attach(void *regs, struct pci_dev *sdh, char **vars,
 				uint *varsz);
 extern void ai_detach(struct si_pub *sih);
-extern bool ai_pci_war16165(struct si_pub *sih);
-
 extern uint ai_coreid(struct si_pub *sih);
 extern uint ai_corerev(struct si_pub *sih);
 extern uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index 14e60a5..cbb574a 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -1330,8 +1330,7 @@ struct shm_acparams {
 #define	MHF1_FORCEFASTCLK	0x0400
 
 /* Flags in M_HOST_FLAGS2 */
-/* PR16165WAR : Enable ucode PCI slow clock WAR */
-#define MHF2_PCISLOWCLKWAR	0x0008
+
 /* Flush BCMC FIFO immediately */
 #define MHF2_TXBCMC_NOW		0x0040
 /* Enable ucode/hw power control */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 4d5c842..3ec952c 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -829,19 +829,6 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 	return n >= bound_limit;
 }
 
-static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx)
-{
-	if (tx) {
-		/* the post-increment is used in STAY_AWAKE macro */
-		if (wlc->txpend16165war++ == 0)
-			brcms_c_set_ps_ctrl(wlc);
-	} else {
-		wlc->txpend16165war--;
-		if (wlc->txpend16165war == 0)
-			brcms_c_set_ps_ctrl(wlc);
-	}
-}
-
 /* process an individual struct tx_status */
 static bool
 brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
@@ -879,8 +866,6 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	}
 
 	p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
-	if (wlc->war16165)
-		brcms_c_war16165(wlc, false);
 	if (p == NULL)
 		goto fatal;
 
@@ -3109,8 +3094,6 @@ static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	uint i;
 
-	wlc->txpend16165war = 0;
-
 	/* free any posted tx packets */
 	for (i = 0; i < NFIFO; i++)
 		if (wlc_hw->di[i]) {
@@ -3532,9 +3515,6 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 	AND_REG(&regs->ifs_ctl, 0x0FFF);
 	W_REG(&regs->ifs_aifsn, EDCF_AIFSN_MIN);
 
-	/* dma initializations */
-	wlc->txpend16165war = 0;
-
 	/* init the tx dma engines */
 	for (i = 0; i < NFIFO; i++) {
 		if (wlc_hw->di[i])
@@ -4832,9 +4812,6 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
 		brcms_b_pllreq(wlc_hw, true, BRCMS_PLLREQ_SHARED);
 
-	if (ai_pci_war16165(wlc_hw->sih))
-		wlc->war16165 = true;
-
 	/* check device id(srom, nvram etc.) to set bands */
 	if (wlc_hw->deviceid == BCM43224_D11N_ID ||
 	    wlc_hw->deviceid == BCM43224_D11N_ID_VEN1)
@@ -5833,10 +5810,6 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	/* Set EDCF hostflags */
 	brcms_c_mhf(wlc, MHF1, MHF1_EDCF, MHF1_EDCF, BRCM_BAND_ALL);
 
-	if (wlc->war16165)
-		brcms_c_mhf(wlc, MHF2, MHF2_PCISLOWCLKWAR, MHF2_PCISLOWCLKWAR,
-			BRCM_BAND_ALL);
-
 	brcms_init(wlc->wl);
 	wlc->pub->up = true;
 
@@ -7816,10 +7789,6 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	if (fifo == TX_BCMC_FIFO)
 		frameid = le16_to_cpu(txh->TxFrameID);
 
-	if (wlc->war16165)
-		brcms_c_war16165(wlc, true);
-
-
 	/*
 	 * Bump up pending count for if not using rpc. If rpc is
 	 * used, this will be handled in brcms_b_txfifo()
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index d6de9c3..717843a 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -416,8 +416,6 @@ struct brcms_txq_info {
  * band: pointer to active per-band state.
  * corestate: per-core state (one per hw core).
  * bandstate: per-band state (one per phy/radio).
- * war16165: PCI slow clock 16165 war flag.
- * txpend16165war: PCI slow clock 16165 war flag.
  * qvalid: DirFrmQValid and BcMcFrmQValid.
  * ampdu: ampdu module handler.
  * asi: antsel module handler.
@@ -508,9 +506,6 @@ struct brcms_c_info {
 	struct brcms_core *corestate;
 	struct brcms_band *bandstate[MAXBANDS];
 
-	bool war16165;
-	uint txpend16165war;
-
 	/* packet queue */
 	uint qvalid;
 
-- 
1.7.1


