Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2868 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbZBLSjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 13:39:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/6] ath9k: save a few calls to ath9k_regd_get_eepromRD
Date: Thu, 12 Feb 2009 13:38:54 -0500
Message-Id: <1234463938-1350-3-git-send-email-me@bobcopeland.com> (sfid-20090212_193916_216642_CD21EBD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we already have a stack variable to track the eeprom regd,
we can grab it up front it and save three calls to fetch it again.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath9k/regd.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 0c632ff..9999462 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -371,11 +371,8 @@ ath9k_regd_find_country_by_rd(int regdmn)
 }
 
 /* Returns the map of the EEPROM set RD to a country code */
-static u16 ath9k_regd_get_default_country(struct ath_hw *ah)
+static u16 ath9k_regd_get_default_country(u16 rd)
 {
-	u16 rd;
-
-	rd = ath9k_regd_get_eepromRD(ah);
 	if (rd & COUNTRY_ERD_FLAG) {
 		struct country_code_to_enum_rd *country = NULL;
 		u16 cc = rd & ~COUNTRY_ERD_FLAG;
@@ -405,7 +402,7 @@ ath9k_get_regpair(int regdmn)
 int ath9k_regd_init(struct ath_hw *ah)
 {
 	struct country_code_to_enum_rd *country = NULL;
-	int regdmn;
+	u16 regdmn;
 
 	if (!ath9k_regd_is_eeprom_valid(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
@@ -413,14 +410,14 @@ int ath9k_regd_init(struct ath_hw *ah)
 		return -EINVAL;
 	}
 
-	ah->regulatory.country_code = ath9k_regd_get_default_country(ah);
+	regdmn = ath9k_regd_get_eepromRD(ah);
+	ah->regulatory.country_code = ath9k_regd_get_default_country(regdmn);
 
 	if (ah->regulatory.country_code == CTRY_DEFAULT &&
-	    ath9k_regd_get_eepromRD(ah) == CTRY_DEFAULT)
+	    regdmn == CTRY_DEFAULT)
 		ah->regulatory.country_code = CTRY_UNITED_STATES;
 
 	if (ah->regulatory.country_code == CTRY_DEFAULT) {
-		regdmn = ath9k_regd_get_eepromRD(ah);
 		country = NULL;
 	} else {
 		country = ath9k_regd_find_country(ah->regulatory.country_code);
-- 
1.6.0.6


