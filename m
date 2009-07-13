Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51793 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbZGMHJT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 03:09:19 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 00:09:19 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/3] ath9k: Handle tx desc shortage more appropriately
Date: Mon, 13 Jul 2009 12:32:06 +0530
Message-ID: <1247468527-5097-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1247468527-5097-1-git-send-email-vasanth@atheros.com>
References: <1247468527-5097-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update tx BA window and complete the frame as failed
one if we can't clone the holding descriptor due to
unavailability of descriptors.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 45eac35..cbeff1a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -382,8 +382,23 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				struct ath_buf *tbf;
 
 				tbf = ath_clone_txbuf(sc, bf_last);
-				if (!tbf)
+				/*
+				 * Update tx baw and complete the frame with
+				 * failed status if we run out of tx buf
+				 */
+				if (!tbf) {
+					spin_lock_bh(&txq->axq_lock);
+					ath_tx_update_baw(sc, tid,
+							  bf->bf_seqno);
+					spin_unlock_bh(&txq->axq_lock);
+
+					bf->bf_state.bf_type |= BUF_XRETRY;
+					ath_tx_rc_status(bf, ds, nbad,
+							 0, false);
+					ath_tx_complete_buf(sc, bf, &bf_head,
+							    0, 0);
 					break;
+				}
 				ath9k_hw_cleartxdesc(sc->sc_ah, tbf->bf_desc);
 				list_add_tail(&tbf->list, &bf_head);
 			} else {
-- 
1.5.5.1

