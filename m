Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39274 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdFOQR7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 12:17:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH for-4.12 1/3] brcmfmac: add parameter to pass error code in firmware callback
References: <1497268054-4507-1-git-send-email-arend.vanspriel@broadcom.com>
        <1497268054-4507-2-git-send-email-arend.vanspriel@broadcom.com>
Date: Thu, 15 Jun 2017 19:17:49 +0300
In-Reply-To: <1497268054-4507-2-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Mon, 12 Jun 2017 12:47:32 +0100")
Message-ID: <87vanxns2a.fsf@purkki.adurom.net> (sfid-20170615_181821_361770_955DEFA3)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> Extend the parameters in the firmware callback so it can be called
> upon success and failure. This allows the caller to properly clear
> all resources in the failure path. Right now the error code is
> always zero, ie. success.
>
> Cc: stable@vger.kernel.org # 4.9.x-
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

[...]

> -static void brcmf_usb_probe_phase2(struct device *dev,
> +static void brcmf_usb_probe_phase2(struct device *dev, int ret,
>  				   const struct firmware *fw,
>  				   void *nvram, u32 nvlen)
>  {
>  	struct brcmf_bus *bus =3D dev_get_drvdata(dev);
>  	struct brcmf_usbdev_info *devinfo;
> -	int ret;
> +
> +	if (ret)
> +		goto error;

This introduces a new warning:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:1198:2: warning:
=E2=80=98devinfo=E2=80=99 may be used uninitialized in this function
[-Wmaybe-uninitialized]

>From a quick look I think it's valid, but due to my mistake I only
noticed it after I had applied the patch. So can you send a small
followup patch to fix this, please?

--=20
Kalle Valo
