Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43017C433B4
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Apr 2021 20:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B5D961428
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Apr 2021 20:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhDVUFO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Apr 2021 16:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVUFN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Apr 2021 16:05:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64591C06174A;
        Thu, 22 Apr 2021 13:04:38 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lZfYs-00FKfh-Bx; Thu, 22 Apr 2021 22:04:30 +0200
Message-ID: <120f5db6566b583cc7050f13e947016f3cb82412.camel@sipsolutions.net>
Subject: Re: [PATCH v2][next] wireless: wext-spy: Fix out-of-bounds warning
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Date:   Thu, 22 Apr 2021 22:04:29 +0200
In-Reply-To: <20210422200032.GA168995@embeddedor>
References: <20210422200032.GA168995@embeddedor>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2021-04-22 at 15:00 -0500, Gustavo A. R. Silva wrote:
> 
> Changes in v2:
>  - Use direct struct assignments instead of memcpy().
>  - Fix one more instance of this same issue in function
>    iw_handler_get_thrspy().
>  - Update changelog text.

Thanks.

>  - Add Kees' RB tag. 

He probably won't mind in this case, but you did some pretty substantial
changes to the patch, so I really wouldn't recommend keeping it there.

johannes

