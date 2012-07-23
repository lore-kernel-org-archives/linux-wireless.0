Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:54082 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298Ab2GWQBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 12:01:23 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com, thomas@net.t-labs.tu-berlin.de,
	nbd@nbd.name
Subject: [PATCH 2/2] ath5k: fix phy_init() to respect user txpower changes
Date: Mon, 23 Jul 2012 18:01:15 +0200
Message-Id: <1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120723_180127_844068_5C1B650D)
In-Reply-To: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In such cases where phy_init() function got called, tx_power is always
set to ah->ah_txpower.txp_cur_pwr which is never updated with txpower
specified by the user instead it equale max chan power and got
potentially incremented by ah_txpower.txp_offset.
In any case the card was switching to a txpower level higher that
someone specified to use. This patch fix this by introducing
ah_txpower.txp_user_pwr which holds the tx_power specified at userland.
Function ath5k_hw_txpower is restructured and uses the value at
ah_txpower.txp_user_pwr directly.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
restructure of ath5k_hw_txpower as suggested by Felix Fietkau.
---
 drivers/net/wireless/ath/ath5k/ath5k.h |  1 +
 drivers/net/wireless/ath/ath5k/base.c  |  3 +++
 drivers/net/wireless/ath/ath5k/phy.c   | 27 ++++++++++++++-------------
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 64a453a..89d9ac54 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1418,6 +1418,7 @@ struct ath5k_hw {
 		s16		txp_min_pwr;
 		s16		txp_max_pwr;
 		s16		txp_cur_pwr;
+		s16		txp_user_pwr;
 		/* Values in 0.5dB units */
 		s16		txp_offset;
 		s16		txp_ofdm;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 8c4c040..e831f69 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2951,6 +2951,9 @@ ath5k_init(struct ieee80211_hw *hw)
 		hw->queues = 1;
 	}
 
+	/* init tx_power setting to maximum */
+	ah->ah_txpower.txp_user_pwr = AR5K_TUNE_MAX_TXPOWER;
+
 	tasklet_init(&ah->rxtq, ath5k_tasklet_rx, (unsigned long)ah);
 	tasklet_init(&ah->txtq, ath5k_tasklet_tx, (unsigned long)ah);
 	tasklet_init(&ah->beacontq, ath5k_tasklet_beacon, (unsigned long)ah);
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 8b71a2d..728ff07 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3583,14 +3583,12 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
  * ath5k_hw_txpower() - Set transmission power limit for a given channel
  * @ah: The &struct ath5k_hw
  * @channel: The &struct ieee80211_channel
- * @txpower: Requested tx power in 0.5dB steps
  *
  * Combines all of the above to set the requested tx power limit
- * on hw.
+ * on hw to ah->ah_txpower.txp_user_pwr.
  */
 static int
-ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
-		 u8 txpower)
+ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 {
 	struct ath5k_rate_pcal_info rate_info;
 	struct ieee80211_channel *curr_channel = ah->ah_current_channel;
@@ -3598,11 +3596,6 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	u8 type;
 	int ret;
 
-	if (txpower > AR5K_TUNE_MAX_TXPOWER) {
-		ATH5K_ERR(ah, "invalid tx power: %u\n", txpower);
-		return -EINVAL;
-	}
-
 	ee_mode = ath5k_eeprom_mode_from_channel(channel);
 	if (ee_mode < 0) {
 		ATH5K_ERR(ah,
@@ -3667,7 +3660,7 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	ath5k_get_rate_pcal_data(ah, channel, &rate_info);
 
 	/* Setup rate power table */
-	ath5k_setup_rate_powertable(ah, txpower, &rate_info, ee_mode);
+	ath5k_setup_rate_powertable(ah, ah->ah_txpower.txp_user_pwr, &rate_info, ee_mode);
 
 	/* Write rate power table on hw */
 	ath5k_hw_reg_write(ah, AR5K_TXPOWER_OFDM(3, 24) |
@@ -3717,8 +3710,16 @@ ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 {
 	ATH5K_DBG(ah, ATH5K_DEBUG_TXPOWER,
 		"changing txpower to %d\n", txpower);
+	if (txpower) {
+		ah->ah_txpower.txp_user_pwr = txpower;
+
+		if (ah->ah_txpower.txp_user_pwr > AR5K_TUNE_MAX_TXPOWER) {
+			ATH5K_ERR(ah, "invalid tx power: %u\n", ah->ah_txpower.txp_user_pwr);
+			return -EINVAL;
+		}
+	}
 
-	return ath5k_hw_txpower(ah, ah->ah_current_channel, txpower);
+	return ath5k_hw_txpower(ah, ah->ah_current_channel);
 }
 
 
@@ -3789,8 +3790,8 @@ ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	 * RF buffer settings on 5211/5212+ so that we
 	 * properly set curve indices.
 	 */
-	ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
-			ah->ah_txpower.txp_cur_pwr / 2 : AR5K_TUNE_MAX_TXPOWER);
+	ret = ath5k_hw_txpower(ah, channel);
+
 	if (ret)
 		return ret;
 
-- 
1.7.11.1

