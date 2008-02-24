Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:40284 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbYBXEb7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 23:31:59 -0500
Date: Sun, 24 Feb 2008 06:31:41 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 7/8] ath5k: Minor code review to match regdumps
Message-ID: <20080224043141.GF4426@makis.domain.invalid> (sfid-20080224_043202_711635_CEF862CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 * Make some changes to follow register dumps.

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index cd640ed..adcce6f 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -727,15 +727,23 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		/*
 		 * Write some more initial register settings
 		 */
-		if (ah->ah_version > AR5K_AR5211){ /* found on 5213+ */
+		if (ah->ah_version == AR5K_AR5212){
 			ath5k_hw_reg_write(ah, 0x0002a002, AR5K_PHY(11));
 
 			if (channel->hw_value == CHANNEL_G)
-				ath5k_hw_reg_write(ah, 0x00f80d80, AR5K_PHY(83)); /* 0x00fc0ec0 */
+				if (ah->ah_mac_srev < AR5K_SREV_VER_AR2413) {
+					ath5k_hw_reg_write(ah, 0x00f80d80, AR5K_PHY(83));
+				} else if (ah->ah_mac_srev < AR5K_SREV_VER_AR2424) {	 
+					ath5k_hw_reg_write(ah, 0x00380140, AR5K_PHY(83));
+				} else if (ah->ah_mac_srev < AR5K_SREV_VER_AR2425) {
+					ath5k_hw_reg_write(ah, 0x00fc0ec0, AR5K_PHY(83));
+				} else {
+					/* 2425 */
+					ath5k_hw_reg_write(ah, 0x00fc0fc0, AR5K_PHY(83));
+				}
 			else
 				ath5k_hw_reg_write(ah, 0x00000000, AR5K_PHY(83));
 
-			ath5k_hw_reg_write(ah, 0x000001b5, 0xa228); /* 0x000009b5 */
 			ath5k_hw_reg_write(ah, 0x000009b5, 0xa228);
 			ath5k_hw_reg_write(ah, 0x0000000f, 0x8060);
 			ath5k_hw_reg_write(ah, 0x00000000, 0xa254);
@@ -1019,6 +1027,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 	/*
 	 * Set the 32MHz reference clock on 5212 phy clock sleep register
+	 *
+	 * TODO: Find out how to switch to external 32Khz clock to save power
 	 */
 	if (ah->ah_version == AR5K_AR5212) {
 		ath5k_hw_reg_write(ah, AR5K_PHY_SCR_32MHZ, AR5K_PHY_SCR);
@@ -1029,6 +1039,14 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
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
@@ -2273,8 +2291,8 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	 * Set simple BSSID mask on 5212
 	 */
 	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, 0xfffffff, AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(ah, 0xfffffff, AR5K_BSS_IDM1);
+		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_BSS_IDM0);
+		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_BSS_IDM1);
 	}
 
 	/*
@@ -2419,6 +2437,8 @@ void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
 	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+
+	/* TODO: ANI Support */
 }
 
 /*
@@ -2428,6 +2448,8 @@ void ath5k_hw_stop_pcu_recv(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
 	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+
+	/* TODO: ANI Support */
 }
 
 /*


