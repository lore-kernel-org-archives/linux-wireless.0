Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FCFC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDFC62184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="d5gP9wZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfCTKhi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:37:38 -0400
Received: from narfation.org ([79.140.41.39]:34086 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfCTKhi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:37:38 -0400
Received: from sven-desktop.home.narfation.org (unknown [IPv6:2001:16b8:5523:5cf2:11e7:332b:14eb:c67a])
        by v3-1039.vlinux.de (Postfix) with ESMTPSA id 801FD1100E9;
        Wed, 20 Mar 2019 11:37:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=narfation.org;
        s=20121; t=1553078256;
        bh=+uR4AhtXnnJTSfnZbm9a8xyvhzmZZDjy6VQugo88pWw=;
        h=From:To:Cc:Subject:Date:From;
        b=d5gP9wZQnHfYZJEwEABcUeKxgpA8XCzzgkQkZLr+l+ElYC/4pw1xw1w4HPIgIOIc/
         A/uPcjHsyzrR5no7ceI8Uk974hTDQDCImurh8eF8H2LXd99wxQwFXqQOsHRReIM3kz
         G3mE/V3ZqS/OCrBlsOIFgCIgrziwZifMng93//Cs=
From:   Sven Eckelmann <sven@narfation.org>
To:     linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH] ath9k: Differentiate between max combined and per chain power
Date:   Wed, 20 Mar 2019 11:37:23 +0100
Message-Id: <20190320103723.27228-1-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The ath9k driver uses as maximum allowed txpower the constant
MAX_RATE_POWER. It is used to set a maximum txpower limit for the PHY
(which is combined txpower) and also the maximum txpower for per chain
rates. Its value 63 is derived from the maximum number the registers can
store for the per chain txpower.

The max txpower a user can set because of this is 31 dBm (floor(63 / 2)).
This also means that a device with multiple tx chains is even limited
further:

* 1 chain:  31 dBm per chain
* 2 chains: 28 dBm per chain
* 3 chains: 26 dBm per chain

This combined txpower limit of 31 dBm becomes even more problematic when
some extra antenna gain is set in the EEPROM. A high power device is then
no longer able to reach its potential limits.

Instead the code dealing with the combined txpower must use a higher limit
than 63 and only the code dealing with the per chain txpower have to use
the limit of 63. Since the antenna gain can be quite large and 8 bit
variables are often used in ath9k for txpower, a large, divisible by two
number like 254 is a good choice for this new limit.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.c    | 2 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c | 1 +
 drivers/net/wireless/ath/ath9k/hw.c        | 8 ++++----
 drivers/net/wireless/ath/ath9k/hw.h        | 1 +
 drivers/net/wireless/ath/ath9k/init.c      | 2 +-
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 6fbd5559c0c0..c22d457dbc54 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -428,7 +428,7 @@ u16 ath9k_hw_get_scaled_power(struct ath_hw *ah, u16 power_limit,
 	else
 		power_limit = 0;
 
-	return power_limit;
+	return min_t(u16, power_limit, MAX_RATE_POWER);
 }
 
 void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index b8c0a08066a0..e8c2cc03be0c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -424,6 +424,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	scaledPower = powerLimit - antenna_reduction;
+	scaledPower = min_t(u16, scaledPower, MAX_RATE_POWER);
 	numCtlModes = ARRAY_SIZE(ctlModesFor11g) - SUB_NUM_CTL_MODES_AT_2G_40;
 	pCtlMode = ctlModesFor11g;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8581d917635a..f47322869bc3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -446,7 +446,7 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 
 	regulatory->country_code = CTRY_DEFAULT;
-	regulatory->power_limit = MAX_RATE_POWER;
+	regulatory->power_limit = MAX_COMBINED_POWER;
 
 	ah->hw_version.magic = AR5416_MAGIC;
 	ah->hw_version.subvendorid = 0;
@@ -2952,7 +2952,7 @@ void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan,
 		ctl = ath9k_regd_get_ctl(reg, chan);
 
 	channel = chan->chan;
-	chan_pwr = min_t(int, channel->max_power * 2, MAX_RATE_POWER);
+	chan_pwr = min_t(int, channel->max_power * 2, MAX_COMBINED_POWER);
 	new_pwr = min_t(int, chan_pwr, reg->power_limit);
 
 	ah->eep_ops->set_txpower(ah, chan, ctl,
@@ -2965,9 +2965,9 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test)
 	struct ath9k_channel *chan = ah->curchan;
 	struct ieee80211_channel *channel = chan->chan;
 
-	reg->power_limit = min_t(u32, limit, MAX_RATE_POWER);
+	reg->power_limit = min_t(u32, limit, MAX_COMBINED_POWER);
 	if (test)
-		channel->max_power = MAX_RATE_POWER / 2;
+		channel->max_power = MAX_COMBINED_POWER / 2;
 
 	ath9k_hw_apply_txpower(ah, chan, test);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 68956cdc8c9a..2e4489700a85 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -173,6 +173,7 @@
 #define ATH9K_NUM_QUEUES            10
 
 #define MAX_RATE_POWER              63
+#define MAX_COMBINED_POWER          254 /* 128 dBm, chosen to fit in u8 */
 #define AH_WAIT_TIMEOUT             100000 /* (us) */
 #define AH_TSF_WRITE_TIMEOUT        100    /* (us) */
 #define AH_TIME_QUANTUM             10
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 98141b699c88..043801f773b5 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -805,7 +805,7 @@ static void ath9k_init_band_txpower(struct ath_softc *sc, int band)
 		ah->curchan = &ah->channels[chan->hw_value];
 		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
 		ath9k_cmn_get_channel(sc->hw, ah, &chandef);
-		ath9k_hw_set_txpowerlimit(ah, MAX_RATE_POWER, true);
+		ath9k_hw_set_txpowerlimit(ah, MAX_COMBINED_POWER, true);
 	}
 }
 
-- 
2.20.1

