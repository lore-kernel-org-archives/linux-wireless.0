Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55626 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaBVN4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 08:56:10 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath5k: set SURVEY_INFO_IN_USE on get_survey
Date: Sat, 22 Feb 2014 14:55:57 +0100
Message-Id: <1393077357-65471-1-git-send-email-nbd@openwrt.org> (sfid-20140222_145613_805059_DAD5B09C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only one channel is returned - the one currently being used.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 4ee01f6..afb23b3 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -681,6 +681,7 @@ ath5k_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
 	survey->channel = conf->chandef.chan;
 	survey->noise = ah->ah_noise_floor;
 	survey->filled = SURVEY_INFO_NOISE_DBM |
+			SURVEY_INFO_IN_USE |
 			SURVEY_INFO_CHANNEL_TIME |
 			SURVEY_INFO_CHANNEL_TIME_BUSY |
 			SURVEY_INFO_CHANNEL_TIME_RX |
-- 
1.8.3.4 (Apple Git-47)

