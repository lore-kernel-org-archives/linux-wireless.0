Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2908 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1IAJRh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:37 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 27/30] staging: brcm80211: macro cleanup in softmac
 ampdu.c
Date: Thu, 1 Sep 2011 11:17:17 +0200
Message-ID: <1314868640-9425-28-git-send-email-rvossen@broadcom.com> (sfid-20110901_111836_424187_5E7AE591)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moved, deleted or substituted macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c |   29 ++++++++-------------------
 1 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 318235d..341768d 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -60,8 +60,6 @@
 					 * accumulate between resets.
 					 */
 
-#define SHORTNAME "AMPDU status"
-
 #define TX_SEQ_TO_INDEX(seq) ((seq) % AMPDU_TX_BA_MAX_WSIZE)
 
 /* max possible overhead per mpdu in the ampdu; 3 is for roundup if needed */
@@ -144,14 +142,6 @@ struct cb_del_ampdu_pars {
 	u16 tid;
 };
 
-#define AMPDU_CLEANUPFLAG_RX   (0x1)
-#define AMPDU_CLEANUPFLAG_TX   (0x2)
-
-#define SCB_AMPDU_CUBBY(ampdu, scb) (&(scb->scb_ampdu))
-#define SCB_AMPDU_INI(scb_ampdu, tid) (&(scb_ampdu->ini[tid]))
-
-#define brcms_c_ampdu_txflowcontrol(a, b, c)	do {} while (0)
-
 static void brcms_c_scb_ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur)
 {
 	u32 rate, mcs;
@@ -288,7 +278,7 @@ void brcms_c_ampdu_detach(struct ampdu_info *ampdu)
 static void brcms_c_scb_ampdu_update_config(struct ampdu_info *ampdu,
 					    struct scb *scb)
 {
-	struct scb_ampdu *scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
+	struct scb_ampdu *scb_ampdu = &scb->scb_ampdu;
 	int i;
 
 	scb_ampdu->max_pdu = (u8) ampdu->wlc->pub->tunables->ampdunummpdu;
@@ -486,7 +476,7 @@ brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 	struct scb_ampdu_tid_ini *ini;
 	struct ampdu_info *ampdu = wlc->ampdu;
 	struct scb *scb = wlc->pub->global_scb;
-	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
+	scb_ampdu = &scb->scb_ampdu;
 
 	if (!ampdu->ini_enable[tid]) {
 		wiphy_err(ampdu->wlc->wiphy, "%s: Rejecting tid %d\n",
@@ -494,7 +484,7 @@ brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 		return;
 	}
 
-	ini = SCB_AMPDU_INI(scb_ampdu, tid);
+	ini = &scb_ampdu->ini[tid];
 	ini->tid = tid;
 	ini->scb = scb_ampdu->scb;
 	ini->ba_wsize = ba_wsize;
@@ -546,7 +536,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 	f = ampdu->fifo_tb + prio2fifo[tid];
 
 	scb = wlc->pub->global_scb;
-	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
+	scb_ampdu = &scb->scb_ampdu;
 	ini = &scb_ampdu->ini[tid];
 
 	/* Let pressure continue to build ... */
@@ -925,10 +915,10 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	memset(hole, 0, sizeof(hole));
 #endif
 
-	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
+	scb_ampdu = &scb->scb_ampdu;
 	tid = (u8) (p->priority);
 
-	ini = SCB_AMPDU_INI(scb_ampdu, tid);
+	ini = &scb_ampdu->ini[tid];
 	retry_limit = ampdu->retry_limit_tid[tid];
 	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
 	memset(bitmap, 0, sizeof(bitmap));
@@ -1080,7 +1070,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				skb_pull(p, D11_PHY_HDR_LEN);
 				skb_pull(p, D11_TXH_LEN);
 				wiphy_err(wiphy, "%s: BA Timeout, seq %d, in_"
-					"transit %d\n", SHORTNAME, seq,
+					"transit %d\n", "AMPDU status", seq,
 					ini->tx_in_transit);
 				ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw,
 							    p);
@@ -1134,8 +1124,8 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 	}
 
 	if (likely(scb)) {
-		scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
-		ini = SCB_AMPDU_INI(scb_ampdu, p->priority);
+		scb_ampdu = &scb->scb_ampdu;
+		ini = &scb_ampdu->ini[p->priority];
 		brcms_c_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
 	} else {
 		/* loop through all pkts and free */
@@ -1155,7 +1145,6 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		}
 		brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 	}
-	brcms_c_ampdu_txflowcontrol(wlc, scb_ampdu, ini);
 }
 
 void brcms_c_ampdu_macaddr_upd(struct brcms_c_info *wlc)
-- 
1.7.4.1


