Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58444 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbcDLRjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 13:39:08 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, lkml2017@openmailbox.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k: ar5008_hw_cmn_spur_mitigate: add missing mask_m & mask_p initialisation
Date: Tue, 12 Apr 2016 19:37:44 +0200
Message-Id: <1460482664-21086-1-git-send-email-linux@rempel-privat.de> (sfid-20160412_193913_210834_9C35DDF9)
In-Reply-To: <120e427452ad7e93f17828e8bba4b043@openmailbox.org>
References: <120e427452ad7e93f17828e8bba4b043@openmailbox.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

by moving common code to ar5008_hw_cmn_spur_mitigate i forgot to move
mask_m & mask_p initialisation. This coused a performance regression
on ar9281.

Fixes: f911085ffa88 ("ath9k: split ar5008_hw_spur_mitigate and reuse common code in ar9002_hw_spur_mitigate.")
Reported-by: Gustav Frederiksen <lkml2017@openmailbox.org>
Tested-by: Gustav Frederiksen <lkml2017@openmailbox.org>
Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 8 +++-----
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 5 -----
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 8f87930..1b271b9 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -274,6 +274,9 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,
 	};
 	static const int inc[4] = { 0, 100, 0, 0 };
 
+	memset(&mask_m, 0, sizeof(int8_t) * 123);
+	memset(&mask_p, 0, sizeof(int8_t) * 123);
+
 	cur_bin = -6000;
 	upper = bin + 100;
 	lower = bin - 100;
@@ -424,14 +427,9 @@ static void ar5008_hw_spur_mitigate(struct ath_hw *ah,
 	int tmp, new;
 	int i;
 
-	int8_t mask_m[123];
-	int8_t mask_p[123];
 	int cur_bb_spur;
 	bool is2GHz = IS_CHAN_2GHZ(chan);
 
-	memset(&mask_m, 0, sizeof(int8_t) * 123);
-	memset(&mask_p, 0, sizeof(int8_t) * 123);
-
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
 		if (AR_NO_SPUR == cur_bb_spur)
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index db66245..53d7445 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -178,14 +178,9 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
 	int i;
 	struct chan_centers centers;
 
-	int8_t mask_m[123];
-	int8_t mask_p[123];
 	int cur_bb_spur;
 	bool is2GHz = IS_CHAN_2GHZ(chan);
 
-	memset(&mask_m, 0, sizeof(int8_t) * 123);
-	memset(&mask_p, 0, sizeof(int8_t) * 123);
-
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	freq = centers.synth_center;
 
-- 
2.5.0

