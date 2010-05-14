Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56959 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab0ENP1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 11:27:06 -0400
Received: by vws9 with SMTP id 9so159999vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 08:27:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BED5E08.3050000@openwrt.org>
References: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com>
	 <1273842969-3435-1-git-send-email-tom.leiming@gmail.com>
	 <4BED5E08.3050000@openwrt.org>
Date: Fri, 14 May 2010 23:27:03 +0800
Message-ID: <AANLkTikVkBdTopPJlU2lGkafLIkiiviUHe8J-lTy67y9@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k: fix dma sync in rx path
From: Ming Lei <tom.leiming@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/14 Felix Fietkau <nbd@openwrt.org>:
> On 2010-05-14 3:16 PM, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> If buffer is to be accessed by cpu after dma transfer is over, but
>> between dma mapping and dma unmapping, we should use
>> dma_sync_single_for_cpu to sync the buffer between cpu with
>> device. And dma_sync_single_for_device is used to let
>> device gain the buffer again.
> I think this patch is wrong. On most MIPS devices,
> dma_sync_single_for_cpu is a no-op. In fact, with this patch, the rx
> path fails very quickly.

Sorry for  my  bad email client.

On most MIPS devices,  dma_sync_single_for_cpu does same things
almost with dma_unmap_single(plat_unmap_dma_mem is no-op). If
dma_unmap_single is enough, dma_sync_single_for_cpu is certainly
enough,
isn't it?

For the usage of dma_sync_single_for_cpu or dma_sync_single_for_device,
Documentation/DMA-API*.txt give more details.

> I believe keeping the dma_sync_single_for_device variant is necessary
> for all syncs.

Thanks,

-- 
Lei Ming
