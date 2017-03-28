Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10129 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752219AbdC1LyJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 07:54:09 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v6 00/10] ath10k: sdio support
Date: Tue, 28 Mar 2017 11:53:51 +0000
Message-ID: <87k279wrao.fsf@kamboji.qca.qualcomm.com> (sfid-20170328_135521_474129_03518C56)
References: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
In-Reply-To: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
        (Kalle Valo's message of "Wed, 15 Mar 2017 17:44:41 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> I did some changes while reviewing Erik's SDIO patches. Only compile
> tested, I don't have any SDIO boards at the moment.

[...]

> still todo:
>
> o fix remaining memory leaks (if any)
>
> o endian support, eg ath10k_sdio_hif_set_mbox_sleep()
>
> o are ath10k_sdio_io() and ath10k_sdio_read_write_sync() really
>   necessary? looks like just an unnecessary abstraction layer

It took me longer than I planned, but here are my notes about what I'm
planning to do to remove unnecessary ath10k_sdio_io() abstraction:

ath10k_sdio_read_write_sync():
HIF_RD_SYNC_BLOCK_FIX	-> ath10k_sdio_readsb()
HIF_RD_SYNC_BYTE_INC	-> ath10k_sdio_read(), ath10k_sdio_read32()
HIF_WR_SYNC_BYTE_FIX	-> ath10k_sdio_writesb()
HIF_WR_SYNC_BYTE_INC	-> ath10k_sdio_write()

ath10k_sdio_prep_async_req():
HIF_WRITE		-> HIF_WR_SYNC_BYTE_INC -> ath10k_sdio_write()

ath10k_sdio_read/write32():
sdio_readl()/sdio_writel() (those use endian macros)

ath10k_sdio_readsb():
len =3D round_down(len, ar_sdio->mbox_info.block_size);
sdio_memcpy_fromio(len)

With these changes I'm hoping to get rid of also the memory leaks and
have proper endian support.

--=20
Kalle Valo=
