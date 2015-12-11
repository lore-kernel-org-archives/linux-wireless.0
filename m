Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34982 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbbLKNpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 08:45:01 -0500
Received: by pfd5 with SMTP id 5so4939255pfd.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2015 05:45:00 -0800 (PST)
Subject: Re: [PATCH] wcn36xx: handle rx skb allocation failure to avoid system
 crash
To: Bob Copeland <me@bobcopeland.com>
References: <1449034051-12536-1-git-send-email-fengwei.yin@linaro.org>
 <566ACC1C.1070304@linaro.org> <20151211133730.GA8835@localhost>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com,
	lking@qti.qualcomm.com
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <566AD356.50404@linaro.org> (sfid-20151211_144506_511305_25C3CF8A)
Date: Fri, 11 Dec 2015 21:44:54 +0800
MIME-Version: 1.0
In-Reply-To: <20151211133730.GA8835@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015/12/11 21:37, Bob Copeland wrote:
> On Fri, Dec 11, 2015 at 09:14:04PM +0800, fengwei.yin wrote:
>>
>> On 2015/12/2 13:27, Fengwei Yin wrote:
>>> Lawrence reported that git clone could make system crash on a
>>> Qualcomm ARM soc based device (DragonBoard, 1G memory without
>>> swap) running 64bit Debian.
>>>
>>> It's turned out the crash is related with rx skb allocation
>>> failure. git could consume more than 600MB anonymous memory.
>>> And system is in extremely memory shortage case.
>>>
>>> But driver didn't handle the rx allocation failure case. This patch
>>> doesn't submit skb to upper layer if rx skb allocation fails.
>>> Instead, it reuse the old skb for rx DMA again. It's more like
>>> drop the packets if system is in memory shortage case.
>>>
>>> With this change, git clone is OOMed instead of system crash.
>>>
>>> Reported-by: King, Lawrence <lking@qti.qualcomm.com>
>>> Signed-off-by: Fengwei Yin <fengwei.yin@linaro.org>
>
> Concept makes sense to me, but:
Thanks for looking at it.

>
>>>   		dma_addr = dxe->dst_addr_l;
>>> -		wcn36xx_dxe_fill_skb(wcn->dev, ctl);
>>> +		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl);
>>> +		if (0 == ret) {
>
> I find this "success handling" to be unclear and traditionally this
> kind of thing is a source of bugs; how about instead:
>
>>> +			/* new skb allocation ok. Use the new one and queue
>>> +			 * the old one to network system.
>>> +			 */
>>> +			dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
>>> +					DMA_FROM_DEVICE);
>>> +			wcn36xx_rx_skb(wcn, skb);
>>> +		}
>
>             ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl);
>
>             /* skip this frame if we can't alloc a new rx buffer */
>             if (ret)
>                    goto drop;
This can't work because we need to initialize the DMA for the old skb again.
Which is done in following
	switch (ch->ch_type) {
block.

Regards
Yin, Fengwei

>
>>>   		switch (ch->ch_type) {
>>>   		case WCN36XX_DXE_CH_RX_L:
>>> @@ -495,9 +504,6 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>>>   			wcn36xx_warn("Unknown channel\n");
>>>   		}
>>>
>>> -		dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
>>> -				 DMA_FROM_DEVICE);
>>> -		wcn36xx_rx_skb(wcn, skb);
>
> drop:
>
>>>   		ctl = ctl->next;
>>>   		dxe = ctl->desc;
>>>   	}
>
