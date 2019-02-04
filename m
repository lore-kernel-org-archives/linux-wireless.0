Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D4AC282CB
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 11:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34B5C20815
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 11:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbfBDLOK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 06:14:10 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:32862 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728605AbfBDLOH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 06:14:07 -0500
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 16F9EB29205BDD3E156C;
        Mon,  4 Feb 2019 11:14:06 +0000 (GMT)
Received: from [127.0.0.1] (10.202.226.46) by LHREML712-CAH.china.huawei.com
 (10.201.108.35) with Microsoft SMTP Server id 14.3.408.0; Mon, 4 Feb 2019
 11:14:04 +0000
Subject: Re: [PATCH v2] arm64: dts: hikey: Give wifi some time after power-on
To:     Ulf Hansson <ulf.hansson@linaro.org>
CC:     Jan Kiszka <jan.kiszka@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ryan Grachek <ryan@edited.us>,
        "John Stultz" <john.stultz@linaro.org>,
        <linux-wireless@vger.kernel.org>, "Reizer, Eyal" <eyalr@ti.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        "stable #4 . 17+" <stable@vger.kernel.org>
References: <e944650d-514f-3727-2e68-b318aab9ee7f@web.de>
 <14a011aa-862f-7132-8741-df5173875f34@hisilicon.com>
 <CAPDyKFqYWGv7bWW7rcCYhc-PdmRCBdskUTycFxK25VQgd0TWeg@mail.gmail.com>
From:   Wei Xu <xuwei5@hisilicon.com>
Message-ID: <6f4f342e-0b14-9344-c11b-e81f643cc45b@hisilicon.com>
Date:   Mon, 4 Feb 2019 11:13:59 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqYWGv7bWW7rcCYhc-PdmRCBdskUTycFxK25VQgd0TWeg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Ulf,

On 2/4/2019 6:06 AM, Ulf Hansson wrote:
> On Fri, 1 Feb 2019 at 17:34, Wei Xu <xuwei5@hisilicon.com> wrote:
>>
>> Hi Jan,
>>
>> On 1/24/2019 7:52 AM, Jan Kiszka wrote:
>>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>>
>>> Somewhere along recent changes to power control of the wl1835, power-on
>>> became very unreliable on the hikey, failing like this:
>>>
>>> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
>>> wl1271_sdio: probe of mmc2:0001:2 failed with error -16
>>>
>>> After playing with some dt parameters and comparing to other users of
>>> this chip, it turned out we need some power-on delay to make things
>>> stable again. In contrast to those other users which define 200 ms, the
>>> hikey would already be happy with 1 ms. Still, we use the safer 10 ms,
>>> like on the Ultra96.
>>>
>>> Fixes: ea452678734e ("arm64: dts: hikey: Fix WiFi support")
>>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>>> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>>
>> Applied to the hisilicon soc dt tree.
> 
> Wei, can you please also add a stable tag to it?

Yes, added below tag into this patch.
	Cc: <stable@vger.kernel.org> #4.12+

Thanks for your kindly reminder :)

Best Regards,
Wei

> 
> [...]
> 
> Thanks and kind regards
> Uffe
> 
> .
> 

