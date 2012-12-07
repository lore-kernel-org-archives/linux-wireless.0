Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:33912
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab2LGKCr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 05:02:47 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 5/8] ath9k_hw: Various trivial fixes for PAPRD
Date: Fri,  7 Dec 2012 15:31:58 +0530
Message-Id: <1354874521-4138-6-git-send-email-sujith@msujith.org> (sfid-20121207_110252_961023_547F6939)
In-Reply-To: <1354874521-4138-1-git-send-email-sujith@msujith.org>
References: <1354874521-4138-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

* Remove unneeded memset.

  All the values in the PAPRD gain table are filled, so there
  is no need to zero out the arrays.

* Use GFP_KERNEL in ar9003_paprd_create_curve

  This is called from the PAPRD work, so the atomic variant
  is not needed.

* Change return type of ar9003_paprd_setup_gain_table

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c | 9 ++-------
 drivers/net/wireless/ath/ath9k/hw.h           | 2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index b11a166..cd8727b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -287,9 +287,6 @@ static void ar9003_paprd_get_gain_table(struct ath_hw *ah)
 	u32 reg = AR_PHY_TXGAIN_TABLE;
 	int i;
 
-	memset(entry, 0, sizeof(ah->paprd_gain_table_entries));
-	memset(index, 0, sizeof(ah->paprd_gain_table_index));
-
 	for (i = 0; i < PAPRD_GAIN_TABLE_ENTRIES; i++) {
 		entry[i] = REG_READ(ah, reg);
 		index[i] = (entry[i] >> 24) & 0xff;
@@ -788,7 +785,7 @@ void ar9003_paprd_populate_single_table(struct ath_hw *ah,
 }
 EXPORT_SYMBOL(ar9003_paprd_populate_single_table);
 
-int ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain)
+void ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain)
 {
 	unsigned int i, desired_gain, gain_index;
 	unsigned int train_power = ah->paprd_training_power;
@@ -806,8 +803,6 @@ int ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain)
 
 	REG_CLR_BIT(ah, AR_PHY_PAPRD_TRAINER_STAT1,
 			AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_TRAIN_DONE);
-
-	return 0;
 }
 EXPORT_SYMBOL(ar9003_paprd_setup_gain_table);
 
@@ -919,7 +914,7 @@ int ar9003_paprd_create_curve(struct ath_hw *ah,
 
 	memset(caldata->pa_table[chain], 0, sizeof(caldata->pa_table[chain]));
 
-	buf = kmalloc(2 * 48 * sizeof(u32), GFP_ATOMIC);
+	buf = kmalloc(2 * 48 * sizeof(u32), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3636dab..fe87d0e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1058,7 +1058,7 @@ void ar9003_paprd_populate_single_table(struct ath_hw *ah,
 					int chain);
 int ar9003_paprd_create_curve(struct ath_hw *ah,
 			      struct ath9k_hw_cal_data *caldata, int chain);
-int ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain);
+void ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain);
 int ar9003_paprd_init_table(struct ath_hw *ah);
 bool ar9003_paprd_is_done(struct ath_hw *ah);
 
-- 
1.8.0.1

