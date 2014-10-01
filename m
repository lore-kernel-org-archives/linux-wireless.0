Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34144 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaJAKHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 06:07:53 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [RFC 1/5] ath9k: Fix queue handling in flush()
Date: Wed,  1 Oct 2014 15:38:29 +0530
Message-Id: <1412158113-22913-2-git-send-email-sujith@msujith.org> (sfid-20141001_120756_355696_EDDCFA33)
In-Reply-To: <1412158113-22913-1-git-send-email-sujith@msujith.org>
References: <1412158113-22913-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When draining of the TX queues fails, a
full HW reset is done. ath_reset() makes sure
that the queues in mac80211 are restarted,
so there is no need to wake them up again.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 65ca7ac..5f908a0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1999,7 +1999,6 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int timeout = HZ / 5; /* 200 ms */
 	bool drain_txq;
-	int i;
 
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 
@@ -2027,10 +2026,6 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 			ath_reset(sc);
 
 		ath9k_ps_restore(sc);
-		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-			ieee80211_wake_queue(sc->hw,
-					     sc->cur_chan->hw_queue_base + i);
-		}
 	}
 
 	ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
-- 
2.1.1

