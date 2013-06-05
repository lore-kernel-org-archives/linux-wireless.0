Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:43957 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab3FELgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 07:36:52 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless@vger.kernel.org
Subject: Re: cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets
References: <20130604130955.GA13788@debian>
	<20130604134340.GA3813@shaftnet.org>
	<87d2s13rsm.fsf@purkki.adurom.net>
	<20130605111258.GA15549@shaftnet.org>
Date: Wed, 05 Jun 2013 14:36:51 +0300
In-Reply-To: <20130605111258.GA15549@shaftnet.org> (Solomon Peachy's message
	of "Wed, 5 Jun 2013 07:12:59 -0400")
Message-ID: <87vc5s3i24.fsf@purkki.adurom.net> (sfid-20130605_133655_474765_AFE24874)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Solomon Peachy <pizza@shaftnet.org> writes:

> On Wed, Jun 05, 2013 at 11:06:33AM +0300, Kalle Valo wrote:
>> > I'll try to robustify this rather ugly interface as much as possible.  
>> 
>> We have nl80211 testmode interface for just stuff like this. I recommend
>> using that instead of debugfs.
>
> When in the so-called etf_mode, the driver doesn't create a netdev.  It 
> doesn't probe the hardware; it doesn't even (automatically) load 
> firmware because it doesn't know what firmware to load.  The driver 
> becomes a (mostly very dumb) conduit for messages to/from userspace.
>
> That userspace in turn is a thin daemon that listens on a TCP socket and 
> relays everything to/from a windows-only highly proprietary vendor tool.  
> Everything needed to initialize the hardware (even the dpll value), is 
> obtained via these messages.

This is exactly what testmode was written for.

> There's no inherent reason why this daemon couldn't use nl80211 instead, 
> but IMO it's not worth the effort to rewrite the driver so it can bring 
> up a netdev that (cleanly) fails everything other than nl80211
> testcmds.

What do you mean with bring up netdev? I don't understand.

Even now you call ieee80211_register_hw() before cw1200_debug_init(). At
least from a quick look I don't see any technical reason why you can't
use testmode (unless I'm missing something).

And if there's a problem how testmode is implemented we can always fix
it.

> After all, it'll still be an opaque binary interface whether it uses 
> nl80211, custom ioctls, or the existing debugfs interface.
>
> If the existing debugfs interface is too ugly to stomach in the 
> mainline, we're better off just stripping it out and maintaining it as 
> an out-of-tree patch for the handful of users that need to use the 
> vendor tools -- In other words, folks bringing up new hardware designs 
> or obtaining FCC(etc) certification.

Again, this is exactly what testmode is for.

We have been working hard to get rid of all sort ugly driver specific
interfaces. If you don't want to use the proper interface then I guess
it's better to remove the custom debugfs interface from cw1200.

-- 
Kalle Valo
