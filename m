Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36951 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab1G0NBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 09:01:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/4] ath9k_hw: do not limit initial tx power to 20 dbm
Date: Wed, 27 Jul 2011 15:01:05 +0200
Message-Id: <1311771665-59853-4-git-send-email-nbd@openwrt.org> (sfid-20110727_150120_267025_27A5C25D)
In-Reply-To: <1311771665-59853-3-git-send-email-nbd@openwrt.org>
References: <1311771665-59853-1-git-send-email-nbd@openwrt.org>
 <1311771665-59853-2-git-send-email-nbd@openwrt.org>
 <1311771665-59853-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When testing for tx power, bypass the default limits.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8006ce0..a2e5763 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2432,15 +2432,18 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test)
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath9k_channel *chan = ah->curchan;
 	struct ieee80211_channel *channel = chan->chan;
+	int reg_pwr = min_t(int, MAX_RATE_POWER, regulatory->power_limit);
+	int chan_pwr = channel->max_power * 2;
+
+	if (test)
+		reg_pwr = chan_pwr = MAX_RATE_POWER;
 
 	regulatory->power_limit = min(limit, (u32) MAX_RATE_POWER);
 
 	ah->eep_ops->set_txpower(ah, chan,
 				 ath9k_regd_get_ctl(regulatory, chan),
 				 channel->max_antenna_gain * 2,
-				 channel->max_power * 2,
-				 min((u32) MAX_RATE_POWER,
-				 (u32) regulatory->power_limit), test);
+				 chan_pwr, reg_pwr, test);
 }
 EXPORT_SYMBOL(ath9k_hw_set_txpowerlimit);
 
-- 
1.7.3.2

