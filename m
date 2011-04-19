Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1355 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab1DSHN7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 03:13:59 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: [PATCH 2/2] staging: brcm80211: removed BCMFASTPATH macro
Date: Tue, 19 Apr 2011 09:13:45 +0200
Message-ID: <1303197225-4263-3-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303197225-4263-1-git-send-email-rvossen@broadcom.com>
References: <1303197225-4263-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. BCMFASTPATH expanded to an empty string.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    8 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |   10 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |   12 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |   40 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c      |    4 +-
 drivers/staging/brcm80211/include/bcmdefs.h        |    2 -
 drivers/staging/brcm80211/util/bcmutils.c          |   16 ++++----
 drivers/staging/brcm80211/util/hnddma.c            |   14 +++---
 11 files changed, 55 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 92133c7..2e5f5d9 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -2716,7 +2716,7 @@ void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_cmplx_pwr_dB, u8 core)
 	}
 }
 
-void BCMFASTPATH wlc_phy_rssi_compute(wlc_phy_t *pih, void *ctx)
+void wlc_phy_rssi_compute(wlc_phy_t *pih, void *ctx)
 {
 	wlc_d11rxhdr_t *wlc_rxhdr = (wlc_d11rxhdr_t *) ctx;
 	d11rxhdr_t *rxh = &wlc_rxhdr->rxhdr;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index 56e0ba1..a099f7f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -21438,7 +21438,7 @@ static void wlc_phy_rssi_cal_nphy_rev2(phy_info_t *pi, u8 rssi_type)
 	wlc_phy_resetcca_nphy(pi);
 }
 
-int BCMFASTPATH
+int
 wlc_phy_rssi_compute_nphy(phy_info_t *pi, wlc_d11rxhdr_t *wlc_rxh)
 {
 	d11rxhdr_t *rxh = &wlc_rxh->rxhdr;
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 43938f4..9e092a2 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -1465,7 +1465,7 @@ uint wl_reset(struct wl_info *wl)
  * These are interrupt on/off entry points. Disable interrupts
  * during interrupt state transition.
  */
-void BCMFASTPATH wl_intrson(struct wl_info *wl)
+void wl_intrson(struct wl_info *wl)
 {
 	unsigned long flags;
 
@@ -1482,7 +1482,7 @@ bool wl_alloc_dma_resources(struct wl_info *wl, uint addrwidth)
 	return true;
 }
 
-u32 BCMFASTPATH wl_intrsoff(struct wl_info *wl)
+u32 wl_intrsoff(struct wl_info *wl)
 {
 	unsigned long flags;
 	u32 status;
@@ -1539,7 +1539,7 @@ void wl_down(struct wl_info *wl)
 	WL_LOCK(wl);
 }
 
-static irqreturn_t BCMFASTPATH wl_isr(int irq, void *dev_id)
+static irqreturn_t wl_isr(int irq, void *dev_id)
 {
 	struct wl_info *wl;
 	bool ours, wantdpc;
@@ -1566,7 +1566,7 @@ static irqreturn_t BCMFASTPATH wl_isr(int irq, void *dev_id)
 	return IRQ_RETVAL(ours);
 }
 
-static void BCMFASTPATH wl_dpc(unsigned long data)
+static void wl_dpc(unsigned long data)
 {
 	struct wl_info *wl;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index f217cd8..c72a243 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -447,7 +447,7 @@ static void wlc_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 	}
 }
 
-static void BCMFASTPATH
+static void
 wlc_ampdu_agg(struct ampdu_info *ampdu, struct scb *scb, struct sk_buff *p,
 	      uint prec)
 {
@@ -465,7 +465,7 @@ wlc_ampdu_agg(struct ampdu_info *ampdu, struct scb *scb, struct sk_buff *p,
 	return;
 }
 
-int BCMFASTPATH
+int
 wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	      struct sk_buff **pdu, int prec)
 {
@@ -861,7 +861,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	return err;
 }
 
-void BCMFASTPATH
+void
 wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		     struct sk_buff *p, tx_status_t *txs)
 {
@@ -933,7 +933,7 @@ rate_status(struct wlc_info *wlc, struct ieee80211_tx_info *tx_info,
 
 #define SHORTNAME "AMPDU status"
 
-static void BCMFASTPATH
+static void
 wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			      struct sk_buff *p, tx_status_t *txs,
 			      u32 s1, u32 s2)
@@ -1233,7 +1233,7 @@ static void ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur)
 	}
 }
 
