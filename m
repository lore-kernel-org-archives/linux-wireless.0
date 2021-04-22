Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F80C433ED
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Apr 2021 07:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F7B06145A
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Apr 2021 07:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhDVHFG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhDVHFE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Apr 2021 03:05:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510A8C06174A;
        Thu, 22 Apr 2021 00:04:29 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lZTNs-00F4p1-N9; Thu, 22 Apr 2021 09:04:20 +0200
Message-ID: <317099c78edb9fdde3db3f1e7c9a4f77529b281a.camel@sipsolutions.net>
Subject: Re: [PATCH][next] wireless: wext-spy: Fix out-of-bounds warning
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Date:   Thu, 22 Apr 2021 09:04:19 +0200
In-Reply-To: <20210421234337.GA127225@embeddedor>
References: <20210421234337.GA127225@embeddedor>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2021-04-21 at 18:43 -0500, Gustavo A. R. Silva wrote:
> 
>  	/* Just do it */
> -	memcpy(&(spydata->spy_thr_low), &(threshold->low),
> -	       2 * sizeof(struct iw_quality));
> +	memcpy(&spydata->spy_thr_low, &threshold->low, sizeof(threshold->low));
> +	memcpy(&spydata->spy_thr_high, &threshold->high, sizeof(threshold->high));
> 

It would've been really simple to stick to 80 columns here (and
everywhere in the patch), please do that.

Also, why not just use struct assigments?

	spydata->spy_thr_low = threshold->low;

etc.

Seems far simpler (and shorter lines).

johannes


