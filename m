Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33320 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbbFEVjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 17:39:45 -0400
Received: by oiww2 with SMTP id w2so62437899oiw.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 14:39:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55721285.9040404@candelatech.com>
References: <1430829048-22549-1-git-send-email-vthiagar@qti.qualcomm.com>
	<5571D903.7060203@candelatech.com>
	<CAFuUQkjP18E6fjvgZMayJYiEQtpjVUAKb+_zDmS3yBfi-QF8Cg@mail.gmail.com>
	<5571F70D.4020101@candelatech.com>
	<55720425.2050604@candelatech.com>
	<CAFuUQkgeCY2wS1NJoA1qS4NTJuvwZuiMAp=dZx=kErc6N-Da_Q@mail.gmail.com>
	<55721285.9040404@candelatech.com>
Date: Fri, 5 Jun 2015 14:39:45 -0700
Message-ID: <CAFuUQkgF-QTJOcCQKp7MGvmGKYkU+cdCSA9TWYQVbrydNW8nMw@mail.gmail.com> (sfid-20150605_233948_890994_CD7547C5)
Subject: Re: [PATCH] ath10k: Fix survey information reporting
From: YanBo <dreamfly281@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 5, 2015 at 2:20 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 06/05/2015 02:00 PM, YanBo wrote:
>> On Fri, Jun 5, 2015 at 1:18 PM, Ben Greear <greearb@candelatech.com> wrote:
>>> I think the wrapping might be even more weird that previously suspected.  Here is output from my
>>> system.
>>>
>>> It looks to me that when cycle count overflows, it right-shifts all of these
>>> counters one bit.  Clever, I guess, but surely a pain in the ass to deal with!
>>>
>>>
>>> while true; do cat /debug/ieee80211/wiphy0/ath10k/fw_stats|head -10|tail -4; date; echo;sleep 1; done
>>> ....
>>>                 TX frame count  131810463
>>>                 RX frame count 2326362883
>>>                 RX clear count 2542947851
>>>                    Cycle count 4180338939
>>> Fri Jun  5 13:13:48 PDT 2015
>>>
>>>                 TX frame count  134407497
>>>                 RX frame count 2374518035
>>>                 RX clear count 2595337341
>>>                    Cycle count 4269010333
>>> Fri Jun  5 13:13:49 PDT 2015
>>>
>>>                 TX frame count   69523007
>>>                 RX frame count 1229973316
>>>                 RX clear count 1344131636
>>>                    Cycle count 2210412416
>>> Fri Jun  5 13:13:50 PDT 2015
>>>
>>>                 TX frame count   72305753
>>>                 RX frame count 1280184579
>>>                 RX clear count 1398937635
>>>                    Cycle count 2299234941
>>> Fri Jun  5 13:13:51 PDT 2015
>>>
>>>                 TX frame count   75050021
>>>                 RX frame count 1330205664
>>>                 RX clear count 1453548082
>>>                    Cycle count 2387901854
>>> Fri Jun  5 13:13:52 PDT 2015
>>>
>>>
>> The scan count is 32 bits hence, it will wrap rapidly with 24 seconds
>> cycle, the new WMI interface will
>> supply these count in 64 bits to avoid such issue.
>
> That is not the problem... you can just sample often to resolve that.
>
> The problem is that the other 3 are divided by 2 at time when the main
> cycle-counter counter wraps.  So as far as I can tell, you cannot
> actually calculate precise totals from old and new values for the tx/rx/rx-clear
> counters if cycle-counter has wrapped since you last read stats.
>
> Only way I can see to deal with it is to sample often enough that I can
> afford to throw away samples where cycle-count wraps.  With this implemented,
> I see ath10k 'activity' calculation the same as ath9k.
>
> This wrap logic is coming out of the hardware registers as far as I
> can tell, so I'm not sure that just firmware changes can really resolve
> this fully.
>
> If all they are doing is implementing faster polling in the firmware
> itself, that seems like a waste of effort and precious instruction RAM.
>
Exactly that the FW used to fixed this issue, as it is a HW
limitation, they is no
better way to correct it without faster polling

Thanks
BR /Yanbo
