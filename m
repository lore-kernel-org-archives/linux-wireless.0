Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:45640 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379AbZDPA1G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 20:27:06 -0400
Date: Thu, 16 Apr 2009 03:27:14 +0300
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Cc: jirislaby@gmail.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: [PATCH 3/7] ath5k: Put remaining EEPROM data on ee struct
Message-ID: <20090416002714.GC4138@makis> (sfid-20090416_022712_845316_CE6CE947)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Put remaining EEPROM information on ee struct and remove is_hb63 function.

 Now we also have rfkill stuff available.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/eeprom.c |   24 +++++++++++-------------
 drivers/net/wireless/ath/ath5k/eeprom.h |   15 ++++++++++-----
 drivers/net/wireless/ath/ath5k/reset.c  |    5 +++--
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index d204546..cadcdae 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -156,6 +156,17 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 		ee->ee_db[AR5K_EEPROM_MODE_11G][0] = (val >> 3) & 0x7;
 	}
 
+	AR5K_EEPROM_READ(AR5K_EEPROM_IS_HB63, val);
+
+	if ((ah->ah_mac_version == (AR5K_SREV_AR2425 >> 4)) && val)
+		ee->ee_is_hb63 = true;
+	else
+		ee->ee_is_hb63 = false;
+
+	AR5K_EEPROM_READ(AR5K_EEPROM_RFKILL, val);
+	ee->ee_rfkill_pin = (u8) AR5K_REG_MS(val, AR5K_EEPROM_RFKILL_GPIO_SEL);
+	ee->ee_rfkill_pol = val & AR5K_EEPROM_RFKILL_POLARITY ? true : false;
+
 	return 0;
 }
 
@@ -1789,16 +1800,3 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 
 	return 0;
 }
-
-bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah)
-{
-	u16 data;
-
-	ath5k_hw_eeprom_read(ah, AR5K_EEPROM_IS_HB63, &data);
-
-	if ((ah->ah_mac_version == (AR5K_SREV_AR2425 >> 4)) && data)
-		return true;
-	else
-		return false;
-}
-
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index df9ffa0..46e4d22 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -26,6 +26,13 @@
 #define AR5K_EEPROM_MAGIC_5210		0x0000145a /* 5210 */
 
 #define	AR5K_EEPROM_IS_HB63		0x000b	/* Talon detect */
+
+#define AR5K_EEPROM_RFKILL		0x0f
+#define AR5K_EEPROM_RFKILL_GPIO_SEL	0x0000001c
+#define AR5K_EEPROM_RFKILL_GPIO_SEL_S	2
+#define AR5K_EEPROM_RFKILL_POLARITY	0x00000002
+#define AR5K_EEPROM_RFKILL_POLARITY_S	1
+
 #define AR5K_EEPROM_REG_DOMAIN		0x00bf	/* EEPROM regdom */
 #define AR5K_EEPROM_CHECKSUM		0x00c0	/* EEPROM checksum */
 #define AR5K_EEPROM_INFO_BASE		0x00c0	/* EEPROM header */
@@ -66,11 +73,6 @@
 #define AR5K_EEPROM_HDR_RFKILL(_v)	(((_v) >> 14) & 0x1)	/* Device has RFKill support */
 #define AR5K_EEPROM_HDR_T_5GHZ_DIS(_v)	(((_v) >> 15) & 0x1)	/* Disable turbo for 5Ghz */
 
-#define AR5K_EEPROM_RFKILL_GPIO_SEL	0x0000001c
-#define AR5K_EEPROM_RFKILL_GPIO_SEL_S	2
-#define AR5K_EEPROM_RFKILL_POLARITY	0x00000002
-#define AR5K_EEPROM_RFKILL_POLARITY_S	1
-
 /* Newer EEPROMs are using a different offset */
 #define AR5K_EEPROM_OFF(_v, _v3_0, _v3_3) \
 	(((_v) >= AR5K_EEPROM_VERSION_3_3) ? _v3_3 : _v3_0)
@@ -386,6 +388,9 @@ struct ath5k_eeprom_info {
 	u16	ee_version;
 	u16	ee_header;
 	u16	ee_ant_gain;
+	u8	ee_rfkill_pin;
+	bool	ee_rfkill_pol;
+	bool	ee_is_hb63;
 	u16	ee_misc0;
 	u16	ee_misc1;
 	u16	ee_misc2;
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 23d6fc8..9e5c4b4 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -508,7 +508,7 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 
 		if (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))
 			scal = AR5K_PHY_SCAL_32MHZ_2417;
-		else if (ath5k_eeprom_is_hb63(ah))
+		else if (ee->ee_is_hb63)
 			scal = AR5K_PHY_SCAL_32MHZ_HB63;
 		else
 			scal = AR5K_PHY_SCAL_32MHZ;
@@ -599,9 +599,10 @@ static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 	/* Set DAC/ADC delays */
 	if (ah->ah_version == AR5K_AR5212) {
 		u32 scal;
+		struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 		if (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))
 			scal = AR5K_PHY_SCAL_32MHZ_2417;
-		else if (ath5k_eeprom_is_hb63(ah))
+		else if (ee->ee_is_hb63)
 			scal = AR5K_PHY_SCAL_32MHZ_HB63;
 		else
 			scal = AR5K_PHY_SCAL_32MHZ;
