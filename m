Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7771C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 19:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FA2A20850
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 19:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqKeYF2K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfCTTKb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 15:10:31 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39333 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfCTTKb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 15:10:31 -0400
Received: by mail-ed1-f68.google.com with SMTP id p27so2963576edc.6;
        Wed, 20 Mar 2019 12:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E1J0TLtNxQGhiW+cnGH2Vxj6UXnA7Xkbtcf3KUCqpLY=;
        b=bqKeYF2KAVLf1abyHvg8mOPOBK4qTIE9S/qG1gyDlXcK3xGKmiUhWzIYProZPQM7aS
         toZByuvXfkrcQd9wLCFzWIeQmmeeVKhm/F0TqSvxbzUT08uAqlqEpzaiEVOmuE0eJOAL
         pYaNCC5xsPFx/6O4bwsC7z10Iz2vFFDgv3UDGxBhcBIUzijeMCFvHo56VitCNZhnxpWk
         NvZKYmwyU4bF/FU3K19q0i/cEllUQTjE3mGCdQb7LbnsPlHn0Ymz1LN9K7K/zbhKVEgP
         j758KAzqqLQnAFCJeVJfLjDC3y+a3YT1d+xcsREYoRLqbhzey39rmAzugcd3Qr2AV1fh
         9CHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E1J0TLtNxQGhiW+cnGH2Vxj6UXnA7Xkbtcf3KUCqpLY=;
        b=EUhckBePi0hnpjy/odqKsvoUk1Fi1oBUrrVduBHEc9nFOUwduRE2pPemZ+80qDaDAF
         I7DWD9zvV3etCjhR8QiaoqClBWkjtjbmjZLqCGEtXQEv3BjY9r5OglkQzLFx6UhZZPmv
         ucgzbc7GyBj5hi3gQKxPQqbPigIAB/l1jmo9pFxXU6TbtMlC9/CnNE2ZwEbqGbG3ipzI
         WC28FWk5/orfyFLpeUKSMujn3wZ+1pDef7R2sMVNlwICqRvcaCqtYyY2GHQgssgeZwUM
         IWN9aOS05Z3jIhaoQsdIp5tTapUU0yzUiedKMTDZXFR3TyZRmMeLch+JfiluSgMkjdMf
         9ymw==
X-Gm-Message-State: APjAAAU/l39hVzKxr0gzOudf9hPwdE7eCF2F2skYgqcqV2/sGGfMt1J9
        +t6aK7ERPB5VX8JaGgJLqGw=
X-Google-Smtp-Source: APXvYqy0YWmnCFTw36hzPK6pIBzUYnXZR3uFMjLRPffWACQ9Np7uliEfETIX6cKQMfdAqvYRmjp8ag==
X-Received: by 2002:a17:906:1d0f:: with SMTP id n15mr18193353ejh.102.1553109029444;
        Wed, 20 Mar 2019 12:10:29 -0700 (PDT)
Received: from archlinux-ryzen ([2a01:4f9:2a:1fae::2])
        by smtp.gmail.com with ESMTPSA id z3sm863426edh.74.2019.03.20.12.10.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 20 Mar 2019 12:10:28 -0700 (PDT)
Date:   Wed, 20 Mar 2019 12:10:26 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] cfg80211: Change an 'else if' into an 'else' in
 cfg80211_calculate_bitrate_he
Message-ID: <20190320191026.GC28744@archlinux-ryzen>
References: <20190307235735.31487-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190307235735.31487-1-natechancellor@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Mar 07, 2019 at 04:57:35PM -0700, Nathan Chancellor wrote:
> When building with -Wsometimes-uninitialized, Clang warns:
> 
> net/wireless/util.c:1223:11: warning: variable 'result' is used
> uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
> 
> Clang can't evaluate at this point that WARN(1, ...) always returns true
> because __ret_warn_on is defined as !!(condition), which isn't
> immediately evaluated as 1. Change this branch to else so that it's
> clear to Clang that we intend to bail out here.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/382
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  net/wireless/util.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index e4b8db5e81ec..75899b62bdc9 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -1220,9 +1220,11 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
>  	else if (rate->bw == RATE_INFO_BW_HE_RU &&
>  		 rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_26)
>  		result = rates_26[rate->he_gi];
> -	else if (WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
> -		      rate->bw, rate->he_ru_alloc))
> +	else {
> +		WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
> +		     rate->bw, rate->he_ru_alloc);
>  		return 0;
> +	}
>  
>  	/* now scale to the appropriate MCS */
>  	tmp = result;
> -- 
> 2.21.0
> 

Gentle ping (if there was a response to this, I didn't receive it). I
know I sent it in the middle of a merge window so I get if it slipped
through the cracks.

Thanks,
Nathan
