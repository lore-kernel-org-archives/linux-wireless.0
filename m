Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2K2JAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 04:00:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] cfg80211: fix cmp_hidden_bss
Date: Thu, 29 Nov 2012 10:01:00 +0100
Message-Id: <1354179660-11964-1-git-send-email-johannes@sipsolutions.net> (sfid-20121129_100044_281945_8456D381)
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
 net/wireless/scan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9233910..456c342 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -469,10 +469,14 @@ static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
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

