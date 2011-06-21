Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1FUHpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 03:45:36 -0400
Subject: [PATCH] nl80211: use netlink consistent dump feature for BSS dumps
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 09:45:33 +0200
Message-ID: <1308642333.3900.2.camel@jlt3.sipsolutions.net> (sfid-20110621_094539_411949_057FD9EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the new consistent dump feature from (generic) netlink
to advertise when dumps are incomplete.

Readers may note that this does not initialize the
rdev->bss_generation counter to a non-zero value. This is
still OK since the value is modified only under spinlock
when the list is modified. Since the dump code holds the
spinlock, the value will either be > 0 already, or the
list will still be empty in which case a consistent dump
will actually be made (and be empty).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/wireless/nl80211.c	2011-06-20 13:34:43.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-06-20 13:39:58.000000000 +0200
@@ -3620,7 +3620,8 @@ static int nl80211_stop_sched_scan(struc
 	return __cfg80211_stop_sched_scan(rdev, false);
 }
 
-static int nl80211_send_bss(struct sk_buff *msg, u32 pid, u32 seq, int flags,
+static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
+			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev,
 			    struct cfg80211_internal_bss *intbss)
@@ -3632,11 +3633,13 @@ static int nl80211_send_bss(struct sk_bu
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	hdr = nl80211hdr_put(msg, pid, seq, flags,
+	hdr = nl80211hdr_put(msg, NETLINK_CB(cb->skb).pid, seq, flags,
 			     NL80211_CMD_NEW_SCAN_RESULTS);
 	if (!hdr)
 		return -1;
 
+	genl_dump_check_consistent(cb, hdr, &nl80211_fam);
+
 	NLA_PUT_U32(msg, NL80211_ATTR_GENERATION, rdev->bss_generation);
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex);
 
@@ -3725,11 +3728,12 @@ static int nl80211_dump_scan(struct sk_b
 	spin_lock_bh(&rdev->bss_lock);
 	cfg80211_bss_expire(rdev);
 
+	cb->seq = rdev->bss_generation;
+
 	list_for_each_entry(scan, &rdev->bss_list, list) {
 		if (++idx <= start)
 			continue;
-		if (nl80211_send_bss(skb,
-				NETLINK_CB(cb->skb).pid,
+		if (nl80211_send_bss(skb, cb,
 				cb->nlh->nlmsg_seq, NLM_F_MULTI,
 				rdev, wdev, scan) < 0) {
 			idx--;


