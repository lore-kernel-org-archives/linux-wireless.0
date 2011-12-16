Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36452 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760557Ab1LPTTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 14:19:38 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 5/7] initvals: add support for printing one dimensional arrays
Date: Fri, 16 Dec 2011 20:19:23 +0100
Message-Id: <1324063165-4349-5-git-send-email-juhosg@openwrt.org> (sfid-20111216_201941_830171_7CB91D9B)
In-Reply-To: <1324063165-4349-1-git-send-email-juhosg@openwrt.org>
References: <1324063165-4349-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It will be used for printing AR9330 specific initvals.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/initvals.c b/initvals.c
index 541fa6b..b85c9dd 100644
--- a/initvals.c
+++ b/initvals.c
@@ -215,7 +215,19 @@ typedef long long unsigned int u64;
 	} else { \
 		printf("static const u32 "#_array"[][%ld] = {\n", ARRAY_SIZE((_array)[0])); \
 		ath9k_hw_print_initval((const u32 *) _array, \
-				       ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0])); \
+				       ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0]), false); \
+	} \
+    } while (0)
+
+#define INI_PRINT_ONEDIM(_array) do { \
+	if (check) { \
+		chksum = ath9k_hw_check_initval((const u32 *) &_array,\
+						ARRAY_SIZE(_array), 1); \
+		printf("0x%016llx        "#_array"\n", chksum); \
+	} else { \
+		printf("static const u32 "#_array"[] = {\n"); \
+		ath9k_hw_print_initval((const u32 *) _array, \
+				       ARRAY_SIZE(_array), 1, true); \
 	} \
     } while (0)
 
@@ -254,7 +266,7 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
 	return val;
 }
 
-static void ath9k_hw_print_initval(const u32 *array, u32 rows, u32 columns)
+static void ath9k_hw_print_initval(const u32 *array, u32 rows, u32 columns, bool onedim)
 {
 	u32 chksum, col, row;
 
@@ -286,7 +298,7 @@ static void ath9k_hw_print_initval(const u32 *array, u32 rows, u32 columns)
 			u32 idx;
 			u32 val;
 			if (!col)
-				printf("\t{");
+				printf("\t%s", onedim ? "" : "{");
 			val = array[row * columns + col];
 			if (col > 0) {
 				idx = array[row * columns];
@@ -296,7 +308,7 @@ static void ath9k_hw_print_initval(const u32 *array, u32 rows, u32 columns)
 			if (col + 1 < columns)
 				printf(", ");
 		}
-		printf("},\n");
+		printf("%s,\n", onedim ? "" : "}");
 	}
 	printf("};\n\n");
 }
-- 
1.7.2.1

