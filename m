Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37205 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946393Ab2LFSRf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:35 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 10/13] qca-swiss-army-knife: allow to print initvals with more than 5 columns
Date: Thu,  6 Dec 2012 19:17:24 +0100
Message-Id: <1354817847-23440-11-git-send-email-juhosg@openwrt.org> (sfid-20121206_191740_903972_B8B9F73A)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required for the QCA955X initvals, because that
contain some arrays with 9 columns.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |   62 ++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 21 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 35466bc..b13d12e 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -338,7 +338,8 @@ struct initval_family {
 		char *sha1sum; \
 		sha1sum = ath9k_hw_check_initval((const u32 *) &_array,\
 						ARRAY_SIZE(_array), \
-						ARRAY_SIZE((_array)[0])); \
+						ARRAY_SIZE((_array)[0]), \
+						false); \
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
 		if (sizeof(_ref) == sizeof(_array) && \
@@ -349,34 +350,40 @@ struct initval_family {
 		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
 				       ARRAY_SIZE(_array), \
 				       ARRAY_SIZE((_array)[0]), \
+				       false, \
 				       false); \
 	} \
     } while (0)
 
-#define INI_PRINT(_array) do { \
+#define _INI_PRINT(_label, _array, _wide) do { \
 	if (check) { \
 		char *sha1sum; \
 		sha1sum = ath9k_hw_check_initval((const u32 *) &_array,\
-						 ARRAY_SIZE(_array), \
-						 ARRAY_SIZE((_array)[0])); \
-		printf("%s        "#_array"\n", sha1sum); \
+						ARRAY_SIZE(_array), \
+						ARRAY_SIZE((_array)[0]), \
+						_wide); \
+		printf("%s        " _label "\n", sha1sum); \
 	} else { \
-		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
+		ath9k_hw_print_initval((_label), (const u32 *) _array, \
 				       ARRAY_SIZE(_array), \
 				       ARRAY_SIZE((_array)[0]), \
-				       false); \
+				       false, \
+				       _wide); \
 	} \
     } while (0)
 
+#define INI_PRINT(_array)	_INI_PRINT(#_array, _array, false)
+#define INI_PRINTW(_array)	_INI_PRINT(#_array, _array, true)
+
 #define INI_PRINT_ONEDIM(_array) do { \
 	if (check) { \
 		char *sha1sum; \
 		sha1sum = ath9k_hw_check_initval((const u32 *) &_array,\
-						ARRAY_SIZE(_array), 1); \
+						ARRAY_SIZE(_array), 1, false); \
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
 		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
-				       ARRAY_SIZE(_array), 1, true); \
+				       ARRAY_SIZE(_array), 1, true, false); \
 	} \
     } while (0)
 
@@ -416,19 +423,26 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
 	return val;
 }
 
-static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows, u32 columns, bool onedim)
+static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
+				   u32 columns, bool onedim, bool wide)
 {
-	u32 p_columns = columns > 5 ? 5 : columns;
+	u32 p_columns;
 	u32 col, row;
 
-	/*
-	 * This checksum stuff is designed for columns <= 8),
-	 * and spreads the checksum over 64 bits but since currently
-	 * the initval max column size is 6 we only use the first 48
-	 * bits.
-	 */
-	if (columns > 6)
-		return;
+	if (wide) {
+		p_columns = columns;
+	} else {
+		p_columns = columns > 5 ? 5 : columns;
+
+		/*
+		* This checksum stuff is designed for columns <= 8),
+		* and spreads the checksum over 64 bits but since currently
+		* the initval max column size is 6 we only use the first 48
+		* bits.
+		*/
+		if (columns > 6)
+			return;
+	}
 
 	if (onedim)
 		printf("static const u32 %s[] = {\n", name);
@@ -472,14 +486,20 @@ static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
 	printf("};\n\n");
 }
 
-static char *ath9k_hw_check_initval(const u32 *array, u32 rows, u32 columns)
+static char *ath9k_hw_check_initval(const u32 *array, u32 rows, u32 columns,
+				    bool wide)
 {
 	SHA1_CTX ctx;
 	unsigned char digest[SHA1_DIGEST_SIZE];
 	static char buf[64];
-	u32 p_columns = columns > 5 ? 5 : columns;
+	u32 p_columns;
 	u32 col, row;
 
+	if (wide)
+		p_columns = columns;
+	else
+		p_columns = columns > 5 ? 5 : columns;
+
 	SHA1_Init(&ctx);
 	for (row = 0; row < rows; row++) {
 		for (col = 0; col < p_columns; col++) {
-- 
1.7.10

