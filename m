Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:3596 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751385Ab0FGELT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 00:11:19 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0336803878
	for <linux-wireless@vger.kernel.org>; Mon,  7 Jun 2010 13:11:18 +0900 (JST)
Subject: [PATCH 3/5] ath5k: new function for setting the antenna switch table
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 07 Jun 2010 13:11:30 +0900
Message-ID: <20100607041130.18667.37656.stgit@tt-desk>
In-Reply-To: <20100607041012.18667.6859.stgit@tt-desk>
References: <20100607041012.18667.6859.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Collect all pieces concering the antenna switch table into one function.
Previously it was split up between ath5k_hw_reset() and
ath5k_hw_commit_eeprom_settings().

Also we need to set the antenna switch table when ath5k_hw_set_antenna_mode()
is called manually (by "iw phy0 antenna set", for example).

I'm not sure if we need to set the switchtable at the same place in
ath5k_hw_reset() as it was before - it is set later thru
ath5k_hw_set_antenna_mode() anyways - but i leave it there to avoid
problems(?).

Plus print switchtable registers in the debugfs file.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    1 +
 drivers/net/wireless/ath/ath5k/debug.c |    7 +++++++
 drivers/net/wireless/ath/ath5k/phy.c   |   32 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/reset.c |   33 ++++++--------------------------
 4 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index eace74d..cf16318 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1286,6 +1286,7 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
 int ath5k_hw_phy_disable(struct ath5k_hw *ah);
 /* Antenna control */
 void ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode);
+void ath5k_hw_set_antenna_switch(struct ath5k_hw *ah, u8 ee_mode);
 /* TX power setup */
 int ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		     u8 ee_mode, u8 txpower);
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index c58503c..41817a2 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -425,6 +425,13 @@ static ssize_t read_file_antenna(struct file *file, char __user *user_buf,
 		"AR5K_PHY_FAST_ANT_DIV_EN\t%d\n",
 		(v & AR5K_PHY_FAST_ANT_DIV_EN) != 0);
 
+	v = ath5k_hw_reg_read(sc->ah, AR5K_PHY_ANT_SWITCH_TABLE_0);
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"\nAR5K_PHY_ANT_SWITCH_TABLE_0\t0x%08x\n", v);
+	v = ath5k_hw_reg_read(sc->ah, AR5K_PHY_ANT_SWITCH_TABLE_1);
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"AR5K_PHY_ANT_SWITCH_TABLE_1\t0x%08x\n", v);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 0f3b9be..73c4fcd 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1781,6 +1781,37 @@ ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, bool enable)
 	}
 }
 
+void
+ath5k_hw_set_antenna_switch(struct ath5k_hw *ah, u8 ee_mode)
+{
+	u8 ant0, ant1;
+
+	/*
+	 * In case a fixed antenna was set as default
+	 * use the same switch table twice.
+	 */
+	if (ah->ah_ant_mode == AR5K_ANTMODE_FIXED_A)
+		ant0 = ant1 = AR5K_ANT_SWTABLE_A;
+	else if (ah->ah_ant_mode == AR5K_ANTMODE_FIXED_B)
+		ant0 = ant1 = AR5K_ANT_SWTABLE_B;
+	else {
+		ant0 = AR5K_ANT_SWTABLE_A;
+		ant1 = AR5K_ANT_SWTABLE_B;
+	}
+
+	/* Set antenna idle switch table */
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_ANT_CTL,
+			AR5K_PHY_ANT_CTL_SWTABLE_IDLE,
+			(ah->ah_ant_ctl[ee_mode][AR5K_ANT_CTL] |
+			AR5K_PHY_ANT_CTL_TXRX_EN));
+
+	/* Set antenna switch tables */
+	ath5k_hw_reg_write(ah, ah->ah_ant_ctl[ee_mode][ant0],
+		AR5K_PHY_ANT_SWITCH_TABLE_0);
+	ath5k_hw_reg_write(ah, ah->ah_ant_ctl[ee_mode][ant1],
+		AR5K_PHY_ANT_SWITCH_TABLE_1);
+}
+
 /*
  * Set antenna operating mode
  */
@@ -1900,6 +1931,7 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 	if (sta_id1)
 		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1, sta_id1);
 
+	ath5k_hw_set_antenna_switch(ah, ee_mode);
 	/* Note: set diversity before default antenna
 	 * because it won't work correctly */
 	ath5k_hw_set_fast_div(ah, ee_mode, fast_div);
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index c17c84e..d561f7c 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -729,7 +729,7 @@ static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 }
 
 static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
-		struct ieee80211_channel *channel, u8 *ant, u8 ee_mode)
+		struct ieee80211_channel *channel, u8 ee_mode)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	s16 cck_ofdm_pwr_delta;
@@ -763,17 +763,9 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 						ee->ee_cck_ofdm_gain_delta;
 	}
 
-	/* Set antenna idle switch table */
-	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_ANT_CTL,
-			AR5K_PHY_ANT_CTL_SWTABLE_IDLE,
-			(ah->ah_ant_ctl[ee_mode][0] |
-			AR5K_PHY_ANT_CTL_TXRX_EN));
-
-	/* Set antenna switch tables */
-	ath5k_hw_reg_write(ah, ah->ah_ant_ctl[ee_mode][ant[0]],
-		AR5K_PHY_ANT_SWITCH_TABLE_0);
-	ath5k_hw_reg_write(ah, ah->ah_ant_ctl[ee_mode][ant[1]],
-		AR5K_PHY_ANT_SWITCH_TABLE_1);
+	/* XXX: necessary here? is called from ath5k_hw_set_antenna_mode()
+	 * too */
+	ath5k_hw_set_antenna_switch(ah, ee_mode);
 
 	/* Noise floor threshold */
 	ath5k_hw_reg_write(ah,
@@ -887,7 +879,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	struct ath_common *common = ath5k_hw_common(ah);
 	u32 s_seq[10], s_ant, s_led[3], staid1_flags, tsf_up, tsf_lo;
 	u32 phy_tst1;
-	u8 mode, freq, ee_mode, ant[2];
+	u8 mode, freq, ee_mode;
 	int i, ret;
 
 	s_ant = 0;
@@ -1110,21 +1102,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 				    AR5K_TXCFG_B_MODE);
 		}
 
-		/*
-		 * In case a fixed antenna was set as default
-		 * use the same switch table twice.
-		 */
-		if (ah->ah_ant_mode == AR5K_ANTMODE_FIXED_A)
-				ant[0] = ant[1] = AR5K_ANT_SWTABLE_A;
-		else if (ah->ah_ant_mode == AR5K_ANTMODE_FIXED_B)
-				ant[0] = ant[1] = AR5K_ANT_SWTABLE_B;
-		else {
-			ant[0] = AR5K_ANT_SWTABLE_A;
-			ant[1] = AR5K_ANT_SWTABLE_B;
-		}
-
 		/* Commit values from EEPROM */
-		ath5k_hw_commit_eeprom_settings(ah, channel, ant, ee_mode);
+		ath5k_hw_commit_eeprom_settings(ah, channel, ee_mode);
 
 	} else {
 		/*

