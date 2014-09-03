Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60201 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbaICJNm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 05:13:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.17] nl80211: clear skb cb before passing to netlink
Date: Wed,  3 Sep 2014 11:13:36 +0200
Message-Id: <1409735616-31294-1-git-send-email-johannes@sipsolutions.net> (sfid-20140903_111346_051207_BEFE9D3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In testmode and vendor command reply/event SKBs we use the
skb cb data to store nl80211 parameters between allocation
and sending. This causes the code for CONFIG_NETLINK_MMAP
to get confused, because it takes ownership of the skb cb
data when the SKB is handed off to netlink, and it doesn't
explicitly clear it.

Clear the skb cb explicitly when we're done and before it
gets passed to netlink to avoid this issue.

Cc: stable@vger.kernel.org [this goes way back]
Reported-by: Assaf Azulay <assaf.azulay@intel.com>
Reported-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index df7b1332a1ec..7257164af91b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6969,6 +6969,9 @@ void __cfg80211_send_event_skb(struct sk_buff *skb, gfp_t gfp)
 	struct nlattr *data = ((void **)skb->cb)[2];
 	enum nl80211_multicast_groups mcgrp = NL80211_MCGRP_TESTMODE;
 
+	/* clear CB data for netlink core to own from now on */
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
 
@@ -9294,6 +9297,9 @@ int cfg80211_vendor_cmd_reply(struct sk_buff *skb)
 	void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
 
+	/* clear CB data for netlink core to own from now on */
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	if (WARN_ON(!rdev->cur_cmd_info)) {
 		kfree_skb(skb);
 		return -EINVAL;
-- 
2.1.0

