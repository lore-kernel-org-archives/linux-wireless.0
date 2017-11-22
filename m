Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:64031 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751658AbdKVTRY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 14:17:24 -0500
Date: Wed, 22 Nov 2017 20:17:15 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list@cypress.com
Message-ID: <1736744183.124.1511378235966@email.1und1.de> (sfid-20171122_201732_895505_209F89DD)
In-Reply-To: <08b0ba6f-d4e7-576e-18fe-98e8247d2d91@broadcom.com>
References: <578431614.96494.1510505412682@email.1und1.de>
 <1906631797.229909.1511367617667@email.1und1.de>
 <08b0ba6f-d4e7-576e-18fe-98e8247d2d91@broadcom.com>
Subject: Re: brcmfmac: Unable to handle kernel paging request at virtual
 address 726f6674616cd8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> Arend van Spriel <arend.vanspriel@broadcom.com> hat am 22. November 2017 um 19:23 geschrieben:
> 
> 
> On 22-11-17 17:20, Stefan Wahren wrote:
> > Hi,
> > 
> >> Stefan Wahren <stefan.wahren@i2se.com> hat am 12. November 2017 um 17:50 geschrieben:
> >>
> >>
> >> Hi,
> >> i discovered a random oops during probe of brcmfmac on Raspberry Pi 3 in yesterdays kernelci run for net-next [1]. I need to point out there is no DT entry for the wifi chip on Raspberry Pi 3 in the lack of a driver for the necessary GPIO expander. So the "HT Avail timeout" is expected.
> >>
> >> I was also able to trigger this oops by calling "modprobe brcmfmac" on my Raspberry Pi 3 with latest linux-next.
> >>
> >> Any help to fix this is appreciated.
> >>
> >> [1] - https://storage.kernelci.org/net-next/master/v4.14-rc8-2221-ga8a6f1e4ea78/arm64/defconfig+kselftest/lab-baylibre/boot-bcm2837-rpi-3-b.txt
> >>
> > 
> > the issue still persists in linux-next-20171122:
> > 
> ...
> 
> seems like a use-after-free. We do a device_release_driver() twice. Once 
> for sdio func #1 and for sdio func #2. This was introduced by:
> 
> commit 7a51461fc2da82a6c565a3ee65c41c197f28225d
> Author: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Date:   Mon Jun 12 12:47:34 2017 +0100
> 
>      brcmfmac: unbind all devices upon failure in firmware callback
> 
> What we do is:
> 
>          device_release_driver(dev);
>          device_release_driver(&sdiodev->func[2]->dev);
> 
> with the assumption that dev == &sdiodev->func[1]->dev. I wonder if that 
> is always true. The error print did not make it in your log. Maybe we 
> should make it explicit here (see below).

i tried it, but the issue still occurs.

Maybe this is helpful but this issue doesn't happend everytime. Sometimes i need 2 attemps via unloading/loading.

> 
> Regards,
> Arend
> ---
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c 
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 613caca..0fda9a4 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -4096,7 +4096,7 @@ static void brcmf_sdio_firmware_callback(struct 
> device *dev, int err,
>          sdio_release_host(sdiodev->func[1]);
>   fail:
>          brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
> -       device_release_driver(dev);
> +       device_release_driver(&sdiodev->func[1]->dev);
>          device_release_driver(&sdiodev->func[2]->dev);
>   }
>
