Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:50157 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753843AbdKXSrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Nov 2017 13:47:52 -0500
Date: Fri, 24 Nov 2017 19:47:42 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list@cypress.com
Message-ID: <1830131626.467184.1511549262573@email.1und1.de> (sfid-20171124_194755_765877_38DF1E3C)
In-Reply-To: <5A181609.40907@broadcom.com>
References: <578431614.96494.1510505412682@email.1und1.de>
 <1906631797.229909.1511367617667@email.1und1.de>
 <08b0ba6f-d4e7-576e-18fe-98e8247d2d91@broadcom.com>
 <1736744183.124.1511378235966@email.1und1.de> <5A181609.40907@broadcom.com>
Subject: Re: brcmfmac: Unable to handle kernel paging request at virtual
 address 726f6674616cd8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> Arend van Spriel <arend.vanspriel@broadcom.com> hat am 24. November 2017 um 13:52 geschrieben:
> 
> 
> ...
> 
> I just realized the remove of sdio func #1 removes everything so we must 
> first remove sdio func #2. Can you try the patch below.
> 
> Regards,
> Arend
> ---
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c 
> b/drivers/n
> index b2256aa..58fa438 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -4121,8 +4121,8 @@ static void brcmf_sdio_firmware_callback(struct 
> device *de
>          sdio_release_host(sdiodev->func[1]);
>   fail:
>          brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
> -       device_release_driver(dev);
>          device_release_driver(&sdiodev->func[2]->dev);
> +       device_release_driver(dev);
>   }
> 
>   struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
> 
>

that's it. The issue disappeared.

Thanks
Stefan
