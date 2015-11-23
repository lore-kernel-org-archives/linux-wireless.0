Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40426 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbbKWIwM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 03:52:12 -0500
Message-ID: <1448268727.5792.0.camel@sipsolutions.net> (sfid-20151123_095215_992132_C832781B)
Subject: Re: [PATCH 2/2] ath9k: implement set_coalesce callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Olav Haugan <ohaugan@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, davem@davemloft.net,
	kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Date: Mon, 23 Nov 2015 09:52:07 +0100
In-Reply-To: <20151123041250.GA30745@codeaurora.org>
References: <1445712652-19327-1-git-send-email-ohaugan@codeaurora.org>
	 <1445712652-19327-2-git-send-email-ohaugan@codeaurora.org>
	 <1446199251.3261.22.camel@sipsolutions.net>
	 <20151123041250.GA30745@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-11-22 at 20:12 -0800, Olav Haugan wrote:
> On 15-10-30 11:00:51, Johannes Berg wrote:
> > On Sat, 2015-10-24 at 11:50 -0700, Olav Haugan wrote:
> > > implement set_coalesce ieee80211_ops callback. Add default
> > > wiphy_coalesce_support rules for 9k. These rules are not being
> > > used 
> > > by 9k since 9k can just toggle coalesce as on/off.
> > > 
> > This seems extremely strange to me - like you're trying to abuse
> > set_coalesce, intended for coalescing certain classes of low-
> > importance
> > packets, for a completely different purpose (interrupt coalescing)?
> > 
> Hmm, yes. We misunderstood how this API is used. Do you have any
> suggestion for how to accomplish what we are trying to do? We can't
> just add a new public user space API for this functionality.

ethtool usually has interrupt coalescing parameters.

johannes
