Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:52515 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3JURmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:42:19 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so7055023wes.28
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:42:18 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] crda: consolidate passive-scan and no-ibss flags
Date: Mon, 21 Oct 2013 19:42:15 +0200
Message-Id: <1382377335-26425-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_194221_938850_B5D2A76C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We consolidate these two flags into one flag to indicate
initiating radiation is not allowed.

For parsing we'll treat the no-ibss flag moving forward
as also passive-scan as well, newer kernels will always
treat these equally, older kernels will use the still
use them separately even though in practice they are
used together interchangably.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 regdb.h  | 6 ++++--
 reglib.c | 9 +++++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/regdb.h b/regdb.h
index 4508621..20f29e9 100644
--- a/regdb.h
+++ b/regdb.h
@@ -79,10 +79,12 @@ enum reg_rule_flags {
 					 * links */
 	RRF_PTMP_ONLY		= 1<<6, /* this is only for Point To Multi
 					 * Point links */
-	RRF_PASSIVE_SCAN	= 1<<7, /* passive scan is required */
-	RRF_NO_IBSS		= 1<<8, /* IBSS is not allowed */
+	RRF_NO_IR		= 1<<7, /* do not initiate radiation */
+	__RRF_NO_IBSS		= 1<<8, /* old no-IBSS rule, maps to no-ir */
 };
 
+#define RRF_NO_IR_ALL	(RRF_NO_IR | __RRF_NO_IBSS)
+
 /**
  * enum regdb_dfs_regions - regulatory DFS regions
  *
diff --git a/reglib.c b/reglib.c
index 64584f4..fa6efe0 100644
--- a/reglib.c
+++ b/reglib.c
@@ -313,6 +313,9 @@ static void reg_rule2rd(uint8_t *db, size_t dblen,
 	rd_power_rule->max_eirp = ntohl(power->max_eirp);
 
 	rd_reg_rule->flags = ntohl(rule->flags);
+
+	if (rd_reg_rule->flags & RRF_NO_IR_ALL)
+		rd_reg_rule->flags |= RRF_NO_IR_ALL;
 }
 
 /* Converts a file regdomain to ieee80211_regdomain, easier to manage */
@@ -694,10 +697,8 @@ static void print_reg_rule(const struct ieee80211_reg_rule *rule)
 		printf(", PTP-ONLY");
 	if (rule->flags & RRF_PTMP_ONLY)
 		printf(", PTMP-ONLY");
-	if (rule->flags & RRF_PASSIVE_SCAN)
-		printf(", PASSIVE-SCAN");
-	if (rule->flags & RRF_NO_IBSS)
-		printf(", NO-IBSS");
+	if (rule->flags & RRF_NO_IR_ALL)
+		printf(", NO-IR");
 
 	printf("\n");
 }
-- 
1.8.4.rc3

