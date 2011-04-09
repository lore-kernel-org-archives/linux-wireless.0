Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52443 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab1DIVKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 17:10:25 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 1/3] ath5k: fix short preamble rate duration value
Date: Sat,  9 Apr 2011 23:10:19 +0200
Message-Id: <1302383421-1418-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subtract the difference in preamble duration (in usec) from the value
returned by ieee80211_generic_frame_duration.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c   |   31 ++++++++++++-------------------
 drivers/net/wireless/ath/ath5k/qcu.c   |    2 +-
 3 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 8a06dbd..996d8af 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1233,7 +1233,7 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
 /* Protocol Control Unit Functions */
 /* Helpers */
 int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
-		int len, struct ieee80211_rate *rate);
+		int len, struct ieee80211_rate *rate, bool shortpre);
 unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah);
 unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah);
 extern int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype opmode);
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index a702817..e342e47 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -75,7 +75,7 @@ static const unsigned int ack_rates_high[] =
  * bwmodes.
  */
 int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
-		int len, struct ieee80211_rate *rate)
+		int len, struct ieee80211_rate *rate, bool shortpre)
 {
 	struct ath5k_softc *sc = ah->ah_sc;
 	int sifs, preamble, plcp_bits, sym_time;
@@ -84,9 +84,15 @@ int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
 
 	/* Fallback */
 	if (!ah->ah_bwmode) {
-		dur = ieee80211_generic_frame_duration(sc->hw,
-						NULL, len, rate);
-		return le16_to_cpu(dur);
+		__le16 raw_dur = ieee80211_generic_frame_duration(sc->hw,
+					NULL, len, rate);
+
+		/* subtract difference between long and short preamble */
+		dur = le16_to_cpu(raw_dur);
+		if (shortpre)
+			dur -= 96;
+
+		return dur;
 	}
 
 	bitrate = rate->bitrate;
@@ -263,27 +269,14 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 		 * actual rate for this rate. See mac80211 tx.c
 		 * ieee80211_duration() for a brief description of
 		 * what rate we should choose to TX ACKs. */
-		tx_time = ath5k_hw_get_frame_duration(ah, 10, rate);
+		tx_time = ath5k_hw_get_frame_duration(ah, 10, rate, false);
 
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
 		if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))
 			continue;
 
-		/*
-		 * We're not distinguishing short preamble here,
-		 * This is true, all we'll get is a longer value here
-		 * which is not necessarilly bad. We could use
-		 * export ieee80211_frame_duration() but that needs to be
-		 * fixed first to be properly used by mac802111 drivers:
-		 *
-		 *  - remove erp stuff and let the routine figure ofdm
-		 *    erp rates
-		 *  - remove passing argument ieee80211_local as
-		 *    drivers don't have access to it
-		 *  - move drivers using ieee80211_generic_frame_duration()
-		 *    to this
-		 */
+		tx_time = ath5k_hw_get_frame_duration(ah, 10, rate, true);
 		ath5k_hw_reg_write(ah, tx_time,
 			reg + (AR5K_SET_SHORT_PREAMBLE << 2));
 	}
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 3343fb9..93abcfa 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -550,7 +550,7 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 	else
 		rate = &sc->sbands[IEEE80211_BAND_2GHZ].bitrates[0];
 
-	ack_tx_time = ath5k_hw_get_frame_duration(ah, 10, rate);
+	ack_tx_time = ath5k_hw_get_frame_duration(ah, 10, rate, false);
 
 	/* ack_tx_time includes an SIFS already */
 	eifs = ack_tx_time + sifs + 2 * slot_time;
-- 
1.7.3.2

