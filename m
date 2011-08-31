Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37846 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab1HaVvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 17:51:11 -0400
Received: by qyk15 with SMTP id 15so2762085qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:51:10 -0700 (PDT)
From: Bill Jordan <bjordan@rajant.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, linville@tuxdriver.com
Cc: Bill Jordan <bjordan@rajant.com>
Subject: [PATCH] ath9k: ath9k_hw_set_txpowerlimit sets previous txpower
Date: Wed, 31 Aug 2011 17:51:00 -0400
Message-Id: <1314827460-17724-1-git-send-email-bjordan@rajant.com> (sfid-20110831_235114_774536_1E786783)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 9c204b46c7af93e334114bea1f5eeaa6fea9ba07
(ath9k_hw: do not limit initial tx power to 20 dbm),
setting of txpower was broken.

This patch fixes it by initializing reg_pwr from the new
power limit, not the previous value.

Signed-off-by: Bill Jordan <bjordan@rajant.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3a16ba2..fae1f30 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2447,13 +2447,13 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test)
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath9k_channel *chan = ah->curchan;
 	struct ieee80211_channel *channel = chan->chan;
-	int reg_pwr = min_t(int, MAX_RATE_POWER, regulatory->power_limit);
+	int reg_pwr = min_t(int, MAX_RATE_POWER, limit);
 	int chan_pwr = channel->max_power * 2;
 
 	if (test)
 		reg_pwr = chan_pwr = MAX_RATE_POWER;
 
-	regulatory->power_limit = min(limit, (u32) MAX_RATE_POWER);
+	regulatory->power_limit = reg_pwr;
 
 	ah->eep_ops->set_txpower(ah, chan,
 				 ath9k_regd_get_ctl(regulatory, chan),
-- 
1.7.6

