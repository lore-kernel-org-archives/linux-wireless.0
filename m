Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab2JELqB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 07:46:01 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5/7] rt2800: pass channel pointer to rt2800_config_txpower
Date: Fri,  5 Oct 2012 13:44:13 +0200
Message-Id: <1349437455-18754-5-git-send-email-sgruszka@redhat.com> (sfid-20121005_134605_870322_CF51B77B)
In-Reply-To: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for use regulatory max channel power in TX power delta
calculations.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e0e641d..9c2c647 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2566,13 +2566,14 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 }
 
 static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
-				  enum ieee80211_band band,
+				  struct ieee80211_channel *chan,
 				  int power_level)
 {
 	u8 txpower, r1;
 	u16 eeprom;
 	u32 reg, offset;
 	int i, is_rate_b, delta, power_ctrl;
+	enum ieee80211_band band = chan->band;
 
 	/*
 	 * Calculate HT40 compensation delta
@@ -2720,7 +2721,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 
 void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev)
 {
-	rt2800_config_txpower(rt2x00dev, rt2x00dev->curr_band,
+	rt2800_config_txpower(rt2x00dev, rt2x00dev->hw->conf.channel,
 			      rt2x00dev->tx_power);
 }
 EXPORT_SYMBOL_GPL(rt2800_gain_calibration);
@@ -2855,11 +2856,11 @@ void rt2800_config(struct rt2x00_dev *rt2x00dev,
 	if (flags & IEEE80211_CONF_CHANGE_CHANNEL) {
 		rt2800_config_channel(rt2x00dev, libconf->conf,
 				      &libconf->rf, &libconf->channel);
-		rt2800_config_txpower(rt2x00dev, libconf->conf->channel->band,
+		rt2800_config_txpower(rt2x00dev, libconf->conf->channel,
 				      libconf->conf->power_level);
 	}
 	if (flags & IEEE80211_CONF_CHANGE_POWER)
-		rt2800_config_txpower(rt2x00dev, libconf->conf->channel->band,
+		rt2800_config_txpower(rt2x00dev, libconf->conf->channel,
 				      libconf->conf->power_level);
 	if (flags & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		rt2800_config_retry_limit(rt2x00dev, libconf);
-- 
1.7.1

