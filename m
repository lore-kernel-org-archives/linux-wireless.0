Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1KDKBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:01:50 -0400
Subject: [PATCH] cfg80211: fix cmp_ies
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 11:01:46 +0100
Message-ID: <1320400906.3969.70.camel@jlt3.sipsolutions.net> (sfid-20111104_110155_529872_2BCA6083)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When comparing two items by IE, the sort order
wasn't stable, which could lead to issues in the
rbtree. Make it stable by making a missing IE
sort before a present IE.

Also sort by length first if it differs and then
by contents.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/wireless/scan.c	2011-11-03 13:48:30.000000000 +0100
+++ b/net/wireless/scan.c	2011-11-04 09:38:25.000000000 +0100
@@ -259,17 +259,20 @@ static int cmp_ies(u8 num, u8 *ies1, siz
 {
 	const u8 *ie1 = cfg80211_find_ie(num, ies1, len1);
 	const u8 *ie2 = cfg80211_find_ie(num, ies2, len2);
-	int r;
 
+	/* equal if both missing */
 	if (!ie1 && !ie2)
 		return 0;
-	if (!ie1 || !ie2)
+	/* sort missing IE before (left of) present IE */
+	if (!ie1)
 		return -1;
+	if (!ie2)
+		return 1;
 
-	r = memcmp(ie1 + 2, ie2 + 2, min(ie1[1], ie2[1]));
-	if (r == 0 && ie1[1] != ie2[1])
+	/* sort by length first, then by contents */
+	if (ie1[1] != ie2[1])
 		return ie2[1] - ie1[1];
-	return r;
+	return memcmp(ie1 + 2, ie2 + 2, ie1[1]);
 }
 
 static bool is_bss(struct cfg80211_bss *a,


