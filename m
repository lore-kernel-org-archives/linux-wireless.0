Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:39532 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750760Ab0JEE1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 00:27:18 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-043882836
	for <linux-wireless@vger.kernel.org>; Tue,  5 Oct 2010 13:27:17 +0900 (JST)
Subject: [PATCH] ath5k: Don't wake internal queues
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: greearb@candelatech.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Date: Tue, 05 Oct 2010 13:27:17 +0900
Message-ID: <20101005042717.9652.86752.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should only wake up queues which mac80211 knows about (queues 0-3). We have
another internal queue ("CAB", queue number 6) which we use for power-saved
frames. When transmitted frames are processed from this queue, we have to make
sure we don't bother mac80211 with waking a queue it doesn't know about.

this fixes:

WARNING: at /home/br1/ath/wireless-testing/net/mac80211/util.c:275
  __ieee80211_wake_queue+0xd6/0xe0 [mac80211]()

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 94cc335..c158f2e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1642,7 +1642,7 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		}
 	}
 	spin_unlock(&txq->lock);
-	if (txq->txq_len < ATH5K_TXQ_LEN_LOW)
+	if (txq->txq_len < ATH5K_TXQ_LEN_LOW && txq->qnum < 4)
 		ieee80211_wake_queue(sc->hw, txq->qnum);
 }
 

