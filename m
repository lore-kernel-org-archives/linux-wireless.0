Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38727 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab2DPTu7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:50:59 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] ath9k: move ath9k_hw_fbin2freq function to eeprom.h
Date: Mon, 16 Apr 2012 22:46:31 +0200
Message-Id: <1334609192-26412-1-git-send-email-juhosg@openwrt.org> (sfid-20120416_215103_053588_4A7DA9DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both eeprom.c and ar9003_eeprom.c has an indentical
'ath9k_hw_fbin2freq' function. Move the function to
a common place and remove the duplicates.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    9 ---------
 drivers/net/wireless/ath/ath9k/eeprom.c        |    8 --------
 drivers/net/wireless/ath/ath9k/eeprom.h        |    8 ++++++++
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 672b6c9..122a066 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -2936,15 +2936,6 @@ static const struct ar9300_eeprom *ar9003_eeprom_struct_find_by_id(int id)
 #undef N_LOOP
 }
 
-
-static u16 ath9k_hw_fbin2freq(u8 fbin, bool is2GHz)
-{
-	if (fbin == AR5416_BCHAN_UNUSED)
-		return fbin;
-
-	return (u16) ((is2GHz) ? (2300 + fbin) : (4800 + 5 * fbin));
-}
-
 static int ath9k_hw_ar9300_check_eeprom(struct ath_hw *ah)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index c435232..ef174e3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -16,14 +16,6 @@
 
 #include "hw.h"
 
-static inline u16 ath9k_hw_fbin2freq(u8 fbin, bool is2GHz)
-{
-	if (fbin == AR5416_BCHAN_UNUSED)
-		return fbin;
-
-	return (u16) ((is2GHz) ? (2300 + fbin) : (4800 + 5 * fbin));
-}
-
 void ath9k_hw_analog_shift_regwrite(struct ath_hw *ah, u32 reg, u32 val)
 {
         REG_WRITE(ah, reg, val);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 5ff7ab9..fc13e63 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -697,6 +697,14 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 				u16 *pPdGainBoundaries, u8 *pPDADCValues,
 				u16 numXpdGains);
 
+static inline u16 ath9k_hw_fbin2freq(u8 fbin, bool is2GHz)
+{
+	if (fbin == AR5416_BCHAN_UNUSED)
+		return fbin;
+
+	return (u16) ((is2GHz) ? (2300 + fbin) : (4800 + 5 * fbin));
+}
+
 #define ar5416_get_ntxchains(_txchainmask)			\
 	(((_txchainmask >> 2) & 1) +                            \
 	 ((_txchainmask >> 1) & 1) + (_txchainmask & 1))
-- 
1.7.2.1

