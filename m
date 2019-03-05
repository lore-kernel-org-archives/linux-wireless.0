Return-Path: <SRS0=e8Py=RI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA47C43381
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 11:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A440206DD
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 11:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfCELqg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Mar 2019 06:46:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:40552 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726150AbfCELqg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Mar 2019 06:46:36 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h18Wi-00050B-Tw; Tue, 05 Mar 2019 13:46:29 +0200
Message-ID: <2213e2f0199d8165efcbb9a9ee14b99b2e0f5fc5.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 05 Mar 2019 13:46:27 +0200
In-Reply-To: <87a7i9fuef.fsf@kamboji.qca.qualcomm.com>
References: <20190304203924.2111146-1-arnd@arndb.de>
         <87a7i9fuef.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: fix 64-bit division
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-03-05 at 13:11 +0200, Kalle Valo wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> 
> > do_div() expects unsigned operands and otherwise triggers a warning
> > like:
> > 
> > drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:465:2:
> > error: comparison of distinct pointer types ('typeof ((rtt_avg)) *'
> > (aka 'long long *') and 'uint64_t *' (aka 'unsigned long long *'))
> > [-Werror,-Wcompare-distinct-pointer-types]
> >         do_div(rtt_avg, 6666);
> >         ^~~~~~~~~~~~~~~~~~~~~
> > include/asm-generic/div64.h:222:28: note: expanded from macro
> > 'do_div'
> >         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
> >                ~~~~~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~~
> > 1 error generated.
> > 
> > Change the do_div() to the simpler div_s64() that can handle
> > negative inputs correctly.
> > 
> > Fixes: 937b10c0de68 ("iwlwifi: mvm: add debug prints for FTM")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Luca, can I take this directly?

Yeah, I guess to make things simpler, and since you're planning to send
fixes to 5.1 already anyway, you can just take this one.  I'll assign
it to you in patchwork.

Arnd, this way you'll get it earlier. ;)

--
Cheers,
Luca.

