Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:41046 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S939332AbeE1OfS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 10:35:18 -0400
Subject: Re: [PATCH 1/2] NFC: st95hf: initialize semaphore and mutex earlier
To: sameo@linux.intel.com, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org
References: <20180516133247.25986-1-daniel@zonque.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <6eed2f2f-b3cc-0582-220c-e4ccd2175fd7@zonque.org> (sfid-20180528_163526_703871_5A0CE01C)
Date: Mon, 28 May 2018 16:35:15 +0200
MIME-Version: 1.0
In-Reply-To: <20180516133247.25986-1-daniel@zonque.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, May 16, 2018 03:32 PM, Daniel Mack wrote:
> 'rm_lock' and 'exchange_lock' need to be ready before the IRQ handler has a
> chance to fire.
> 
> This fixes the oops below.

Nobody seems to be interested in these. Davem, can you take them through 
your tree or is there anyone else I can ping?


Thanks,
Daniel


> 
> [    1.040255] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [...]
> [    1.181564] Call trace:
> [    1.188591] Exception stack(0xffff00000a473c40 to 0xffff00000a473d80)
> [    1.190943] 3c40: ffff80003673b118 0000000000000000 ffff800036374380 0000000000000000
> [    1.197542] 3c60: 0000000000000000 0000000000000000 00000000044b2ac5 0000000000000001
> [    1.205354] 3c80: ffff800036374d60 ffff00000a473d70 0000000000000980 0000000000000000
> [    1.213166] 3ca0: 0000000000000001 0000000000000000 000000000000004c 0000000000000033
> [    1.217590] st95hf spi2.0: err: por seq failed for st95hf
> [    1.228788] 3cc0: 0000000000000019 0000000000000001 0000000000000007 ffff80003673b118
> [    1.234175] 3ce0: ffff800009f27000 0000000000000000 ffff80003673b1c8 ffff80003673b1b0
> [    1.241986] 3d00: ffff0000080f0000 ffff800009f716a4 ffff00000894bb40 0000000000000000
> [    1.249800] 3d20: 0000000000000000 ffff00000a473d80 ffff0000084268c0 ffff00000a473d80
> [    1.257611] 3d40: ffff0000084268c4 0000000040000005 ffff00000a473d60 ffff0000080e5688
> [    1.265424] 3d60: ffffffffffffffff ffff0000084268a4 ffff00000a473d80 ffff0000084268c4
> [    1.273239] [<ffff0000084268c4>] st95hf_irq_thread_handler+0x44/0x3a0
> [    1.281048] [<ffff0000080f00b0>] irq_thread_fn+0x28/0x68
> [    1.287468] [<ffff0000080f035c>] irq_thread+0x10c/0x1a0
> [    1.292850] [<ffff0000080c50bc>] kthread+0x12c/0x130
> [    1.297799] [<ffff000008084b88>] ret_from_fork+0x10/0x18
> [    1.303008] Code: aa1603e0 f9403675 940d010f aa1303e0 (f94066a1)
> [    1.308307] ---[ end trace d058c1b88aad74d8 ]---
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>   drivers/nfc/st95hf/core.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
> index 2b26f762fbc3..394bdc7b0cf2 100644
> --- a/drivers/nfc/st95hf/core.c
> +++ b/drivers/nfc/st95hf/core.c
> @@ -1112,8 +1112,10 @@ static int st95hf_probe(struct spi_device *nfc_spi_dev)
>   		}
>   	}
>   
> +	sema_init(&st95context->exchange_lock, 1);
>   	init_completion(&spicontext->done);
>   	mutex_init(&spicontext->spi_lock);
> +	mutex_init(&st95context->rm_lock);
>   
>   	/*
>   	 * Store spicontext in spi device object for using it in
> @@ -1197,9 +1199,6 @@ static int st95hf_probe(struct spi_device *nfc_spi_dev)
>   	/* store st95context in nfc device object */
>   	nfc_digital_set_drvdata(st95context->ddev, st95context);
>   
> -	sema_init(&st95context->exchange_lock, 1);
> -	mutex_init(&st95context->rm_lock);
> -
>   	return ret;
>   
>   err_free_digital_device:
> 
