Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43C3C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 16:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7911E207E0
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 16:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbfBAQeM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 11:34:12 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:32856 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727057AbfBAQeL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 11:34:11 -0500
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 24E9E7295E4DD4C1BD35;
        Fri,  1 Feb 2019 16:34:10 +0000 (GMT)
Received: from [127.0.0.1] (10.202.226.46) by lhreml709-cah.china.huawei.com
 (10.201.108.32) with Microsoft SMTP Server id 14.3.408.0; Fri, 1 Feb 2019
 16:34:07 +0000
Subject: Re: [PATCH v2] arm64: dts: hikey: Give wifi some time after power-on
To:     Jan Kiszka <jan.kiszka@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC:     Ryan Grachek <ryan@edited.us>,
        John Stultz <john.stultz@linaro.org>,
        <linux-wireless@vger.kernel.org>, "Reizer, Eyal" <eyalr@ti.com>,
        "Valentin Schneider" <valentin.schneider@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>
References: <e944650d-514f-3727-2e68-b318aab9ee7f@web.de>
From:   Wei Xu <xuwei5@hisilicon.com>
Message-ID: <14a011aa-862f-7132-8741-df5173875f34@hisilicon.com>
Date:   Fri, 1 Feb 2019 16:34:07 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <e944650d-514f-3727-2e68-b318aab9ee7f@web.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Jan,

On 1/24/2019 7:52 AM, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> Somewhere along recent changes to power control of the wl1835, power-on
> became very unreliable on the hikey, failing like this:
> 
> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> wl1271_sdio: probe of mmc2:0001:2 failed with error -16
> 
> After playing with some dt parameters and comparing to other users of
> this chip, it turned out we need some power-on delay to make things
> stable again. In contrast to those other users which define 200 ms, the
> hikey would already be happy with 1 ms. Still, we use the safer 10 ms,
> like on the Ultra96.
> 
> Fixes: ea452678734e ("arm64: dts: hikey: Fix WiFi support")
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Applied to the hisilicon soc dt tree.
Thanks!

Best Regards,
Wei

> ---
> 
> Changes in v2:
>  - set delay to 10 ms
>  - updated changelog
> 
> Who will take care of updating also the Hikey firmware dts with this
> change?
> 
>  arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> index 610235028cc7..ba946543dd0a 100644
> --- a/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> +++ b/arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts
> @@ -118,6 +118,7 @@
>  		reset-gpios = <&gpio0 5 GPIO_ACTIVE_LOW>;
>  		clocks = <&pmic>;
>  		clock-names = "ext_clock";
> +		post-power-on-delay-ms = <10>;
>  		power-off-delay-us = <10>;
>  	};
> 
> --
> 2.16.4
> 
> .
> 

