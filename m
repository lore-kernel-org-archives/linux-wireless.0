Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E7CC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 06:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E167218E2
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 06:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbfCWGLV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Mar 2019 02:11:21 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46472 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726029AbfCWGLV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Mar 2019 02:11:21 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Zs8-00015K-0H; Sat, 23 Mar 2019 08:11:12 +0200
Message-ID: <a92bc0994d5f3fa5da5da471d0ccd01f8cefeee5.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 23 Mar 2019 08:11:10 +0200
In-Reply-To: <20190322141322.463149-1-arnd@arndb.de>
References: <20190322141322.463149-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: work around clang -Wuninitialized warning
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-03-22 at 15:13 +0100, Arnd Bergmann wrote:
> Clang incorrectly warns about an uninitialized variable:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2114:12: error: variable
> 'queue' is used uninitialized whenever 'if'
>       condition is false [-Werror,-Wsometimes-uninitialized]
>                 else if (WARN(1, "Missing required TXQ for adding
> bcast STA\n"))
>                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~~~~
> include/asm-generic/bug.h:130:36: note: expanded from macro 'WARN'
>  #define WARN(condition, format...)
> ({                                   \
>                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~
> drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2119:33: note:
> uninitialized use occurs here
>                 iwl_mvm_enable_txq(mvm, NULL, queue, 0, &cfg,
> wdg_timeout);
>                                               ^~~~~
> drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2114:8: note: remove the
> 'if' if its condition is always true
>                 else if (WARN(1, "Missing required TXQ for adding
> bcast STA\n"))
>                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~~~~~
> drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2094:11: note:
> initialize the variable 'queue' to silence this warning
>         int queue;
>                  ^
>                   = 0
> 1 error generated.
> 
> This cannot happen because the if/else if/else if block always
> has one code path that is entered. However, we can simply
> rearrange the code to let clang see this as well.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Thanks for the patch, Arnd! But I have already queued up an equivalent
patch for v5.2 (should probably reach linux-next by the end of next
week or so):

https://patchwork.kernel.org/patch/10844025/

--
Cheers,
Luca.

