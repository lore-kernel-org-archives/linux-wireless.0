Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31844 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab2CNJKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 05:10:55 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20320.24700.538599.436565@gargle.gargle.HOWL> (sfid-20120314_101059_253677_A1A46C12)
Date: Wed, 14 Mar 2012 14:40:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/6] ath9k: Remove unnecessary initialization
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to mask out SWBA/BMISS from the
interrupt mask in start().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4a99010..db38a4e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1049,9 +1049,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	sc->sc_flags &= ~SC_OP_INVALID;
 	sc->sc_ah->is_monitoring = false;
 
-	/* Disable BMISS interrupt when we're not associated */
-	ah->imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
-
 	if (!ath_complete_reset(sc, false)) {
 		r = -EIO;
 		spin_unlock_bh(&sc->sc_pcu_lock);
-- 
1.7.9.4

