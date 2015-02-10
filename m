Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:30387 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbBJVm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 16:42:56 -0500
Message-ID: <54DA7B5C.5040604@broadcom.com> (sfid-20150210_224259_090170_E43C16EA)
Date: Tue, 10 Feb 2015 22:42:52 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Steeve Morin <steeve.morin@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac + AP6120 (brcm43362) doesn't connect to WPA2 AP (unprotected
 ok)
References: <CAEZVCP4bNmfnHH=Ksi6wMQoqdZGbprUH5X_VA41GRf9=h2MT1A@mail.gmail.com> <54D92DFC.1080604@broadcom.com> <CAEZVCP7+gTqJJUNQuUDTGWG1BQ4_XY7Q79Cg-2daVourfasvEw@mail.gmail.com> <CAEZVCP6HNDsR=S4c5xYLr=UZZmQhA9WBwrzwT_5jJvfXz+gC1A@mail.gmail.com> <CAEZVCP6R4-aotR4K5=EhXzg0jEcgfoURAXmbc+Xeb3UZWNs0Kw@mail.gmail.com> <CAEZVCP4=ZRPFtdychXOhURvqaT02E_9dPpMf-zp2qB-eBsRRVQ@mail.gmail.com> <54DA4070.8080002@broadcom.com> <CAEZVCP6FzA8c95hxoBm_cDjT8MuoxaijsA1Wx69dO1z8eBoZuQ@mail.gmail.com>
In-Reply-To: <CAEZVCP6FzA8c95hxoBm_cDjT8MuoxaijsA1Wx69dO1z8eBoZuQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/15 21:03, Steeve Morin wrote:
> Okay I've managed to fix it, it was due to a faulty mmc setting in the
> kernel driver from the chip maker.
>
> Basically it was setting a wrong max_blk_count and max_blk_size for
> the MMC host.
>
> Basically, max_blk_count was set wrong, causing a BUG_ON assertion,
> and when patched, because the max_blk_size was wrong, it was
> overflowing the MMC buffer (this is 128k according to the device
> tree).
>
> Thank you for your time, actually talking about it and laying it out
> made me look in the right direction.

Glad to help. Did not expect I would get off that easy ;-)

Regards,
Arend

> Here is the fix.
>
>  From 6c92e578748e039dfcfd8e737efdead6cd3e7568 Mon Sep 17 00:00:00 2001
> From: Steeve Morin<steeve.morin@gmail.com>
> Date: Mon, 9 Feb 2015 16:25:49 +0100
> Subject: [PATCH 4/4] Properly set max_blk_count and max_blk_size for the host
>   mmc
>
> Signed-off-by: Steeve Morin<steeve.morin@gmail.com>
> ---
>   drivers/amlogic/mmc/aml_sdio.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/amlogic/mmc/aml_sdio.c b/drivers/amlogic/mmc/aml_sdio.c
> index 680b95a..8b42f0e 100755
> --- a/drivers/amlogic/mmc/aml_sdio.c
> +++ b/drivers/amlogic/mmc/aml_sdio.c
> @@ -1322,10 +1322,10 @@ static int aml_sdio_probe(struct platform_device *pdev)
>           mmc->alldev_claim =&aml_sdio_claim;
>           mmc->ios.clock = 400000;
>           mmc->ios.bus_width = MMC_BUS_WIDTH_1;
> -        mmc->max_blk_count = 4095;
> -        mmc->max_blk_size = 4095;
> +        mmc->max_blk_count = 256;
>           mmc->max_req_size = pdata->max_req_size;
>           mmc->max_seg_size = mmc->max_req_size;
> +        mmc->max_blk_size = mmc->max_req_size / mmc->max_blk_count;
>           mmc->max_segs = 1024;
>           mmc->ocr_avail = pdata->ocr_avail;
>           mmc->ocr = pdata->ocr_avail;

