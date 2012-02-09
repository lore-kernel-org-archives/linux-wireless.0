Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40813 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2BIXvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 18:51:13 -0500
Received: by yenm8 with SMTP id m8so1232709yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 15:51:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328818149-4826-10-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com> <1328818149-4826-10-git-send-email-arend@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Feb 2012 10:50:53 +1100
Message-ID: <CAGRGNgXPE3T_jTFDvxAQ_Of4kNQSOGwwAy_-Na3iR24xvnLEZA@mail.gmail.com> (sfid-20120210_005119_671572_BFB32A70)
Subject: Re: [PATCH 09/15] brcm80211: fmac: move module entry points to dhd_linux.c
To: Arend van Spriel <arend@broadcom.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Quick query:

On Fri, Feb 10, 2012 at 07:09, Arend van Spriel <arend@broadcom.com> wrote:
> The module_init/exit functions are moved to dhd_linux.c to prepare
> for supporting multiple host interface types.
>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    7 +----
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    6 +++++
>  .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   24 ++++++++++++++++++++
>  3 files changed, 32 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
> index eff0073..ff7fc0e 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
> @@ -1183,3 +1183,27 @@ exit:
>        return ret;
>  }
>  #endif                         /* DEBUG */
> +
> +static int __init brcmfmac_init(void)
> +{
> +       int ret = 0;
> +
> +#ifdef CONFIG_BRCMFMAC_SDIO
> +       ret = brcmf_sdio_init();
> +       if (ret)
> +               goto fail;
> +#endif

I assume that the USB driver init will be added here as a separate #ifdef block.

If this is the case, doesn't this mean that on a system with both the
USB and SDIO drivers enabled in .config, you won't be able to load the
USB driver without the SDIO driver or vice-versa?

The model that most other drivers I've seen use is to have
bus-specific modules and a common code module.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
