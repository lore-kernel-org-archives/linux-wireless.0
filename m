Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46017 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760555Ab2EKQQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 12:16:47 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] atheros-initvals: fix comments for non-fastclock 3-column tables
Date: Fri, 11 May 2012 18:16:38 +0200
Message-Id: <1336753001-29583-3-git-send-email-nbd@openwrt.org> (sfid-20120511_181653_542327_E55F1FF5)
In-Reply-To: <1336753001-29583-2-git-send-email-nbd@openwrt.org>
References: <1336753001-29583-1-git-send-email-nbd@openwrt.org>
 <1336753001-29583-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 initvals.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/initvals.c b/initvals.c
index 9352010..17a7ab0 100644
--- a/initvals.c
+++ b/initvals.c
@@ -284,7 +284,7 @@ typedef long long unsigned int u64;
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
 		printf("static const u32 "#_array"[][%d] = {\n", (int) ARRAY_SIZE((_array)[0])); \
-		ath9k_hw_print_initval((const u32 *) _array, \
+		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
 				       ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0]), false); \
 	} \
     } while (0)
@@ -297,7 +297,7 @@ typedef long long unsigned int u64;
 		printf("%s        "#_array"\n", sha1sum); \
 	} else { \
 		printf("static const u32 "#_array"[] = {\n"); \
-		ath9k_hw_print_initval((const u32 *) _array, \
+		ath9k_hw_print_initval(#_array, (const u32 *) _array, \
 				       ARRAY_SIZE(_array), 1, true); \
 	} \
     } while (0)
@@ -337,7 +337,7 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
 	return val;
 }
 
-static void ath9k_hw_print_initval(const u32 *array, u32 rows, u32 columns, bool onedim)
+static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows, u32 columns, bool onedim)
 {
 	u32 col, row;
 
@@ -355,7 +355,10 @@ static void ath9k_hw_print_initval(const u32 *array, u32 rows, u32 columns, bool
 		printf("\t/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */\n");
 		break;
 	case 3:
-		printf("\t/* Addr      5G_HT20     5G_HT40   */\n");
+		if (strstr(name, "fast_clock"))
+			printf("\t/* Addr      5G_HT20     5G_HT40   */\n");
+		else
+			printf("\t/* Addr      5G          2G        */\n");
 		break;
 	case 2:
 		printf("\t/* Addr      allmodes  */\n");
-- 
1.7.3.2

