Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39234 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1AIBG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 20:06:59 -0500
Message-ID: <4D290A2C.6040803@candelatech.com>
Date: Sat, 08 Jan 2011 17:06:52 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Implement rx copy-break.
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com> <4D28FF57.9040706@openwrt.org> <4D290307.4080807@candelatech.com> <4D290450.8070700@openwrt.org>
In-Reply-To: <4D290450.8070700@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/2011 04:41 PM, Felix Fietkau wrote:
> On 2011-01-08 5:36 PM, Ben Greear wrote:
>> On 01/08/2011 04:20 PM, Felix Fietkau wrote:
>>> I think this should be dependent on packet size, maybe even based on the architecture. Especially on embedded hardware, copying large frames is probably quite a
>>> bit more expensive than allocating large buffers. Cache sizes are small, memory access takes several cycles, especially during concurrent DMA.
>>> Once I'm back home, I could try a few packet size threshold to find a sweet spot for the typical MIPS hardware that I'm playing with. I expect a visible
>>> performance regression from this patch when applied as-is.
>>
>> I see a serious performance improvement with this patch. My current test is sending 1024 byte UDP
>> payloads to/from each of 60 stations at 128kbps. Please do try it out on your system and see how
>> it performs there. I'm guessing that any time you have more than 1 VIF this will be a good
>> improvement since mac80211 does skb_copy (and you would typically be copying a much smaller
>> packet with this patch).
>>
>> If we do see performance differences on different platforms, this could perhaps be
>> something we could tune at run-time.
> What kind of system are you testing on? If it's a PC, then the performance characteristics will be completely different compared to embedded hardware. I've had
> to remove a few copybreak-like implementations from various ethernet drivers on similar hardware, because even taking the hit of unaligned load/store exceptions
> (which are already *very* expensive on MIPS) was less than copying the full packet data, even with packet sizes less than what you're using.
>
> I don't have suitable test hardware with me right now, but I'll do some tests in a week or so.

I'm on a dual-core Atom processor.  I'm interested in your MIPs results when you get them...

Thanks,
Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
