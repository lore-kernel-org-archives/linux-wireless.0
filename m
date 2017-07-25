Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46066 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750897AbdGYMoH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 08:44:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Mathias Kresin <dev@kresin.me>
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: call clk_get_rate only if we have a clock
References: <1499498863-6865-1-git-send-email-dev@kresin.me>
Date: Tue, 25 Jul 2017 15:44:02 +0300
In-Reply-To: <1499498863-6865-1-git-send-email-dev@kresin.me> (Mathias
        Kresin's message of "Sat, 8 Jul 2017 09:27:43 +0200")
Message-ID: <87r2x4it4d.fsf@codeaurora.org> (sfid-20170725_144410_885353_9FD9FD0F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mathias Kresin <dev@kresin.me> writes:

> If clk_get returns an error, rt2x00dev->clk is set to NULL. In
> contrast to the common clock framework provided clk_get_rate(), at
> least the ramips and bcm63xx legacy implementation of the clk API
> access the rate member of the clk struct without a NULL check. This
> results into a kernel panic if we do not have a (SoC) clock.
>
> Call clk_get_rate only if we have a clock to fix the issues. This
> approach is similar to what is done in the kernel at various places.
> Usually clk_get_rate() is only called if clk_get_rate() doesn't return
> an error.
>
> Signed-off-by: Mathias Kresin <dev@kresin.me>
> ---
>
> Resend, the first mail had the wrong list in cc.

Then you should mark this as v2:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

-- 
Kalle Valo
