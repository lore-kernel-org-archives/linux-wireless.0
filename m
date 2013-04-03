Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:35448 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874Ab3DCNwH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 09:52:07 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: johannes@sipsolutions.net, rodrigue@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] crda: display DFS regulatory domain in regdbdump
Date: Wed,  3 Apr 2013 15:51:58 +0200
Message-Id: <1364997118-14072-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130403_155212_791461_B643FC61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 print-regdom.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/print-regdom.c b/print-regdom.c
index 075eea8..9c65872 100644
--- a/print-regdom.c
+++ b/print-regdom.c
@@ -7,6 +7,22 @@
 
 #include "reglib.h"
 
+static const char *dfs_domain_name(enum nl80211_dfs_regions region)
+{
+	switch (region) {
+	case NL80211_DFS_UNSET:
+		return "DFS-UNSET";
+	case NL80211_DFS_FCC:
+		return "DFS-FCC";
+	case NL80211_DFS_ETSI:
+		return "DFS-ETSI";
+	case NL80211_DFS_JP:
+		return "DFS-JP";
+	default:
+		return "DFS-invalid";
+	}
+}
+
 static void print_reg_rule(struct ieee80211_reg_rule *rule)
 {
 	struct ieee80211_freq_range *freq;
@@ -57,7 +73,8 @@ static void print_reg_rule(struct ieee80211_reg_rule *rule)
 void print_regdom(struct ieee80211_regdomain *rd)
 {
 	unsigned int i;
-	printf("country %.2s:\n", rd->alpha2);
+	printf("country %.2s: %s\n", rd->alpha2,
+	       dfs_domain_name(rd->dfs_region));
 	for (i = 0; i < rd->n_reg_rules; i++)
 		print_reg_rule(&rd->reg_rules[i]);
 	printf("\n");
-- 
1.7.4.1

