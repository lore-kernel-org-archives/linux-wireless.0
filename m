Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35870 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab1GIENS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 00:13:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 5/9] ath9k_hw: initialize more timing related registers for half/quarter channels
Date: Sat,  9 Jul 2011 11:12:50 +0700
Message-Id: <1310184774-32913-5-git-send-email-nbd@openwrt.org> (sfid-20110709_061327_395690_D3D4CEE6)
In-Reply-To: <1310184774-32913-4-git-send-email-nbd@openwrt.org>
References: <1310184774-32913-1-git-send-email-nbd@openwrt.org>
 <1310184774-32913-2-git-send-email-nbd@openwrt.org>
 <1310184774-32913-3-git-send-email-nbd@openwrt.org>
 <1310184774-32913-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize the the clock-to-TSF field of AR_USEC and the SIFS and EIFS time
registers based on the clock rate instead of relying on initvals.
With those changes, some of the hardcoded AR9287 1.3+ specific overrides
can be dropped.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   67 ++++++++++++++++++++++++++++++----
 1 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d4084d8..279d73a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -905,6 +905,13 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 	}
 }
 
+static void ath9k_hw_set_sifs_time(struct ath_hw *ah, u32 us)
+{
+	u32 val = ath9k_hw_mac_to_clks(ah, us - 2);
+	val = min(val, (u32) 0xFFFF);
+	REG_WRITE(ah, AR_D_GBL_IFS_SIFS, val);
+}
+
 static void ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
 {
 	u32 val = ath9k_hw_mac_to_clks(ah, us);
@@ -942,25 +949,60 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 
 void ath9k_hw_init_global_settings(struct ath_hw *ah)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_conf *conf = &common->hw->conf;
+	const struct ath9k_channel *chan = ah->curchan;
 	int acktimeout;
 	int slottime;
 	int sifstime;
+	int rx_lat = 0, tx_lat = 0, eifs = 0;
+	u32 reg;
 
 	ath_dbg(ath9k_hw_common(ah), ATH_DBG_RESET, "ah->misc_mode 0x%x\n",
 		ah->misc_mode);
 
+	if (!chan)
+		return;
+
 	if (ah->misc_mode != 0)
 		REG_SET_BIT(ah, AR_PCU_MISC, ah->misc_mode);
 
-	if (conf->channel && conf->channel->band == IEEE80211_BAND_5GHZ)
-		sifstime = 16;
-	else
-		sifstime = 10;
+	rx_lat = 37;
+	tx_lat = 54;
+
+	if (IS_CHAN_HALF_RATE(chan)) {
+		eifs = 175;
+		rx_lat *= 2;
+		tx_lat *= 2;
+		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
+		    tx_lat += 11;
+
+		slottime = 13;
+		sifstime = 32;
+	} else if (IS_CHAN_QUARTER_RATE(chan)) {
+		eifs = 340;
+		rx_lat *= 4;
+		tx_lat *= 4;
+		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
+		    tx_lat += 22;
+
+		slottime = 21;
+		sifstime = 64;
+	} else {
+		eifs = REG_READ(ah, AR_D_GBL_IFS_EIFS);
+		reg = REG_READ(ah, AR_USEC);
+		rx_lat = MS(reg, AR_USEC_RX_LAT);
+		tx_lat = MS(reg, AR_USEC_TX_LAT);
+
+		slottime = ah->slottime;
+		if (IS_CHAN_5GHZ(chan))
+			sifstime = 16;
+		else
+			sifstime = 10;
+	}
 
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
-	slottime = ah->slottime + 3 * ah->coverage_class;
-	acktimeout = slottime + sifstime;
+	acktimeout = slottime + sifstime + 3 * ah->coverage_class;
 
 	/*
 	 * Workaround for early ACK timeouts, add an offset to match the
@@ -972,11 +1014,20 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ)
 		acktimeout += 64 - sifstime - ah->slottime;
 
-	ath9k_hw_setslottime(ah, ah->slottime);
+	ath9k_hw_set_sifs_time(ah, sifstime);
+	ath9k_hw_setslottime(ah, slottime);
 	ath9k_hw_set_ack_timeout(ah, acktimeout);
 	ath9k_hw_set_cts_timeout(ah, acktimeout);
 	if (ah->globaltxtimeout != (u32) -1)
 		ath9k_hw_set_global_txtimeout(ah, ah->globaltxtimeout);
+
+	REG_WRITE(ah, AR_D_GBL_IFS_EIFS, ath9k_hw_mac_to_clks(ah, eifs));
+	REG_RMW(ah, AR_USEC,
+		(common->clockrate - 1) |
+		SM(rx_lat, AR_USEC_RX_LAT) |
+		SM(tx_lat, AR_USEC_TX_LAT),
+		AR_USEC_TX_LAT | AR_USEC_RX_LAT | AR_USEC_USEC);
+
 }
 EXPORT_SYMBOL(ath9k_hw_init_global_settings);
 
-- 
1.7.3.2

