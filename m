Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35809 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbdFRE0e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 00:26:34 -0400
Received: by mail-qt0-f196.google.com with SMTP id x58so16005794qtc.2
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jun 2017 21:26:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1497602195-29895-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497602195-29895-1-git-send-email-arend.vanspriel@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 18 Jun 2017 14:26:13 +1000
Message-ID: <CAGRGNgU8=i6Nox1k2c3RozPncm92Z9Gd85f=wgzwaSDmavbA4A@mail.gmail.com> (sfid-20170618_062641_943523_CB0D519C)
Subject: Re: [PATCH] brcmfmac: fix uninitialized warning in brcmf_usb_probe_phase2()
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Fri, Jun 16, 2017 at 6:36 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> This fixes the following warning:
>
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c: In function
>   'brcmf_usb_probe_phase2':
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:1198:2:
>   warning: 'devinfo' may be used uninitialized in this function
>   [-Wmaybe-uninitialized]
>     mutex_unlock(&devinfo->dev_init_lock);
>
> Fixes: 6d0507a777fb ("brcmfmac: add parameter to pass error code in firmware callback")
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> index 9ce3b55..8b16387 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> @@ -1164,14 +1164,13 @@ static void brcmf_usb_probe_phase2(struct device *dev, int ret,
>                                    void *nvram, u32 nvlen)
>  {
>         struct brcmf_bus *bus = dev_get_drvdata(dev);
> -       struct brcmf_usbdev_info *devinfo;
> +       struct brcmf_usbdev_info *devinfo = bus->bus_priv.usb->devinfo;;
>
>         if (ret)
>                 goto error;

Completely unrelated to this specific patch, I just want to point out
that this construct looks _really_ weird.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
