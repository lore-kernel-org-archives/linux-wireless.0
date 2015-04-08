Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35202 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbbDHSwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2015 14:52:00 -0400
Received: by wgyo15 with SMTP id o15so86967646wgy.2
        for <linux-wireless@vger.kernel.org>; Wed, 08 Apr 2015 11:51:59 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org
Subject: [PATCH] ath9k: fix per-packet tx power configuration
Date: Wed,  8 Apr 2015 20:51:57 +0200
Message-Id: <1428519117-15833-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150408_205206_612623_7BD935E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not use ieee80211_vif pointer in ath_get_rate_txpower() since it has been
overwritten by setup_frame_info() and it will result in a corrupted tx power
configuration. Set per-packet tx power in setup_frame_info() according to
current vif tx power.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 52 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 0acd079..3ad79bb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1103,28 +1103,14 @@ static u8 ath_get_rate_txpower(struct ath_softc *sc, struct ath_buf *bf,
 	struct sk_buff *skb;
 	struct ath_frame_info *fi;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_vif *vif;
 	struct ath_hw *ah = sc->sc_ah;
 
 	if (sc->tx99_state || !ah->tpc_enabled)
 		return MAX_RATE_POWER;
 
 	skb = bf->bf_mpdu;
-	info = IEEE80211_SKB_CB(skb);
-	vif = info->control.vif;
-
-	if (!vif) {
-		max_power = sc->cur_chan->cur_txpower;
-		goto out;
-	}
-
-	if (vif->bss_conf.txpower_type != NL80211_TX_POWER_LIMITED) {
-		max_power = min_t(u8, sc->cur_chan->cur_txpower,
-				  2 * vif->bss_conf.txpower);
-		goto out;
-	}
-
 	fi = get_frame_info(skb);
+	info = IEEE80211_SKB_CB(skb);
 
 	if (!AR_SREV_9300_20_OR_LATER(ah)) {
 		int txpower = fi->tx_power;
@@ -1161,25 +1147,26 @@ static u8 ath_get_rate_txpower(struct ath_softc *sc, struct ath_buf *bf,
 			txpower -= 2;
 
 		txpower = max(txpower, 0);
-		max_power = min_t(u8, ah->tx_power[rateidx],
-				  2 * vif->bss_conf.txpower);
-		max_power = min_t(u8, max_power, txpower);
+		max_power = min_t(u8, ah->tx_power[rateidx], txpower);
+
+		/* XXX: clamp minimum TX power at 1 for AR9160 since if
+		 * max_power is set to 0, frames are transmitted at max
+		 * TX power
+		 */
+		if (!max_power && !AR_SREV_9280_20_OR_LATER(ah))
+			max_power = 1;
 	} else if (!bf->bf_state.bfs_paprd) {
 		if (rateidx < 8 && (info->flags & IEEE80211_TX_CTL_STBC))
 			max_power = min_t(u8, ah->tx_power_stbc[rateidx],
-					  2 * vif->bss_conf.txpower);
+					  fi->tx_power);
 		else
 			max_power = min_t(u8, ah->tx_power[rateidx],
-					  2 * vif->bss_conf.txpower);
-		max_power = min(max_power, fi->tx_power);
+					  fi->tx_power);
 	} else {
 		max_power = ah->paprd_training_power;
 	}
-out:
-	/* XXX: clamp minimum TX power at 1 for AR9160 since if max_power
-	 * is set to 0, frames are transmitted at max TX power
-	 */
-	return (!max_power && !AR_SREV_9280_20_OR_LATER(ah)) ? 1 : max_power;
+
+	return max_power;
 }
 
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
@@ -2129,6 +2116,7 @@ static void setup_frame_info(struct ieee80211_hw *hw,
 	struct ath_node *an = NULL;
 	enum ath9k_key_type keytype;
 	bool short_preamble = false;
+	u8 txpower;
 
 	/*
 	 * We check if Short Preamble is needed for the CTS rate by
@@ -2145,6 +2133,16 @@ static void setup_frame_info(struct ieee80211_hw *hw,
 	if (sta)
 		an = (struct ath_node *) sta->drv_priv;
 
+	if (tx_info->control.vif) {
+		struct ieee80211_vif *vif = tx_info->control.vif;
+
+		txpower = 2 * vif->bss_conf.txpower;
+	} else {
+		struct ath_softc *sc = hw->priv;
+
+		txpower = sc->cur_chan->cur_txpower;
+	}
+
 	memset(fi, 0, sizeof(*fi));
 	fi->txq = -1;
 	if (hw_key)
@@ -2155,7 +2153,7 @@ static void setup_frame_info(struct ieee80211_hw *hw,
 		fi->keyix = ATH9K_TXKEYIX_INVALID;
 	fi->keytype = keytype;
 	fi->framelen = framelen;
-	fi->tx_power = MAX_RATE_POWER;
+	fi->tx_power = txpower;
 
 	if (!rate)
 		return;
-- 
2.1.0

