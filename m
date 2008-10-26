Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38196 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbYJZWAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 18:00:33 -0400
Date: Sun, 26 Oct 2008 23:00:30 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
Message-ID: <20081026220030.GA20964@Chamillionaire.breakpoint.cc> (sfid-20081026_230038_298792_E7E48EDF)
References: <4902DEBB.3050205@hotmail.com> <1224926241.6695.1.camel@johannes.berg> <20081025112526.GB12252@Chamillionaire.breakpoint.cc> <1224936311.3410.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1224936311.3410.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Johannes Berg | 2008-10-25 14:05:11 [+0200]:

>On Sat, 2008-10-25 at 13:25 +0200, Sebastian Andrzej Siewior wrote:
>> * Johannes Berg | 2008-10-25 11:17:21 [+0200]:
>> 
>> >> [  277.190494] Kernel unaligned access at TPC[10129b68] zd_mac_rx+0x144/0x32c [zd1211rw]
>> >
>> >my best bet is this:
>> >
>> >        fc = *(__le16 *)buffer;
>> >
>> >could you try something with get_unaligned? Though if this is it,
>> >then ... We really need disassembly of the exact spot.
>> A few lines before that:
>> |         buffer += ZD_PLCP_HEADER_SIZE;
>> 
>> and ZD_PLCP_HEADER_SIZE is 5 so we end up unaligned, don't we?
>
>Depends where the buffer was before, and thought has gone into this
>alignment stuff here so it shouldn't. Might well be a new bug though.

On my x86_64 box the address of the buffer pointer right after the add
of ZD_PLCP_HEADER_SIZE is:
[   28.462273] buffer: ffff88003e310005

so it looks to me like it was perfectly aligned before the add. Is it
possible that it is not a new bug and we need a get_unaligend helper
here?

>
>johannes

Sebastian
