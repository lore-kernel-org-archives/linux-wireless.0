Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59428 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbeHHHLg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 03:11:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Kees Cook <keescook@chromium.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-drivers] mt76x0: Remove VLA usage
References: <20180807225040.GA2164@beast>
Date: Wed, 08 Aug 2018 07:53:44 +0300
In-Reply-To: <20180807225040.GA2164@beast> (Kees Cook's message of "Tue, 7 Aug
        2018 15:50:40 -0700")
Message-ID: <87600l4fxj.fsf@kamboji.qca.qualcomm.com> (sfid-20180808_065517_968841_BEF9FD3D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kees Cook <keescook@chromium.org> writes:

> Even with "const" variables, the compiler will generate warnings about
> VLA usage. In the quest to remove all VLAs from the kernel[1], this uses
> a #define instead of a const to do the array sizing.
>
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>
> Fixes: e87b5039511a ("mt76x0: eeprom files")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Please include this for the v4.19 merge window. The VLA was introduced
> with the new source file (which I also note is missing a SPDX line), so
> I'd like to avoid the kernel ever getting released with a VLA here.

Ok, I'll push this to v4.19.

-- 
Kalle Valo
