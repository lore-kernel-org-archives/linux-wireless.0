Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51821 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2FOUDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 16:03:41 -0400
Received: by yenl2 with SMTP id l2so2235112yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 13:03:40 -0700 (PDT)
Date: Fri, 15 Jun 2012 16:03:29 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, mickflemm@gmail.com,
	linville@tuxdriver.com
Cc: johannes.berg@intel.com
Subject: [PATCH] ath5k: remove _bh from inner locks
Message-ID: <20120615200329.GA19999@localhost> (sfid-20120615_220418_079389_DA7537E0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

spin_unlock_bh(&txq->lock) already disables softirqs so we don't want
to do it here.  Fixes smatch warnings:

   drivers/net/wireless/ath/ath5k/base.c:1048 ath5k_drain_tx_buffs() error: double lock 'bottom_half:'
   drivers/net/wireless/ath/ath5k/base.c:1056 ath5k_drain_tx_buffs() error: double unlock 'bottom_half:'

Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index fbaa309..44ad6fe 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1045,11 +1045,11 @@ ath5k_drain_tx_buffs(struct ath5k_hw *ah)
 
 				ath5k_txbuf_free_skb(ah, bf);
 
-				spin_lock_bh(&ah->txbuflock);
+				spin_lock(&ah->txbuflock);
 				list_move_tail(&bf->list, &ah->txbuf);
 				ah->txbuf_len++;
 				txq->txq_len--;
-				spin_unlock_bh(&ah->txbuflock);
+				spin_unlock(&ah->txbuflock);
 			}
 			txq->link = NULL;
 			txq->txq_poll_mark = false;
-- 
1.7.2.5

-- 
Bob Copeland %% www.bobcopeland.com
