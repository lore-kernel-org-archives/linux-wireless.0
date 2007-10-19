Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:50011 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbXJSW5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 18:57:13 -0400
Message-id: <4615322232898129799@pripojeni.net> (sfid-20071020_011640_685970_A4C107B8)
Subject: [PATCH 1/1] Net: ath5k, minor fixes
From: Jiri Slaby <jirislaby@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Cc: <mickflemm@gmail.com>
Cc: <mcgrof@gmail.com>
Date: Fri, 19 Oct 2007 18:57:13 -0400
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k, minor fixes

- some -W compiler warnings fixes (signedness)
- make ath_stop static
- add BUG to ath5k_register_mode when passing supported but not filled mode
  and move the supported modes check into this function to simplify the
  macro

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 9867f6ed3959a87d236cd6f012240757d81cd44a
tree 73b24022edecd0b925a5a9958d884c9d1504e677
parent 4bcbd552358739d0fb1712694b9f8bb7fa5b340b
author Jiri Slaby <jirislaby@gmail.com> Sat, 20 Oct 2007 00:41:48 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 20 Oct 2007 00:41:48 +0200

 drivers/net/wireless/ath5k/base.c |   25 +++++++++++++------------
 drivers/net/wireless/ath5k/hw.c   |    8 ++++----
 drivers/net/wireless/ath5k/phy.c  |    3 ++-
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index c38adab..3f3089f 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -908,7 +908,7 @@ static void ath5k_tx_draintxq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 static void ath5k_draintxq(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
-	int i;
+	unsigned int i;
 
 	/* XXX return value */
 	if (likely(!test_bit(ATH_STAT_INVALID, sc->status))) {
@@ -1317,7 +1317,7 @@ static int ath5k_start(struct ieee80211_hw *hw)
 	return ath5k_init(hw->priv);
 }
 
-void ath5k_stop(struct ieee80211_hw *hw)
+static void ath5k_stop(struct ieee80211_hw *hw)
 {
 	ath5k_stop_hw(hw->priv);
 }
@@ -1429,9 +1429,8 @@ unlock:
  *   - when scanning
  */
 static void ath5k_configure_filter(struct ieee80211_hw *hw,
-               unsigned int changed_flags,
-               unsigned int *new_flags,
-               int mc_count, struct dev_mc_list *mclist)
+		unsigned int changed_flags, unsigned int *new_flags,
+		int mc_count, struct dev_mc_list *mclist)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
@@ -1933,7 +1932,11 @@ static inline int ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ieee80211_hw_mode *modes = sc->modes;
-	int i, ret;
+	unsigned int i;
+	int ret;
+
+	if (!test_bit(m, sc->ah->ah_capabilities.cap_mode))
+		return 0;
 
 	for (i = 0; i < NUM_DRIVER_MODES; i++) {
 		if (modes[i].mode != m || !modes[i].num_channels)
@@ -1945,16 +1948,14 @@ static inline int ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
 		}
 		return 0;
 	}
-	return 1;
+	BUG();
 }
 
 /* Only tries to register modes our EEPROM says it can support */
 #define REGISTER_MODE(m) do { \
-	if (test_bit(m, ah->ah_capabilities.cap_mode)) { \
-		ret = ath5k_register_mode(hw, m); \
-		if (ret) \
-			return ret; \
-	} \
+	ret = ath5k_register_mode(hw, m); \
+	if (ret) \
+		return ret; \
 } while (0) \
 
 static int ath5k_getchannels(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 64430ed..c8d1fbd 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -539,7 +539,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 {
 	const struct ath5k_rate_table *rt;
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	u32 data, noise_floor, s_seq, s_ant, s_led[3];
+	u32 data, s_seq, s_ant, s_led[3];
+	s32 noise_floor;
 	unsigned int i, mode, freq, ee_mode, ant[2];
 	int ret;
 
@@ -944,8 +945,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		mdelay(1);
 		noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
 
-		if (AR5K_PHY_NF_RVAL(noise_floor) &
-		AR5K_PHY_NF_ACTIVE)
+		if (AR5K_PHY_NF_RVAL(noise_floor) & AR5K_PHY_NF_ACTIVE)
 			noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
 
 		if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
@@ -1033,7 +1033,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 {
 	int ret;
-	u32 mask = val ? val : ~0;
+	u32 mask = val ? val : ~0U;
 
 	AR5K_TRACE;
 
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 83cff49..d3735bc 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1306,7 +1306,8 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
-	u32 phy_sig, phy_agc, phy_sat, beacon, noise_floor;
+	u32 phy_sig, phy_agc, phy_sat, beacon;
+	s32 noise_floor;
 	unsigned int i;
 	int ret;
 
