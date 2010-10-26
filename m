Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:42518 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537Ab0JZCE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 22:04:27 -0400
Message-ID: <4CC63728.4030009@web.de>
Date: Tue, 26 Oct 2010 04:04:24 +0200
From: Lee <lee-in-berlin@web.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
References: <4CC0D0F6.4080507@web.de> <4CC33E83.4020505@web.de> <20101025174957.GD2414@tuxdriver.com>
In-Reply-To: <20101025174957.GD2414@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/10/10 19:49, John W. Linville wrote:
> On Sat, Oct 23, 2010 at 09:58:59PM +0200, Lee wrote:
>> On 22/10/10 01:47, Lee wrote:
>>> Hi everyone,
>>>
>>> I noticed a bug (details later) in Linus' git tree, which wasn't there in
>>> 2.6.35.7. So I went on to bisect the bug. 12 compiles and reboots later, I
>>> could narrow it down to this commit:
>>>
>>> # bad: [05318bc905467237d4aa68a701f6e92a2b332218] Merge branch 'master' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6
>>>
>>> Unfortunately, I couldn't further bisect down wireless-next, because all three
>>> commits I picked were unworkable (bringing down an interface caused the kernel
>>> to oops, which made my test case impossible).
>>>
>>> The test case is as follows: I have eth0 and wlan0 (the interface to an
>>> rt37usb device) in a bridge lan0. I have a properly configured hostapd. When I
>>> try to connect with a client to my hostapd AP, I can successfully
>>> authenticate, but all further packets don't reach the interface of the AP.
>>>
>>> However, I can see broadcast packets *from* the AP on my client, but not the
>>> other way round (DHCP requests from client to AP). To make sure the bug was
>>> not specific to broadcast packets, I manually set an IP on my client and tried
>>> to ping the AP, but those packets didn't come through, either.
>>>
>>> Right now I'm a bit clueless on how to get to the root of this bug, so any
>>> help is appreciated.
>>>
>>> Regards,
>>> Lee
>>
>> I checked vanilla 2.6.36, the bug is still there. Is this a known
>> bug? Does anyone care to give me some hints? Are any details needed?
>
> Hard to say if you can't complete the bisect.
>
> The bisect you mention is a merge from wireless-next-2.6 at 88c1f4f.
> The preceding merge from wireless-next-2.6 was from abf52f8.  It looks
> like there were a number of rt2x00 commits in between.
>
> So, you might try a new bisect:
>
> 	git bisect start 88c1f4f abf52f8
>
> If you still get commits that don't work but in an apparently unrelated
> way, you can use 'git bisect skip'.
>
> Does that help you to narrow things down?
>
> John

I found a way to work around that oops I was hitting, so I took your two 
commit points to start off a new bisect.

 > 1df90809f79b765fd4e8868c2b182d948f198a17 is the first bad commit

I tried to revert that commit on top of v2.6.36, but there were a few commits 
to rt2800lib.c. But since that file doesn't get compiled in my .config, I just 
reverted the changes to rt2x00dev.c and tried that kernel. It compiled fine, 
but didn't fix my problem.

I don't really understand the code, so I guess I'll stop fiddling around with 
it. I've got a working test-case, though, so I'm happy to test any patches 
that are sent in my direction.

Lee
