Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f171.google.com ([209.85.221.171]:42631 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0EOBbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 21:31:31 -0400
Received: by qyk1 with SMTP id 1so4078555qyk.5
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 18:31:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BED7809.3090204@openwrt.org>
References: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com>
	 <1273842969-3435-1-git-send-email-tom.leiming@gmail.com>
	 <4BED5E08.3050000@openwrt.org>
	 <AANLkTikVkBdTopPJlU2lGkafLIkiiviUHe8J-lTy67y9@mail.gmail.com>
	 <4BED7809.3090204@openwrt.org>
Date: Sat, 15 May 2010 09:31:30 +0800
Message-ID: <AANLkTikV8cAc4Njpa1cXq1BHRExkwbaKwjlyyH52rgqO@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k: fix dma sync in rx path
From: Ming Lei <tom.leiming@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/15 Felix Fietkau <nbd@openwrt.org>:
> On 2010-05-14 5:27 PM, Ming Lei wrote:
>> 2010/5/14 Felix Fietkau <nbd@openwrt.org>:
>>> On 2010-05-14 3:16 PM, tom.leiming@gmail.com wrote:
>>>> From: Ming Lei <tom.leiming@gmail.com>
>>>>
>>>> If buffer is to be accessed by cpu after dma transfer is over, but
>>>> between dma mapping and dma unmapping, we should use
>>>> dma_sync_single_for_cpu to sync the buffer between cpu with
>>>> device. And dma_sync_single_for_device is used to let
>>>> device gain the buffer again.
>>> I think this patch is wrong. On most MIPS devices,
>>> dma_sync_single_for_cpu is a no-op. In fact, with this patch, the rx
>>> path fails very quickly.
>>
>> Sorry for  my  bad email client.
>>
>> On most MIPS devices,  dma_sync_single_for_cpu does same things
>> almost with dma_unmap_single(plat_unmap_dma_mem is no-op). If
>> dma_unmap_single is enough, dma_sync_single_for_cpu is certainly
>> enough,
>> isn't it?
> Because I did some testing with these functions while writing the code,
> I already know that dma_sync_single_for_cpu is not enough in this case.

In theory, dma_sync_single_for_cpu is enough in this case, as explained
in the commit log.

On MIPS, cache invalidation is done in dma mapping for DMA_FROM_DEVICE
direction, so it is correct that dma_sync_single_for_cpu or dma unmapping
is only a no-op since access from CPU will trigger a refetch of the buffer
from memory into cache.

Also dma_sync_single_for_device still does cache invalidation for
DMA_FROM_DEVICE direction, if it has to be done in this case to avoid rx
failure, I guess there is some code which does touch the dma buffer
after dma mapping but before dma_sync_single_for_device(should be
dma_sync_single_for_cpu), maybe before dma transfer is over.
If so, it should be a bug since it violates the dma api constraint, maybe
we should have a careful review to check the dma api rule.

>
> Maybe we need to place the dma_sync_single_for_device call elsewhere and
> then move the dma_sync_single_for_cpu call there afterwads, but simply
> replacing this instance as is done in your patch *will* cause regressions.
>
> - Felix
>

-- 
Lei Ming
