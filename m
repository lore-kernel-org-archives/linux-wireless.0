Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34534 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754497AbdFWJ0m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 05:26:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 12:26:33 +0300
Message-Id: <20170623092633.23026-1-luca@coelho.fi> (sfid-20170623_112654_208458_7D116F19)
Subject: [PATCH] nl80211: Don't verify owner_nlportid on NAN commands
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

If NAN interface is created with NL80211_ATTR_SOCKET_OWNER, the socket
that is used to create the interface is used for all NAN operations and
reporting NAN events.
However, it turns out that sending commands and receiving events on
the same socket is not possible in a completely race-free way:
If the socket buffer is overflowed by the events, the command response
will not be sent. In that case the caller will block forever on recv.
Using non-blocking socket for commands is more complicated and still
the command response or ack may not be received.
So, keep unicasting NAN events to the interface creator, but allow
using a different socket for commands.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5487cd775b6f..45ba3d0872cc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11206,10 +11206,6 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 	if (!info->attrs[NL80211_ATTR_NAN_FUNC])
 		return -EINVAL;
 
-	if (wdev->owner_nlportid &&
-	    wdev->owner_nlportid != info->snd_portid)
-		return -ENOTCONN;
-
 	err = nla_parse_nested(tb, NL80211_NAN_FUNC_ATTR_MAX,
 			       info->attrs[NL80211_ATTR_NAN_FUNC],
 			       nl80211_nan_func_policy, info->extack);
@@ -11441,10 +11437,6 @@ static int nl80211_nan_del_func(struct sk_buff *skb,
 	if (!info->attrs[NL80211_ATTR_COOKIE])
 		return -EINVAL;
 
-	if (wdev->owner_nlportid &&
-	    wdev->owner_nlportid != info->snd_portid)
-		return -ENOTCONN;
-
 	cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
 
 	rdev_del_nan_func(rdev, wdev, cookie);
-- 
2.11.0
