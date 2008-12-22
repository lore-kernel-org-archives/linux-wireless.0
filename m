Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:35909 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYLVKf6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 05:35:58 -0500
Date: Mon, 22 Dec 2008 12:35:55 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: [PATCH] ath5k: More EEPROM code updates
Message-ID: <20081222103554.GA19438@makis> (sfid-20081222_113602_097150_040D2230)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Don't scale power values on RF5111 EEPROMs because they get out of bounds (power is u8, so multiplying power by 50 is too much and there is no 
reason to do so -we don't do it on other chips anyway-). HAL does it as a technique to handle 0.5 dbm steps but i believe it's not the right thing to 
do and certainly not the right place to do it. We 'll work this out on interpolation code for all chips (0.5 or 0.25 steps etc) in a generic way.

 Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/eeprom.c b/drivers/net/wireless/ath5k/eeprom.c
index 079e9ca..b4ec539 100644
--- a/drivers/net/wireless/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath5k/eeprom.c
@@ -665,7 +665,7 @@ ath5k_eeprom_read_pcal_info_5111(struct ath5k_hw *ah, int mode)
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	struct ath5k_chan_pcal_info *pcal;
 	int offset, ret;
-	int i, j;
+	int i;
 	u16 val;
 
 	offset = AR5K_EEPROM_GROUPS_START(ee->ee_version);
@@ -745,11 +745,6 @@ ath5k_eeprom_read_pcal_info_5111(struct ath5k_hw *ah, int mode)
 
 		ath5k_get_pcdac_intercepts(ah, cdata->pcdac_min,
 			cdata->pcdac_max, cdata->pcdac);
-
-		for (j = 0; j < AR5K_EEPROM_N_PCDAC; j++) {
-			cdata->pwr[j] = (u16)
-				(AR5K_EEPROM_POWER_STEP * cdata->pwr[j]);
-		}
 	}
 
 	return 0;

