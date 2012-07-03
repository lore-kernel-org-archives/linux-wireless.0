Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46677 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964782Ab2GCQyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:54:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 06/10] qca-swiss-army-knife: allow to print initvals with more than 5 columns
Date: Tue,  3 Jul 2012 18:42:51 +0200
Message-Id: <1341333775-14091-7-git-send-email-juhosg@openwrt.org> (sfid-20120703_185450_073799_7F60F809)
In-Reply-To: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
References: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required for the QCA955X initvals, because that
contain some arrays with 9 columns.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |   58 ++++++++++++++++++++++++++++++--------------
 1 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index f28f2c9..d7df352 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -306,7 +306,8 @@ struct initval_family {
 		char *sha1sum; \
 		sha1sum = ath9k_hw_check_initval((const u32 *) &_array,\
 						ARRAY_SIZE(_array), \
-						ARRAY_SIZE((_array)[0])); \
+						ARRAY_SIZE((_array)[0]), \
+						false); \
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
 		if (sizeof(_ref) == sizeof(_array) && \
@@ -317,34 +318,40 @@ struct initval_family {
 		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
 				       ARRAY_SIZE(_array), \
 				       ARRAY_SIZE((_array)[0]), \
+				       false, \
 				       false); \
 	} \
     } while (0)
 
-#define INI_PRINT(_array) do { \
+#define _INI_PRINT(_array, _wide) do { \
 	if (check) { \
 		char *sha1sum; \
 		sha1sum = ath9k_hw_check_initval((const u32 *) &_array,\
-						 ARRAY_SIZE(_array), \
-						 ARRAY_SIZE((_array)[0])); \
+						ARRAY_SIZE(_array), \
+					        ARRAY_SIZE((_array)[0]), \
+						_wide); \
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
 		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
 				       ARRAY_SIZE(_array), \
 				       ARRAY_SIZE((_array)[0]), \
-				       false); \
+				       false, \
+				       _wide); \
 	} \
     } while (0)
 
+#define INI_PRINT(_array)	_INI_PRINT(_array, false)
+#define INI_PRINTW(_array)	_INI_PRINT(_array, true)
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
 
@@ -384,19 +391,26 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
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
@@ -440,14 +454,20 @@ static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
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
1.7.2.1

