Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38198 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0JEQYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 12:24:55 -0400
Message-ID: <4CAB514E.2010009@candelatech.com>
Date: Tue, 05 Oct 2010 09:24:46 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
References: <4CAA2247.50402@candelatech.com>	 <1286218879.3620.55.camel@jlt3.sipsolutions.net>	 <4CAA252F.9090102@candelatech.com>	 <1286219405.3620.56.camel@jlt3.sipsolutions.net>	 <AANLkTi=Ya6RuCdVYLYi3Mk5EKSP6czOfTh7TRKqB0GPU@mail.gmail.com>	 <AANLkTinGaCAEqGRt_X6hsO8sQx4kKEdNqU8pfi00_1-r@mail.gmail.com>	 <4CAA494B.5000500@candelatech.com>  <4CAA5861.4020503@candelatech.com> <1286265366.3641.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286265366.3641.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2010 12:56 AM, Johannes Berg wrote:
> On Mon, 2010-10-04 at 15:42 -0700, Ben Greear wrote:
>
>> I did find a similar crash while debugging a kernel with just symbols
>> compiled in (not kgdb) though:
>
> Doesn't seem all that similar...
>
>> The interesting thing to me is that the 00100104 address is the same in
>> both crashes, though this one is in a different method.
>
> except for that maybe. But this is LIST_POISON1, and with seemingly
> different lists. It may be faster to reproduce if you enable slab/slub
> debugging.
>
>> Also, this is with power-save NOT disabled (I was hoping to
>> hit some debugging code I put in for the other crash..hit this instead.)
>>
>> Oct  4 15:26:15 localhost kernel: BUG: unable to handle kernel paging request at 00100104
>> Oct  4 15:26:15 localhost kernel: IP: [<fc77e038>] cfg80211_unlink_bss+0x4d/0x8d [cfg80211]
>
> Looks like a mac80211 bug, but you snipped the stack trace.

I'll apply your deadlock-fix patch, enable slab debugging, and have another go
at it today.

Thanks!
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

