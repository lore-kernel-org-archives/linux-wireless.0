Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1571C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 831072147C
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfBTKvw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:51:52 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45281 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfBTKvw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 05:51:52 -0500
Received: by mail-qk1-f196.google.com with SMTP id v139so1647117qkb.12;
        Wed, 20 Feb 2019 02:51:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HbDijqYd6VcGTjPEbGlnYQ5VNZqSZ9FTKXSy74dKt3Y=;
        b=E826gvrpL4E/w6ZwMXtTLeEpRMr6Xp/6fZwN1QD24OM9t4Mi6UE/CUgiBsQrp7cvPv
         lEILB03T03kUD/VmwDKQz5TbVbsl0i7K52zY+Pg/JRm1UX25MP6xJgmuiRGRR2ygYaTU
         OtrmB89b3WcgEYiamDIfffUbC4Gv9xTlaGhzLm0SoGIJAqdP9nn4vFcvGR/fTRRw5Nry
         xYQkposszndh8kkI+fvtYeO7kDqDDNoTpyZ1hx6Hi2Y1eZWAm+VIfEuM5nVq+kfpvdJD
         1s1Z+STMXeBEGt5y/kfbMWSNuDidqBtVJoJGD+OgipmTKUBWdPvwC4NLvUGBLbqaWZdp
         dOGQ==
X-Gm-Message-State: AHQUAua3KdSzpHYEs2i/qcSinG+O2reARebbj2B8iLC9DlzPDWAyrUMA
        8xsJumB4+8RGkJkvzszqwILKipP1B2/cr/pvuvY=
X-Google-Smtp-Source: AHgI3IbG25UwycjW5eDbZn7BhId3DVZSHrLpQvTau5C8rR6BfYWypsTdmtn4n3G7181xutvguKWUXkkA4wr/ClOsT1c=
X-Received: by 2002:ae9:d8c2:: with SMTP id u185mr23165623qkf.107.1550659911265;
 Wed, 20 Feb 2019 02:51:51 -0800 (PST)
MIME-Version: 1.0
References: <20190219182105.19933-1-natechancellor@gmail.com>
In-Reply-To: <20190219182105.19933-1-natechancellor@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 Feb 2019 11:51:34 +0100
Message-ID: <CAK8P3a1d6Zksdv-Or+paawyn4N0u4EpVw9QgyDGHYvX_1s3JrQ@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: mvm: Use div64_s64 instead of do_div in iwl_mvm_debug_range_resp
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 19, 2019 at 7:22 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>

> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> index e9822a3ec373..92b22250eb7d 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> @@ -462,7 +462,7 @@ static void iwl_mvm_debug_range_resp(struct iwl_mvm *mvm, u8 index,
>  {
>         s64 rtt_avg = res->ftm.rtt_avg * 100;
>
> -       do_div(rtt_avg, 6666);
> +       div64_s64(rtt_avg, 6666);

This is wrong: div64_s64 does not modify its argument like do_div(), but
it returns the result instead. You also don't want to divide by a 64-bit
value when the second argument is a small constant.

I think the correct way should be

       s64 rtt_avg = div_s64(res->ftm.rtt_avg * 100, 6666);

If you know that the value is positive, using unsigned types
and div_u64() would be slightly faster.

      Arnd
