Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37835 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752919AbdHGLZW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:25:22 -0400
Received: by mail-wm0-f50.google.com with SMTP id t201so4611853wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:25:22 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 01/34] brcmfmac: Fix parameter order in
 brcmf_sdiod_f0_writeb()
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-2-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E20.7090108@broadcom.com> (sfid-20170807_132526_140533_F9914971)
Date: Mon, 7 Aug 2017 13:25:20 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-2-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ian,

So it took me a while to get to this patch series. It is indeed way to 
big and not well structured making it difficult to review the patches on 
a per-patch basis.

I decided to limit myself to looking at the patches involving bcmsdh.c 
doing a 'git log bcmsdh.c' on the applied patches. Still twenty patches 
to review. I reviewed the first 15 patches of the series and skipped 
patch [13/34] as it did not touch bcmsdh.c. A few response already 
slipped to the mailing list so I will post the rest shortly. Here is the 
first one.

On 26-07-17 22:25, Ian Molton wrote:
> 	All the other IO functions are the other way round in this
> driver. Make this one match.

Core SDIO functions are indeed the other way around, but the IO
functions in this file use (addr, data) pattern. So should we aim to get 
it all consistent with core SDIO or just consistent on its own.

> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 984c1d0560b1..f585dfd89453 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -230,8 +230,8 @@ void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
>  	sdiodev->state = state;
>  }
>
> -static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func,
> -					uint regaddr, u8 byte)
> +static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func, u8 byte,
> +					uint regaddr)

The second line needs to be aligned on same column as the opening bracket.

Regards,
Arend
