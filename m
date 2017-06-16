Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36206 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752385AbdFPIo1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 04:44:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] brcmfmac: fix uninitialized warning in brcmf_usb_probe_phase2()
References: <1497602195-29895-1-git-send-email-arend.vanspriel@broadcom.com>
Date: Fri, 16 Jun 2017 11:44:22 +0300
In-Reply-To: <1497602195-29895-1-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Fri, 16 Jun 2017 09:36:35 +0100")
Message-ID: <87shj0z5i1.fsf@kamboji.qca.qualcomm.com> (sfid-20170616_104431_125723_CA2E5973)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

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
> Hi Kalle,
>
> Here it is. Was indeed a valid warning.

Thanks for the quick fix.

> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> @@ -1164,14 +1164,13 @@ static void brcmf_usb_probe_phase2(struct device *dev, int ret,
>  				   void *nvram, u32 nvlen)
>  {
>  	struct brcmf_bus *bus = dev_get_drvdata(dev);
> -	struct brcmf_usbdev_info *devinfo;
> +	struct brcmf_usbdev_info *devinfo = bus->bus_priv.usb->devinfo;;

But an extra semicolon :) I'll try to edit it out during commit.

-- 
Kalle Valo
