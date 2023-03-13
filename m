Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514E6C6FD1C
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Mar 2023 21:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCMVmf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Mar 2023 17:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCMVme (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Mar 2023 17:42:34 -0400
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5813C8ABF4;
        Mon, 13 Mar 2023 14:42:32 -0700 (PDT)
Received: from [IPV6:2a02:8428:2a4:1a01:c8ce:acb0:d46a:bb07] (unknown [IPv6:2a02:8428:2a4:1a01:c8ce:acb0:d46a:bb07])
        (Authenticated sender: marc.w.gonzalez@free.fr)
        by smtp1-g21.free.fr (Postfix) with ESMTPSA id 94AD1B0051E;
        Mon, 13 Mar 2023 22:42:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1678743750;
        bh=VEU8HwgWPW9ROwRnS41wvdPNcD7KmargOkeucWFLS4U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ibV+m8YZmaQxJ2zXcwxwmRV5EzUD98UltT/YLQ2Smu+/welo9rIawRdQ+7jrx68ZQ
         E/smTuaMFRSOX9X5JNao+IiVwFbi2cuPl+Uuhw5qCTjXXeOqMgJPZj7BHWLqVZ0bwG
         /oI6MeCSsRBYy/Olkw0W3jtvHFLg4ld5RwGbY1I8x1WSbAkkPFzyjieM/tBss1p9To
         0OmWMSY3/KUyVqt0WZV7+H+GZc9wfZlBWuB4sOnAJxKZY7i7VXYYUc2BpmRKmt2N1L
         YNfP42xtwdhZ3aEHU2P8BlQ2j7bS8WcU0rCLRv+FMbdlLPQ4iUzJOP+I6FBkPtDhrI
         AAMECuMBLMmPg==
Message-ID: <6ac1ecb1-eba4-b0a3-579c-afcbe532a474@free.fr>
Date:   Mon, 13 Mar 2023 22:42:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH] brcmfmac: add 43751 SDIO ids and initialization
Content-Language: fr, en-US
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Alexander Prutskov <alep@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Angus Ainslie <angus@akkea.ca>,
        Pierre-Hugues Husson <phh@phh.me>,
        linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-amlogic@lists.infradead.org
References: <05977cbb-8a8f-0a67-b4bd-b265dbb83280@free.fr>
 <895a3812-e490-cc40-0f8e-a88e166e8f24@linaro.org>
 <c1a215cf-94be-871b-2a8a-3cc381588f83@free.fr>
 <13676dcc-944f-cf3d-8adf-ee3d4e8fa699@free.fr>
 <e5baf73b-3b9d-1011-2ed9-4b6fc7ee644f@free.fr>
 <CAPDyKFoAT-jMkYb7=m--q_eEb2xxH-VPQy5vaHNvw4s=WiAeCg@mail.gmail.com>
 <0450e34e-7190-104c-832a-150f15f7c825@free.fr>
 <3d91a067-c9c3-6d71-11a7-1289ea67f109@free.fr>
 <eecb86be-81e3-09cd-8ec7-4e77c42f2795@free.fr>
 <CAFBinCDHRhLSyFsEv7cdhSgZorj-TdR3HhqSBnAQcUtEsecV=Q@mail.gmail.com>
From:   Marc Gonzalez <marc.w.gonzalez@free.fr>
In-Reply-To: <CAFBinCDHRhLSyFsEv7cdhSgZorj-TdR3HhqSBnAQcUtEsecV=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 13/03/2023 21:04, Martin Blumenstingl wrote:

> On Mon, Mar 13, 2023 at 6:09 PM Marc Gonzalez wrote:
> [...]
>> QUESTION:
>> It's not clear to me why we sleep twice for host->ios.power_delay_ms?
>
> I'm not sure but I think host->ios.power_delay_ms is independent from
> the post-power-on-delay-ms property of "mmc-pwrseq-simple".

They are distinct indeed (the props have the same name & similar purpose though).

host->ios.power_delay_ms is set via:

drivers/mmc/core/host.c:        device_property_read_u32(dev, "post-power-on-delay-ms",
drivers/mmc/core/host.c-                                 &host->ios.power_delay_ms);


pwrseq->post_power_on_delay_ms is set via:

drivers/mmc/core/pwrseq_simple.c:       device_property_read_u32(dev, "post-power-on-delay-ms",
drivers/mmc/core/pwrseq_simple.c-                                &pwrseq->post_power_on_delay_ms);


However, they are both used to delay mmc_power_up(),
and the host delay is used to sleep twice, which I
found confusing ;)

Regards

