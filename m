Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41428 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZFBUay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:30:54 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath: make regulatory parsing more verbose on debug
Date: Tue,  2 Jun 2009 16:30:56 -0400
Message-Id: <1243974656-15600-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should help when reviewing issues regarding regulatory
domain on ath5k/ath9k/ar9170.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/regd.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 7a89f9f..eef370b 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -366,11 +366,17 @@ static bool ath_regd_is_eeprom_valid(struct ath_regulatory *reg)
 	if (rd & COUNTRY_ERD_FLAG) {
 		/* EEPROM value is a country code */
 		u16 cc = rd & ~COUNTRY_ERD_FLAG;
+		printk(KERN_DEBUG
+		       "ath: EEPROM indicates we should expect "
+			"a country code\n");
 		for (i = 0; i < ARRAY_SIZE(allCountries); i++)
 			if (allCountries[i].countryCode == cc)
 				return true;
 	} else {
 		/* EEPROM value is a regpair value */
+		if (rd != CTRY_DEFAULT)
+			printk(KERN_DEBUG "ath: EEPROM indicates we "
+			       "should expect a direct regpair map\n");
 		for (i = 0; i < ARRAY_SIZE(regDomainPairs); i++)
 			if (regDomainPairs[i].regDmnEnum == rd)
 				return true;
@@ -477,6 +483,11 @@ ath_regd_init(struct ath_regulatory *reg,
 	struct country_code_to_enum_rd *country = NULL;
 	u16 regdmn;
 
+	if (!reg)
+		return -EINVAL;
+
+	printk(KERN_DEBUG "ath: EEPROM regdomain: 0x%0x\n", reg->current_rd);
+
 	if (!ath_regd_is_eeprom_valid(reg)) {
 		printk(KERN_ERR "ath: Invalid EEPROM contents\n");
 		return -EINVAL;
@@ -486,20 +497,30 @@ ath_regd_init(struct ath_regulatory *reg,
 	reg->country_code = ath_regd_get_default_country(regdmn);
 
 	if (reg->country_code == CTRY_DEFAULT &&
-	    regdmn == CTRY_DEFAULT)
+	    regdmn == CTRY_DEFAULT) {
+		printk(KERN_DEBUG "ath: EEPROM indicates default "
+		       "country code should be used\n");
 		reg->country_code = CTRY_UNITED_STATES;
+	}
 
 	if (reg->country_code == CTRY_DEFAULT) {
 		country = NULL;
 	} else {
+		printk(KERN_DEBUG "ath: doing EEPROM country->regdmn "
+		       "map search\n");
 		country = ath_regd_find_country(reg->country_code);
 		if (country == NULL) {
 			printk(KERN_DEBUG
-				"ath: Country is NULL!!!!, cc= %d\n",
+				"ath: no valid country maps found for "
+				"country code: 0x%0x\n",
 				reg->country_code);
 			return -EINVAL;
-		} else
+		} else {
 			regdmn = country->regDmnEnum;
+			printk(KERN_DEBUG "ath: country maps to "
+			       "regdmn code: 0x%0x\n",
+			       regdmn);
+		}
 	}
 
 	reg->regpair = ath_get_regpair(regdmn);
@@ -523,7 +544,7 @@ ath_regd_init(struct ath_regulatory *reg,
 
 	printk(KERN_DEBUG "ath: Country alpha2 being used: %c%c\n",
 		reg->alpha2[0], reg->alpha2[1]);
-	printk(KERN_DEBUG "ath: Regpair detected: 0x%0x\n",
+	printk(KERN_DEBUG "ath: Regpair used: 0x%0x\n",
 		reg->regpair->regDmnEnum);
 
 	ath_regd_init_wiphy(reg, wiphy, reg_notifier);
-- 
1.6.0.6

