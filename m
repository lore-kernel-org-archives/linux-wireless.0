Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46479 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab0ENQTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 12:19:32 -0400
Message-ID: <4BED7809.3090204@openwrt.org>
Date: Fri, 14 May 2010 18:19:21 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: fix dma sync in rx path
References: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com>	 <1273842969-3435-1-git-send-email-tom.leiming@gmail.com>	 <4BED5E08.3050000@openwrt.org> <AANLkTikVkBdTopPJlU2lGkafLIkiiviUHe8J-lTy67y9@mail.gmail.com>
In-Reply-To: <AANLkTikVkBdTopPJlU2lGkafLIkiiviUHe8J-lTy67y9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-05-14 5:27 PM, Ming Lei wrote:
> 2010/5/14 Felix Fietkau <nbd@openwrt.org>:
>> On 2010-05-14 3:16 PM, tom.leiming@gmail.com wrote:
>>> From: Ming Lei <tom.leiming@gmail.com>
>>>
>>> If buffer is to be accessed by cpu after dma transfer is over, but
>>> between dma mapping and dma unmapping, we should use
>>> dma_sync_single_for_cpu to sync the buffer between cpu with
>>> device. And dma_sync_single_for_device is used to let
>>> device gain the buffer again.
>> I think this patch is wrong. On most MIPS devices,
>> dma_sync_single_for_cpu is a no-op. In fact, with this patch, the rx
>> path fails very quickly.
> 
> Sorry for  my  bad email client.
> 
> On most MIPS devices,  dma_sync_single_for_cpu does same things
> almost with dma_unmap_single(plat_unmap_dma_mem is no-op). If
> dma_unmap_single is enough, dma_sync_single_for_cpu is certainly
> enough,
> isn't it?
Because I did some testing with these functions while writing the code,
I already know that dma_sync_single_for_cpu is not enough in this case.

Maybe we need to place the dma_sync_single_for_device call elsewhere and
then move the dma_sync_single_for_cpu call there afterwads, but simply
replacing this instance as is done in your patch *will* cause regressions.

- Felix
