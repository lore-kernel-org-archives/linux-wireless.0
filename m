Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35919 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbbETJht (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 05:37:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix memory leak
Date: Wed, 20 May 2015 11:37:46 +0200
Message-Id: <1432114666-16034-1-git-send-email-johannes@sipsolutions.net> (sfid-20150520_113752_941793_613AF598)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My recent change here introduced a possible memory leak if the
driver registers an invalid cipher schemes. This won't really
happen in practice, but fix the leak nonetheless.

Fixes: e3a55b5399d55 ("mac80211: validate cipher scheme PN length better")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 3c956c5f99b2..99d27babd9f0 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -770,8 +770,10 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 
 		for (r = 0; r < local->hw.n_cipher_schemes; r++) {
 			suites[w++] = cs[r].cipher;
-			if (WARN_ON(cs[r].pn_len > IEEE80211_MAX_PN_LEN))
+			if (WARN_ON(cs[r].pn_len > IEEE80211_MAX_PN_LEN)) {
+				kfree(suites);
 				return -EINVAL;
+			}
 		}
 	}
 
-- 
2.1.4

