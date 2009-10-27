Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:36228 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbZJ0F5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 01:57:42 -0400
Received: by ywh40 with SMTP id 40so8981906ywh.33
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 22:57:47 -0700 (PDT)
Date: Tue, 27 Oct 2009 11:27:31 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Updates for regulatory and country codes.
Message-ID: <20091027055731.GA6153@vivek-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a few new country codes and update the regulatory domain for some
countries.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/regd.h        |    8 ++++++++
 drivers/net/wireless/ath/regd_common.h |   32 ++++++++++++++++++++------------
 2 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index c1dd857..a1c3952 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -65,10 +65,13 @@ enum CountryCode {
 	CTRY_ALGERIA = 12,
 	CTRY_ARGENTINA = 32,
 	CTRY_ARMENIA = 51,
+	CTRY_ARUBA = 533,
 	CTRY_AUSTRALIA = 36,
 	CTRY_AUSTRIA = 40,
 	CTRY_AZERBAIJAN = 31,
 	CTRY_BAHRAIN = 48,
+	CTRY_BANGLADESH = 50,
+	CTRY_BARBADOS = 52,
 	CTRY_BELARUS = 112,
 	CTRY_BELGIUM = 56,
 	CTRY_BELIZE = 84,
@@ -77,6 +80,7 @@ enum CountryCode {
 	CTRY_BRAZIL = 76,
 	CTRY_BRUNEI_DARUSSALAM = 96,
 	CTRY_BULGARIA = 100,
+	CTRY_CAMBODIA = 116,
 	CTRY_CANADA = 124,
 	CTRY_CHILE = 152,
 	CTRY_CHINA = 156,
@@ -97,7 +101,11 @@ enum CountryCode {
 	CTRY_GEORGIA = 268,
 	CTRY_GERMANY = 276,
 	CTRY_GREECE = 300,
+	CTRY_GREENLAND = 304,
+	CTRY_GRENEDA = 308,
+	CTRY_GUAM = 316,
 	CTRY_GUATEMALA = 320,
+	CTRY_HAITI = 332,
 	CTRY_HONDURAS = 340,
 	CTRY_HONG_KONG = 344,
 	CTRY_HUNGARY = 348,
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 9847af7..248c670 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -288,13 +288,16 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_DEFAULT, FCC1_FCCA, "CO"},
 	{CTRY_ALBANIA, NULL1_WORLD, "AL"},
 	{CTRY_ALGERIA, NULL1_WORLD, "DZ"},
-	{CTRY_ARGENTINA, APL3_WORLD, "AR"},
+	{CTRY_ARGENTINA, FCC3_WORLD, "AR"},
 	{CTRY_ARMENIA, ETSI4_WORLD, "AM"},
+	{CTRY_ARUBA, ETSI1_WORLD, "AW"},
 	{CTRY_AUSTRALIA, FCC2_WORLD, "AU"},
 	{CTRY_AUSTRALIA2, FCC6_WORLD, "AU"},
 	{CTRY_AUSTRIA, ETSI1_WORLD, "AT"},
 	{CTRY_AZERBAIJAN, ETSI4_WORLD, "AZ"},
 	{CTRY_BAHRAIN, APL6_WORLD, "BH"},
+	{CTRY_BANGLADESH, NULL1_WORLD, "BD"},
+	{CTRY_BARBADOS, FCC2_WORLD, "BB"},
 	{CTRY_BELARUS, ETSI1_WORLD, "BY"},
 	{CTRY_BELGIUM, ETSI1_WORLD, "BE"},
 	{CTRY_BELGIUM2, ETSI4_WORLD, "BL"},
@@ -304,13 +307,14 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_BRAZIL, FCC3_WORLD, "BR"},
 	{CTRY_BRUNEI_DARUSSALAM, APL1_WORLD, "BN"},
 	{CTRY_BULGARIA, ETSI6_WORLD, "BG"},
-	{CTRY_CANADA, FCC2_FCCA, "CA"},
+	{CTRY_CAMBODIA, ETSI1_WORLD, "KH"},
+	{CTRY_CANADA, FCC3_FCCA, "CA"},
 	{CTRY_CANADA2, FCC6_FCCA, "CA"},
 	{CTRY_CHILE, APL6_WORLD, "CL"},
 	{CTRY_CHINA, APL1_WORLD, "CN"},
 	{CTRY_COLOMBIA, FCC1_FCCA, "CO"},
 	{CTRY_COSTA_RICA, FCC1_WORLD, "CR"},
-	{CTRY_CROATIA, ETSI3_WORLD, "HR"},
+	{CTRY_CROATIA, ETSI1_WORLD, "HR"},
 	{CTRY_CYPRUS, ETSI1_WORLD, "CY"},
 	{CTRY_CZECH, ETSI3_WORLD, "CZ"},
 	{CTRY_DENMARK, ETSI1_WORLD, "DK"},
@@ -324,18 +328,22 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_GEORGIA, ETSI4_WORLD, "GE"},
 	{CTRY_GERMANY, ETSI1_WORLD, "DE"},
 	{CTRY_GREECE, ETSI1_WORLD, "GR"},
+	{CTRY_GREENLAND, ETSI1_WORLD, "GL"},
+	{CTRY_GRENEDA, FCC3_FCCA, "GD"},
+	{CTRY_GUAM, FCC1_FCCA, "GU"},
 	{CTRY_GUATEMALA, FCC1_FCCA, "GT"},
