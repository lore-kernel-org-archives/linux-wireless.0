Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:45239 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbYB1W7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 17:59:05 -0500
Date: Thu, 28 Feb 2008 17:59:01 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	me@bobcopeland.com
Subject: [PATCH 4/8] ath5k: more RF2413 stuff
Message-ID: <19edc37dfc2a205270bd5a3039866b56813e85f0.1204236793.git.mcgrof@winlab.rutgers.edu> (sfid-20080228_225910_085474_9300F5F3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6d5bb6d43d1ddfb60d5ed8b8d6ee472643eafd8.1204236793.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add AR5K_RF2413 to radio check during hw_reset so it doesn't complain

 * Write ah_phy_spending value we set during attach instead of checking
each time for radio revision

 * Skip txpower setup for RF2413 because it can't transmit with it
(weird thing is that RF5413 has no problem with it).

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/hw.c  |    7 +++----
 drivers/net/wireless/ath5k/phy.c |    9 +++++++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 96b881d..6bbd732 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -640,7 +640,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	if (ah->ah_version != AR5K_AR5210) {
 		if (ah->ah_radio != AR5K_RF5111 &&
 			ah->ah_radio != AR5K_RF5112 &&
-			ah->ah_radio != AR5K_RF5413) {
+			ah->ah_radio != AR5K_RF5413 &&
+			ah->ah_radio != AR5K_RF2413) {
 			ATH5K_ERR(ah->ah_sc,
 				"invalid phy radio: %u\n", ah->ah_radio);
 			return -EINVAL;
@@ -1002,9 +1003,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		ath5k_hw_reg_write(ah, AR5K_PHY_SCAL_32MHZ, AR5K_PHY_SCAL);
 		ath5k_hw_reg_write(ah, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
 		ath5k_hw_reg_write(ah, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
-		ath5k_hw_reg_write(ah, ah->ah_radio == AR5K_RF5111 ?
-			AR5K_PHY_SPENDING_RF5111 : AR5K_PHY_SPENDING_RF5112,
-			AR5K_PHY_SPENDING);
+		ath5k_hw_reg_write(ah, ah->ah_phy_spending, AR5K_PHY_SPENDING);
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index f108b08..40efd4d 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -2178,6 +2178,15 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		return -EINVAL;
 	}
 
+	/*
+	 * RF2413 for some reason can't
+	 * transmit anything if we call
+	 * this funtion, so we skip it
+	 * until we fix txpower.
+	 */
+	if (ah->ah_radio == AR5K_RF2413)
+		return 0;
+
 	/* Reset TX power values */
 	memset(&ah->ah_txpower, 0, sizeof(ah->ah_txpower));
 	ah->ah_txpower.txp_tpc = tpc;
-- 
1.5.3.7

