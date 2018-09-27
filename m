Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDCAC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 12:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2CE2168B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 12:37:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF2CE2168B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbeI0SzH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 14:55:07 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55246 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbeI0SzH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 14:55:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5VXQ-0003vk-4i; Thu, 27 Sep 2018 14:37:00 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: remove nl80211_prepare_wdev_dump() skb argument
Date:   Thu, 27 Sep 2018 14:36:44 +0200
Message-Id: <20180927123644.14507-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

nl80211_prepare_wdev_dump() is using the output skb to look up
the network namespace, but this isn't really necessary, it can
just as well use the input skb which is available as cb->skb,
the sk is the same anyway.

Therefore, remove the redundant argument.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 73123b7563a0..49537073e0a1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -623,8 +623,7 @@ nl80211_packet_pattern_policy[MAX_NL80211_PKTPAT + 1] = {
 	[NL80211_PKTPAT_OFFSET] = { .type = NLA_U32 },
 };
 
-static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
-				     struct netlink_callback *cb,
+static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
 				     struct wireless_dev **wdev)
 {
@@ -638,7 +637,7 @@ static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 			return err;
 
 		*wdev = __cfg80211_wdev_from_attrs(
-					sock_net(skb->sk),
+					sock_net(cb->skb->sk),
 					genl_family_attrbuf(&nl80211_fam));
 		if (IS_ERR(*wdev))
 			return PTR_ERR(*wdev);
@@ -4808,7 +4807,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
 	int err;
 
 	rtnl_lock();
-	err = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
+	err = nl80211_prepare_wdev_dump(cb, &rdev, &wdev);
 	if (err)
 		goto out_err;
 
@@ -5628,7 +5627,7 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 	int err;
 
 	rtnl_lock();
-	err = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
+	err = nl80211_prepare_wdev_dump(cb, &rdev, &wdev);
 	if (err)
 		goto out_err;
 
@@ -5824,7 +5823,7 @@ static int nl80211_dump_mpp(struct sk_buff *skb,
 	int err;
 
 	rtnl_lock();
-	err = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
+	err = nl80211_prepare_wdev_dump(cb, &rdev, &wdev);
 	if (err)
 		goto out_err;
 
@@ -8100,7 +8099,7 @@ static int nl80211_dump_scan(struct sk_buff *skb, struct netlink_callback *cb)
 	int err;
 
 	rtnl_lock();
-	err = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
+	err = nl80211_prepare_wdev_dump(cb, &rdev, &wdev);
 	if (err) {
 		rtnl_unlock();
 		return err;
@@ -8221,7 +8220,7 @@ static int nl80211_dump_survey(struct sk_buff *skb, struct netlink_callback *cb)
 	bool radio_stats;
 
 	rtnl_lock();
-	res = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
+	res = nl80211_prepare_wdev_dump(cb, &rdev, &wdev);
 	if (res)
 		goto out_err;
 
-- 
2.14.4

