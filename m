Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46486 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbeFYV4D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 17:56:03 -0400
Received: by mail-wr0-f196.google.com with SMTP id l14-v6so10074923wrq.13
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2018 14:56:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANcMJZASEDRxaXwdG96nNeEDPrDm_ap5MjhXonEcg=yHZ8F=qg@mail.gmail.com>
References: <20180613151305.17240-1-ryan@edited.us> <CANcMJZASEDRxaXwdG96nNeEDPrDm_ap5MjhXonEcg=yHZ8F=qg@mail.gmail.com>
From: John Stultz <john.stultz@linaro.org>
Date: Mon, 25 Jun 2018 14:56:02 -0700
Message-ID: <CALAqxLWjJKsU+XJmANzx-aO2ruszwbBnPV2yV5WoyVStO+5K0A@mail.gmail.com> (sfid-20180625_235624_067561_1F8C6468)
Subject: Re: [PATCH] arm64: dts: hikey: Define wl1835 power capabilities
To: Ryan Grachek <ryan@edited.us>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Wei Xu <xuwei5@hisilicon.com>, Eyal Reizer <eyalr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2018 at 11:30 AM, John Stultz <john.stultz@linaro.org> wrote:
> On Wed, Jun 13, 2018 at 8:13 AM, Ryan Grachek <ryan@edited.us> wrote:
>> These properties are required for compatibility with runtime PM.
>> Without these properties, MMC host controller will not be aware
>> of power capabilities. When the wlcore driver attempts to power
>> on the device, it will erroneously fail with -EACCES.
>>
>> Signed-off-by: Ryan Grachek <ryan@edited.us>
>
> Fixes: 60f36637bbbd ("wlcore: sdio: allow pm to handle sdio power")
> Tested-by: John Stultz <john.stultz@linaro.org>
> Acked-by: John Stultz <john.stultz@linaro.org>
>
> Wei Xu: This fixes a functional regression with wifi on the HiKey
> board that was introduced in 4.18-rc with commit 60f36637bbbd
> ("wlcore: sdio: allow pm to handle sdio power").

Wei Xu: Just wanted to follow up to make sure this wasn't missed for
4.18-rc, as I haven't seen it upstream or in -next, and it fixes a
recently introduced regression.

thanks
-john
