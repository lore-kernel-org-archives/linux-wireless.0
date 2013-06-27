Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55895 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3F0Mon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 08:44:43 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 18/18] ath5k: enable support for 5 MHz and 10 MHz channels
Date: Thu, 27 Jun 2013 14:44:24 +0200
Message-Id: <1372337064-19254-19-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_144501_858490_8703C3A9)
In-Reply-To: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath5k/ath5k.h        |    1 +
 drivers/net/wireless/ath/ath5k/base.c         |   25 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath5k/base.h         |    2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 2d691b8..74bd54d 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -29,6 +29,7 @@
 #include <linux/average.h>
 #include <linux/leds.h>
 #include <net/mac80211.h>
+#include <net/cfg80211.h>
 
 /* RX/TX descriptor hw structs
  * TODO: Driver part should only see sw structs */
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 7c298af..48161ed 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -56,6 +56,7 @@
 #include <linux/etherdevice.h>
 #include <linux/nl80211.h>
 
+#include <net/cfg80211.h>
 #include <net/ieee80211_radiotap.h>
 
 #include <asm/unaligned.h>
@@ -443,11 +444,27 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
  * Called with ah->lock.
  */
 int
-ath5k_chan_set(struct ath5k_hw *ah, struct ieee80211_channel *chan)
+ath5k_chan_set(struct ath5k_hw *ah, struct cfg80211_chan_def *chandef)
 {
 	ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 		  "channel set, resetting (%u -> %u MHz)\n",
-		  ah->curchan->center_freq, chan->center_freq);
+		  ah->curchan->center_freq, chandef->chan->center_freq);
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		ah->ah_bwmode = AR5K_BWMODE_DEFAULT;
+		break;
+	case NL80211_CHAN_WIDTH_5:
+		ah->ah_bwmode = AR5K_BWMODE_5MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_10:
+		ah->ah_bwmode = AR5K_BWMODE_10MHZ;
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
 
 	/*
 	 * To switch channels clear any pending DMA operations;
@@ -455,7 +472,7 @@ ath5k_chan_set(struct ath5k_hw *ah, struct ieee80211_channel *chan)
 	 * hardware at the new frequency, and then re-enable
 	 * the relevant bits of the h/w.
 	 */
-	return ath5k_reset(ah, chan, true);
+	return ath5k_reset(ah, chandef->chan, true);
 }
 
 void ath5k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
@@ -2525,6 +2542,8 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 	/* SW support for IBSS_RSN is provided by mac80211 */
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_5_10_MHZ;
+
 	/* both antennas can be configured as RX or TX */
 	hw->wiphy->available_antennas_tx = 0x3;
 	hw->wiphy->available_antennas_rx = 0x3;
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index ca9a83c..97469d0 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -101,7 +101,7 @@ void ath5k_set_beacon_filter(struct ieee80211_hw *hw, bool enable);
 
 void ath5k_update_bssid_mask_and_opmode(struct ath5k_hw *ah,
 					struct ieee80211_vif *vif);
-int ath5k_chan_set(struct ath5k_hw *ah, struct ieee80211_channel *chan);
+int ath5k_chan_set(struct ath5k_hw *ah, struct cfg80211_chan_def *chandef);
 void ath5k_txbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
 void ath5k_rxbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
 void ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 81b686c..aa9d976 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -202,7 +202,7 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&ah->lock);
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		ret = ath5k_chan_set(ah, conf->chandef.chan);
+		ret = ath5k_chan_set(ah, &conf->chandef);
 		if (ret < 0)
 			goto unlock;
 	}
-- 
1.7.10.4

