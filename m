Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1665 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1ECJgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 07/61] staging: brcm80211: replaced WL_ERROR in
 wlc_ampdu.c
Date: Tue, 3 May 2011 11:35:07 +0200
Message-ID: <1304415361-7813-8-git-send-email-arend@broadcom.com> (sfid-20110503_113806_559313_0D41950C)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replaced proprietary function by wiphy_err().

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |   57 ++++++++++++++----------
 1 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index b5172e2..be12748 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -169,8 +169,8 @@ struct ampdu_info *wlc_ampdu_attach(struct wlc_info *wlc)
 
 	ampdu = kzalloc(sizeof(struct ampdu_info), GFP_ATOMIC);
 	if (!ampdu) {
-		WL_ERROR("wl%d: wlc_ampdu_attach: out of mem\n",
-			 wlc->pub->unit);
+		wiphy_err(wlc->wiphy, "wl%d: wlc_ampdu_attach: out of mem\n",
+			  wlc->pub->unit);
 		return NULL;
 	}
 	ampdu->wlc = wlc;
@@ -516,8 +516,10 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	bool fbr_iscck;
 	struct ieee80211_tx_info *tx_info;
 	u16 qlen;
+	struct wiphy *wiphy;
 
 	wlc = ampdu->wlc;
+	wiphy = wlc->wiphy;
 	p = *pdu;
 
 	ASSERT(p);
@@ -543,7 +545,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	wlc_ampdu_agg(ampdu, scb, p, tid);
 
 	if (wlc->block_datafifo) {
-		WL_ERROR("%s: Fifo blocked\n", __func__);
+		wiphy_err(wiphy, "%s: Fifo blocked\n", __func__);
 		return -BCME_BUSY;
 	}
 	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
@@ -558,24 +560,25 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 			err = wlc_prep_pdu(wlc, p, &fifo);
 		} else {
-			WL_ERROR("%s: AMPDU flag is off!\n", __func__);
+			wiphy_err(wiphy, "%s: AMPDU flag is off!\n", __func__);
 			*pdu = NULL;
 			err = 0;
 			break;
 		}
 
 		if (err) {
-			if (err == -BCME_BUSY) {
-				WL_ERROR("wl%d: wlc_sendampdu: prep_xdu retry; seq 0x%x\n",
-					 wlc->pub->unit, seq);
+			if (err == BCME_BUSY) {
+				wiphy_err(wiphy, "wl%d: wlc_sendampdu: "
+					  "prep_xdu retry; seq 0x%x\n",
+					  wlc->pub->unit, seq);
 				WLCNTINCR(ampdu->cnt->sduretry);
 				*pdu = p;
 				break;
 			}
 
 			/* error in the packet; reject it */
-			WL_AMPDU_ERR("wl%d: wlc_sendampdu: prep_xdu rejected; seq 0x%x\n",
-				     wlc->pub->unit, seq);
+			wiphy_err(wiphy, "wl%d: wlc_sendampdu: prep_xdu "
+				  "rejected; seq 0x%x\n", wlc->pub->unit, seq);
 			WLCNTINCR(ampdu->cnt->sdurejected);
 
 			*pdu = NULL;
@@ -746,16 +749,16 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 
 				if ((plen + ampdu_len) > maxlen) {
 					p = NULL;
-					WL_ERROR("%s: Bogus plen #1\n",
-						 __func__);
+					wiphy_err(wiphy, "%s: Bogus plen #1\n",
+						__func__);
 					ASSERT(3 == 4);
 					continue;
 				}
 
 				/* check if there are enough descriptors available */
 				if (TXAVAIL(wlc, fifo) <= (seg_cnt + 1)) {
-					WL_ERROR("%s: No fifo space   !!!!!!\n",
-						 __func__);
+					wiphy_err(wiphy, "%s: No fifo space  "
+						  "!!\n", __func__);
 					p = NULL;
 					continue;
 				}
@@ -868,8 +871,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		/* inform rate_sel if it this is a rate probe pkt */
 		frameid = le16_to_cpu(txh->TxFrameID);
 		if (frameid & TXFID_RATE_PROBE_MASK) {
-			WL_ERROR("%s: XXX what to do with TXFID_RATE_PROBE_MASK!?\n",
-				 __func__);
+			wiphy_err(wiphy, "%s: XXX what to do with "
+				  "TXFID_RATE_PROBE_MASK!?\n", __func__);
 		}
 		for (i = 0; i < count; i++)
 			wlc_txfifo(wlc, fifo, pkt[i], i == (count - 1),
@@ -984,6 +987,7 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	u8 antselid = 0;
 	u8 retry_limit, rr_retry_limit;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(p);
+	struct wiphy *wiphy = wlc->wiphy;
 
 #ifdef BCMDBG
 	u8 hole[AMPDU_MAX_MPDU];
@@ -1041,12 +1045,14 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		if (supr_status) {
 			update_rate = false;
 			if (supr_status == TX_STATUS_SUPR_BADCH) {
-				WL_ERROR("%s: Pkt tx suppressed, illegal channel possibly %d\n",
-					 __func__,
-					 CHSPEC_CHANNEL(wlc->default_bss->chanspec));
+				wiphy_err(wiphy, "%s: Pkt tx suppressed, "
+					  "illegal channel possibly %d\n",
+					  __func__, CHSPEC_CHANNEL(
+					  wlc->default_bss->chanspec));
 			} else {
 				if (supr_status != TX_STATUS_SUPR_FRAG)
-					WL_ERROR("%s: wlc_ampdu_dotxstatus: supr_status 0x%x\n",
+					wiphy_err(wiphy, "%s: wlc_ampdu_dotx"
+						  "status:supr_status 0x%x\n",
 						 __func__, supr_status);
 			}
 			/* no need to retry for badch; will fail again */
@@ -1071,8 +1077,9 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		} else if (txs->phyerr) {
 			update_rate = false;
 			wlc->pub->_cnt->txphyerr++;
-			WL_ERROR("wl%d: wlc_ampdu_dotxstatus: tx phy error (0x%x)\n",
-				 wlc->pub->unit, txs->phyerr);
+			wiphy_err(wiphy, "wl%d: wlc_ampdu_dotxstatus: tx phy "
+				  "error (0x%x)\n", wlc->pub->unit,
+				  txs->phyerr);
 
 			if (WL_ERROR_ON()) {
 				prpkt("txpkt (AMPDU)", p);
@@ -1150,8 +1157,9 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				    IEEE80211_TX_STAT_AMPDU_NO_BACK;
 				skb_pull(p, D11_PHY_HDR_LEN);
 				skb_pull(p, D11_TXH_LEN);
-				WL_ERROR("%s: BA Timeout, seq %d, in_transit %d\n",
-					 SHORTNAME, seq, ini->tx_in_transit);
+				wiphy_err(wiphy, "%s: BA Timeout, seq %d, in_"
+					"transit %d\n", SHORTNAME, seq,
+					ini->tx_in_transit);
 				ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw,
 							    p);
 			}
@@ -1213,7 +1221,8 @@ static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
 
 	/* check for per-tid control of ampdu */
 	if (!ampdu->ini_enable[tid]) {
-		WL_ERROR("%s: Rejecting tid %d\n", __func__, tid);
+		wiphy_err(ampdu->wlc->wiphy, "%s: Rejecting tid %d\n",
+			  __func__, tid);
 		return NULL;
 	}
 
-- 
1.7.4.1


