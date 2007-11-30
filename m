Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:36222 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760989AbXK3C0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 21:26:36 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 3/5] ath5k: fix noise floor calibration
Date: Fri, 30 Nov 2007 11:26:35 +0900
Message-Id: <1196389597-23559-4-git-send-email-bruno@thinktube.com> (sfid-20071130_022643_060329_12DF8A94)
In-Reply-To: <1196389597-23559-3-git-send-email-bruno@thinktube.com>
References: <1196389597-23559-1-git-send-email-bruno@thinktube.com>
 <1196389597-23559-2-git-send-email-bruno@thinktube.com>
 <1196389597-23559-3-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix noise floor calibration by applying AR5K_PHY_NF_AVAL after
AR5K_PHY_NF_RVAL.  that way the XORed mask and value have the same length and
we get a reasonable noise value in -dBm.

move duplicate noise floor calibration code from two different places into one
function ath5k_hw_noise_floor_calibration().

the check for accepted noise_floor values (<= AR5K_TUNE_NOISE_FLOOR) should
only happen when we have an active reading and a converted value, so move it up
into the first if.

Changes-licensed-under: ISC
Signed-off-by: Bruno Randolf <bruno@thinktube.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath5k/ath5k.h |    1 +
 drivers/net/wireless/ath5k/hw.c    |   36 +------------
 drivers/net/wireless/ath5k/phy.c   |  100 ++++++++++++++++++++++++-----------
 3 files changed, 72 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 1b8ddd9..5bcbbf9 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -1127,6 +1127,7 @@ extern int ath5k_hw_phy_disable(struct ath5k_hw *ah);
 extern u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
 extern void ath5k_hw_set_def_antenna(struct ath5k_hw *ah, unsigned int ant);
 extern unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah);
+extern int ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq);
 /* TX power setup */
 extern int ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel, unsigned int txpower);
 extern int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, unsigned int power);
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 752bd6a..83fd241 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -591,7 +591,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 data, s_seq, s_ant, s_led[3];
-	s32 noise_floor;
 	unsigned int i, mode, freq, ee_mode, ant[2], driver_mode = -1;
 	int ret;
 
@@ -914,38 +913,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		return -EAGAIN;
 	}
 
-	/*
-	 * Enable noise floor calibration and wait until completion
-	 */
-	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
-				AR5K_PHY_AGCCTL_NF);
-
-	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
-			AR5K_PHY_AGCCTL_NF, 0, false)) {
-		ATH5K_ERR(ah->ah_sc,
-			"noise floor calibration timeout (%uMHz)\n",
-			channel->freq);
-		return -EAGAIN;
-	}
-
-	/* Wait until the noise floor is calibrated and read the value */
-	for (i = 20; i > 0; i--) {
-		mdelay(1);
-		noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
-
-		if (AR5K_PHY_NF_RVAL(noise_floor) & AR5K_PHY_NF_ACTIVE)
-			noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
-
-		if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
-			break;
-	}
-
-	if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
-		ATH5K_ERR(ah->ah_sc,
-			"noise floor calibration failed (%uMHz)\n",
-			channel->freq);
-		return -EIO;
-	}
+	ret = ath5k_hw_noise_floor_calibration(ah, channel->freq);
+	if (ret)
+		return ret;
 
 	ah->ah_calibration = false;
 
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 3c2a67c..7dba325 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1520,6 +1520,72 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
   PHY calibration
 \*****************/
 
+/**
+ * ath5k_hw_noise_floor_calibration - perform PHY noise floor calibration
+ *
+ * @ah: struct ath5k_hw pointer we are operating on
+ * @freq: the channel frequency, just used for error logging
+ *
+ * This function performs a noise floor calibration of the PHY and waits for
+ * it to complete. Then the noise floor value is compared to some maximum
+ * noise floor we consider valid.
+ *
+ * Note that this is different from what the madwifi HAL does: it reads the
+ * noise floor and afterwards initiates the calibration. Since the noise floor
+ * calibration can take some time to finish, depending on the current channel
+ * use, that avoids the occasional timeout warnings we are seeing now.
+ *
+ * See the following link for an Atheros patent on noise floor calibration:
+ * http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO1&Sect2=HITOFF&d=PALL \
+ * &p=1&u=%2Fnetahtml%2FPTO%2Fsrchnum.htm&r=1&f=G&l=50&s1=7245893.PN.&OS=PN/7
+ *
+ */
+int
+ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq)
+{
+	int ret;
+	unsigned int i;
+	s32 noise_floor;
+
+	/*
+	 * Enable noise floor calibration and wait until completion
+	 */
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
+				AR5K_PHY_AGCCTL_NF);
+
+	ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
+			AR5K_PHY_AGCCTL_NF, 0, false);
+	if (ret) {
+		ATH5K_ERR(ah->ah_sc,
+			"noise floor calibration timeout (%uMHz)\n", freq);
+		return ret;
+	}
+
+	/* Wait until the noise floor is calibrated and read the value */
+	for (i = 20; i > 0; i--) {
+		mdelay(1);
+		noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
+		noise_floor = AR5K_PHY_NF_RVAL(noise_floor);
+		if (noise_floor & AR5K_PHY_NF_ACTIVE) {
+			noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
+
+			if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
+				break;
+		}
+	}
+
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
+		"noise floor %d\n", noise_floor);
+
+	if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
+		ATH5K_ERR(ah->ah_sc,
+			"noise floor calibration failed (%uMHz)\n", freq);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /*
  * Perform a PHY calibration on RF5110
  * -Fix BPSK/QAM Constellation (I/Q correction)
@@ -1529,8 +1595,6 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	u32 phy_sig, phy_agc, phy_sat, beacon;
-	s32 noise_floor;
-	unsigned int i;
 	int ret;
 
 	/*
@@ -1612,37 +1676,9 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 		return ret;
 	}
 
-	/*
-	 * Enable noise floor calibration and wait until completion
-	 */
-	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
-
-	ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
-			AR5K_PHY_AGCCTL_NF, 0, false);
-	if (ret) {
-		ATH5K_ERR(ah->ah_sc,
-			"noise floor calibration timeout (%uMHz)\n",
-			channel->freq);
+	ret = ath5k_hw_noise_floor_calibration(ah, channel->freq);
+	if (ret)
 		return ret;
-	}
-
-	/* Wait until the noise floor is calibrated */
-	for (i = 20; i > 0; i--) {
-		mdelay(1);
-		noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
-
-		if (AR5K_PHY_NF_RVAL(noise_floor) & AR5K_PHY_NF_ACTIVE)
-			noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
-
-		if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
-			break;
-	}
-
-	if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
-		ATH5K_ERR(ah->ah_sc, "noise floor calibration failed (%uMHz)\n",
-			channel->freq);
-		return -EIO;
-	}
 
 	/*
 	 * Re-enable RX/TX and beacons
-- 
1.5.3.4

