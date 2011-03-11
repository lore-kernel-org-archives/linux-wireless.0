Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1CKUeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:34:13 -0500
Subject: Re: [PATCH] mac80211: fix channel type recalculation with HT and
 non-HT interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <4D7A85FC.4090708@candelatech.com>
References: <1299873939-1171-1-git-send-email-nbd@openwrt.org>
	 <4D7A8350.9000406@candelatech.com>
	 <1299875041.4320.6.camel@jlt3.sipsolutions.net>
	 <4D7A85FC.4090708@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 21:34:06 +0100
Message-ID: <1299875646.4320.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-11 at 12:28 -0800, Ben Greear wrote:

> > But I'm not sure what you mean?
> >
> > With the fix, we go through and use the widest possible channel of all
> > interfaces. The only conflict can happen with HT40- and HT40+, but we
> > should never get into that situation since we can't have one interface
> > with HT40- and another with HT40+ at the same time to start with. Am I
> > missing something?
> 
> Maybe I'm missing something, but from what I can tell:
> 
> If we have two interfaces:
> 
> first interface is HT40, second is HT20:
>    -> superchan == HT20
> 
> first interface is HT20, second is HT40:
>    -> superchan == HT40
> 
> It seems wrong that the ordering would influence superchan before we go into
> the "switch (superchan)" logic.

Ah, you're right -- the real fix isn't this patch, but probably
something like this:

...
case NL..._NO_HT:
case NL_...HT20:
	if (channel_type < super_chan)
		break;
	superchan = channel_type;
	break;
...

johannes

