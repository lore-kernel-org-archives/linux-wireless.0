Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35249 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753163AbdHGLZj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:25:39 -0400
Received: by mail-wm0-f52.google.com with SMTP id m85so4685556wma.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:25:38 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 03/34] brcmfmac: Split brcmf_sdiod_regrw_helper() up.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-4-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E31.8090205@broadcom.com> (sfid-20170807_132542_103183_BE875CFF)
Date: Mon, 7 Aug 2017 13:25:37 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-4-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> 	This large function is concealing a LOT of obscure logic about
> how the hardware functions. Time to split it up.
>
> This first patch splits the function into two pieces - read and write,
> doing away with the rw flag in the process.

I really don't this it is all that obscure, but alas. Everything is in
the eye of the beholder. The reason for having the helper was to not
duplicate code for read and write and different access sizes. So now you
are duplicating it. In subsequent patches you throw away pieces of this
helper so duplication is not as bad in the net result. It would have
been easier if those patches were done before this one.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>

some minor comment below

> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 94 +++++++++++++++++-----
>  1 file changed, 73 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 2b441ce91d5f..1ee0f91b6c50 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -302,8 +302,8 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
>  	return ret;
>  }
>
> -static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
> -				   u8 regsz, void *data, bool write)
> +static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr,
> +				 u8 regsz, void *data)

Fix the indent and column align to opening bracket.

Regards,
Arend
