Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51904 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868Ab2GCQti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:49:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 04/10] qca-swiss-army-knife: reformat INI_PRINT_* macros
Date: Tue,  3 Jul 2012 18:42:49 +0200
Message-Id: <1341333775-14091-5-git-send-email-juhosg@openwrt.org> (sfid-20120703_184945_327216_4D9C2DAD)
In-Reply-To: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
References: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep the length of the macro lines under 80 character.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index d3740da..4205b08 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -297,15 +297,19 @@ typedef long long unsigned int u64;
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
 
@@ -313,11 +317,14 @@ typedef long long unsigned int u64;
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
1.7.2.1

