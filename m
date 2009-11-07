Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZKGUTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:08 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 25/29] ath5k: use the common->keymap
Date: Sat,  7 Nov 2009 15:19:02 -0500
Message-Id: <1257625146-17971-26-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   10 +++++++---
 drivers/net/wireless/ath/ath5k/base.h |    2 --
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c7fc13c..9341e2d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1684,6 +1684,8 @@ static unsigned int
 ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
 		struct sk_buff *skb, struct ath5k_rx_status *rs)
 {
+	struct ath5k_hw *ah = sc->ah;
+	struct ath_common *common = ath5k_hw_common(ah);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int keyix, hlen;
 
@@ -1700,7 +1702,7 @@ ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
 	    skb->len >= hlen + 4) {
 		keyix = skb->data[hlen + 3] >> 6;
 
-		if (test_bit(keyix, sc->keymap))
+		if (test_bit(keyix, common->keymap))
 			return RX_FLAG_DECRYPTED;
 	}
 
@@ -3039,6 +3041,8 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	      struct ieee80211_key_conf *key)
 {
 	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath_common *common = ath5k_hw_common(ah);
 	int ret = 0;
 
 	if (modparam_nohwcrypt)
@@ -3071,14 +3075,14 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			ATH5K_ERR(sc, "can't set the key\n");
 			goto unlock;
 		}
-		__set_bit(key->keyidx, sc->keymap);
+		__set_bit(key->keyidx, common->keymap);
 		key->hw_key_idx = key->keyidx;
 		key->flags |= (IEEE80211_KEY_FLAG_GENERATE_IV |
 			       IEEE80211_KEY_FLAG_GENERATE_MMIC);
 		break;
 	case DISABLE_KEY:
 		ath5k_hw_reset_key(sc->ah, key->keyidx);
-		__clear_bit(key->keyidx, sc->keymap);
+		__clear_bit(key->keyidx, common->keymap);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index b14ba07..b72338c 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -153,8 +153,6 @@ struct ath5k_softc {
 
 	enum ath5k_int		imask;		/* interrupt mask copy */
 
-	DECLARE_BITMAP(keymap, AR5K_KEYCACHE_SIZE); /* key use bit map */
-
 	u8			bssidmask[ETH_ALEN];
 
 	unsigned int		led_pin,	/* GPIO pin for driving LED */
-- 
1.6.5.2.143.g8cc62

