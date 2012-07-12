Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030292Ab2GLJ4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 05:56:44 -0400
Message-ID: <1342087000.4531.11.camel@jlt3.sipsolutions.net> (sfid-20120712_115658_371123_64E83BB6)
Subject: Re: pull-request: mac80211-next 2012-07-10
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 12 Jul 2012 11:56:40 +0200
In-Reply-To: <1342085261.4531.9.camel@jlt3.sipsolutions.net> (sfid-20120712_112748_417680_83E2626B)
References: <1341946090.4475.31.camel@jlt3.sipsolutions.net>
	 (sfid-20120710_204821_128762_BC016001) <1342085261.4531.9.camel@jlt3.sipsolutions.net>
	 (sfid-20120712_112748_417680_83E2626B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 11:27 +0200, Johannes Berg wrote:
> On Tue, 2012-07-10 at 20:48 +0200, Johannes Berg wrote:
> > John,
> > 
> > Please pull some more patches. I've included the first round of API
> > additions/updates for the P2P Device abstraction, I don't know if we'll
> > get the actual code done in time for 3.6 but I didn't want to hang on to
> > these APIs for too long to avoid conflicts.
> 
> Ugh, I found a bug with this, please drop, I'll respin. Sorry!

Ok the bug is this -- if we remove a wdev (that doesn't have a netdev),
this change is obviously needed:


diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 27cd18e..70452aa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6768,6 +6768,7 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 			info->user_ptr[1] = dev;
 		} else {
 			info->user_ptr[1] = wdev;
+			info->user_ptr[2] = wdev->netdev;
 		}
 
 		if (dev) {
@@ -6799,10 +6800,8 @@ static void nl80211_post_doit(struct genl_ops *ops, struct sk_buff *skb,
 		cfg80211_unlock_rdev(info->user_ptr[0]);
 	if (info->user_ptr[1]) {
 		if (ops->internal_flags & NL80211_FLAG_NEED_WDEV) {
-			struct wireless_dev *wdev = info->user_ptr[1];
-
-			if (wdev->netdev)
-				dev_put(wdev->netdev);
+			if (info->user_ptr[2])
+				dev_put(info->user_ptr[2]);
 		} else {
 			dev_put(info->user_ptr[1]);
 		}


I've rolled it into the patch that introduced the bug ("nl80211: add
NL80211_FLAG_NEED_WDEV") and will send a new pull request. Obviously,
I'm therefore rebasing my tree.

Sorry for the inconvenience!

johannes

