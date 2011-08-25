Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59275 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1HYBel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:34:41 -0400
Received: by yie30 with SMTP id 30so1341655yie.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:34:41 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	me@bobcopeland.com, Javier Cardona <javier@cozybit.com>
Subject: [PATCH] ath5k: Invoke irqsafe version of ieee80211_tx_status() to avoid deadlock
Date: Wed, 24 Aug 2011 18:34:24 -0700
Message-Id: <1314236064-6339-1-git-send-email-thomas@cozybit.com> (sfid-20110825_033444_439163_B9A65422)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

This driver reports transmission status to the upper layer
(ath5k_tx_frame_completed()) while holding the lock on the transmission
queue (txq->lock).  Under failure conditions, the mesh stack will
attempt to send PERR messages to the previous sender of the failed
frame.  When that happens the driver will attempt to re-acquire the
txq->lock lock causing a deadlock.  There are two possible fixes for
this, (1) we could defer the transmission of the PERR frame until the
lock is released or (2) release the lock before invoking
ieee80211_tx_status().  The ath9k driver implements the second approach
(see ath_tx_complete() in ath9k/xmit.c) as well as the rt2x00 and b43
drivers.  The iwl driver, on the other hand, avoids this problem by
invoking  ieee80211_tx_status_irqsafe() which effectively defers
processing of transmission feedback status.  This last approach is the
least intrusive is implemented here.

Reported by Pedro Larbig (ASPj)
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index e9ea38d..9b488f9 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1630,7 +1630,7 @@ ath5k_tx_frame_completed(struct ath5k_hw *ah, struct sk_buff *skb,
 		ah->stats.antenna_tx[0]++; /* invalid */
 
 	trace_ath5k_tx_complete(ah, skb, txq, ts);
-	ieee80211_tx_status(ah->hw, skb);
+	ieee80211_tx_status_irqsafe(ah->hw, skb);
 }
 
 static void
-- 
1.7.4.1

