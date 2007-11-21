Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail12.tpgi.com.au ([203.12.160.162]:42872 "EHLO
	mail12.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbXKUNWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 08:22:08 -0500
Message-ID: <47443035.1070702@hotmail.com> (sfid-20071121_132215_066386_363BDDC5)
Date: Thu, 22 Nov 2007 00:18:45 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	   jt@hpl.hp.com, Johannes Berg <johannes@sipsolutions.net>,
	   David Miller <davem@davemloft.net>
MIME-Version: 1.0
To: jt@hpl.hp.com
CC: Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com>
In-Reply-To: <20071119180423.GA19250@bougret.hpl.hp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jean

Jean Tourrilhes wrote:
> On Mon, Nov 19, 2007 at 04:03:02PM +0100, Johannes Berg wrote:
>>>> The first noticeable problem is when using iwconfig on the device. I 
>>>> cannot set a key for the device, and a query of the configuration always 
>>>> claims that the "<encryption key is too long>".
>>> Likely some wireless ioctl compat layer bug in the kernel.
>> Is this 32/64 interop? The kernel has never been fixed and never will
>> be. New wireless tools should "support" this, but imnsho you're *much*
>> better off compiling 64-bit wireless tools.
> 
> 	There was a patch for this kind of issue from Masakazu Mokuno
> that went in 2.6.22 or 2.6.23 that was touching that part. I don't
> think he went in the stable series, but probably should have. There
> are other potential cause of problem here, and I suspect he might get
> the same error with 64 bits userspace.
> 	Can you give me the exact error text as reported by iwconfig ?
> I'll probably have to send you a test version to see what's happening
> under the cover.

Please find this in-lined below (with key protected):

# iwconfig eth2
eth2      IEEE 802.11b/g  ESSID:off/any  Nickname:"zd1211"
           Mode:Managed  Frequency:2.462 GHz  Access Point: Invalid
           Bit Rate=1 Mb/s
           Encryption key:<too big>

# iwconfig eth2 essid dixieland key "GGGGGGGGGG"
# iwconfig eth2
eth2      IEEE 802.11b/g  ESSID:off/any  Nickname:"zd1211"
           Mode:Managed  Frequency:2.462 GHz  Access Point: 
GG:GG:GG:GG:GG:GG
           Bit Rate=24 Mb/s
           Encryption key:<too big>

#

>>>> If I try to scan for APs using iwlist, I get one AP listed, before a bus 
>>>> error occurs. This of course, does not suggest that the problem is with 
>>>> the driver, but I mention it for the record.
>>> This is an unaligned data access in the userland tools.
>>> Try to catch it with GDB and give us ths backtrace.
>> For Jean.
> 
> 	Definitely, it sounds familiar.
> 	This is that I need :
> 		o version of the kernel

Debian sparc64 2.6.22 (built myself, using make-kpg, to include the driver)

> 		o version of the driver if not stock driver
As stock with the kernel described above

> 		o version of Wireless Tools (iwconfig --version).
> 	Most likely, you need to upgrade your Wireless Tools to
> version 29 which fixes this 32/64 interop problem.
> 	With the latest kernel and the latest wireless tools, the only
> known bugs are the two ESSID bugs.

I think I'm right for version:
# iwconfig --version
iwconfig  Wireless-Tools version 29
           Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.

eth2      Recommend Wireless Extension v20 or later,
           Currently compiled with Wireless Extension v22.


Hope that helps.

Regards,
Shaddy


