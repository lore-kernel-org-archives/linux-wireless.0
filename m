Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50523 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3EaCKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:33 -0400
Received: by mail-pb0-f41.google.com with SMTP id xb12so1396589pbc.14
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:33 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 11/40] crda: fix intersect.c memory management
Date: Thu, 30 May 2013 19:09:00 -0700
Message-Id: <1369966169-23640-12-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041036_155954_D3EE717F)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

We didn't free memory in some cases, fix this and
to help with the complexity also simplify the case
where any regdom_intersect() fails by completely
failing. In such cases we need an alternative strategy
to build "world regulatory" domains.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/intersect.c b/intersect.c
index 169fe1a..970f4db 100644
--- a/intersect.c
+++ b/intersect.c
@@ -24,8 +24,10 @@ int main(int argc, char **argv)
 
 	/* We intersect only when we have to rd structures ready */
 	reglib_for_each_country(rd, idx, argv[1]) {
-		if (is_world_regdom((const char *) rd->alpha2))
+		if (is_world_regdom((const char *) rd->alpha2)) {
+			free((struct ieee80211_regdomain *) rd);
 			continue;
+		}
 
 		if (!prev_world) {
 			prev_world = (struct ieee80211_regdomain *) rd;
@@ -39,18 +41,10 @@ int main(int argc, char **argv)
 
 		world = regdom_intersect(prev_world, rd);
 		if (!world) {
-			/* Could be something else but we'll live with this */
-			r = -ENOMEM;
-			if (intersected)
-				fprintf(stderr, "Could not intersect world "
-					"with country (%.2s)\n",
-					rd->alpha2);
-			else
-				fprintf(stderr, "Could not intersect country (%.2s) "
-					"with country (%.2s)\n",
-					prev_world->alpha2,
-					rd->alpha2);
-			continue;
+			free(prev_world);
+			free((struct ieee80211_regdomain *) rd);
+			fprintf(stderr, "Intersection not possible\n");
+			return -ENOENT;
 		}
 
 		if (intersected)
@@ -71,6 +65,7 @@ int main(int argc, char **argv)
 				rd->n_reg_rules,
 				world->n_reg_rules);
 		intersected++;
+		free((struct ieee80211_regdomain *) rd);
 	}
 
 	if (!idx) {
@@ -83,28 +78,25 @@ int main(int argc, char **argv)
 		printf("%d regulatory domains intersected\n", intersected);
 	else {
 		world = prev_world;
+		prev_world = NULL;
 		printf("No intersections completed\n");
 		if (idx > 1) {
 			printf("Since more than one regulatory domain is "
 			       "present and no intersections were possible "
 			       "no globally allowed spectrum is possible so "
 			       "consider enabling passive scan flags\n");
+			free(world);
 			return r;
 		}
 	}
 
+	if (prev_world)
+		free(prev_world);
+
 	/* Tada! */
 	printf("== World regulatory domain: ==\n");
 	print_regdom(world);
 
-	if (!intersected) {
-		free(world);
-		return r;
-	}
-	if (intersected > 1) {
-		free((struct ieee80211_regdomain *)rd);
-		free(prev_world);
-	}
 	free(world);
 	return r;
 }
-- 
1.7.10.4

