Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38986 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaIPOnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2014 10:43:46 -0400
Received: by mail-wi0-f169.google.com with SMTP id cc10so4065623wib.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2014 07:43:44 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: enable ext channel pulse detection
Date: Tue, 16 Sep 2014 16:43:42 +0200
Message-Id: <1410878622-2864-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_164349_316511_C383FF9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable pulse detection on extension channel if 40MHz channel width has been set

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ef5f5a6..6bbc2be 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1956,6 +1956,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	if (ah->hw->conf.radar_enabled) {
 		/* set HW specific DFS configuration */
+		ah->radar_conf.ext_channel = IS_CHAN_HT40(chan);
 		ath9k_hw_set_radar_params(ah);
 	}
 
-- 
1.9.1

