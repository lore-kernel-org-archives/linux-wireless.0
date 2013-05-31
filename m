Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42701 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3EaCMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:12:24 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so1387742pbb.34
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:12:24 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 37/40] crda: move regdbprint to its own helper
Date: Thu, 30 May 2013 19:09:26 -0700
Message-Id: <1369966169-23640-38-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042938_960079_D509E1D9)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

We'll later move this to reglib but first we have
to clean up the print utility to make it more general.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 regdbdump.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/regdbdump.c b/regdbdump.c
index ea14730..edf3e7c 100644
--- a/regdbdump.c
+++ b/regdbdump.c
@@ -2,26 +2,35 @@
 #include <errno.h>
 #include "reglib.h"
 
-int main(int argc, char **argv)
+static int reglib_regdbdump(char *regdb_file)
 {
 	const struct ieee80211_regdomain *rd = NULL;
 	unsigned int idx = 0;
 
-	if (argc != 2) {
-		fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
-		return 2;
-	}
-
-	reglib_for_each_country(rd, idx, argv[1]) {
+	reglib_for_each_country(rd, idx, regdb_file) {
 		reglib_print_regdom(rd);
 		free((struct ieee80211_regdomain *) rd);
 	}
 
 	if (!idx) {
-		printf("Invalid or empty regulatory file, note: "
+		fprintf(stderr, "Invalid or empty regulatory file, note: "
 		       "a binary regulatory file should be used.\n");
 		return -EINVAL;
 	}
 
 	return 0;
 }
+
+int main(int argc, char **argv)
+{
+	int r;
+
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <regulatory-binary-file>\n", argv[0]);
+		return 2;
+	}
+
+	r = reglib_regdbdump(argv[1]);
+
+	return r;
+}
-- 
1.7.10.4

