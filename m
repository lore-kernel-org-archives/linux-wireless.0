Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:46483 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751149AbeACDAp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jan 2018 22:00:45 -0500
From: Hao Chen <flank3rsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hao Chen <flank3rsky@gmail.com>
Subject: [PATCH] nl80211: Check for the required netlink attribute presence
Date: Wed,  3 Jan 2018 11:00:31 +0800
Message-Id: <1514948431-20893-1-git-send-email-flank3rsky@gmail.com> (sfid-20180103_040058_967261_C90EDE54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211_nan_add_func() does not check if the required attribute
NL80211_NAN_FUNC_FOLLOW_UP_DEST is present when processing
NL80211_CMD_ADD_NAN_FUNCTION request. This request can be issued
by users with CAP_NET_ADMIN privilege and may result in NULL dereference
and a system crash. Add a check for the required attribute presence.

Signed-off-by: Hao Chen <flank3rsky@gmail.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 213d0c4..2b3dbcd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11361,7 +11361,8 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 		break;
 	case NL80211_NAN_FUNC_FOLLOW_UP:
 		if (!tb[NL80211_NAN_FUNC_FOLLOW_UP_ID] ||
-		    !tb[NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID]) {
+		    !tb[NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID] ||
+		    !tb[NL80211_NAN_FUNC_FOLLOW_UP_DEST]) {
 			err = -EINVAL;
 			goto out;
 		}
-- 
1.9.1
