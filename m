Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47299 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaIKVu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 17:50:58 -0400
Received: by mail-wi0-f174.google.com with SMTP id n3so1736110wiv.7
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 14:50:56 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: fix radar parameters initialization
Date: Thu, 11 Sep 2014 23:50:54 +0200
Message-Id: <1410472254-15600-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140911_235101_743365_8470CE24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move ath9k_hw_set_radar_params() in ath9k_hw_reset() in order to avoid
AR_PHY_RADAR registers are overwritten after hw reset

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 2 --
 drivers/net/wireless/ath/ath9k/hw.c      | 5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index a1b3282..d2a0f12 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -83,8 +83,6 @@ static int ath_set_channel(struct ath_softc *sc)
 	if (hw->conf.radar_enabled) {
 		u32 rxfilter;
 
-		/* set HW specific DFS configuration */
-		ath9k_hw_set_radar_params(ah);
 		rxfilter = ath9k_hw_getrxfilter(ah);
 		rxfilter |= ATH9K_RX_FILTER_PHYRADAR |
 				ATH9K_RX_FILTER_PHYERR;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 69bbea1..ef5f5a6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1954,6 +1954,11 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (AR_SREV_9565(ah) && common->bt_ant_diversity)
 		REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV, AR_BTCOEX_WL_LNADIV_FORCE_ON);
 
+	if (ah->hw->conf.radar_enabled) {
+		/* set HW specific DFS configuration */
+		ath9k_hw_set_radar_params(ah);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(ath9k_hw_reset);
-- 
1.9.1

