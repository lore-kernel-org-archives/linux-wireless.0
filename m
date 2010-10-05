Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57301 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0JEDn1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 23:43:27 -0400
Message-ID: <4CAA9EDB.90509@candelatech.com>
Date: Mon, 04 Oct 2010 20:43:23 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
References: <4CAA2247.50402@candelatech.com> <1286218879.3620.55.camel@jlt3.sipsolutions.net> <4CAA252F.9090102@candelatech.com> <1286219405.3620.56.camel@jlt3.sipsolutions.net> <AANLkTi=Ya6RuCdVYLYi3Mk5EKSP6czOfTh7TRKqB0GPU@mail.gmail.com> <AANLkTinGaCAEqGRt_X6hsO8sQx4kKEdNqU8pfi00_1-r@mail.gmail.com> <4CAA494B.5000500@candelatech.com> <AANLkTi=3EXnANmEP28Z2ASmqxopbe-EDypska72bL=to@mail.gmail.com>
In-Reply-To: <AANLkTi=3EXnANmEP28Z2ASmqxopbe-EDypska72bL=to@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2010 04:48 PM, Luis R. Rodriguez wrote:
> On Mon, Oct 4, 2010 at 2:38 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 10/04/2010 02:13 PM, Luis R. Rodriguez wrote:
>>>
>>> On Mon, Oct 4, 2010 at 2:12 PM, Luis R. Rodriguez<mcgrof@gmail.com>
>>>   wrote:
>>>>
>>>> On Mon, Oct 4, 2010 at 12:10 PM, Johannes Berg
>>>> <johannes@sipsolutions.net>    wrote:
>>>>>
>>>>> On Mon, 2010-10-04 at 12:04 -0700, Ben Greear wrote:
>>>>>>
>>>>>> On 10/04/2010 12:01 PM, Johannes Berg wrote:
>>>>>>>
>>>>>>> On Mon, 2010-10-04 at 11:51 -0700, Ben Greear wrote:
>>>>>>>>
>>>>>>>> Just in case this seems familiar to anyone...
>>>>>>>>
>>>>>>>> IP: [<f8ba74da>] ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211]
>>>>>>>
>>>>>>> Do you have debug info that'd point to a code line?
>>>>>>>
>>>>>>> I have never heard of this.
>>>>>>
>>>>>> I don't actually know how to get a line of code out of those
>>>>>> hex offsets...
>>>>>>
>>>>>> Someone told me many years ago..but I lost that information :P
>>>>>
>>>>> Err, I never remember either, I think Luis knows the gdb thing ... I
>>>>> usually use "objdump -dS"
>>>>
>>>> gdb net/mac80211/mac80211.ko
>>>> l *(ieee80211_stop_tx_ba_session+0x14/0x84)
>>>
>>> Oops I meant:
>>>
>>> gdb net/mac80211/mac80211.ko
>>> l *(ieee80211_stop_tx_ba_session+0x14)
>>
>> Thank!
>>
>> I had to re-compile with debugging symbols, and added kgdb (hopefully
>> that won't mess anything up).
>
> You may want to look at using netconsole instead if you're goal is
> just to get some oops off the box.
>
> CONFIG_NETCONSOLE=m
>
> mcgrof@tux ~/bin $ cat netconsole
> #!/bin/bash
> sudo dmesg -n 8
> sudo ip addr add 192.168.4.2/24 dev eth4
> sudo modprobe netconsole
> netconsole="@192.168.4.2/eth4,@192.168.4.3/00:1e:37:82:48:5a"
>
> I'd run that script on the dev box, and on 192.168.4.3 just do `nc -l
> -p 6666 | tee log`. To test just modprobe and rmmod ath9k.

I have serial-console, is netconsole any better, or just useful
if you don't have serial console?

I was sort of hoping kgdb would magically drop me into a debug
shell on panic and let me look at backtraces and variables...but
instead the system would go OOM, hard-lock, or panic and show a single
line of panic and then dead to the world.  I've enough to debug w/out
debugging kgdb as well :)

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
