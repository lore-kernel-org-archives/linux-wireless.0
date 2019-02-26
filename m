Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA537C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 16:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B0DC2173C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 16:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ndu29BT6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbfBZQWB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 11:22:01 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:54456 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbfBZQWA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 11:22:00 -0500
Received: by mail-it1-f193.google.com with SMTP id w18so4667334itj.4
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2019 08:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NKqd0gJ+FjQE644QZeYOhYWnNjhb8KLh1cAPylR2kwQ=;
        b=Ndu29BT6k9PQGhWxmPMQNCVP+xixHK40OdQ/K/6V0FJjVz8dUP9LTbIx7042K3fsja
         SCp5fPWur+gvQnber+IjktUjU+K4SE9+yR8/oUZSyHbS/qHTkVnk57eaUH/p+NkrtFDe
         kgsj4GePNS90fzkV9U6ytKZbzDDLo4yiCqBvWEC636mukyIA/T0s9p9QOYB0PqaLGoBA
         POmXqxrmufNJbWwA40rIPPN5eF0tA3VjPQIzatjTNv5hjPYCcUZgJyzirOw26EQlEO4E
         RHpCT4dOPvXEU6Al2hCnednhfUoKbsSvQFuLY1YS9P8jsR6dOcB0KOww5OBn6J9fjwS3
         AoXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NKqd0gJ+FjQE644QZeYOhYWnNjhb8KLh1cAPylR2kwQ=;
        b=qlhwuqEdjlrZbeQhAQCIi7rbsuITkqo7wmYPTbUG1egduwBQTnJr4z1GhPB3RiPYqM
         NbBVzI1uyCgye+2Irl1NMETva+riDkAq+jtWi04B+2c7hTOdRwpQ9e3XHidhk8dI9+S7
         ZaTizfbCVRGxzEHyEKqxhuh8qS1zPBVUcFpK/j/Q0K0w5SgDPDap3Hll0ToTt1Dshekj
         EEMS1zrqxOyetMgDO2U7jAlxaScRWhcAcPt+7LmNH8IfY2hRsU9CkBHwzuw9T/GjbtJB
         7rOdS+1uQOTktLd87kng648ecI/quSpuG1pYmISCk29Zp3Wjil/Q3HGeK335HI4lTWGy
         hW7Q==
X-Gm-Message-State: AHQUAubFzgBPK1ui9+gC3yz2X9aTHi/D3Yt6jj2pv0OO7LuElKkwa0lD
        JY7K/KZyTDiexxBn9VUtZsV7081lcwvPTsQK1GHnpg==
X-Google-Smtp-Source: AHgI3IYn0kUmFJAD5WGV84GxKV2IOkWMSNAfMfEWhXCCWBFMIfTvKwzdFFwOkNF99jXeOgRb5gyf2lj5tO8/02t+rm0=
X-Received: by 2002:a02:568a:: with SMTP id u10mr13543781jad.130.1551198119627;
 Tue, 26 Feb 2019 08:21:59 -0800 (PST)
MIME-Version: 1.0
References: <20190224140426.3267-1-marc.zyngier@arm.com> <CAKv+Gu9OOzOxx0rTAZqM8r4q_hRmOp3b=KP7fwgNeiu67FCApA@mail.gmail.com>
 <5310b73b-4821-6dff-b9c0-34c59fb7fd72@arm.com>
In-Reply-To: <5310b73b-4821-6dff-b9c0-34c59fb7fd72@arm.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 26 Feb 2019 17:21:48 +0100
Message-ID: <CAKv+Gu_=bQyVZqgUnJm9moCcaCcpDrag6NWGEpaR65=pMiTFJQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] mwifiex PCI/wake-up interrupt fixes
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 25 Feb 2019 at 15:53, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> Hi Ard,
>
> On 25/02/2019 12:45, Ard Biesheuvel wrote:
> > On Sun, 24 Feb 2019 at 15:08, Marc Zyngier <marc.zyngier@arm.com> wrote:
> >>
> >> For quite some time, I wondered why the PCI mwifiex device built in my
> >> Chromebook was unable to use the good old legacy interrupts. But as MSIs
> >> were working fine, I never really bothered investigating. I finally had a
> >> look, and the result isn't very pretty.
> >>
> >> On this machine (rk3399-based kevin), the wake-up interrupt is described as
> >> such:
> >>
> >> &pci_rootport {
> >>         mvl_wifi: wifi@0,0 {
> >>                 compatible = "pci1b4b,2b42";
> >>                 reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
> >>                        0x83010000 0x0 0x00100000 0x0 0x00100000>;
> >>                 interrupt-parent = <&gpio0>;
> >>                 interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
> >>                 pinctrl-names = "default";
> >>                 pinctrl-0 = <&wlan_host_wake_l>;
> >>                 wakeup-source;
> >>         };
> >> };
> >>
> >> Note how the interrupt is part of the properties directly attached to the
> >> PCI node. And yet, this interrupt has nothing to do with a PCI legacy
> >> interrupt, as it is attached to the wake-up widget that bypasses the PCIe RC
> >> altogether (Yay for the broken design!). This is in total violation of the
> >> IEEE Std 1275-1994 spec[1], which clearly documents that such interrupt
> >> specifiers describe the PCI device interrupts, and must obey the
> >> INT-{A,B,C,D} mapping. Oops!
> >>
> >
> > The mapping of legacy PCIe INTx interrupts onto wired system
> > interrupts is a property of the PCIe host controller, not of a
> > particular PCIe device. So I would argue that the code is broken here
> > as well: it should never attempt to interpret 'interrupt' properties
> > at the PCI device level as having any bearing on how legacy interrupts
> > are routed.
>
> OpenFirmware says that this node contains the interrupt number of the
> device (4.1.1. Open Firmware-defined Properties for Child Nodes). The
> trick is that this property is generated *from* the device, and not set
> in stone.
>
> DT, on the other hand, takes whatever is described there and uses it as
> the gospel to configure the OS, no matter how the PCI device is actually
> configured. If the two don't match (like in this case), things break.
> This is the "DT describes the HW" mantra, for (sometimes) better or
> (more generally) worse.
>
> What the DT code does is to interpret the whole interrupt specifier,
> *including the interrupt-parent*. And that feels wrong. It should always
> be in the context of the host controller. But on the other side, the DT
> code is not in the business of validating the DT either...
>
> It outlines one thing: If you have to interpret per-device PCI
> properties from DT, you're in for serious trouble. I should get some
> better HW.
>

Yeah, it obviously makes no sense at all for the interrupt parent of a
PCI device to deviate from the host bridge's interrupt parent, and
it's quite unfortunate that we can't simply ban it now that the cat is
out of the bag already.

Arguably, the wake up widget is not part of the PCI device, but I have
no opinion as to whether it is better modeling it as a sub device as
you are proposing or as an entirely separate device referenced via a
phandle.
