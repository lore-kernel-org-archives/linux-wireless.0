Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33803 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753301AbdC1QkK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 12:40:10 -0400
Received: by mail-wm0-f65.google.com with SMTP id u132so679276wmg.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 09:40:03 -0700 (PDT)
Subject: Re: [PATCH v6 00/10] ath10k: sdio support
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
References: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
 <87k279wrao.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <7917f151-a8af-039d-119c-93ee2e6354f1@gmail.com> (sfid-20170328_184048_124000_45B8CCB4)
Date: Tue, 28 Mar 2017 18:40:01 +0200
MIME-Version: 1.0
In-Reply-To: <87k279wrao.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Please let me know if there is anything I can help with...

I will test the patches as soon as v7 is submitted.

On 2017-03-28 13:53, Kalle Valo wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> I did some changes while reviewing Erik's SDIO patches. Only compile
>> tested, I don't have any SDIO boards at the moment.
>
> [...]
>
>> still todo:
>>
>> o fix remaining memory leaks (if any)
>>
>> o endian support, eg ath10k_sdio_hif_set_mbox_sleep()
>>
>> o are ath10k_sdio_io() and ath10k_sdio_read_write_sync() really
>>   necessary? looks like just an unnecessary abstraction layer
>
> It took me longer than I planned, but here are my notes about what I'm
> planning to do to remove unnecessary ath10k_sdio_io() abstraction:
>
> ath10k_sdio_read_write_sync():
> HIF_RD_SYNC_BLOCK_FIX	-> ath10k_sdio_readsb()
> HIF_RD_SYNC_BYTE_INC	-> ath10k_sdio_read(), ath10k_sdio_read32()
> HIF_WR_SYNC_BYTE_FIX	-> ath10k_sdio_writesb()
> HIF_WR_SYNC_BYTE_INC	-> ath10k_sdio_write()
>
> ath10k_sdio_prep_async_req():
> HIF_WRITE		-> HIF_WR_SYNC_BYTE_INC -> ath10k_sdio_write()
>
> ath10k_sdio_read/write32():
> sdio_readl()/sdio_writel() (those use endian macros)
>
> ath10k_sdio_readsb():
> len = round_down(len, ar_sdio->mbox_info.block_size);
> sdio_memcpy_fromio(len)
>
> With these changes I'm hoping to get rid of also the memory leaks and
> have proper endian support.
>
