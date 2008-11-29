Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc2-s38.bay0.hotmail.com ([65.54.246.174]:49735 "EHLO
	bay0-omc2-s38.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156AbYK2I7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 03:59:11 -0500
Message-ID: <BAY104-DAV45277DC429AEBF024857A99070@phx.gbl> (sfid-20081129_095917_158558_C9DF327F)
Message-ID: <49310454.60906@hotmail.com>
Date: Sat, 29 Nov 2008 19:59:00 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
References: <4902DEBB.3050205@hotmail.com> <BAY104-DAV1D226EA8FB16BE36E3C84991A0@phx.gbl> <BAY104-DAV671C2C6DE8B2A05AD785E99040@phx.gbl> <200811282344.29293.mb@bu3sch.de>
In-Reply-To: <200811282344.29293.mb@bu3sch.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29/11/08 09:44, Michael Buesch wrote:
> On Friday 28 November 2008 06:34:34 Shaddy Baddah wrote:
>> case the same simple function replacement would not be OK. But I saw 
>> several places where memcmp() is preferred to compare_ether_addr(), 
>> which I assume indicates that mac80211 does not expect alignment of 
>> 80211 packets passed to it.
> 
> The whole networking stack expects 4byte alignment and the driver _must_
> make sure it is this way. Either by padding a constant number of bytes at the front
> of each allocated SKB, or (if the alignment differs) use dynamic checks
> for the lowest few bits of the pointer passed to mac80211.

Right. But I'm not sure that in this case that the packet is being 
passed to mac80211 by the driver. My recall of the stack traces I saw 
were that the unalignment I was seeing in sta_info_get() were a 
consequence of transmission attempts.

I must admit though, I could not source where the unaligned packet came 
from, as I do not fully understand the different queuing mechanisms in 
use and where and how enqueues occur. My  limited efforts to understand 
this gave me the impression that network stack itself, and not the 
driver, was constructing these unaligned packets, for transmission.

The memcmp() that really persuaded me to believe that the mac80211 had 
no alignment requirements was this one:

net/mac80211/tx.c:1304:		if (memcmp(odev->dev_addr, hdr->addr4, 
ETH_ALEN) != 0)

I would have thought it would use compare_ether_addr() if we could 
safely assume alignment. In any case, say that alignment was always the 
intention... then can't we just use memcmp() as a hack (not being 
derogatory. Just that it would turn into a hack in deference to using 
compare_ether_addr()) consistent with hacks like the above? Even in the 
interim until a program to iron out alignment is set in place?

Regards,
Shaddy


