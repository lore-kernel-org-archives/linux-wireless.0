Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49829 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaJVJbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 05:31:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't remove tainted keys after not programming
Date: Wed, 22 Oct 2014 11:30:51 +0200
Message-Id: <1413970251-29354-1-git-send-email-johannes@sipsolutions.net> (sfid-20141022_113104_858289_ABD38974)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a key is tainted during resume, it is no longer programmed
into the device; however, it's uploaded flag may (will) be set.
Clear the flag when not programming it because it's tainted to
avoid attempting to remove it again later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 4712150dc210..434a91ad12c8 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -94,8 +94,17 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 	might_sleep();
 
-	if (key->flags & KEY_FLAG_TAINTED)
+	if (key->flags & KEY_FLAG_TAINTED) {
+		/* If we get here, it's during resume and the key is
+		 * tainted so shouldn't be used/programmed any more.
+		 * However, its flags may still indicate that it was
+		 * programmed into the device (since we're in resume)
+		 * so clear that flag now to avoid trying to remove
+		 * it again later.
+		 */
+		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 		return -EINVAL;
+	}
 
 	if (!key->local->ops->set_key)
 		goto out_unsupported;
-- 
2.1.0

