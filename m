Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:38810 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaANR3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 12:29:48 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so375507eei.12
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 09:29:47 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 3/5] cfg80211: parse DFS CAC time for internal regdb option
Date: Tue, 14 Jan 2014 18:29:28 +0100
Message-Id: <1389720570-2430-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_182956_408074_54B48E9C)
In-Reply-To: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for parsing DFS CAC time when internal
regulatory database is used.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/genregdb.awk |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 9a8217d..d48f881 100644
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
+	printf "\t\tREG_RULE_DFS(%d, %d, %d, %d, %d, %d, %s),\n", start, end, bw, gain, power, dfs_cac, flags
 	rules++
 }
 
-- 
1.7.9.5

