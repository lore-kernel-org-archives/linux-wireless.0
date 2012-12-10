Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:54299
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2LJBxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 20:53:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] ath9k_hw: Fix PAPRD retraining for AR9485
Date: Mon, 10 Dec 2012 07:22:36 +0530
Message-Id: <1355104358-30062-6-git-send-email-sujith@msujith.org> (sfid-20121210_025334_360301_BB650DEB)
In-Reply-To: <1355104358-30062-1-git-send-email-sujith@msujith.org>
References: <1355104358-30062-1-git-send-email-sujith@msujith.org>
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
index b28565e..fb3a87e 100644
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

