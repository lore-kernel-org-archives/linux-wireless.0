Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:57137 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752766AbeFNGkc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 02:40:32 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
CC: Ryan Grachek <ryan@edited.us>, Wei Xu <xuwei5@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH] arm64: dts: hikey: Define wl1835 power
   capabilities
Date: Thu, 14 Jun 2018 06:40:05 +0000
Message-ID: <ae036763950c4c9e80ceccc8c61e78dd@ti.com> (sfid-20180614_084037_109289_97FEC656)
References: <20180613151305.17240-1-ryan@edited.us>
        <CANcMJZASEDRxaXwdG96nNeEDPrDm_ap5MjhXonEcg=yHZ8F=qg@mail.gmail.com>
 <87tvq6a577.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87tvq6a577.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >> These properties are required for compatibility with runtime PM.
> >> Without these properties, MMC host controller will not be aware
> >> of power capabilities. When the wlcore driver attempts to power
> >> on the device, it will erroneously fail with -EACCES.
> >>
> >> Signed-off-by: Ryan Grachek <ryan@edited.us>
> >
> > Fixes: 60f36637bbbd ("wlcore: sdio: allow pm to handle sdio power")
> > Tested-by: John Stultz <john.stultz@linaro.org>
> > Acked-by: John Stultz <john.stultz@linaro.org>
> >
> > Wei Xu: This fixes a functional regression with wifi on the HiKey
> > board that was introduced in 4.18-rc with commit 60f36637bbbd
> > ("wlcore: sdio: allow pm to handle sdio power").
> >
> > Could you please be sure to queue this for the 4.18-rc ?
>=20
> Adding linux-wireless so that wireless folks are aware of this wlcore
> regression fix as well.
>=20
Actually  "cap-power-off-card" is normally included with all .dts files sup=
porting wilink=20
So it should have been there from the start for this board as well.=20
It probably worked without it due to the explicit call to mmc_power_restore=
_host()
that was there as an old workaround for trying to control the power explici=
tly from the
driver which was actually causing other failures on suspend/resume as the m=
mc layer=20
already power the module on resume.
"keep-power-in-suspend" is needed in case of planning to use "WoWLAN":
Iw phy0 wowlan enable....

Best Regards,
Eyal
