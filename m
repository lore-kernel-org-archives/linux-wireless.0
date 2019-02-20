Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35A4C10F07
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 17:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9D6421848
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 17:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hQQrgG8k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfBTR4V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 12:56:21 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42030 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfBTR4U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 12:56:20 -0500
Received: by mail-ed1-f66.google.com with SMTP id j89so11250162edb.9;
        Wed, 20 Feb 2019 09:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5EYA/pR4D3Qk39QOsx21H2qfduexaLEFk1otMKvXeq8=;
        b=hQQrgG8ktq2jf4GihGMLbEOMZN2+p31B1bCi/hdllGgMPpTJ0QhCiHXCuZzyDhm4BS
         x7s8pxYKHDN8XXq3/heyUju54PHGSV3uZml+0AvgFbFEJS4XoCEIMbwLSbBY7fp8Ord2
         aIGUD9kZixGrdxs2nkjmS1z/G2jOE/RTkhO3aGvFtaIUlDWIQB+3NvAuyryoZ+ZtfUKG
         /O0lP/dDyRP/7AR3V02C/7mFqiC63yXcfPOf19N3Tr+k0f9CXHZPJwa4QyoNwwSi0f9l
         449EAW8B16LphiyxMUbPW3439ElJ8DrXFQUEuSL6PNSBlevQ8IawdjiHvdTOSGvGK/1D
         RO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5EYA/pR4D3Qk39QOsx21H2qfduexaLEFk1otMKvXeq8=;
        b=fuvqn8GqAfKnZfxX5IJJRk/F6gRP8+9bDJcnDWJ/rHIuwsjpETZTm/YEKaMq9bDHUI
         BVyExAeGKBqDcMRtja7ddNXWtKJ1mCJtLIUS/+ziDKU/LZFlGFMF3Smr0UdVgAcsN6vs
         HO55Smouie6QOMY1goEfqP9JxEFmoi/2xw0m8f3kZq3fhxPhltbrdhEm69vjLbNSvNrE
         qUaCObWUgEMoR8P5nXA6SfIImdZEJ3jst+WZfQZdbOwEM5ooSNDKj+juw4fKz+BvpLzI
         MmavHnU3uB6LKvkgAGUtJ6Skco70KirXUBW12v64VG6knwDaiZzL7Zm2I3MEpcA7adJn
         vf6w==
X-Gm-Message-State: AHQUAua5THUJz5h014KI1TGV+qbFNK3SbRxPuE40rSFw3+BWLJK6fsAs
        tpdiwCw6zVYd3Mhe8qi2xMI=
X-Google-Smtp-Source: AHgI3Iah9iVG2xNzgadgw2mBDecX7voCsDy3Cw92/M4inuQJDhyBcyKJNJ7MpHxaUX31sYLF7cJY8A==
X-Received: by 2002:a05:6402:185a:: with SMTP id v26mr28148414edy.163.1550685378393;
        Wed, 20 Feb 2019 09:56:18 -0800 (PST)
Received: from archlinux-ryzen ([2a01:4f9:2a:1fae::2])
        by smtp.gmail.com with ESMTPSA id c5sm6058214edm.36.2019.02.20.09.56.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 20 Feb 2019 09:56:17 -0800 (PST)
Date:   Wed, 20 Feb 2019 10:56:15 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] iwlwifi: mvm: Use div64_s64 instead of do_div in
 iwl_mvm_debug_range_resp
Message-ID: <20190220175615.GA1312@archlinux-ryzen>
References: <20190219182105.19933-1-natechancellor@gmail.com>
 <CAK8P3a1d6Zksdv-Or+paawyn4N0u4EpVw9QgyDGHYvX_1s3JrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1d6Zksdv-Or+paawyn4N0u4EpVw9QgyDGHYvX_1s3JrQ@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 20, 2019 at 11:51:34AM +0100, Arnd Bergmann wrote:
> On Tue, Feb 19, 2019 at 7:22 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> 
> > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> > index e9822a3ec373..92b22250eb7d 100644
> > --- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> > @@ -462,7 +462,7 @@ static void iwl_mvm_debug_range_resp(struct iwl_mvm *mvm, u8 index,
> >  {
> >         s64 rtt_avg = res->ftm.rtt_avg * 100;
> >
> > -       do_div(rtt_avg, 6666);
> > +       div64_s64(rtt_avg, 6666);
> 
> This is wrong: div64_s64 does not modify its argument like do_div(), but
> it returns the result instead. You also don't want to divide by a 64-bit
> value when the second argument is a small constant.
> 
> I think the correct way should be
> 
>        s64 rtt_avg = div_s64(res->ftm.rtt_avg * 100, 6666);
> 
> If you know that the value is positive, using unsigned types
> and div_u64() would be slightly faster.
> 
>       Arnd

Thanks for the review and explanation, Arnd.

Luca, could you drop this version so I can resend it?

Nathan
