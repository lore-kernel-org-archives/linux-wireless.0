Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54019 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672Ab0JYSAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 14:00:11 -0400
Date: Mon, 25 Oct 2010 13:49:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Lee <lee-in-berlin@web.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
Message-ID: <20101025174957.GD2414@tuxdriver.com>
References: <4CC0D0F6.4080507@web.de>
 <4CC33E83.4020505@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CC33E83.4020505@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 23, 2010 at 09:58:59PM +0200, Lee wrote:
> On 22/10/10 01:47, Lee wrote:
> >Hi everyone,
> >
> >I noticed a bug (details later) in Linus' git tree, which wasn't there in
> >2.6.35.7. So I went on to bisect the bug. 12 compiles and reboots later, I
> >could narrow it down to this commit:
> >
> ># bad: [05318bc905467237d4aa68a701f6e92a2b332218] Merge branch 'master' of
> >git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6
> >
> >Unfortunately, I couldn't further bisect down wireless-next, because all three
> >commits I picked were unworkable (bringing down an interface caused the kernel
> >to oops, which made my test case impossible).
> >
> >The test case is as follows: I have eth0 and wlan0 (the interface to an
> >rt37usb device) in a bridge lan0. I have a properly configured hostapd. When I
> >try to connect with a client to my hostapd AP, I can successfully
> >authenticate, but all further packets don't reach the interface of the AP.
> >
> >However, I can see broadcast packets *from* the AP on my client, but not the
> >other way round (DHCP requests from client to AP). To make sure the bug was
> >not specific to broadcast packets, I manually set an IP on my client and tried
> >to ping the AP, but those packets didn't come through, either.
> >
> >Right now I'm a bit clueless on how to get to the root of this bug, so any
> >help is appreciated.
> >
> >Regards,
> >Lee
> 
> I checked vanilla 2.6.36, the bug is still there. Is this a known
> bug? Does anyone care to give me some hints? Are any details needed?

Hard to say if you can't complete the bisect.

The bisect you mention is a merge from wireless-next-2.6 at 88c1f4f.
The preceding merge from wireless-next-2.6 was from abf52f8.  It looks
like there were a number of rt2x00 commits in between.

So, you might try a new bisect:

	git bisect start 88c1f4f abf52f8

If you still get commits that don't work but in an apparently unrelated
way, you can use 'git bisect skip'.

Does that help you to narrow things down?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
