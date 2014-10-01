Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34276 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaJAKIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 06:08:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [RFC 4/5] ath9k: Fix queue handling for channel contexts
Date: Wed,  1 Oct 2014 15:38:32 +0530
Message-Id: <1412158113-22913-5-git-send-email-sujith@msujith.org> (sfid-20141001_120807_418238_6B3A9BDB)
In-Reply-To: <1412158113-22913-1-git-send-email-sujith@msujith.org>
References: <1412158113-22913-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When a full chip reset is done, all the queues
across all VIFs are stopped, but if MCC is enabled,
only the queues of the current context is awakened,
when we complete the reset.

This results in unfairness for the inactive context.
Since frames are queued internally in the driver if
there is a context mismatch, we can awaken all the
queues when coming out of a reset.

The VIF-specific queues are still used in flow control,
to ensure fairness when traffic is high.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f0035a9..2051624 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -264,12 +264,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 
 	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
-
-	if (!ath9k_is_chanctx_enabled())
-		ieee80211_wake_queues(sc->hw);
-	else
-		ath9k_chanctx_wake_queues(sc, sc->cur_chan);
-
+	ieee80211_wake_queues(sc->hw);
 	ath9k_p2p_ps_timer(sc);
 
 	return true;
-- 
2.1.1

