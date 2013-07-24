Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51792 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3GXPAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 11:00:10 -0400
Date: Wed, 24 Jul 2013 10:55:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] ssb: drop BROKEN from SSB_SFLASH
Message-ID: <20130724145500.GC2385@tuxdriver.com> (sfid-20130724_170022_398995_F22AA703)
References: <1372148026-9750-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1372148026-9750-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Did Hauke respond to this?

On Tue, Jun 25, 2013 at 10:13:46AM +0200, Rafał Miłecki wrote:
> With recent patches ssb can fetch info about serial flash and register
> it as a platform device. No more reasons to mark it BROKEN.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> ---
> Hauke: does it look OK for you? Did you give it a try?
> ---
>  drivers/ssb/Kconfig                    |    2 +-
>  drivers/ssb/driver_chipcommon_sflash.c |    8 +++-----
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
> index 4f0dd37..775251d 100644
> --- a/drivers/ssb/Kconfig
> +++ b/drivers/ssb/Kconfig
> @@ -139,7 +139,7 @@ config SSB_DRIVER_MIPS
>  
>  config SSB_SFLASH
>  	bool "SSB serial flash support"
> -	depends on SSB_DRIVER_MIPS && BROKEN
> +	depends on SSB_DRIVER_MIPS
>  	default y
>  
>  # Assumption: We are on embedded, if we compile the MIPS core.
> diff --git a/drivers/ssb/driver_chipcommon_sflash.c b/drivers/ssb/driver_chipcommon_sflash.c
> index e84cf04..50328de 100644
> --- a/drivers/ssb/driver_chipcommon_sflash.c
> +++ b/drivers/ssb/driver_chipcommon_sflash.c
> @@ -151,8 +151,8 @@ int ssb_sflash_init(struct ssb_chipcommon *cc)
>  	sflash->size = sflash->blocksize * sflash->numblocks;
>  	sflash->present = true;
>  
> -	pr_info("Found %s serial flash (blocksize: 0x%X, blocks: %d)\n",
> -		e->name, e->blocksize, e->numblocks);
> +	pr_info("Found %s serial flash (size: %dKiB, blocksize: 0x%X, blocks: %d)\n",
> +		e->name, sflash->size / 1024, e->blocksize, e->numblocks);
>  
>  	/* Prepare platform device, but don't register it yet. It's too early,
>  	 * malloc (required by device_private_init) is not available yet. */
> @@ -160,7 +160,5 @@ int ssb_sflash_init(struct ssb_chipcommon *cc)
>  					 sflash->size;
>  	ssb_sflash_dev.dev.platform_data = sflash;
>  
> -	pr_err("Serial flash support is not implemented yet!\n");
> -
> -	return -ENOTSUPP;
> +	return 0;
>  }
> -- 
> 1.7.10.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
