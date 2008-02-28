Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:45275 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbYB1XA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 18:00:28 -0500
Date: Thu, 28 Feb 2008 18:00:24 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	me@bobcopeland.com
Subject: [PATCH 7/8] ath5k: Minor code review to match regdumps
Message-ID: <3d16ff86ebf71f749d3cc0b4219ebe89c0e4585d.1204236793.git.mcgrof@winlab.rutgers.edu> (sfid-20080228_230036_648806_175183E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6d5bb6d43d1ddfb60d5ed8b8d6ee472643eafd8.1204236793.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make some changes which mimic what we see in register dumps. Also,
lets move ar5212 initial settings out into a helper during reset
to make code more readible.

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/hw.c |   66 +++++++++++++++++++++++++++++---------
 1 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 6f69e46..b8e412c 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -589,6 +589,38 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
 }
 
 /*
+ * ath5k_hw_reset_ar5212 - reset helper for ar5212
+ *
+ * @ah: the &struct ath5k_hw
+ * @channel: the &ieee80211_channel
+ *
+ * This is a helper to ath5k_hw_reset() for AR5212.
+ */
+static inline void ath5k_hw_reset_init_ar5212(struct ath5k_hw *ah,
+	struct ieee80211_channel *channel)
+{
+	ath5k_hw_reg_write(ah, 0x0002a002, AR5K_PHY(11));
+
+	if ((channel->hw_value & CHANNEL_MODES) == CHANNEL_G) {
+		if (ah->ah_mac_srev < AR5K_SREV_VER_AR2413)
+			ath5k_hw_reg_write(ah, 0x00f80d80, AR5K_PHY(83));
+		else if (ah->ah_mac_srev < AR5K_SREV_VER_AR2424)
+			ath5k_hw_reg_write(ah, 0x00380140, AR5K_PHY(83));
+		else if (ah->ah_mac_srev < AR5K_SREV_VER_AR2425)
+			ath5k_hw_reg_write(ah, 0x00fc0ec0, AR5K_PHY(83));
+		else
+			/* 2425 */
+			ath5k_hw_reg_write(ah, 0x00fc0fc0, AR5K_PHY(83));
+	} else
+		ath5k_hw_reg_write(ah, 0x00000000, AR5K_PHY(83));
+
+	ath5k_hw_reg_write(ah, 0x000009b5, 0xa228);
+	ath5k_hw_reg_write(ah, 0x0000000f, 0x8060);
+	ath5k_hw_reg_write(ah, 0x00000000, 0xa254);
+	ath5k_hw_reg_write(ah, 0x0000000e, AR5K_PHY_SCAL);
+}
+
+/*
  * Main reset function
  */
 int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
@@ -724,20 +756,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		/*
 		 * Write some more initial register settings
 		 */
-		if (ah->ah_version > AR5K_AR5211){ /* found on 5213+ */
-			ath5k_hw_reg_write(ah, 0x0002a002, AR5K_PHY(11));
-
-			if (channel->hw_value == CHANNEL_G)
-				ath5k_hw_reg_write(ah, 0x00f80d80, AR5K_PHY(83)); /* 0x00fc0ec0 */
-			else
-				ath5k_hw_reg_write(ah, 0x00000000, AR5K_PHY(83));
-
-			ath5k_hw_reg_write(ah, 0x000001b5, 0xa228); /* 0x000009b5 */
-			ath5k_hw_reg_write(ah, 0x000009b5, 0xa228);
-			ath5k_hw_reg_write(ah, 0x0000000f, 0x8060);
-			ath5k_hw_reg_write(ah, 0x00000000, 0xa254);
-			ath5k_hw_reg_write(ah, 0x0000000e, AR5K_PHY_SCAL);
-		}
+		if (ah->ah_version == AR5K_AR5212)
+			ath5k_hw_reset_init_ar5212(ah, channel);
 
 		/* Fix for first revision of the RF5112 RF chipset */
 		if (ah->ah_radio >= AR5K_RF5112 &&
@@ -1015,6 +1035,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 	/*
 	 * Set the 32MHz reference clock on 5212 phy clock sleep register
+	 *
+	 * TODO: Find out how to switch to external 32Khz clock to save power
 	 */
 	if (ah->ah_version == AR5K_AR5212) {
 		ath5k_hw_reg_write(ah, AR5K_PHY_SCR_32MHZ, AR5K_PHY_SCR);
@@ -1025,6 +1047,14 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		ath5k_hw_reg_write(ah, ah->ah_phy_spending, AR5K_PHY_SPENDING);
 	}
 
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(ah, 0x000100aa, 0x8118);
+		ath5k_hw_reg_write(ah, 0x00003210, 0x811c);
+		ath5k_hw_reg_write(ah, 0x00000052, 0x8108);
+		if (ah->ah_mac_srev >= AR5K_SREV_VER_AR2413)
+			ath5k_hw_reg_write(ah, 0x00000004, 0x8120);
+	}
+
 	/*
 	 * Disable beacons and reset the register
 	 */
@@ -2269,8 +2299,8 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	 * Set simple BSSID mask on 5212
 	 */
 	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, 0xfffffff, AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(ah, 0xfffffff, AR5K_BSS_IDM1);
+		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_BSS_IDM0);
+		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_BSS_IDM1);
 	}
 
 	/*
@@ -2415,6 +2445,8 @@ void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
 	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+
+	/* TODO: ANI Support */
 }
 
 /*
@@ -2424,6 +2456,8 @@ void ath5k_hw_stop_pcu_recv(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
 	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+
+	/* TODO: ANI Support */
 }
 
 /*
-- 
1.5.3.7

