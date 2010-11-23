Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49942 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0KWThh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:37:37 -0500
Received: by eye27 with SMTP id 27so4899367eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:37:36 -0800 (PST)
Date: Tue, 23 Nov 2010 21:37:30 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 22/30] ath5k: Skip powertable setting when we are on the same
 channel
Message-ID: <20101123193730.GV4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Only set power table if we are changing channel/mode
 there is no need to recalculate and reset the power table
 all the time.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   65 ++++++++++++++++++++++------------
 1 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index b908915..9392320 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3090,7 +3090,7 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
  */
 static int
 ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
-		u8 ee_mode, u8 txpower)
+		u8 ee_mode, u8 txpower, bool fast)
 {
 	struct ath5k_rate_pcal_info rate_info;
 	u8 type;
@@ -3126,10 +3126,15 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		return -EINVAL;
 	}
 
-	/* FIXME: Only on channel/mode change */
-	ret = ath5k_setup_channel_powertable(ah, channel, ee_mode, type);
-	if (ret)
-		return ret;
+	/* If fast is set it means we are on the same channel/mode
+	 * so there is no need to recalculate the powertable, we 'll
+	 * just use the cached one */
+	if (!fast) {
+		ret = ath5k_setup_channel_powertable(ah, channel,
+							ee_mode, type);
+			if (ret)
+				return ret;
+	}
 
 	/* Limit max power if we have a CTL available */
 	ath5k_get_max_ctl_power(ah, channel);
@@ -3210,7 +3215,7 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 	ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_TXPOWER,
 		"changing txpower to %d\n", txpower);
 
-	return ath5k_hw_txpower(ah, channel, ee_mode, txpower);
+	return ath5k_hw_txpower(ah, channel, ee_mode, txpower, true);
 }
 
 /*************\
@@ -3220,13 +3225,42 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 						u8 mode, u8 ee_mode, u8 freq)
 {
+	struct ieee80211_channel *curr_channel;
 	int ret, i;
 	u32 phy_tst1;
-
+	bool fast_txp;
 	ret = 0;
 
 	/*
-	 * 5211/5212 Specific
+	 * If we don't change channel/mode skip
+	 * tx powertable calculation and use the
+	 * cached one.
+	 */
+	curr_channel = ah->ah_current_channel;
+	if ((channel->hw_value == curr_channel->hw_value) &&
+	(channel->center_freq == curr_channel->center_freq))
+		fast_txp = true;
+	else
+		fast_txp = false;
+
+	/*
+	 * Set TX power
+	 *
+	 * Note: We need to do that before we set
+	 * RF buffer settings on 5211/5212+ so that we
+	 * properly set curve indices.
+	 */
+	ret = ath5k_hw_txpower(ah, channel, ee_mode,
+				ah->ah_txpower.txp_max_pwr / 2,
+				fast_txp);
+	if (ret)
+		return ret;
+
+	/*
+	 * For 5210 we do all initialization using
+	 * initvals, so we don't have to modify
+	 * any settings (5210 also only supports
+	 * a/aturbo modes)
 	 */
 	if (ah->ah_version != AR5K_AR5210) {
 
@@ -3241,21 +3275,12 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		mdelay(1);
 
 		/*
-		 * Set TX power
-		 */
-		ret = ath5k_hw_txpower(ah, channel, ee_mode,
-					ah->ah_txpower.txp_max_pwr / 2);
-		if (ret)
-			return ret;
-
-		/*
 		 * Write RF buffer
 		 */
 		ret = ath5k_hw_rfregs_init(ah, channel, mode);
 		if (ret)
 			return ret;
 
-
 		/* Write OFDM timings on 5212*/
 		if (ah->ah_version == AR5K_AR5212 &&
 			channel->hw_value & CHANNEL_OFDM) {
@@ -3284,12 +3309,6 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		}
 
 	} else {
-		/*
-		 * For 5210 we do all initialization using
-		 * initvals, so we don't have to modify
-		 * any settings (5210 also only supports
-		 * a/aturbo modes)
-		 */
 		mdelay(1);
 		/* Disable phy and wait */
 		ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
