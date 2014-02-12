Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55164 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaBLSyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 13:54:39 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so4510479eek.23
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 10:54:38 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/4] cfg80211: parse DFS CAC time for internal regdb option
Date: Wed, 12 Feb 2014 19:54:21 +0100
Message-Id: <1392231266-28479-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140212_195447_679013_B8EA20BA)
In-Reply-To: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for parsing DFS CAC time when internal
regulatory database is used.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/genregdb.awk |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 9a8217d..7683b47 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -66,6 +66,7 @@ function parse_reg_rule()
 	units = $8
 	sub(/\)/, "", units)
 	sub(/,/, "", units)
+	dfs_cac = $9
 	if (units == "mW") {
 		if (power == 100) {
 			power = 20
@@ -78,7 +79,12 @@ function parse_reg_rule()
 		} else {
 			print "Unknown power value in database!"
 		}
+	} else {
+		dfs_cac = $8
 	}
+	sub(/,/, "", dfs_cac)
+	sub(/\(/, "", dfs_cac)
+	sub(/\)/, "", dfs_cac)
 	flagstr = ""
 	for (i=8; i<=NF; i++)
 		flagstr = flagstr $i
@@ -109,7 +115,7 @@ function parse_reg_rule()
 
 	}
 	flags = flags "0"
-	printf "\t\tREG_RULE(%d, %d, %d, %d, %d, %s),\n", start, end, bw, gain, power, flags
+	printf "\t\tREG_RULE_EXT(%d, %d, %d, %d, %d, %d, %s),\n", start, end, bw, gain, power, dfs_cac, flags
 	rules++
 }
 
-- 
1.7.9.5

