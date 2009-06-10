Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28522 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbZFJM0U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 08:26:20 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 05:26:23 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/3] ath9k: Nuke unneccesary helper function to see if aggr is active
Date: Wed, 10 Jun 2009 17:50:07 +0530
Message-ID: <1244636409-9946-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1244636409-9946-1-git-send-email-vasanth@atheros.com>
References: <1244636409-9946-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE80211_TX_CTL_AMPDU in tx control flags should be enough
to confirm BA is negotiated for that tid.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b61a071..687e475 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -73,18 +73,6 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds,
 /* Aggregation logic */
 /*********************/
 
-static int ath_aggr_query(struct ath_softc *sc, struct ath_node *an, u8 tidno)
-{
-	struct ath_atx_tid *tid;
-	tid = ATH_AN_2_TID(an, tidno);
-
-	if (tid->state & AGGR_ADDBA_COMPLETE ||
-	    tid->state & AGGR_ADDBA_PROGRESS)
-		return 1;
-	else
-		return 0;
-}
-
 static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 {
 	struct ath_atx_ac *ac = tid->ac;
@@ -1629,7 +1617,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			goto tx_done;
 		}
 
-		if (ath_aggr_query(sc, an, bf->bf_tidno)) {
+		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 			/*
 			 * Try aggregation if it's a unicast data frame
 			 * and the destination is HT capable.
-- 
1.5.5.1

