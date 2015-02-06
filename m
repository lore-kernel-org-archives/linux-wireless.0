Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:53794 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbBFOju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 09:39:50 -0500
Received: by mail-we0-f176.google.com with SMTP id p10so2545277wes.7
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 06:39:49 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [RFC 2/2] ath9k: add per-vif TX power capability to TX path
Date: Fri,  6 Feb 2015 15:39:46 +0100
Message-Id: <1423233586-9258-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150206_153954_953398_E8B95013)
In-Reply-To: <1423233586-9258-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1423233586-9258-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to add per-vif TX power capability cap per-packet TX power to vif
configured power if the latter is lower than per-rate TX power and mac80211
per-frame power. Use vif TX power if TPC has been disabled for current
interface

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 42 +++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 1b8e75c..0acd079 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1103,14 +1103,28 @@ static u8 ath_get_rate_txpower(struct ath_softc *sc, struct ath_buf *bf,
 	struct sk_buff *skb;
 	struct ath_frame_info *fi;
 	struct ieee80211_tx_info *info;
+	struct ieee80211_vif *vif;
 	struct ath_hw *ah = sc->sc_ah;
 
 	if (sc->tx99_state || !ah->tpc_enabled)
 		return MAX_RATE_POWER;
 
 	skb = bf->bf_mpdu;
-	fi = get_frame_info(skb);
 	info = IEEE80211_SKB_CB(skb);
+	vif = info->control.vif;
+
+	if (!vif) {
+		max_power = sc->cur_chan->cur_txpower;
+		goto out;
+	}
+
+	if (vif->bss_conf.txpower_type != NL80211_TX_POWER_LIMITED) {
+		max_power = min_t(u8, sc->cur_chan->cur_txpower,
+				  2 * vif->bss_conf.txpower);
+		goto out;
+	}
+
+	fi = get_frame_info(skb);
 
 	if (!AR_SREV_9300_20_OR_LATER(ah)) {
 		int txpower = fi->tx_power;
@@ -1147,25 +1161,25 @@ static u8 ath_get_rate_txpower(struct ath_softc *sc, struct ath_buf *bf,
 			txpower -= 2;
 
 		txpower = max(txpower, 0);
-		max_power = min_t(u8, ah->tx_power[rateidx], txpower);
-
-		/* XXX: clamp minimum TX power at 1 for AR9160 since if
-		 * max_power is set to 0, frames are transmitted at max
-		 * TX power
-		 */
-		if (!max_power && !AR_SREV_9280_20_OR_LATER(ah))
-			max_power = 1;
+		max_power = min_t(u8, ah->tx_power[rateidx],
+				  2 * vif->bss_conf.txpower);
+		max_power = min_t(u8, max_power, txpower);
 	} else if (!bf->bf_state.bfs_paprd) {
 		if (rateidx < 8 && (info->flags & IEEE80211_TX_CTL_STBC))
-			max_power = min(ah->tx_power_stbc[rateidx],
-					fi->tx_power);
+			max_power = min_t(u8, ah->tx_power_stbc[rateidx],
+					  2 * vif->bss_conf.txpower);
 		else
-			max_power = min(ah->tx_power[rateidx], fi->tx_power);
+			max_power = min_t(u8, ah->tx_power[rateidx],
+					  2 * vif->bss_conf.txpower);
+		max_power = min(max_power, fi->tx_power);
 	} else {
 		max_power = ah->paprd_training_power;
 	}
-
-	return max_power;
+out:
+	/* XXX: clamp minimum TX power at 1 for AR9160 since if max_power
+	 * is set to 0, frames are transmitted at max TX power
+	 */
+	return (!max_power && !AR_SREV_9280_20_OR_LATER(ah)) ? 1 : max_power;
 }
 
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
-- 
2.1.0

