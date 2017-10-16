Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55690 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbdJPM61 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 08:58:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: icenowy@aosc.io
Cc: devicetree@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/2] dt-bindings: add device tree binding for Allwinner XR819 SDIO Wi-Fi
References: <20171003165944.13056-1-icenowy@aosc.io>
        <20171003165944.13056-2-icenowy@aosc.io>
        <871smjxp46.fsf@kamboji.qca.qualcomm.com>
        <E46F3A20-294A-497E-AF71-C77A67AFDB8C@aosc.io>
        <59D4B1C8.8020105@broadcom.com> <20171004101145.kgjufpcktodppuy3@flea>
        <C4895259-FCDE-4B21-BB15-8F150FC53BE3@aosc.io>
        <878tgq5beu.fsf@codeaurora.org>
        <dba5f095f9f25f0726ee3a2852e01b88@aosc.io>
Date: Mon, 16 Oct 2017 15:58:20 +0300
In-Reply-To: <dba5f095f9f25f0726ee3a2852e01b88@aosc.io> (icenowy@aosc.io's
        message of "Sat, 14 Oct 2017 20:00:52 +0800")
Message-ID: <87o9p7meqb.fsf@kamboji.qca.qualcomm.com> (sfid-20171016_145850_455508_EEC99DFD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

icenowy@aosc.io writes:

>>>>> > > Like I asked already last time, AFAICS there is no upstream xr819
>>>>> > > wireless driver in drivers/net/wireless directory. Do we still
>>>> accept
>>>>> > > bindings like this for out-of-tree drivers?
>>>>> >
>>>>> > See esp8089.
>>>>> >
>>>>> > There's also no in-tree driver for it.
>>>>>
>>>>> The question is whether we should. The above might be a precedent,
>>>> but it
>>>>> may not necessarily be the way to go. The commit message for esp8089
>>>> seems
>>>>> to hint that there is intent to have an in-tree driver:
>>>>>
>>>>> """
>>>>>     Note that at this point there only is an out of tree driver for
>>>> this
>>>>>     hardware, there is no clear timeline / path for merging this.
>>>> Still
>>>>>     I believe it would be good to specify the binding for this in
>>>> tree
>>>>>     now, so that any future migration to an in tree driver will not
>>>> cause
>>>>>     compatiblity issues.
>>>>>
>>>>>     Cc: Icenowy Zheng <icenowy@aosc.xyz>
>>>>>     Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>>     Signed-off-by: Rob Herring <robh@kernel.org>
>>>>> """
>>>>>
>>>>> Regardless the bindings are in principle independent of the kernel
>>>> and just
>>>>> describing hardware. I think there have been discussions to move the
>>>>> bindings to their own repository, but apparently it was decided
>>>> otherwise.
>>>>
>>>> Yeah, I guess especially how it could be merged with the cw1200
>>>> driver
>>>> would be very relevant to that commit log.
>>>
>>> The cw1200 driver seems to still have some legacy platform
>>> data. Maybe they should also be convert to DT.
>>> (Or maybe compatible = "allwinner,xr819" is enough, as
>>> xr819 is a specified variant of cw1200 family)
>>
>> Ah, so the upstream cw1200 driver supports xr819? Has anyone tested
>> that? Or does cw1200 more changes than just adding the DT support?
>
> The support of XR819 in CW1200 driver is far more difficult than I
> imagined -- the codedrop used in the mainlined CW1200 driver seems to
> be so old that it's before XR819 (which seems to be based on CW1160),
> and there's a large number of problems to adapt it to a modern CW1200
> variant.
>
> P.S. could you apply this device tree binding patch now?

As I haven't seen any consensus that applying bindings document for
out-of-tree drivers is ok so at least I'm not taking this. Though not
sure what DT maintainers are planning to do.

-- 
Kalle Valo
