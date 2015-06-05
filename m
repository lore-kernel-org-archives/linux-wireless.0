Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37495 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbFEUSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 16:18:46 -0400
Message-ID: <55720425.2050604@candelatech.com> (sfid-20150605_221849_342055_58B9FEF9)
Date: Fri, 05 Jun 2015 13:18:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: YanBo <dreamfly281@gmail.com>
CC: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix survey information reporting
References: <1430829048-22549-1-git-send-email-vthiagar@qti.qualcomm.com> <5571D903.7060203@candelatech.com> <CAFuUQkjP18E6fjvgZMayJYiEQtpjVUAKb+_zDmS3yBfi-QF8Cg@mail.gmail.com> <5571F70D.4020101@candelatech.com>
In-Reply-To: <5571F70D.4020101@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think the wrapping might be even more weird that previously suspected.  Here is output from my
system.

It looks to me that when cycle count overflows, it right-shifts all of these
counters one bit.  Clever, I guess, but surely a pain in the ass to deal with!


while true; do cat /debug/ieee80211/wiphy0/ath10k/fw_stats|head -10|tail -4; date; echo;sleep 1; done
....
                TX frame count  131810463
                RX frame count 2326362883
                RX clear count 2542947851
                   Cycle count 4180338939
Fri Jun  5 13:13:48 PDT 2015

                TX frame count  134407497
                RX frame count 2374518035
                RX clear count 2595337341
                   Cycle count 4269010333
Fri Jun  5 13:13:49 PDT 2015

                TX frame count   69523007
                RX frame count 1229973316
                RX clear count 1344131636
                   Cycle count 2210412416
Fri Jun  5 13:13:50 PDT 2015

                TX frame count   72305753
                RX frame count 1280184579
                RX clear count 1398937635
                   Cycle count 2299234941
Fri Jun  5 13:13:51 PDT 2015

                TX frame count   75050021
                RX frame count 1330205664
                RX clear count 1453548082
                   Cycle count 2387901854
Fri Jun  5 13:13:52 PDT 2015


Thanks,
Ben


On 06/05/2015 12:22 PM, Ben Greear wrote:
> On 06/05/2015 12:10 PM, YanBo wrote:
>> On Fri, Jun 5, 2015 at 10:14 AM, Ben Greear <greearb@candelatech.com> wrote:
>>> I applied these and some other related patches to my hacked-upon 4.0.4, but
>>> I am seeing some inconsistencies between how ath10k and ath9k
>>> reports survey info.  I am using my CT firmware based on 10.1.
>>>
>>> ath9k reports ever-increasing counters for the channel time
>>> and busy time.
>>>
>>> With ath10k, it reports the same values until I do a scan
>>> again, and even then, it is not additive.
>>>
>>> First, should the value only update when we do a scan?
>>>
>>> And second, should ath10k report ever increasing totals
>>> to match ath9k behaviour?
>>>
>>
>> It should be match with ath9k, but the ath10k doesn't accumulate the
>> survey count at currently code,
>> I drafted a patch to fix this issue, will send to public mailist soon.
> 
> I notice you can get current cycle stats out of the pdev stats as well,
> and those update every time you ask firmware for stats.
> 
> It won't be 100% accurate because you don't know when firmware
> was off-channel or not, but I guess it will be better for me than
> nothing.  I certainly don't want to be scanning all the time,
> but grabbing firmware stats already happens when you get ethtool
> stats, so as long as I poll often enough to catch wraps, I think it
> will be good enough.
> 
> I guess to get really accurate values, one would have to hack the
> firmware to keep its own accumulated stats and properly deal with
> channel changes.
> 
> Thanks,
> Ben
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

