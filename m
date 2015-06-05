Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38383 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbbFEVUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 17:20:06 -0400
Message-ID: <55721285.9040404@candelatech.com> (sfid-20150605_232010_511404_5762170A)
Date: Fri, 05 Jun 2015 14:20:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: YanBo <dreamfly281@gmail.com>
CC: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix survey information reporting
References: <1430829048-22549-1-git-send-email-vthiagar@qti.qualcomm.com> <5571D903.7060203@candelatech.com> <CAFuUQkjP18E6fjvgZMayJYiEQtpjVUAKb+_zDmS3yBfi-QF8Cg@mail.gmail.com> <5571F70D.4020101@candelatech.com> <55720425.2050604@candelatech.com> <CAFuUQkgeCY2wS1NJoA1qS4NTJuvwZuiMAp=dZx=kErc6N-Da_Q@mail.gmail.com>
In-Reply-To: <CAFuUQkgeCY2wS1NJoA1qS4NTJuvwZuiMAp=dZx=kErc6N-Da_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2015 02:00 PM, YanBo wrote:
> On Fri, Jun 5, 2015 at 1:18 PM, Ben Greear <greearb@candelatech.com> wrote:
>> I think the wrapping might be even more weird that previously suspected.  Here is output from my
>> system.
>>
>> It looks to me that when cycle count overflows, it right-shifts all of these
>> counters one bit.  Clever, I guess, but surely a pain in the ass to deal with!
>>
>>
>> while true; do cat /debug/ieee80211/wiphy0/ath10k/fw_stats|head -10|tail -4; date; echo;sleep 1; done
>> ....
>>                 TX frame count  131810463
>>                 RX frame count 2326362883
>>                 RX clear count 2542947851
>>                    Cycle count 4180338939
>> Fri Jun  5 13:13:48 PDT 2015
>>
>>                 TX frame count  134407497
>>                 RX frame count 2374518035
>>                 RX clear count 2595337341
>>                    Cycle count 4269010333
>> Fri Jun  5 13:13:49 PDT 2015
>>
>>                 TX frame count   69523007
>>                 RX frame count 1229973316
>>                 RX clear count 1344131636
>>                    Cycle count 2210412416
>> Fri Jun  5 13:13:50 PDT 2015
>>
>>                 TX frame count   72305753
>>                 RX frame count 1280184579
>>                 RX clear count 1398937635
>>                    Cycle count 2299234941
>> Fri Jun  5 13:13:51 PDT 2015
>>
>>                 TX frame count   75050021
>>                 RX frame count 1330205664
>>                 RX clear count 1453548082
>>                    Cycle count 2387901854
>> Fri Jun  5 13:13:52 PDT 2015
>>
>>
> The scan count is 32 bits hence, it will wrap rapidly with 24 seconds
> cycle, the new WMI interface will
> supply these count in 64 bits to avoid such issue.

That is not the problem... you can just sample often to resolve that.

The problem is that the other 3 are divided by 2 at time when the main
cycle-counter counter wraps.  So as far as I can tell, you cannot
actually calculate precise totals from old and new values for the tx/rx/rx-clear
counters if cycle-counter has wrapped since you last read stats.

Only way I can see to deal with it is to sample often enough that I can
afford to throw away samples where cycle-count wraps.  With this implemented,
I see ath10k 'activity' calculation the same as ath9k.

This wrap logic is coming out of the hardware registers as far as I
can tell, so I'm not sure that just firmware changes can really resolve
this fully.

If all they are doing is implementing faster polling in the firmware
itself, that seems like a waste of effort and precious instruction RAM.

Maybe newer hardware will act in a more sane manner so we can deal with
normal 32-bit wraps.

Thanks,
Ben

> 
> BR /Yanbo
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

