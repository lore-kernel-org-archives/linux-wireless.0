Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53702 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388146AbeGWRFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 13:05:13 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 8/9] ath9k_hw: fix channel maximum power level test
Date: Mon, 23 Jul 2018 18:02:59 +0200
Message-Id: <20180723160300.58024-8-nbd@nbd.name> (sfid-20180723_180324_368897_DE815911)
In-Reply-To: <20180723160300.58024-1-nbd@nbd.name>
References: <20180723160300.58024-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tx power applied by set_txpower is limited by the CTL (conformance
test limit) entries in the EEPROM. These can change based on the user
configured regulatory domain.
Depending on the EEPROM data this can cause the tx power to become too
limited, if the original regdomain CTLs impose lower limits than the CTLs
of the user configured regdomain.

To fix this issue, set the initial channel limits without any CTL
restrictions and only apply the CTL at run time when setting the channel
and the real tx power.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/hw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1665066f4e24..9dc866404eca 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2942,16 +2942,19 @@ void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan,
 	struct ath_regulatory *reg = ath9k_hw_regulatory(ah);
 	struct ieee80211_channel *channel;
 	int chan_pwr, new_pwr;
+	u16 ctl = NO_CTL;
 
 	if (!chan)
 		return;
 
+	if (!test)
+		ctl = ath9k_regd_get_ctl(reg, chan);
+
 	channel = chan->chan;
 	chan_pwr = min_t(int, channel->max_power * 2, MAX_RATE_POWER);
 	new_pwr = min_t(int, chan_pwr, reg->power_limit);
 
-	ah->eep_ops->set_txpower(ah, chan,
-				 ath9k_regd_get_ctl(reg, chan),
+	ah->eep_ops->set_txpower(ah, chan, ctl,
 				 get_antenna_gain(ah, chan), new_pwr, test);
 }
 
-- 
2.17.0
