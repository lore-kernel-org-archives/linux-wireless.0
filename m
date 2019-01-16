Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFE0C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 20:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CE6620840
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 20:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="Usit9sEY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732541AbfAPU0M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 15:26:12 -0500
Received: from mout.web.de ([217.72.192.78]:55649 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731741AbfAPU0M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 15:26:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1547670365;
        bh=tUxduNu2TvteLg8eXOnadxdcWVrfypdoGQzRYSBQ9eI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Usit9sEYWELIU8pRW6NkCIOkq1218c61LbIDI34LPxIeF6TXrUz4mA582sRI3dXsA
         TLVq12nerOcj6OFwdc1x0YY01invfVkrbSM/IiEqEFYuAoIJpxBt5eXSLlA2CY9el/
         a52DVgk3G7Kygl/iEMbcUF4nGyxA+lKfCUjJMd2E=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.57.47]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MD87M-1gTOgy3Vmu-00Ga7o; Wed, 16
 Jan 2019 21:26:04 +0100
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org
Cc:     Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <20190116113723.15668-1-ulf.hansson@linaro.org>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <258ecb6b-c2b2-c8b8-9804-4df69002d9f5@web.de>
Date:   Wed, 16 Jan 2019 21:26:02 +0100
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <20190116113723.15668-1-ulf.hansson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LPRScK4fBJSOzSfF0RqYFID+4EGpqFlfyJj+/44Wp5ZLwVVZ2Hq
 eJZ+fhFB7XOy+DYYxFT8O/HvgqKoFIHWWmpDMPuHgdtbJqLy1FlZD3macGy/4y1N816vBtj
 REdzFf8XETkQZBZ5C469Hp90EgM5WEAqMIWAwWl9egjWxPgpl78d/I/l3C8upo/hm4jjPD+
 zpIaghdmbCD3Qjlx6OLIA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:rkie1JSVNX4=:jDqkJvqbiJr0krqS9XzTMO
 9w9lnw3qAD9ebThlWFf9hRXHRGD9qJCH4mnUMrDhnGVoYfAz+in4gDtHfGMX9JzDycUKnQtvb
 swWAu7GtQh9XGBMql9LHPOxaFBwRZCtV1jOacp9VvzJM9eYx/EcTbPMz+qTpKe8kgt1KXFVvp
 qGFMlW9wDdLDHBV8BsAgJrdq9/92DgfqHax62o+dWbNvNBgq9PHQ5fefxvPIBWkUkVbNqDgk0
 C6ywVBZvobgNlraK0UVfUDqu7gkK8qc4IYCqYbnxfZlew4KOPCTJSKpkBFMTTW2TG8LeJDc48
 xpUysEQq8VghxZR+RQcUQENUlD3/6jr17iTAN6JOhUYk5jKMAXsfMylymD4ZdKQr0ERxEtULK
 AUfL4OTxDyQTtrNidUgSROAhGN6UfPWyQgYcGRm1CipjoJgHLylpferC/klfgZY07alBH6/Co
 q5vQOHOHWyMhixjhQOfGQSYJicizM3ImzKg39JRgc5J26cvlnfy2Vfp/qAn/Xcr/h4Xpf1eBo
 8FTUBFs30Y/7d8jclYGCp56dk9wqWuS5NPr1f6ovceqANjvZuI7hXv9YNBH2Zv9zk7Nx2thCG
 EK99RQDDzRrSL6zlfETbtNgGhFOEVpoGBFWPU1dzvxUtKNxqrYTa9RcwzG0fPDlziyd/fuWH1
 lnUCCAxYzwtoHZq6kKUExTV8C28YAYr+LK8Exk3ClcRZ+x3IWJqJQv58LrxBSBbxIaxW5Bxfv
 smPIkrGxzGZ9wctqPQcLZG88Wb8uLJIY+H2OL8skgIvicRU1iqlMfjCVXyHlqnaCUpl4ijEqD
 M0RwIsKzk3ATwn3UEaYYgvau2WC2V+g+AuWp8/tWXtNxJmbBJ47uRD3vivVCo77gJTH1vc+kv
 0f/Z7CPDht5QO3phIFQ++py0wm2/5n/w8Oxm64/I1MZsatVa0ehiAWJPQJth0CYpavIaYVRec
 rD2RhswxC3w==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 16.01.19 12:37, Ulf Hansson wrote:
> During "wlan-up", we are programming the FW into the WiFi-chip. However,
> re-programming the FW doesn't work, unless a power cycle of the WiFi-chi=
p
> is made in-between the programmings.
>
> To conform to this requirement and to fix the regression in a simple way=
,
> let's start by allowing that the SDIO card (WiFi-chip) may stay powered =
on
> (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with =
the
> current code is to treat this scenario as an error, but unfortunate this
> doesn't work as expected, so let's fix this.
>
> The other part is to guarantee that a power cycle of the SDIO card has b=
een
> completed when wl12xx_sdio_power_on() returns, as to allow the FW
> programming to succeed. However, relying solely on runtime PM to deal wi=
th
> this isn't sufficient. For example, userspace may prevent runtime suspen=
d
> via sysfs for the device that represents the SDIO card, leading to that =
the
> mmc core also keeps it powered on. For this reason, let's instead do a
> brute force power cycle in wl12xx_sdio_power_on().
>
> Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling"=
)
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>
> Changes in v2:
> 	- Keep the SDIO host claimed when calling mmc_hw_reset().
> 	- Add a fixes tag.
> ---
>   drivers/net/wireless/ti/wlcore/sdio.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireles=
s/ti/wlcore/sdio.c
> index bd10165d7eec..4d4b07701149 100644
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> @@ -164,6 +164,12 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_=
glue *glue)
>   	}
>
>   	sdio_claim_host(func);
> +	/*
> +	 * To guarantee that the SDIO card is power cycled, as required to mak=
e
> +	 * the FW programming to succeed, let's do a brute force HW reset.
> +	 */
> +	mmc_hw_reset(card->host);
> +
>   	sdio_enable_func(func);
>   	sdio_release_host(func);
>
> @@ -174,20 +180,13 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdi=
o_glue *glue)
>   {
>   	struct sdio_func *func =3D dev_to_sdio_func(glue->dev);
>   	struct mmc_card *card =3D func->card;
> -	int error;
>
>   	sdio_claim_host(func);
>   	sdio_disable_func(func);
>   	sdio_release_host(func);
>
>   	/* Let runtime PM know the card is powered off */
> -	error =3D pm_runtime_put(&card->dev);
> -	if (error < 0 && error !=3D -EBUSY) {
> -		dev_err(&card->dev, "%s failed: %i\n", __func__, error);
> -
> -		return error;
> -	}
> -
> +	pm_runtime_put(&card->dev);
>   	return 0;
>   }
>
>

Just tested on both HiKey (620) and Ultra96 but it fails to fix the issue =
on
both. I'm getting

wl1271_sdio: probe of mmc2:0001:1 failed with error -16

during boot again, and the interface is not available.

Jan
