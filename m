Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43356 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3EaCMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:12:12 -0400
Received: by mail-pb0-f53.google.com with SMTP id un4so1392938pbc.12
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:12:12 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 34/40] crda: clarify intersect.c only computes an intersection
Date: Thu, 30 May 2013 19:09:23 -0700
Message-Id: <1369966169-23640-35-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042938_328944_AD79783C)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

World regulatory domains should deal with passive scan
flags to account for gaps in the frequency spectrum that
some countries do not rely on but some APs / Cell towers
could be relied upon for determining location.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/intersect.c b/intersect.c
index bc1e63e..baca5f1 100644
--- a/intersect.c
+++ b/intersect.c
@@ -7,7 +7,7 @@
 #include "reglib.h"
 
 /* Intersects regulatory domains, this will skip any regulatory marked with
- * an alpha2 of '00', which is used to indicate a regulatory domain */
+ * an alpha2 of '00', which is used to indicate a world regulatory domain */
 
 int main(int argc, char **argv)
 {
@@ -67,7 +67,7 @@ int main(int argc, char **argv)
 		free(prev_rd_intsct);
 
 	/* Tada! */
-	printf("== World regulatory domain: ==\n");
+	printf("Intersected regulatory domain:\n");
 	reglib_print_regdom(rd_intsct);
 
 	free(rd_intsct);
-- 
1.7.10.4

