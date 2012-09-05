Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37078 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2IERXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 13:23:54 -0400
Received: by wgbdr13 with SMTP id dr13so857445wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 10:23:52 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] mac80211: use synchronize_net() on key destroying
Date: Wed,  5 Sep 2012 20:23:56 +0300
Message-Id: <1346865837-32265-2-git-send-email-eliad@wizery.com> (sfid-20120905_192357_077482_89D8F2AA)
In-Reply-To: <1346865837-32265-1-git-send-email-eliad@wizery.com>
References: <1346865837-32265-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__ieee80211_key_destroy() calls synchronize_rcu() in
order to sync the tx path before destroying the key.

However, synching the tx path can be done with
synchronize_net() as well, which is usually faster
(the timing might be important for roaming scenarios).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/key.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f86d09d..3d29d34 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -406,7 +406,7 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
 	 * Synchronize so the TX path can no longer be using
 	 * this key before we free/remove it.
 	 */
-	synchronize_rcu();
+	synchronize_net();
 
 	if (key->local)
 		ieee80211_key_disable_hw_accel(key);
-- 
1.7.6.401.g6a319

