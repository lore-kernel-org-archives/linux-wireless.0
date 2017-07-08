Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33288 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdGHNhP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Jul 2017 09:37:15 -0400
Received: by mail-wr0-f196.google.com with SMTP id x23so13888832wrb.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Jul 2017 06:37:14 -0700 (PDT)
Subject: Re: [PATCH] rt2x00: call clk_get_rate only if we have a clock
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1499498863-6865-1-git-send-email-dev@kresin.me>
 <CAOiHx=m5CdOM82R3T7DBwQPNgHTrAA95mt4ZeYWqa-cr5KPGrQ@mail.gmail.com>
From: Mathias Kresin <dev@kresin.me>
Message-ID: <f3744f76-9909-90a9-012d-ddafbda9ad4a@kresin.me> (sfid-20170708_153754_158133_A1FC3902)
Date: Sat, 8 Jul 2017 15:37:11 +0200
MIME-Version: 1.0
In-Reply-To: <CAOiHx=m5CdOM82R3T7DBwQPNgHTrAA95mt4ZeYWqa-cr5KPGrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

08.07.2017 13:15, Jonas Gorski:
> Hi,
> 
> On 8 July 2017 at 09:27, Mathias Kresin <dev@kresin.me> wrote:
>> If clk_get returns an error, rt2x00dev->clk is set to NULL. In
>> contrast to the common clock framework provided clk_get_rate(), at
>> least the ramips and bcm63xx legacy implementation of the clk API
>> access the rate member of the clk struct without a NULL check. This
>> results into a kernel panic if we do not have a (SoC) clock.
>>
>> Call clk_get_rate only if we have a clock to fix the issues. This
>> approach is similar to what is done in the kernel at various places.
>> Usually clk_get_rate() is only called if clk_get_rate() doesn't return
> 
> Did you mean clk_get() as the second one?

Yes I do. ... is only called if clk_get() doesn't return an error.

> 
>> an error.
>>
>> Signed-off-by: Mathias Kresin <dev@kresin.me>
> 
> Tbh, I'd rather have this fixed at the source than adding a workaround
> to consumers, to have a consistent API across implementations (with
> drivers/clk/clk.c as the reference).
> 
> And there don't seem that many, at least searching for clk_get_rate
> gave me only two handful of implementations of which many already
> check for NULL.

I do not necessarily see an error in the archs legacy clock 
implementation. It rather looks like it works with the common clock 
framework due the lucky coincident that someone has added (an extra) 
null check.

I only had a brief look at the common clock framework, but it seams to 
me one should not pass the error returned by clk_get() and/or call 
clk_get_rate() at all if there was an error. That is what I've already 
seen and mentioned in the commit message.

The only difference here is that we do not have the error check and the 
clk_get_rate() call in the same function. rt2800_clk_is_20mhz() isn't 
aware that clk_get() failed. rt2x00dev->clk is set back to NULL in 
rt2x00soc_probe() in case of an clk_get error.

Mathias
