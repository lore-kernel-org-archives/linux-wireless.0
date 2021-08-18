Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31072C4338F
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Aug 2021 07:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11B8B60FBF
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Aug 2021 07:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbhHRHJl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Aug 2021 03:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238745AbhHRHJj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Aug 2021 03:09:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD82C061764;
        Wed, 18 Aug 2021 00:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ym1uD8O5zOub+cpikC9nk8w/uDg8kA95v0fuB8biuWo=;
        t=1629270544; x=1630480144; b=p1Ld4iQXUw+HDTOMXfbZh8MdkvWZs01KD6dhfc0MHu3ANOJ
        kjikpASrlMR5ErUwflDXgeN/ePfPdk6uHK5YkYndKFme44SGe7PFapUGhCkd4wr+hgDtuxxi1Rkpn
        WvMjnMdJMhWMkyETqbRbmGHaQg7QVhzW15MAkXgIMhgfH6px5KEsTbRnJlHYePY3dmbZwub+3EJFn
        VoTMq7pLiGeW5+Ytg3N/GchGICPxmp+mn2SzwyDGShHa3UdD/h5wGj+yNYTQRsh2X/isgBAOfRWYa
        QpDGlH4bQR6Vtjrozmt0lhENfx+Evj2JqLHbf2Idbo/xkNnblGpg3bdy8ycEpkKg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mGFgz-00CbW0-CL; Wed, 18 Aug 2021 09:08:53 +0200
Message-ID: <11db2cdc5316b51f3fa2f34e813a458e455c763d.camel@sipsolutions.net>
Subject: Re: [PATCH v2 44/63] mac80211: Use memset_after() to clear tx status
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Date:   Wed, 18 Aug 2021 09:08:52 +0200
In-Reply-To: <20210818060533.3569517-45-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
         <20210818060533.3569517-45-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2021-08-17 at 23:05 -0700, Kees Cook wrote:
> 
> @@ -275,12 +275,11 @@ static void carl9170_tx_release(struct kref *ref)
>  	if (WARN_ON_ONCE(!ar))
>  		return;
>  
> 
> 
> 
> -	BUILD_BUG_ON(
> -	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
> -
> -	memset(&txinfo->status.ack_signal, 0,
> -	       sizeof(struct ieee80211_tx_info) -
> -	       offsetof(struct ieee80211_tx_info, status.ack_signal));
> +	/*
> +	 * Should this call ieee80211_tx_info_clear_status() instead of clearing
> +	 * manually? txinfo->status.rates do not seem to be used here.
> +	 */

Since you insist, I went digging :)

It should not, carl9170_tx_fill_rateinfo() has filled the rate
information before we get to this point.

johannes

