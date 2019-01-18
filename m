Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E56C43444
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 12:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D36A2087E
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 12:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="ZKMaZATa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfARMKA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 07:10:00 -0500
Received: from mout.web.de ([217.72.192.78]:58267 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbfARMJ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 07:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1547813385;
        bh=hYdR8FAJ1NHqGK5owU2EpK5hesFmYLute4uNAAUcz6Y=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ZKMaZATayfFSfHb0LgVB462bb4YwvTqg/uOMBOYNPJ0iNyJ1ua0XYn+8btm+3Q+Pi
         OuUlJJKRhkegIiiG7Byfb1ifejdCOBYMv45xadB/D4eAhJlzk2oG7yRK33wkm+Uggc
         rVg8qGJxTtCov2ga4F8bD+SdQL/OG0/bH3GALrRI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.0.24] ([83.215.108.61]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M7bYJ-1h7ees1QQh-00xJnW; Fri, 18
 Jan 2019 13:09:45 +0100
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
References: <20190116113723.15668-1-ulf.hansson@linaro.org>
 <258ecb6b-c2b2-c8b8-9804-4df69002d9f5@web.de>
 <CAPDyKFoqfyvQRnSBRvPVxrL-nmf1YoSzxRkPfGwr==L3LOwgaw@mail.gmail.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <5bf8514a-eb15-b098-1857-835b36d4a67c@web.de>
Date:   Fri, 18 Jan 2019 13:09:42 +0100
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <CAPDyKFoqfyvQRnSBRvPVxrL-nmf1YoSzxRkPfGwr==L3LOwgaw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------30E45D5AA4F2B8882B732D8E"
Content-Language: en-US
X-Provags-ID: V03:K1:ycdTmgr9kFaY1vwRFHglKmMPAVDYzjN1gQrxvP+u+2NLCTELEL/
 VWp4MFB4cyte15LXeXM7/Fjr0fMGzhwJwUwopvaMieXE4ggaRKvbM/71/Mrf9QtDhn4nCO3
 s2006wYutNQdTJVo/EQlXV1yZwQXkthvTpsjx4/guhRFC32fnbAUvRZTVzmNpZpLu/11Hsh
 aQksPQC4eknateiMhvNAQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BFrB2QH3N/8=:SqjQsn2RSNRmAxEOQLFXmh
 M4hGSpBXwP9zXhNT8LsldY0PQVA63Ex4BoOAKMboPUoRQC5qOAVElMpXv7ab4Bdv89VgImagb
 eXCEhSUVZMr4cWUt/WgKvGl1V3XYvQkUbE2DBPBVYh7Cy4mWVZ3P0QsZZH/CgDNS+w+2POANd
 50mtRxqjNJa08/wjJKWkVD3LfOebY7I8NfBqRXqEPeMcyoiGVSz9NsGBKW9Iuv833E7kTbxM0
 5pR7TxcLQbPjGKcXp92p8c6vMSHPS6s6jBZT533SB0WPd+UgqYBxgQN9r3cCk9TVFmaZaU5bY
 HdMqiTEz+1ADs0kUoNoTRazcRBENJnz5HMZpaAMGoXlqsisLreysuWhabmwDr4dxy7uOKQFib
 nf35Qmjp5S6+/vMNWpgsO+FIq6l7hLICmC8jS7cvxkwFlw+xBTfwgg9oqQSJM91NqLX7YGh02
 DIdWSTUqfzqaL2DM8h5VPYeLJMtUB4xRrnw1Euwj5MxE+0Q6wW+7WZEd9SkJr2jDvYbn/vH8W
 CS82yyuSMzHGTVkstc+4+4uy16bFQvRTujWrOvBBWbRWAQhODgZLbRaLSmBxC963pmcWo20mU
 KEb9gYpY6GX91GbCp9JuK9DpQfLHPg/ifQC/e3e9iAUhoOqaMGjehIh/2HwjdOcet2iyi7xzk
 MNai9IkI2Ws4cjbxHcmR7LuOhON10HbT7HE0EHixd2zC+QFTKtcT2ScPW8TancxUahSb2MQVQ
 kD2ln4rWZ9MdAfyxoG1/1BfldqAT4axLXN7GIYYKLpi2RQLLj2XY6WuhA0c1jAWVTh666FcE3
 RX5DCHcWD/aw0BHD5KCTpjhE6OE/xjB/psWmx8VMcTHsA/SVlS4KZvikoJlxbgpicKtXf8f8H
 XLtx3hUoFHx4DYzPO2R3/efvYzKtsck4TPoSqwnVvcAZP9EsEaOf48M0qsZdJ7
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a multi-part message in MIME format.
--------------30E45D5AA4F2B8882B732D8E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 17.01.19 10:54, Ulf Hansson wrote:
> On Wed, 16 Jan 2019 at 21:26, Jan Kiszka <jan.kiszka@web.de> wrote:
>>
>> On 16.01.19 12:37, Ulf Hansson wrote:
>>> During "wlan-up", we are programming the FW into the WiFi-chip. Howeve=
r,
>>> re-programming the FW doesn't work, unless a power cycle of the WiFi-c=
hip
>>> is made in-between the programmings.
>>>
>>> To conform to this requirement and to fix the regression in a simple w=
ay,
>>> let's start by allowing that the SDIO card (WiFi-chip) may stay powere=
d on
>>> (runtime resumed) when wl12xx_sdio_power_off() returns. The intent wit=
h the
>>> current code is to treat this scenario as an error, but unfortunate th=
is
>>> doesn't work as expected, so let's fix this.
>>>
>>> The other part is to guarantee that a power cycle of the SDIO card has=
 been
>>> completed when wl12xx_sdio_power_on() returns, as to allow the FW
>>> programming to succeed. However, relying solely on runtime PM to deal =
with
>>> this isn't sufficient. For example, userspace may prevent runtime susp=
end
>>> via sysfs for the device that represents the SDIO card, leading to tha=
t the
>>> mmc core also keeps it powered on. For this reason, let's instead do a
>>> brute force power cycle in wl12xx_sdio_power_on().
>>>
>>> Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handlin=
g")
>>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>>> ---
>>>
>>> Changes in v2:
>>>        - Keep the SDIO host claimed when calling mmc_hw_reset().
>>>        - Add a fixes tag.
>>> ---
>>>    drivers/net/wireless/ti/wlcore/sdio.c | 15 +++++++--------
>>>    1 file changed, 7 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wirel=
ess/ti/wlcore/sdio.c
>>> index bd10165d7eec..4d4b07701149 100644
>>> --- a/drivers/net/wireless/ti/wlcore/sdio.c
>>> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
>>> @@ -164,6 +164,12 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdi=
o_glue *glue)
>>>        }
>>>
>>>        sdio_claim_host(func);
>>> +     /*
>>> +      * To guarantee that the SDIO card is power cycled, as required =
to make
>>> +      * the FW programming to succeed, let's do a brute force HW rese=
t.
>>> +      */
>>> +     mmc_hw_reset(card->host);
>>> +
>>>        sdio_enable_func(func);
>>>        sdio_release_host(func);
>>>
>>> @@ -174,20 +180,13 @@ static int wl12xx_sdio_power_off(struct wl12xx_s=
dio_glue *glue)
>>>    {
>>>        struct sdio_func *func =3D dev_to_sdio_func(glue->dev);
>>>        struct mmc_card *card =3D func->card;
>>> -     int error;
>>>
>>>        sdio_claim_host(func);
>>>        sdio_disable_func(func);
>>>        sdio_release_host(func);
>>>
>>>        /* Let runtime PM know the card is powered off */
>>> -     error =3D pm_runtime_put(&card->dev);
>>> -     if (error < 0 && error !=3D -EBUSY) {
>>> -             dev_err(&card->dev, "%s failed: %i\n", __func__, error);
>>> -
>>> -             return error;
>>> -     }
>>> -
>>> +     pm_runtime_put(&card->dev);
>>>        return 0;
>>>    }
>>>
>>>
>>
>> Just tested on both HiKey (620) and Ultra96 but it fails to fix the iss=
ue on
>> both. I'm getting
>>
>> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
>>
>> during boot again, and the interface is not available.
>
> Okay, sounds like this may be a different problem then. Can you share
> the complete log and the kernel config?

You can find the config here [1], log from the HiKey boot attached.

> I can prepare a debug patch as well, if you are willing to re-run the te=
st?

Sure, send it over, I can run it.

>
> Adding a post-power-on-delay-ms of 1 ms as you suggested [1], doesn't
> sounds like the correct solution to me, unless I am overlooking some
> things. The point is, since the mmc core succeeds to detect and
> initialize the SDIO card, the power sequence seems to be correct.

Yeah, I'm not claiming at all I know what I'm doing there, just that it ha=
ppens
to work.

Jan

[1]
https://github.com/siemens/jailhouse-images/blob/next/recipes-kernel/linux=
/files/arm64_defconfig_4.19

--------------30E45D5AA4F2B8882B732D8E
Content-Type: application/x-xz;
 name="hikey640.log.xz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="hikey640.log.xz"

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

--------------30E45D5AA4F2B8882B732D8E--
