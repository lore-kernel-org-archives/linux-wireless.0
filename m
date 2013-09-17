Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:39500 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3IQGZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 02:25:47 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so2457953eae.38
        for <linux-wireless@vger.kernel.org>; Mon, 16 Sep 2013 23:25:45 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, rodrigue@qca.qualcomm.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] cfg80211: parse dfs region for internal regdb option
Date: Tue, 17 Sep 2013 08:25:36 +0200
Message-Id: <1379399136-3181-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20130917_082645_746795_B2BB7D43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for parsing and setting the dfs region (ETSI, FCC, JP)
when the internal regulatory database is used. Before this
the DFS region was being ignored even if present on the used
db.txt

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/genregdb.awk |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 9392f8c..42ed274 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -46,6 +46,12 @@ BEGIN {
 	sub(/:/, "", country)
 	printf "static const struct ieee80211_regdomain regdom_%s = {\n", country
 	printf "\t.alpha2 = \"%s\",\n", country
+	if ($NF ~ /DFS-ETSI/)
+		printf "\t.dfs_region = NL80211_DFS_ETSI,\n"
+	else if ($NF ~ /DFS-FCC/)
+		printf "\t.dfs_region = NL80211_DFS_FCC,\n"
+	else if ($NF ~ /DFS-JP/)
+		printf "\t.dfs_region = NL80211_DFS_JP,\n"
 	printf "\t.reg_rules = {\n"
 	active = 1
 	regdb = regdb "\t&regdom_" country ",\n"
-- 
1.7.9.5

