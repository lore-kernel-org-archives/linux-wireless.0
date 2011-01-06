Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42013 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1AFAP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 19:15:56 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 4/5] ath9k:  Ensure xmit makes progress.
Date: Wed,  5 Jan 2011 16:15:18 -0800
Message-Id: <1294272919-7068-4-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294272919-7068-1-git-send-email-greearb@candelatech.com>
References: <1294272919-7068-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If the txq->axq_q is empty, the code was breaking out
of the tx_processq logic without checking to see if it should
transmit other queued AMPDU frames (txq->axq_acq).

This patches ensures ath_txq_schedule is called.

This needs review.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c769037... 2248e47... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/xmit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c769037..2248e47 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1999,6 +1999,8 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		spin_lock_bh(&txq->axq_lock);
 		if (list_empty(&txq->axq_q)) {
 			txq->axq_link = NULL;
+			if (sc->sc_flags & SC_OP_TXAGGR)
+				ath_txq_schedule(sc, txq);
 			spin_unlock_bh(&txq->axq_lock);
 			break;
 		}
-- 
1.7.2.3

