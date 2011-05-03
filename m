Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2356 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 16/61] staging: brcm80211: removed ASSERTs from
 wlc_ampdu.c
Date: Tue, 3 May 2011 11:35:16 +0200
Message-ID: <1304415361-7813-17-git-send-email-arend@broadcom.com> (sfid-20110503_113842_857072_8562F970)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Driver contains far too many ASSERTs.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |   57 +-----------------------
 1 files changed, 1 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index be12748..fce2906 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -164,9 +164,6 @@ struct ampdu_info *wlc_ampdu_attach(struct wlc_info *wlc)
 	struct ampdu_info *ampdu;
 	int i;
 
-	ASSERT(wlc->pub->tunables->ampdunummpdu <= AMPDU_MAX_MPDU);
-	ASSERT(wlc->pub->tunables->ampdunummpdu > 0);
-
 	ampdu = kzalloc(sizeof(struct ampdu_info), GFP_ATOMIC);
 	if (!ampdu) {
 		wiphy_err(wlc->wiphy, "wl%d: wlc_ampdu_attach: out of mem\n",
@@ -239,8 +236,6 @@ void scb_ampdu_cleanup(struct ampdu_info *ampdu, struct scb *scb)
 	u8 tid;
 
 	WL_AMPDU_UPDN("scb_ampdu_cleanup: enter\n");
-	ASSERT(scb_ampdu);
-
 	for (tid = 0; tid < AMPDU_MAX_SCB_TID; tid++) {
 		ampdu_cleanup_tid_ini(ampdu, scb_ampdu, tid, false);
 	}
@@ -279,8 +274,6 @@ static void scb_ampdu_update_config(struct ampdu_info *ampdu, struct scb *scb)
 	scb_ampdu->release = min(scb_ampdu->release,
 				 ampdu->fifo_tb[TX_AC_BE_FIFO].
 				 mcs2ampdu_table[FFPLD_MAX_MCS]);
-
-	ASSERT(scb_ampdu->release);
 }
 
 void scb_ampdu_update_config_all(struct ampdu_info *ampdu)
@@ -522,10 +515,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	wiphy = wlc->wiphy;
 	p = *pdu;
 
-	ASSERT(p);
-
 	tid = (u8) (p->priority);
-	ASSERT(tid < AMPDU_MAX_SCB_TID);
 
 	f = ampdu->fifo_tb + prio2fifo[tid];
 
@@ -533,7 +523,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	ASSERT(scb->magic == SCB_MAGIC);
 
 	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
-	ASSERT(scb_ampdu);
 	ini = &scb_ampdu->ini[tid];
 
 	/* Let pressure continue to build ... */
@@ -586,7 +575,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		}
 
 		/* pkt is good to be aggregated */
-		ASSERT(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 		txh = (d11txh_t *) p->data;
 		plcp = (u8 *) (txh + 1);
 		h = (struct ieee80211_hdr *)(plcp + D11_PHY_HDR_LEN);
@@ -597,7 +585,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		mcl = le16_to_cpu(txh->MacTxControlLow);
 		mcl &= ~TXC_AMPDU_MASK;
 		fbr_iscck = !(le16_to_cpu(txh->XtraFrameTypes) & 0x3);
-		ASSERT(!fbr_iscck);
 		txh->PreloadSize = 0;	/* always default to 0 */
 
 		/*  Handle retry limits */
@@ -605,7 +592,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 			txrate[0].count++;
 			rr = true;
 			fbr = false;
-			ASSERT(!fbr);
 		} else {
 			fbr = true;
 			rr = false;
@@ -677,7 +663,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 			is40 = (plcp0 & MIMO_PLCP_40MHZ) ? 1 : 0;
 			sgi = PLCP3_ISSGI(plcp3) ? 1 : 0;
 			mcs = plcp0 & ~MIMO_PLCP_40MHZ;
-			ASSERT(mcs < MCS_TABLE_SIZE);
 			maxlen =
 			    min(scb_ampdu->max_rxlen,
 				ampdu->max_txlen[mcs][is40][sgi]);
@@ -751,7 +736,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 					p = NULL;
 					wiphy_err(wiphy, "%s: Bogus plen #1\n",
 						__func__);
-					ASSERT(3 == 4);
 					continue;
 				}
 
@@ -763,7 +747,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 					continue;
 				}
 				p = pktq_pdeq(&qi->q, prec);
-				ASSERT(p);
 			} else {
 				p = NULL;
 			}
@@ -894,8 +877,6 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 	struct ieee80211_tx_info *tx_info;
 
 	tx_info = IEEE80211_SKB_CB(p);
-	ASSERT(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
-	ASSERT(txs->status & TX_STATUS_AMPDU);
 
 	/* BMAC_NOTE: For the split driver, second level txstatus comes later
 	 * So if the ACK was received then wait for the second level else just
@@ -909,20 +890,15 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 			udelay(1);
 			status_delay++;
 			if (status_delay > 10) {
-				ASSERT(status_delay <= 10);
-				return;
+				return; /* error condition */
 			}
 		}
 
