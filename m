Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50055 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3EPLCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 07:02:01 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 18/18] ath5k: enable support for 5 MHz and 10 MHz channels
Date: Thu, 16 May 2013 13:00:45 +0200
Message-Id: <1368702045-27598-19-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130516_130231_850750_E7B4BDB2)
In-Reply-To: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
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
index 9be5f11..5af13b3 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -56,6 +56,7 @@
 #include <linux/etherdevice.h>
 #include <linux/nl80211.h>
 
+#include <net/cfg80211.h>
 #include <net/ieee80211_radiotap.h>
 
 #include <asm/unaligned.h>
@@ -442,11 +443,27 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
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
@@ -454,7 +471,7 @@ ath5k_chan_set(struct ath5k_hw *ah, struct ieee80211_channel *chan)
 	 * hardware at the new frequency, and then re-enable
 	 * the relevant bits of the h/w.
 	 */
-	return ath5k_reset(ah, chan, true);
+	return ath5k_reset(ah, chandef->chan, true);
 }
 
 void ath5k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
@@ -2474,6 +2491,8 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 	/* SW support for IBSS_RSN is provided by mac80211 */
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_5_10_MHZ;
+
 	/* both antennas can be configured as RX or TX */
 	hw->wiphy->available_antennas_tx = 0x3;
 	hw->wiphy->available_antennas_rx = 0x3;
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 6c94c7f..130075b 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -99,7 +99,7 @@ void ath5k_set_beacon_filter(struct ieee80211_hw *hw, bool enable);
 
 void ath5k_update_bssid_mask_and_opmode(struct ath5k_hw *ah,
 					struct ieee80211_vif *vif);
-int ath5k_chan_set(struct ath5k_hw *ah, struct ieee80211_channel *chan);
+int ath5k_chan_set(struct ath5k_hw *ah, struct cfg80211_chan_def *chandef);
 void ath5k_txbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
 void ath5k_rxbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
 void ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 06f86f4..2129330 100644
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

