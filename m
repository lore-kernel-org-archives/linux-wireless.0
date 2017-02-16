Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:32784 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbdBPBTE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 20:19:04 -0500
MIME-Version: 1.0
In-Reply-To: <20170215222948.21030-2-zajec5@gmail.com>
References: <20170215222948.21030-1-zajec5@gmail.com> <20170215222948.21030-2-zajec5@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 16 Feb 2017 03:19:02 +0200
Message-ID: <CAHp75Vee+f5eH7DFWNcWFPcdoBf_63yQh7L71dLpNSmC5fXDww@mail.gmail.com> (sfid-20170216_021932_154606_237BF399)
Subject: Re: [PATCH 2/2] brcmfmac: don't warn user if loading firmware file
 with NVRAM fails
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 16, 2017 at 12:29 AM, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com=
> wrote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> This isn't critical as we use platform NVRAM as fallback and it's very
> common case of all Broadcom home routers. Thanks for the new firmware
> loading function we can achieve this by simply passing FW_OPT_NO_WARN.
>

What kind of warning you are talking about?

On Intel Edison brcmfmac isn't backed up by NVRAM (there no such) and
the platform is not ACPI-based. The warning might be crucial for
debugging Wi-Fi issues on such platforms.

> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
> Kalle, Arend: this patch is strictly related to the bigger 1/2. Could you=
 ack
> this change as I expect this patchset to be picked by Ming, Luis or Greg.
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c =
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index c7c1e9906500..26ec445a8d2d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -504,9 +504,9 @@ static void brcmf_fw_request_code_done(const struct f=
irmware *fw, void *ctx)
>                 return;
>         }
>         fwctx->code =3D fw;
> -       ret =3D request_firmware_nowait(THIS_MODULE, true, fwctx->nvram_n=
ame,
> -                                     fwctx->dev, GFP_KERNEL, fwctx,
> -                                     brcmf_fw_request_nvram_done);
> +       ret =3D request_firmware_async(THIS_MODULE, FW_OPT_NO_WARN,
> +                                    fwctx->nvram_name, fwctx->dev, GFP_K=
ERNEL,
> +                                    fwctx, brcmf_fw_request_nvram_done);
>
>         if (!ret)
>                 return;
> --
> 2.11.0
>



--=20
With Best Regards,
Andy Shevchenko
