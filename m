Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1452 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/31] staging: brcm80211: renamed structures in softmac
Date: Wed, 6 Jul 2011 00:02:42 +0200
Message-ID: <1309903378-29021-16-git-send-email-arend@broadcom.com> (sfid-20110706_000342_988403_336F1BCA)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Several structures contained a '_c_' in their name that does not add any
information.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c    |   36 ++--
 drivers/staging/brcm80211/brcmsmac/ampdu.c    |    4 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.h    |    2 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c     |  290 ++++++++++++------------
 drivers/staging/brcm80211/brcmsmac/bmac.h     |   96 ++++----
 drivers/staging/brcm80211/brcmsmac/channel.c  |    6 +-
 drivers/staging/brcm80211/brcmsmac/main.c     |   84 ++++----
 drivers/staging/brcm80211/brcmsmac/main.h     |   81 +++----
 drivers/staging/brcm80211/brcmsmac/phy_shim.c |    4 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/stf.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/stf.h      |    2 +-
 drivers/staging/brcm80211/brcmsmac/types.h    |    6 +-
 13 files changed, 304 insertions(+), 311 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index 62770b3..bf01ba0 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -20,8 +20,8 @@
 #include "main.h"
 #include "alloc.h"
 
-static struct brcms_c_bsscfg *brcms_c_bsscfg_malloc(uint unit);
-static void brcms_c_bsscfg_mfree(struct brcms_c_bsscfg *cfg);
+static struct brcms_bss_cfg *brcms_c_bsscfg_malloc(uint unit);
+static void brcms_c_bsscfg_mfree(struct brcms_bss_cfg *cfg);
 static struct brcms_pub *brcms_c_pub_malloc(uint unit,
 				      uint *err, uint devid);
 static void brcms_c_pub_mfree(struct brcms_pub *pub);
@@ -87,11 +87,11 @@ static void brcms_c_pub_mfree(struct brcms_pub *pub)
 	kfree(pub);
 }
 
-static struct brcms_c_bsscfg *brcms_c_bsscfg_malloc(uint unit)
+static struct brcms_bss_cfg *brcms_c_bsscfg_malloc(uint unit)
 {
-	struct brcms_c_bsscfg *cfg;
+	struct brcms_bss_cfg *cfg;
 
-	cfg = kzalloc(sizeof(struct brcms_c_bsscfg), GFP_ATOMIC);
+	cfg = kzalloc(sizeof(struct brcms_bss_cfg), GFP_ATOMIC);
 	if (cfg == NULL)
 		goto fail;
 
@@ -106,7 +106,7 @@ static struct brcms_c_bsscfg *brcms_c_bsscfg_malloc(uint unit)
 	return NULL;
 }
 
-static void brcms_c_bsscfg_mfree(struct brcms_c_bsscfg *cfg)
+static void brcms_c_bsscfg_mfree(struct brcms_bss_cfg *cfg)
 {
 	if (cfg == NULL)
 		return;
@@ -117,7 +117,7 @@ static void brcms_c_bsscfg_mfree(struct brcms_c_bsscfg *cfg)
 }
 
 static void brcms_c_bsscfg_ID_assign(struct brcms_c_info *wlc,
-				 struct brcms_c_bsscfg *bsscfg)
+				 struct brcms_bss_cfg *bsscfg)
 {
 	bsscfg->ID = wlc->next_bsscfg_ID;
 	wlc->next_bsscfg_ID++;
@@ -144,9 +144,9 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	}
 	wlc->pub->wlc = wlc;
 
-	/* allocate struct brcms_c_hw_info state structure */
+	/* allocate struct brcms_hardware state structure */
 
-	wlc->hw = kzalloc(sizeof(struct brcms_c_hw_info), GFP_ATOMIC);
+	wlc->hw = kzalloc(sizeof(struct brcms_hardware), GFP_ATOMIC);
 	if (wlc->hw == NULL) {
 		*err = 1005;
 		goto fail;
@@ -154,7 +154,7 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	wlc->hw->wlc = wlc;
 
 	wlc->hw->bandstate[0] =
-		kzalloc(sizeof(struct brcms_c_hwband) * MAXBANDS, GFP_ATOMIC);
+		kzalloc(sizeof(struct brcms_hw_band) * MAXBANDS, GFP_ATOMIC);
 	if (wlc->hw->bandstate[0] == NULL) {
 		*err = 1006;
 		goto fail;
@@ -162,9 +162,9 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 		int i;
 
 		for (i = 1; i < MAXBANDS; i++) {
-			wlc->hw->bandstate[i] = (struct brcms_c_hwband *)
+			wlc->hw->bandstate[i] = (struct brcms_hw_band *)
 			    ((unsigned long)wlc->hw->bandstate[0] +
-			     (sizeof(struct brcms_c_hwband) * i));
+			     (sizeof(struct brcms_hw_band) * i));
 		}
 	}
 
@@ -202,21 +202,21 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 		}
 	}
 
-	wlc->protection = kzalloc(sizeof(struct brcms_c_protection),
+	wlc->protection = kzalloc(sizeof(struct brcms_protection),
 				  GFP_ATOMIC);
 	if (wlc->protection == NULL) {
 		*err = 1016;
 		goto fail;
 	}
 
-	wlc->stf = kzalloc(sizeof(struct brcms_c_stf), GFP_ATOMIC);
+	wlc->stf = kzalloc(sizeof(struct brcms_stf), GFP_ATOMIC);
 	if (wlc->stf == NULL) {
 		*err = 1017;
 		goto fail;
 	}
 
 	wlc->bandstate[0] =
-		kzalloc(sizeof(struct brcms_c_band)*MAXBANDS, GFP_ATOMIC);
+		kzalloc(sizeof(struct brcms_band)*MAXBANDS, GFP_ATOMIC);
 	if (wlc->bandstate[0] == NULL) {
 		*err = 1025;
 		goto fail;
@@ -224,13 +224,13 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 		int i;
 
 		for (i = 1; i < MAXBANDS; i++) {
-			wlc->bandstate[i] = (struct brcms_c_band *)
+			wlc->bandstate[i] = (struct brcms_band *)
 				((unsigned long)wlc->bandstate[0]
-				+ (sizeof(struct brcms_c_band)*i));
+				+ (sizeof(struct brcms_band)*i));
 		}
 	}
 
-	wlc->corestate = kzalloc(sizeof(struct brcms_c_core), GFP_ATOMIC);
+	wlc->corestate = kzalloc(sizeof(struct brcms_core), GFP_ATOMIC);
 	if (wlc->corestate == NULL) {
 		*err = 1026;
 		goto fail;
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 4060ee2..599f6e9 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -436,7 +436,7 @@ brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 }
 
 int
-brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
+brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 	      struct sk_buff **pdu, int prec)
 {
 	struct brcms_c_info *wlc;
@@ -1204,7 +1204,7 @@ static void dma_cb_fn_ampdu(void *txi, void *arg_a)
 void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 		     struct ieee80211_sta *sta, u16 tid)
 {
-	struct brcms_c_txq_info *qi = wlc->pkt_queue;
+	struct brcms_txq_info *qi = wlc->pkt_queue;
 	struct pktq *pq = &qi->q;
 	int prec;
 	struct cb_del_ampdu_pars ampdu_pars;
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.h b/drivers/staging/brcm80211/brcmsmac/ampdu.h
index 07b53fc..421f4ba 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.h
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.h
@@ -20,7 +20,7 @@
 extern struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc);
 extern void brcms_c_ampdu_detach(struct ampdu_info *ampdu);
 extern int brcms_c_sendampdu(struct ampdu_info *ampdu,
-			     struct brcms_c_txq_info *qi,
+			     struct brcms_txq_info *qi,
 			     struct sk_buff **aggp, int prec);
 extern void brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 				 struct sk_buff *p, struct tx_status *txs);
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index b0446d8..6f1203c 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -71,79 +71,79 @@ static u16 xmtfifo_sz[][NFIFO] = {
 	{9, 58, 22, 14, 14, 5},	/* corerev 24: 2304, 14848, 5632, 3584, 3584, 1280 */
 };
 
-static void brcms_b_clkctl_clk(struct brcms_c_hw_info *wlc, uint mode);
+static void brcms_b_clkctl_clk(struct brcms_hardware *wlc, uint mode);
 static void brcms_b_coreinit(struct brcms_c_info *wlc);
 
 /* used by wlc_wakeucode_init() */
-static void brcms_c_write_inits(struct brcms_c_hw_info *wlc_hw,
+static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 			    const struct d11init *inits);
-static void brcms_ucode_write(struct brcms_c_hw_info *wlc_hw, const u32 ucode[],
+static void brcms_ucode_write(struct brcms_hardware *wlc_hw, const u32 ucode[],
 			    const uint nbytes);
-static void brcms_ucode_download(struct brcms_c_hw_info *wlc);
-static void brcms_c_ucode_txant_set(struct brcms_c_hw_info *wlc_hw);
+static void brcms_ucode_download(struct brcms_hardware *wlc);
+static void brcms_c_ucode_txant_set(struct brcms_hardware *wlc_hw);
 
 /* used by brcms_c_dpc() */
-static bool brcms_b_dotxstatus(struct brcms_c_hw_info *wlc,
+static bool brcms_b_dotxstatus(struct brcms_hardware *wlc,
 			       struct tx_status *txs, u32 s2);
-static bool brcms_b_txstatus(struct brcms_c_hw_info *wlc, bool bound,
+static bool brcms_b_txstatus(struct brcms_hardware *wlc, bool bound,
 			     bool *fatal);
-static bool brcms_b_recv(struct brcms_c_hw_info *wlc_hw, uint fifo, bool bound);
+static bool brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound);
 
 /* used by brcms_c_down() */
 static void brcms_c_flushqueues(struct brcms_c_info *wlc);
 
-static void brcms_c_write_mhf(struct brcms_c_hw_info *wlc_hw, u16 *mhfs);
-static void brcms_c_mctrl_reset(struct brcms_c_hw_info *wlc_hw);
-static void brcms_b_corerev_fifofixup(struct brcms_c_hw_info *wlc_hw);
-static bool brcms_b_tx_fifo_suspended(struct brcms_c_hw_info *wlc_hw,
+static void brcms_c_write_mhf(struct brcms_hardware *wlc_hw, u16 *mhfs);
+static void brcms_c_mctrl_reset(struct brcms_hardware *wlc_hw);
+static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw);
+static bool brcms_b_tx_fifo_suspended(struct brcms_hardware *wlc_hw,
 				       uint tx_fifo);
-static void brcms_b_tx_fifo_suspend(struct brcms_c_hw_info *wlc_hw,
+static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
 				    uint tx_fifo);
-static void brcms_b_tx_fifo_resume(struct brcms_c_hw_info *wlc_hw,
+static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 				   uint tx_fifo);
 
 /* Low Level Prototypes */
-static int brcms_b_bandtype(struct brcms_c_hw_info *wlc_hw);
-static void brcms_b_info_init(struct brcms_c_hw_info *wlc_hw);
-static void brcms_b_xtal(struct brcms_c_hw_info *wlc_hw, bool want);
-static u16 brcms_b_read_objmem(struct brcms_c_hw_info *wlc_hw, uint offset,
+static int brcms_b_bandtype(struct brcms_hardware *wlc_hw);
+static void brcms_b_info_init(struct brcms_hardware *wlc_hw);
+static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want);
+static u16 brcms_b_read_objmem(struct brcms_hardware *wlc_hw, uint offset,
 				   u32 sel);
-static void brcms_b_write_objmem(struct brcms_c_hw_info *wlc_hw, uint offset,
+static void brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset,
 				  u16 v, u32 sel);
-static void brcms_b_core_phy_clk(struct brcms_c_hw_info *wlc_hw, bool clk);
+static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk);
 static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme);
