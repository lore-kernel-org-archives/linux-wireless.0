Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A9EC677FC
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 16:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B148D2085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 16:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B148D2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbeJKXox (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 19:44:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59768 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726700AbeJKXox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 19:44:53 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B381CEB5075A2;
        Fri, 12 Oct 2018 00:16:55 +0800 (CST)
Received: from [127.0.0.1] (10.202.226.41) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.399.0; Fri, 12 Oct 2018
 00:17:17 +0800
Subject: Re: Question on FIELD_PREP() for static array
To:     Johannes Berg <johannes@sipsolutions.net>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <jakub.kicinski@netronome.com>, <yamada.masahiro@socionext.com>,
        "Arnd Bergmann" <arnd@arndb.de>, <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <c8594a75-964b-01b0-382e-88bcb5b462f2@huawei.com>
 <40fd3d963820bf96547fa9b5e8c171c6a339674e.camel@perches.com>
 <1539195207.3687.178.camel@sipsolutions.net>
 <830ff9fb-07b1-86b6-4f57-af549a37a8c0@huawei.com>
 <1539271422.3687.217.camel@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>, <nbd@nbd.name>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ef2d37ab-bef4-fd3f-a6f7-e68e60695e9b@huawei.com>
Date:   Thu, 11 Oct 2018 17:16:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <1539271422.3687.217.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.41]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/10/2018 16:23, Johannes Berg wrote:

Hi

> On Thu, 2018-10-11 at 15:24 +0100, John Garry wrote:
>>
>>> +#define BUILD_BUG_ON_RET_ZERO(cond) (sizeof(char[1 - 2*!!(cond)]) - 1)
>>> +#define BUILD_BUG_ON_NOT_POW2_RET_ZERO(n)	BUILD_BUG_ON_RET_ZERO(((n) & ((n) - 1)) != 0)
>
>> Seems reasonable. However I did try this and was getting compiler
>> warnings about VLA, from a non-constant being fed into
>> BUILD_BUG_ON_RET_ZERO(), related to sizeof char[]:
>> drivers/iio/adc/meson_saradc.c:375:2: warning: ISO C90 forbids variable
>> length array [-Wvla]
>>    regval = FIELD_PREP(MESON_SAR_ADC_CHAN_LIST_ENTRY_MASK(0),
>
> Hmm, what's the code there?

Nothing special, it was just a sample. Here'e the code:
     regval = FIELD_PREP(MESON_SAR_ADC_CHAN_LIST_ENTRY_MASK(0),
                 chan->address);

So val is a variable, and I find if remove both of the 
BUILD_BUG_ON_RET_ZERO()' which use __bf_shf() then it goes away.

>
> I don't see why the compiler should think it's a variable length?
>
>> Surely __NLA_ENSURE is getting a similar issue as it uses a similar
>> principle, no? I see that this is in -next now, but could not this macro
>> or derivatives being referenced.
>
> Yeah, I have a patch now to reference it, but I don't see anything from
> -Wvla with gcc 8.1?

I'm using a 7.3.1-based toolchain

>
> See
> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/commit/?id=3d7af878357acd9e37fc156928106f1a969c8942
> and its parent.
>
> Do you see -Wvla warnings there? Any idea how I could reproduce them?

I'll try it, thanks

John

>
> johannes
>
> .
>


