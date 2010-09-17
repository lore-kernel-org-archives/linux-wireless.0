Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54958 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab0IQXI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:08:28 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3128487bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 16:08:27 -0700 (PDT)
Message-Id: <81729a27100af4463a92872ed4c83945554fdc2d.1284763835.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1284763834.git.chunkeey@googlemail.com>
References: <cover.1284763834.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 17 Sep 2010 23:09:19 +0200
Subject: [PATCH 6/7] carl9170: reinit phy after HT settings have changed
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver has a set of different initvals for 20 MHz
vs dynamic HT2040 operation. Because we can't change
some of the registers "in-flight", the driver needs to
perform a warm reset.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 +
 drivers/net/wireless/ath/carl9170/phy.c      |   25 +++++++++++++------------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index d43675a..d7c5482 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -325,6 +325,7 @@ struct ar9170 {
 	unsigned int chan_fail;
 	unsigned int total_chan_fail;
 	u8 heavy_clip;
+	u8 ht_settings;
 
 	/* power calibration data */
 	u8 power_5G_leg[4];
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index fa349b8..89deca3 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1610,7 +1610,7 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 	const struct carl9170_phy_freq_params *freqpar;
 	struct carl9170_rf_init_result rf_res;
 	struct carl9170_rf_init rf;
-	u32 cmd, tmp, offs = 0;
+	u32 cmd, tmp, offs = 0, new_ht = 0;
 	int err;
 	enum carl9170_bw bw;
 	bool warm_reset;
@@ -1618,12 +1618,19 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 
 	bw = nl80211_to_carl(_bw);
 
+	if (conf_is_ht(&ar->hw->conf))
+		new_ht |= CARL9170FW_PHY_HT_ENABLE;
+
+	if (conf_is_ht40(&ar->hw->conf))
+		new_ht |= CARL9170FW_PHY_HT_DYN2040;
+
 	/* may be NULL at first setup */
 	if (ar->channel) {
 		old_channel = ar->channel;
 		warm_reset = (old_channel->band != channel->band) ||
 			     (old_channel->center_freq ==
-			      channel->center_freq);
+			      channel->center_freq) ||
+			     (ar->ht_settings != new_ht);
 
 		ar->channel = NULL;
 	} else {
@@ -1724,16 +1731,9 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 
 	freqpar = carl9170_get_hw_dyn_params(channel, bw);
 
-	rf.ht_settings = 0;
-	if (conf_is_ht(&ar->hw->conf)) {
-		rf.ht_settings |= CARL9170FW_PHY_HT_ENABLE;
-
-		if (conf_is_ht40(&ar->hw->conf)) {
-			rf.ht_settings |= CARL9170FW_PHY_HT_DYN2040;
-			SET_VAL(CARL9170FW_PHY_HT_EXT_CHAN_OFF,
-				rf.ht_settings, offs);
-		}
-	}
+	rf.ht_settings = new_ht;
+	if (conf_is_ht40(&ar->hw->conf))
+		SET_VAL(CARL9170FW_PHY_HT_EXT_CHAN_OFF, rf.ht_settings, offs);
 
 	rf.freq = cpu_to_le32(channel->center_freq * 1000);
 	rf.delta_slope_coeff_exp = cpu_to_le32(freqpar->coeff_exp);
@@ -1805,5 +1805,6 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		ar->ps.off_override &= ~PS_OFF_5GHZ;
 
 	ar->channel = channel;
+	ar->ht_settings = new_ht;
 	return 0;
 }
-- 
1.7.1

