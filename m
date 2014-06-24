Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63062 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaFXLhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 07:37:16 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 4/5] ath9k_hw: fix tx gain table index for AR953x
Date: Tue, 24 Jun 2014 17:07:48 +0530
Message-ID: <1403609869-12901-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140624_133720_321701_AF947918)
In-Reply-To: <1403609869-12901-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1403609869-12901-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix tx gain table index on fast channel change for AR953x.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 8927fc3..1ef17e1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1552,12 +1552,15 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 				      u8 *ini_reloaded)
 {
 	unsigned int regWrites = 0;
-	u32 modesIndex;
+	u32 modesIndex, txgain_index = 0;
 
-	if (IS_CHAN_5GHZ(chan))
+	if (IS_CHAN_5GHZ(chan)) {
 		modesIndex = IS_CHAN_HT40(chan) ? 2 : 1;
-	else
+	} else {
+		if (AR_SREV_9531(ah))
+			txgain_index = 1;
 		modesIndex = IS_CHAN_HT40(chan) ? 3 : 4;
+	}
 
 	if (modesIndex == ah->modes_index) {
 		*ini_reloaded = false;
@@ -1573,7 +1576,10 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 		ar9003_hw_prog_ini(ah, &ah->ini_radio_post_sys2ant,
 				   modesIndex);
 
-	REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
+	if (AR_SREV_9531(ah))
+		REG_WRITE_ARRAY(&ah->iniModesTxGain, txgain_index, regWrites);
+	else
+		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
 
 	if (AR_SREV_9462_20_OR_LATER(ah)) {
 		/*
-- 
2.0.0

