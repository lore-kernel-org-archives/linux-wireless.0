Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:19152 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbcCaQNx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 12:13:53 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: interpret requested txpower in EIRP domain
Date: Thu, 31 Mar 2016 18:07:10 +0200
Message-Id: <1459440430-7676-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20160331_181357_052328_F50B62D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx power limitations at upper layers are interpreted in
the EIRP domain. When the user requests a given maximum
txpower, e.g. with: 'iw phy0 set txpower fixed 1500',
he expects the EIRP to be at or below 15dBm.

In ath9k_hw_apply_txpower(), the interpretation is
different: the antenna-gain is capped against the
current txpower limit in the regulatory, but not
against the user set value. It ensures that the
resulting EIRP is below the limit defined by the
active countrycode, but not below the value the
user requested.

In a scenario like e.g.
 a) antenna_gain=6
 b) countrycode limits to eirp=18
 c) user set txpower=15
this will cause a setting for AR_PHY_POWER_TX_RATE
regs resulting in an EIRP > 15.

This patch ensures that antenna-gain is considered
whenever the txpower limit is adjusted and with that
the user set limits are kept.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e7a3101..30be8a5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2834,7 +2834,6 @@ void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan,
 	struct ath_regulatory *reg = ath9k_hw_regulatory(ah);
 	struct ieee80211_channel *channel;
 	int chan_pwr, new_pwr, max_gain;
-	int ant_gain, ant_reduction = 0;
 
 	if (!chan)
 		return;
@@ -2842,15 +2841,10 @@ void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan,
 	channel = chan->chan;
 	chan_pwr = min_t(int, channel->max_power * 2, MAX_RATE_POWER);
 	new_pwr = min_t(int, chan_pwr, reg->power_limit);
-	max_gain = chan_pwr - new_pwr + channel->max_antenna_gain * 2;
-
-	ant_gain = get_antenna_gain(ah, chan);
-	if (ant_gain > max_gain)
-		ant_reduction = ant_gain - max_gain;
 
 	ah->eep_ops->set_txpower(ah, chan,
 				 ath9k_regd_get_ctl(reg, chan),
-				 ant_reduction, new_pwr, test);
+				 get_antenna_gain(ah, chan), new_pwr, test);
 }
 
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test)
-- 
2.7.4

