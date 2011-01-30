Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33145 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1A3Qj3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 11:39:29 -0500
Message-ID: <4D45943E.2050409@candelatech.com>
Date: Sun, 30 Jan 2011 08:39:26 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k: Still seeing DMA issues in latest wireless-testing.
References: <4D439AEA.6020101@candelatech.com> <AANLkTinSxnxYdUuQGWRr-fA8HF_JotQfG3S1QWEwS3K=@mail.gmail.com>
In-Reply-To: <AANLkTinSxnxYdUuQGWRr-fA8HF_JotQfG3S1QWEwS3K=@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2011 07:54 AM, Björn Smedman wrote:
> On Sat, Jan 29, 2011 at 5:43 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> Looks like some potentially nice ath9k patches just got merged into
>> wireless-testing.  It has been stable and fast so far, but I
>> do still see DMA issues in the logs.
>>
>> This is on a system with 30 STAs associated with a flakey netgear running
>> HT40-, and 30 associated with a cisco running HT20.  (Through some luck,
>> the netgear managed to send proper ht-info channel this time,
>> so the NIC went HT40-).
>
> Ben, the fact that you see much more of these DMA issues when you're
> running your virtual STAs suggests to me that root cause is some race
> condition between dma and cpu. The main difference between the 60 STA
> use-case and the one STA use case is that rx irq processing will take
> longer with multiple STAs, right? Is there some other difference?

I don't know.  I see it even when not running much traffic.

I also see DMA on my AP system, which has a single AP and one idle
station.  Granted, I have 128 or so stations connected to the AP,
but again, the stations are mostly idle.

Other folks see the DMA issues too...and most probably just don't report
them anymore...

Thanks,
Ben

>
> /Björn


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
