Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44736 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751605AbdIRUuN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 16:50:13 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: fix null-ptr dereference on invalid mesh configuration
Date: Mon, 18 Sep 2017 22:50:10 +0200
Message-Id: <20170918205010.16669-1-johannes@sipsolutions.net> (sfid-20170918_225017_285229_54D079C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If TX rates are specified during mesh join, the channel must
also be specified. Check the channel pointer to avoid a null
pointer dereference if it isn't.

Reported-by: Jouni Malinen <j@w1.fi>
Fixes: 8564e38206de ("cfg80211: add checks for beacon rate, extend to mesh")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8ce85420ecb0..dfc8e6fff677 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9987,6 +9987,9 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 		if (err)
 			return err;
 
+		if (!setup.chandef.chan)
+			return -EINVAL;
+
 		err = validate_beacon_tx_rate(rdev, setup.chandef.chan->band,
 					      &setup.beacon_rate);
 		if (err)
-- 
2.14.1
