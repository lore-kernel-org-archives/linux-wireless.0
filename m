Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48821 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1AJEdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 23:33:02 -0500
Message-ID: <4D2A8BF3.70807@candelatech.com>
Date: Sun, 09 Jan 2011 20:32:51 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Implement rx copy-break.
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com> <4D28FF57.9040706@openwrt.org> <4D290307.4080807@candelatech.com> <20110109181303.GA12562@jm.kir.nu>
In-Reply-To: <20110109181303.GA12562@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2011 10:13 AM, Jouni Malinen wrote:
> On Sat, Jan 08, 2011 at 04:36:23PM -0800, Ben Greear wrote:
>> On 01/08/2011 04:20 PM, Felix Fietkau wrote:
>>> On 2011-01-08 8:33 AM, greearb@candelatech.com wrote:
>>>> From: Ben Greear<greearb@candelatech.com>
>>>> This saves us constantly allocating large, multi-page
>>>> skbs. It should fix the order-1 allocation errors reported,
>>>> and in a 60-vif scenario, this significantly decreases CPU
>>>> utilization, and latency, and increases bandwidth.
>
> As far as CPU use is concerned, 60 VIF scenario should not be the one to
> use for checking what is most efficient.. This really needs to be tested
> on something that uses a single VIF on an embedded (low-power CPU)..
>
> For the order-1 allocation issues, it would be interesting to see if
> someone could take a look at using paged skbs or multiple RX descriptors
> with shorter skbs (and copying only for the case where a long frame is
> received so that only the A-MSDU RX case would suffer from extra
> copying).

>
>> I see a serious performance improvement with this patch.  My current test is sending 1024 byte UDP
>> payloads to/from each of 60 stations at 128kbps.  Please do try it out on your system and see how
>> it performs there.  I'm guessing that any time you have more than 1 VIF this will be a good
>> improvement since mac80211 does skb_copy (and you would typically be copying a much smaller
>> packet with this patch).
>
> How would this patch change the number of bytes copied by skb_copy?

It seems that if you allocate a 2-page SKB, as upstream ath9k does, pass that
up the stack, then if/when anything calls 'skb_copy' it allocates a new skb with
2 pages even if the actual data-length is much smaller.

This copy wouldn't be so bad for single VIF scenarios (which means probably no copying),
but you still end up exhausting the order-1 memory buffer pool with lots of big skbs
floating around the system.  Note that the original bug was not filed by me
and happened on some embedded device, though I also see memory exhaustion in my
tests with upstream code.

>
>> If we do see performance differences on different platforms, this could perhaps be
>> something we could tune at run-time.
>
> I guess that could be looked at, but as long as that is not the case,
> the test setup you used is not exactly the most common case for ath9k in
> the upstream kernel and should not be used to figure out default
> behavior.

True, but I also like the protection this should offer against stray
DMA that this chipset/driver seems capable of.

I'm curious if anyone has any stats at all as far as ath9k performance goes?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