+	{CTRY_HAITI, ETSI1_WORLD, "HT"},
 	{CTRY_HONDURAS, NULL1_WORLD, "HN"},
-	{CTRY_HONG_KONG, FCC2_WORLD, "HK"},
+	{CTRY_HONG_KONG, FCC3_WORLD, "HK"},
 	{CTRY_HUNGARY, ETSI1_WORLD, "HU"},
 	{CTRY_ICELAND, ETSI1_WORLD, "IS"},
 	{CTRY_INDIA, APL6_WORLD, "IN"},
-	{CTRY_INDONESIA, APL1_WORLD, "ID"},
+	{CTRY_INDONESIA, NULL1_WORLD, "ID"},
 	{CTRY_IRAN, APL1_WORLD, "IR"},
 	{CTRY_IRELAND, ETSI1_WORLD, "IE"},
 	{CTRY_ISRAEL, NULL1_WORLD, "IL"},
 	{CTRY_ITALY, ETSI1_WORLD, "IT"},
-	{CTRY_JAMAICA, ETSI1_WORLD, "JM"},
+	{CTRY_JAMAICA, FCC3_WORLD, "JM"},
 
 	{CTRY_JAPAN, MKK1_MKKA, "JP"},
 	{CTRY_JAPAN1, MKK1_MKKB, "JP"},
@@ -402,7 +410,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_KOREA_ROC, APL9_WORLD, "KR"},
 	{CTRY_KOREA_ROC2, APL2_WORLD, "K2"},
 	{CTRY_KOREA_ROC3, APL9_WORLD, "K3"},
-	{CTRY_KUWAIT, NULL1_WORLD, "KW"},
+	{CTRY_KUWAIT, ETSI3_WORLD, "KW"},
 	{CTRY_LATVIA, ETSI1_WORLD, "LV"},
 	{CTRY_LEBANON, NULL1_WORLD, "LB"},
 	{CTRY_LIECHTENSTEIN, ETSI1_WORLD, "LI"},
@@ -414,13 +422,13 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_MALTA, ETSI1_WORLD, "MT"},
 	{CTRY_MEXICO, FCC1_FCCA, "MX"},
 	{CTRY_MONACO, ETSI4_WORLD, "MC"},
-	{CTRY_MOROCCO, NULL1_WORLD, "MA"},
+	{CTRY_MOROCCO, APL4_WORLD, "MA"},
 	{CTRY_NEPAL, APL1_WORLD, "NP"},
 	{CTRY_NETHERLANDS, ETSI1_WORLD, "NL"},
 	{CTRY_NETHERLANDS_ANTILLES, ETSI1_WORLD, "AN"},
 	{CTRY_NEW_ZEALAND, FCC2_ETSIC, "NZ"},
 	{CTRY_NORWAY, ETSI1_WORLD, "NO"},
-	{CTRY_OMAN, APL6_WORLD, "OM"},
+	{CTRY_OMAN, FCC3_WORLD, "OM"},
 	{CTRY_PAKISTAN, NULL1_WORLD, "PK"},
 	{CTRY_PANAMA, FCC1_FCCA, "PA"},
 	{CTRY_PAPUA_NEW_GUINEA, FCC1_WORLD, "PG"},
@@ -429,7 +437,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_POLAND, ETSI1_WORLD, "PL"},
 	{CTRY_PORTUGAL, ETSI1_WORLD, "PT"},
 	{CTRY_PUERTO_RICO, FCC1_FCCA, "PR"},
-	{CTRY_QATAR, NULL1_WORLD, "QA"},
+	{CTRY_QATAR, APL1_WORLD, "QA"},
 	{CTRY_ROMANIA, NULL1_WORLD, "RO"},
 	{CTRY_RUSSIA, NULL1_WORLD, "RU"},
 	{CTRY_SAUDI_ARABIA, NULL1_WORLD, "SA"},
@@ -445,7 +453,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_SYRIA, NULL1_WORLD, "SY"},
 	{CTRY_TAIWAN, APL3_FCCA, "TW"},
 	{CTRY_THAILAND, FCC3_WORLD, "TH"},
-	{CTRY_TRINIDAD_Y_TOBAGO, ETSI4_WORLD, "TT"},
+	{CTRY_TRINIDAD_Y_TOBAGO, FCC3_WORLD, "TT"},
 	{CTRY_TUNISIA, ETSI3_WORLD, "TN"},
 	{CTRY_TURKEY, ETSI3_WORLD, "TR"},
 	{CTRY_UKRAINE, NULL1_WORLD, "UA"},
@@ -456,7 +464,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	 * would need to assign new special alpha2 to CRDA db as with the world
 	 * regdomain and use another alpha2 */
 	{CTRY_UNITED_STATES_FCC49, FCC4_FCCA, "PS"},
-	{CTRY_URUGUAY, APL2_WORLD, "UY"},
+	{CTRY_URUGUAY, FCC3_WORLD, "UY"},
 	{CTRY_UZBEKISTAN, FCC3_FCCA, "UZ"},
 	{CTRY_VENEZUELA, APL2_ETSIC, "VE"},
 	{CTRY_VIET_NAM, NULL1_WORLD, "VN"},
-- 
1.6.5.1

