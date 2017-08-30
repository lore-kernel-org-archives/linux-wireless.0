Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35690 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdH3TAD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:00:03 -0400
Received: by mail-wm0-f41.google.com with SMTP id a80so15658271wma.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:00:03 -0700 (PDT)
Subject: Re: [PATCH 03/30] brcmfmac: Split brcmf_sdiod_regrw_helper() up.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-4-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <91172916-24b6-a52a-8ef2-ab891fcce5a0@broadcom.com> (sfid-20170830_210007_645014_7CE98417)
Date: Wed, 30 Aug 2017 20:59:59 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-4-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> 	This large function is concealing a LOT of obscure logic about
> how the hardware functions. Time to split it up.

Again the tab. Guess it is your default ;-)

> This first patch splits the function into two pieces - read and write,
> doing away with the rw flag in the process.
>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 94 +++++++++++++++++-----
>   1 file changed, 73 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 2b441ce91d5f..1ee0f91b6c50 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -302,8 +302,8 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
>   	return ret;
>   }
>   
> -static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
> -				   u8 regsz, void *data, bool write)
> +static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr,
> +				 u8 regsz, void *data)

Thought I mentioned this before, but the indentation should be aligned 
to opening bracket.

>   {
>   	u8 func;
>   	s32 retry = 0;

[...]

> +
> +static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
> +				u8 regsz, void *data)

dito here.

Regards,
Arend
