Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39115 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935695AbeFMTgm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 15:36:42 -0400
Received: by mail-wm0-f66.google.com with SMTP id p11-v6so7539213wmc.4
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2018 12:36:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180613180321.16745-1-ryan@edited.us>
References: <20180613180321.16745-1-ryan@edited.us>
From: John Stultz <john.stultz@linaro.org>
Date: Wed, 13 Jun 2018 12:36:40 -0700
Message-ID: <CALAqxLWuUJYfXszaO01KODbom8WykKQKm0X3fzPTwSRK+G3zqw@mail.gmail.com> (sfid-20180613_213705_414001_202595F8)
Subject: Re: [PATCH] arm64: dts: hikey960: Define wl1837 power capabilities
To: Ryan Grachek <ryan@edited.us>, Wei Xu <xuwei5@hisilicon.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        linux-arm-kernel@lists.infradead.org, Eyal Reizer <eyalr@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2018 at 11:03 AM, Ryan Grachek <ryan@edited.us> wrote:
> These properties are required for compatibility with runtime PM.
> Without these properties, MMC host controller will not be aware
> of power capabilities. When the wlcore driver attempts to power
> on the device, it will erroneously fail with -EACCES. This fixes
> a regression found here: https://lkml.org/lkml/2018/6/12/930
>
> Signed-off-by: Ryan Grachek <ryan@edited.us>

Fixes: 60f36637bbbd ("wlcore: sdio: allow pm to handle sdio power")
Tested-by: John Stultz <john.stultz@linaro.org>
Acked-by: John Stultz <john.stultz@linaro.org>

Wei Xu: This also fixes a functional regression with wifi on the
HiKey960 board that was introduced in 4.18-rc with commit 60f36637bbbd
("wlcore: sdio: allow pm to handle sdio power").

Could you please be sure to queue this for the 4.18-rc too?

thanks
-john
