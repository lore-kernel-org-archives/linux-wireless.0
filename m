Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90437C4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 09:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 626F52089F
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 09:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfBTJkB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 04:40:01 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34398 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727021AbfBTJkB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 04:40:01 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwOM7-0003vV-Lh; Wed, 20 Feb 2019 11:39:56 +0200
Message-ID: <cd93696bcca66944ec2d472758d86e8f7c6e81de.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date:   Wed, 20 Feb 2019 11:39:54 +0200
In-Reply-To: <CAKwvOdmFE0kQoxvRDcarT+kYLXxqKYJfVHo4uTiYm7-wDefrrw@mail.gmail.com>
References: <20190219182105.19933-1-natechancellor@gmail.com>
         <CAKwvOdmFE0kQoxvRDcarT+kYLXxqKYJfVHo4uTiYm7-wDefrrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: mvm: Use div64_s64 instead of do_div in
 iwl_mvm_debug_range_resp
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-02-19 at 11:05 -0800, Nick Desaulniers wrote:
> On Tue, Feb 19, 2019 at 10:21 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> > Clang warns:
> > 
> > drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:465:2:
> > warning:
> > comparison of distinct pointer types ('typeof ((rtt_avg)) *' (aka
> > 'long
> > long *') and 'uint64_t *' (aka 'unsigned long long *'))
> > [-Wcompare-distinct-pointer-types]
> >         do_div(rtt_avg, 6666);
> >         ^~~~~~~~~~~~~~~~~~~~~
> > include/asm-generic/div64.h:222:28: note: expanded from macro
> > 'do_div'
> >         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
> >                ~~~~~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~~
> > 1 warning generated.
> > 
> > do_div expects an unsigned dividend. Use div64_s64, which expects a
> > signed dividend.
> 
> Eh, IIRC, signed vs unsigned division has implications for rounding
> towards zero or not, but I doubt that the round trip time average
> (RTT
> avg) should ever be negative.  General rule of thumb for C is to keep
> arithmetic signed (even when working with non zero values), so rather
> than make the literal (6666) a unsigned long, I agree with your
> change
> to keep the division signed as well.  Thanks for the fix.
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks for the patch and for the review.  I've applied this to our
internal tree and it will be sent upstreaming following our normal
upstreaming process.

--
Cheers,
Luca.

