Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:33416 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbZKWLID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 06:08:03 -0500
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Message-Id: <5A2C6B7F-5617-49AA-B22A-A5574D6CD9FA@ing.unibs.it>
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <200911231149.38494.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
Date: Mon, 23 Nov 2009 12:00:15 +0100
References: <200911192224.29491.mb@bu3sch.de> <4B0A137B.7050604@lwfinger.net> <200911231149.38494.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 23, 2009, at 11:49 AM, Michael Buesch wrote:

> On Monday 23 November 2009 05:45:47 Larry Finger wrote:
>> On 11/19/2009 03:24 PM, Michael Buesch wrote:
>>> This rewrites the error handling policies in the TX status handler.
>>> It tries to be error-tolerant as in "try hard to not crash the  
>>> machine".
>>> It won't recover from errors (that are bugs in the firmware or  
>>> driver),
>>> because that's impossible. However, it will return a more or less  
>>> useful
>>> error message and bail out. It also tries hard to use rate-limited  
>>> messages
>>> to not flood the syslog in case of a failure.
>>
>> This patch definitely helped open-source firmware, but it is not a  
>> complete fix.
>
> It is no fix _at_ _all_.
> The patch does not change a single line of code that wasn't either  
> an assertion
> or a machine crash before.
> So it just transforms assertions into more verbose assertions and  
> crashes into
> assertions without a crash.
>
>> debug: Out of order TX status report on DMA ring 1. Expected 114,  
>> but got 146
>
> Ok, this is what I expected.
>
> Let's see what's going on. Here's the ring. o is unused, * is used.
>
> ooooooooooooooo 
> ***************************************************ooooooooooooooooooooooooooo
>               ^               ^                                 ^
>               114             146                               newest
>               oldest
>
> So as you can see, the firmware reported a TX status for a frame  
> right in the middle of
> the ringbuffer. The new code detects this now before getting a  
> double free and/or silent
> memory corruption (freeing of used memory).
Hi Michael,

so you can observe this behavior at your site. Do you mind describing  
the exact configuration? Maybe this time I can reproduce this  
behavior, as I tried everything to make it happen. I also asked Larry  
one of his boards and put it into several PCs but had no chance to  
reproduce the crash. Could you please also report the neighboring  
stations, the AP you are connected and so on.

Many thanks,
-Francesco



Informativa sulla privacy: http://help.ing.unibs.it/privacy.php


