Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46172 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3GPGgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 02:36:48 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] ath9k: Program correct initvals for FCC
Date: Tue, 16 Jul 2013 12:03:21 +0530
Message-Id: <1373956402-22169-5-git-send-email-sujith@msujith.org> (sfid-20130716_083653_015996_BE94F518)
In-Reply-To: <1373956402-22169-1-git-send-email-sujith@msujith.org>
References: <1373956402-22169-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

* CUS217 specific initvals have to be programmed.
* iniAdditional is not used for AR9462/AR9565, remove it.
* Handle channel 2484 for regulatory compliance.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 57e345a..2db4ddf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1517,6 +1517,18 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 
 	REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
 
+	if (AR_SREV_9462_20_OR_LATER(ah)) {
+		/*
+		 * CUS217 mix LNA mode.
+		 */
+		if (ar9003_hw_get_rx_gain_idx(ah) == 2) {
+			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_bb_core,
+					1, regWrites);
+			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_bb_postamble,
+					modesIndex, regWrites);
+		}
+	}
+
 	/*
 	 * For 5GHz channels requiring Fast Clock, apply
 	 * different modal values.
@@ -1527,7 +1539,11 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 	if (AR_SREV_9565(ah))
 		REG_WRITE_ARRAY(&ah->iniModesFastClock, 1, regWrites);
 
-	REG_WRITE_ARRAY(&ah->iniAdditional, 1, regWrites);
+	/*
+	 * JAPAN regulatory.
+	 */
+	if (chan->channel == 2484)
+		ar9003_hw_prog_ini(ah, &ah->iniCckfirJapan2484, 1);
 
 	ah->modes_index = modesIndex;
 	*ini_reloaded = true;
-- 
1.8.3.2

