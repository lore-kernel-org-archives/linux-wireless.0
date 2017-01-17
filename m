Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39208 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750888AbdAQA4T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 19:56:19 -0500
Subject: Re: brcmfmac: add support for BCM43455 with modalias
 sdio:c00v02D0dA9BF
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-mmc@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        ulf.hansson@linaro.org
References: <20170116101757.20483-1-martin.blumenstingl@googlemail.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
From: =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Message-ID: <05c41a09-c7d3-f53e-f19d-88b480f2b4c3@suse.de> (sfid-20170117_015622_923153_1095F756)
Date: Tue, 17 Jan 2017 01:19:24 +0100
MIME-Version: 1.0
In-Reply-To: <20170116101757.20483-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

Am 16.01.2017 um 11:17 schrieb Martin Blumenstingl:
> BCM43455 is a more recent revision of the BCM4345. Some of the BCM43455
> got a dedicated SDIO device ID which is currently not supported by
> brcmfmac.
> Adding the new sdio_device_id to brcmfmac is enough to get the BCM43455
> supported because the chip itself is already supported (due to BCM4345
> support in the driver).
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> This is the proper patch following the (short) discussion from [0]
> 
> [0] https://marc.info/?l=linux-wireless&m=148455981002310&w=2
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 1 +
>  include/linux/mmc/sdio_ids.h                              | 1 +
>  2 files changed, 2 insertions(+)

Reviewed-by: Andreas Färber <afaerber@suse.de>

I encountered the same ID on my R-Box Pro 3G and tested the exact same
patch based on [0] there:

[  +0,130866] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
Mar  1 2015 07:29:38 version 7.45.18 (r538002) FWID 01-6a2c8ad4
...
[  +0,156118] brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166 code
(0x30 0x30)
...
[  +1,790419] brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166 code
(0x30 0x30)

Tested-by: Andreas Färber <afaerber@suse.de>

Thanks,

Andreas

-- 
SUSE Linux GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