-u8 BCMFASTPATH
+u8
 wlc_ampdu_null_delim_cnt(struct ampdu_info *ampdu, struct scb *scb,
 			 ratespec_t rspec, int phylen)
 {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index 7a154ab..c003d67 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -200,7 +200,7 @@ wlc_antsel_init_cfg(struct antsel_info *asi, wlc_antselcfg_t *antsel,
 	}
 }
 
-void BCMFASTPATH
+void
 wlc_antsel_antcfg_get(struct antsel_info *asi, bool usedef, bool sel,
 		      u8 antselid, u8 fbantselid, u8 *antcfg,
 		      u8 *fbantcfg)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index fc61584..af0d9ca 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -256,7 +256,7 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
  * Return true if more frames need to be processed. false otherwise.
  * Param 'bound' indicates max. # frames to process before break out.
  */
-static bool BCMFASTPATH
+static bool
 wlc_bmac_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
 {
 	struct sk_buff *p;
@@ -305,7 +305,7 @@ wlc_bmac_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
  *   Return true if another dpc needs to be re-scheduled. false otherwise.
  *   Param 'bounded' indicates if applicable loops should be bounded.
  */
-bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
+bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 {
 	u32 macintstatus;
 	struct wlc_hw_info *wlc_hw = wlc->hw;
@@ -2975,7 +2975,7 @@ bool wlc_intrsupd(struct wlc_info *wlc)
  * *wantdpc will be set to true if further wlc_dpc() processing is required,
  * false otherwise.
  */
-bool BCMFASTPATH wlc_isr(struct wlc_info *wlc, bool *wantdpc)
+bool wlc_isr(struct wlc_info *wlc, bool *wantdpc)
 {
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 	u32 macintstatus;
@@ -3004,7 +3004,7 @@ bool BCMFASTPATH wlc_isr(struct wlc_info *wlc, bool *wantdpc)
 
 }
 
-static bool BCMFASTPATH
+static bool
 wlc_bmac_dotxstatus(struct wlc_hw_info *wlc_hw, tx_status_t *txs, u32 s2)
 {
 	/* discard intermediate indications for ucode with one legitimate case:
@@ -3023,7 +3023,7 @@ wlc_bmac_dotxstatus(struct wlc_hw_info *wlc_hw, tx_status_t *txs, u32 s2)
 /* process tx completion events in BMAC
  * Return true if more tx status need to be processed. false otherwise.
  */
-static bool BCMFASTPATH
+static bool
 wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 {
 	bool morepending = false;
@@ -3253,7 +3253,7 @@ void wlc_bmac_band_stf_ss_set(struct wlc_hw_info *wlc_hw, u8 stf_mode)
 		wlc_upd_ofdm_pctl1_table(wlc_hw);
 }
 
-void BCMFASTPATH
+void
 wlc_bmac_read_tsf(struct wlc_hw_info *wlc_hw, u32 *tsf_l_ptr,
 		  u32 *tsf_h_ptr)
 {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 46bf93b..c043045 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -243,7 +243,7 @@ static const u8 acbitmap2maxprio[] = {
 #define WLC_REPLAY_CNTRS_VALUE	WPA_CAP_16_REPLAY_CNTRS
 
 /* local prototypes */
-static u16 BCMFASTPATH wlc_d11hdrs_mac80211(struct wlc_info *wlc,
+static u16 wlc_d11hdrs_mac80211(struct wlc_info *wlc,
 					       struct ieee80211_hw *hw,
 					       struct sk_buff *p,
 					       struct scb *scb, uint frag,
@@ -4818,13 +4818,13 @@ static u16 wlc_rate_shm_offset(struct wlc_info *wlc, u8 rate)
  *
  * Returns true if packet consumed (queued), false if not.
  */
-bool BCMFASTPATH
+bool
 wlc_prec_enq(struct wlc_info *wlc, struct pktq *q, void *pkt, int prec)
 {
 	return wlc_prec_enq_head(wlc, q, pkt, prec, false);
 }
 
-bool BCMFASTPATH
+bool
 wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 		  int prec, bool head)
 {
@@ -4880,7 +4880,7 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 	return true;
 }
 
-void BCMFASTPATH wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
+void wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 			     uint prec)
 {
 	struct wlc_info *wlc = (struct wlc_info *) ctx;
@@ -4921,7 +4921,7 @@ void BCMFASTPATH wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 	}
 }
 
-bool BCMFASTPATH
+bool
 wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 		     struct ieee80211_hw *hw)
 {
@@ -4946,7 +4946,7 @@ wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 	return 0;
 }
 
-void BCMFASTPATH wlc_send_q(struct wlc_info *wlc)
+void wlc_send_q(struct wlc_info *wlc)
 {
 	struct sk_buff *pkt[DOT11_MAXNUMFRAGS];
 	int prec;
@@ -5033,7 +5033,7 @@ bcmc_fid_generate(struct wlc_info *wlc, struct wlc_bsscfg *bsscfg,
 	return frameid;
 }
 
-void BCMFASTPATH
+void
 wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
 	   s8 txpktpend)
 {
@@ -5116,7 +5116,7 @@ wlc_compute_airtime(struct wlc_info *wlc, ratespec_t rspec, uint length)
 	return usec;
 }
 
-void BCMFASTPATH
+void
 wlc_compute_plcp(struct wlc_info *wlc, ratespec_t rspec, uint length, u8 *plcp)
 {
 	if (IS_MCS(rspec)) {
@@ -5144,7 +5144,7 @@ static void wlc_compute_mimo_plcp(ratespec_t rspec, uint length, u8 *plcp)
 }
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
-static void BCMFASTPATH
+static void
 wlc_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
 {
 	u8 rate_signal;
@@ -5236,7 +5236,7 @@ static void wlc_compute_cck_plcp(struct wlc_info *wlc, ratespec_t rspec,
  * next_frag_len	next MPDU length in bytes
  * preamble_type	use short/GF or long/MM PLCP header
  */
-static u16 BCMFASTPATH
+static u16
 wlc_compute_frame_dur(struct wlc_info *wlc, ratespec_t rate, u8 preamble_type,
 		      uint next_frag_len)
 {
@@ -5270,7 +5270,7 @@ wlc_compute_frame_dur(struct wlc_info *wlc, ratespec_t rate, u8 preamble_type,
  * rate			next MPDU rate in unit of 500kbps
  * frame_len		next MPDU frame length in bytes
  */
-u16 BCMFASTPATH
+u16
 wlc_compute_rtscts_dur(struct wlc_info *wlc, bool cts_only, ratespec_t rts_rate,
 		       ratespec_t frame_rate, u8 rts_preamble_type,
 		       u8 frame_preamble_type, uint frame_len, bool ba)
@@ -5302,7 +5302,7 @@ wlc_compute_rtscts_dur(struct wlc_info *wlc, bool cts_only, ratespec_t rts_rate,
 	return dur;
 }
 
-u16 BCMFASTPATH wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
+u16 wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 {
 	u16 phyctl1 = 0;
 	u16 bw;
@@ -5348,7 +5348,7 @@ u16 BCMFASTPATH wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 	return phyctl1;
 }
 
-ratespec_t BCMFASTPATH
+ratespec_t
 wlc_rspec_to_rts_rspec(struct wlc_info *wlc, ratespec_t rspec, bool use_rspec,
 		       u16 mimo_ctlchbw)
 {
@@ -5404,7 +5404,7 @@ wlc_rspec_to_rts_rspec(struct wlc_info *wlc, ratespec_t rspec, bool use_rspec,
  * headroom == D11_PHY_HDR_LEN + D11_TXH_LEN (D11_TXH_LEN is now 104 bytes)
  *
  */
-static u16 BCMFASTPATH
+static u16
 wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		     struct sk_buff *p, struct scb *scb, uint frag,
 		     uint nfrags, uint queue, uint next_frag_len,
@@ -6197,7 +6197,7 @@ static void wlc_war16165(struct wlc_info *wlc, bool tx)
 
 /* process an individual tx_status_t */
 /* WLC_HIGH_API */
-bool BCMFASTPATH
+bool
 wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 {
 	struct sk_buff *p;
@@ -6355,7 +6355,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 
 }
 
-void BCMFASTPATH
+void
 wlc_txfifo_complete(struct wlc_info *wlc, uint fifo, s8 txpktpend)
 {
 	TXPKTPENDDEC(wlc, fifo, txpktpend);
@@ -6660,7 +6660,7 @@ void wlc_bss_list_free(struct wlc_info *wlc, struct wlc_bss_list *bss_list)
  * Param 'bound' indicates max. # frames to process before break out.
  */
 /* WLC_HIGH_API */
-void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
+void wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 {
 	d11rxhdr_t *rxh;
 	struct ieee80211_hdr *h;
@@ -6759,7 +6759,7 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
  * Formula given by HT PHY Spec v 1.13
  *   len = 3(nsyms + nstream + 3) - 3
  */
-u16 BCMFASTPATH
+u16
 wlc_calc_lsig_len(struct wlc_info *wlc, ratespec_t ratespec, uint mac_len)
 {
 	uint nsyms, len = 0, kNdps;
@@ -6799,7 +6799,7 @@ wlc_calc_lsig_len(struct wlc_info *wlc, ratespec_t ratespec, uint mac_len)
 }
 
 /* calculate frame duration of a given rate and length, return time in usec unit */
-uint BCMFASTPATH
+uint
 wlc_calc_frame_time(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 		    uint mac_len)
 {
@@ -6929,7 +6929,7 @@ wlc_calc_ba_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 				    FCS_LEN));
 }
 
-static uint BCMFASTPATH
+static uint
 wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
 	uint dur = 0;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
index 87a2f62..87b252d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
@@ -332,7 +332,7 @@ wlc_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
 }
 
 /* calculate the rate of a rx'd frame and return it as a ratespec */
-ratespec_t BCMFASTPATH wlc_compute_rspec(d11rxhdr_t *rxh, u8 *plcp)
+ratespec_t wlc_compute_rspec(d11rxhdr_t *rxh, u8 *plcp)
 {
 	int phy_type;
 	ratespec_t rspec = PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT;
@@ -466,7 +466,7 @@ wlc_rateset_default(wlc_rateset_t *rs_tgt, const wlc_rateset_t *rs_hw,
 					   mcsallow ? txstreams : 1);
 }
 
-s16 BCMFASTPATH wlc_rate_legacy_phyctl(uint rate)
+s16 wlc_rate_legacy_phyctl(uint rate)
 {
 	uint i;
 	for (i = 0; i < LEGACY_PHYCFG_TABLE_SIZE; i++)
diff --git a/drivers/staging/brcm80211/include/bcmdefs.h b/drivers/staging/brcm80211/include/bcmdefs.h
index 5d1a620..854f14f 100644
--- a/drivers/staging/brcm80211/include/bcmdefs.h
+++ b/drivers/staging/brcm80211/include/bcmdefs.h
@@ -36,8 +36,6 @@
 
 #define	AUTO	(-1)		/* Auto = -1 */
 
-#define BCMFASTPATH
-
 /* Bus types */
 #define	SI_BUS			0	/* SOC Interconnect */
 #define	PCI_BUS			1	/* PCI target */
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index df1b6fe..9d5e627 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -32,7 +32,7 @@
 /* Global ASSERT type flag */
 u32 g_assert_type;
 
-struct sk_buff *BCMFASTPATH pkt_buf_get_skb(uint len)
+struct sk_buff *pkt_buf_get_skb(uint len)
 {
 	struct sk_buff *skb;
 
@@ -46,7 +46,7 @@ struct sk_buff *BCMFASTPATH pkt_buf_get_skb(uint len)
 }
 
 /* Free the driver packet. Free the tag if present */
-void BCMFASTPATH pkt_buf_free_skb(struct sk_buff *skb)
+void pkt_buf_free_skb(struct sk_buff *skb)
 {
 	struct sk_buff *nskb;
 	int nest = 0;
@@ -101,7 +101,7 @@ uint pktfrombuf(struct sk_buff *p, uint offset, int len,
 	return ret;
 }
 /* return total length of buffer chain */
-uint BCMFASTPATH pkttotlen(struct sk_buff *p)
+uint pkttotlen(struct sk_buff *p)
 {
 	uint total;
 
@@ -115,7 +115,7 @@ uint BCMFASTPATH pkttotlen(struct sk_buff *p)
  * osl multiple-precedence packet queue
  * hi_prec is always >= the number of the highest non-empty precedence
  */
-struct sk_buff *BCMFASTPATH pktq_penq(struct pktq *pq, int prec,
+struct sk_buff *pktq_penq(struct pktq *pq, int prec,
 				      struct sk_buff *p)
 {
 	struct pktq_prec *q;
@@ -141,7 +141,7 @@ struct sk_buff *BCMFASTPATH pktq_penq(struct pktq *pq, int prec,
 	return p;
 }
 
-struct sk_buff *BCMFASTPATH pktq_penq_head(struct pktq *pq, int prec,
+struct sk_buff *pktq_penq_head(struct pktq *pq, int prec,
 					   struct sk_buff *p)
 {
 	struct pktq_prec *q;
@@ -166,7 +166,7 @@ struct sk_buff *BCMFASTPATH pktq_penq_head(struct pktq *pq, int prec,
 	return p;
 }
 
-struct sk_buff *BCMFASTPATH pktq_pdeq(struct pktq *pq, int prec)
+struct sk_buff *pktq_pdeq(struct pktq *pq, int prec)
 {
 	struct pktq_prec *q;
 	struct sk_buff *p;
@@ -190,7 +190,7 @@ struct sk_buff *BCMFASTPATH pktq_pdeq(struct pktq *pq, int prec)
 	return p;
 }
 
-struct sk_buff *BCMFASTPATH pktq_pdeq_tail(struct pktq *pq, int prec)
+struct sk_buff *pktq_pdeq_tail(struct pktq *pq, int prec)
 {
 	struct pktq_prec *q;
 	struct sk_buff *p, *prev;
@@ -331,7 +331,7 @@ int pktq_mlen(struct pktq *pq, uint prec_bmp)
 	return len;
 }
 /* Priority dequeue from a specific set of precedences */
-struct sk_buff *BCMFASTPATH pktq_mdeq(struct pktq *pq, uint prec_bmp,
+struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp,
 				      int *prec_out)
 {
 	struct pktq_prec *q;
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index 134caf2..7d9a99d 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -700,7 +700,7 @@ _dma_rx_param_get(dma_info_t *di, u16 *rxoffset, u16 *rxbufsize)
  *   After it reaches the max size of buffer, the data continues in next DMA descriptor
  *   buffer WITHOUT DMA header
  */
-static void *BCMFASTPATH _dma_rx(dma_info_t *di)
+static void *_dma_rx(dma_info_t *di)
 {
 	struct sk_buff *p, *head, *tail;
 	uint len;
@@ -761,7 +761,7 @@ static void *BCMFASTPATH _dma_rx(dma_info_t *di)
  *  this will stall the rx dma and user might want to call rxfill again asap
  *  This unlikely happens on memory-rich NIC, but often on memory-constrained dongle
  */
-static bool BCMFASTPATH _dma_rxfill(dma_info_t *di)
+static bool _dma_rxfill(dma_info_t *di)
 {
 	struct sk_buff *p;
 	u16 rxin, rxout;
@@ -896,7 +896,7 @@ static void _dma_rxreclaim(dma_info_t *di)
 		pkt_buf_free_skb(p);
 }
 
-static void *BCMFASTPATH _dma_getnextrxp(dma_info_t *di, bool forceall)
+static void *_dma_getnextrxp(dma_info_t *di, bool forceall)
 {
 	if (di->nrxd == 0)
 		return NULL;
@@ -1111,7 +1111,7 @@ static bool dma64_txsuspended(dma_info_t *di)
 	     D64_XC_SE);
 }
 
-static void BCMFASTPATH dma64_txreclaim(dma_info_t *di, txd_range_t range)
+static void dma64_txreclaim(dma_info_t *di, txd_range_t range)
 {
 	void *p;
 
@@ -1358,7 +1358,7 @@ static int dma64_txunframed(dma_info_t *di, void *buf, uint len, bool commit)
  * WARNING: call must check the return value for error.
  *   the error(toss frames) could be fatal and cause many subsequent hard to debug problems
  */
-static int BCMFASTPATH dma64_txfast(dma_info_t *di, struct sk_buff *p0,
+static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 				    bool commit)
 {
 	struct sk_buff *p, *next;
@@ -1480,7 +1480,7 @@ static int BCMFASTPATH dma64_txfast(dma_info_t *di, struct sk_buff *p0,
  * If range is HNDDMA_RANGE_ALL, reclaim all txd(s) posted to the ring and
  * return associated packet regardless of the value of hardware pointers.
  */
-static void *BCMFASTPATH dma64_getnexttxp(dma_info_t *di, txd_range_t range)
+static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 {
 	u16 start, end, i;
 	u16 active_desc;
@@ -1573,7 +1573,7 @@ static void *BCMFASTPATH dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 }
 
 /* if forcing, dma engine must be disabled */
-static void *BCMFASTPATH dma64_getnextrxp(dma_info_t *di, bool forceall)
+static void *dma64_getnextrxp(dma_info_t *di, bool forceall)
 {
 	uint i, curr;
 	void *rxp;
-- 
1.7.1


