Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62770 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3KKTj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 14:39:56 -0500
Received: by mail-bk0-f46.google.com with SMTP id e11so1834161bkh.5
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 11:39:53 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org, mcgrof@do-not-panic.com
Subject: [PATCH] reglib: fix memset usage
Date: Mon, 11 Nov 2013 20:39:50 +0100
Message-ID: <2765421.8z1iAPSgk6@blech> (sfid-20131111_204004_513722_F3E1F31C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc-4.8 fails to compile reglib due to:

reglib.c:1133:22: error: argument to ‘sizeof’ in ‘memset’ call is
			 the same expression as the destination; did you mean
			 to dereference it? [-Werror=sizeof-pointer-memaccess]
  memset(rd, 0, sizeof(rd));
                      ^
reglib.c:1155:22: error: argument to ‘sizeof’ in... (same as above)

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 reglib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/reglib.c b/reglib.c
index 9577ada..1e57634 100644
--- a/reglib.c
+++ b/reglib.c
@@ -1127,7 +1127,7 @@ reglib_parse_country_simple(char *line, struct ieee80211_regdomain *rd)
 	char alpha2[2];
 	int hits;
 
-	memset(rd, 0, sizeof(rd));
+	memset(rd, 0, sizeof(*rd));
 	memset(alpha2, 0, sizeof(alpha2));
 	memset(dfs_region_alpha, 0, sizeof(dfs_region_alpha));
 
@@ -1149,7 +1149,7 @@ static int reglib_parse_country_dfs(char *line, struct ieee80211_regdomain *rd)
 	char alpha2[2];
 	int hits;
 
-	memset(rd, 0, sizeof(rd));
+	memset(rd, 0, sizeof(*rd));
 	memset(alpha2, 0, sizeof(alpha2));
 	memset(dfs_region_alpha, 0, sizeof(dfs_region_alpha));
 
-- 
1.8.4.2

