Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36735 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbFETWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 15:22:54 -0400
Message-ID: <5571F70D.4020101@candelatech.com> (sfid-20150605_212257_416756_47A004D3)
Date: Fri, 05 Jun 2015 12:22:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: YanBo <dreamfly281@gmail.com>
CC: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix survey information reporting
References: <1430829048-22549-1-git-send-email-vthiagar@qti.qualcomm.com> <5571D903.7060203@candelatech.com> <CAFuUQkjP18E6fjvgZMayJYiEQtpjVUAKb+_zDmS3yBfi-QF8Cg@mail.gmail.com>
In-Reply-To: <CAFuUQkjP18E6fjvgZMayJYiEQtpjVUAKb+_zDmS3yBfi-QF8Cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2015 12:10 PM, YanBo wrote:
> On Fri, Jun 5, 2015 at 10:14 AM, Ben Greear <greearb@candelatech.com> wrote:
>> I applied these and some other related patches to my hacked-upon 4.0.4, but
>> I am seeing some inconsistencies between how ath10k and ath9k
>> reports survey info.  I am using my CT firmware based on 10.1.
>>
>> ath9k reports ever-increasing counters for the channel time
>> and busy time.
>>
>> With ath10k, it reports the same values until I do a scan
>> again, and even then, it is not additive.
>>
>> First, should the value only update when we do a scan?
>>
>> And second, should ath10k report ever increasing totals
>> to match ath9k behaviour?
>>
> 
> It should be match with ath9k, but the ath10k doesn't accumulate the
> survey count at currently code,
> I drafted a patch to fix this issue, will send to public mailist soon.

I notice you can get current cycle stats out of the pdev stats as well,
and those update every time you ask firmware for stats.

It won't be 100% accurate because you don't know when firmware
was off-channel or not, but I guess it will be better for me than
nothing.  I certainly don't want to be scanning all the time,
but grabbing firmware stats already happens when you get ethtool
stats, so as long as I poll often enough to catch wraps, I think it
will be good enough.

I guess to get really accurate values, one would have to hack the
firmware to keep its own accumulated stats and properly deal with
channel changes.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

