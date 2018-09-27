Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67308C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01DEA2156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01DEA2156B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbeI0O3Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 10:29:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52610 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbeI0O3Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 10:29:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5RPJ-0007WD-Pj; Thu, 27 Sep 2018 10:12:22 +0200
Message-ID: <1538035929.14416.21.camel@sipsolutions.net>
Subject: Re: [PATCH] netlink: add policy attribute range validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 27 Sep 2018 10:12:09 +0200
In-Reply-To: <20180927071621.GF30601@unicorn.suse.cz>
References: <20180926200630.23399-1-johannes@sipsolutions.net>
         <1537993066.28767.29.camel@sipsolutions.net>
         <1537994127.28767.39.camel@sipsolutions.net>
         <20180927071621.GF30601@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-09-27 at 09:16 +0200, Michal Kubecek wrote:

> The overloading still feels a bit complicated. Perhaps we could rather
> use validation_data in the natural way, i.e. as a pointer to validation
> data. That would be a struct (maybe array) of two values of the
> corresponding type. It would mean a bit more data and a bit more writing
> but it would be IMHO more straightforward.

I considered that, but I didn't really like it either. The memory
wasting isn't *that* bad (even if we go to s64 that'd only be ~20x16
bytes for nl80211, eating up 320 out of the 550 saved, but still); I'm
more worried about making this really hard to actually *do*.

Consider

policy[] = {
	...
	[NL80211_ATTR_WIPHY_RETRY_SHORT] =
		NLA_POLICY_RANGE(NLA_U8, 1, 255),
	...
};

vs.

static const struct netlink_policy_range retry_range = {
	.min = 1,
	.max = 255,
};

policy[] = {
	...
	[NL80211_ATTR_WIPHY_RETRY_SHORT] = {
		.type = NLA_U8,
		.validation_data = &retry_range,
	},
	...
};


That's significantly more to type, to the point where I'd seriously
consider doing this only for attributes that are used and checked in
many places - it doesn't feel like a big win over manual range-checking.

But I want it to be a win over manual range-checking so it gets used
more because it's more efficient, less prone to getting messed up if
multiple places use the same attribute and validates attributes even if
they're ignored by an operation.


I'd also say that we're certainly no strangers to union/overloading, so
I don't feel like this is a big argument. One doesn't even really have
to be *aware* of it for the most part: if it were a struct instead of a
union, it'd actually have the same effect since the .type field
indicates which part gets used. That it's overloaded in a union is
basically just a space saving measure, I don't think it makes the
reasoning much more complex?


That said, given that I also later sent that RFC patch for a further
validation function pointer (which is useful e.g. for ensuring certain
binary attributes are well-formed), I think it might in fact be better
to split .type field (it really only needs to be u8, we have ~20) and
adding a "validation" enum to the policy:

enum netlink_policy_validation {
	/* default */
	NLA_VALIDATE_NONE,

	/* valid for NLA_{U,S}{8,16,32,64} */
	NLA_VALIDATE_MIN,
	NLA_VALIDATE_MAX,
	NLA_VALIDATE_RANGE,

	/* valid for any type other than NLA_BITFIELD32/NLA_REJECT */
	NLA_VALIDATE_FUNCTION,
};

Combining that with macros like the ones I wrote in my previous message
in this thread:

#define __NLA_ENSURE(condition) (sizeof(char[1 - 2*!(condition)]) - 1)
#define NLA_ENSURE_INT_TYPE(tp)                         \
        (__NLA_ENSURE(tp == NLA_S8 || tp == NLA_U8 ||   \
                      tp == NLA_S16 || tp == NLA_U16 || \
                      tp == NLA_S32 || tp == NLA_U32 || \
                      tp == NLA_S64 || tp == NLA_U64) + tp)
#define NLA_ENSURE_NO_VALIDATION_PTR(tp)                \
        (__NLA_ENSURE(tp != NLA_BITFIELD32 &&           \
                      tp != NLA_REJECT &&               \
                      tp != NLA_NESTED &&               \
                      tp != NLA_NESTED_ARRAY) + tp)

#define NLA_POLICY_RANGE(tp, _min, _max) {
        .type = NLA_ENSURE_INT_TYPE(tp),
	.validate_type = NLA_VALIDATE_RANGE,
        .min = _min,
        .max = _max,
}

#define NLA_POLICY_MIN(tp, _min) {
        .type = NLA_ENSURE_INT_TYPE(tp),
	.validate_type = NLA_VALIDATE_MIN,
        .min = _min,
}

#define NLA_POLICY_MAX(tp, _max) {
        .type = NLA_ENSURE_INT_TYPE(tp),
	.validate_type = NLA_VALIDATE_MAX,
        .max = _max,
}

#define NLA_POLICY_FN(tp, fn) {
	.type = NLA_ENSURE_NO_VALIDATION_PTR(tp),
	.validate_type = NLA_VALIDATE_FUNCTION,
	.validate = fn,
}

This would even give us the flexibility to extend the validation type
further in the future, to actually have what you suggested where the
validation_data is a pointer and the valid range is given in a struct
pointed to, to allow larger ranges than s16.

johannes
