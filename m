Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39506 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3EaCLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:04 -0400
Received: by mail-pd0-f173.google.com with SMTP id v14so1380263pde.32
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:03 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 18/40] crda: rename world and prev_world on intersect.c
Date: Thu, 30 May 2013 19:09:07 -0700
Message-Id: <1369966169-23640-19-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042937_276571_2AAEFA4D)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

The assumption was that intersect.c was creating a world
regulatory domain for by doing an intersection of all
regulatory domains. This is technically still true however
it does not add passive scan flag'd frequency ranges and
as such to be precise lets just rename the "world" and
"prev_world" variables as intersection variables.

This change introduces no functional changes.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/intersect.c b/intersect.c
index 970f4db..7903dd7 100644
--- a/intersect.c
+++ b/intersect.c
@@ -13,7 +13,7 @@ int main(int argc, char **argv)
 {
 	int r = 0;
 	const struct ieee80211_regdomain *rd;
-	struct ieee80211_regdomain *prev_world = NULL, *world = NULL;
+	struct ieee80211_regdomain *prev_rd_intsct = NULL, *rd_intsct = NULL;
 	int intersected = 0;
 	unsigned int idx = 0;
 
@@ -29,19 +29,19 @@ int main(int argc, char **argv)
 			continue;
 		}
 
-		if (!prev_world) {
-			prev_world = (struct ieee80211_regdomain *) rd;
+		if (!prev_rd_intsct) {
+			prev_rd_intsct = (struct ieee80211_regdomain *) rd;
 			continue;
 		}
 
-		if (world) {
-			free(prev_world);
-			prev_world = (struct ieee80211_regdomain *) world;
+		if (rd_intsct) {
+			free(prev_rd_intsct);
+			prev_rd_intsct = (struct ieee80211_regdomain *) rd_intsct;
 		}
 
-		world = regdom_intersect(prev_world, rd);
-		if (!world) {
-			free(prev_world);
+		rd_intsct = regdom_intersect(prev_rd_intsct, rd);
+		if (!rd_intsct) {
+			free(prev_rd_intsct);
 			free((struct ieee80211_regdomain *) rd);
 			fprintf(stderr, "Intersection not possible\n");
 			return -ENOENT;
@@ -50,20 +50,20 @@ int main(int argc, char **argv)
 		if (intersected)
 			/* Use UTF-8 Intersection symbol ? (0xE2,0x88,0xA9) :) */
 			printf("WW (%d) intersect %c%c (%d) ==> %d rules\n",
-				prev_world->n_reg_rules,
+				prev_rd_intsct->n_reg_rules,
 				rd->alpha2[0],
 				rd->alpha2[1],
 				rd->n_reg_rules,
-				world->n_reg_rules);
+				rd_intsct->n_reg_rules);
 		else
 			printf("%c%c (%d) intersect %c%c (%d) ==> %d rules\n",
-				prev_world->alpha2[0],
-				prev_world->alpha2[1],
-				prev_world->n_reg_rules,
+				prev_rd_intsct->alpha2[0],
+				prev_rd_intsct->alpha2[1],
+				prev_rd_intsct->n_reg_rules,
 				rd->alpha2[0],
 				rd->alpha2[1],
 				rd->n_reg_rules,
-				world->n_reg_rules);
+				rd_intsct->n_reg_rules);
 		intersected++;
 		free((struct ieee80211_regdomain *) rd);
 	}
@@ -77,26 +77,26 @@ int main(int argc, char **argv)
 	if (intersected > 1)
 		printf("%d regulatory domains intersected\n", intersected);
 	else {
-		world = prev_world;
-		prev_world = NULL;
+		rd_intsct = prev_rd_intsct;
+		prev_rd_intsct = NULL;
 		printf("No intersections completed\n");
 		if (idx > 1) {
 			printf("Since more than one regulatory domain is "
 			       "present and no intersections were possible "
 			       "no globally allowed spectrum is possible so "
 			       "consider enabling passive scan flags\n");
-			free(world);
+			free(rd_intsct);
 			return r;
 		}
 	}
 
-	if (prev_world)
-		free(prev_world);
+	if (prev_rd_intsct)
+		free(prev_rd_intsct);
 
 	/* Tada! */
 	printf("== World regulatory domain: ==\n");
-	print_regdom(world);
+	print_regdom(rd_intsct);
 
-	free(world);
+	free(rd_intsct);
 	return r;
 }
-- 
1.7.10.4

