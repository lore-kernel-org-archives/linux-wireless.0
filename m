Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:18946 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757972Ab0LUIah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 03:30:37 -0500
Received: from vs3010.wh2.ocn.ne.jp (125.206.180.173)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-083113234
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 17:30:35 +0900 (JST)
Subject: [PATCH 4/5] ath5k: Remove ATH5K_INI_RFGAIN defines, use band instead
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Date: Tue, 21 Dec 2010 17:30:37 +0900
Message-ID: <20101221083037.8765.68357.stgit@localhost6.localdomain6>
In-Reply-To: <20101221083020.8765.16350.stgit@localhost6.localdomain6>
References: <20101221083020.8765.16350.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove redundant defines.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    6 +-----
 drivers/net/wireless/ath/ath5k/phy.c   |   18 ++++++------------
 drivers/net/wireless/ath/ath5k/reset.c |   11 +++--------
 3 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 342da28..5de8520 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -154,10 +154,6 @@
 		udelay(1);						\
 } while (0)
 
-/* Register dumps are done per operation mode */
-#define AR5K_INI_RFGAIN_5GHZ		0
-#define AR5K_INI_RFGAIN_2GHZ		1
-
 /*
  * Some tuneable values (these should be changeable by the user)
  * TODO: Make use of them and add more options OR use debug/configfs
@@ -1322,7 +1318,7 @@ void ath5k_hw_set_antenna_switch(struct ath5k_hw *ah, u8 ee_mode);
 int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower);
 /* Init function */
 int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
-				u8 mode, u8 ee_mode, u8 freq, bool fast);
+				u8 mode, u8 ee_mode, bool fast);
 
 /*
  * Functions used internaly
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 18c58cd..b6e9621 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -609,10 +609,10 @@ done:
 /* Write initial RF gain table to set the RF sensitivity
  * this one works on all RF chips and has nothing to do
  * with gain_F calibration */
-static int ath5k_hw_rfgain_init(struct ath5k_hw *ah, unsigned int freq)
+static int ath5k_hw_rfgain_init(struct ath5k_hw *ah, enum ieee80211_band band)
 {
 	const struct ath5k_ini_rfgain *ath5k_rfg;
-	unsigned int i, size;
+	unsigned int i, size, index;
 
 	switch (ah->ah_radio) {
 	case AR5K_RF5111:
@@ -644,17 +644,11 @@ static int ath5k_hw_rfgain_init(struct ath5k_hw *ah, unsigned int freq)
 		return -EINVAL;
 	}
 
-	switch (freq) {
-	case AR5K_INI_RFGAIN_2GHZ:
-	case AR5K_INI_RFGAIN_5GHZ:
-		break;
-	default:
-		return -EINVAL;
-	}
+	index = (band == IEEE80211_BAND_2GHZ) ? 1 : 0;
 
 	for (i = 0; i < size; i++) {
 		AR5K_REG_WAIT(i);
-		ath5k_hw_reg_write(ah, ath5k_rfg[i].rfg_value[freq],
+		ath5k_hw_reg_write(ah, ath5k_rfg[i].rfg_value[index],
 			(u32)ath5k_rfg[i].rfg_register);
 	}
 
@@ -3246,7 +3240,7 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 \*************/
 
 int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
-				u8 mode, u8 ee_mode, u8 freq, bool fast)
+				u8 mode, u8 ee_mode, bool fast)
 {
 	struct ieee80211_channel *curr_channel;
 	int ret, i;
@@ -3305,7 +3299,7 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		 * Write initial RF gain settings
 		 * This should work for both 5111/5112
 		 */
-		ret = ath5k_hw_rfgain_init(ah, freq);
+		ret = ath5k_hw_rfgain_init(ah, channel->band);
 		if (ret)
 			return ret;
 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index bc84aaa..4b8b987 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1020,13 +1020,12 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		struct ieee80211_channel *channel, bool fast, bool skip_pcu)
 {
 	u32 s_seq[10], s_led[3], tsf_up, tsf_lo;
-	u8 mode, freq, ee_mode;
+	u8 mode, ee_mode;
 	int i, ret;
 
 	ee_mode = 0;
 	tsf_up = 0;
 	tsf_lo = 0;
-	freq = 0;
 	mode = 0;
 
 	/*
@@ -1071,7 +1070,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
 		mode = AR5K_MODE_11A;
-		freq = AR5K_INI_RFGAIN_5GHZ;
 		ee_mode = AR5K_EEPROM_MODE_11A;
 		break;
 	case CHANNEL_G:
@@ -1083,7 +1081,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		}
 
 		mode = AR5K_MODE_11G;
-		freq = AR5K_INI_RFGAIN_2GHZ;
 		ee_mode = AR5K_EEPROM_MODE_11G;
 		break;
 	case CHANNEL_B:
@@ -1095,7 +1092,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		}
 
 		mode = AR5K_MODE_11B;
-		freq = AR5K_INI_RFGAIN_2GHZ;
 		ee_mode = AR5K_EEPROM_MODE_11B;
 		break;
 	case CHANNEL_XR:
@@ -1105,7 +1101,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 			return -EINVAL;
 		}
 		mode = AR5K_MODE_XR;
-		freq = AR5K_INI_RFGAIN_5GHZ;
 		ee_mode = AR5K_EEPROM_MODE_11A;
 		break;
 	default:
@@ -1120,7 +1115,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 */
 	if (fast) {
 		ret = ath5k_hw_phy_init(ah, channel, mode,
-					ee_mode, freq, true);
+					ee_mode, true);
 		if (ret) {
 			ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_RESET,
 				"fast chan change failed, falling back to normal reset\n");
@@ -1256,7 +1251,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	/*
 	 * Initialize PHY
 	 */
-	ret = ath5k_hw_phy_init(ah, channel, mode, ee_mode, freq, false);
+	ret = ath5k_hw_phy_init(ah, channel, mode, ee_mode, false);
 	if (ret) {
 		ATH5K_ERR(ah->ah_sc,
 			"failed to initialize PHY (%i) !\n", ret);

