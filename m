Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44050 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdFVBZH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 21:25:07 -0400
From: miaoqing@codeaurora.org
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        sssa@qti.qualcomm.com, giulio.genovese@gmail.com,
        Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 3/3] ath9k: Use mutex_lock to avoid potential race in start/stop rng
Date: Thu, 22 Jun 2017 09:24:29 +0800
Message-Id: <1498094669-6510-3-git-send-email-miaoqing@codeaurora.org> (sfid-20170622_032510_851174_C4612DDA)
In-Reply-To: <1498094669-6510-1-git-send-email-miaoqing@codeaurora.org>
References: <1498094669-6510-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Move ath9k_rng_stop/ath9k_rng_start pair into critical section,
use mutex_lock to void potential race accessing.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9e65d14..8b4ac7f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -731,12 +731,12 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
+	ath9k_rng_start(sc);
+
 	mutex_unlock(&sc->mutex);
 
 	ath9k_ps_restore(sc);
 
-	ath9k_rng_start(sc);
-
 	return 0;
 }
 
@@ -826,10 +826,10 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	ath9k_deinit_channel_context(sc);
 
-	ath9k_rng_stop(sc);
-
 	mutex_lock(&sc->mutex);
 
+	ath9k_rng_stop(sc);
+
 	ath_cancel_work(sc);
 
 	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
-- 
1.9.1
