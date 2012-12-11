Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39048 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab2LKUgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 15:36:15 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/3] qca-swiss-army-knife: add 'ath9k_get_p_columns' helper
Date: Tue, 11 Dec 2012 21:36:11 +0100
Message-Id: <1355258172-6938-2-git-send-email-juhosg@openwrt.org> (sfid-20121211_213621_063234_6BAB903F)
In-Reply-To: <1355258172-6938-1-git-send-email-juhosg@openwrt.org>
References: <1355258172-6938-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of the columns to be printed is computed in
two different function. Add a helper function for that
and remove the duplicated code.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 4413e04..94f5aba 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -443,17 +443,26 @@ static u32 ath9k_patch_initval(u32 idx, u32 val)
 	return val;
 }
 
-static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
-				   u32 columns, bool onedim, bool wide)
+static u32 ath9k_get_p_columns(u32 columns, bool wide)
 {
 	u32 p_columns;
-	u32 col, row;
 
 	if (wide)
 		p_columns = columns;
 	else
 		p_columns = columns > 5 ? 5 : columns;
 
+	return p_columns;
+}
+
+static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
+				   u32 columns, bool onedim, bool wide)
+{
+	u32 p_columns;
+	u32 col, row;
+
+	p_columns = ath9k_get_p_columns(columns, wide);
+
 	if (onedim)
 		printf("static const u32 %s[] = {\n", name);
 	else
@@ -508,10 +517,7 @@ static char *ath9k_hw_check_initval(const u32 *array, u32 rows, u32 columns,
 	u32 p_columns;
 	u32 col, row;
 
-	if (wide)
-		p_columns = columns;
-	else
-		p_columns = columns > 5 ? 5 : columns;
+	p_columns = ath9k_get_p_columns(columns, wide);
 
 	SHA1_Init(&ctx);
 	for (row = 0; row < rows; row++) {
-- 
1.7.10

