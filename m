Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CANwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 08:52:31 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] nl80211: increase wiphy dump size dynamically
Date: Fri,  1 Mar 2013 14:52:26 +0100
Message-Id: <1362145946-16023-1-git-send-email-johannes@sipsolutions.net> (sfid-20130301_145234_690249_AA159861)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Given a device with many channels capabilities the wiphy
information can still overflow even though its size in
3.9 was reduced to 3.8 levels. For new userspace and
kernel 3.10 we're going to implement a new "split dump"
protocol that can use multiple messages per wiphy.

For now though, add a workaround to be able to send more
information to userspace. Since generic netlink doesn't
have a way to set the minimum dump size globally, and we
wouldn't really want to set it globally anyway, increase
the size only when needed, as described in the comments.

Also increase the size for the get_wiphy command.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7a7b621..c773953 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1307,7 +1307,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 
 static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	int idx = 0;
+	int idx = 0, ret;
 	int start = cb->args[0];
 	struct cfg80211_registered_device *dev;
 
@@ -1317,9 +1317,29 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 			continue;
 		if (++idx <= start)
 			continue;
-		if (nl80211_send_wiphy(skb, NETLINK_CB(cb->skb).portid,
-				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				       dev) < 0) {
+		ret = nl80211_send_wiphy(skb, NETLINK_CB(cb->skb).portid,
+					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
+					 dev);
+		if (ret < 0) {
+			/*
+			 * If sending the wiphy data didn't fit (ENOBUFS or
+			 * EMSGSIZE returned), this SKB is still empty (so
+			 * it's not too big because another wiphy dataset is
+			 * already in the skb) and we've not tried to adjust
+			 * the dump allocation yet ... then adjust the alloc
+			 * size to be bigger, and return 1 but with the empty
+			 * skb. This results in an empty message being RX'ed
+			 * in userspace, but that is ignored.
+			 *
+			 * We can then retry with the larger buffer.
+			 */
+			if ((ret == -ENOBUFS || ret == -EMSGSIZE) &&
+			    !skb->len &&
+			    cb->min_dump_alloc < SKB_WITH_OVERHEAD(8192UL)) {
+				cb->min_dump_alloc = SKB_WITH_OVERHEAD(8192UL);
+				mutex_unlock(&cfg80211_mutex);
+				return 1;
+			}
 			idx--;
 			break;
 		}
@@ -1336,7 +1356,7 @@ static int nl80211_get_wiphy(struct sk_buff *skb, struct genl_info *info)
 	struct sk_buff *msg;
 	struct cfg80211_registered_device *dev = info->user_ptr[0];
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	msg = nlmsg_new(SKB_WITH_OVERHEAD(8192UL), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-- 
1.8.0

