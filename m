Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab2FZPeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 11:34:23 -0400
Message-ID: <1340724861.4484.1.camel@jlt3.sipsolutions.net> (sfid-20120626_173427_038467_75C8D61B)
Subject: Re: [RFC v3 7/7] mac80211: reuse channels for channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jun 2012 17:34:21 +0200
In-Reply-To: <4FE9BF57.6080100@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
	  <1340714242-20032-8-git-send-email-michal.kazior@tieto.com>
	 <1340718113.14634.45.camel@jlt3.sipsolutions.net>
	 <4FE9BF57.6080100@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 15:55 +0200, Michal Kazior wrote:


> > I don't think I understand this, wouldn't it need some per-vif requested
> > channel type to work correctly? I don't see any chantype values coming
> > from the sdata here, so I don't think this could work?
> >
> > If say vif1 needs ht40+ and vif2 ht20, the channel context will be set
> > to ht40+, but then if vif1 goes away and you don't know anything about
> > vif2 at all, then how can this work? The way I see it, your code here
> > doesn't really do anything, except recalculate that ht40+ is compatible
> > with ht40+, or something like that? I guess I'm a bit confused, it seems
> > to me that this cannot work even in theory unless you have per-vif data.
> 
> It seems I must've had a mind-derp. I was planning on using 
> sdata->vif.bss_conf.channel_type which should be ok, right?

Yeah, unless you were planning to not go through
ieee80211_set_channel_type() any more in the future?

johannes

