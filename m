Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38849 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3HNLuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 07:50:23 -0400
Date: Wed, 14 Aug 2013 14:50:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] nl80211: nl80211hdr_put() doesn't return an ERR_PTR
Message-ID: <20130814115001.GB8044@elgon.mountain> (sfid-20130814_135027_737308_524F1C3F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a few places which check nl80211hdr_put() for an ERR_PTR
but actually it returns NULL on error and never error values.  In
nl80211_testmode_dump() the return wasn't checked at all so I have added
one.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is static checker stuff and I don't know the code well.  I was
especially not sure if I got the check right in nl80211_testmode_dump().
Please review that bit carefully.

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index adf1e98..47b8ac5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2664,8 +2664,8 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 
 	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
 			     NL80211_CMD_NEW_KEY);
-	if (IS_ERR(hdr))
-		return PTR_ERR(hdr);
+	if (!hdr)
+		return -ENOBUFS;
 
 	cookie.msg = msg;
 	cookie.idx = key_idx;
@@ -6665,10 +6665,14 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 	}
 
 	while (1) {
-		void *hdr = nl80211hdr_put(skb, NETLINK_CB(cb->skb).portid,
+		void *hdr;
+		struct nlattr *tmdata;
+
+		hdr = nl80211hdr_put(skb, NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
 					   NL80211_CMD_TESTMODE);
-		struct nlattr *tmdata;
+		if (!hdr)
+			break;
 
 		if (nla_put_u32(skb, NL80211_ATTR_WIPHY, phy_idx)) {
 			genlmsg_cancel(skb, hdr);
@@ -7115,8 +7119,8 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
 			     NL80211_CMD_REMAIN_ON_CHANNEL);
 
-	if (IS_ERR(hdr)) {
-		err = PTR_ERR(hdr);
+	if (!hdr) {
+		err = -ENOBUFS;
 		goto free_msg;
 	}
 
@@ -7415,8 +7419,8 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
 				     NL80211_CMD_FRAME);
 
-		if (IS_ERR(hdr)) {
-			err = PTR_ERR(hdr);
+		if (!hdr) {
+			err = -ENOBUFS;
 			goto free_msg;
 		}
 	}
@@ -8552,8 +8556,8 @@ static int nl80211_probe_client(struct sk_buff *skb,
 	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
 			     NL80211_CMD_PROBE_CLIENT);
 
-	if (IS_ERR(hdr)) {
-		err = PTR_ERR(hdr);
+	if (!hdr) {
+		err = -ENOBUFS;
 		goto free_msg;
 	}
 
