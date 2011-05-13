Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2942 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850Ab1EMKAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/32] staging: brcm80211: removed counter related
 struct wl_cnt
Date: Fri, 13 May 2011 11:59:36 +0200
Message-ID: <1305280792-9475-16-git-send-email-arend@broadcom.com> (sfid-20110513_120046_602348_AF30B85C)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Struct wl_cnt contains all sorts of counters, but either these
were written and never read, or set to zero at initialization but never
updated. Therefore the struct and any code accessing the struct has been
removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |    8 +-
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c   |    5 -
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c   |    5 -
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c    |   17 --
 drivers/staging/brcm80211/brcmsmac/wlc_main.c    |  108 ----------
 drivers/staging/brcm80211/include/wlioctl.h      |  234 ----------------------
 6 files changed, 4 insertions(+), 373 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index df98bb8..6c6236c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -532,10 +532,10 @@ wl_ops_get_stats(struct ieee80211_hw *hw,
 
 	WL_LOCK(wl);
 	cnt = wl->pub->_cnt;
-	stats->dot11ACKFailureCount = cnt->txnoack;
-	stats->dot11RTSFailureCount = cnt->txnocts;
-	stats->dot11FCSErrorCount = cnt->rxcrc;
-	stats->dot11RTSSuccessCount = cnt->txrts;
+	stats->dot11ACKFailureCount = 0;
+	stats->dot11RTSFailureCount = 0;
+	stats->dot11FCSErrorCount = 0;
+	stats->dot11RTSSuccessCount = 0;
 	WL_UNLOCK(wl);
 	return 0;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index d91cf5a..82c64cd 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -80,10 +80,6 @@ static struct wlc_pub *wlc_pub_malloc(uint unit, uint *err, uint devid)
 	/* need to init the tunables now */
 	wlc_tunables_init(pub->tunables, devid);
 
-	pub->_cnt =  kzalloc(sizeof(struct wl_cnt), GFP_ATOMIC);
-	if (pub->_cnt == NULL)
-		goto fail;
-
 	pub->multicast = kzalloc(ETH_ALEN * MAXMULTILIST, GFP_ATOMIC);
 	if (pub->multicast == NULL) {
 		*err = 1003;
@@ -103,7 +99,6 @@ static void wlc_pub_mfree(struct wlc_pub *pub)
 		return;
 
 	kfree(pub->multicast);
-	kfree(pub->_cnt);
 	kfree(pub->tunables);
 	kfree(pub);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 11aac96..25e67be 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -982,11 +982,7 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			if (supr_status == TX_STATUS_SUPR_BADCH ||
 			    supr_status == TX_STATUS_SUPR_EXPTIME) {
 				retry = false;
-				wlc->pub->_cnt->txchanrej++;
 			} else if (supr_status == TX_STATUS_SUPR_EXPTIME) {
-
-				wlc->pub->_cnt->txexptime++;
-
 				/* TX underflow : try tuning pre-loading or ampdu size */
 			} else if (supr_status == TX_STATUS_SUPR_FRAG) {
 				/* if there were underflows, but pre-loading is not active,
@@ -999,7 +995,6 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			}
 		} else if (txs->phyerr) {
 			update_rate = false;
-			wlc->pub->_cnt->txphyerr++;
 			wiphy_err(wiphy, "wl%d: wlc_ampdu_dotxstatus: tx phy "
 				  "error (0x%x)\n", wlc->pub->unit,
 				  txs->phyerr);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index e7f47eb..4534926 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -362,11 +362,6 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 		wlc->qvalid = 0;
 	}
 
-	/* phy tx error */
-	if (macintstatus & MI_PHYTXERR) {
-		wlc->pub->_cnt->txphyerr++;
-	}
-
 	/* received data or control frame, MI_DMAINT is indication of RX_FIFO interrupt */
 	if (macintstatus & MI_DMAINT) {
 		if (wlc_bmac_recv(wlc_hw, RX_FIFO, bounded)) {
@@ -393,9 +388,6 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
 					__func__, wlc_hw->sih->chip,
 					wlc_hw->sih->chiprev);
-
-		wlc->pub->_cnt->psmwds++;
-
 		/* big hammer */
 		wl_init(wlc->wl);
 	}
@@ -408,7 +400,6 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 	if (macintstatus & MI_RFDISABLE) {
 		BCMMSG(wlc->wiphy, "wl%d: BMAC Detected a change on the"
 		       " RF Disable Input\n", wlc_hw->unit);
-		wlc->pub->_cnt->rfdisable++;
 		wl_rfkill_set_hw_state(wlc->wl);
 	}
 
@@ -1036,8 +1027,6 @@ void wlc_bmac_reset(struct wlc_hw_info *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
-	wlc_hw->wlc->pub->_cnt->reset++;
-
 	/* reset the core */
 	if (!DEVICEREMOVED(wlc_hw->wlc))
 		wlc_bmac_corereset(wlc_hw, WLC_USE_COREFLAGS);
@@ -2638,41 +2627,35 @@ void wlc_bmac_fifoerrors(struct wlc_hw_info *wlc_hw)
 		if (intstatus & I_RO) {
 			wiphy_err(wiphy, "wl%d: fifo %d: receive fifo "
 				  "overflow\n", unit, idx);
-			wlc_hw->wlc->pub->_cnt->rxoflo++;
 			fatal = true;
 		}
 
 		if (intstatus & I_PC) {
 			wiphy_err(wiphy, "wl%d: fifo %d: descriptor error\n",
 				 unit, idx);
-			wlc_hw->wlc->pub->_cnt->dmade++;
 			fatal = true;
 		}
 
 		if (intstatus & I_PD) {
 			wiphy_err(wiphy, "wl%d: fifo %d: data error\n", unit,
 				  idx);
-			wlc_hw->wlc->pub->_cnt->dmada++;
 			fatal = true;
 		}
 
 		if (intstatus & I_DE) {
 			wiphy_err(wiphy, "wl%d: fifo %d: descriptor protocol "
 				  "error\n", unit, idx);
-			wlc_hw->wlc->pub->_cnt->dmape++;
 			fatal = true;
 		}
 
 		if (intstatus & I_RU) {
 			wiphy_err(wiphy, "wl%d: fifo %d: receive descriptor "
 				  "underflow\n", idx, unit);
-			wlc_hw->wlc->pub->_cnt->rxuflo[idx]++;
 		}
 
 		if (intstatus & I_XU) {
 			wiphy_err(wiphy, "wl%d: fifo %d: transmit fifo "
 				  "underflow\n", idx, unit);
-			wlc_hw->wlc->pub->_cnt->txuflo++;
 			fatal = true;
 		}
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index cdd55f8..2762b89 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -247,8 +247,6 @@ static u16 wlc_d11hdrs_mac80211(struct wlc_info *wlc,
 					       uint next_frag_len,
 					       wsec_key_t *key,
 					       ratespec_t rspec_override);
-
-static void wlc_ctrupd_cache(u16 cur_stat, u16 *macstat_snapshot, u32 *macstat);
 static void wlc_bss_default_init(struct wlc_info *wlc);
 static void wlc_ucode_mac_upd(struct wlc_info *wlc);
 static ratespec_t mac80211_wlc_set_nrate(struct wlc_info *wlc,
@@ -1752,9 +1750,6 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 	wlc->cfg->wlc = wlc;
 	pub->txmaxpkts = MAXTXPKTS;
 
-	pub->_cnt->version = WL_CNT_T_VERSION;
-	pub->_cnt->length = sizeof(struct wl_cnt);
-
 	wlc_wme_initparams_sta(wlc, &wlc->wme_param_ie);
 
 	wlc->mimoft = FT_HT;
@@ -4361,24 +4356,6 @@ void wlc_print_txstatus(tx_status_t *txs)
 #endif				/* defined(BCMDBG) */
 }
 
-static void
-wlc_ctrupd_cache(u16 cur_stat, u16 *macstat_snapshot, u32 *macstat)
-{
-	u16 v;
-	u16 delta;
-
-	v = le16_to_cpu(cur_stat);
-	delta = (u16)(v - *macstat_snapshot);
-
-	if (delta != 0) {
-		*macstat += delta;
-		*macstat_snapshot = v;
-	}
-}
-
-#define MACSTATUPD(name) \
-	wlc_ctrupd_cache(macstats.name, &wlc->core->macstat_snapshot->name, &wlc->pub->_cnt->name)
-
 void wlc_statsupd(struct wlc_info *wlc)
 {
 	int i;
@@ -4406,62 +4383,6 @@ void wlc_statsupd(struct wlc_info *wlc)
 	wlc_bmac_copyfrom_shm(wlc->hw, M_UCODE_MACSTAT,
 			      &macstats, sizeof(macstat_t));
 
-	/* update mac stats */
-	MACSTATUPD(txallfrm);
-	MACSTATUPD(txrtsfrm);
-	MACSTATUPD(txctsfrm);
-	MACSTATUPD(txackfrm);
-	MACSTATUPD(txdnlfrm);
-	MACSTATUPD(txbcnfrm);
-	for (i = 0; i < NFIFO; i++)
-		MACSTATUPD(txfunfl[i]);
-	MACSTATUPD(txtplunfl);
-	MACSTATUPD(txphyerr);
-	MACSTATUPD(rxfrmtoolong);
-	MACSTATUPD(rxfrmtooshrt);
-	MACSTATUPD(rxinvmachdr);
-	MACSTATUPD(rxbadfcs);
-	MACSTATUPD(rxbadplcp);
-	MACSTATUPD(rxcrsglitch);
-	MACSTATUPD(rxstrt);
-	MACSTATUPD(rxdfrmucastmbss);
-	MACSTATUPD(rxmfrmucastmbss);
-	MACSTATUPD(rxcfrmucast);
-	MACSTATUPD(rxrtsucast);
-	MACSTATUPD(rxctsucast);
-	MACSTATUPD(rxackucast);
-	MACSTATUPD(rxdfrmocast);
-	MACSTATUPD(rxmfrmocast);
-	MACSTATUPD(rxcfrmocast);
-	MACSTATUPD(rxrtsocast);
-	MACSTATUPD(rxctsocast);
-	MACSTATUPD(rxdfrmmcast);
-	MACSTATUPD(rxmfrmmcast);
-	MACSTATUPD(rxcfrmmcast);
-	MACSTATUPD(rxbeaconmbss);
-	MACSTATUPD(rxdfrmucastobss);
-	MACSTATUPD(rxbeaconobss);
-	MACSTATUPD(rxrsptmout);
-	MACSTATUPD(bcntxcancl);
-	MACSTATUPD(rxf0ovfl);
-	MACSTATUPD(rxf1ovfl);
-	MACSTATUPD(rxf2ovfl);
-	MACSTATUPD(txsfovfl);
-	MACSTATUPD(pmqovfl);
-	MACSTATUPD(rxcgprqfrm);
-	MACSTATUPD(rxcgprsqovfl);
-	MACSTATUPD(txcgprsfail);
-	MACSTATUPD(txcgprssuc);
-	MACSTATUPD(prs_timeout);
-	MACSTATUPD(rxnack);
-	MACSTATUPD(frmscons);
-	MACSTATUPD(txnack);
-	MACSTATUPD(txglitch_nack);
-	MACSTATUPD(txburst);
-	MACSTATUPD(phywatchdog);
-	MACSTATUPD(pktengrxducast);
-	MACSTATUPD(pktengrxdmcast);
-
 #ifdef BCMDBG
 	/* check for rx fifo 0 overflow */
 	delta = (u16) (wlc->core->macstat_snapshot->rxf0ovfl - rxf0ovfl);
@@ -4486,9 +4407,6 @@ void wlc_statsupd(struct wlc_info *wlc)
 			dma_counterreset(wlc->hw->di[i]);
 		}
 	}
-
-	for (i = 0; i < NFIFO; i++)
-		wlc->pub->_cnt->rxerror += wlc->pub->_cnt->rxuflo[i];
 }
 
 bool wlc_chipmatch(u16 vendor, u16 device)
@@ -4720,7 +4638,6 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 		p = discard_oldest ? bcm_pktq_pdeq(q, eprec) :
 			bcm_pktq_pdeq_tail(q, eprec);
 		bcm_pkt_buf_free_skb(p);
-		wlc->pub->_cnt->txnobuf++;
 	}
 
 	/* Enqueue */
@@ -4753,7 +4670,6 @@ void wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 		 * packet flooding from mac80211 stack
 		 */
 		bcm_pkt_buf_free_skb(sdu);
-		wlc->pub->_cnt->txnobuf++;
 	}
 
 	/* Check if flow control needs to be turned on after enqueuing the packet
@@ -4793,8 +4709,6 @@ wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 		return -EINVAL;
 	wlc_txq_enq(wlc, scb, pkt, WLC_PRIO_TO_PREC(prio));
 	wlc_send_q(wlc);
-
-	wlc->pub->_cnt->ieee_tx++;
 	return 0;
 }
 
@@ -5713,7 +5627,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	    (preamble_type[0] == WLC_GF_PREAMBLE)) {
 		if (RSPEC2RATE(rspec[0]) != WLC_RATE_1M)
 			phyctl |= PHY_TXC_SHORT_HDR;
-		wlc->pub->_cnt->txprshort++;
 	}
 
 	/* phytxant is properly bit shifted */
