Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5145EC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 01:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E729217D9
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 01:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="N3EjsaZC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732634AbfBSBQ4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 20:16:56 -0500
Received: from conssluserg-05.nifty.com ([210.131.2.90]:19130 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfBSBQ4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 20:16:56 -0500
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x1J1GcBe031407;
        Tue, 19 Feb 2019 10:16:38 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x1J1GcBe031407
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1550538999;
        bh=Douiv15xBB5mdwLvrk43kW9DatkEu5DyhdQekoTVJo4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=N3EjsaZCDdE5xA6+/thXXwKv+jyhtTvSVbprT1r/Nwew7Rll5FG0b4Bv/SWLwq82r
         I+xEI+Jg8vO7GeVGHTa6eUhD9Qh8izJRN9v9BsqAmeHla7FvKq2FmWIO+ESPcJf8a3
         BlJYgZnjgsvaJaQEOwCPZQ6aBhFXv+T0doi6O+Di+3Pxg2s0OR6wUSl6BlB2fapwPZ
         2X5kqPkuV3tpeR8Q8PNR0NNdk27Dg6BXa5lYqz0WYgY4K6OFeFBhArazn5OvOJWKJk
         4x5pdh7Vrl1Ot3S8wRtKKmqsfoXF6uLWmM+ATdvnUj7YZyzA48S10GG5T8X3ZKxkEh
         XxyjBNcGzPPPQ==
X-Nifty-SrcIP: [209.85.217.49]
Received: by mail-vs1-f49.google.com with SMTP id z18so10767504vso.7;
        Mon, 18 Feb 2019 17:16:38 -0800 (PST)
X-Gm-Message-State: AHQUAuYbSdmUgVEUR0nDKQ6NfOf2kgAl8V+fvR1hpJh5y6dCq4RHpaM1
        ahHnDkTBcvh1/R+L2Aynz28zr5RVeOCkOYJ0JSI=
X-Google-Smtp-Source: AHgI3Ib3puRMlLmBdffOatDI18/7F9DkPs0JYxpfBTR47cKD/YQ0OhyQMoUTf8dBjrHdow5axdEImDNGgMDv3y+huug=
X-Received: by 2002:a05:6102:18f:: with SMTP id r15mr7412998vsq.215.1550538997631;
 Mon, 18 Feb 2019 17:16:37 -0800 (PST)
MIME-Version: 1.0
References: <1550469571-25933-1-git-send-email-yamada.masahiro@socionext.com> <1550469571-25933-3-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1550469571-25933-3-git-send-email-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Tue, 19 Feb 2019 10:16:01 +0900
X-Gmail-Original-Message-ID: <CAK7LNATS_4AjrehQ7uW26=bjw-VHc_GcD7oqS_C9Rsgs1-jHUw@mail.gmail.com>
Message-ID: <CAK7LNATS_4AjrehQ7uW26=bjw-VHc_GcD7oqS_C9Rsgs1-jHUw@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: disable CONFIG_GENERIC_HWEIGHT and remove __HAVE_ARCH_SW_HWEIGHT
To:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 18, 2019 at 3:09 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> arch/x86/include/asm/arch_hweight.h uses __sw_hweight{32,64} as
> alternatives, but they are implemented in arch/x86/lib/hweight.S
>
> x86 does not rely on the generic C implementation lib/hweight.c
> at all, so CONFIG_GENERIC_HWEIGHT should be disabled.
>
> __HAVE_ARCH_SW_HWEIGHT was unneeded in the first place.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>


Maintainers,

As I replied to 1/2,
please ignore this for now.


I will resend this later,
hopefully in the next development cycle.


> ---
>
>  arch/x86/Kconfig                    | 3 ---
>  arch/x86/include/asm/arch_hweight.h | 2 --
>  lib/hweight.c                       | 4 ----
>  3 files changed, 9 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 6826143..c2813af 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -262,9 +262,6 @@ config GENERIC_BUG
>  config GENERIC_BUG_RELATIVE_POINTERS
>         bool
>
> -config GENERIC_HWEIGHT
> -       def_bool y
> -
>  config ARCH_MAY_HAVE_PC_FDC
>         def_bool y
>         depends on ISA_DMA_API
> diff --git a/arch/x86/include/asm/arch_hweight.h b/arch/x86/include/asm/arch_hweight.h
> index fc06935..ba88edd 100644
> --- a/arch/x86/include/asm/arch_hweight.h
> +++ b/arch/x86/include/asm/arch_hweight.h
> @@ -12,8 +12,6 @@
>  #define REG_OUT "a"
>  #endif
>
> -#define __HAVE_ARCH_SW_HWEIGHT
> -
>  static __always_inline unsigned int __arch_hweight32(unsigned int w)
>  {
>         unsigned int res;
> diff --git a/lib/hweight.c b/lib/hweight.c
> index 7660d88..c94586b 100644
> --- a/lib/hweight.c
> +++ b/lib/hweight.c
> @@ -10,7 +10,6 @@
>   * The Hamming Weight of a number is the total number of bits set in it.
>   */
>
> -#ifndef __HAVE_ARCH_SW_HWEIGHT
>  unsigned int __sw_hweight32(unsigned int w)
>  {
>  #ifdef CONFIG_ARCH_HAS_FAST_MULTIPLIER
> @@ -27,7 +26,6 @@ unsigned int __sw_hweight32(unsigned int w)
>  #endif
>  }
>  EXPORT_SYMBOL(__sw_hweight32);
> -#endif
>
>  unsigned int __sw_hweight16(unsigned int w)
>  {
> @@ -46,7 +44,6 @@ unsigned int __sw_hweight8(unsigned int w)
>  }
>  EXPORT_SYMBOL(__sw_hweight8);
>
> -#ifndef __HAVE_ARCH_SW_HWEIGHT
>  unsigned long __sw_hweight64(__u64 w)
>  {
>  #if BITS_PER_LONG == 32
> @@ -69,4 +66,3 @@ unsigned long __sw_hweight64(__u64 w)
>  #endif
>  }
>  EXPORT_SYMBOL(__sw_hweight64);
> -#endif
> --
> 2.7.4
>


-- 
Best Regards
Masahiro Yamada
