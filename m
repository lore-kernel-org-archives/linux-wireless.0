Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:50047 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaJCDQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 23:16:56 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: Fix crash in MCC mode
Date: Fri,  3 Oct 2014 08:47:34 +0530
Message-Id: <1412306254-30086-1-git-send-email-sujith@msujith.org> (sfid-20141003_051659_912792_AF3D497C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When a channel context is removed, the hw_queue_base
is set to -1, this will result in a panic because
ath9k_chanctx_stop_queues() can be called on an interface
that is not assigned to any context yet - for example,
when trying to scan.

Fix this issue by setting the hw_queue_base to zero
when a channel context is removed.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
It would be nice to get this merged for 3.18.

 drivers/net/wireless/ath/ath9k/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2051624..6f6a974 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2332,7 +2332,7 @@ static void ath9k_remove_chanctx(struct ieee80211_hw *hw,
 		conf->def.chan->center_freq);
 
 	ctx->assigned = false;
-	ctx->hw_queue_base = -1;
+	ctx->hw_queue_base = 0;
 	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_UNASSIGN);
 
 	mutex_unlock(&sc->mutex);
-- 
2.1.2

