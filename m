Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725BCC10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41E3E207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfBVHp0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:45:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:4525 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfBVHpZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 02:45:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2019 23:45:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,398,1544515200"; 
   d="scan'208";a="126355752"
Received: from njmartin-mobl2.ger.corp.intel.com ([10.252.28.185])
  by fmsmga008.fm.intel.com with ESMTP; 21 Feb 2019 23:45:22 -0800
Message-ID: <0ce6097e3c1a6b76610df9a4fb912dd0cb8941ee.camel@intel.com>
Subject: Re: [PATCH v2] iwlwifi: mvm: Use div_s64 instead of do_div in
 iwl_mvm_debug_range_resp
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 22 Feb 2019 09:45:21 +0200
In-Reply-To: <CAKwvOdmCeHxiGPkXXzjwnTtgzEDDjYRE1QBdu7BHeuzCE4YtRA@mail.gmail.com>
References: <20190219182105.19933-1-natechancellor@gmail.com>
         <20190221080617.2795-1-natechancellor@gmail.com>
         <CAKwvOdmCeHxiGPkXXzjwnTtgzEDDjYRE1QBdu7BHeuzCE4YtRA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-02-21 at 16:13 -0800, Nick Desaulniers wrote:
> On Thu, Feb 21, 2019 at 12:08 AM Nathan Chancellor
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
> > do_div expects an unsigned dividend. Use div_s64, which expects a
> > signed
> > dividend.
> > 
> > Fixes: 937b10c0de68 ("iwlwifi: mvm: add debug prints for FTM")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/372
> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> > 
> > v1 -> v2:
> > 
> > * Fix logic (as the return value of div{,64}_s64 must be used),
> > thanks
> >   to Arnd for the review.
> 
> oh boy, sorry I missed that in the initial code review, thanks Arnd
> for the sharp eye!
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks, guys, I really didn't pay much attention when I applied the
previous versions either.

I have applied this in our internal tree and will send it out instead
of the previous one as part of our upstreaming process.

--
Cheers,
Luca.

