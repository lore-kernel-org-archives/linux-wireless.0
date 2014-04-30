Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:42073 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaD3Txr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 15:53:47 -0400
Received: by mail-ve0-f171.google.com with SMTP id jy13so2779097veb.16
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2014 12:53:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFjWW+Yt5RxZStkyfMgW9j0SV7RX_ZKC4JT9B-8_WbYNmP7RFg@mail.gmail.com>
References: <CAFjWW+Yt5RxZStkyfMgW9j0SV7RX_ZKC4JT9B-8_WbYNmP7RFg@mail.gmail.com>
Date: Wed, 30 Apr 2014 12:53:46 -0700
Message-ID: <CAFjWW+bAWSfFR32eU1Wcp+Nft9YFgaF63DBFPSDt6PGBgWKDUg@mail.gmail.com> (sfid-20140430_215351_165568_5D3770EA)
Subject: Re: Unable to Compile 3.14-1
From: Aaron Hamilton <aaron@logicdatasystems.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case anyone else comes across this, there's a dependency for
CRYPTO_CCM that wasn't enabled in my kernel. Somehow menuconfig didn't
pick it up.

Still have no idea why the compat_put_timespec line is failing to
compile. I'm guessing it's another unmet dependency somewhere (I'm
using a striped down ARM kernel)?

On Tue, Apr 29, 2014 at 7:59 PM, Aaron Hamilton
<aaron@logicdatasystems.net> wrote:
> In trying to compile backports-3.14-1 with a 2.6.39.4 kernel, I get
> the following compilation errors:
>
> backport-include/linux/compat.h:18: error: expected ';', ',' or ')'
> before '*' token
>
> If I comment out line 18 in compat.h which just reads "extern int
> compat_put_timespec(const struct timespec*, void __user *)", then I
> get past that error.
>
> Next, things get stuck on compat/crypto-ccm.c on lines 250 and 255,
> stating "too few arguments to function 'scatterwalk_map'" and "too few
> arguments to function 'scatterwalk_unmap'". Both of these function
> calls pass only one argument, yet my kernel headers define the
> functions with two parameters.
>
> I also checked for further references in compat code, but couldn't
> find any declarations that map this function properly to one take a
> single argument.
