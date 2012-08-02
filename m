Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58381 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2HBPtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 11:49:15 -0400
Message-ID: <501AA176.2050704@candelatech.com> (sfid-20120802_174919_128698_9A275FF8)
Date: Thu, 02 Aug 2012 08:49:10 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211-wip preview
References: <1343922290.4471.21.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343922290.4471.21.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2012 08:44 AM, Johannes Berg wrote:
> Hi,
>
> This is a more tentative preview, things are still subject to change.
>
> The included patchsets and their status:
>   * P2P Device work
>     I posted this, I'll apply it when I get back unless I see any
>     objections then :-)
>   * some more cleanups, including the CSA cleanups
>     I posted most of these I believe, and will also apply most of it when
>     I get back
>   * a brcmsmac patch that I posted -- I'm not going to apply it but I
>     just wanted to do a random cleanup (the obsolete functions removal)
>   * and channel context code of course!
>     This is still WIP, I need to
>     - address SMPS -- I might just do passive/active # of chains per
>       channel context and let the driver sort out the rest, this gives it
>       more information and flexibility
>     - TX power -- I'm open to suggestions about how we should do this,
>       technically the user setting could be per virtual interface, but do
>       we care? I have a feeling it should be per channel since even 11h
>       TX power reduction is defined for the entire channel

I would love for tx power to be per network device.  If nothing else,
one could have two station interfaces talking on the same channel, to two different
APs..one close by and one far away.  Could set the tx-power higher for
the far-away one, for example.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

