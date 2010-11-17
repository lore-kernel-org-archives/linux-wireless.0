Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:58755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935045Ab0KQVV5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 16:21:57 -0500
Date: Wed, 17 Nov 2010 13:11:29 -0800
From: Greg KH <greg@kroah.com>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] staging: brcm80211: brcmfmac: cleanup
 bcmsdh_(un)register
Message-ID: <20101117211129.GA31776@kroah.com>
References: <20101116200438.GA10803@kroah.com>
 <1289980800-28743-1-git-send-email-mike.rapoport@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1289980800-28743-1-git-send-email-mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 10:00:00AM +0200, Mike Rapoport wrote:
> Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
> ---
>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
> index fd327e1..e3fb7ed 100644
> --- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
> +++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
> @@ -285,28 +285,17 @@ extern int sdio_function_init(void);
>  
>  int bcmsdh_register(bcmsdh_driver_t *driver)
>  {
> -	int error = 0;
> -
>  	drvinfo = *driver;
>  
> -#if defined(BCMPLATFORM_BUS)
> -#if defined(BCMLXSDMMC)
>  	SDLX_MSG(("Linux Kernel SDIO/MMC Driver\n"));
> -	error = sdio_function_init();

Same question here, are you sure we can remove this code?

just want to make sure.

thanks,

greg k-h
