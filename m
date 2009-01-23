Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11195 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbZAWJNP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 04:13:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 01:13:15 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/2] ath9k: Remove unused ath9k_hw_select_antconfig() from hw.c
Date: Fri, 23 Jan 2009 14:40:36 +0530
Message-ID: <1232701837-25673-1-git-send-email-vasanth@atheros.com> (sfid-20090123_101323_503813_E704FA3C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath9k/hw.c    |   21 ---------------------
 2 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 5fcea58..f5d6131 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -893,7 +893,6 @@ void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val);
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 void ath9k_enable_rfkill(struct ath_hal *ah);
 #endif
-int ath9k_hw_select_antconfig(struct ath_hal *ah, u32 cfg);
 u32 ath9k_hw_getdefantenna(struct ath_hal *ah);
 void ath9k_hw_setantenna(struct ath_hal *ah, u32 antenna);
 bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index fae3be6..3c879ac 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -3588,27 +3588,6 @@ void ath9k_enable_rfkill(struct ath_hal *ah)
 }
 #endif
 
-int ath9k_hw_select_antconfig(struct ath_hal *ah, u32 cfg)
-{
-	struct ath9k_channel *chan = ah->ah_curchan;
-	const struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
-	u16 ant_config;
-	u32 halNumAntConfig;
-
-	halNumAntConfig = IS_CHAN_2GHZ(chan) ?
-		pCap->num_antcfg_2ghz : pCap->num_antcfg_5ghz;
-
-	if (cfg < halNumAntConfig) {
-		if (!ath9k_hw_get_eeprom_antenna_cfg(ah, chan,
-						     cfg, &ant_config)) {
-			REG_WRITE(ah, AR_PHY_SWITCH_COM, ant_config);
-			return 0;
-		}
-	}
-
-	return -EINVAL;
-}
-
 u32 ath9k_hw_getdefantenna(struct ath_hal *ah)
 {
 	return REG_READ(ah, AR_DEF_ANTENNA) & 0x7;
-- 
1.5.5.1

