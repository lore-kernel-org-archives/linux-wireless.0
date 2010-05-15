Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45153 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab0EOJZx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 May 2010 05:25:53 -0400
Message-ID: <4BEE689A.9060102@openwrt.org>
Date: Sat, 15 May 2010 11:25:46 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: fix dma sync in rx path
References: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com>	 <1273842969-3435-1-git-send-email-tom.leiming@gmail.com>	 <4BED5E08.3050000@openwrt.org>	 <AANLkTikVkBdTopPJlU2lGkafLIkiiviUHe8J-lTy67y9@mail.gmail.com>	 <4BED7809.3090204@openwrt.org> <AANLkTikV8cAc4Njpa1cXq1BHRExkwbaKwjlyyH52rgqO@mail.gmail.com>
In-Reply-To: <AANLkTikV8cAc4Njpa1cXq1BHRExkwbaKwjlyyH52rgqO@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-05-15 3:31 AM, Ming Lei wrote:
> 2010/5/15 Felix Fietkau <nbd@openwrt.org>:
>> On 2010-05-14 5:27 PM, Ming Lei wrote:
>>> 2010/5/14 Felix Fietkau <nbd@openwrt.org>:
>>>> On 2010-05-14 3:16 PM, tom.leiming@gmail.com wrote:
>>>>> From: Ming Lei <tom.leiming@gmail.com>
>>>>>
>>>>> If buffer is to be accessed by cpu after dma transfer is over, but
>>>>> between dma mapping and dma unmapping, we should use
>>>>> dma_sync_single_for_cpu to sync the buffer between cpu with
>>>>> device. And dma_sync_single_for_device is used to let
>>>>> device gain the buffer again.
>>>> I think this patch is wrong. On most MIPS devices,
>>>> dma_sync_single_for_cpu is a no-op. In fact, with this patch, the rx
>>>> path fails very quickly.
>>>
>>> Sorry for  my  bad email client.
>>>
>>> On most MIPS devices,  dma_sync_single_for_cpu does same things
>>> almost with dma_unmap_single(plat_unmap_dma_mem is no-op). If
>>> dma_unmap_single is enough, dma_sync_single_for_cpu is certainly
>>> enough,
>>> isn't it?
>> Because I did some testing with these functions while writing the code,
>> I already know that dma_sync_single_for_cpu is not enough in this case.
> 
> In theory, dma_sync_single_for_cpu is enough in this case, as explained
> in the commit log.
> 
> On MIPS, cache invalidation is done in dma mapping for DMA_FROM_DEVICE
> direction, so it is correct that dma_sync_single_for_cpu or dma unmapping
> is only a no-op since access from CPU will trigger a refetch of the buffer
> from memory into cache.
> 
> Also dma_sync_single_for_device still does cache invalidation for
> DMA_FROM_DEVICE direction, if it has to be done in this case to avoid rx
> failure, I guess there is some code which does touch the dma buffer
> after dma mapping but before dma_sync_single_for_device(should be
> dma_sync_single_for_cpu), maybe before dma transfer is over.
> If so, it should be a bug since it violates the dma api constraint, maybe
> we should have a careful review to check the dma api rule.
The second part of your patch might be OK then (I'm not really sure).
But the first part is definitely wrong, since with EDMA Rx, the
descriptor data is part of the buffer, so the cache needs to be
invalidated for every access until the status bit shows that it has been
completed.
This could probably be fixed by running dma_sync_single_for_device after
an unsuccessful status bit check and also after the descriptor part has
been zero'd out before passing the buffer on to the hw.

- Felix
