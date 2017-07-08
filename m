Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:33456 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752841AbdGHLPm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Jul 2017 07:15:42 -0400
Received: by mail-vk0-f43.google.com with SMTP id r126so29093042vkg.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Jul 2017 04:15:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1499498863-6865-1-git-send-email-dev@kresin.me>
References: <1499498863-6865-1-git-send-email-dev@kresin.me>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Sat, 8 Jul 2017 13:15:21 +0200
Message-ID: <CAOiHx=m5CdOM82R3T7DBwQPNgHTrAA95mt4ZeYWqa-cr5KPGrQ@mail.gmail.com> (sfid-20170708_131545_801247_C9D67BD1)
Subject: Re: [PATCH] rt2x00: call clk_get_rate only if we have a clock
To: Mathias Kresin <dev@kresin.me>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 8 July 2017 at 09:27, Mathias Kresin <dev@kresin.me> wrote:
> If clk_get returns an error, rt2x00dev->clk is set to NULL. In
> contrast to the common clock framework provided clk_get_rate(), at
> least the ramips and bcm63xx legacy implementation of the clk API
> access the rate member of the clk struct without a NULL check. This
> results into a kernel panic if we do not have a (SoC) clock.
>
> Call clk_get_rate only if we have a clock to fix the issues. This
> approach is similar to what is done in the kernel at various places.
> Usually clk_get_rate() is only called if clk_get_rate() doesn't return

Did you mean clk_get() as the second one?

> an error.
>
> Signed-off-by: Mathias Kresin <dev@kresin.me>

Tbh, I'd rather have this fixed at the source than adding a workaround
to consumers, to have a consistent API across implementations (with
drivers/clk/clk.c as the reference).

And there don't seem that many, at least searching for clk_get_rate
gave me only two handful of implementations of which many already
check for NULL.


Regards
Jonas
