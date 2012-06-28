Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41924 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab2F1A0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 20:26:42 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH 05/11] qca-swiss-army-knife: add a macro for de-duplicating initval tables
Date: Thu, 28 Jun 2012 02:26:33 +0200
Message-Id: <1340843199-49821-5-git-send-email-nbd@openwrt.org> (sfid-20120628_022650_318835_F2C545D8)
In-Reply-To: <1340843199-49821-4-git-send-email-nbd@openwrt.org>
References: <1340843199-49821-1-git-send-email-nbd@openwrt.org>
 <1340843199-49821-2-git-send-email-nbd@openwrt.org>
 <1340843199-49821-3-git-send-email-nbd@openwrt.org>
 <1340843199-49821-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 tools/initvals/initvals.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 437dfc5..b655a4c 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -296,6 +296,22 @@ typedef long long unsigned int u64;
 
 #endif /* ATHEROS */
 
+#define INI_PRINT_DUP(_array, _ref) do { \
+	if (check) { \
+		char *sha1sum; \
+		sha1sum = ath9k_hw_check_initval((const u32 *) &_array,\
+						ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0])); \
+		printf("%s        "#_array"\n", sha1sum); \
+	} else { \
+		if (sizeof(_ref) == sizeof(_array) && !memcmp(&_ref, &_array, sizeof(_ref))) { \
+			printf("#define " #_array " " #_ref "\n\n"); \
+			break; \
+		} \
+		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
+				       ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0]), false); \
+	} \
+    } while (0)
+
 #define INI_PRINT(_array) do { \
 	if (check) { \
 		char *sha1sum; \
-- 
1.7.3.2

