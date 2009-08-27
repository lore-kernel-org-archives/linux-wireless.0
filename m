Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27839 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbZH0CaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 22:30:02 -0400
Subject: [PATCH 1/2] ath5k: fix uninitialized value use in
	ath5k_eeprom_read_turbo_modes()
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 26 Aug 2009 22:30:00 -0400
Message-ID: <20090827023000.21926.90867.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The `val' variable in ath5k_eeprom_read_turbo_modes() is used
uninitialized.  gcc 4.4.1 with -fno-inline-functions-called-once reports
it:

eeprom.c: In function 'ath5k_eeprom_read_turbo_modes':
eeprom.c:441: warning: 'val' may be used uninitialized in this function

Comparing the code to the Atheros HAL, it's clear that the split between
ath5k_eeprom_read_modes() and ath5k_eeprom_read_turbo_modes() was
incorrect.

The Atheros HAL reads both turbo and non-turbo data from EEPROM in one
function.  Some turbo mode parameters are derived from the same EEPROM
values as non-turbo parameters, just from different bits.

Merge ath5k_eeprom_read_turbo_modes() into ath5k_eeprom_read_modes() to
fix the warning.  The actual values and offsets have been cross-checked
against Atheros HAL.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/eeprom.c |   29 +++++------------------------
 1 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 8af477d..644962a 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -414,27 +414,11 @@ static int ath5k_eeprom_read_modes(struct ath5k_hw *ah, u32 *offset,
 		break;
 	}
 
-done:
-	/* return new offset */
-	*offset = o;
-
-	return 0;
-}
-
-/*
- * Read turbo mode information on newer EEPROM versions
- */
-static int
-ath5k_eeprom_read_turbo_modes(struct ath5k_hw *ah,
-			      u32 *offset, unsigned int mode)
-{
-	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	u32 o = *offset;
-	u16 val;
-	int ret;
-
+	/*
+	 * Read turbo mode information on newer EEPROM versions
+	 */
 	if (ee->ee_version < AR5K_EEPROM_VERSION_5_0)
-		return 0;
+		goto done;
 
 	switch (mode){
 	case AR5K_EEPROM_MODE_11A:
@@ -468,6 +452,7 @@ ath5k_eeprom_read_turbo_modes(struct ath5k_hw *ah,
 		break;
 	}
 
+done:
 	/* return new offset */
 	*offset = o;
 
@@ -504,10 +489,6 @@ ath5k_eeprom_init_modes(struct ath5k_hw *ah)
 		ret = ath5k_eeprom_read_modes(ah, &offset, mode);
 		if (ret)
 			return ret;
-
-		ret = ath5k_eeprom_read_turbo_modes(ah, &offset, mode);
-		if (ret)
-			return ret;
 	}
 
 	/* override for older eeprom versions for better performance */
