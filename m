Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59170 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab3EGXgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 19:36:00 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] ath9k: Do not use local_bh_disable in ampdu_action
Date: Wed,  8 May 2013 05:03:32 +0530
Message-Id: <1367969613-1867-3-git-send-email-sujith@msujith.org> (sfid-20130508_013605_226831_9E5EC61B)
In-Reply-To: <1367969613-1867-1-git-send-email-sujith@msujith.org>
References: <1367969613-1867-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This was added during the early conversion of ampdu_action
to a sleeping callback. There is no need to do this - instead,
use the normal mutex that is acquired for all callbacks.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 74a0482..a1630d1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1688,7 +1688,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;
 
-	local_bh_disable();
+	mutex_lock(&sc->mutex);
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
@@ -1719,7 +1719,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 		ath_err(ath9k_hw_common(sc->sc_ah), "Unknown AMPDU action\n");
 	}
 
-	local_bh_enable();
+	mutex_unlock(&sc->mutex);
 
 	return ret;
 }
-- 
1.8.2.2

