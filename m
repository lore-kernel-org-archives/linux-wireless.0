Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FB5C4161D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 14:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 464A620652
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 14:25:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 464A620652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbeJKVw1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 17:52:27 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13622 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbeJKVw1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 17:52:27 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E9F406B25A1EC;
        Thu, 11 Oct 2018 22:24:54 +0800 (CST)
Received: from [127.0.0.1] (10.202.226.41) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.399.0; Thu, 11 Oct 2018
 22:24:55 +0800
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
CC:     <linux-wireless@vger.kernel.org>, <nbd@nbd.name>
From:   John Garry <john.garry@huawei.com>
Message-ID: <830ff9fb-07b1-86b6-4f57-af549a37a8c0@huawei.com>
Date:   Thu, 11 Oct 2018 15:24:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <1539195207.3687.178.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.41]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/10/2018 19:13, Johannes Berg wrote:
> On Wed, 2018-10-10 at 10:33 -0700, Joe Perches wrote:
>>
>>> Specifically it doesn't like the __BF_FIELD_CHECK() in FIELD_PREP().
>>>
>>> Any ideas on compiler trickery we could do with the FIELD_PREP()
>>> definition to avoid this issue (i.e. enforce the check but only use the
>>> constant value)?
>>

thanks guys

>> Perhaps __bf_shf should not use __builtin_ffsll.
>
> __bf_shf() is a constant expression, and is fine in this context.
>
> The problem is the use of the compound statement here:
>
> static int x[2] = {
> 	({ (void)(0); 1; }),
> 	0,
> }
>
> similarly fails to compile.
>
> I've recently run into a similar situation, namely in
> include/net/netlink.h, and the applicable way to solve it here would be
> something like this:
>
> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> index 3f1ef4450a7c..0680d641923f 100644
> --- a/include/linux/bitfield.h
> +++ b/include/linux/bitfield.h
> @@ -49,19 +49,16 @@
>
>  #define __bf_shf(x) (__builtin_ffsll(x) - 1)
>
> +#define BUILD_BUG_ON_RET_ZERO(cond) (sizeof(char[1 - 2*!!(cond)]) - 1)
> +#define BUILD_BUG_ON_NOT_POW2_RET_ZERO(n)	BUILD_BUG_ON_RET_ZERO(((n) & ((n) - 1)) != 0)
> +

>  #define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)			\
> -	({								\
> -		BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),		\
> -				 _pfx "mask is not constant");		\
> -		BUILD_BUG_ON_MSG((_mask) == 0, _pfx "mask is zero");	\
> -		BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
> -				 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
> -				 _pfx "value too large for the field"); \
> -		BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,		\
> -				 _pfx "type of reg too small for mask"); \
> -		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
> -					      (1ULL << __bf_shf(_mask))); \
> -	})
> +	BUILD_BUG_ON_RET_ZERO(!__builtin_constant_p(_mask)) +		\
> +	BUILD_BUG_ON_RET_ZERO((_mask) == 0) +				\
> +	BUILD_BUG_ON_RET_ZERO(__builtin_constant_p(_val) ?		\
> +			      ~((_mask) >> __bf_shf(_mask)) & (_val) : 0) + \
> +	BUILD_BUG_ON_RET_ZERO((_mask) > (typeof(_reg))~0ull) +	\
> +	BUILD_BUG_ON_NOT_POW2_RET_ZERO((_mask) + (1ULL << __bf_shf(_mask)))
>
>  /**
>   * FIELD_FIT() - check if value fits in the field
> @@ -85,10 +82,8 @@
>   * be combined with other fields of the bitfield using logical OR.
>   */
>  #define FIELD_PREP(_mask, _val)						\
> -	({								\
> -		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");	\
> -		((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);	\
> -	})
> +	(__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ") +		\
> +	 (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask)))
>
>  /**
>   * FIELD_GET() - extract a bitfield element
>
>
> Note that this is an incomplete patch - everything but FIELD_PREP will
> not compile with this.
>
> Also, BUILD_BUG_ON_RET_ZERO and BUILD_BUG_ON_NOT_POW2_RET_ZERO should
> probably have better names, or perhaps do the positive way that I did in
> __NLA_ENSURE, e.g. CONST_ASSERT()/CONST_ASSERT_IS_POWER_OF_2()? I guess
> they should go to build_bug.h as well...

Seems reasonable. However I did try this and was getting compiler 
warnings about VLA, from a non-constant being fed into 
BUILD_BUG_ON_RET_ZERO(), related to sizeof char[]:
drivers/iio/adc/meson_saradc.c:375:2: warning: ISO C90 forbids variable 
length array [-Wvla]
   regval = FIELD_PREP(MESON_SAR_ADC_CHAN_LIST_ENTRY_MASK(0),

Surely __NLA_ENSURE is getting a similar issue as it uses a similar 
principle, no? I see that this is in -next now, but could not this macro 
or derivatives being referenced.

>

Much appreciated,
John

> johannes
>
> .
>


