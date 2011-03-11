Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55892 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1CKUYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:24:02 -0500
Subject: Re: [PATCH] mac80211: fix channel type recalculation with HT and
 non-HT interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <4D7A8350.9000406@candelatech.com>
References: <1299873939-1171-1-git-send-email-nbd@openwrt.org>
	 <4D7A8350.9000406@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 21:24:01 +0100
Message-ID: <1299875041.4320.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-11 at 12:17 -0800, Ben Greear wrote:
> On 03/11/2011 12:05 PM, Felix Fietkau wrote:
> > When running an AP interface along with the cooked monitor interface created
> > by hostapd, adding an interface and deleting it again triggers a channel type
> > recalculation during which the (non-HT) monitor interface takes precedence
> > over the HT AP interface, thus causing the channel type to be set to non-HT.
> > Fix this by not overriding HT interfaces with a non-HT channel type.

The fix seems right.

> After staring at that code a bit more, should that list-for-each-entry
> loop be entirely different such that it better calculates a proper
> super-channel for mixed interface types?
> 
> If seems like a bad case of last-one-wins as currently written.
> 
> The code probably (mostly?) works right because we limit the
> bss_conf.channel_type based on existing super-chan when
> adding new interfaces, but it still seems like brittle code to me.

But I'm not sure what you mean?

With the fix, we go through and use the widest possible channel of all
interfaces. The only conflict can happen with HT40- and HT40+, but we
should never get into that situation since we can't have one interface
with HT40- and another with HT40+ at the same time to start with. Am I
missing something?

johannes

