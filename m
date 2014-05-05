Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbaEEJXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 05:23:53 -0400
Message-ID: <1399281820.22235.4.camel@jlt4.sipsolutions.net> (sfid-20140505_112404_517852_A81215ED)
Subject: Re: [PATCH 3.15] cfg80211: allow restricting supported dfs regions
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 05 May 2014 11:23:40 +0200
In-Reply-To: <536757DA.1010205@openwrt.org>
References: <1399150555-36041-1-git-send-email-nbd@openwrt.org>
	 <1399275222.22235.2.camel@jlt4.sipsolutions.net>
	 <536757DA.1010205@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-05 at 11:20 +0200, Felix Fietkau wrote:

> >> Add a bitmap in the interface combinations, indicating which DFS regions
> >> are supported by the detector.
> > 
> > Does that make sense? It seems unlikely to me that it would be interface
> > combination specific?
> Having it there made about as much sense to me as having the supportede
> channel width there :)
> Got any better suggestions?

Not really, it does make sense to group them, though the only real
reason to do it there originally was to prohibit multi-channel usage
with radar detection, so that made sense ... I have no real problem
doing this here as well.

> > I think it's already questionable to put this in after -rc4, in
> > particular with the userspace advertising part. Can we do anything
> > else? 
> I mostly pushed it for 3.15, because right now you can already enable
> DFS and it will bring it up on a FCC regdomain and it will appear to be
> working (but probably just not recognize any radars).
> 
> However, now that I look at the description of the options that you have
> to enable, it should be clear enough that this is not guaranteed to be
> functional yet, so I guess it can wait for 3.16.

Ok.

johannes

