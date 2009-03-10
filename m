Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbZCJC2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:28:51 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] iw: use stdbool on reg.c
Date: Mon,  9 Mar 2009 22:28:49 -0400
Message-Id: <1236652130-29971-3-git-send-email-lrodriguez@atheros.com> (sfid-20090310_032859_010942_3337C8E2)
In-Reply-To: <1236652130-29971-1-git-send-email-lrodriguez@atheros.com>
References: <1236652130-29971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 reg.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/reg.c b/reg.c
index cb58ed9..74ae77f 100644
--- a/reg.c
+++ b/reg.c
@@ -1,6 +1,7 @@
 #include <net/if.h>
 #include <errno.h>
 #include <string.h>
+#include <stdbool.h>
 
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
@@ -18,26 +19,26 @@
 #define DBM_TO_MBM(gain) ((gain) * 100)
 #define MBM_TO_DBM(gain) ((gain) / 100)
 
-static int isalpha_upper(char letter)
+static bool isalpha_upper(char letter)
 {
 	if (letter >= 65 && letter <= 90)
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
-static int is_alpha2(char *alpha2)
+static bool is_alpha2(char *alpha2)
 {
 	if (isalpha_upper(alpha2[0]) && isalpha_upper(alpha2[1]))
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
-static int is_world_regdom(char *alpha2)
+static bool is_world_regdom(char *alpha2)
 {
 	/* ASCII 0 */
 	if (alpha2[0] == 48 && alpha2[1] == 48)
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
 static int handle_reg_set(struct nl_cb *cb,
-- 
1.6.0.6