@@ -5850,8 +5763,6 @@ void wlc_tbtt(struct wlc_info *wlc, d11regs_t *regs)
 {
 	struct wlc_bsscfg *cfg = wlc->cfg;
 
-	wlc->pub->_cnt->tbtt++;
-
 	if (BSSCFG_STA(cfg)) {
 		/* run watchdog here if the watchdog timer is not armed */
 		if (WLC_WATCHDOG_TBTT(wlc)) {
@@ -5959,14 +5870,6 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	if (tx_info->control.sta)
 		scb = (struct scb *)tx_info->control.sta->drv_priv;
 
-	if (N_ENAB(wlc->pub)) {
-		u8 *plcp = (u8 *) (txh + 1);
-		if (PLCP3_ISSGI(plcp[3]))
-			wlc->pub->_cnt->txmpdu_sgi++;
-		if (PLCP3_ISSTBC(plcp[3]))
-			wlc->pub->_cnt->txmpdu_stbc++;
-	}
-
 	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 		wlc_ampdu_dotxstatus(wlc->ampdu, scb, p, txs);
 		return false;
@@ -6036,7 +5939,6 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 		skb_pull(p, D11_PHY_HDR_LEN);
 		skb_pull(p, D11_TXH_LEN);
 		ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw, p);
-		wlc->pub->_cnt->ieee_tx_status++;
 	} else {
 		wiphy_err(wlc->wiphy, "%s: Not last frame => not calling "
 			  "tx_status\n", __func__);
@@ -6254,8 +6156,6 @@ wlc_recvctl(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
 
 	memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
 	ieee80211_rx_irqsafe(wlc->pub->ieee_hw, p);
-
-	wlc->pub->_cnt->ieee_rx++;
 	return;
 }
 
@@ -6296,7 +6196,6 @@ void wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	/* MAC inserts 2 pad bytes for a4 headers or QoS or A-MSDU subframes */
 	if (rxh->RxStatus1 & RXS_PBPRES) {
 		if (p->len < 2) {
-			wlc->pub->_cnt->rxrunt++;
 			wiphy_err(wlc->wiphy, "wl%d: wlc_recv: rcvd runt of "
 				  "len %d\n", wlc->pub->unit, p->len);
 			goto toss;
@@ -6320,7 +6219,6 @@ void wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 
 	/* check received pkt has at least frame control field */
 	if (len < D11_PHY_HDR_LEN + sizeof(h->frame_control)) {
-		wlc->pub->_cnt->rxrunt++;
 		goto toss;
 	}
 
@@ -6338,10 +6236,8 @@ void wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 					  "frame with invalid src mac address,"
 					  " a2: %pM\n",
 					 wlc->pub->unit, __func__, h->addr2);
-				wlc->pub->_cnt->rxbadsrcmac++;
 				goto toss;
 			}
-			wlc->pub->_cnt->rxfrag++;
 		}
 	}
 
