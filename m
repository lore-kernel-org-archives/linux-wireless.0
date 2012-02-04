Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60041 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2BDB0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:26:23 -0500
Received: by mail-pw0-f46.google.com with SMTP id u11so3334452pbd.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:26:23 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 10/11] crda: make usage of regdb.h exclusive to reglib.c
Date: Fri,  3 Feb 2012 17:25:47 -0800
Message-Id: <1328318748-21044-11-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022632_157461_848BA3B6)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only other remaining user of regdb.h is regdbdump tool
but as I see it this utility can exist in either a reglib
library, or on each OS for its own specific adaptation of
the reglib code. For now we just make regdbump use the local
copy of nl80211.h. Later the reglib library can have its own
print / dump utility if we deem it necessary.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 print-regdom.c |   21 ++++++++++++---------
 reglib.c       |    1 +
 reglib.h       |    2 --
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/print-regdom.c b/print-regdom.c
index a3bedeb..075eea8 100644
--- a/print-regdom.c
+++ b/print-regdom.c
@@ -2,6 +2,9 @@
 #include <stdio.h>
 #include <string.h>
 #include <arpa/inet.h>
+
+#include "nl80211.h"
+
 #include "reglib.h"
 
 static void print_reg_rule(struct ieee80211_reg_rule *rule)
@@ -29,23 +32,23 @@ static void print_reg_rule(struct ieee80211_reg_rule *rule)
 	else
 		printf("N/A)");
 
-	if (rule->flags & RRF_NO_OFDM)
+	if (rule->flags & NL80211_RRF_NO_OFDM)
 		printf(", NO-OFDM");
-	if (rule->flags & RRF_NO_CCK)
+	if (rule->flags & NL80211_RRF_NO_CCK)
 		printf(", NO-CCK");
-	if (rule->flags & RRF_NO_INDOOR)
+	if (rule->flags & NL80211_RRF_NO_INDOOR)
 		printf(", NO-INDOOR");
-	if (rule->flags & RRF_NO_OUTDOOR)
+	if (rule->flags & NL80211_RRF_NO_OUTDOOR)
 		printf(", NO-OUTDOOR");
-	if (rule->flags & RRF_DFS)
+	if (rule->flags & NL80211_RRF_DFS)
 		printf(", DFS");
-	if (rule->flags & RRF_PTP_ONLY)
+	if (rule->flags & NL80211_RRF_PTP_ONLY)
 		printf(", PTP-ONLY");
-	if (rule->flags & RRF_PTMP_ONLY)
+	if (rule->flags & NL80211_RRF_PTMP_ONLY)
 		printf(", PTMP-ONLY");
-	if (rule->flags & RRF_PASSIVE_SCAN)
+	if (rule->flags & NL80211_RRF_PASSIVE_SCAN)
 		printf(", PASSIVE-SCAN");
-	if (rule->flags & RRF_NO_IBSS)
+	if (rule->flags & NL80211_RRF_NO_IBSS)
 		printf(", NO-IBSS");
 
 	printf("\n");
diff --git a/reglib.c b/reglib.c
index 3cb7f72..12698fa 100644
--- a/reglib.c
+++ b/reglib.c
@@ -13,6 +13,7 @@
 #include <arpa/inet.h> /* ntohl */
 
 #include "reglib.h"
+#include "regdb.h"
 
 #ifdef USE_OPENSSL
 #include <openssl/objects.h>
diff --git a/reglib.h b/reglib.h
index 42c7999..99e6c76 100644
--- a/reglib.h
+++ b/reglib.h
@@ -4,8 +4,6 @@
 #include <stdlib.h>
 #include <stdint.h>
 
-#include "regdb.h"
-
 /* Common regulatory structures, functions and helpers */
 
 /* This matches the kernel's data structures */
-- 
1.7.4.15.g7811d

