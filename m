Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54097 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3EaCLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:33 -0400
Received: by mail-pd0-f177.google.com with SMTP id u11so1368675pdi.8
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:33 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 25/40] crda: make print-regdom use internal flags
Date: Thu, 30 May 2013 19:09:14 -0700
Message-Id: <1369966169-23640-26-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042937_176005_555CB89B)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Do not rely on nl80211.h for general regulatory db parsing.
Its best to use our own OS agnostic definitions.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 print-regdom.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/print-regdom.c b/print-regdom.c
index ab122db..68c7b4e 100644
--- a/print-regdom.c
+++ b/print-regdom.c
@@ -3,20 +3,19 @@
 #include <string.h>
 #include <arpa/inet.h>
 
-#include "nl80211.h"
-
 #include "reglib.h"
+#include "regdb.h"
 
-static const char *dfs_domain_name(enum nl80211_dfs_regions region)
+static const char *dfs_domain_name(enum regdb_dfs_regions region)
 {
 	switch (region) {
-	case NL80211_DFS_UNSET:
+	case REGDB_DFS_UNSET:
 		return "DFS-UNSET";
-	case NL80211_DFS_FCC:
+	case REGDB_DFS_FCC:
 		return "DFS-FCC";
-	case NL80211_DFS_ETSI:
+	case REGDB_DFS_ETSI:
 		return "DFS-ETSI";
-	case NL80211_DFS_JP:
+	case REGDB_DFS_JP:
 		return "DFS-JP";
 	default:
 		return "DFS-invalid";
@@ -48,23 +47,23 @@ static void print_reg_rule(const struct ieee80211_reg_rule *rule)
 	else
 		printf("N/A)");
 
-	if (rule->flags & NL80211_RRF_NO_OFDM)
+	if (rule->flags & RRF_NO_OFDM)
 		printf(", NO-OFDM");
-	if (rule->flags & NL80211_RRF_NO_CCK)
+	if (rule->flags & RRF_NO_CCK)
 		printf(", NO-CCK");
-	if (rule->flags & NL80211_RRF_NO_INDOOR)
+	if (rule->flags & RRF_NO_INDOOR)
 		printf(", NO-INDOOR");
-	if (rule->flags & NL80211_RRF_NO_OUTDOOR)
+	if (rule->flags & RRF_NO_OUTDOOR)
 		printf(", NO-OUTDOOR");
-	if (rule->flags & NL80211_RRF_DFS)
+	if (rule->flags & RRF_DFS)
 		printf(", DFS");
-	if (rule->flags & NL80211_RRF_PTP_ONLY)
+	if (rule->flags & RRF_PTP_ONLY)
 		printf(", PTP-ONLY");
-	if (rule->flags & NL80211_RRF_PTMP_ONLY)
+	if (rule->flags & RRF_PTMP_ONLY)
 		printf(", PTMP-ONLY");
-	if (rule->flags & NL80211_RRF_PASSIVE_SCAN)
+	if (rule->flags & RRF_PASSIVE_SCAN)
 		printf(", PASSIVE-SCAN");
-	if (rule->flags & NL80211_RRF_NO_IBSS)
+	if (rule->flags & RRF_NO_IBSS)
 		printf(", NO-IBSS");
 
 	printf("\n");
-- 
1.7.10.4

