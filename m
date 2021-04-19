Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DF2C433ED
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Apr 2021 11:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 430996023E
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Apr 2021 11:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbhDSL5E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Apr 2021 07:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbhDSL5D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Apr 2021 07:57:03 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFA2C06174A;
        Mon, 19 Apr 2021 04:56:32 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id o2so12369435qtr.4;
        Mon, 19 Apr 2021 04:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=geHbG37dG66IVQ8TphiJdyvokhoZACxqTO6eQyQepdA=;
        b=GDErt55EFDad6hclq6Zft921T/o/xr4n85l668ZNrFIzQsX+2XmF3E+0FjCCQAMpvt
         6a65atxH3OvHVdUegPgSsiobPHngawRR8MBTMs9NlZrUVJlemSknLFKHAMUml44mfash
         07Td0smiBon29XVPxAGWR2RcpWeoyehl8I8iO0hzIyVME9J3SeDltSQ4xwHMjJRd5XQy
         vxLTN4VhovrmnRtsLRzyyUGIL3MtMvoKySeZk6UHhwyqSUk9cidAyU8EW0SptNGAkQ+j
         D5Mi8DruCaKdV3j3GX10bPyUMX543bbx89KiYks6klH80o+MovgNXNWTH+xUk7MWYWWn
         rLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=geHbG37dG66IVQ8TphiJdyvokhoZACxqTO6eQyQepdA=;
        b=enZv6Cs9lHnIGw8Q8kIHlB6xmJRRBIlDwHNw8+ZLfRZtNhI0/svXVernBs/3WcizSD
         sOHzw7NiMhBlnUanuNySlkqBmx9z8i72vKNA9Cn8xnC4UpS97x81Ac0KCyev9MHNlQFI
         MWFExgqN1uxhSz8f4mhkwK1Rqx1u5+6e8sZi6EITPUnizd5wDFblmkKwfGPOMFI2aNJt
         9H5hNfHb08rE79dU8bKDHUAaOCv73dCbnOf913nHMO8b2C0Zii3w1KNeK32bXgTvUP0v
         hUJrqZ1H2ZuY1qeSVx5poNCyyCsiL8t/i8+H/zSr0oo6ViFYdC+uV0N4qeWv3Cbyz8ai
         nxqQ==
X-Gm-Message-State: AOAM530xylUppG9jhCHObiLV1VmtKK1PujwilJDctjsjxP2FJTG9PZLI
        75MCI/kJcYQeUQoPHBpZM9LAkh9pgV0=
X-Google-Smtp-Source: ABdhPJyG73rmPAhNEADWajH1APPXwzSNiPx9EPGcR1DnSe7zUpkJIncUyWIQjXpizCrkVhX9SMncAA==
X-Received: by 2002:a05:622a:88:: with SMTP id o8mr11589245qtw.39.1618833391371;
        Mon, 19 Apr 2021 04:56:31 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:1102::1844? ([2620:10d:c091:480::1:1b53])
        by smtp.gmail.com with ESMTPSA id p21sm7458401qkp.95.2021.04.19.04.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 04:56:30 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
To:     Joe Perches <joe@perches.com>, Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305094850.GA141221@embeddedor>
 <20210417175201.2D5A7C433F1@smtp.codeaurora.org>
 <6bcce753-ceca-8731-ec66-6f467a3199fd@gmail.com>
 <e256ba8bf66ec4baa5267b4a2f64b2a215817d16.camel@perches.com>
Message-ID: <55e04b5e-9ec5-6a9c-7381-024c4bf11c6d@gmail.com>
Date:   Mon, 19 Apr 2021 07:56:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e256ba8bf66ec4baa5267b4a2f64b2a215817d16.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/17/21 8:09 PM, Joe Perches wrote:
> On Sat, 2021-04-17 at 14:30 -0400, Jes Sorensen wrote:
>> On 4/17/21 1:52 PM, Kalle Valo wrote:
>>> "Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:
>>>
>>>> In preparation to enable -Wimplicit-fallthrough for Clang, fix
>>>> multiple warnings by replacing /* fall through */ comments with
>>>> the new pseudo-keyword macro fallthrough; instead of letting the
>>>> code fall through to the next case.
>>>>
>>>> Notice that Clang doesn't recognize /* fall through */ comments as
>>>> implicit fall-through markings.
>>>>
>>>> Link: https://github.com/KSPP/linux/issues/115
>>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>>
>>> Patch applied to wireless-drivers-next.git, thanks.
>>>
>>> bf3365a856a1 rtl8xxxu: Fix fall-through warnings for Clang
>>>
>>
>> Sorry this junk patch should not have been applied.
> 
> I don't believe it's a junk patch.
> I believe your characterization of it as such is flawed.
> 
> You don't like the style, that's fine, but:
> 
> Any code in the kernel should not be a unique style of your own choosing
> when it could cause various compilers to emit unnecessary warnings.
> 
> Please remember the kernel code base is a formed by a community with a
> nominally generally accepted style.  There is a real desire in that
> community to both enable compiler warnings that might show defects and
> simultaneously avoid unnecessary compiler warnings.
> 
> This particular change just avoids a possible compiler warning.

Please go back and look at the thread. This patch fixes nothing, it
mutilates the code by introducing non C for the sole purpose of avoiding
to work with the Clang community to fix their broken compiler. The
author of this patch ignored previous feedback and just reposted the
same patch unaltered and when it was called out, the answer was other
people was fine with it. None of the issues raised have been addressed,
so yes, that makes the patch junk.

Jes
