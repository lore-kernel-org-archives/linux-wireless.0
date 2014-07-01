Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42380 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbaGAUaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 16:30:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: fixup genregdb.awk for remove of antenna gain from wireless-regdb
Date: Tue,  1 Jul 2014 16:17:54 -0400
Message-Id: <1404245874-350-1-git-send-email-linville@tuxdriver.com> (sfid-20140701_223023_012879_A749E7BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since "wireless-regdb: remove antenna gain" was merged in the
wireless-regdb tree, this script has been incompatible with the
'official' regulatory database.  Let's fix it up.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
I think the dfs_cac stuff is still broken, since it does not account
for the starting offset of the flags.

 net/wireless/genregdb.awk | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 40c37fc5b67c..c4f90ddb1a7d 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -56,21 +56,19 @@ function parse_reg_rule()
 	end = $3
 	bw = $5
 	sub(/\),/, "", bw)
-	gain = $6
-	sub(/\(/, "", gain)
-	sub(/,/, "", gain)
-	power = $7
+	power = $6
+	sub(/\(/, "", power)
 	sub(/\)/, "", power)
 	sub(/,/, "", power)
 	# power might be in mW...
-	units = $8
+	units = $7
 	sub(/\)/, "", units)
 	sub(/,/, "", units)
-	dfs_cac = $9
+	dfs_cac = $8
 	if (units == "mW") {
 		power = 10 * log(power)/log(10)
 	} else {
-		dfs_cac = $8
+		dfs_cac = $7
 	}
 	sub(/,/, "", dfs_cac)
 	sub(/\(/, "", dfs_cac)
@@ -107,7 +105,7 @@ function parse_reg_rule()
 
 	}
 	flags = flags "0"
-	printf "\t\tREG_RULE_EXT(%d, %d, %d, %d, %.0f, %d, %s),\n", start, end, bw, gain, power, dfs_cac, flags
+	printf "\t\tREG_RULE_EXT(%d, %d, %d, 0, %.0f, %d, %s),\n", start, end, bw, power, dfs_cac, flags
 	rules++
 }
 
-- 
1.9.3

