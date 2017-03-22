Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42744 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965959AbdCVTmo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 15:42:44 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, stable@vger.kernel.org
Subject: [PATCH] ath9k_hw: fix channel maximum power level test
Date: Wed, 22 Mar 2017 20:42:40 +0100
Message-Id: <20170322194240.1488-1-nbd@nbd.name> (sfid-20170322_204537_936305_FFC691A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tx power applied by set_txpower is limited by the CTL (conformance
test limit) entries in the EEPROM. These can change based on the user
configured regulatory domain.
Depending on the EEPROM data this can cause the tx power to become too
limited, if the original regdomain CTLs impose lowr limits than the CTLs
of the user configured regdomain.

To fix this issue, set the initial channel limits without any CTL
restrictions and only apply the CTL at run time when setting the channel
and the real tx power.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 17ca60482b5f..3346cbf63b9c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2937,10 +2937,14 @@ void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan,
 	struct ieee80211_channel *channel;
 	int chan_pwr, new_pwr, max_gain;
 	int ant_gain, ant_reduction = 0;
+	u16 ctl = NO_CTL;
 
 	if (!chan)
 		return;
 
+	if (!test)
+		ctl = ath9k_regd_get_ctl(reg, chan);
+
 	channel = chan->chan;
 	chan_pwr = min_t(int, channel->max_power * 2, MAX_RATE_POWER);
 	new_pwr = min_t(int, chan_pwr, reg->power_limit);
@@ -2950,9 +2954,7 @@ void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (ant_gain > max_gain)
 		ant_reduction = ant_gain - max_gain;
 
-	ah->eep_ops->set_txpower(ah, chan,
-				 ath9k_regd_get_ctl(reg, chan),
-				 ant_reduction, new_pwr, test);
+	ah->eep_ops->set_txpower(ah, chan, ctl, ant_reduction, new_pwr, test);
 }
 
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test)
-- 
2.11.0
