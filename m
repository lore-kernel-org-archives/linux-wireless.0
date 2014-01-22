Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:33775 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbaAVMoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 07:44:16 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so4586840ead.36
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 04:44:15 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 3/3] cfg80211: parse WIDE-BW flag for internal regdb option
Date: Wed, 22 Jan 2014 13:43:44 +0100
Message-Id: <1390394624-3927-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140122_134420_634306_C2A154CB)
In-Reply-To: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for parsing WIDE-BW country flag when
internal regulatory database is used.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/genregdb.awk |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 9a8217d..22ffada 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -38,12 +38,26 @@ function parse_country_head() {
 	sub(/:/, "", country)
 	printf "static const struct ieee80211_regdomain regdom_%s = {\n", country
 	printf "\t.alpha2 = \"%s\",\n", country
-	if ($NF ~ /DFS-ETSI/)
-		printf "\t.dfs_region = NL80211_DFS_ETSI,\n"
-	else if ($NF ~ /DFS-FCC/)
-		printf "\t.dfs_region = NL80211_DFS_FCC,\n"
-	else if ($NF ~ /DFS-JP/)
-		printf "\t.dfs_region = NL80211_DFS_JP,\n"
+
+	flagstr = ""
+	dfs_region = ""
+	for (i=3; i<=NF; i++)
+		flagstr = flagstr $i
+	split(flagstr, flagarray, ",")
+	for (arg in flagarray) {
+		if (flagarray[arg] == "WIDE-BW")
+			printf "\t.flags = NL80211_REG_FLAG_WIDE_BW,\n"
+		if (flagarray[arg] == "DFS-ETSI")
+			dfs_region = "NL80211_DFS_ETSI"
+		if (flagarray[arg] == "DFS-FCC")
+			dfs_region = "NL80211_DFS_FCC"
+		if (flagarray[arg] == "DFS-JP")
+			dfs_region = "NL80211_DFS_JP"
+	}
+
+	if (dfs_region != "")
+		printf "\t.dfs_region = %s,\n", dfs_region
+
 	printf "\t.reg_rules = {\n"
 	active = 1
 	regdb = regdb "\t&regdom_" country ",\n"
-- 
1.7.9.5

