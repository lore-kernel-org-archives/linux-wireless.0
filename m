Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:43159 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932231AbXCEIKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 03:10:52 -0500
Message-ID: <45EBD087.9020103@warmcat.com>
Date: Mon, 05 Mar 2007 08:10:47 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Question about PRISM2 header rate field
References: <45EA9E39.6080706@warmcat.com> <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com> <200703042210.52534.flamingice@sourmilk.net>
In-Reply-To: <200703042210.52534.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:

Hi Michael -

> On Sunday 04 March 2007 20:02, Andy Green wrote:
>> How about for injection on the Management interface, it expects to find
>> a PRISM2 header prepended to the ieee80211 one and the payload, in
>> exactly the same format as is delivered by Monitor Mode?  The PRISM2
>> capture header structure has a bunch of fields for things like rate and
>> antenna selection already.  This has the satisfying aspect that you can
>> literally replay the whole Monitor Mode packet capture down the
>> Management Interface and get it to go out at the same rate.
>>
> Isn't this what aircrack does? I think many other drivers that support frame 
> injection do it in a similar way (TX AVS frame on monitor interface), and 
> this is also the way I prefer the frame injection interface. It does have the 
> nice property of being able to directly replay captured traffic as you 
> mentioned. Just note that AVS/prism2 is planned to be removed in favor of 
> radiotap which is more extensible. Radiotap should also work for frame 
> injection, though it isn't as easy as using a fixed length header format.

Radiotap is fine for me too.  PRISM2 has a 32-bit magic at the start, I 
guess you can just check the first byte (Magic 0x1e for PRISM2, Version 
0x00 for Radiotap) to find out what you have been given.  Just returning 
  -ENOSUPP or something else unique for an unsupported header will allow 
easy adaptation in userspace to what header system a given kernel will 
support for tx.

Radiotap also has better documentation in the form of the old stack 
header file at least.  It's clear there's more than enough capability 
defined for my needs anyway, it will allow optional specification of 
antenna and even tx power too.  It doesn't make any difference for me 
that it is variable length.

> Note that modifying the management interface to do this is possible, but it 
> would break hostap (and probably wpa_supplicant w/ MLME). Doing packet 
> injection on monitor interfaces instead is safer in that regard.

Basing it around Monitor Mode interfaces will suit all the potential 
users I think, since they might already have one floating around, and 
they are easier to spawn than Management anyway.

-Andy
