Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2DREBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 00:01:20 -0400
Message-ID: <1334721645.3672.2.camel@jlt3.sipsolutions.net> (sfid-20120418_060126_805647_32946400)
Subject: Re: [PATCH v2 2/6] mac80211: Support getting sta_info stats via
 ethtool.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 21:00:45 -0700
In-Reply-To: <4F8E3905.70900@candelatech.com>
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>
	  <1334684807-14026-3-git-send-email-greearb@candelatech.com>
	  (sfid-20120417_194716_243783_5644375D) <1334713070.3725.14.camel@jlt3.sipsolutions.net>
	 <4F8E3905.70900@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-17 at 20:46 -0700, Ben Greear wrote:

> >> +	rcu_read_lock();
> >> +	list_for_each_entry_rcu(sta,&local->sta_list, list) {
> >
> > This doesn't seem right -- shouldn't it look up the BSSID or something
> > and only work on managed interfaces? What if there really are two
> > stations on this interface -- then it'll just overwrite it and return a
> > random station's data? That's useless.
> 
> Well, its weird at least.
> 
> But, if there are multiple stations, like for APs??, then it will
> add the station's stats together.  Perhaps not horribly useful, but better
> than nothing.

Oh, right, it's adding, I missed that. But is that really useful?

> For managed interface, I *think* they don't have more than one station, right?

You can't rely on it. Typically they will, but with TDLS there might be
multiple.

> And, as for the underlying driver stats and survey stats (in later patches),
> that is only probed once.  I guess if you somehow had two
> stations on different channels on the same network device,
> the survey stats would be a bit dodgy, but it does return
> the freq for the stats in question, so at least you know
> what you are getting.

A single netdev is always going to be on a single channel. Actually, I
take that back, I think TDLS can work out of channel too, but we don't
support that right now.

johannes

