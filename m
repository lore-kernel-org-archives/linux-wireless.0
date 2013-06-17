Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:35046 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3FQTii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 15:38:38 -0400
Received: by mail-we0-f179.google.com with SMTP id w59so2645069wes.24
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 12:38:35 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH] ssb: add struct for serial flash
Date: Mon, 17 Jun 2013 20:38:21 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
References: <1371491780-23412-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1371491780-23412-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201306172038.21642.florian@openwrt.org> (sfid-20130617_213847_578719_99827962)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Rafal,

Le lundi 17 juin 2013 18:56:20, Rafał Miłecki a écrit :
> This data allow writing for example MTD driver.

Your commit message could probably have some more information, by looking at 
the patch, it is not entirely clear to me what this does, especially as sflash 
is just a write only structure?

> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/ssb/driver_chipcommon_sflash.c |    7 +++++++
>  include/linux/ssb/ssb_driver_mips.h    |   15 +++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/drivers/ssb/driver_chipcommon_sflash.c
> b/drivers/ssb/driver_chipcommon_sflash.c index 1b9e770..205f1c4 100644
> --- a/drivers/ssb/driver_chipcommon_sflash.c
> +++ b/drivers/ssb/driver_chipcommon_sflash.c
> @@ -73,6 +73,7 @@ static void ssb_sflash_cmd(struct ssb_chipcommon *cc, u32
> opcode) /* Initialize serial flash access */
>  int ssb_sflash_init(struct ssb_chipcommon *cc)
>  {
> +	struct ssb_sflash *sflash = &cc->dev->bus->mipscore.sflash;
>  	const struct ssb_sflash_tbl_e *e;
>  	u32 id, id2;
> 
> @@ -131,6 +132,12 @@ int ssb_sflash_init(struct ssb_chipcommon *cc)
>  		return -ENOTSUPP;
>  	}
> 
> +	sflash->window = SSB_FLASH2;
> +	sflash->blocksize = e->blocksize;
> +	sflash->numblocks = e->numblocks;
> +	sflash->size = sflash->blocksize * sflash->numblocks;
> +	sflash->present = true;
> +
>  	pr_info("Found %s serial flash (blocksize: 0x%X, blocks: %d)\n",
>  		e->name, e->blocksize, e->numblocks);
> 
> diff --git a/include/linux/ssb/ssb_driver_mips.h
> b/include/linux/ssb/ssb_driver_mips.h index afe79d4..6535e47 100644
> --- a/include/linux/ssb/ssb_driver_mips.h
> +++ b/include/linux/ssb/ssb_driver_mips.h
> @@ -20,6 +20,18 @@ struct ssb_pflash {
>  	u32 window_size;
>  };
> 
> +#ifdef CONFIG_SSB_SFLASH
> +struct ssb_sflash {
> +	bool present;
> +	u32 window;
> +	u32 blocksize;
> +	u16 numblocks;
> +	u32 size;
> +
> +	void *priv;
> +};
> +#endif
> +
>  struct ssb_mipscore {
>  	struct ssb_device *dev;
> 
> @@ -27,6 +39,9 @@ struct ssb_mipscore {
>  	struct ssb_serial_port serial_ports[4];
> 
>  	struct ssb_pflash pflash;
> +#ifdef CONFIG_SSB_SFLASH
> +	struct ssb_sflash sflash;
> +#endif
>  };
> 
>  extern void ssb_mipscore_init(struct ssb_mipscore *mcore);

-- 
Florian
