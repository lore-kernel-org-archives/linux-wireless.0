Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE17C7112A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 08:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FEB320644
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 08:53:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FEB320644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbeJOQiI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 12:38:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13636 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726273AbeJOQiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 12:38:08 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 79FA6F999506F;
        Mon, 15 Oct 2018 16:53:44 +0800 (CST)
Received: from [127.0.0.1] (10.202.226.41) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.399.0; Mon, 15 Oct 2018
 16:53:40 +0800
Subject: Re: [PATCH] bitfield: add constant field preparation macros
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
References: <20181012194556.31004-1-johannes@sipsolutions.net>
CC:     <linux-kernel@vger.kernel.org>, <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d250e401-e939-c521-8e66-d9f6648db986@huawei.com>
Date:   Mon, 15 Oct 2018 09:53:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <20181012194556.31004-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.41]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 12/10/2018 20:45, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> John Garry requested to be able to use FIELD_PREP() and friends
> in constant initializers, but we cannot completely switch all of
> the current assertions to BUILD_BUG_ON_ZERO().
>

Thanks for this.

> So instead of this, add __FIELD_PREP() which is suitable in such
> contexts, and also add __{u,le,be}{16,32,64}encode_bits() like
> the existing versions without underscores, but again suitable in
> constant contexts.
>
> Requested-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/linux/bitfield.h | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> index 3f1ef4450a7c..245dfb47d201 100644
> --- a/include/linux/bitfield.h
> +++ b/include/linux/bitfield.h
> @@ -63,6 +63,14 @@
>  					      (1ULL << __bf_shf(_mask))); \
>  	})
>
> +#define __BF_CHECK_POW2(n)	BUILD_BUG_ON_ZERO(((n) & ((n) - 1)) != 0)
> +
> +#define __BF_FIELD_CHECK_CONST(_mask, _reg, _val)			\
> +	(BUILD_BUG_ON_ZERO((_mask) == 0) +				\
> +	 BUILD_BUG_ON_ZERO(~((_mask) >> __bf_shf(_mask)) & (_val)) +	\
> +	 BUILD_BUG_ON_ZERO((_mask) > (typeof(_reg))~0ull) +		\
> +	 __BF_CHECK_POW2((_mask) + (1ULL << __bf_shf(_mask))))
> +
>  /**
>   * FIELD_FIT() - check if value fits in the field
>   * @_mask: shifted mask defining the field's length and position
> @@ -90,6 +98,21 @@
>  		((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);	\
>  	})
>
> +/**
> + * __FIELD_PREP() - prepare a constant bitfield element

My impression is that the name prefix - '__' - tells little about the 
function. If you agree, how about even CFIELD_PREP() or 
FIELD_PREP_CONST() or similar? I preper the latter, but becomes rather long.

> + * @_mask: shifted mask defining the field's length and position
> + * @_val:  value to put in the field
> + *
> + * __FIELD_PREP() masks and shifts up the value.  The result should
> + * be combined with other fields of the bitfield using local OR.

should this be 'logical OR', or indeed 'bitwise OR'?

> + *
> + * This version is suitable for use in a pure constant context, e.g.
> + * a constant initializer.
> + */
> +#define __FIELD_PREP(_mask, _val)					\
> +	((typeof(_mask))__BF_FIELD_CHECK_CONST(_mask, 0ULL, _val) +	\
> +	 (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask)))
> +
>  /**
>   * FIELD_GET() - extract a bitfield element
>   * @_mask: shifted mask defining the field's length and position
> @@ -150,4 +173,15 @@ __MAKE_OP(64)
>  #undef __MAKE_OP
>  #undef ____MAKE_OP
>
> +#define __encode_bits(w, v, field)	__FIELD_PREP((u##w)(field), v)
> +#define __u16_encode_bits(v, field)	__encode_bits(16, v, field)
> +#define __le16_encode_bits(v, field)	cpu_to_le16(__encode_bits(16, v, field))
> +#define __be16_encode_bits(v, field)	cpu_to_be16(__encode_bits(16, v, field))
> +#define __u32_encode_bits(v, field)	__encode_bits(32, v, field)
> +#define __le32_encode_bits(v, field)	cpu_to_le32(__encode_bits(32, v, field))
> +#define __be32_encode_bits(v, field)	cpu_to_be32(__encode_bits(32, v, field))
> +#define __u64_encode_bits(v, field)	__encode_bits(64, v, field)
> +#define __le64_encode_bits(v, field)	cpu_to_le64(__encode_bits(64, v, field))
> +#define __be64_encode_bits(v, field)	cpu_to_be64(__encode_bits(64, v, field))
> +
>  #endif
>

Thanks again,
John


