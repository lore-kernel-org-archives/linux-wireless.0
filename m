Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7097CC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 15:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38DD82151D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 15:24:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38DD82151D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbeJKWvs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:51:48 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34650 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbeJKWvs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 18:51:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAcof-0005ue-G2; Thu, 11 Oct 2018 17:23:57 +0200
Message-ID: <1539271422.3687.217.camel@sipsolutions.net>
Subject: Re: Question on FIELD_PREP() for static array
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Garry <john.garry@huawei.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        jakub.kicinski@netronome.com, yamada.masahiro@socionext.com,
        Arnd Bergmann <arnd@arndb.de>, viro@zeniv.linux.org.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name
Date:   Thu, 11 Oct 2018 17:23:42 +0200
In-Reply-To: <830ff9fb-07b1-86b6-4f57-af549a37a8c0@huawei.com>
References: <c8594a75-964b-01b0-382e-88bcb5b462f2@huawei.com>
         <40fd3d963820bf96547fa9b5e8c171c6a339674e.camel@perches.com>
         <1539195207.3687.178.camel@sipsolutions.net>
         <830ff9fb-07b1-86b6-4f57-af549a37a8c0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-10-11 at 15:24 +0100, John Garry wrote:
> 
> > +#define BUILD_BUG_ON_RET_ZERO(cond) (sizeof(char[1 - 2*!!(cond)]) - 1)
> > +#define BUILD_BUG_ON_NOT_POW2_RET_ZERO(n)	BUILD_BUG_ON_RET_ZERO(((n) & ((n) - 1)) != 0)

> Seems reasonable. However I did try this and was getting compiler 
> warnings about VLA, from a non-constant being fed into 
> BUILD_BUG_ON_RET_ZERO(), related to sizeof char[]:
> drivers/iio/adc/meson_saradc.c:375:2: warning: ISO C90 forbids variable 
> length array [-Wvla]
>    regval = FIELD_PREP(MESON_SAR_ADC_CHAN_LIST_ENTRY_MASK(0),

Hmm, what's the code there?

I don't see why the compiler should think it's a variable length?

> Surely __NLA_ENSURE is getting a similar issue as it uses a similar 
> principle, no? I see that this is in -next now, but could not this macro 
> or derivatives being referenced.

Yeah, I have a patch now to reference it, but I don't see anything from
-Wvla with gcc 8.1?

See
https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/commit/?id=3d7af878357acd9e37fc156928106f1a969c8942
and its parent.

Do you see -Wvla warnings there? Any idea how I could reproduce them?

johannes
