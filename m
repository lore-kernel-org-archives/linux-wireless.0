Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38107 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbaFXQ5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 12:57:03 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 4/5] ath9k_hw: fix tx gain table index for AR953x
Date: Tue, 24 Jun 2014 22:27:39 +0530
Message-ID: <1403629060-14245-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140624_185718_842463_3BF0EF2C)
In-Reply-To: <1403629060-14245-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1403629060-14245-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix tx gain table index on fast channel change for AR953x.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 8927fc3..542a8d5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1552,13 +1552,15 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 				      u8 *ini_reloaded)
 {
 	unsigned int regWrites = 0;
-	u32 modesIndex;
+	u32 modesIndex, txgain_index;
 
 	if (IS_CHAN_5GHZ(chan))
 		modesIndex = IS_CHAN_HT40(chan) ? 2 : 1;
 	else
 		modesIndex = IS_CHAN_HT40(chan) ? 3 : 4;
 
+	txgain_index = AR_SREV_9531(ah) ? 1 : modesIndex;
+
 	if (modesIndex == ah->modes_index) {
 		*ini_reloaded = false;
 		goto set_rfmode;
@@ -1573,7 +1575,7 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 		ar9003_hw_prog_ini(ah, &ah->ini_radio_post_sys2ant,
 				   modesIndex);
 
-	REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
+	REG_WRITE_ARRAY(&ah->iniModesTxGain, txgain_index, regWrites);
 
 	if (AR_SREV_9462_20_OR_LATER(ah)) {
 		/*
-- 
2.0.0

