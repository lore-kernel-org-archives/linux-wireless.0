Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34754 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759981Ab2EKQkA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 12:40:00 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 4/6] atheros-initvals: drop the "turbo" column for older chipsets, it is unused and unsupported
Date: Fri, 11 May 2012 18:39:54 +0200
Message-Id: <1336754396-30216-4-git-send-email-nbd@openwrt.org> (sfid-20120511_184010_218227_42BB7B91)
In-Reply-To: <1336754396-30216-3-git-send-email-nbd@openwrt.org>
References: <1336754396-30216-1-git-send-email-nbd@openwrt.org>
 <1336754396-30216-2-git-send-email-nbd@openwrt.org>
 <1336754396-30216-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 initvals.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/initvals.c b/initvals.c
index 17a7ab0..8c06690 100644
--- a/initvals.c
+++ b/initvals.c
@@ -283,7 +283,6 @@ typedef long long unsigned int u64;
 						ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0])); \
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
-		printf("static const u32 "#_array"[][%d] = {\n", (int) ARRAY_SIZE((_array)[0])); \
 		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
 				       ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0]), false); \
 	} \
@@ -296,7 +295,6 @@ typedef long long unsigned int u64;
 						ARRAY_SIZE(_array), 1); \
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
-		printf("static const u32 "#_array"[] = {\n"); \
 		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
 				       ARRAY_SIZE(_array), 1, true); \
 	} \
@@ -339,6 +337,7 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
 
 static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows, u32 columns, bool onedim)
 {
+	u32 p_columns = columns > 5 ? 5 : columns;
 	u32 col, row;
 
 	/*
@@ -350,7 +349,12 @@ static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
 	if (columns > 6)
 		return;
 
-	switch (columns) {
+	if (onedim)
+		printf("static const u32 %s[] = {\n", name);
+	else
+		printf("static const u32 %s[][%d] = {\n", name, p_columns);
+
+	switch (p_columns) {
 	case 5:
 		printf("\t/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */\n");
 		break;
@@ -368,7 +372,7 @@ static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
 	}
 
 	for (row = 0; row < rows; row++) {
-		for (col = 0; col < columns; col++) {
+		for (col = 0; col < p_columns; col++) {
 			u32 idx;
 			u32 val;
 			if (!col)
@@ -379,7 +383,7 @@ static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
 				val = ath9k_patch_initval(idx, val);
 			}
 			printf("0x%08x", val);
-			if (col + 1 < columns)
+			if (col + 1 < p_columns)
 				printf(", ");
 		}
 		printf("%s,\n", onedim ? "" : "}");
@@ -392,11 +396,12 @@ static char *ath9k_hw_check_initval(const u32 *array, u32 rows, u32 columns)
 	SHA1_CTX ctx;
 	unsigned char digest[SHA1_DIGEST_SIZE];
 	static char buf[64];
+	u32 p_columns = columns > 5 ? 5 : columns;
 	u32 col, row;
 
 	SHA1_Init(&ctx);
 	for (row = 0; row < rows; row++) {
-		for (col = 0; col < columns; col++) {
+		for (col = 0; col < p_columns; col++) {
 			unsigned char sha1_buf[4];
 			u32 val;
 
-- 
1.7.3.2

