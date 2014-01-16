Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaAPNlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 08:41:12 -0500
Message-ID: <1389879668.4345.5.camel@jlt4.sipsolutions.net> (sfid-20140116_144133_912452_E79746FE)
Subject: Re: [PATCH] nl80211: Reset split_start on error path when split
 dump is not used
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 Jan 2014 14:41:08 +0100
In-Reply-To: <1389879279-20832-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20140116_143453_482265_044A6882)
References: <1389879279-20832-1-git-send-email-pontus.fuchs@gmail.com>
	 (sfid-20140116_143453_482265_044A6882)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-16 at 14:34 +0100, Pontus Fuchs wrote:
> When the netlink skb is exhausted split_start is left set. In the
> subsequent retry, with a larger buffer, the dump is continued from the
> failing point instead of from the beginning.

Hmm. Maybe it should be like this instead?

johannes

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 138dc3b..2e08af5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1680,6 +1680,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 				    !skb->len &&
 				    cb->min_dump_alloc < 4096) {
 					cb->min_dump_alloc = 4096;
+					state->split_start = 0;
 					rtnl_unlock();
 					return 1;
 				}