-static void brcms_b_detach_dmapio(struct brcms_c_hw_info *wlc_hw);
-static void brcms_c_ucode_bsinit(struct brcms_c_hw_info *wlc_hw);
-static bool brcms_c_validboardtype(struct brcms_c_hw_info *wlc);
-static bool brcms_c_isgoodchip(struct brcms_c_hw_info *wlc_hw);
-static bool brcms_b_validate_chip_access(struct brcms_c_hw_info *wlc_hw);
-static char *brcms_c_get_macaddr(struct brcms_c_hw_info *wlc_hw);
+static void brcms_b_detach_dmapio(struct brcms_hardware *wlc_hw);
+static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw);
+static bool brcms_c_validboardtype(struct brcms_hardware *wlc);
+static bool brcms_c_isgoodchip(struct brcms_hardware *wlc_hw);
+static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw);
+static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw);
 static void brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init);
-static void brcms_c_mctrl_write(struct brcms_c_hw_info *wlc_hw);
-static void brcms_b_mute(struct brcms_c_hw_info *wlc_hw, bool want,
+static void brcms_c_mctrl_write(struct brcms_hardware *wlc_hw);
+static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool want,
 			 mbool flags);
-static void brcms_c_ucode_mute_override_set(struct brcms_c_hw_info *wlc_hw);
-static void brcms_c_ucode_mute_override_clear(struct brcms_c_hw_info *wlc_hw);
+static void brcms_c_ucode_mute_override_set(struct brcms_hardware *wlc_hw);
+static void brcms_c_ucode_mute_override_clear(struct brcms_hardware *wlc_hw);
 static u32 brcms_c_wlintrsoff(struct brcms_c_info *wlc);
 static void brcms_c_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask);
 static void brcms_c_gpio_init(struct brcms_c_info *wlc);
-static void brcms_c_write_hw_bcntemplate0(struct brcms_c_hw_info *wlc_hw,
+static void brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw,
 					  void *bcn, int len);
-static void brcms_c_write_hw_bcntemplate1(struct brcms_c_hw_info *wlc_hw,
+static void brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw,
 					  void *bcn, int len);
 static void brcms_b_bsinit(struct brcms_c_info *wlc, chanspec_t chanspec);
 static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit);
