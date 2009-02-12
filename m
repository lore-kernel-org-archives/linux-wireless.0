Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2873 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759062AbZBLSjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 13:39:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/6] ath9k: convert isWwrSKU macro into C code
Date: Thu, 12 Feb 2009 13:38:55 -0500
Message-Id: <1234463938-1350-4-git-send-email-me@bobcopeland.com> (sfid-20090212_193924_745072_BD3758F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Write isWwrSKU as an inline function and nix the camel-case to make
the routine slightly clearer.  Change its argument to take the regd
value directly so it can eventually be used by ath5k as well.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath9k/regd.c |   11 +++++++++--
 drivers/net/wireless/ath9k/regd.h |    5 -----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 9999462..9793515 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -106,6 +106,12 @@ static const struct ieee80211_regdomain ath9k_world_regdom_67_68_6A = {
 	}
 };
 
+static inline bool is_wwr_sku(u16 regd)
+{
+	return ((regd & WORLD_SKU_MASK) == WORLD_SKU_PREFIX) ||
+		(regd == WORLD);
+}
+
 static u16 ath9k_regd_get_eepromRD(struct ath_hw *ah)
 {
 	return ah->regulatory.current_rd & ~WORLDWIDE_ROAMING_FLAG;
@@ -118,7 +124,7 @@ u16 ath9k_regd_get_rd(struct ath_hw *ah)
 
 bool ath9k_is_world_regd(struct ath_hw *ah)
 {
-	return isWwrSKU(ah);
+	return is_wwr_sku(ath9k_regd_get_eepromRD(ah));
 }
 
 const struct ieee80211_regdomain *ath9k_default_world_regdomain(void)
@@ -463,7 +469,8 @@ u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan)
 	u32 ctl = NO_CTL;
 
 	if (!ah->regulatory.regpair ||
-	    (ah->regulatory.country_code == CTRY_DEFAULT && isWwrSKU(ah))) {
+	    (ah->regulatory.country_code == CTRY_DEFAULT &&
+	     is_wwr_sku(ath9k_regd_get_eepromRD(ah)))) {
 		if (IS_CHAN_B(chan))
 			ctl = SD_NO_CTL | CTL_11B;
 		else if (IS_CHAN_G(chan))
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 53a9f46..8f0bfcc 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -20,11 +20,6 @@
 #define COUNTRY_ERD_FLAG        0x8000
 #define WORLDWIDE_ROAMING_FLAG  0x4000
 
-#define isWwrSKU(_ah) \
-	(((ath9k_regd_get_eepromRD((_ah)) & WORLD_SKU_MASK) == \
-		WORLD_SKU_PREFIX) || \
-		(ath9k_regd_get_eepromRD(_ah) == WORLD))
-
 #define MULTI_DOMAIN_MASK 0xFF00
 
 #define WORLD_SKU_MASK          0x00F0
-- 
1.6.0.6


