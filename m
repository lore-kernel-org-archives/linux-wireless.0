Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43085 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3CDUPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:15:31 -0500
Message-ID: <1362428118.21028.45.camel@jlt4.sipsolutions.net> (sfid-20130304_211535_033397_8BEC9EB6)
Subject: Re: [PATCH] mac80211: provide race-free 64-bit traffic counters
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Mar 2013 21:15:18 +0100
In-Reply-To: <5134D604.3060608@candelatech.com>
References: <1362416578-1672-1-git-send-email-johannes@sipsolutions.net>
	 <5134D604.3060608@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 09:12 -0800, Ben Greear wrote:

[please trim quotes before and after the part you're replying to]

> >   	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
> > +	sinfo->tx_bytes = 0;
> > +	sinfo->tx_packets = 0;
> > +	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
> > +		sinfo->tx_bytes += sta->tx_bytes[ac];
> > +		sinfo->tx_packets += sta->tx_packets[ac];
> > +	}
> 
> I think you'll need tx_packets to be u64 as well, as otherwise
> if a queue wraps it's going to be quite hard to figure out?

Hmm, that's a good question. I guess I figured it'd never overflow
anyway, but it seems that it is actually possible. I'll change it.

johannes

