Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35909 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932720AbdHVMux (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 08:50:53 -0400
Received: by mail-yw0-f194.google.com with SMTP id s187so2304119ywf.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Aug 2017 05:50:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-18-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk> <20170822112550.60311-18-ian@mnementh.co.uk>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 22 Aug 2017 22:50:32 +1000
Message-ID: <CAGRGNgWUFx=cXjMZdTAkYoXTa=V-6Uty6+ccoXwO7WJA9udQRQ@mail.gmail.com> (sfid-20170822_145057_546045_3EE22F6A)
Subject: Re: [PATCH 17/30] brcmfamc: remove unnecessary call to brcmf_sdiod_set_backplane_window()
To: Ian Molton <ian@mnementh.co.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ian,

On Tue, Aug 22, 2017 at 9:25 PM, Ian Molton <ian@mnementh.co.uk> wrote:
> All functions that might require the window address changing call
> brcmf_sdiod_set_backplane_window() prior to access. Thus resetting
> the window is not required.

Wouldn't it be more safe to write these sorts of functions so that
they set the window themselves instead of relying on the caller?

> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 0d37c68637f2..cabfab9a02a2 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -721,11 +721,6 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
>
>         dev_kfree_skb(pkt);
>
> -       /* Return the window to backplane enumeration space for core access */
> -       if (brcmf_sdiod_set_backplane_window(sdiodev, sdiodev->sbwad))
> -               brcmf_err("FAILED to set window back to 0x%x\n",
> -                         sdiodev->sbwad);
> -
>         sdio_release_host(sdiodev->func[1]);
>
>         return err;
> --
> 2.11.0
>



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
