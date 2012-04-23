Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58672 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2DWIrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 04:47:14 -0400
Received: by bkcik5 with SMTP id ik5so8376457bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 01:47:13 -0700 (PDT)
Message-ID: <4F9516B5.3000509@openwrt.org> (sfid-20120423_104718_390173_B2BFC4D3)
Date: Mon, 23 Apr 2012 10:45:41 +0200
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.4 1/2] brcm80211: fmac: fix SDIO function 0 register
 r/w issue
References: <1334957269-27416-1-git-send-email-frankyl@broadcom.com> <1334957269-27416-2-git-send-email-frankyl@broadcom.com>
In-Reply-To: <1334957269-27416-2-git-send-email-frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Franky,

Le 04/20/12 23:27, Franky Lin a écrit :
> SDIO stack doesn't have a structure for function 0. The structure
> pointer stored in card->sdio_func[0] is actually for function 1.
> With current implementation the register read/write is applied to
> function 1. This pathch fixes the issue.
>
> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
> Reviewed-by: Arend van Spriel<arend@broadcom.com>
> Signed-off-by: Franky Lin<frankyl@broadcom.com>
> ---
>   .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> index 4688904..6989916 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> @@ -108,9 +108,13 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
>   			sdio_release_host(sdfunc);
>   		}
>   	} else if (regaddr == SDIO_CCCR_ABORT) {
> +		sdfunc = kzalloc(sizeof(struct sdio_func), GFP_KERNEL);

You are not catching a kzalloc() possible failure here.

> +		memcpy(sdfunc, sdiodev->func[0], sizeof(struct sdio_func));
> +		sdfunc->num = 0;
>   		sdio_claim_host(sdfunc);
>   		sdio_writeb(sdfunc, *byte, regaddr,&err_ret);
>   		sdio_release_host(sdfunc);
> +		kfree(sdfunc);
>   	} else if (regaddr<  0xF0) {
>   		brcmf_dbg(ERROR, "F0 Wr:0x%02x: write disallowed\n", regaddr);
>   		err_ret = -EPERM;
> @@ -486,7 +490,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
>   			kfree(bus_if);
>   			return -ENOMEM;
>   		}
> -		sdiodev->func[0] = func->card->sdio_func[0];
> +		sdiodev->func[0] = func;
>   		sdiodev->func[1] = func;
>   		sdiodev->bus_if = bus_if;
>   		bus_if->bus_priv.sdio = sdiodev;
