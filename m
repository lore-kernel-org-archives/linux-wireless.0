Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46406 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2GLKIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 06:08:20 -0400
Message-ID: <1342087697.4531.14.camel@jlt3.sipsolutions.net> (sfid-20120712_120824_446206_F3585520)
Subject: Re: pull-request: mac80211-next 2012-07-10
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 12 Jul 2012 12:08:17 +0200
In-Reply-To: <1342087211.4531.12.camel@jlt3.sipsolutions.net> (sfid-20120712_120018_674592_22967432)
References: <1341946090.4475.31.camel@jlt3.sipsolutions.net>
	 (sfid-20120710_204821_128762_BC016001) <1342085261.4531.9.camel@jlt3.sipsolutions.net>
	 (sfid-20120712_112748_417680_83E2626B) <1342087000.4531.11.camel@jlt3.sipsolutions.net>
	 (sfid-20120712_115658_371123_64E83BB6) <1342087211.4531.12.camel@jlt3.sipsolutions.net>
	 (sfid-20120712_120018_674592_22967432)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 12:00 +0200, Johannes Berg wrote:

> > Ok the bug is this -- if we remove a wdev (that doesn't have a netdev),
> > this change is obviously needed:

Better just handle the special case, I'm rolling this into the patch
"cfg80211: use wireless_dev for interface management":


--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2030,6 +2030,16 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->del_virtual_intf)
 		return -EOPNOTSUPP;
 
+	/*
+	 * If we remove a wireless device without a netdev then clear
+	 * user_ptr[1] so that nl80211_post_doit won't dereference it
+	 * to check if it needs to do dev_put(). Otherwise it crashes
+	 * since the wdev has been freed, unlike with a netdev where
+	 * we need the dev_put() for the netdev to really be freed.
+	 */
+	if (!wdev->netdev)
+		info->user_ptr[1] = NULL;
+
 	return rdev->ops->del_virtual_intf(&rdev->wiphy, wdev);
 }
 
johannes

