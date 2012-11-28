Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab2K1Vob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 16:44:31 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix cmp_hidden_bss
Date: Wed, 28 Nov 2012 22:44:55 +0100
Message-Id: <1354139095-22937-1-git-send-email-johannes@sipsolutions.net> (sfid-20121128_224434_557114_B5AB2119)
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
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9233910..57855bc 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -472,7 +472,7 @@ static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
 	/* zeroed SSID ie is another indication of a hidden bss */
 	for (i = 0; i < ie2[1]; i++)
 		if (ie2[i + 2])
-			return -1;
+			return 1;
 
 	return 0;
 }
-- 
1.8.0

