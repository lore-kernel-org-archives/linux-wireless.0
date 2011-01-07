Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47304 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1AGAqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 19:46:22 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/3] ath9k:  Re-start xmit logic in xmit watchdog timer.
Date: Thu,  6 Jan 2011 16:46:04 -0800
Message-Id: <1294361165-15308-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

We should not get to this state, but we do.  What is
worse, many times the xmit logic still will not start,
probably due to tids being paused when they shouldn't be.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  This needs review.  It might be too much of a hack
for upstream code, and at best it works around a small part
of the problem.

:100644 100644 3aae523... 547fb44... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/xmit.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3aae523..547fb44 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2110,6 +2110,27 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 				} else {
 					txq->axq_tx_inprogress = true;
 				}
+			} else {
+				/* If the queue has pending buffers, then it
+				 * should be doing tx work (and have axq_depth).
+				 * Shouldn't get to this state I think..but
+				 * perhaps we do.
+				 */
+				if (!list_empty(&txq->axq_acq)) {
+					ath_err(ath9k_hw_common(sc->sc_ah),
+						"txq: %p axq_qnum: %i,"
+						" axq_link: %p"
+						" pending frames: %i"
+						" axq_acq is not empty, but"
+						" axq_depth is zero.  Calling"
+						" ath_txq_schedule to restart"
+						" tx logic.\n",
+						txq, txq->axq_qnum,
+						txq->axq_link,
+						txq->pending_frames);
+					ATH_DBG_WARN_ON_ONCE(1);
+					ath_txq_schedule(sc, txq);
+				}
 			}
 			spin_unlock_bh(&txq->axq_lock);
 		}
-- 
1.7.2.3

