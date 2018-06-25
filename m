Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33479 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbeFYHn4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 03:43:56 -0400
Received: by mail-qk0-f194.google.com with SMTP id c131-v6so6995946qkb.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2018 00:43:56 -0700 (PDT)
Subject: Re: [PATCHv2 5/5] arm64: allwinner: a64: Add support for TERES-I
 laptop
To: Harald Geyer <harald@ccbib.org>, Icenowy Zheng <icenowy@aosc.io>
References: <20180315162510.11669-1-harald@ccbib.org>
 <20180315162510.11669-6-harald@ccbib.org>
 <a7011fe78d171658742406bf01d50b7e3d7eaf1d.camel@aosc.io>
 <E1fX7yK-0000OC-HA@stardust.g4.wien.funkfeuer.at>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andre Przywara <andre.przywara@arm.com>, info@olimex.com,
        linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B309D37.80207@broadcom.com> (sfid-20180625_094441_228451_BDEF2264)
Date: Mon, 25 Jun 2018 09:43:51 +0200
MIME-Version: 1.0
In-Reply-To: <E1fX7yK-0000OC-HA@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/24/2018 6:34 PM, Harald Geyer wrote:
> Icenowy Zheng writes:
>> >在 2018-03-15四的 16:25 +0000，Harald Geyer写道：
>>> > >+&mmc1 {
>>> > >+	pinctrl-names = "default";
>>> > >+	pinctrl-0 = <&mmc1_pins>;
>>> > >+	vmmc-supply = <&reg_aldo2>;
>>> > >+	vqmmc-supply = <&reg_dldo4>;
>>> > >+	mmc-pwrseq = <&wifi_pwrseq>;
>>> > >+	bus-width = <4>;
>>> > >+	non-removable;
>>> > >+	status = "okay";
>>> > >+
>>> > >+	rtl8723bs: wifi@1 {
>>> > >+		reg = <1>;
>>> > >+		interrupt-parent = <&r_pio>;
>>> > >+		interrupts = <0 3 IRQ_TYPE_LEVEL_LOW>; /* PL3 */
>>> > >+		interrupt-names = "host-wake";
>>> > >+	};

[...]

>> >- This device node has no binding. The "host-wake" interrupt is part of
>> >  Broadcom SDIO Wi-Fi binding, rather than a generic one.
> I think the general mmc and interrupts bindings apply. And the mmc binding
> clearly states that for sub-nodes a compatible string is optional.
>
> However I just realized that the 'interrupt-names' property is not part
> of the general interrupts binding, so I guess at least this property should
> be removed.

Indeed. If the device just used the SDIO interrupt this is not needed. 
The Broadcom device can use either SDIO interrupt or a so-called 
out-of-band host-wake interrupt, which is what the above represents.

Regards,
Arend
