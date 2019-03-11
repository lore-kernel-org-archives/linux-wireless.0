Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E87C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 739F120643
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbfCKHqJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 03:46:09 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:42602 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725943AbfCKHqH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 03:46:07 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h3FdI-00025W-LM; Mon, 11 Mar 2019 09:46:01 +0200
Message-ID: <1766c73f8a0a500450d3ef385608b8b666eebe05.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Date:   Mon, 11 Mar 2019 09:45:58 +0200
In-Reply-To: <CAKwvOdn183kWz=+6robC44m4YWPXBLVJzhxL6f9jftvRi-=sxA@mail.gmail.com>
References: <20190308000322.5379-1-natechancellor@gmail.com>
         <CAKwvOdn183kWz=+6robC44m4YWPXBLVJzhxL6f9jftvRi-=sxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: mvm: Change an 'else if' into an 'else' in
 iwl_mvm_send_add_bcast_sta
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-03-07 at 16:08 -0800, Nick Desaulniers wrote:
> On Thu, Mar 7, 2019 at 4:03 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> > When building with -Wsometimes-uninitialized, Clang warns:
> > 
> > drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2114:12: warning:
> > variable
> > 'queue' is used uninitialized whenever 'if' condition is false
> > [-Wsometimes-uninitialized]
> > 
> > Clang can't evaluate at this point that WARN(1, ...) always returns
> > true
> > because __ret_warn_on is defined as !!(condition), which isn't
> > immediately evaluated as 1. Change this branch to else so that it's
> > clear to Clang that we intend to bail out here.
> > 
> > Link: https://github.com/ClangBuiltLinux/linux/issues/399
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> Thanks for the simple fix.
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks for the patch and for the review!

I have applied it in our internal tree and it will reach the mainline
following our normal upstreaming process.

--
Cheers,
Luca.

