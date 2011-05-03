Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2400 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 30/61] staging: brcm80211: remove queue info parameter
 from wlc_send_q
Date: Tue, 3 May 2011 11:35:30 +0200
Message-ID: <1304415361-7813-31-git-send-email-arend@broadcom.com> (sfid-20110503_113835_691245_26405FC4)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is only one queue on which the wlc_send_q has to operate. This
queue is available under the struct wlc_info parameter passed so
the additional queue info parameter is redundant.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c  |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_main.c  |   11 ++++-------
 drivers/staging/brcm80211/brcmsmac/wlc_main.h  |    2 +-
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 1a3f2ea6..1d7d91b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -1133,7 +1133,7 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 
 		p = GETNEXTTXP(wlc, queue);
 	}
-	wlc_send_q(wlc, wlc->pkt_queue);
+	wlc_send_q(wlc);
 
 	/* update rate state */
 	antselid = wlc_antsel_antsel2id(wlc->asi, mimoantsel);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index bf87343..8dbf388 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -420,7 +420,7 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 
 	/* send any enq'd tx packets. Just makes sure to jump start tx */
 	if (!pktq_empty(&wlc->pkt_queue->q))
-		wlc_send_q(wlc, wlc->pkt_queue);
+		wlc_send_q(wlc);
 
 	/* it isn't done and needs to be resched if macintstatus is non-zero */
 	return wlc->macintstatus != 0;
@@ -3088,7 +3088,7 @@ wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 		morepending = true;
 
 	if (!pktq_empty(&wlc->pkt_queue->q))
-		wlc_send_q(wlc, wlc->pkt_queue);
+		wlc_send_q(wlc);
 
 	return morepending;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index adece8c..1f25fc3 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -4933,26 +4933,23 @@ wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 	    (wlc_d11hdrs_mac80211(wlc, hw, pkt, scb, 0, 1, fifo, 0, NULL, 0)))
 		return -EINVAL;
 	wlc_txq_enq(wlc, scb, pkt, WLC_PRIO_TO_PREC(prio));
-	wlc_send_q(wlc, wlc->pkt_queue);
+	wlc_send_q(wlc);
 
 	wlc->pub->_cnt->ieee_tx++;
 	return 0;
 }
 
-void BCMFASTPATH wlc_send_q(struct wlc_info *wlc, struct wlc_txq_info *qi)
+void BCMFASTPATH wlc_send_q(struct wlc_info *wlc)
 {
 	struct sk_buff *pkt[DOT11_MAXNUMFRAGS];
 	int prec;
 	u16 prec_map;
 	int err = 0, i, count;
 	uint fifo;
+	struct wlc_txq_info *qi = wlc->pkt_queue;
 	struct pktq *q = &qi->q;
 	struct ieee80211_tx_info *tx_info;
 
-	/* only do work for the packet queue */
-	if (qi != wlc->pkt_queue)
-		return;
-
 	if (in_send_q)
 		return;
 	else
@@ -6183,7 +6180,7 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 
 	/* send any enq'd tx packets. Just makes sure to jump start tx */
 	if (!pktq_empty(&wlc->pkt_queue->q))
-		wlc_send_q(wlc, wlc->pkt_queue);
+		wlc_send_q(wlc);
 }
 
 static void wlc_war16165(struct wlc_info *wlc, bool tx)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 0c185b5..4f0db6c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -856,7 +856,7 @@ extern void wlc_txflowcontrol_override(struct wlc_info *wlc,
 				       bool on, uint override);
 extern bool wlc_txflowcontrol_prio_isset(struct wlc_info *wlc,
 					 struct wlc_txq_info *qi, int prio);
-extern void wlc_send_q(struct wlc_info *wlc, struct wlc_txq_info *qi);
+extern void wlc_send_q(struct wlc_info *wlc);
 extern int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifo);
 
 extern u16 wlc_calc_lsig_len(struct wlc_info *wlc, ratespec_t ratespec,
-- 
1.7.4.1


