Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52972 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab1AIUYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 15:24:25 -0500
Message-ID: <4D2A1970.5080206@openwrt.org>
Date: Sun, 09 Jan 2011 13:24:16 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Jouni Malinen <j@w1.fi>, Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Implement rx copy-break.
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com> <4D290307.4080807@candelatech.com> <20110109181303.GA12562@jm.kir.nu> <201101092114.55534.chunkeey@googlemail.com>
In-Reply-To: <201101092114.55534.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-09 1:14 PM, Christian Lamparter wrote:
> On Sunday 09 January 2011 19:13:04 Jouni Malinen wrote:
>>  On Sat, Jan 08, 2011 at 04:36:23PM -0800, Ben Greear wrote:
>>  >  On 01/08/2011 04:20 PM, Felix Fietkau wrote:
>>  >  >On 2011-01-08 8:33 AM, greearb@candelatech.com wrote:
>>  >  >>From: Ben Greear<greearb@candelatech.com>
>>  >  >>This saves us constantly allocating large, multi-page
>>  >  >>skbs. It should fix the order-1 allocation errors reported,
>>  >  >>and in a 60-vif scenario, this significantly decreases CPU
>>  >  >>utilization, and latency, and increases bandwidth.
>>
>>  As far as CPU use is concerned, 60 VIF scenario should not be the one to
>>  use for checking what is most efficient.. This really needs to be tested
>>  on something that uses a single VIF on an embedded (low-power CPU)..
>>
>>  For the order-1 allocation issues, it would be interesting to see if
>>  someone could take a look at using paged skbs or multiple RX descriptors
>>  with shorter skbs (and copying only for the case where a long frame is
>>  received so that only the A-MSDU RX case would suffer from extra
>>  copying).
>
> Well, here's a shot at paged rx. It'll only work when PAGE_SIZE>  buf_size
> (which will be true for most system, I guess)
>
> No idea how to handle EDMA... In fact I don't have any ath9k* solution
> at the moment to test ;), so you better backup your data!
I think paged rx would be quite problematic for performance on embedded 
hardware that way. If I read the networking stack correctly, this would 
trigger skb_linearize() for network drivers/devices that cannot do 
scatter/gather IO when packets are forwarded between interfaces (the 
most common use case for OpenWrt).
It might be possible to avoid this by changing the network stack to 
bypass the linearize if there is only data in the page attached to the 
skb, but I don't know how easy that is to add, nor what corner cases I'd 
need to take care of.

- Felix
