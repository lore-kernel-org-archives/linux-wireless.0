Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50816 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaL0OMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 09:12:32 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so15981517wgh.12
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 06:12:30 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [RFC 2/3] ath9k: add TPC to TX path for AR9002 based chips
Date: Sat, 27 Dec 2014 15:12:24 +0100
Message-Id: <1419689545-26965-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141227_151242_821207_2D5FBEC7)
In-Reply-To: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add TPC capability to TX descriptor path for AR9002 based chips. Scale
per-packet TX power according to eeprom power bias, power adjustments for
HT40 mode and open loop CCK rates. Cap per-packet TX power according to
TX power per-rate tables

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 66 +++++++++++++++++++++++++++++------
 1 file changed, 55 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 52d63de..1cfe5f8 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1097,24 +1097,65 @@ void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop)
 }
 
 static u8 ath_get_rate_txpower(struct ath_softc *sc, struct ath_buf *bf,
-			       u8 rateidx)
+			       u8 rateidx, bool is_40, bool is_cck)
 {
 	u8 max_power;
+	struct sk_buff *skb;
+	struct ath_frame_info *fi;
+	struct ieee80211_tx_info *info;
 	struct ath_hw *ah = sc->sc_ah;
 
 	if (sc->tx99_state)
 		return MAX_RATE_POWER;
 
+	skb = bf->bf_mpdu;
+	fi = get_frame_info(skb);
+	info = IEEE80211_SKB_CB(skb);
+
 	if (!AR_SREV_9300_20_OR_LATER(ah)) {
-		/* ar9002 does not support TPC for the moment */
-		return MAX_RATE_POWER;
-	}
+		int txpower = fi->tx_power;
 
-	if (!bf->bf_state.bfs_paprd) {
-		struct sk_buff *skb = bf->bf_mpdu;
-		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-		struct ath_frame_info *fi = get_frame_info(skb);
+		if (is_40) {
+			u8 power_ht40delta;
+			struct ar5416_eeprom_def *eep = &ah->eeprom.def;
+
+			if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_2) {
+				bool is_2ghz;
+				struct modal_eep_header *pmodal;
 
+				is_2ghz = info->band == IEEE80211_BAND_2GHZ;
+				pmodal = &eep->modalHeader[is_2ghz];
+				power_ht40delta = pmodal->ht40PowerIncForPdadc;
+			} else {
+				power_ht40delta = 2;
+			}
+			txpower += power_ht40delta;
+		}
+
+		if (AR_SREV_9287(ah) || AR_SREV_9285(ah) ||
+		    AR_SREV_9271(ah)) {
+			txpower -= 2 * AR9287_PWR_TABLE_OFFSET_DB;
+		} else if (AR_SREV_9280_20_OR_LATER(ah)) {
+			s8 power_offset;
+
+			power_offset = ah->eep_ops->get_eeprom(ah,
+							EEP_PWR_TABLE_OFFSET);
+			txpower -= 2 * power_offset;
+		}
+
+		if (OLC_FOR_AR9280_20_LATER && is_cck)
+			txpower -= 2;
+
+		txpower = max(txpower, 0);
+		max_power = min_t(ah->tx_power[rateidx], (u8)txpower);
+
+		/* XXX: clamp minimum TX power at 1 for AR9160 since if
+		 * max_power is set to 0, frames are transmitted at max
+		 * TX power
+		 */
+		if (!max_power && !AR_SREV_9280_20_OR_LATER(ah))
+			max_power = 1;
+	} else if (!bf->bf_state.bfs_paprd) {
 		if (rateidx < 8 && (info->flags & IEEE80211_TX_CTL_STBC))
 			max_power = min(ah->tx_power_stbc[rateidx],
 					fi->tx_power);
@@ -1152,7 +1193,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 	info->rtscts_rate = fi->rtscts_rate;
 
 	for (i = 0; i < ARRAY_SIZE(bf->rates); i++) {
-		bool is_40, is_sgi, is_sp;
+		bool is_40, is_sgi, is_sp, is_cck;
 		int phy;
 
 		if (!rates[i].count || (rates[i].idx < 0))
@@ -1198,7 +1239,8 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 			if (rix < 8 && (tx_info->flags & IEEE80211_TX_CTL_STBC))
 				info->rates[i].RateFlags |= ATH9K_RATESERIES_STBC;
 
-			info->txpower[i] = ath_get_rate_txpower(sc, bf, rix);
+			info->txpower[i] = ath_get_rate_txpower(sc, bf, rix,
+								is_40, false);
 			continue;
 		}
 
@@ -1227,7 +1269,9 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 		info->rates[i].PktDuration = ath9k_hw_computetxtime(sc->sc_ah,
 			phy, rate->bitrate * 100, len, rix, is_sp);
 
-		info->txpower[i] = ath_get_rate_txpower(sc, bf, rix);
+		is_cck = IS_CCK_RATE(info->rates[i].Rate);
+		info->txpower[i] = ath_get_rate_txpower(sc, bf, rix, false,
+							is_cck);
 	}
 
 	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
-- 
2.1.0

