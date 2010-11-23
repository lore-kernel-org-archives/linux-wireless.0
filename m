Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57897 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab0KWTuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:50:18 -0500
Received: by eye27 with SMTP id 27so4907992eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:50:16 -0800 (PST)
Date: Tue, 23 Nov 2010 21:49:53 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 28/30] ath5k: Cleanup turbo channel flags
Message-ID: <20101123194953.GB4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Clean up CHANNEL_T(URBO), use AR5K_BWMODE_40MHZ instead

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    9 +--------
 drivers/net/wireless/ath/ath5k/base.c  |    5 -----
 drivers/net/wireless/ath/ath5k/phy.c   |   22 ++++++++--------------
 drivers/net/wireless/ath/ath5k/reset.c |   17 +----------------
 4 files changed, 10 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 385b919..81ad236 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -686,7 +686,6 @@ struct ath5k_gain {
 
 /* channel_flags */
 #define	CHANNEL_CW_INT	0x0008	/* Contention Window interference detected */
-#define	CHANNEL_TURBO	0x0010	/* Turbo Channel */
 #define	CHANNEL_CCK	0x0020	/* CCK channel */
 #define	CHANNEL_OFDM	0x0040	/* OFDM channel */
 #define	CHANNEL_2GHZ	0x0080	/* 2GHz channel. */
@@ -698,16 +697,10 @@ struct ath5k_gain {
 #define	CHANNEL_A	(CHANNEL_5GHZ|CHANNEL_OFDM)
 #define	CHANNEL_B	(CHANNEL_2GHZ|CHANNEL_CCK)
 #define	CHANNEL_G	(CHANNEL_2GHZ|CHANNEL_OFDM)
-#define	CHANNEL_T	(CHANNEL_5GHZ|CHANNEL_OFDM|CHANNEL_TURBO)
-#define	CHANNEL_TG	(CHANNEL_2GHZ|CHANNEL_OFDM|CHANNEL_TURBO)
-#define	CHANNEL_108A	CHANNEL_T
-#define	CHANNEL_108G	CHANNEL_TG
 #define	CHANNEL_X	(CHANNEL_5GHZ|CHANNEL_OFDM|CHANNEL_XR)
 
-#define	CHANNEL_ALL 	(CHANNEL_OFDM|CHANNEL_CCK|CHANNEL_2GHZ|CHANNEL_5GHZ| \
-		CHANNEL_TURBO)
+#define	CHANNEL_ALL	(CHANNEL_OFDM|CHANNEL_CCK|CHANNEL_2GHZ|CHANNEL_5GHZ)
 
-#define	CHANNEL_ALL_NOTURBO 	(CHANNEL_ALL & ~CHANNEL_TURBO)
 #define CHANNEL_MODES		CHANNEL_ALL
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 33cd1bc..8083117 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -364,11 +364,6 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		case AR5K_MODE_11G:
 			channels[count].hw_value = chfreq | CHANNEL_OFDM;
 			break;
-		case AR5K_MODE_11A_TURBO:
-		case AR5K_MODE_11G_TURBO:
-			channels[count].hw_value = chfreq |
-				CHANNEL_OFDM | CHANNEL_TURBO;
-			break;
 		case AR5K_MODE_11B:
 			channels[count].hw_value = CHANNEL_B;
 		}
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 95b602b..61d3800 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1358,12 +1358,10 @@ void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 
 	switch (ah->ah_current_channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
-	case CHANNEL_T:
 	case CHANNEL_XR:
 		ee_mode = AR5K_EEPROM_MODE_11A;
 		break;
 	case CHANNEL_G:
-	case CHANNEL_TG:
 		ee_mode = AR5K_EEPROM_MODE_11G;
 		break;
 	default:
@@ -1946,12 +1944,10 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
-	case CHANNEL_T:
 	case CHANNEL_XR:
 		ee_mode = AR5K_EEPROM_MODE_11A;
 		break;
 	case CHANNEL_G:
-	case CHANNEL_TG:
 		ee_mode = AR5K_EEPROM_MODE_11G;
 		break;
 	case CHANNEL_B:
@@ -2385,20 +2381,20 @@ ath5k_get_max_ctl_power(struct ath5k_hw *ah,
 
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
-		ctl_mode |= AR5K_CTL_11A;
+		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ)
+			ctl_mode |= AR5K_CTL_TURBO;
+		else
+			ctl_mode |= AR5K_CTL_11A;
 		break;
 	case CHANNEL_G:
-		ctl_mode |= AR5K_CTL_11G;
+		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ)
+			ctl_mode |= AR5K_CTL_TURBOG;
+		else
+			ctl_mode |= AR5K_CTL_11G;
 		break;
 	case CHANNEL_B:
 		ctl_mode |= AR5K_CTL_11B;
 		break;
-	case CHANNEL_T:
-		ctl_mode |= AR5K_CTL_TURBO;
-		break;
-	case CHANNEL_TG:
-		ctl_mode |= AR5K_CTL_TURBOG;
-		break;
 	case CHANNEL_XR:
 		/* Fall through */
 	default:
@@ -3210,12 +3206,10 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
-	case CHANNEL_T:
 	case CHANNEL_XR:
 		ee_mode = AR5K_EEPROM_MODE_11A;
 		break;
 	case CHANNEL_G:
-	case CHANNEL_TG:
 		ee_mode = AR5K_EEPROM_MODE_11G;
 		break;
 	case CHANNEL_B:
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 93014fd..418c96b 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -834,7 +834,7 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 		AR5K_PHY_NF_SVAL(ee->ee_noise_floor_thr[ee_mode]),
 		AR5K_PHY_NFTHRES);
 
-	if ((channel->hw_value & CHANNEL_TURBO) &&
+	if ((ah->ah_bwmode == AR5K_BWMODE_40MHZ) &&
 	(ah->ah_ee_version >= AR5K_EEPROM_VERSION_5_0)) {
 		/* Switch settling time (Turbo) */
 		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_SETTLING,
@@ -1019,21 +1019,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		freq = AR5K_INI_RFGAIN_2GHZ;
 		ee_mode = AR5K_EEPROM_MODE_11B;
 		break;
-	case CHANNEL_T:
-		mode = AR5K_MODE_11A_TURBO;
-		freq = AR5K_INI_RFGAIN_5GHZ;
-		ee_mode = AR5K_EEPROM_MODE_11A;
-		break;
-	case CHANNEL_TG:
-		if (ah->ah_version == AR5K_AR5211) {
-			ATH5K_ERR(ah->ah_sc,
-				"TurboG mode not available on 5211");
-			return -EINVAL;
-		}
-		mode = AR5K_MODE_11G_TURBO;
-		freq = AR5K_INI_RFGAIN_2GHZ;
-		ee_mode = AR5K_EEPROM_MODE_11G;
-		break;
 	case CHANNEL_XR:
 		if (ah->ah_version == AR5K_AR5211) {
 			ATH5K_ERR(ah->ah_sc,
