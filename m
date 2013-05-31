Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49185 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3EaCLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:07 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz12so1389721pbc.31
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:07 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 19/40] crda: remove verbosity out of intersect.c
Date: Thu, 30 May 2013 19:09:08 -0700
Message-Id: <1369966169-23640-20-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042939_268447_CAF32820)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

No need for such much verbosity, additionally,
we'll move this eventually to reglib.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |   33 +++------------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

diff --git a/intersect.c b/intersect.c
index 7903dd7..bce7eb3 100644
--- a/intersect.c
+++ b/intersect.c
@@ -43,48 +43,21 @@ int main(int argc, char **argv)
 		if (!rd_intsct) {
 			free(prev_rd_intsct);
 			free((struct ieee80211_regdomain *) rd);
-			fprintf(stderr, "Intersection not possible\n");
 			return -ENOENT;
 		}
 
-		if (intersected)
-			/* Use UTF-8 Intersection symbol ? (0xE2,0x88,0xA9) :) */
-			printf("WW (%d) intersect %c%c (%d) ==> %d rules\n",
-				prev_rd_intsct->n_reg_rules,
-				rd->alpha2[0],
-				rd->alpha2[1],
-				rd->n_reg_rules,
-				rd_intsct->n_reg_rules);
-		else
-			printf("%c%c (%d) intersect %c%c (%d) ==> %d rules\n",
-				prev_rd_intsct->alpha2[0],
-				prev_rd_intsct->alpha2[1],
-				prev_rd_intsct->n_reg_rules,
-				rd->alpha2[0],
-				rd->alpha2[1],
-				rd->n_reg_rules,
-				rd_intsct->n_reg_rules);
 		intersected++;
 		free((struct ieee80211_regdomain *) rd);
 	}
 
-	if (!idx) {
-		printf("Invalid or empty regulatory file, note: "
-		       "a binary regulatory file should be used.\n");
+	if (!idx)
 		return -EINVAL;
-	}
 
-	if (intersected > 1)
-		printf("%d regulatory domains intersected\n", intersected);
-	else {
+	if (intersected <= 0) {
 		rd_intsct = prev_rd_intsct;
 		prev_rd_intsct = NULL;
-		printf("No intersections completed\n");
 		if (idx > 1) {
-			printf("Since more than one regulatory domain is "
-			       "present and no intersections were possible "
-			       "no globally allowed spectrum is possible so "
-			       "consider enabling passive scan flags\n");
+			r = -ENOENT;
 			free(rd_intsct);
 			return r;
 		}
-- 
1.7.10.4

