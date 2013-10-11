Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55817 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296Ab3JKVbK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 17:31:10 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH v2 06/10] ath9k: make ath9k_cmn_update_ichannel static
Date: Fri, 11 Oct 2013 23:30:57 +0200
Message-Id: <1381527061-43758-6-git-send-email-nbd@openwrt.org> (sfid-20131011_233135_781465_F8A5D298)
In-Reply-To: <1381527061-43758-1-git-send-email-nbd@openwrt.org>
References: <1381527061-43758-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework its wrapper function to make it more generic, using it as a
replacement for previous calls to ath9k_cmn_update_ichannel.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/common.c       | 16 ++++++++--------
 drivers/net/wireless/ath/ath9k/common.h       |  7 +++----
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  6 ++----
 drivers/net/wireless/ath/ath9k/init.c         |  2 +-
 drivers/net/wireless/ath/ath9k/main.c         |  7 +++----
 5 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index b5ac269..a7e5a05 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -52,8 +52,8 @@ EXPORT_SYMBOL(ath9k_cmn_get_hw_crypto_keytype);
 /*
  * Update internal channel flags.
  */
-void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
-			       struct cfg80211_chan_def *chandef)
+static void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
+				      struct cfg80211_chan_def *chandef)
 {
 	struct ieee80211_channel *chan = chandef->chan;
 	u16 flags = 0;
@@ -88,25 +88,25 @@ void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
 
 	ichan->channelFlags = flags;
 }
-EXPORT_SYMBOL(ath9k_cmn_update_ichannel);
 
 /*
  * Get the internal channel reference.
  */
-struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
-					       struct ath_hw *ah)
+struct ath9k_channel *ath9k_cmn_get_channel(struct ieee80211_hw *hw,
+					    struct ath_hw *ah,
+					    struct cfg80211_chan_def *chandef)
 {
-	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
+	struct ieee80211_channel *curchan = chandef->chan;
 	struct ath9k_channel *channel;
 	u8 chan_idx;
 
 	chan_idx = curchan->hw_value;
 	channel = &ah->channels[chan_idx];
-	ath9k_cmn_update_ichannel(channel, &hw->conf.chandef);
+	ath9k_cmn_update_ichannel(channel, chandef);
 
 	return channel;
 }
-EXPORT_SYMBOL(ath9k_cmn_get_curchannel);
+EXPORT_SYMBOL(ath9k_cmn_get_channel);
 
 int ath9k_cmn_count_streams(unsigned int chainmask, int max)
 {
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index e039bcb..eb85e1b 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -43,10 +43,9 @@
 	(((x) + ((mul)/2)) / (mul))
 
 int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb);
-void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
-			       struct cfg80211_chan_def *chandef);
-struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
-					       struct ath_hw *ah);
+struct ath9k_channel *ath9k_cmn_get_channel(struct ieee80211_hw *hw,
+					    struct ath_hw *ah,
+					    struct cfg80211_chan_def *chandef);
 int ath9k_cmn_count_streams(unsigned int chainmask, int max);
 void ath9k_cmn_btcoex_bt_stomp(struct ath_common *common,
 				  enum ath_stomp_type stomp_type);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index fa71af1..9a2657f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -906,7 +906,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	WMI_CMD(WMI_FLUSH_RECV_CMDID);
 
 	/* setup initial channel */
-	init_channel = ath9k_cmn_get_curchannel(hw, ah);
+	init_channel = ath9k_cmn_get_channel(hw, ah, &hw->conf.chandef);
 
 	ret = ath9k_hw_reset(ah, init_channel, ah->caldata, false);
 	if (ret) {
@@ -1188,9 +1188,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		ath_dbg(common, CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
-		ath9k_cmn_update_ichannel(&priv->ah->channels[pos],
-					  &hw->conf.chandef);
-
+		ath9k_cmn_get_channel(hw, priv->ah, &hw->conf.chandef);
 		if (ath9k_htc_set_channel(priv, hw, &priv->ah->channels[pos]) < 0) {
 			ath_err(common, "Unable to set channel\n");
 			ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2306f57..9c145fa 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -802,7 +802,7 @@ static void ath9k_init_band_txpower(struct ath_softc *sc, int band)
 		chan = &sband->channels[i];
 		ah->curchan = &ah->channels[chan->hw_value];
 		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
-		ath9k_cmn_update_ichannel(ah->curchan, &chandef);
+		ath9k_cmn_get_channel(sc->hw, ah, &chandef);
 		ath9k_hw_set_txpowerlimit(ah, MAX_RATE_POWER, true);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 433caf4..2a86047 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -600,7 +600,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
-	init_channel = ath9k_cmn_get_curchannel(hw, ah);
+	init_channel = ath9k_cmn_get_channel(hw, ah, &hw->conf.chandef);
 
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(ah, false);
@@ -803,7 +803,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	}
 
 	if (!ah->curchan)
-		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
+		ah->curchan = ath9k_cmn_get_channel(hw, ah, &hw->conf.chandef);
 
 	ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	ath9k_hw_phy_disable(ah);
@@ -1223,8 +1223,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		ath_update_survey_stats(sc);
 		spin_unlock_irqrestore(&common->cc_lock, flags);
 
-		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
-					  &conf->chandef);
+		ath9k_cmn_get_channel(hw, ah, &conf->chandef);
 
 		/*
 		 * If the operating channel changes, change the survey in-use flags
-- 
1.8.0.2

