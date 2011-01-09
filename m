Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60926 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1AIOPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 09:15:07 -0500
Received: by iyj18 with SMTP id 18so178952iyj.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Jan 2011 06:15:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D290A2C.6040803@candelatech.com>
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com>
	<4D28FF57.9040706@openwrt.org>
	<4D290307.4080807@candelatech.com>
	<4D290450.8070700@openwrt.org>
	<4D290A2C.6040803@candelatech.com>
Date: Sun, 9 Jan 2011 15:15:06 +0100
Message-ID: <AANLkTim0=1wpPGPDZZzVjO0u_jvv5knA2=v4b-dTfRFq@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Implement rx copy-break.
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 9, 2011 at 2:06 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 01/08/2011 04:41 PM, Felix Fietkau wrote:
>>
>> On 2011-01-08 5:36 PM, Ben Greear wrote:
>>>
>>> On 01/08/2011 04:20 PM, Felix Fietkau wrote:
>>>>
>>>> I think this should be dependent on packet size, maybe even based on the
>>>> architecture. Especially on embedded hardware, copying large frames is
>>>> probably quite a
>>>> bit more expensive than allocating large buffers. Cache sizes are small,
>>>> memory access takes several cycles, especially during concurrent DMA.
>>>> Once I'm back home, I could try a few packet size threshold to find a
>>>> sweet spot for the typical MIPS hardware that I'm playing with. I expect a
>>>> visible
>>>> performance regression from this patch when applied as-is.
>>>
>>> I see a serious performance improvement with this patch. My current test
>>> is sending 1024 byte UDP
>>> payloads to/from each of 60 stations at 128kbps. Please do try it out on
>>> your system and see how
>>> it performs there. I'm guessing that any time you have more than 1 VIF
>>> this will be a good
>>> improvement since mac80211 does skb_copy (and you would typically be
>>> copying a much smaller
>>> packet with this patch).
>>>
>>> If we do see performance differences on different platforms, this could
>>> perhaps be
>>> something we could tune at run-time.
>>
>> What kind of system are you testing on? If it's a PC, then the performance
>> characteristics will be completely different compared to embedded hardware.
>> I've had
>> to remove a few copybreak-like implementations from various ethernet
>> drivers on similar hardware, because even taking the hit of unaligned
>> load/store exceptions
>> (which are already *very* expensive on MIPS) was less than copying the
>> full packet data, even with packet sizes less than what you're using.
>>
>> I don't have suitable test hardware with me right now, but I'll do some
>> tests in a week or so.
>
> I'm on a dual-core Atom processor.  I'm interested in your MIPs results when
> you get them...

I think we should also consider the added stability/saneness with this
patch. I for one would be willing to live with some extra cpu load if
that means the unstoppable rx dma problem can be contained (all the
time).

Perhaps make it a configuration option?

/Björn
