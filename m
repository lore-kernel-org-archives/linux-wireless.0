Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48375 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbbK0VKt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 16:10:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix off-channel mgmt-tx unintialized variable usage
Date: Fri, 27 Nov 2015 22:10:46 +0100
Message-Id: <1448658646-30499-1-git-send-email-johannes@sipsolutions.net> (sfid-20151127_221055_959510_7EAF0E8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the previous commit, I neglected to update the cookie in one code
path: when a mgmt-tx has no real cookie sent to userspace as it doesn't
wait for a response, but is off-channel. The original code used the SKB
pointer as the cookie and always assigned the cookie to the TX SKB in
ieee80211_start_roc_work(), but my change turned this around and made
the code rely on a valid cookie being passed in.

Unfortunately, the off-channel no-wait TX path wasn't assigning one at
all, resulting in an uninitialized stack value being used. This wasn't
handed back to userspace as a cookie (since in the no-wait case there
isn't a cookie), but it was tested for non-zero to distinguish between
mgmt-tx and off-channel.

Fix this by assigning a dummy non-zero cookie unconditionally, and get
rid of a misleading comment and some dead code while at it. I'll clean
up the ACK SKB handling separately later.

Fixes: 3b79af973cf4 ("mac80211: stop using pointers as userspace cookies")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c2bd1b6a6922..df7550bf196e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3454,8 +3454,12 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			goto out_unlock;
 		}
 	} else {
-		/* for cookie below */
-		ack_skb = skb;
+		/* assign a dummy non-zero cookie, it's not sent to
+		 * userspace in this case but we rely on its value
+		 * internally in the need_offchan case to distinguish
+		 * mgmt-tx from remain-on-channel;
+		 */
+		*cookie = 0xffffffff;
 	}
 
 	if (!need_offchan) {
-- 
2.6.2

