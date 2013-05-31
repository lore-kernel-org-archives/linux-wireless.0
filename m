Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50756 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3EaCKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:10:16 -0400
Received: by mail-pd0-f179.google.com with SMTP id q11so1369723pdj.24
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:10:16 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 07/40] crda: fix regression when using reglib_for_each_country()
Date: Thu, 30 May 2013 19:08:56 -0700
Message-Id: <1369966169-23640-8-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041020_247097_998C0904)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

When reglib_for_each_country() was introduced via ebcbfcf4
its users were not updated with the possibility of rd being
NULL due to the fact that the parsed file could be invalid
or empty. The users

mcgrof@frijol ~/devel/crda (git::master)$ git describe --contains 7a09f4dd
v1.1.3~8

mcgrof@frijol ~/devel/crda (git::master)$ git describe --contains ebcbfcf45
v1.1.3~9

This regression exists since v1.1. Fix this.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |    6 ++++++
 regdbdump.c |    7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/intersect.c b/intersect.c
index 1c00a67..8f826a0 100644
--- a/intersect.c
+++ b/intersect.c
@@ -73,6 +73,12 @@ int main(int argc, char **argv)
 		intersected++;
 	}
 
+	if (!idx) {
+		printf("Invalid or empty regulatory file, note: "
+		       "a binary regulatory file should be used.\n");
+		return -EINVAL;
+	}
+
 	if (idx == 1) {
 		world = (struct ieee80211_regdomain *) rd;
 		rd = NULL;
diff --git a/regdbdump.c b/regdbdump.c
index 26cbef7..dcbed71 100644
--- a/regdbdump.c
+++ b/regdbdump.c
@@ -1,4 +1,5 @@
 #include <stdio.h>
+#include <errno.h>
 #include "reglib.h"
 
 int main(int argc, char **argv)
@@ -16,5 +17,11 @@ int main(int argc, char **argv)
 		free((struct ieee80211_regdomain *) rd);
 	}
 
+	if (!idx) {
+		printf("Invalid or empty regulatory file, note: "
+		       "a binary regulatory file should be used.\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
-- 
1.7.10.4