-static void brcms_b_setband(struct brcms_c_hw_info *wlc_hw, uint bandunit,
+static void brcms_b_setband(struct brcms_hardware *wlc_hw, uint bandunit,
 			     chanspec_t chanspec);
-static void brcms_b_update_slot_timing(struct brcms_c_hw_info *wlc_hw,
+static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
 					bool shortslot);
-static void brcms_upd_ofdm_pctl1_table(struct brcms_c_hw_info *wlc_hw);
-static u16 brcms_b_ofdm_ratetable_offset(struct brcms_c_hw_info *wlc_hw,
+static void brcms_upd_ofdm_pctl1_table(struct brcms_hardware *wlc_hw);
+static u16 brcms_b_ofdm_ratetable_offset(struct brcms_hardware *wlc_hw,
 					     u8 rate);
 
 /* === Low Level functions === */
 
-void brcms_b_set_shortslot(struct brcms_c_hw_info *wlc_hw, bool shortslot)
+void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
 {
 	wlc_hw->shortslot = shortslot;
 
@@ -159,7 +159,7 @@ void brcms_b_set_shortslot(struct brcms_c_hw_info *wlc_hw, bool shortslot)
  * or shortslot 11g (9us slots)
  * The PSM needs to be suspended for this call.
  */
-static void brcms_b_update_slot_timing(struct brcms_c_hw_info *wlc_hw,
+static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
 					bool shortslot)
 {
 	d11regs_t *regs;
@@ -177,7 +177,7 @@ static void brcms_b_update_slot_timing(struct brcms_c_hw_info *wlc_hw,
 	}
 }
 
-static void WLBANDINITFN(brcms_c_ucode_bsinit) (struct brcms_c_hw_info *wlc_hw)
+static void WLBANDINITFN(brcms_c_ucode_bsinit) (struct brcms_hardware *wlc_hw)
 {
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
@@ -213,7 +213,7 @@ static void WLBANDINITFN(brcms_c_ucode_bsinit) (struct brcms_c_hw_info *wlc_hw)
 static u32 WLBANDINITFN(brcms_c_setband_inact) (struct brcms_c_info *wlc,
 					    uint bandunit)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	u32 macintmask;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
@@ -239,7 +239,7 @@ static u32 WLBANDINITFN(brcms_c_setband_inact) (struct brcms_c_info *wlc,
  * Param 'bound' indicates max. # frames to process before break out.
  */
 static bool
-brcms_b_recv(struct brcms_c_hw_info *wlc_hw, uint fifo, bool bound)
+brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 {
 	struct sk_buff *p;
 	struct sk_buff *head = NULL;
@@ -290,7 +290,7 @@ brcms_b_recv(struct brcms_c_hw_info *wlc_hw, uint fifo, bool bound)
 bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 {
 	u32 macintstatus;
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	d11regs_t *regs = wlc_hw->regs;
 	bool fatal = false;
 	struct wiphy *wiphy = wlc->wiphy;
@@ -394,7 +394,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 void brcms_b_watchdog(void *arg)
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -414,7 +414,7 @@ void brcms_b_watchdog(void *arg)
 }
 
 void
-brcms_b_set_chanspec(struct brcms_c_hw_info *wlc_hw, chanspec_t chanspec,
+brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
 		      bool mute, struct txpwr_limits *txpwr)
 {
 	uint bandunit;
@@ -457,7 +457,7 @@ brcms_b_set_chanspec(struct brcms_c_hw_info *wlc_hw, chanspec_t chanspec,
 	}
 }
 
-int brcms_b_state_get(struct brcms_c_hw_info *wlc_hw,
+int brcms_b_state_get(struct brcms_hardware *wlc_hw,
 		      struct brcms_b_state *state)
 {
 	state->machwcap = wlc_hw->machwcap;
@@ -471,7 +471,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 	char name[8];
 	/* ucode host flag 2 needed for pio mode, independent of band and fifo */
 	u16 pio_mhf2 = 0;
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	uint unit = wlc_hw->unit;
 	struct brcms_tunables *tune = wlc->pub->tunables;
 	struct wiphy *wiphy = wlc->wiphy;
@@ -562,7 +562,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 	return true;
 }
 
-static void brcms_b_detach_dmapio(struct brcms_c_hw_info *wlc_hw)
+static void brcms_b_detach_dmapio(struct brcms_hardware *wlc_hw)
 {
 	uint j;
 
@@ -583,7 +583,7 @@ static void brcms_b_detach_dmapio(struct brcms_c_hw_info *wlc_hw)
 int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 		    bool piomode, void *regsva, uint bustype, void *btparam)
 {
-	struct brcms_c_hw_info *wlc_hw;
+	struct brcms_hardware *wlc_hw;
 	d11regs_t *regs;
 	char *macaddr = NULL;
 	char *vars;
@@ -604,7 +604,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->band = wlc_hw->bandstate[0];
 	wlc_hw->_piomode = piomode;
 
-	/* populate struct brcms_c_hw_info with default values  */
+	/* populate struct brcms_hardware with default values  */
 	brcms_b_info_init(wlc_hw);
 
 	/*
@@ -929,7 +929,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
  * may get overrides later in this function
  *  BMAC_NOTES, move low out and resolve the dangling ones
  */
-static void brcms_b_info_init(struct brcms_c_hw_info *wlc_hw)
+static void brcms_b_info_init(struct brcms_hardware *wlc_hw)
 {
 	struct brcms_c_info *wlc = wlc_hw->wlc;
 
@@ -954,8 +954,8 @@ static void brcms_b_info_init(struct brcms_c_hw_info *wlc_hw)
 int brcms_b_detach(struct brcms_c_info *wlc)
 {
 	uint i;
-	struct brcms_c_hwband *band;
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hw_band *band;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	int callbacks;
 
 	callbacks = 0;
@@ -1000,7 +1000,7 @@ int brcms_b_detach(struct brcms_c_info *wlc)
 
 }
 
-void brcms_b_reset(struct brcms_c_hw_info *wlc_hw)
+void brcms_b_reset(struct brcms_hardware *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -1015,7 +1015,7 @@ void brcms_b_reset(struct brcms_c_hw_info *wlc_hw)
 }
 
 void
-brcms_b_init(struct brcms_c_hw_info *wlc_hw, chanspec_t chanspec,
+brcms_b_init(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
 			  bool mute) {
 	u32 macintmask;
 	bool fastclk;
@@ -1066,7 +1066,7 @@ brcms_b_init(struct brcms_c_hw_info *wlc_hw, chanspec_t chanspec,
 		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
 }
 
-int brcms_b_up_prep(struct brcms_c_hw_info *wlc_hw)
+int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 {
 	uint coremask;
 
@@ -1110,7 +1110,7 @@ int brcms_b_up_prep(struct brcms_c_hw_info *wlc_hw)
 	return 0;
 }
 
-int brcms_b_up_finish(struct brcms_c_hw_info *wlc_hw)
+int brcms_b_up_finish(struct brcms_hardware *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -1123,7 +1123,7 @@ int brcms_b_up_finish(struct brcms_c_hw_info *wlc_hw)
 	return 0;
 }
 
-int brcms_b_bmac_down_prep(struct brcms_c_hw_info *wlc_hw)
+int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw)
 {
 	bool dev_gone;
 	uint callbacks = 0;
@@ -1151,7 +1151,7 @@ int brcms_b_bmac_down_prep(struct brcms_c_hw_info *wlc_hw)
 	return callbacks;
 }
 
-int brcms_b_down_finish(struct brcms_c_hw_info *wlc_hw)
+int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
 {
 	uint callbacks = 0;
 	bool dev_gone;
@@ -1195,7 +1195,7 @@ int brcms_b_down_finish(struct brcms_c_hw_info *wlc_hw)
 	return callbacks;
 }
 
-void brcms_b_wait_for_wake(struct brcms_c_hw_info *wlc_hw)
+void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
 {
 	/* delay before first read of ucode state */
 	udelay(40);
@@ -1205,18 +1205,18 @@ void brcms_b_wait_for_wake(struct brcms_c_hw_info *wlc_hw)
 		  DBGST_ASLEEP), wlc_hw->wlc->fastpwrup_dly);
 }
 
-void brcms_b_hw_etheraddr(struct brcms_c_hw_info *wlc_hw, u8 *ea)
+void brcms_b_hw_etheraddr(struct brcms_hardware *wlc_hw, u8 *ea)
 {
 	memcpy(ea, wlc_hw->etheraddr, ETH_ALEN);
 }
 
-static int brcms_b_bandtype(struct brcms_c_hw_info *wlc_hw)
+static int brcms_b_bandtype(struct brcms_hardware *wlc_hw)
 {
 	return wlc_hw->band->bandtype;
 }
 
 /* control chip clock to save power, enable dynamic clock or force fast clock */
-static void brcms_b_clkctl_clk(struct brcms_c_hw_info *wlc_hw, uint mode)
+static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 {
 	if (PMUCTL_ENAB(wlc_hw->sih)) {
 		/* new chips with PMU, CCS_FORCEHT will distribute the HT clock on backplane,
@@ -1289,7 +1289,7 @@ static void brcms_b_clkctl_clk(struct brcms_c_hw_info *wlc_hw, uint mode)
 static void
 brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 
 	memset(mhfs, 0, MHFMAX * sizeof(u16));
 
@@ -1317,7 +1317,7 @@ brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
  *                   WLC_BAND_ALL  <--- All bands
  */
 void
-brcms_b_mhf(struct brcms_c_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
+brcms_b_mhf(struct brcms_hardware *wlc_hw, u8 idx, u16 mask, u16 val,
 	     int bands)
 {
 	u16 save;
@@ -1325,7 +1325,7 @@ brcms_b_mhf(struct brcms_c_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 		M_HOST_FLAGS1, M_HOST_FLAGS2, M_HOST_FLAGS3, M_HOST_FLAGS4,
 		M_HOST_FLAGS5
 	};
-	struct brcms_c_hwband *band;
+	struct brcms_hw_band *band;
 
 	if ((val & ~mask) || idx >= MHFMAX)
 		return; /* error condition */
@@ -1369,9 +1369,9 @@ brcms_b_mhf(struct brcms_c_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 	}
 }
 
-u16 brcms_b_mhf_get(struct brcms_c_hw_info *wlc_hw, u8 idx, int bands)
+u16 brcms_b_mhf_get(struct brcms_hardware *wlc_hw, u8 idx, int bands)
 {
-	struct brcms_c_hwband *band;
+	struct brcms_hw_band *band;
 
 	if (idx >= MHFMAX)
 		return 0; /* error condition */
@@ -1395,7 +1395,7 @@ u16 brcms_b_mhf_get(struct brcms_c_hw_info *wlc_hw, u8 idx, int bands)
 	return band->mhfs[idx];
 }
 
-static void brcms_c_write_mhf(struct brcms_c_hw_info *wlc_hw, u16 *mhfs)
+static void brcms_c_write_mhf(struct brcms_hardware *wlc_hw, u16 *mhfs)
 {
 	u8 idx;
 	u16 addr[] = {
@@ -1411,7 +1411,7 @@ static void brcms_c_write_mhf(struct brcms_c_hw_info *wlc_hw, u16 *mhfs)
 /* set the maccontrol register to desired reset state and
  * initialize the sw cache of the register
  */
-static void brcms_c_mctrl_reset(struct brcms_c_hw_info *wlc_hw)
+static void brcms_c_mctrl_reset(struct brcms_hardware *wlc_hw)
 {
 	/* IHR accesses are always enabled, PSM disabled, HPS off and WAKE on */
 	wlc_hw->maccontrol = 0;
@@ -1422,7 +1422,7 @@ static void brcms_c_mctrl_reset(struct brcms_c_hw_info *wlc_hw)
 }
 
 /* set or clear maccontrol bits */
-void brcms_b_mctrl(struct brcms_c_hw_info *wlc_hw, u32 mask, u32 val)
+void brcms_b_mctrl(struct brcms_hardware *wlc_hw, u32 mask, u32 val)
 {
 	u32 maccontrol;
 	u32 new_maccontrol;
@@ -1444,7 +1444,7 @@ void brcms_b_mctrl(struct brcms_c_hw_info *wlc_hw, u32 mask, u32 val)
 }
 
 /* write the software state of maccontrol and overrides to the maccontrol register */
-static void brcms_c_mctrl_write(struct brcms_c_hw_info *wlc_hw)
+static void brcms_c_mctrl_write(struct brcms_hardware *wlc_hw)
 {
 	u32 maccontrol = wlc_hw->maccontrol;
 
@@ -1461,7 +1461,7 @@ static void brcms_c_mctrl_write(struct brcms_c_hw_info *wlc_hw)
 	W_REG(&wlc_hw->regs->maccontrol, maccontrol);
 }
 
-void brcms_c_ucode_wake_override_set(struct brcms_c_hw_info *wlc_hw,
+void brcms_c_ucode_wake_override_set(struct brcms_hardware *wlc_hw,
 				 u32 override_bit)
 {
 	if (wlc_hw->wake_override || (wlc_hw->maccontrol & MCTL_WAKE)) {
@@ -1477,7 +1477,7 @@ void brcms_c_ucode_wake_override_set(struct brcms_c_hw_info *wlc_hw,
 	return;
 }
 
-void brcms_c_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
+void brcms_c_ucode_wake_override_clear(struct brcms_hardware *wlc_hw,
 				   u32 override_bit)
 {
 	mboolclr(wlc_hw->wake_override, override_bit);
@@ -1497,7 +1497,7 @@ void brcms_c_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
  * STA               0              1 <--- This will ensure no beacons
  * IBSS              0              0
  */
-static void brcms_c_ucode_mute_override_set(struct brcms_c_hw_info *wlc_hw)
+static void brcms_c_ucode_mute_override_set(struct brcms_hardware *wlc_hw)
 {
 	wlc_hw->mute_override = 1;
 
@@ -1513,7 +1513,7 @@ static void brcms_c_ucode_mute_override_set(struct brcms_c_hw_info *wlc_hw)
 }
 
 /* Clear the override on AP and INFRA bits */
-static void brcms_c_ucode_mute_override_clear(struct brcms_c_hw_info *wlc_hw)
+static void brcms_c_ucode_mute_override_clear(struct brcms_hardware *wlc_hw)
 {
 	if (wlc_hw->mute_override == 0)
 		return;
@@ -1533,7 +1533,7 @@ static void brcms_c_ucode_mute_override_clear(struct brcms_c_hw_info *wlc_hw)
  * Write a MAC address to the given match reg offset in the RXE match engine.
  */
 void
-brcms_b_set_addrmatch(struct brcms_c_hw_info *wlc_hw, int match_reg_offset,
+brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw, int match_reg_offset,
 		       const u8 *addr)
 {
 	d11regs_t *regs;
@@ -1558,7 +1558,7 @@ brcms_b_set_addrmatch(struct brcms_c_hw_info *wlc_hw, int match_reg_offset,
 }
 
 void
-brcms_b_write_template_ram(struct brcms_c_hw_info *wlc_hw, int offset, int len,
+brcms_b_write_template_ram(struct brcms_hardware *wlc_hw, int offset, int len,
 			    void *buf)
 {
 	d11regs_t *regs;
@@ -1590,7 +1590,7 @@ brcms_b_write_template_ram(struct brcms_c_hw_info *wlc_hw, int offset, int len,
 	}
 }
 
-void brcms_b_set_cwmin(struct brcms_c_hw_info *wlc_hw, u16 newmin)
+void brcms_b_set_cwmin(struct brcms_hardware *wlc_hw, u16 newmin)
 {
 	wlc_hw->band->CWmin = newmin;
 
@@ -1599,7 +1599,7 @@ void brcms_b_set_cwmin(struct brcms_c_hw_info *wlc_hw, u16 newmin)
 	W_REG(&wlc_hw->regs->objdata, newmin);
 }
 
-void brcms_b_set_cwmax(struct brcms_c_hw_info *wlc_hw, u16 newmax)
+void brcms_b_set_cwmax(struct brcms_hardware *wlc_hw, u16 newmax)
 {
 	wlc_hw->band->CWmax = newmax;
 
@@ -1608,7 +1608,7 @@ void brcms_b_set_cwmax(struct brcms_c_hw_info *wlc_hw, u16 newmax)
 	W_REG(&wlc_hw->regs->objdata, newmax);
 }
 
-void brcms_b_bw_set(struct brcms_c_hw_info *wlc_hw, u16 bw)
+void brcms_b_bw_set(struct brcms_hardware *wlc_hw, u16 bw)
 {
 	bool fastclk;
 
@@ -1628,7 +1628,7 @@ void brcms_b_bw_set(struct brcms_c_hw_info *wlc_hw, u16 bw)
 }
 
 static void
-brcms_c_write_hw_bcntemplate0(struct brcms_c_hw_info *wlc_hw, void *bcn,
+brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw, void *bcn,
 			      int len)
 {
 	d11regs_t *regs = wlc_hw->regs;
@@ -1642,7 +1642,7 @@ brcms_c_write_hw_bcntemplate0(struct brcms_c_hw_info *wlc_hw, void *bcn,
 }
 
 static void
-brcms_c_write_hw_bcntemplate1(struct brcms_c_hw_info *wlc_hw, void *bcn,
+brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw, void *bcn,
 			      int len)
 {
 	d11regs_t *regs = wlc_hw->regs;
@@ -1657,7 +1657,7 @@ brcms_c_write_hw_bcntemplate1(struct brcms_c_hw_info *wlc_hw, void *bcn,
 
 /* mac is assumed to be suspended at this point */
 void
-brcms_b_write_hw_bcntemplates(struct brcms_c_hw_info *wlc_hw, void *bcn,
+brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, void *bcn,
 			      int len, bool both)
 {
 	d11regs_t *regs = wlc_hw->regs;
@@ -1676,7 +1676,7 @@ brcms_b_write_hw_bcntemplates(struct brcms_c_hw_info *wlc_hw, void *bcn,
 	}
 }
 
-static void WLBANDINITFN(brcms_b_upd_synthpu) (struct brcms_c_hw_info *wlc_hw)
+static void WLBANDINITFN(brcms_b_upd_synthpu) (struct brcms_hardware *wlc_hw)
 {
 	u16 v;
 	struct brcms_c_info *wlc = wlc_hw->wlc;
@@ -1697,7 +1697,7 @@ static void WLBANDINITFN(brcms_b_upd_synthpu) (struct brcms_c_hw_info *wlc_hw)
 static void
 WLBANDINITFN(brcms_b_bsinit) (struct brcms_c_info *wlc, chanspec_t chanspec)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 
 	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
 		wlc_hw->band->bandunit);
@@ -1727,7 +1727,7 @@ WLBANDINITFN(brcms_b_bsinit) (struct brcms_c_info *wlc, chanspec_t chanspec)
 	brcms_b_upd_synthpu(wlc_hw);
 }
 
-static void brcms_b_core_phy_clk(struct brcms_c_hw_info *wlc_hw, bool clk)
+static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: clk %d\n", wlc_hw->unit, clk);
 
@@ -1752,7 +1752,7 @@ static void brcms_b_core_phy_clk(struct brcms_c_hw_info *wlc_hw, bool clk)
 }
 
 /* Perform a soft reset of the PHY PLL */
-void brcms_b_core_phypll_reset(struct brcms_c_hw_info *wlc_hw)
+void brcms_b_core_phypll_reset(struct brcms_hardware *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -1773,7 +1773,7 @@ void brcms_b_core_phypll_reset(struct brcms_c_hw_info *wlc_hw)
 /* light way to turn on phy clock without reset for NPHY only
  *  refer to brcms_b_core_phy_clk for full version
  */
-void brcms_b_phyclk_fgc(struct brcms_c_hw_info *wlc_hw, bool clk)
+void brcms_b_phyclk_fgc(struct brcms_hardware *wlc_hw, bool clk)
 {
 	/* support(necessary for NPHY and HYPHY) only */
 	if (!WLCISNPHY(wlc_hw->band))
@@ -1786,7 +1786,7 @@ void brcms_b_phyclk_fgc(struct brcms_c_hw_info *wlc_hw, bool clk)
 
 }
 
-void brcms_b_macphyclk_set(struct brcms_c_hw_info *wlc_hw, bool clk)
+void brcms_b_macphyclk_set(struct brcms_hardware *wlc_hw, bool clk)
 {
 	if (ON == clk)
 		ai_core_cflags(wlc_hw->sih, SICF_MPCLKE, SICF_MPCLKE);
@@ -1794,7 +1794,7 @@ void brcms_b_macphyclk_set(struct brcms_c_hw_info *wlc_hw, bool clk)
 		ai_core_cflags(wlc_hw->sih, SICF_MPCLKE, 0);
 }
 
-void brcms_b_phy_reset(struct brcms_c_hw_info *wlc_hw)
+void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 {
 	struct brcms_phy_pub *pih = wlc_hw->band->pi;
 	u32 phy_bw_clkbits;
@@ -1838,7 +1838,7 @@ void brcms_b_phy_reset(struct brcms_c_hw_info *wlc_hw)
 
 /* switch to and initialize new band */
 static void
-WLBANDINITFN(brcms_b_setband) (struct brcms_c_hw_info *wlc_hw, uint bandunit,
+WLBANDINITFN(brcms_b_setband) (struct brcms_hardware *wlc_hw, uint bandunit,
 				chanspec_t chanspec) {
 	struct brcms_c_info *wlc = wlc_hw->wlc;
 	u32 macintmask;
@@ -1875,7 +1875,7 @@ WLBANDINITFN(brcms_b_setband) (struct brcms_c_hw_info *wlc_hw, uint bandunit,
 }
 
 /* low-level band switch utility routine */
-void WLBANDINITFN(brcms_c_setxband) (struct brcms_c_hw_info *wlc_hw,
+void WLBANDINITFN(brcms_c_setxband) (struct brcms_hardware *wlc_hw,
 				     uint bandunit)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
@@ -1893,7 +1893,7 @@ void WLBANDINITFN(brcms_c_setxband) (struct brcms_c_hw_info *wlc_hw,
 	}
 }
 
-static bool brcms_c_isgoodchip(struct brcms_c_hw_info *wlc_hw)
+static bool brcms_c_isgoodchip(struct brcms_hardware *wlc_hw)
 {
 
 	/* reject unsupported corerev */
@@ -1907,7 +1907,7 @@ static bool brcms_c_isgoodchip(struct brcms_c_hw_info *wlc_hw)
 }
 
 /* Validate some board info parameters */
-static bool brcms_c_validboardtype(struct brcms_c_hw_info *wlc_hw)
+static bool brcms_c_validboardtype(struct brcms_hardware *wlc_hw)
 {
 	uint boardrev = wlc_hw->boardrev;
 
@@ -1935,7 +1935,7 @@ static bool brcms_c_validboardtype(struct brcms_c_hw_info *wlc_hw)
 	return true;
 }
 
-static char *brcms_c_get_macaddr(struct brcms_c_hw_info *wlc_hw)
+static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw)
 {
 	const char *varname = "macaddr";
 	char *macaddr;
@@ -1965,7 +1965,7 @@ static char *brcms_c_get_macaddr(struct brcms_c_hw_info *wlc_hw)
  * this function could be called when driver is down and w/o clock
  * it operates on different registers depending on corerev and boardflag.
  */
-bool brcms_b_radio_read_hwdisabled(struct brcms_c_hw_info *wlc_hw)
+bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 {
 	bool v, clk, xtal;
 	u32 resetbits = 0, flags = 0;
@@ -2007,7 +2007,7 @@ bool brcms_b_radio_read_hwdisabled(struct brcms_c_hw_info *wlc_hw)
 }
 
 /* Initialize just the hardware when coming out of POR or S3/S5 system states */
-void brcms_b_hw_up(struct brcms_c_hw_info *wlc_hw)
+void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 {
 	if (wlc_hw->wlc->pub->hw_up)
 		return;
@@ -2048,7 +2048,7 @@ void brcms_b_hw_up(struct brcms_c_hw_info *wlc_hw)
 	}
 }
 
-static bool wlc_dma_rxreset(struct brcms_c_hw_info *wlc_hw, uint fifo)
+static bool wlc_dma_rxreset(struct brcms_hardware *wlc_hw, uint fifo)
 {
 	struct dma_pub *di = wlc_hw->di[fifo];
 	return dma_rxreset(di);
@@ -2062,7 +2062,7 @@ static bool wlc_dma_rxreset(struct brcms_c_hw_info *wlc_hw, uint fifo)
  *   clear software macintstatus for fresh new start
  * one testing hack wlc_hw->noreset will bypass the d11/phy reset
  */
-void brcms_b_corereset(struct brcms_c_hw_info *wlc_hw, u32 flags)
+void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 {
 	d11regs_t *regs;
 	uint i;
@@ -2145,7 +2145,7 @@ void brcms_b_corereset(struct brcms_c_hw_info *wlc_hw, u32 flags)
 /* txfifo sizes needs to be modified(increased) since the newer cores
  * have more memory.
  */
-static void brcms_b_corerev_fifofixup(struct brcms_c_hw_info *wlc_hw)
+static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw)
 {
 	d11regs_t *regs = wlc_hw->regs;
 	u16 fifo_nu;
@@ -2202,7 +2202,7 @@ static void brcms_b_corerev_fifofixup(struct brcms_c_hw_info *wlc_hw)
  */
 static void brcms_b_coreinit(struct brcms_c_info *wlc)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	d11regs_t *regs;
 	u32 sflags;
 	uint bcnint_us;
@@ -2390,7 +2390,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
  *  - 559241 = 0x88889 => tsf_clk_frac_h = 0x8, tsf_clk_frac_l = 0x8889
  */
 
-void brcms_b_switch_macfreq(struct brcms_c_hw_info *wlc_hw, u8 spurmode)
+void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 {
 	d11regs_t *regs;
 	regs = wlc_hw->regs;
@@ -2421,7 +2421,7 @@ void brcms_b_switch_macfreq(struct brcms_c_hw_info *wlc_hw, u8 spurmode)
 /* Initialize GPIOs that are controlled by D11 core */
 static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	d11regs_t *regs;
 	u32 gc, gm;
 
@@ -2481,7 +2481,7 @@ static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 	ai_gpiocontrol(wlc_hw->sih, gm, gc, GPIO_DRV_PRIORITY);
 }
 
-static void brcms_ucode_download(struct brcms_c_hw_info *wlc_hw)
+static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 {
 	struct brcms_c_info *wlc;
 	wlc = wlc_hw->wlc;
@@ -2511,7 +2511,7 @@ static void brcms_ucode_download(struct brcms_c_hw_info *wlc_hw)
 	}
 }
 
-static void brcms_ucode_write(struct brcms_c_hw_info *wlc_hw, const u32 ucode[],
+static void brcms_ucode_write(struct brcms_hardware *wlc_hw, const u32 ucode[],
 			      const uint nbytes) {
 	d11regs_t *regs = wlc_hw->regs;
 	uint i;
@@ -2527,7 +2527,7 @@ static void brcms_ucode_write(struct brcms_c_hw_info *wlc_hw, const u32 ucode[],
 		W_REG(&regs->objdata, ucode[i]);
 }
 
-static void brcms_c_write_inits(struct brcms_c_hw_info *wlc_hw,
+static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 			    const struct d11init *inits)
 {
 	int i;
@@ -2547,7 +2547,7 @@ static void brcms_c_write_inits(struct brcms_c_hw_info *wlc_hw,
 	}
 }
 
-static void brcms_c_ucode_txant_set(struct brcms_c_hw_info *wlc_hw)
+static void brcms_c_ucode_txant_set(struct brcms_hardware *wlc_hw)
 {
 	u16 phyctl;
 	u16 phytxant = wlc_hw->bmac_phytxant;
@@ -2564,7 +2564,7 @@ static void brcms_c_ucode_txant_set(struct brcms_c_hw_info *wlc_hw)
 	brcms_b_write_shm(wlc_hw, M_RSP_PCTLWD, phyctl);
 }
 
-void brcms_b_txant_set(struct brcms_c_hw_info *wlc_hw, u16 phytxant)
+void brcms_b_txant_set(struct brcms_hardware *wlc_hw, u16 phytxant)
 {
 	/* update sw state */
 	wlc_hw->bmac_phytxant = phytxant;
@@ -2576,12 +2576,12 @@ void brcms_b_txant_set(struct brcms_c_hw_info *wlc_hw, u16 phytxant)
 
 }
 
-u16 brcms_b_get_txant(struct brcms_c_hw_info *wlc_hw)
+u16 brcms_b_get_txant(struct brcms_hardware *wlc_hw)
 {
 	return (u16) wlc_hw->wlc->stf->txant;
 }
 
-void brcms_b_antsel_type_set(struct brcms_c_hw_info *wlc_hw, u8 antsel_type)
+void brcms_b_antsel_type_set(struct brcms_hardware *wlc_hw, u8 antsel_type)
 {
 	wlc_hw->antsel_type = antsel_type;
 
@@ -2589,7 +2589,7 @@ void brcms_b_antsel_type_set(struct brcms_c_hw_info *wlc_hw, u8 antsel_type)
 	wlc_phy_antsel_type_set(wlc_hw->band->pi, antsel_type);
 }
 
-void brcms_b_fifoerrors(struct brcms_c_hw_info *wlc_hw)
+void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 {
 	bool fatal = false;
 	uint unit;
@@ -2655,7 +2655,7 @@ void brcms_b_fifoerrors(struct brcms_c_hw_info *wlc_hw)
 
 void brcms_c_intrson(struct brcms_c_info *wlc)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	wlc->macintmask = wlc->defmacintmask;
 	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
 }
@@ -2683,7 +2683,7 @@ static void brcms_c_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask)
 
 u32 brcms_c_intrsoff(struct brcms_c_info *wlc)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	u32 macintmask;
 
 	if (!wlc_hw->clk)
@@ -2702,7 +2702,7 @@ u32 brcms_c_intrsoff(struct brcms_c_info *wlc)
 
 void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	if (!wlc_hw->clk)
 		return;
 
@@ -2710,7 +2710,7 @@ void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask)
 	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
 }
 
-static void brcms_b_mute(struct brcms_c_hw_info *wlc_hw, bool on, mbool flags)
+static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, mbool flags)
 {
 	u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
 
@@ -2746,7 +2746,7 @@ static void brcms_b_mute(struct brcms_c_hw_info *wlc_hw, bool on, mbool flags)
 		brcms_c_ucode_mute_override_clear(wlc_hw);
 }
 
-int brcms_b_xmtfifo_sz_get(struct brcms_c_hw_info *wlc_hw, uint fifo,
+int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 			   uint *blocks)
 {
 	if (fifo >= NFIFO)
@@ -2766,7 +2766,7 @@ int brcms_b_xmtfifo_sz_get(struct brcms_c_hw_info *wlc_hw, uint fifo,
  * be pulling data into a tx fifo, by the time the MAC acks the suspend
  * request.
  */
-static bool brcms_b_tx_fifo_suspended(struct brcms_c_hw_info *wlc_hw,
+static bool brcms_b_tx_fifo_suspended(struct brcms_hardware *wlc_hw,
 				      uint tx_fifo)
 {
 	/* check that a suspend has been requested and is no longer pending */
@@ -2786,7 +2786,7 @@ static bool brcms_b_tx_fifo_suspended(struct brcms_c_hw_info *wlc_hw,
 	return false;
 }
 
-static void brcms_b_tx_fifo_suspend(struct brcms_c_hw_info *wlc_hw,
+static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
 				    uint tx_fifo)
 {
 	u8 fifo = 1 << tx_fifo;
@@ -2819,7 +2819,7 @@ static void brcms_b_tx_fifo_suspend(struct brcms_c_hw_info *wlc_hw,
 	}
 }
 
-static void brcms_b_tx_fifo_resume(struct brcms_c_hw_info *wlc_hw,
+static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 				   uint tx_fifo)
 {
 	/* BMAC_NOTE: WLC_TX_FIFO_ENAB is done in brcms_c_dpc() for DMA case
@@ -2851,7 +2851,7 @@ static void brcms_b_tx_fifo_resume(struct brcms_c_hw_info *wlc_hw,
  */
 static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	d11regs_t *regs = wlc_hw->regs;
 	u32 macintstatus;
 
@@ -2931,7 +2931,7 @@ bool brcms_c_intrsupd(struct brcms_c_info *wlc)
  */
 bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	u32 macintstatus;
 
 	*wantdpc = false;
@@ -2960,7 +2960,7 @@ bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc)
 }
 
 static bool
-brcms_b_dotxstatus(struct brcms_c_hw_info *wlc_hw, struct tx_status *txs,
+brcms_b_dotxstatus(struct brcms_hardware *wlc_hw, struct tx_status *txs,
 		   u32 s2)
 {
 	/* discard intermediate indications for ucode with one legitimate case:
@@ -2980,7 +2980,7 @@ brcms_b_dotxstatus(struct brcms_c_hw_info *wlc_hw, struct tx_status *txs,
  * Return true if more tx status need to be processed. false otherwise.
  */
 static bool
-brcms_b_txstatus(struct brcms_c_hw_info *wlc_hw, bool bound, bool *fatal)
+brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 {
 	bool morepending = false;
 	struct brcms_c_info *wlc = wlc_hw->wlc;
@@ -3036,7 +3036,7 @@ brcms_b_txstatus(struct brcms_c_hw_info *wlc_hw, bool bound, bool *fatal)
 
 void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	d11regs_t *regs = wlc_hw->regs;
 	u32 mc, mi;
 	struct wiphy *wiphy = wlc->wiphy;
@@ -3105,7 +3105,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 
 void brcms_c_enable_mac(struct brcms_c_info *wlc)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	d11regs_t *regs = wlc_hw->regs;
 	u32 mc, mi;
 
@@ -3138,7 +3138,7 @@ void brcms_c_enable_mac(struct brcms_c_info *wlc)
 	brcms_c_ucode_wake_override_clear(wlc_hw, WLC_WAKE_OVERRIDE_MACSUSPEND);
 }
 
-static void brcms_upd_ofdm_pctl1_table(struct brcms_c_hw_info *wlc_hw)
+static void brcms_upd_ofdm_pctl1_table(struct brcms_hardware *wlc_hw)
 {
 	u8 rate;
 	u8 rates[8] = {
@@ -3172,7 +3172,7 @@ static void brcms_upd_ofdm_pctl1_table(struct brcms_c_hw_info *wlc_hw)
 	}
 }
 
-static u16 brcms_b_ofdm_ratetable_offset(struct brcms_c_hw_info *wlc_hw,
+static u16 brcms_b_ofdm_ratetable_offset(struct brcms_hardware *wlc_hw,
 					 u8 rate)
 {
 	uint i;
@@ -3206,7 +3206,7 @@ static u16 brcms_b_ofdm_ratetable_offset(struct brcms_c_hw_info *wlc_hw,
 	return 2 * brcms_b_read_shm(wlc_hw, M_RT_DIRMAP_A + (plcp_rate * 2));
 }
 
-void brcms_b_band_stf_ss_set(struct brcms_c_hw_info *wlc_hw, u8 stf_mode)
+void brcms_b_band_stf_ss_set(struct brcms_hardware *wlc_hw, u8 stf_mode)
 {
 	wlc_hw->hw_stf_ss_opmode = stf_mode;
 
@@ -3215,7 +3215,7 @@ void brcms_b_band_stf_ss_set(struct brcms_c_hw_info *wlc_hw, u8 stf_mode)
 }
 
 void
-brcms_b_read_tsf(struct brcms_c_hw_info *wlc_hw, u32 *tsf_l_ptr,
+brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
 		  u32 *tsf_h_ptr)
 {
 	d11regs_t *regs = wlc_hw->regs;
@@ -3227,7 +3227,7 @@ brcms_b_read_tsf(struct brcms_c_hw_info *wlc_hw, u32 *tsf_l_ptr,
 	return;
 }
 
-static bool brcms_b_validate_chip_access(struct brcms_c_hw_info *wlc_hw)
+static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw)
 {
 	d11regs_t *regs;
 	u32 w, val;
@@ -3292,7 +3292,7 @@ static bool brcms_b_validate_chip_access(struct brcms_c_hw_info *wlc_hw)
 
 #define PHYPLL_WAIT_US	100000
 
-void brcms_b_core_phypll_ctl(struct brcms_c_hw_info *wlc_hw, bool on)
+void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 {
 	d11regs_t *regs;
 	u32 tmp;
@@ -3344,7 +3344,7 @@ void brcms_b_core_phypll_ctl(struct brcms_c_hw_info *wlc_hw, bool on)
 	}
 }
 
-void brcms_c_coredisable(struct brcms_c_hw_info *wlc_hw)
+void brcms_c_coredisable(struct brcms_hardware *wlc_hw)
 {
 	bool dev_gone;
 
@@ -3382,7 +3382,7 @@ void brcms_c_coredisable(struct brcms_c_hw_info *wlc_hw)
 }
 
 /* power both the pll and external oscillator on/off */
-static void brcms_b_xtal(struct brcms_c_hw_info *wlc_hw, bool want)
+static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: want %d\n", wlc_hw->unit, want);
 
@@ -3403,7 +3403,7 @@ static void brcms_b_xtal(struct brcms_c_hw_info *wlc_hw, bool want)
 
 static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 {
-	struct brcms_c_hw_info *wlc_hw = wlc->hw;
+	struct brcms_hardware *wlc_hw = wlc->hw;
 	uint i;
 
 	wlc->txpend16165war = 0;
@@ -3420,18 +3420,18 @@ static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 	dma_rxreclaim(wlc_hw->di[RX_FIFO]);
 }
 
-u16 brcms_b_read_shm(struct brcms_c_hw_info *wlc_hw, uint offset)
+u16 brcms_b_read_shm(struct brcms_hardware *wlc_hw, uint offset)
 {
 	return brcms_b_read_objmem(wlc_hw, offset, OBJADDR_SHM_SEL);
 }
 
-void brcms_b_write_shm(struct brcms_c_hw_info *wlc_hw, uint offset, u16 v)
+void brcms_b_write_shm(struct brcms_hardware *wlc_hw, uint offset, u16 v)
 {
 	brcms_b_write_objmem(wlc_hw, offset, v, OBJADDR_SHM_SEL);
 }
 
 static u16
-brcms_b_read_objmem(struct brcms_c_hw_info *wlc_hw, uint offset, u32 sel)
+brcms_b_read_objmem(struct brcms_hardware *wlc_hw, uint offset, u32 sel)
 {
 	d11regs_t *regs = wlc_hw->regs;
 	volatile u16 *objdata_lo = (volatile u16 *)&regs->objdata;
@@ -3450,7 +3450,7 @@ brcms_b_read_objmem(struct brcms_c_hw_info *wlc_hw, uint offset, u32 sel)
 }
 
 static void
-brcms_b_write_objmem(struct brcms_c_hw_info *wlc_hw, uint offset, u16 v,
+brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset, u16 v,
 		     u32 sel)
 {
 	d11regs_t *regs = wlc_hw->regs;
@@ -3472,7 +3472,7 @@ brcms_b_write_objmem(struct brcms_c_hw_info *wlc_hw, uint offset, u16 v,
  * 'sel' selects the type of memory
  */
 void
-brcms_b_copyto_objmem(struct brcms_c_hw_info *wlc_hw, uint offset,
+brcms_b_copyto_objmem(struct brcms_hardware *wlc_hw, uint offset,
 		      const void *buf, int len, u32 sel)
 {
 	u16 v;
@@ -3494,7 +3494,7 @@ brcms_b_copyto_objmem(struct brcms_c_hw_info *wlc_hw, uint offset,
  * 'sel' selects the type of memory
  */
 void
-brcms_b_copyfrom_objmem(struct brcms_c_hw_info *wlc_hw, uint offset, void *buf,
+brcms_b_copyfrom_objmem(struct brcms_hardware *wlc_hw, uint offset, void *buf,
 			 int len, u32 sel)
 {
 	u16 v;
@@ -3511,7 +3511,7 @@ brcms_b_copyfrom_objmem(struct brcms_c_hw_info *wlc_hw, uint offset, void *buf,
 	}
 }
 
-void brcms_b_copyfrom_vars(struct brcms_c_hw_info *wlc_hw, char **buf,
+void brcms_b_copyfrom_vars(struct brcms_hardware *wlc_hw, char **buf,
 			   uint *len)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "nvram vars totlen=%d\n",
@@ -3521,7 +3521,7 @@ void brcms_b_copyfrom_vars(struct brcms_c_hw_info *wlc_hw, char **buf,
 	*len = wlc_hw->vars_size;
 }
 
-void brcms_b_retrylimit_upd(struct brcms_c_hw_info *wlc_hw, u16 SRL, u16 LRL)
+void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw, u16 SRL, u16 LRL)
 {
 	wlc_hw->SRL = SRL;
 	wlc_hw->LRL = LRL;
@@ -3539,7 +3539,7 @@ void brcms_b_retrylimit_upd(struct brcms_c_hw_info *wlc_hw, u16 SRL, u16 LRL)
 	}
 }
 
-void brcms_b_pllreq(struct brcms_c_hw_info *wlc_hw, bool set, mbool req_bit)
+void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, mbool req_bit)
 {
 	if (set) {
 		if (mboolisset(wlc_hw->pllreq, req_bit))
@@ -3568,7 +3568,7 @@ void brcms_b_pllreq(struct brcms_c_hw_info *wlc_hw, bool set, mbool req_bit)
 	return;
 }
 
-u16 brcms_b_rate_shm_offset(struct brcms_c_hw_info *wlc_hw, u8 rate)
+u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
 {
 	u16 table_ptr;
 	u8 phy_rate, index;
@@ -3591,7 +3591,7 @@ u16 brcms_b_rate_shm_offset(struct brcms_c_hw_info *wlc_hw, u8 rate)
 	return 2 * brcms_b_read_shm(wlc_hw, table_ptr + (index * 2));
 }
 
-void brcms_b_antsel_set(struct brcms_c_hw_info *wlc_hw, u32 antsel_avail)
+void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
 {
 	wlc_hw->antsel_avail = antsel_avail;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.h b/drivers/staging/brcm80211/brcmsmac/bmac.h
index af4afa9..3c9ad4f 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.h
@@ -19,7 +19,7 @@
 #include <brcmu_wifi.h>
 #include "types.h"
 
-/* dup state between BMAC(struct brcms_c_hw_info) and HIGH(struct brcms_c_info)
+/* dup state between BMAC(struct brcms_hardware) and HIGH(struct brcms_c_info)
    driver */
 struct brcms_b_state {
 	u32 machwcap;	/* mac hw capibility */
@@ -78,97 +78,97 @@ extern int brcms_b_detach(struct brcms_c_info *wlc);
 extern void brcms_b_watchdog(void *arg);
 
 /* up/down, reset, clk */
-extern void brcms_b_copyto_objmem(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_b_copyto_objmem(struct brcms_hardware *wlc_hw,
 				   uint offset, const void *buf, int len,
 				   u32 sel);
-extern void brcms_b_copyfrom_objmem(struct brcms_c_hw_info *wlc_hw, uint offset,
+extern void brcms_b_copyfrom_objmem(struct brcms_hardware *wlc_hw, uint offset,
 				     void *buf, int len, u32 sel);
 #define brcms_b_copyfrom_shm(wlc_hw, offset, buf, len)                 \
 	brcms_b_copyfrom_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
 #define brcms_b_copyto_shm(wlc_hw, offset, buf, len)                   \
 	brcms_b_copyto_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
 
-extern void brcms_b_core_phypll_reset(struct brcms_c_hw_info *wlc_hw);
-extern void brcms_b_core_phypll_ctl(struct brcms_c_hw_info *wlc_hw, bool on);
-extern void brcms_b_phyclk_fgc(struct brcms_c_hw_info *wlc_hw, bool clk);
-extern void brcms_b_macphyclk_set(struct brcms_c_hw_info *wlc_hw, bool clk);
-extern void brcms_b_phy_reset(struct brcms_c_hw_info *wlc_hw);
-extern void brcms_b_corereset(struct brcms_c_hw_info *wlc_hw, u32 flags);
-extern void brcms_b_reset(struct brcms_c_hw_info *wlc_hw);
-extern void brcms_b_init(struct brcms_c_hw_info *wlc_hw, chanspec_t chanspec,
+extern void brcms_b_core_phypll_reset(struct brcms_hardware *wlc_hw);
+extern void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on);
+extern void brcms_b_phyclk_fgc(struct brcms_hardware *wlc_hw, bool clk);
+extern void brcms_b_macphyclk_set(struct brcms_hardware *wlc_hw, bool clk);
+extern void brcms_b_phy_reset(struct brcms_hardware *wlc_hw);
+extern void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags);
+extern void brcms_b_reset(struct brcms_hardware *wlc_hw);
+extern void brcms_b_init(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
 			  bool mute);
-extern int brcms_b_up_prep(struct brcms_c_hw_info *wlc_hw);
-extern int brcms_b_up_finish(struct brcms_c_hw_info *wlc_hw);
-extern int brcms_b_bmac_down_prep(struct brcms_c_hw_info *wlc_hw);
-extern int brcms_b_down_finish(struct brcms_c_hw_info *wlc_hw);
-extern void brcms_b_switch_macfreq(struct brcms_c_hw_info *wlc_hw, u8 spurmode);
+extern int brcms_b_up_prep(struct brcms_hardware *wlc_hw);
+extern int brcms_b_up_finish(struct brcms_hardware *wlc_hw);
+extern int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw);
+extern int brcms_b_down_finish(struct brcms_hardware *wlc_hw);
+extern void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode);
 
 /* chanspec, ucode interface */
-extern void brcms_b_set_chanspec(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_b_set_chanspec(struct brcms_hardware *wlc_hw,
 				  chanspec_t chanspec,
 				  bool mute, struct txpwr_limits *txpwr);
 
-extern int brcms_b_xmtfifo_sz_get(struct brcms_c_hw_info *wlc_hw, uint fifo,
+extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 				   uint *blocks);
-extern void brcms_b_mhf(struct brcms_c_hw_info *wlc_hw, u8 idx, u16 mask,
+extern void brcms_b_mhf(struct brcms_hardware *wlc_hw, u8 idx, u16 mask,
 			 u16 val, int bands);
-extern void brcms_b_mctrl(struct brcms_c_hw_info *wlc_hw, u32 mask, u32 val);
-extern u16 brcms_b_mhf_get(struct brcms_c_hw_info *wlc_hw, u8 idx, int bands);
-extern void brcms_b_txant_set(struct brcms_c_hw_info *wlc_hw, u16 phytxant);
-extern u16 brcms_b_get_txant(struct brcms_c_hw_info *wlc_hw);
-extern void brcms_b_antsel_type_set(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_b_mctrl(struct brcms_hardware *wlc_hw, u32 mask, u32 val);
+extern u16 brcms_b_mhf_get(struct brcms_hardware *wlc_hw, u8 idx, int bands);
+extern void brcms_b_txant_set(struct brcms_hardware *wlc_hw, u16 phytxant);
+extern u16 brcms_b_get_txant(struct brcms_hardware *wlc_hw);
+extern void brcms_b_antsel_type_set(struct brcms_hardware *wlc_hw,
 				     u8 antsel_type);
-extern int brcms_b_state_get(struct brcms_c_hw_info *wlc_hw,
+extern int brcms_b_state_get(struct brcms_hardware *wlc_hw,
 			      struct brcms_b_state *state);
-extern void brcms_b_write_shm(struct brcms_c_hw_info *wlc_hw, uint offset,
+extern void brcms_b_write_shm(struct brcms_hardware *wlc_hw, uint offset,
 			      u16 v);
-extern u16 brcms_b_read_shm(struct brcms_c_hw_info *wlc_hw, uint offset);
-extern void brcms_b_write_template_ram(struct brcms_c_hw_info *wlc_hw,
+extern u16 brcms_b_read_shm(struct brcms_hardware *wlc_hw, uint offset);
+extern void brcms_b_write_template_ram(struct brcms_hardware *wlc_hw,
 				       int offset, int len, void *buf);
-extern void brcms_b_copyfrom_vars(struct brcms_c_hw_info *wlc_hw, char **buf,
+extern void brcms_b_copyfrom_vars(struct brcms_hardware *wlc_hw, char **buf,
 				   uint *len);
 
-extern void brcms_b_hw_etheraddr(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_b_hw_etheraddr(struct brcms_hardware *wlc_hw,
 				  u8 *ea);
 
-extern bool brcms_b_radio_read_hwdisabled(struct brcms_c_hw_info *wlc_hw);
-extern void brcms_b_set_shortslot(struct brcms_c_hw_info *wlc_hw,
+extern bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw);
+extern void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw,
 				  bool shortslot);
-extern void brcms_b_band_stf_ss_set(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_b_band_stf_ss_set(struct brcms_hardware *wlc_hw,
 				    u8 stf_mode);
 
-extern void brcms_b_wait_for_wake(struct brcms_c_hw_info *wlc_hw);
+extern void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw);
 
-extern void brcms_c_ucode_wake_override_set(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_c_ucode_wake_override_set(struct brcms_hardware *wlc_hw,
 					u32 override_bit);
-extern void brcms_c_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_c_ucode_wake_override_clear(struct brcms_hardware *wlc_hw,
 					  u32 override_bit);
 
-extern void brcms_b_set_addrmatch(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw,
 				   int match_reg_offset,
 				   const u8 *addr);
-extern void brcms_b_write_hw_bcntemplates(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw,
 					   void *bcn, int len, bool both);
 
-extern void brcms_b_read_tsf(struct brcms_c_hw_info *wlc_hw, u32 *tsf_l_ptr,
+extern void brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
 			      u32 *tsf_h_ptr);
-extern void brcms_b_set_cwmin(struct brcms_c_hw_info *wlc_hw, u16 newmin);
-extern void brcms_b_set_cwmax(struct brcms_c_hw_info *wlc_hw, u16 newmax);
+extern void brcms_b_set_cwmin(struct brcms_hardware *wlc_hw, u16 newmin);
+extern void brcms_b_set_cwmax(struct brcms_hardware *wlc_hw, u16 newmax);
 
-extern void brcms_b_retrylimit_upd(struct brcms_c_hw_info *wlc_hw, u16 SRL,
+extern void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw, u16 SRL,
 				    u16 LRL);
 
-extern void brcms_b_fifoerrors(struct brcms_c_hw_info *wlc_hw);
+extern void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw);
 
 
 /* API for BMAC driver (e.g. wlc_phy.c etc) */
 
-extern void brcms_b_bw_set(struct brcms_c_hw_info *wlc_hw, u16 bw);
-extern void brcms_b_pllreq(struct brcms_c_hw_info *wlc_hw, bool set,
+extern void brcms_b_bw_set(struct brcms_hardware *wlc_hw, u16 bw);
+extern void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set,
 			    mbool req_bit);
-extern void brcms_b_hw_up(struct brcms_c_hw_info *wlc_hw);
-extern u16 brcms_b_rate_shm_offset(struct brcms_c_hw_info *wlc_hw, u8 rate);
-extern void brcms_b_antsel_set(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_b_hw_up(struct brcms_hardware *wlc_hw);
+extern u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate);
+extern void brcms_b_antsel_set(struct brcms_hardware *wlc_hw,
 			       u32 antsel_avail);
 
 #endif /* _BRCM_BOTTOM_MAC_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 6cf8ca1..ba245d8 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -869,7 +869,7 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i, j;
-	struct brcms_c_band *band;
+	struct brcms_band *band;
 	const struct locale_info *li;
 	chanvec_t sup_chan;
 	const struct locale_mimo_info *li_mimo;
@@ -970,7 +970,7 @@ static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i, j;
-	struct brcms_c_band *band;
+	struct brcms_band *band;
 	const chanvec_t *chanvec;
 
 	memset(&wlc_cm->quiet_channels, 0, sizeof(chanvec_t));
@@ -1262,7 +1262,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 	int maxpwr;
 	int delta;
 	const struct country_info *country;
-	struct brcms_c_band *band;
+	struct brcms_band *band;
 	const struct locale_info *li;
 	int conducted_max;
 	int conducted_ofdm_max;
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index f9e134a..8d061ad 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -309,7 +309,7 @@ static u16 brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc,
 static void brcms_c_bss_default_init(struct brcms_c_info *wlc);
 static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc);
 static ratespec_t mac80211_wlc_set_nrate(struct brcms_c_info *wlc,
-					 struct brcms_c_band *cur_band,
+					 struct brcms_band *cur_band,
 					 u32 int_val);
 static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc);
 static void brcms_c_watchdog(void *arg);
@@ -319,11 +319,11 @@ static int brcms_c_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg);
 static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc);
 
 /* send and receive */
-static struct brcms_c_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc);
+static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc);
 static void brcms_c_txq_free(struct brcms_c_info *wlc,
-			 struct brcms_c_txq_info *qi);
+			 struct brcms_txq_info *qi);
 static void brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
-				     struct brcms_c_txq_info *qi,
+				     struct brcms_txq_info *qi,
 				     bool on, int prio);
 static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc);
 static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rate,
@@ -380,7 +380,7 @@ static int _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 {
 	int idx;
-	struct brcms_c_bsscfg *cfg;
+	struct brcms_bss_cfg *cfg;
 
 	/* disallow PS when one of the following global conditions meets */
 	if (!wlc->pub->associated)
@@ -458,7 +458,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	d11regs_t *regs;
 	chanspec_t chanspec;
 	int i;
-	struct brcms_c_bsscfg *bsscfg;
+	struct brcms_bss_cfg *bsscfg;
 	bool mute = false;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
@@ -643,7 +643,7 @@ void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
  * Write this BSS config's MAC address to core.
  * Updates RXE match engine.
  */
-int brcms_c_set_mac(struct brcms_c_bsscfg *cfg)
+int brcms_c_set_mac(struct brcms_bss_cfg *cfg)
 {
 	int err = 0;
 	struct brcms_c_info *wlc = cfg->wlc;
@@ -661,7 +661,7 @@ int brcms_c_set_mac(struct brcms_c_bsscfg *cfg)
 /* Write the BSS config's BSSID address to core (set_bssid in d11procs.tcl).
  * Updates RXE match engine.
  */
-void brcms_c_set_bssid(struct brcms_c_bsscfg *cfg)
+void brcms_c_set_bssid(struct brcms_bss_cfg *cfg)
 {
 	struct brcms_c_info *wlc = cfg->wlc;
 
@@ -683,7 +683,7 @@ void brcms_c_set_bssid(struct brcms_c_bsscfg *cfg)
 void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 {
 	int idx;
-	struct brcms_c_bsscfg *cfg;
+	struct brcms_bss_cfg *cfg;
 
 	/* use the override if it is set */
 	if (wlc->shortslot_override != WLC_SHORTSLOT_AUTO)
@@ -739,7 +739,7 @@ void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 {
 	if (wlc->home_chanspec != chanspec) {
 		int idx;
-		struct brcms_c_bsscfg *cfg;
+		struct brcms_bss_cfg *cfg;
 
 		wlc->home_chanspec = chanspec;
 
@@ -1052,7 +1052,7 @@ static void WLBANDINITFN(brcms_c_setband) (struct brcms_c_info *wlc,
 					   uint bandunit)
 {
 	int idx;
-	struct brcms_c_bsscfg *cfg;
+	struct brcms_bss_cfg *cfg;
 
 	wlc->band = wlc->bandstate[bandunit];
 
@@ -1944,7 +1944,7 @@ static void brcms_c_watchdog(void *arg)
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
 	int i;
-	struct brcms_c_bsscfg *cfg;
+	struct brcms_bss_cfg *cfg;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -2051,7 +2051,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 			if (!mboolisset
 			    (wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE)) {
 				int idx;
-				struct brcms_c_bsscfg *bsscfg;
+				struct brcms_bss_cfg *bsscfg;
 				mboolset(wlc->pub->radio_disabled,
 					 WL_RADIO_HW_DISABLE);
 
@@ -2158,7 +2158,7 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 	uint callbacks = 0;
 	int i;
 	bool dev_gone = false;
-	struct brcms_c_txq_info *qi;
+	struct brcms_txq_info *qi;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -2230,7 +2230,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	bool preamble_restrict = false;	/* Restrict association to stations that support short
 					 * preambles
 					 */
-	struct brcms_c_band *band;
+	struct brcms_band *band;
 
 	/* if N-support is enabled, allow Gmode set as long as requested
 	 * Gmode is not GMODE_LEGACY_B
@@ -2531,7 +2531,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 	struct scb *nextscb;
 	bool ta_ok;
 	uint band;
-	struct brcms_c_bsscfg *bsscfg;
+	struct brcms_bss_cfg *bsscfg;
 	struct brcms_bss_info *current_bss;
 
 	/* update bsscfg pointer */
@@ -3155,7 +3155,7 @@ void brcms_c_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 			     uint prec)
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) ctx;
-	struct brcms_c_txq_info *qi = wlc->pkt_queue;	/* Check me */
+	struct brcms_txq_info *qi = wlc->pkt_queue;	/* Check me */
 	struct pktq *q = &qi->q;
 	int prio;
 
@@ -3222,7 +3222,7 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 	u16 prec_map;
 	int err = 0, i, count;
 	uint fifo;
-	struct brcms_c_txq_info *qi = wlc->pkt_queue;
+	struct brcms_txq_info *qi = wlc->pkt_queue;
 	struct pktq *q = &qi->q;
 	struct ieee80211_tx_info *tx_info;
 
@@ -3288,7 +3288,7 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
  * for MC frames so is used as part of the sequence number.
  */
 static inline u16
-bcmc_fid_generate(struct brcms_c_info *wlc, struct brcms_c_bsscfg *bsscfg,
+bcmc_fid_generate(struct brcms_c_info *wlc, struct brcms_bss_cfg *bsscfg,
 		  struct d11txh *txh)
 {
 	u16 frameid;
@@ -4268,7 +4268,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 void brcms_c_tbtt(struct brcms_c_info *wlc)
 {
-	struct brcms_c_bsscfg *cfg = wlc->cfg;
+	struct brcms_bss_cfg *cfg = wlc->cfg;
 
 	if (!cfg->BSS) {
 		/* DirFrmQ is now valid...defer setting until end of ATIM window */
@@ -5172,7 +5172,7 @@ bool brcms_c_valid_rate(struct brcms_c_info *wlc, ratespec_t rspec, int band,
 static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
 {
 	uint i;
-	struct brcms_c_band *band;
+	struct brcms_band *band;
 
 	for (i = 0; i < NBANDS(wlc); i++) {
 		if (IS_SINGLEBAND_5G(wlc->deviceid))
@@ -5249,7 +5249,7 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 static void
 brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 			 ratespec_t bcn_rspec,
-			 struct brcms_c_bsscfg *cfg, u16 *buf, int *len)
+			 struct brcms_bss_cfg *cfg, u16 *buf, int *len)
 {
 	static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 	struct cck_phy_hdr *plcp;
@@ -5313,7 +5313,7 @@ int brcms_c_get_header_len()
  * Otherwise, it updates the hardware template.
  */
 void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
-			       struct brcms_c_bsscfg *cfg)
+			       struct brcms_bss_cfg *cfg)
 {
 	int len = BCN_TMPL_LEN;
 
@@ -5361,7 +5361,7 @@ void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
 void brcms_c_update_beacon(struct brcms_c_info *wlc)
 {
 	int idx;
-	struct brcms_c_bsscfg *bsscfg;
+	struct brcms_bss_cfg *bsscfg;
 
 	/* update AP or IBSS beacons */
 	FOREACH_BSS(wlc, idx, bsscfg) {
@@ -5371,7 +5371,7 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
 }
 
 /* Write ssid into shared memory */
-void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_c_bsscfg *cfg)
+void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_bss_cfg *cfg)
 {
 	u8 *ssidptr = cfg->SSID;
 	u16 base = M_SSID;
@@ -5390,7 +5390,7 @@ void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_c_bsscfg *cfg)
 void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 {
 	int idx;
-	struct brcms_c_bsscfg *bsscfg;
+	struct brcms_bss_cfg *bsscfg;
 
 	/* update AP or IBSS probe responses */
 	FOREACH_BSS(wlc, idx, bsscfg) {
@@ -5401,7 +5401,7 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 
 void
 brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
-			      struct brcms_c_bsscfg *cfg,
+			      struct brcms_bss_cfg *cfg,
 			      bool suspend)
 {
 	u16 prb_resp[BCN_TMPL_LEN / 2];
@@ -5475,7 +5475,7 @@ int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 void brcms_c_reprate_init(struct brcms_c_info *wlc)
 {
 	int i;
-	struct brcms_c_bsscfg *bsscfg;
+	struct brcms_bss_cfg *bsscfg;
 
 	FOREACH_BSS(wlc, i, bsscfg) {
 		brcms_c_bsscfg_reprate_init(bsscfg);
@@ -5483,7 +5483,7 @@ void brcms_c_reprate_init(struct brcms_c_info *wlc)
 }
 
 /* per bsscfg init tx reported rate mechanism */
-void brcms_c_bsscfg_reprate_init(struct brcms_c_bsscfg *bsscfg)
+void brcms_c_bsscfg_reprate_init(struct brcms_bss_cfg *bsscfg)
 {
 	bsscfg->txrspecidx = 0;
 	memset((char *)bsscfg->txrspec, 0, sizeof(bsscfg->txrspec));
@@ -5501,7 +5501,7 @@ void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs)
 static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 {
 	chanspec_t chanspec;
-	struct brcms_c_band *band;
+	struct brcms_band *band;
 	struct brcms_bss_info *bi = wlc->default_bss;
 
 	/* init default and target BSS with some sane initial values */
@@ -5531,7 +5531,7 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 }
 
 static ratespec_t
-mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_c_band *cur_band,
+mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		       u32 int_val)
 {
 	u8 stf = (int_val & NRATE_STF_MASK) >> NRATE_STF_SHIFT;
@@ -5753,7 +5753,7 @@ void brcms_c_reset_bmac_done(struct brcms_c_info *wlc)
 /* check for the particular priority flow control bit being set */
 bool
 brcms_c_txflowcontrol_prio_isset(struct brcms_c_info *wlc,
-				 struct brcms_c_txq_info *q,
+				 struct brcms_txq_info *q,
 				 int prio)
 {
 	uint prio_mask;
@@ -5769,7 +5769,7 @@ brcms_c_txflowcontrol_prio_isset(struct brcms_c_info *wlc,
 
 /* propagate the flow control to all interfaces using the given tx queue */
 void brcms_c_txflowcontrol(struct brcms_c_info *wlc,
-			   struct brcms_c_txq_info *qi,
+			   struct brcms_txq_info *qi,
 			   bool on, int prio)
 {
 	uint prio_bits;
@@ -5812,7 +5812,7 @@ void brcms_c_txflowcontrol(struct brcms_c_info *wlc,
 
 void
 brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
-			       struct brcms_c_txq_info *qi,
+			       struct brcms_txq_info *qi,
 			       bool on, uint override)
 {
 	uint prev_override;
@@ -5858,7 +5858,7 @@ brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
 
 static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc)
 {
-	struct brcms_c_txq_info *qi;
+	struct brcms_txq_info *qi;
 
 	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
 		if (qi->stopped) {
@@ -5870,7 +5870,7 @@ static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc)
 
 static void
 brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
-			     struct brcms_c_txq_info *qi, bool on, int prio)
+			     struct brcms_txq_info *qi, bool on, int prio)
 {
 #ifdef NON_FUNCTIONAL
 	/* wlcif_list is never filled so this function is not functional */
@@ -5883,11 +5883,11 @@ brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
 #endif
 }
 
-static struct brcms_c_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
+static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
 {
-	struct brcms_c_txq_info *qi, *p;
+	struct brcms_txq_info *qi, *p;
 
-	qi = kzalloc(sizeof(struct brcms_c_txq_info), GFP_ATOMIC);
+	qi = kzalloc(sizeof(struct brcms_txq_info), GFP_ATOMIC);
 	if (qi != NULL) {
 		/*
 		 * Have enough room for control packets along with HI watermark
@@ -5913,9 +5913,9 @@ static struct brcms_c_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
 }
 
 static void brcms_c_txq_free(struct brcms_c_info *wlc,
-			     struct brcms_c_txq_info *qi)
+			     struct brcms_txq_info *qi)
 {
-	struct brcms_c_txq_info *p;
+	struct brcms_txq_info *p;
 
 	if (qi == NULL)
 		return;
@@ -5958,7 +5958,7 @@ void brcms_c_associate_upd(struct brcms_c_info *wlc, bool state)
  * AMPDU traffic, packets pending in hardware have to be invalidated so that
  * when later on hardware releases them, they can be handled appropriately.
  */
-void brcms_c_inval_dma_pkts(struct brcms_c_hw_info *hw,
+void brcms_c_inval_dma_pkts(struct brcms_hardware *hw,
 			       struct ieee80211_sta *sta,
 			       void (*dma_callback_fn))
 {
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 6b8b4d2..80b08a9 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -73,13 +73,6 @@
 		(((val) & (~(field ## _M << field ## _S))) | \
 		 ((unsigned)(bits) << field ## _S))
 
-/* For managing scan result lists */
-struct brcms_c_bss_list {
-	uint count;
-	bool beacon;		/* set for beacon, cleared for probe response */
-	struct brcms_bss_info *ptrs[MAXBSS];
-};
-
 #define	SW_TIMER_MAC_STAT_UPD		30	/* periodic MAC stats update */
 
 /* Double check that unsupported cores are not enabled */
@@ -236,7 +229,7 @@ extern const u8 prio2fifo[];
 
 #define WLCWLUNIT(wlc)		((wlc)->pub->unit)
 
-struct brcms_c_protection {
+struct brcms_protection {
 	bool _g;		/* use g spec protection, driver internal */
 	s8 g_override;	/* override for use of g spec protection */
 	u8 gmode_user;	/* user config gmode, operating band->gmode is different */
@@ -251,7 +244,7 @@ struct brcms_c_protection {
 };
 
 /* anything affects the single/dual streams/antenna operation */
-struct brcms_c_stf {
+struct brcms_stf {
 	u8 hw_txchain;	/* HW txchain bitmap cfg */
 	u8 txchain;		/* txchain bitmap being used */
 	u8 txstreams;	/* number of txchains being used */
@@ -348,7 +341,7 @@ struct wsec_key {
 /*
  * core state (mac)
  */
-struct brcms_c_core {
+struct brcms_core {
 	uint coreidx;		/* # sb enumerated core */
 
 	/* fifo */
@@ -361,7 +354,7 @@ struct brcms_c_core {
 /*
  * band state (phy+ana+radio)
  */
-struct brcms_c_band {
+struct brcms_band {
 	int bandtype;		/* WLC_BAND_2G, WLC_BAND_5G */
 	uint bandunit;		/* bandstate[] index */
 
@@ -450,19 +443,19 @@ struct brcms_c_if {
 				 */
 	u8 flags;		/* flags for the interface */
 	struct brcms_if *wlif;		/* pointer to wlif */
-	struct brcms_c_txq_info *qi;	/* pointer to associated tx queue */
+	struct brcms_txq_info *qi;	/* pointer to associated tx queue */
 	union {
 		/* pointer to scb if WLC_IFTYPE_WDS */
 		struct scb *scb;
 		/* pointer to bsscfg if WLC_IFTYPE_BSS */
-		struct brcms_c_bsscfg *bsscfg;
+		struct brcms_bss_cfg *bsscfg;
 	} u;
 };
 
 /* flags for the interface, this interface is linked to a brcms_if */
 #define WLC_IF_LINKED		0x02
 
-struct brcms_c_hwband {
+struct brcms_hw_band {
 	int bandtype;		/* WLC_BAND_2G, WLC_BAND_5G */
 	uint bandunit;		/* bandstate[] index */
 	u16 mhfs[MHFMAX];	/* MHF array shadow */
@@ -479,7 +472,7 @@ struct brcms_c_hwband {
 	bool abgphy_encore;
 };
 
-struct brcms_c_hw_info {
+struct brcms_hardware {
 	bool _piomode;		/* true if pio mode */
 	struct brcms_c_info *wlc;
 
@@ -506,9 +499,9 @@ struct brcms_c_hw_info {
 	d11regs_t *regs;	/* pointer to device registers */
 	void *physhim;		/* phy shim layer handler */
 	void *phy_sh;		/* pointer to shared phy state */
-	struct brcms_c_hwband *band;/* pointer to active per-band state */
+	struct brcms_hw_band *band;/* pointer to active per-band state */
 	/* band state per phy/radio */
-	struct brcms_c_hwband *bandstate[MAXBANDS];
+	struct brcms_hw_band *bandstate[MAXBANDS];
 	u16 bmac_phytxant;	/* cache of high phytxant state */
 	bool shortslot;		/* currently using 11g ShortSlot timing */
 	u16 SRL;		/* 802.11 dot11ShortRetryLimit */
@@ -561,8 +554,8 @@ struct brcms_c_hw_info {
  * if they belong to the same flow of traffic from the device. For multi-channel
  * operation there are independent TX Queues for each channel.
  */
-struct brcms_c_txq_info {
-	struct brcms_c_txq_info *next;
+struct brcms_txq_info {
+	struct brcms_txq_info *next;
 	struct pktq q;
 	uint stopped;		/* tx flow control bits */
 };
@@ -576,7 +569,7 @@ struct brcms_c_info {
 	d11regs_t *regs;	/* pointer to device registers */
 
 	/* HW related state used primarily by BMAC */
-	struct brcms_c_hw_info *hw;
+	struct brcms_hardware *hw;
 
 	/* clock */
 	int clkreq_override;	/* setting for clkreq for PCIE : Auto, 0, 1 */
@@ -593,11 +586,11 @@ struct brcms_c_info {
 	bool clk;		/* core is out of reset and has clock */
 
 	/* multiband */
-	struct brcms_c_core *core;	/* pointer to active io core */
-	struct brcms_c_band *band;	/* pointer to active per-band state */
-	struct brcms_c_core *corestate;	/* per-core state (one per hw core) */
+	struct brcms_core *core;	/* pointer to active io core */
+	struct brcms_band *band;	/* pointer to active per-band state */
+	struct brcms_core *corestate;	/* per-core state (one per hw core) */
 	/* per-band state (one per phy/radio): */
-	struct brcms_c_band *bandstate[MAXBANDS];
+	struct brcms_band *bandstate[MAXBANDS];
 
 	bool war16165;		/* PCI slow clock 16165 war flag */
 
@@ -680,11 +673,11 @@ struct brcms_c_info {
 	 * BSS Configurations set of BSS configurations, idx 0 is default and
 	 * always valid
 	 */
-	struct brcms_c_bsscfg *bsscfg[WLC_MAXBSSCFG];
-	struct brcms_c_bsscfg *cfg; /* the primary bsscfg (can be AP or STA) */
+	struct brcms_bss_cfg *bsscfg[WLC_MAXBSSCFG];
+	struct brcms_bss_cfg *cfg; /* the primary bsscfg (can be AP or STA) */
 
 	/* tx queue */
-	struct brcms_c_txq_info *tx_queues;	/* common TX Queue list */
+	struct brcms_txq_info *tx_queues;	/* common TX Queue list */
 
 	/* security */
 	struct wsec_key *wsec_keys[WSEC_MAX_KEYS]; /* dynamic key storage */
@@ -737,10 +730,10 @@ struct brcms_c_info {
 	s8 shortslot_override;	/* 11g ShortSlot override */
 	bool include_legacy_erp;	/* include Legacy ERP info elt ID 47 as well as g ID 42 */
 
-	struct brcms_c_protection *protection;
+	struct brcms_protection *protection;
 	s8 PLCPHdr_override;	/* 802.11b Preamble Type override */
 
-	struct brcms_c_stf *stf;
+	struct brcms_stf *stf;
 
 	ratespec_t bcn_rspec;	/* save bcn ratespec purpose */
 
@@ -751,7 +744,7 @@ struct brcms_c_info {
 
 	u16 next_bsscfg_ID;
 
-	struct brcms_c_txq_info *pkt_queue; /* txq for transmit packets */
+	struct brcms_txq_info *pkt_queue; /* txq for transmit packets */
 	u32 mpc_dur;		/* total time (ms) in mpc mode except for the
 				 * portion since radio is turned off last time
 				 */
@@ -775,7 +768,7 @@ struct antsel_info {
 };
 
 /* BSS configuration state */
-struct brcms_c_bsscfg {
+struct brcms_bss_cfg {
 	struct brcms_c_info *wlc; /* wlc to which this bsscfg belongs to. */
 	bool up;		/* is this configuration up operational */
 	bool enable;		/* is this configuration enabled */
@@ -906,8 +899,8 @@ extern void brcms_c_print_txdesc(struct d11txh *txh);
 #define brcms_c_print_txdesc(a)
 #endif
 
-extern void brcms_c_setxband(struct brcms_c_hw_info *wlc_hw, uint bandunit);
-extern void brcms_c_coredisable(struct brcms_c_hw_info *wlc_hw);
+extern void brcms_c_setxband(struct brcms_hardware *wlc_hw, uint bandunit);
+extern void brcms_c_coredisable(struct brcms_hardware *wlc_hw);
 
 extern bool brcms_c_valid_rate(struct brcms_c_info *wlc, ratespec_t rate,
 			       int band, bool verbose);
@@ -915,7 +908,7 @@ extern void brcms_c_ap_upd(struct brcms_c_info *wlc);
 
 /* helper functions */
 extern void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc,
-				 struct brcms_c_bsscfg *cfg);
+				 struct brcms_bss_cfg *cfg);
 extern int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config);
 
 extern void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc,
@@ -923,13 +916,13 @@ extern void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc,
 extern void brcms_c_mac_bcn_promisc(struct brcms_c_info *wlc);
 extern void brcms_c_mac_promisc(struct brcms_c_info *wlc);
 extern void brcms_c_txflowcontrol(struct brcms_c_info *wlc,
-				  struct brcms_c_txq_info *qi,
+				  struct brcms_txq_info *qi,
 				  bool on, int prio);
 extern void brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
-				       struct brcms_c_txq_info *qi,
+				       struct brcms_txq_info *qi,
 				       bool on, uint override);
 extern bool brcms_c_txflowcontrol_prio_isset(struct brcms_c_info *wlc,
-					     struct brcms_c_txq_info *qi,
+					     struct brcms_txq_info *qi,
 					     int prio);
 extern void brcms_c_send_q(struct brcms_c_info *wlc);
 extern int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu,
@@ -948,12 +941,12 @@ extern u16 brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
 				      bool ba);
 
 extern void brcms_c_tbtt(struct brcms_c_info *wlc);
-extern void brcms_c_inval_dma_pkts(struct brcms_c_hw_info *hw,
+extern void brcms_c_inval_dma_pkts(struct brcms_hardware *hw,
 			       struct ieee80211_sta *sta,
 			       void (*dma_callback_fn));
 
 extern void brcms_c_reprate_init(struct brcms_c_info *wlc);
-extern void brcms_c_bsscfg_reprate_init(struct brcms_c_bsscfg *bsscfg);
+extern void brcms_c_bsscfg_reprate_init(struct brcms_bss_cfg *bsscfg);
 
 /* Shared memory access */
 extern void brcms_c_write_shm(struct brcms_c_info *wlc, uint offset, u16 v);
@@ -963,11 +956,11 @@ extern void brcms_c_copyto_shm(struct brcms_c_info *wlc, uint offset,
 
 extern void brcms_c_update_beacon(struct brcms_c_info *wlc);
 extern void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
-				  struct brcms_c_bsscfg *bsscfg);
+				  struct brcms_bss_cfg *bsscfg);
 
 extern void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend);
 extern void brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
-					  struct brcms_c_bsscfg *cfg,
+					  struct brcms_bss_cfg *cfg,
 					  bool suspend);
 extern bool brcms_c_ismpc(struct brcms_c_info *wlc);
 extern bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc);
@@ -990,15 +983,15 @@ extern bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit);
 
 extern int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode);
 extern void brcms_c_mimops_action_ht_send(struct brcms_c_info *wlc,
-				      struct brcms_c_bsscfg *bsscfg,
+				      struct brcms_bss_cfg *bsscfg,
 				      u8 mimops_mode);
 
 extern void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot);
-extern void brcms_c_set_bssid(struct brcms_c_bsscfg *cfg);
+extern void brcms_c_set_bssid(struct brcms_bss_cfg *cfg);
 extern void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend);
 
 extern void brcms_c_set_ratetable(struct brcms_c_info *wlc);
-extern int brcms_c_set_mac(struct brcms_c_bsscfg *cfg);
+extern int brcms_c_set_mac(struct brcms_bss_cfg *cfg);
 extern void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
 					  ratespec_t bcn_rate);
 extern void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index e681f83..12defaa 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -30,12 +30,12 @@
 
 /* PHY SHIM module specific state */
 struct phy_shim_info {
-	struct brcms_c_hw_info *wlc_hw;	/* pointer to main wlc_hw structure */
+	struct brcms_hardware *wlc_hw;	/* pointer to main wlc_hw structure */
 	void *wlc;		/* pointer to main wlc structure */
 	void *wl;		/* pointer to os-specific private state */
 };
 
-struct phy_shim_info *wlc_phy_shim_attach(struct brcms_c_hw_info *wlc_hw,
+struct phy_shim_info *wlc_phy_shim_attach(struct brcms_hardware *wlc_hw,
 						       void *wl, void *wlc) {
 	struct phy_shim_info *physhim = NULL;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index 0a29b67..0ac7fa5 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -108,7 +108,7 @@
 #define WLC_N_TXRX_CHAIN0		0
 #define WLC_N_TXRX_CHAIN1		1
 
-extern struct phy_shim_info *wlc_phy_shim_attach(struct brcms_c_hw_info *wlc_hw,
+extern struct phy_shim_info *wlc_phy_shim_attach(struct brcms_hardware *wlc_hw,
 						void *wl, void *wlc);
 extern void wlc_phy_shim_detach(struct phy_shim_info *physhim);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index b51ca7a..6bece8e 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -290,7 +290,7 @@ int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 }
 
 /* update wlc->stf->ss_opmode which represents the operational stf_ss mode we're using */
-int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_c_band *band)
+int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band)
 {
 	int ret_code = 0;
 	u8 prev_stf_ss;
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.h b/drivers/staging/brcm80211/brcmsmac/stf.h
index 2033938..06c2a39 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.h
+++ b/drivers/staging/brcm80211/brcmsmac/stf.h
@@ -27,7 +27,7 @@ extern void brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc,
 					u16 *ss_algo_channel,
 					chanspec_t chanspec);
 extern int brcms_c_stf_ss_update(struct brcms_c_info *wlc,
-			     struct brcms_c_band *band);
+			     struct brcms_band *band);
 extern void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc);
 extern int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val,
 			       bool force);
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 7ab4263..17c1d8a 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -358,12 +358,12 @@ struct ieee80211_sta;
 struct ieee80211_tx_queue_params;
 struct brcms_info;
 struct brcms_c_info;
-struct brcms_c_hw_info;
+struct brcms_hardware;
 struct brcms_c_if;
 struct brcmu_iovar;
 struct brcmu_strbuf;
-struct brcms_c_txq_info;
-struct brcms_c_band;
+struct brcms_txq_info;
+struct brcms_band;
 struct dma_pub;
 struct si_pub;
 struct tx_status;
-- 
1.7.4.1


