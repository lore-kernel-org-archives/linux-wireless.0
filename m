Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA79FC71122
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 19:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F05120865
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 19:45:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F05120865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbeJMDTV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:19:21 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53898 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeJMDTV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 23:19:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gB3N5-0001Ca-S2; Fri, 12 Oct 2018 21:45:16 +0200
Message-ID: <18f6349cacfb6dc6fe8f1d12685ff6368c1cfbe0.camel@sipsolutions.net>
Subject: Re: [PATCH] bitfield: use BUILD_BUG_ON_ZERO()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>,
        nbd@nbd.name
Date:   Fri, 12 Oct 2018 21:45:03 +0200
In-Reply-To: <20181012092104.2361-1-johannes@sipsolutions.net> (sfid-20181012_112145_400521_10F221F7)
References: <20181012092104.2361-1-johannes@sipsolutions.net>
         (sfid-20181012_112145_400521_10F221F7)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Umm, I really should've tested this :-)

As John points out, it can't possibly compile, e.g. because

> +#define __BF_FIELD_CHECK(_mask, _reg, _val)				\
> +	BUILD_BUG_ON_ZERO(!__builtin_constant_p(_mask)) +		\

this isn't actually a constant expression.

This would be harmless, since e.g.

> +	BUILD_BUG_ON_ZERO((_mask) == 0) +				\

this already forces _mask to be a constant, but

> +	BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?			\
> +				~((_mask) >> __bf_shf(_mask)) & (_val) : 0) + \

we can't actually replicate this check.

We could just remove this as well, at the expense of not getting any
warnings if you write something like

	FIELD_PREP(0xf, 32);

Realistically, FIELD_PREP() is the only one that makes sense in a pure
constant context though, so we could just add __FIELD_PREP for that,
*with* all the checks. I'll send out a patch in a second that has this
and also adds __{u,le,be}{16,32,64}encode_bits().

johannes

