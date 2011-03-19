Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52447 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab1CSMzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 08:55:49 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 7/7] ath9k: remove the pending frames ath_txq_schedule workaround
Date: Sat, 19 Mar 2011 13:55:43 +0100
Message-Id: <1300539343-75509-7-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300539343-75509-6-git-send-email-nbd@openwrt.org>
References: <1300539343-75509-1-git-send-email-nbd@openwrt.org>
 <1300539343-75509-2-git-send-email-nbd@openwrt.org>
 <1300539343-75509-3-git-send-email-nbd@openwrt.org>
 <1300539343-75509-4-git-send-email-nbd@openwrt.org>
 <1300539343-75509-5-git-send-email-nbd@openwrt.org>
 <1300539343-75509-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This workaround called ath_txq_schedule whenever there were still pending
frames for a queue, but the queue depth was zero. Because of its its high
false positive probability (e.g. with paused TIDs) and because it is in
the way of other pending work (AP powersave fixes), it is better to remove
this code entirely.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ef22096..65f1217 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2144,33 +2144,6 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 				} else {
 					txq->axq_tx_inprogress = true;
 				}
-			} else {
-				/* If the queue has pending buffers, then it
-				 * should be doing tx work (and have axq_depth).
-				 * Shouldn't get to this state I think..but
-				 * we do.
-				 */
-				if (!(sc->sc_flags & (SC_OP_OFFCHANNEL)) &&
-				    (txq->pending_frames > 0 ||
-				     !list_empty(&txq->axq_acq) ||
-				     txq->stopped)) {
-					ath_err(ath9k_hw_common(sc->sc_ah),
-						"txq: %p axq_qnum: %u,"
-						" mac80211_qnum: %i"
-						" axq_link: %p"
-						" pending frames: %i"
-						" axq_acq empty: %i"
-						" stopped: %i"
-						" axq_depth: 0  Attempting to"
-						" restart tx logic.\n",
-						txq, txq->axq_qnum,
-						txq->mac80211_qnum,
-						txq->axq_link,
-						txq->pending_frames,
-						list_empty(&txq->axq_acq),
-						txq->stopped);
-					ath_txq_schedule(sc, txq);
-				}
 			}
 			spin_unlock_bh(&txq->axq_lock);
 		}
-- 
1.7.3.2

