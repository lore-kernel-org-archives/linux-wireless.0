Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3804 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab1ILKPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 16/20] staging: brcm80211: removed several unused
 softmac main.h struct members
Date: Mon, 12 Sep 2011 12:15:00 +0200
Message-ID: <1315822504-24210-17-git-send-email-rvossen@broadcom.com> (sfid-20110912_121550_389780_A7DB815A)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Members were always set to zero, or set but never read.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   13 +------------
 drivers/staging/brcm80211/brcmsmac/main.h |   13 -------------
 2 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 13f6cd4..9df2f86 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -2384,9 +2384,7 @@ static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
 				       null_ether_addr);
 	} else {
 		/* resume tx fifos */
-		if (!wlc_hw->wlc->tx_suspended)
-			brcms_b_tx_fifo_resume(wlc_hw, TX_DATA_FIFO);
-
+		brcms_b_tx_fifo_resume(wlc_hw, TX_DATA_FIFO);
 		brcms_b_tx_fifo_resume(wlc_hw, TX_CTL_FIFO);
 		brcms_b_tx_fifo_resume(wlc_hw, TX_AC_BK_FIFO);
 		brcms_b_tx_fifo_resume(wlc_hw, TX_AC_VI_FIFO);
@@ -2774,10 +2772,6 @@ void brcms_c_coredisable(struct brcms_hardware *wlc_hw)
 	/* turn off PHYPLL to save power */
 	brcms_b_core_phypll_ctl(wlc_hw, false);
 
-	/* remove gpio controls */
-	if (wlc_hw->ucode_dbgsel)
-		ai_gpiocontrol(wlc_hw->sih, ~0, 0, GPIO_DRV_PRIORITY);
-
 	wlc_hw->clk = false;
 	ai_core_disable(wlc_hw->sih, 0);
 	wlc_phy_hw_clk_state_upd(wlc_hw->band->pi, false);
@@ -3601,9 +3595,6 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	/* clear tx flow control */
 	brcms_c_txflowcontrol_reset(wlc);
 
-	/* clear tx data fifo suspends */
-	wlc->tx_suspended = false;
-
 	/* enable the RF Disable Delay timer */
 	W_REG(&wlc->regs->rfdisabledly, RFDISABLE_DEFAULT);
 
@@ -4380,8 +4371,6 @@ bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit)
 void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 {
 	int i;
-	/* Assume the device is there until proven otherwise */
-	wlc->device_present = true;
 
 	/* Save our copy of the chanspec */
 	wlc->chanspec = ch20mhz_chspec(1);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index d418686..1ee283c 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -382,7 +382,6 @@ struct brcms_hardware {
 	u32 boardflags2;	/* More board flags if sromrev >= 4 */
 	u32 machwcap;	/* MAC capabilities */
 	u32 machwcap_backup;	/* backup of machwcap */
-	u16 ucode_dbgsel;	/* dbgsel for ucode debug(config gpio) */
 
 	struct si_pub *sih;	/* SI handle (cookie for siutils calls) */
 	char *vars;		/* "environment" name=value */
@@ -416,14 +415,11 @@ struct brcms_hardware {
 	u32 wake_override;	/* bit flags to force MAC to WAKE mode */
 	u32 mute_override;	/* Prevent ucode from sending beacons */
 	u8 etheraddr[ETH_ALEN];	/* currently configured ethernet address */
-	u32 led_gpio_mask;	/* LED GPIO Mask */
 	bool noreset;		/* true= do not reset hw, used by WLC_OUT */
 	bool forcefastclk;	/* true if h/w is forcing to use fast clk */
 	bool clk;		/* core is out of reset and has clock */
 	bool sbclk;		/* sb has clock */
-	struct bmac_pmq *bmac_pmq; /*  bmac PM states derived from ucode PMQ */
 	bool phyclk;		/* phy is out of reset and has clock */
-	bool dma_lpbk;		/* core is in DMA loopback */
 
 	bool ucode_loaded;	/* true after ucode downloaded */
 
@@ -463,14 +459,12 @@ struct brcms_txq_info {
  * macintstatus: bit channel between isr and dpc.
  * macintmask: sw runtime master macintmask value.
  * defmacintmask: default "on" macintmask value.
- * device_present: (removable) device is present.
  * clk: core is out of reset and has clock.
  * core: pointer to active io core.
  * band: pointer to active per-band state.
  * corestate: per-core state (one per hw core).
  * bandstate: per-band state (one per phy/radio).
  * war16165: PCI slow clock 16165 war flag.
- * tx_suspended: data fifos need to remain suspended.
  * txpend16165war: PCI slow clock 16165 war flag.
  * qvalid: DirFrmQValid and BcMcFrmQValid.
  * txpwr_local_max: regulatory local txpwr max.
@@ -559,7 +553,6 @@ struct brcms_c_info {
 	struct brcms_hardware *hw;
 
 	/* clock */
-	int clkreq_override;
 	u16 fastpwrup_dly;
 
 	/* interrupt */
@@ -567,9 +560,6 @@ struct brcms_c_info {
 	u32 macintmask;
 	u32 defmacintmask;
 
-	/* up and down */
-	bool device_present;
-
 	bool clk;
 
 	/* multiband */
@@ -579,9 +569,6 @@ struct brcms_c_info {
 	struct brcms_band *bandstate[MAXBANDS];
 
 	bool war16165;
-
-	bool tx_suspended;
-
 	uint txpend16165war;
 
 	/* packet queue */
-- 
1.7.4.1