-		ASSERT(!(s1 & TX_STATUS_INTERMEDIATE));
-		ASSERT(s1 & TX_STATUS_AMPDU);
 		s2 = R_REG(&wlc->regs->frmtxstatus2);
 	}
 
 	if (likely(scb)) {
-		ASSERT(scb->magic == SCB_MAGIC);
 		scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
-		ASSERT(scb_ampdu);
 		ini = SCB_AMPDU_INI(scb_ampdu, p->priority);
 		ASSERT(ini->scb == scb);
 		wlc_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
@@ -935,14 +911,12 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 			tx_info = IEEE80211_SKB_CB(p);
 			txh = (d11txh_t *) p->data;
 			mcl = le16_to_cpu(txh->MacTxControlLow);
-			ASSERT(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 			pkt_buf_free_skb(p);
 			/* break out if last packet of ampdu */
 			if (((mcl & TXC_AMPDU_MASK) >> TXC_AMPDU_SHIFT) ==
 			    TXC_AMPDU_LAST)
 				break;
 			p = GETNEXTTXP(wlc, queue);
-			ASSERT(p != NULL);
 		}
 		wlc_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 	}
@@ -994,24 +968,14 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	memset(hole, 0, sizeof(hole));
 #endif
 
-	ASSERT(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
-	ASSERT(txs->status & TX_STATUS_AMPDU);
-
 	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
-	ASSERT(scb_ampdu);
-
 	tid = (u8) (p->priority);
 
 	ini = SCB_AMPDU_INI(scb_ampdu, tid);
 	retry_limit = ampdu->retry_limit_tid[tid];
 	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
-
-	ASSERT(ini->scb == scb);
-
 	memset(bitmap, 0, sizeof(bitmap));
 	queue = txs->frameid & TXFID_QUEUE_MASK;
-	ASSERT(queue < AC_COUNT);
-
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
 
 	if (txs->status & TX_STATUS_ACK_RCV) {
@@ -1092,7 +1056,6 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	/* loop through all pkts and retry if not acked */
 	while (p) {
 		tx_info = IEEE80211_SKB_CB(p);
-		ASSERT(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 		txh = (d11txh_t *) p->data;
 		mcl = le16_to_cpu(txh->MacTxControlLow);
 		plcp = (u8 *) (txh + 1);
@@ -1172,10 +1135,6 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			break;
 
 		p = GETNEXTTXP(wlc, queue);
-		if (p == NULL) {
-			ASSERT(p);
-			break;
-		}
 	}
 	wlc_send_q(wlc, wlc->active_queue);
 
@@ -1201,7 +1160,6 @@ ampdu_cleanup_tid_ini(struct ampdu_info *ampdu, scb_ampdu_t *scb_ampdu, u8 tid,
 		return;
 
 	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, ini->scb);
-	ASSERT(ini == &scb_ampdu->ini[ini->tid]);
 
 	/* free all buffered tx packets */
 	pktq_pflush(&scb_ampdu->txq, ini->tid, true, NULL, 0);
@@ -1214,11 +1172,6 @@ static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
 {
 	scb_ampdu_tid_ini_t *ini;
 
-	ASSERT(scb_ampdu);
-	ASSERT(scb_ampdu->scb);
-	ASSERT(SCB_AMPDU(scb_ampdu->scb));
-	ASSERT(tid < AMPDU_MAX_SCB_TID);
-
 	/* check for per-tid control of ampdu */
 	if (!ampdu->ini_enable[tid]) {
 		wiphy_err(ampdu->wlc->wiphy, "%s: Rejecting tid %d\n",
@@ -1295,12 +1248,7 @@ wlc_ampdu_null_delim_cnt(struct ampdu_info *ampdu, struct scb *scb,
 	int bytes, cnt, tmp;
 	u8 tx_density;
 
-	ASSERT(scb);
-	ASSERT(SCB_AMPDU(scb));
-
 	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
-	ASSERT(scb_ampdu);
-
 	if (scb_ampdu->mpdu_density == 0)
 		return 0;
 
@@ -1311,14 +1259,11 @@ wlc_ampdu_null_delim_cnt(struct ampdu_info *ampdu, struct scb *scb,
 	 */
 
 	tx_density = scb_ampdu->mpdu_density;
-
-	ASSERT(tx_density <= AMPDU_MAX_MPDU_DENSITY);
 	tmp = 1 << (17 - tx_density);
 	bytes = CEIL(RSPEC2RATE(rspec), tmp);
 
 	if (bytes > phylen) {
 		cnt = CEIL(bytes - phylen, AMPDU_DELIMITER_LEN);
-		ASSERT(cnt <= 255);
 		return (u8) cnt;
 	} else
 		return 0;
-- 
1.7.4.1


