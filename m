Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47676 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752831AbeFNGU0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 02:20:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Ryan Grachek <ryan@edited.us>, Wei Xu <xuwei5@hisilicon.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list\:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        linux-arm-kernel@lists.infradead.org, Eyal Reizer <eyalr@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: hikey960: Define wl1837 power capabilities
References: <20180613180321.16745-1-ryan@edited.us>
        <CALAqxLWuUJYfXszaO01KODbom8WykKQKm0X3fzPTwSRK+G3zqw@mail.gmail.com>
Date: Thu, 14 Jun 2018 09:20:18 +0300
In-Reply-To: <CALAqxLWuUJYfXszaO01KODbom8WykKQKm0X3fzPTwSRK+G3zqw@mail.gmail.com>
        (John Stultz's message of "Wed, 13 Jun 2018 12:36:40 -0700")
Message-ID: <874li5c2jh.fsf@purkki.adurom.net> (sfid-20180614_082124_467687_5A303668)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John Stultz <john.stultz@linaro.org> writes:

> On Wed, Jun 13, 2018 at 11:03 AM, Ryan Grachek <ryan@edited.us> wrote:
>> These properties are required for compatibility with runtime PM.
>> Without these properties, MMC host controller will not be aware
>> of power capabilities. When the wlcore driver attempts to power
>> on the device, it will erroneously fail with -EACCES. This fixes
>> a regression found here: https://lkml.org/lkml/2018/6/12/930
>>
>> Signed-off-by: Ryan Grachek <ryan@edited.us>
>
> Fixes: 60f36637bbbd ("wlcore: sdio: allow pm to handle sdio power")
> Tested-by: John Stultz <john.stultz@linaro.org>
> Acked-by: John Stultz <john.stultz@linaro.org>
>
> Wei Xu: This also fixes a functional regression with wifi on the
> HiKey960 board that was introduced in 4.18-rc with commit 60f36637bbbd
> ("wlcore: sdio: allow pm to handle sdio power").
>
> Could you please be sure to queue this for the 4.18-rc too?

CCing wireless folks as well.

-- 
Kalle Valo
