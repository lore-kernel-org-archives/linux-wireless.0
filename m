Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:45126
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab2LGKCt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 05:02:49 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 6/8] ath9k_hw: Fix PAPRD retraining for AR9485
Date: Fri,  7 Dec 2012 15:31:59 +0530
Message-Id: <1354874521-4138-7-git-send-email-sujith@msujith.org> (sfid-20121207_110253_688056_9C809D15)
In-Reply-To: <1354874521-4138-1-git-send-email-sujith@msujith.org>
References: <1354874521-4138-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Retraining of PAPRD based on agc2_pwr is required for
chips other than AR9485.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index cd8727b..3eca9bd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -965,9 +965,13 @@ EXPORT_SYMBOL(ar9003_paprd_init_table);
 bool ar9003_paprd_is_done(struct ath_hw *ah)
 {
 	int paprd_done, agc2_pwr;
+
 	paprd_done = REG_READ_FIELD(ah, AR_PHY_PAPRD_TRAINER_STAT1,
 				AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_TRAIN_DONE);
 
+	if (AR_SREV_9485(ah))
+		goto exit;
+
 	if (paprd_done == 0x1) {
 		agc2_pwr = REG_READ_FIELD(ah, AR_PHY_PAPRD_TRAINER_STAT1,
 				AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_AGC2_PWR);
@@ -983,7 +987,7 @@ bool ar9003_paprd_is_done(struct ath_hw *ah)
 		if (agc2_pwr <= PAPRD_IDEAL_AGC2_PWR_RANGE)
 			paprd_done = 0;
 	}
-
+exit:
 	return !!paprd_done;
 }
 EXPORT_SYMBOL(ar9003_paprd_is_done);
-- 
1.8.0.1

