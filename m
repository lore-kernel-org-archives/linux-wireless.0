Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail11.tpgi.com.au ([203.12.160.161]:43734 "EHLO
	mail11.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762399AbXK3DpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 22:45:12 -0500
Message-ID: <474F86AD.4040403@hotmail.com> (sfid-20071130_034518_140115_A2842F88)
Date: Fri, 30 Nov 2007 14:42:37 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: jt@hpl.hp.com, Daniel Drake <dsd@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com> <20071121184459.GA17199@bougret.hpl.hp.com>
In-Reply-To: <20071121184459.GA17199@bougret.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First off, sorry for the delay in responding. I am now trying to catch 
up with my backlog on this issue.

Jean Tourrilhes wrote:
> 	The patch from Masakazu Mokuno I was talking about is not in
> your kernel. It defintely would explain why you would get the
> "Encryption key:<too big>". Basically the length of any variable field
> is not properly return to user space. This patch would fix that
> problem.
> 	The patch from Masakazu Mokuno is not in 2.6.22, and it not
> either in 2.6.14. The patch is only included in 2.6.23 and later. I
> would suggest upgrading to 2.6.23 to get that patch. Alternatively,
> I've included the patch as attachement, and you can use it with
> 2.6.22.
> 	I would like you to try that patch and report.

Yes, this solved that problem. Thank you,

>>> 	Can you give me the exact error text as reported by iwconfig ?
>>> I'll probably have to send you a test version to see what's happening
>>> under the cover.
>> Please find this in-lined below (with key protected):
>>
>> # iwconfig eth2
>> eth2      IEEE 802.11b/g  ESSID:off/any  Nickname:"zd1211"
>>           Mode:Managed  Frequency:2.462 GHz  Access Point: Invalid
>>           Bit Rate=1 Mb/s
>>           Encryption key:<too big>
> 
> 	Note that under Wireless Tools 30, you will notice that it
> won't return too bug but will print an absurdly long encryption
> key. Two symptoms of the same bug.
> 
>>> 		o version of Wireless Tools (iwconfig --version).
>>> 	Most likely, you need to upgrade your Wireless Tools to
>>> version 29 which fixes this 32/64 interop problem.
>>> 	With the latest kernel and the latest wireless tools, the only
>>> known bugs are the two ESSID bugs.
>> I think I'm right for version:
>> # iwconfig --version
>> iwconfig  Wireless-Tools version 29
>>           Compatible with Wireless Extension v11 to v22.
>>
>> Kernel    Currently compiled with Wireless Extension v22.
>>
>> eth2      Recommend Wireless Extension v20 or later,
>>           Currently compiled with Wireless Extension v22.
> 
> 	Yep, that's the correct version. I was afraid you were running
> Debian stable. I'll need to dig up a little bit more in this.
> 	Note that the patch above *may* help with this issue as well.

No, it does not seem to have. An iwlist eth2 scanning command still 
lists a single access point, then fails with a bus error.

Thanks for your help,
Shaddy

