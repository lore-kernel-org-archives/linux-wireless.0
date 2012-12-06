Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37224 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946510Ab2LFSRe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:34 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 08/13] qca-swiss-army-knife: reformat INI_PRINT_* macros
Date: Thu,  6 Dec 2012 19:17:22 +0100
Message-Id: <1354817847-23440-9-git-send-email-juhosg@openwrt.org> (sfid-20121206_192413_133983_08FE48F0)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep the length of the macro lines under 80 character.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 0ab4d7f..90ca377 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -329,15 +329,19 @@ typedef long long unsigned int u64;
 	if (check) { \
 		char *sha1sum; \
 		sha1sum = ath9k_hw_check_initval((const u32 *) &_array,\
-						ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0])); \
+						ARRAY_SIZE(_array), \
+						ARRAY_SIZE((_array)[0])); \
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
-		if (sizeof(_ref) == sizeof(_array) && !memcmp(&_ref, &_array, sizeof(_ref))) { \
+		if (sizeof(_ref) == sizeof(_array) && \
+		    !memcmp(&_ref, &_array, sizeof(_ref))) { \
 			printf("#define " #_array " " #_ref "\n\n"); \
 			break; \
 		} \
 		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
-				       ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0]), false); \
+				       ARRAY_SIZE(_array), \
+				       ARRAY_SIZE((_array)[0]), \
+				       false); \
 	} \
     } while (0)
 
@@ -345,11 +349,14 @@ typedef long long unsigned int u64;
 	if (check) { \
 		char *sha1sum; \
 		sha1sum = ath9k_hw_check_initval((const u32 *) &_array,\
-						ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0])); \
+						 ARRAY_SIZE(_array), \
+						 ARRAY_SIZE((_array)[0])); \
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
 		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
-				       ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0]), false); \
+				       ARRAY_SIZE(_array), \
+				       ARRAY_SIZE((_array)[0]), \
+				       false); \
 	} \
     } while (0)
 
-- 
1.7.10

