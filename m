Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2K2KsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 05:48:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3] cfg80211: fix cmp_hidden_bss
Date: Thu, 29 Nov 2012 11:48:34 +0100
Message-Id: <1354186114-29513-1-git-send-email-johannes@sipsolutions.net> (sfid-20121129_114814_190773_CE378E2B)
In-Reply-To: <1354139095-22937-1-git-send-email-johannes@sipsolutions.net>
References: <1354139095-22937-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The cmp_bss() comparator function uses memcmp() to
compare the SSID. This means that cmp_hidden_bss()
needs to similarly return a number bigger than zero
(use 1) instead of -1 when ie1 is bigger than ie2,
which is the case if an ie2 byte is non-zero.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9233910..834e0d1 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -450,10 +450,16 @@ static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
 			       b->information_elements,
 			       b->len_information_elements);
 
-	/* Key comparator must use same algorithm in any rb-tree
+	/*
+	 * Key comparator must use same algorithm in any rb-tree
 	 * search function (order is important), otherwise ordering
 	 * of items in the tree is broken and search gives incorrect
-	 * results. This code uses same order as cmp_ies() does. */
+	 * results. This code uses same order as cmp_ies() does.
+	 *
+	 * Note that due to the differring behaviour with hidden SSIDs
+	 * this function only works when "b" is the tree element and
+	 * "a" is the key we're looking for.
+	 */
 
 	/* sort missing IE before (left of) present IE */
 	if (!ie1)
@@ -469,10 +475,14 @@ static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
 	if (ie1[1] != ie2[1])
 		return ie2[1] - ie1[1];
 
-	/* zeroed SSID ie is another indication of a hidden bss */
+	/*
+	 * zeroed SSID ie is another indication of a hidden bss;
+	 * if it isn't zeroed just return the regular sort value
+	 * to find the next candidate
+	 */
 	for (i = 0; i < ie2[1]; i++)
 		if (ie2[i + 2])
-			return -1;
+			return memcmp(ie1 + 2, ie2 + 2, ie1[1]);
 
 	return 0;
 }
-- 
1.8.0

