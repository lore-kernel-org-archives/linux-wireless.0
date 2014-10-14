Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44686 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaJNUVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 16:21:04 -0400
Received: by mail-wi0-f170.google.com with SMTP id hi2so12624186wib.3
        for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2014 13:21:02 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: do not overwrite AR_PHY_RADAR_1 MSB
Date: Tue, 14 Oct 2014 22:21:00 +0200
Message-Id: <1413318060-11563-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141014_222108_055093_2987CA58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not overwrite AR_PHY_RADAR_1 most significant byte default value

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 5 ++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index b72d0be..ba3d788 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1190,7 +1190,7 @@ static void ar5008_hw_set_nf_limits(struct ath_hw *ah)
 static void ar5008_hw_set_radar_params(struct ath_hw *ah,
 				       struct ath_hw_radar_conf *conf)
 {
-	u32 radar_0 = 0, radar_1 = 0;
+	u32 radar_0 = 0, radar_1;
 
 	if (!conf) {
 		REG_CLR_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_ENA);
@@ -1204,6 +1204,9 @@ static void ar5008_hw_set_radar_params(struct ath_hw *ah,
 	radar_0 |= SM(conf->pulse_rssi, AR_PHY_RADAR_0_PRSSI);
 	radar_0 |= SM(conf->pulse_inband, AR_PHY_RADAR_0_INBAND);
 
+	radar_1 = REG_READ(ah, AR_PHY_RADAR_1);
+	radar_1 &= ~(AR_PHY_RADAR_1_MAXLEN | AR_PHY_RADAR_1_RELSTEP_THRESH |
+		     AR_PHY_RADAR_1_RELPWR_THRESH);
 	radar_1 |= AR_PHY_RADAR_1_MAX_RRSSI;
 	radar_1 |= AR_PHY_RADAR_1_BLOCK_CHECK;
 	radar_1 |= SM(conf->pulse_maxlen, AR_PHY_RADAR_1_MAXLEN);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 697c4ae..30b2f95 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1348,7 +1348,7 @@ static void ar9003_hw_set_radar_params(struct ath_hw *ah,
 				       struct ath_hw_radar_conf *conf)
 {
 	unsigned int regWrites = 0;
-	u32 radar_0 = 0, radar_1 = 0;
+	u32 radar_0 = 0, radar_1;
 
 	if (!conf) {
 		REG_CLR_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_ENA);
@@ -1362,6 +1362,9 @@ static void ar9003_hw_set_radar_params(struct ath_hw *ah,
 	radar_0 |= SM(conf->pulse_rssi, AR_PHY_RADAR_0_PRSSI);
 	radar_0 |= SM(conf->pulse_inband, AR_PHY_RADAR_0_INBAND);
 
+	radar_1 = REG_READ(ah, AR_PHY_RADAR_1);
+	radar_1 &= ~(AR_PHY_RADAR_1_MAXLEN | AR_PHY_RADAR_1_RELSTEP_THRESH |
+		     AR_PHY_RADAR_1_RELPWR_THRESH);
 	radar_1 |= AR_PHY_RADAR_1_MAX_RRSSI;
 	radar_1 |= AR_PHY_RADAR_1_BLOCK_CHECK;
 	radar_1 |= SM(conf->pulse_maxlen, AR_PHY_RADAR_1_MAXLEN);
-- 
1.9.1

