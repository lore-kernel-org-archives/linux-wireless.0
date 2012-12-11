Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39043 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab2LKUgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 15:36:15 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/3] qca-swiss-army-knife: remove the artificial column size limitation
Date: Tue, 11 Dec 2012 21:36:10 +0100
Message-Id: <1355258172-6938-1-git-send-email-juhosg@openwrt.org> (sfid-20121211_213620_337755_99A9A21C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is obsolete since the SHA1 checksums are used.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 6522de6..4413e04 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -449,21 +449,11 @@ static void ath9k_hw_print_initval(const char *name, const u32 *array, u32 rows,
 	u32 p_columns;
 	u32 col, row;
 
-	if (wide) {
+	if (wide)
 		p_columns = columns;
-	} else {
+	else
 		p_columns = columns > 5 ? 5 : columns;
 
-		/*
-		* This checksum stuff is designed for columns <= 8),
-		* and spreads the checksum over 64 bits but since currently
-		* the initval max column size is 6 we only use the first 48
-		* bits.
-		*/
-		if (columns > 6)
-			return;
-	}
-
 	if (onedim)
 		printf("static const u32 %s[] = {\n", name);
 	else
-- 
1.7.10

