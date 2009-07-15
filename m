Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbZGOARP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:17:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 5/9] ath9k: Handle tx desc shortage more appropriately
Date: Tue, 14 Jul 2009 20:17:11 -0400
Message-Id: <1247617035-15402-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
References: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Update tx BA window and complete the frame as failed
one if we can't clone the holding descriptor due to
unavailability of descriptors.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 24663ce..4ff155e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -382,8 +382,24 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
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
+
 				ath9k_hw_cleartxdesc(sc->sc_ah, tbf->bf_desc);
 				list_add_tail(&tbf->list, &bf_head);
 			} else {
-- 
1.6.0.6

