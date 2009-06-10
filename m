Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28523 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918AbZFJM0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 08:26:22 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 05:26:25 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/3] ath9k: Remove unnecessary count for addba attempt
Date: Wed, 10 Jun 2009 17:50:08 +0530
Message-ID: <1244636409-9946-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1244636409-9946-2-git-send-email-vasanth@atheros.com>
References: <1244636409-9946-1-git-send-email-vasanth@atheros.com>
 <1244636409-9946-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 already has one to keep track of number of failure
addba attempts.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/xmit.c  |   13 +------------
 2 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ca14642..968bf20 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -276,7 +276,6 @@ struct ath_atx_tid {
 	int sched;
 	int paused;
 	u8 state;
-	int addba_exchangeattempts;
 };
 
 struct ath_atx_ac {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 687e475..e074e6f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -395,7 +395,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	if (tid->state & AGGR_CLEANUP) {
 		if (tid->baw_head == tid->baw_tail) {
 			tid->state &= ~AGGR_ADDBA_COMPLETE;
-			tid->addba_exchangeattempts = 0;
 			tid->state &= ~AGGR_CLEANUP;
 
 			/* send buffered frames as singles */
@@ -700,7 +699,6 @@ int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 
 	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
 		txtid->state &= ~AGGR_ADDBA_PROGRESS;
-		txtid->addba_exchangeattempts = 0;
 		return 0;
 	}
 
@@ -728,7 +726,6 @@ int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 		txtid->state |= AGGR_CLEANUP;
 	} else {
 		txtid->state &= ~AGGR_ADDBA_COMPLETE;
-		txtid->addba_exchangeattempts = 0;
 		ath_tx_flush_tid(sc, txtid);
 	}
 
@@ -761,14 +758,8 @@ bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno)
 
 	txtid = ATH_AN_2_TID(an, tidno);
 
-	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
-		if (!(txtid->state & AGGR_ADDBA_PROGRESS) &&
-		    (txtid->addba_exchangeattempts < ADDBA_EXCHANGE_ATTEMPTS)) {
-			txtid->addba_exchangeattempts++;
+	if (!(txtid->state & (AGGR_ADDBA_COMPLETE | AGGR_ADDBA_PROGRESS)))
 			return true;
-		}
-	}
-
 	return false;
 }
 
@@ -2103,7 +2094,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->ac = &an->ac[acno];
 		tid->state &= ~AGGR_ADDBA_COMPLETE;
 		tid->state &= ~AGGR_ADDBA_PROGRESS;
-		tid->addba_exchangeattempts = 0;
 	}
 
 	for (acno = 0, ac = &an->ac[acno];
@@ -2160,7 +2150,6 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 					tid->sched = false;
 					ath_tid_drain(sc, txq, tid);
 					tid->state &= ~AGGR_ADDBA_COMPLETE;
-					tid->addba_exchangeattempts = 0;
 					tid->state &= ~AGGR_CLEANUP;
 				}
 			}
-- 
1.5.5.1