@@ -7068,10 +6964,6 @@ int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifop)
 		WLC_TX_FIFO_CLEAR(wlc, fifo);
 		return -EBUSY;
 	}
-
-	if (!ieee80211_is_data(txh->MacFrameControl))
-		wlc->pub->_cnt->txctl++;
-
 	return 0;
 }
 
diff --git a/drivers/staging/brcm80211/include/wlioctl.h b/drivers/staging/brcm80211/include/wlioctl.h
index d7f316d..0e79dc8 100644
--- a/drivers/staging/brcm80211/include/wlioctl.h
+++ b/drivers/staging/brcm80211/include/wlioctl.h
@@ -1249,240 +1249,6 @@ struct tsinfo_arg {
 
 #define	NFIFO			6	/* # tx/rx fifopairs */
 
-#define	WL_CNT_T_VERSION	7	/* current version of wl_cnt_t struct */
-
-struct wl_cnt {
-	u16 version;		/* see definition of WL_CNT_T_VERSION */
-	u16 length;		/* length of entire structure */
-
-	/* transmit stat counters */
-	u32 txframe;		/* tx data frames */
-	u32 txbyte;		/* tx data bytes */
-	u32 txretrans;	/* tx mac retransmits */
-	u32 txerror;		/* tx data errors (derived: sum of others) */
-	u32 txctl;		/* tx management frames */
-	u32 txprshort;	/* tx short preamble frames */
-	u32 txserr;		/* tx status errors */
-	u32 txnobuf;		/* tx out of buffers errors */
-	u32 txnoassoc;	/* tx discard because we're not associated */
-	u32 txrunt;		/* tx runt frames */
-	u32 txchit;		/* tx header cache hit (fastpath) */
-	u32 txcmiss;		/* tx header cache miss (slowpath) */
-	u32 ieee_tx_status;	/* calls to ieee80211_tx_status */
-	u32 ieee_tx;		/* tx calls frm mac0211 */
-	u32 ieee_rx;		/* calls to ieee_rx */
-
-	/* transmit chip error counters */
-	u32 txuflo;		/* tx fifo underflows */
-	u32 txphyerr;	/* tx phy errors (indicated in tx status) */
-	u32 txphycrs;
-
-	/* receive stat counters */
-	u32 rxframe;		/* rx data frames */
-	u32 rxbyte;		/* rx data bytes */
-	u32 rxerror;		/* rx data errors (derived: sum of others) */
-	u32 rxctl;		/* rx management frames */
-	u32 rxnobuf;		/* rx out of buffers errors */
-	u32 rxnondata;	/* rx non data frames in the data channel errors */
-	u32 rxbadds;		/* rx bad DS errors */
-	u32 rxbadcm;		/* rx bad control or management frames */
-	u32 rxfragerr;	/* rx fragmentation errors */
-	u32 rxrunt;		/* rx runt frames */
-	u32 rxgiant;		/* rx giant frames */
-	u32 rxnoscb;		/* rx no scb error */
-	u32 rxbadproto;	/* rx invalid frames */
-	u32 rxbadsrcmac;	/* rx frames with Invalid Src Mac */
-	u32 rxbadda;		/* rx frames tossed for invalid da */
-	u32 rxfilter;	/* rx frames filtered out */
-
-	/* receive chip error counters */
-	u32 rxoflo;		/* rx fifo overflow errors */
-	u32 rxuflo[NFIFO];	/* rx dma descriptor underflow errors */
-
-	u32 d11cnt_txrts_off;	/* d11cnt txrts value when reset d11cnt */
-	u32 d11cnt_rxcrc_off;	/* d11cnt rxcrc value when reset d11cnt */
-	u32 d11cnt_txnocts_off;	/* d11cnt txnocts value when reset d11cnt */
-
-	/* misc counters */
-	u32 dmade;		/* tx/rx dma descriptor errors */
-	u32 dmada;		/* tx/rx dma data errors */
-	u32 dmape;		/* tx/rx dma descriptor protocol errors */
-	u32 reset;		/* reset count */
-	u32 tbtt;		/* cnts the TBTT int's */
-	u32 txdmawar;
-	u32 pkt_callback_reg_fail;	/* callbacks register failure */
-
-	/* MAC counters: 32-bit version of d11.h's macstat_t */
-	u32 txallfrm;	/* total number of frames sent, incl. Data, ACK, RTS, CTS,
-				 * Control Management (includes retransmissions)
-				 */
-	u32 txrtsfrm;	/* number of RTS sent out by the MAC */
-	u32 txctsfrm;	/* number of CTS sent out by the MAC */
-	u32 txackfrm;	/* number of ACK frames sent out */
-	u32 txdnlfrm;	/* Not used */
-	u32 txbcnfrm;	/* beacons transmitted */
-	u32 txfunfl[8];	/* per-fifo tx underflows */
-	u32 txtplunfl;	/* Template underflows (mac was too slow to transmit ACK/CTS
-				 * or BCN)
-				 */
-	u32 txphyerror;	/* Transmit phy error, type of error is reported in tx-status for
-				 * driver enqueued frames
-				 */
-	u32 rxfrmtoolong;	/* Received frame longer than legal limit (2346 bytes) */
-	u32 rxfrmtooshrt;	/* Received frame did not contain enough bytes for its frame type */
-	u32 rxinvmachdr;	/* Either the protocol version != 0 or frame type not
-				 * data/control/management
-				 */
-	u32 rxbadfcs;	/* number of frames for which the CRC check failed in the MAC */
-	u32 rxbadplcp;	/* parity check of the PLCP header failed */
-	u32 rxcrsglitch;	/* PHY was able to correlate the preamble but not the header */
-	u32 rxstrt;		/* Number of received frames with a good PLCP
-				 * (i.e. passing parity check)
-				 */
-	u32 rxdfrmucastmbss;	/* Number of received DATA frames with good FCS and matching RA */
-	u32 rxmfrmucastmbss;	/* number of received mgmt frames with good FCS and matching RA */
-	u32 rxcfrmucast;	/* number of received CNTRL frames with good FCS and matching RA */
-	u32 rxrtsucast;	/* number of unicast RTS addressed to the MAC (good FCS) */
-	u32 rxctsucast;	/* number of unicast CTS addressed to the MAC (good FCS) */
-	u32 rxackucast;	/* number of ucast ACKS received (good FCS) */
-	u32 rxdfrmocast;	/* number of received DATA frames (good FCS and not matching RA) */
-	u32 rxmfrmocast;	/* number of received MGMT frames (good FCS and not matching RA) */
-	u32 rxcfrmocast;	/* number of received CNTRL frame (good FCS and not matching RA) */
-	u32 rxrtsocast;	/* number of received RTS not addressed to the MAC */
-	u32 rxctsocast;	/* number of received CTS not addressed to the MAC */
-	u32 rxdfrmmcast;	/* number of RX Data multicast frames received by the MAC */
-	u32 rxmfrmmcast;	/* number of RX Management multicast frames received by the MAC */
-	u32 rxcfrmmcast;	/* number of RX Control multicast frames received by the MAC
-				 * (unlikely to see these)
-				 */
-	u32 rxbeaconmbss;	/* beacons received from member of BSS */
-	u32 rxdfrmucastobss;	/* number of unicast frames addressed to the MAC from
-				 * other BSS (WDS FRAME)
-				 */
-	u32 rxbeaconobss;	/* beacons received from other BSS */
-	u32 rxrsptmout;	/* Number of response timeouts for transmitted frames
-				 * expecting a response
-				 */
-	u32 bcntxcancl;	/* transmit beacons canceled due to receipt of beacon (IBSS) */
-	u32 rxf0ovfl;	/* Number of receive fifo 0 overflows */
-	u32 rxf1ovfl;	/* Number of receive fifo 1 overflows (obsolete) */
-	u32 rxf2ovfl;	/* Number of receive fifo 2 overflows (obsolete) */
-	u32 txsfovfl;	/* Number of transmit status fifo overflows (obsolete) */
-	u32 pmqovfl;		/* Number of PMQ overflows */
-	u32 rxcgprqfrm;	/* Number of received Probe requests that made it into
-				 * the PRQ fifo
-				 */
-	u32 rxcgprsqovfl;	/* Rx Probe Request Que overflow in the AP */
-	u32 txcgprsfail;	/* Tx Probe Response Fail. AP sent probe response but did
-				 * not get ACK
-				 */
-	u32 txcgprssuc;	/* Tx Probe Response Success (ACK was received) */
-	u32 prs_timeout;	/* Number of probe requests that were dropped from the PRQ
-				 * fifo because a probe response could not be sent out within
-				 * the time limit defined in M_PRS_MAXTIME
-				 */
-	u32 rxnack;
-	u32 frmscons;
-	u32 txnack;
-	u32 txglitch_nack;	/* obsolete */
-	u32 txburst;		/* obsolete */
-
-	/* 802.11 MIB counters, pp. 614 of 802.11 reaff doc. */
-	u32 txfrag;		/* dot11TransmittedFragmentCount */
-	u32 txmulti;		/* dot11MulticastTransmittedFrameCount */
-	u32 txfail;		/* dot11FailedCount */
-	u32 txretry;		/* dot11RetryCount */
-	u32 txretrie;	/* dot11MultipleRetryCount */
-	u32 rxdup;		/* dot11FrameduplicateCount */
-	u32 txrts;		/* dot11RTSSuccessCount */
-	u32 txnocts;		/* dot11RTSFailureCount */
-	u32 txnoack;		/* dot11ACKFailureCount */
-	u32 rxfrag;		/* dot11ReceivedFragmentCount */
-	u32 rxmulti;		/* dot11MulticastReceivedFrameCount */
-	u32 rxcrc;		/* dot11FCSErrorCount */
-	u32 txfrmsnt;	/* dot11TransmittedFrameCount (bogus MIB?) */
-	u32 rxundec;		/* dot11WEPUndecryptableCount */
-
-	/* WPA2 counters (see rxundec for DecryptFailureCount) */
-	u32 tkipmicfaill;	/* TKIPLocalMICFailures */
-	u32 tkipcntrmsr;	/* TKIPCounterMeasuresInvoked */
-	u32 tkipreplay;	/* TKIPReplays */
-	u32 ccmpfmterr;	/* CCMPFormatErrors */
-	u32 ccmpreplay;	/* CCMPReplays */
-	u32 ccmpundec;	/* CCMPDecryptErrors */
-	u32 fourwayfail;	/* FourWayHandshakeFailures */
-	u32 wepundec;	/* dot11WEPUndecryptableCount */
-	u32 wepicverr;	/* dot11WEPICVErrorCount */
-	u32 decsuccess;	/* DecryptSuccessCount */
-	u32 tkipicverr;	/* TKIPICVErrorCount */
-	u32 wepexcluded;	/* dot11WEPExcludedCount */
-
-	u32 rxundec_mcst;	/* dot11WEPUndecryptableCount */
-
-	/* WPA2 counters (see rxundec for DecryptFailureCount) */
-	u32 tkipmicfaill_mcst;	/* TKIPLocalMICFailures */
-	u32 tkipcntrmsr_mcst;	/* TKIPCounterMeasuresInvoked */
-	u32 tkipreplay_mcst;	/* TKIPReplays */
-	u32 ccmpfmterr_mcst;	/* CCMPFormatErrors */
-	u32 ccmpreplay_mcst;	/* CCMPReplays */
-	u32 ccmpundec_mcst;	/* CCMPDecryptErrors */
-	u32 fourwayfail_mcst;	/* FourWayHandshakeFailures */
-	u32 wepundec_mcst;	/* dot11WEPUndecryptableCount */
-	u32 wepicverr_mcst;	/* dot11WEPICVErrorCount */
-	u32 decsuccess_mcst;	/* DecryptSuccessCount */
-	u32 tkipicverr_mcst;	/* TKIPICVErrorCount */
-	u32 wepexcluded_mcst;	/* dot11WEPExcludedCount */
-
-	u32 txchanrej;	/* Tx frames suppressed due to channel rejection */
-	u32 txexptime;	/* Tx frames suppressed due to timer expiration */
-	u32 psmwds;		/* Count PSM watchdogs */
-	u32 phywatchdog;	/* Count Phy watchdogs (triggered by ucode) */
-
-	/* MBSS counters, AP only */
-	u32 prq_entries_handled;	/* PRQ entries read in */
-	u32 prq_undirected_entries;	/*    which were bcast bss & ssid */
-	u32 prq_bad_entries;	/*    which could not be translated to info */
-	u32 atim_suppress_count;	/* TX suppressions on ATIM fifo */
-	u32 bcn_template_not_ready;	/* Template marked in use on send bcn ... */
-	u32 bcn_template_not_ready_done;	/* ...but "DMA done" interrupt rcvd */
-	u32 late_tbtt_dpc;	/* TBTT DPC did not happen in time */
-
-	/* per-rate receive stat counters */
-	u32 rx1mbps;		/* packets rx at 1Mbps */
-	u32 rx2mbps;		/* packets rx at 2Mbps */
-	u32 rx5mbps5;	/* packets rx at 5.5Mbps */
-	u32 rx6mbps;		/* packets rx at 6Mbps */
-	u32 rx9mbps;		/* packets rx at 9Mbps */
-	u32 rx11mbps;	/* packets rx at 11Mbps */
-	u32 rx12mbps;	/* packets rx at 12Mbps */
-	u32 rx18mbps;	/* packets rx at 18Mbps */
-	u32 rx24mbps;	/* packets rx at 24Mbps */
-	u32 rx36mbps;	/* packets rx at 36Mbps */
-	u32 rx48mbps;	/* packets rx at 48Mbps */
-	u32 rx54mbps;	/* packets rx at 54Mbps */
-	u32 rx108mbps;	/* packets rx at 108mbps */
-	u32 rx162mbps;	/* packets rx at 162mbps */
-	u32 rx216mbps;	/* packets rx at 216 mbps */
-	u32 rx270mbps;	/* packets rx at 270 mbps */
-	u32 rx324mbps;	/* packets rx at 324 mbps */
-	u32 rx378mbps;	/* packets rx at 378 mbps */
-	u32 rx432mbps;	/* packets rx at 432 mbps */
-	u32 rx486mbps;	/* packets rx at 486 mbps */
-	u32 rx540mbps;	/* packets rx at 540 mbps */
-
-	/* pkteng rx frame stats */
-	u32 pktengrxducast;	/* unicast frames rxed by the pkteng code */
-	u32 pktengrxdmcast;	/* multicast frames rxed by the pkteng code */
-
-	u32 rfdisable;	/* count of radio disables */
-	u32 bphy_rxcrsglitch;	/* PHY count of bphy glitches */
-
-	u32 txmpdu_sgi;	/* count for sgi transmit */
-	u32 rxmpdu_sgi;	/* count for sgi received */
-	u32 txmpdu_stbc;	/* count for stbc transmit */
-	u32 rxmpdu_stbc;	/* count for stbc received */
-};
-
 #define	WL_DELTA_STATS_T_VERSION	1	/* current version of wl_delta_stats_t struct */
 
 typedef struct {
-- 
1.7.4.1


