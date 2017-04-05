Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36532 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754734AbdDEQIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 12:08:20 -0400
Received: by mail-lf0-f68.google.com with SMTP id n78so1573492lfi.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Apr 2017 09:08:19 -0700 (PDT)
Subject: Re: [PATCH 0/7] ath10k: remove ath10k_sdio_io()
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org
References: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
Cc: linux-wireless@vger.kernel.org
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <6a6d8e7f-ccd2-0ee6-bd99-6d82dd906843@gmail.com> (sfid-20170405_181024_689863_93BF2CFE)
Date: Wed, 5 Apr 2017 18:08:16 +0200
MIME-Version: 1.0
In-Reply-To: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can't find patch 1/7...

On 2017-04-05 09:06, Kalle Valo wrote:
> Using ath10k_sdio_io() and ath10k_sdio_read_write_sync() are just
> confusing. Refactor the code by following the plan outlined
> below.
>
> I'm planning to fold all these seven patches into Erik's patch
> adding sdio.c[1] so I didn't write any commit logs. I'm just
> submitting these separately to make it easier to review the
> changes.
>
> Kalle
>
> ath10k_sdio_read_write_sync():
> X HIF_RD_SYNC_BLOCK_FIX	-> ath10k_sdio_readsb()
> X HIF_RD_SYNC_BYTE_INC	-> ath10k_sdio_read(), ath10k_sdio_read32()
> X HIF_WR_SYNC_BYTE_FIX	-> ath10k_sdio_writesb32()
> X HIF_WR_SYNC_BYTE_INC	-> ath10k_sdio_write()
>
> ath10k_sdio_prep_async_req():
> X HIF_WRITE		-> HIF_WR_SYNC_BYTE_INC -> ath10k_sdio_write()
>
> ath10k_sdio_read/write32():
> sdio_readl()/sdio_writel() (those use endian macros)
>
> ath10k_sdio_writesb32():
> kmalloc()
> sdio_writesb(len)
> kfree()
>
> ath10k_sdio_readsb():
> len = round_down(len, ar_sdio->mbox_info.block_size);
> sdio_readsb(len)
>
> ath10k_sdio_read():
> sdio_memcpy_fromio()
>
> ath10k_sdio_write():
> sdio_memcpy_toio()
>
>
> [1] https://patchwork.kernel.org/patch/9626001/
>
> ---
>
> Kalle Valo (7):
>       ath10k: add ath10k_sdio_write32/read32()
>       ath10k: add ath10k_sdio_writesb()
>       ath10k: add ath10k_sdio_read()
>       ath10k: add ath10k_sdio_write()
>       ath10k: add ath10k_sdio_readsb()
>       ath10k: convert __ath10k_sdio_write_async() to use ath10k_sdio_write()
>       ath10k: remove unused sdio wrappers
>
>
>  drivers/net/wireless/ath/ath10k/sdio.c |  419 +++++++++++++++++---------------
>  drivers/net/wireless/ath/ath10k/sdio.h |   40 ---
>  2 files changed, 219 insertions(+), 240 deletions(-)
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
>
