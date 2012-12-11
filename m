Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39053 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab2LKUgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 15:36:19 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/3] qca-swiss-army-knife: automatically detect wide initval arrays
Date: Tue, 11 Dec 2012 21:36:12 +0100
Message-Id: <1355258172-6938-3-git-send-email-juhosg@openwrt.org> (sfid-20121211_213622_087113_CD733F1D)
In-Reply-To: <1355258172-6938-1-git-send-email-juhosg@openwrt.org>
References: <1355258172-6938-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of the columns to be printed usually equals
with the actual columns. The only exceptions are the
Modes arrays, where the last column is not used by
ath9k.

The patch modifies the 'ath9k_get_p_columns' helper
so that can determine the correct number of columns
based on the name of the array. The the patch also
removes the 'wide' argument of various functions
because that is not necessary anymore. Additionaly,
the superfluous INI_PRINTW macro is removed as well.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |   55 +++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 94f5aba..3f2c7cd 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -356,10 +356,10 @@ struct initval_family {
 #define INI_PRINT_DUP(_array, _ref) do { \
 	if (check) { \
 		char *sha1sum; \
-		sha1sum = ath9k_hw_check_initval((const u32 *) &_array,\
+		sha1sum = ath9k_hw_check_initval(#_array, \
+						(const u32 *) &_array,\
 						ARRAY_SIZE(_array), \
-						ARRAY_SIZE((_array)[0]), \
-						false); \
+						ARRAY_SIZE((_array)[0])); \
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
 		if (sizeof(_ref) == sizeof(_array) && \
@@ -370,30 +370,26 @@ struct initval_family {
 		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
 				       ARRAY_SIZE(_array), \
 				       ARRAY_SIZE((_array)[0]), \
-				       false, \
 				       false); \
 	} \
     } while (0)
 
-#define _INI_PRINT(_label, _array, _wide) do { \
+#define INI_PRINT(_array) do { \
 	if (check) { \
 		char *sha1sum; \
-		sha1sum = ath9k_hw_check_initval((const u32 *) &_array,\
+		sha1sum = ath9k_hw_check_initval(#_array, \
+						(const u32 *) &_array,\
 						ARRAY_SIZE(_array), \
-						ARRAY_SIZE((_array)[0]), \
-						_wide); \
-		printf("%s        " _label "\n", sha1sum); \
+						ARRAY_SIZE((_array)[0])); \
+		printf("%s        " #_array "\n", sha1sum); \
 	} else { \
-		ath9k_hw_print_initval((_label), (const u32 *) _array, \
+		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
 				       ARRAY_SIZE(_array), \
 				       ARRAY_SIZE((_array)[0]), \
-				       false, \
-				       _wide); \
+				       false); \
 	} \
     } while (0)
 
-#define INI_PRINT(_array)	_INI_PRINT(#_array, _array, false)
-#define INI_PRINTW(_array)	_INI_PRINT(#_array, _array, true)
 
 #define INI_PRINT_ONEDIM(_array) do { \
 	if (check) { \
@@ -443,25 +439,26 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
 	return val;
 }
 
-static u32 ath9k_get_p_columns(u32 columns, bool wide)
+static u32 ath9k_get_p_columns(const char *name, u32 columns)
 {
-	u32 p_columns;
-
-	if (wide)
-		p_columns = columns;
-	else
-		p_columns = columns > 5 ? 5 : columns;
+	if (columns == 6 && strstr(name, "Modes")) {
+		/*
+		 * The last column contain values for Turbo mode.
+		 * Don't print that because it is not used in ath9k.
+		 */
+		return 5;
+	}
 
-	return p_columns;
+	return columns;
 }
 
 static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
-				   u32 columns, bool onedim, bool wide)
+				   u32 columns, bool onedim)
 {
 	u32 p_columns;
 	u32 col, row;
 
-	p_columns = ath9k_get_p_columns(columns, wide);
+	p_columns = ath9k_get_p_columns(name, columns);
 
 	if (onedim)
 		printf("static const u32 %s[] = {\n", name);
@@ -508,8 +505,8 @@ static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
 	printf("};\n\n");
 }
 
-static char *ath9k_hw_check_initval(const u32 *array, u32 rows, u32 columns,
-				    bool wide)
+static char *ath9k_hw_check_initval(const char *name, const u32 *array,
+				    u32 rows, u32 columns)
 {
 	SHA1_CTX ctx;
 	unsigned char digest[SHA1_DIGEST_SIZE];
@@ -517,7 +514,7 @@ static char *ath9k_hw_check_initval(const u32 *array, u32 rows, u32 columns,
 	u32 p_columns;
 	u32 col, row;
 
-	p_columns = ath9k_get_p_columns(columns, wide);
+	p_columns = ath9k_get_p_columns(name, columns);
 
 	SHA1_Init(&ctx);
 	for (row = 0; row < rows; row++) {
@@ -775,7 +772,7 @@ static void ar955x_1p0_hw_print_initvals(bool check)
 	INI_PRINT(ar955x_1p0_baseband_core_txfir_coeff_japan_2484);
 	INI_PRINT(ar955x_1p0_baseband_postamble);
 	INI_PRINT(ar955x_1p0_radio_core);
-	INI_PRINTW(ar955x_1p0_modes_xpa_tx_gain_table);
+	INI_PRINT(ar955x_1p0_modes_xpa_tx_gain_table);
 	INI_PRINT(ar955x_1p0_mac_core);
 	INI_PRINT(ar955x_1p0_common_rx_gain_table);
 	INI_PRINT(ar955x_1p0_baseband_core);
@@ -784,7 +781,7 @@ static void ar955x_1p0_hw_print_initvals(bool check)
 	INI_PRINT(ar955x_1p0_common_wo_xlna_rx_gain_bounds);
 	INI_PRINT(ar955x_1p0_mac_postamble);
 	INI_PRINT(ar955x_1p0_common_rx_gain_bounds);
-	INI_PRINTW(ar955x_1p0_modes_no_xpa_tx_gain_table);
+	INI_PRINT(ar955x_1p0_modes_no_xpa_tx_gain_table);
 	INI_PRINT(ar955x_1p0_soc_postamble);
 	INI_PRINT(ar955x_1p0_modes_fast_clock);
 }
-- 
1.7.10

