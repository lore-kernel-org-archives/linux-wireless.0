Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57377C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A60420883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="b3HUt1y5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfDIIib (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 04:38:31 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33207 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfDIIia (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 04:38:30 -0400
Received: by mail-io1-f68.google.com with SMTP id b6so13576163iog.0
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 01:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hr0F5S+XzCD5idVwYm4YlXT0ZQ48Tzc2AUxRkYlWLt0=;
        b=b3HUt1y5APEE+bVngHS7/hqwuEuoZr5jU+BN9RSsc6yAS6tSfYUu/FMhV+qLtKtFoA
         BDKAP/hK+y9Ys+lME3TAxRlT+bPSQ/J/KWfYeocq8FZgqQF2dzgk9YohHXlHv1yhVIJB
         Twd2whkRTIdJsmLH5cueKWUAHuoi/GyUVnqpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hr0F5S+XzCD5idVwYm4YlXT0ZQ48Tzc2AUxRkYlWLt0=;
        b=bVax7+SZRs/lU2+4+lwYP9F43+9gcBqeeTeB/5Iy3M0a1sG4HL6loakuA43Ajtwzcs
         GCWhf7ZnKzTeqsqNyHagomnR+gw18bChtGSk1Lgme28bkWExTmfelGRkleZp/XntAO/3
         jbVlqKp0FUxFA1+QpkH+HVVr+sgcufAfcmbzUMwy4DfjZWi7eLRZeN9BYaKw8GhCgm/z
         dvLD+Jbc2Q2dDhPZBKPmROKpVC4XTx8UkH4MLR2qWgv/bVFDmBiNi04p25Z1oJbO7JSK
         feB3OULxQ3jxsjykP8tRbnyuD/+EyJfyEjsDx1tjQV0hHG9lvEKU6sSIC/GZ6AeVz7kS
         hc8w==
X-Gm-Message-State: APjAAAUJowSJC+G3dQQtJm4MUIsX9y1aJ242qFAlwOr9o2mDqzouWQpm
        6SmYSi4cO11hm14G/W/9iZ3ktde8oFqQBA/mvRLWxg==
X-Google-Smtp-Source: APXvYqy4gcARrrXnr06bFhPto4qWS5OzxSMNzk0PkAIwxZzg9F8eA3+vXxZ7ji7vtBkbuhDMtjSnIiVCATsQVI5iA+Q=
X-Received: by 2002:a5e:8202:: with SMTP id l2mr2112372iom.144.1554799109450;
 Tue, 09 Apr 2019 01:38:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190409002452.14551-1-megous@megous.com> <20190409002452.14551-3-megous@megous.com>
In-Reply-To: <20190409002452.14551-3-megous@megous.com>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Tue, 9 Apr 2019 14:08:18 +0530
Message-ID: <CAMty3ZBK2jPHTP4Y+hiy8Gq+Nx9iWYoUgke+BvopyzR8T6=0Xw@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 02/13] arm64: dts: allwinner: h6: Add
 Orange Pi 3 DTS
To:     megous@megous.com
Cc:     linux-sunxi <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Based on the conversation about using common dtsi from this thread[1],
I'm commenting here to make show the diff directly on the nodes,
giving comments on each node so-that we can see the diff globally.

On Tue, Apr 9, 2019 at 5:55 AM megous via linux-sunxi
<linux-sunxi@googlegroups.com> wrote:
>
> From: Ondrej Jirman <megous@megous.com>
>
> Orange Pi 3 is a H6 based SBC made by Xulong, released in January 2019. I=
t
> has the following features:
>
> - Allwinner H6 quad-core 64-bit ARM Cortex-A53
> - GPU Mali-T720
> - 1GB or 2GB LPDDR3 RAM
> - AXP805 PMIC
> - AP6256 Wifi/BT 5.0
> - USB 2.0 host port (A)
> - USB 2.0 micro usb, OTG
> - USB 3.0 Host + 4 port USB hub (GL3510)
> - Gigabit Ethernet (Realtek RTL8211E phy)
> - HDMI 2.0 port
> - soldered eMMC (optional)
> - 3x LED (one is on the bottom)
> - microphone
> - audio jack
> - PCIe
>
> Add basic support for the board.
>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  arch/arm64/boot/dts/allwinner/Makefile        |   1 +
>  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 216 ++++++++++++++++++
>  2 files changed, 217 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dt=
s
>
> diff --git a/arch/arm64/boot/dts/allwinner/Makefile b/arch/arm64/boot/dts=
/allwinner/Makefile
> index e4dce2f6fa3a..285a7cb5135b 100644
> --- a/arch/arm64/boot/dts/allwinner/Makefile
> +++ b/arch/arm64/boot/dts/allwinner/Makefile
> @@ -20,6 +20,7 @@ dtb-$(CONFIG_ARCH_SUNXI) +=3D sun50i-h5-orangepi-pc2.dt=
b
>  dtb-$(CONFIG_ARCH_SUNXI) +=3D sun50i-h5-orangepi-prime.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) +=3D sun50i-h5-orangepi-zero-plus.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) +=3D sun50i-h5-orangepi-zero-plus2.dtb
> +dtb-$(CONFIG_ARCH_SUNXI) +=3D sun50i-h6-orangepi-3.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) +=3D sun50i-h6-orangepi-lite2.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) +=3D sun50i-h6-orangepi-one-plus.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) +=3D sun50i-h6-pine-h64.dtb
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arc=
h/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> new file mode 100644
> index 000000000000..5fbc5e410883
> --- /dev/null
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> @@ -0,0 +1,216 @@
> +// SPDX-License-Identifier: (GPL-2.0+ or MIT)
> +/*
> + * Copyright (C) 2019 Ond=C5=99ej Jirman <megous@megous.com>
> + */
> +
> +/dts-v1/;
> +
> +#include "sun50i-h6.dtsi"
> +
> +#include <dt-bindings/gpio/gpio.h>
> +
> +/ {
> +       model =3D "OrangePi 3";
> +       compatible =3D "xunlong,orangepi-3", "allwinner,sun50i-h6";
> +
> +       aliases {
> +               serial0 =3D &uart0;
> +       };
> +
> +       chosen {
> +               stdout-path =3D "serial0:115200n8";
> +       };
> +
> +       leds {
> +               compatible =3D "gpio-leds";
> +
> +               power {
> +                       label =3D "orangepi:red:power";
> +                       gpios =3D <&r_pio 0 4 GPIO_ACTIVE_HIGH>; /* PL4 *=
/
> +                       default-state =3D "on";
> +               };
> +
> +               status {
> +                       label =3D "orangepi:green:status";
> +                       gpios =3D <&r_pio 0 7 GPIO_ACTIVE_HIGH>; /* PL7 *=
/
> +               };
> +       };
> +
> +       reg_vcc5v: vcc5v {
> +               /* board wide 5V supply directly from the DC jack */
> +               compatible =3D "regulator-fixed";
> +               regulator-name =3D "vcc-5v";
> +               regulator-min-microvolt =3D <5000000>;
> +               regulator-max-microvolt =3D <5000000>;
> +               regulator-always-on;
> +       };
> +};

all above nodes are common to all h6 opi boards.

> +
> +&cpu0 {
> +       cpu-supply =3D <&reg_dcdca>;
> +};
> +
> +&ehci0 {
> +       status =3D "okay";
> +};
> +
> +&ehci3 {
> +       status =3D "okay";
> +};

common to all h6 opi boards.

> +
> +&mmc0 {
> +       pinctrl-names =3D "default";
> +       pinctrl-0 =3D <&mmc0_pins>;
> +       vmmc-supply =3D <&reg_cldo1>;
> +       cd-gpios =3D <&pio 5 6 GPIO_ACTIVE_LOW>; /* PF6 */
> +       bus-width =3D <4>;
> +       status =3D "okay";
> +};

common to all h6 opi boards.

> +
> +&ohci0 {
> +       status =3D "okay";
> +};
> +
> +&ohci3 {
> +       status =3D "okay";
> +};

common to all h6 opi boards.

> +
> +&pio {
> +       vcc-pc-supply =3D <&reg_bldo2>;
> +       vcc-pd-supply =3D <&reg_cldo1>;
> +};
> +
> +&r_i2c {
> +       status =3D "okay";
> +
> +       axp805: pmic@36 {
> +               compatible =3D "x-powers,axp805", "x-powers,axp806";
> +               reg =3D <0x36>;
> +               interrupt-parent =3D <&r_intc>;
> +               interrupts =3D <0 IRQ_TYPE_LEVEL_LOW>;
> +               interrupt-controller;
> +               #interrupt-cells =3D <1>;
> +               x-powers,self-working-mode;
> +               vina-supply =3D <&reg_vcc5v>;
> +               vinb-supply =3D <&reg_vcc5v>;
> +               vinc-supply =3D <&reg_vcc5v>;
> +               vind-supply =3D <&reg_vcc5v>;
> +               vine-supply =3D <&reg_vcc5v>;
> +               aldoin-supply =3D <&reg_vcc5v>;
> +               bldoin-supply =3D <&reg_vcc5v>;
> +               cldoin-supply =3D <&reg_vcc5v>;

all these supply voltage regulators are common to h6 opi boards.

> +
> +               regulators {
> +                       reg_aldo1: aldo1 {
> +                               regulator-always-on;
> +                               regulator-min-microvolt =3D <3300000>;
> +                               regulator-max-microvolt =3D <3300000>;
> +                               regulator-name =3D "vcc-pl-led-ir";
> +                       };

same like other h6 boards.

> +
> +                       reg_aldo2: aldo2 {
> +                               regulator-min-microvolt =3D <3300000>;
> +                               regulator-max-microvolt =3D <3300000>;
> +                               regulator-name =3D "vcc33-audio-tv-ephy-m=
ac";
> +                       };

rest of h6 opi boards used it for vcc-ac200, we may append ac200 and
make it common since the voltage is same.

> +
> +                       /* ALDO3 is shorted to CLDO1 */
> +                       reg_aldo3: aldo3 {
> +                               regulator-always-on;
> +                               regulator-min-microvolt =3D <3300000>;
> +                               regulator-max-microvolt =3D <3300000>;
> +                               regulator-name =3D "vcc33-io-pd-emmc-sd-u=
sb-uart-1";
> +                       };

same like above regulator.

> +
> +                       reg_bldo1: bldo1 {
> +                               regulator-always-on;
> +                               regulator-min-microvolt =3D <1800000>;
> +                               regulator-max-microvolt =3D <1800000>;
> +                               regulator-name =3D "vcc18-dram-bias-pll";

same like other h6 boards.

> +                       };
> +
> +                       reg_bldo2: bldo2 {
> +                               regulator-always-on;
> +                               regulator-min-microvolt =3D <1800000>;
> +                               regulator-max-microvolt =3D <1800000>;
> +                               regulator-name =3D "vcc-efuse-pcie-hdmi-p=
c";
> +                       };

same like other h6 boards.

> +
> +                       bldo3 {
> +                               /* unused */
> +                       };

This is used in other h6 opi boards so we may attach status or
re-enable it on board dts file.

> +
> +                       bldo4 {
> +                               /* unused */
> +                       };

same like other h6 boards.

> +
> +                       reg_cldo1: cldo1 {
> +                               regulator-always-on;
> +                               regulator-min-microvolt =3D <3300000>;
> +                               regulator-max-microvolt =3D <3300000>;
> +                               regulator-name =3D "vcc33-io-pd-emmc-sd-u=
sb-uart-2";
> +                       };

same like other h6 boards.

> +
> +                       cldo2 {
> +                               /* unused */
> +                       };
> +
> +                       cldo3 {
> +                               /* unused */
> +                       };

These two used for wifi, so we may define on board dts or attach
status property.

> +
> +                       reg_dcdca: dcdca {
> +                               regulator-always-on;
> +                               regulator-min-microvolt =3D <800000>;
> +                               regulator-max-microvolt =3D <1160000>;
> +                               regulator-name =3D "vdd-cpu";
> +                       };
> +
> +                       reg_dcdcc: dcdcc {
> +                               regulator-min-microvolt =3D <810000>;
> +                               regulator-max-microvolt =3D <1080000>;
> +                               regulator-name =3D "vdd-gpu";
> +                       };
> +
> +                       reg_dcdcd: dcdcd {
> +                               regulator-always-on;
> +                               regulator-min-microvolt =3D <960000>;
> +                               regulator-max-microvolt =3D <960000>;
> +                               regulator-name =3D "vdd-sys";
> +                       };
> +
> +                       reg_dcdce: dcdce {
> +                               regulator-always-on;
> +                               regulator-min-microvolt =3D <1200000>;
> +                               regulator-max-microvolt =3D <1200000>;
> +                               regulator-name =3D "vcc-dram";
> +                       };
> +
> +                       sw {
> +                               /* unused */
> +                       };

all above regulators are common to h6 boards.

> +               };
> +       };
> +};
> +
> +&uart0 {
> +       pinctrl-names =3D "default";
> +       pinctrl-0 =3D <&uart0_ph_pins>;
> +       status =3D "okay";
> +};
> +
> +&usb2otg {
> +       /*
> +        * Beware that this board will not automatically disconnect
> +        * VBUS from DCIN, when self-powered and used as a peripheral.
> +        */
> +       dr_mode =3D "otg";
> +       status =3D "okay";
> +};

above nodes uart0, usb2otg are common to h6 opi boards.

> +
> +&usb2phy {
> +       usb0_id_det-gpios =3D <&pio 2 15 GPIO_ACTIVE_HIGH>; /* PC15 */
> +       usb0_vbus-supply =3D <&reg_vcc5v>;
> +       usb3_vbus-supply =3D <&reg_vcc5v>;
> +       status =3D "okay";
> +};
> --

id detect pin can be differ, so we may move this on board specific dts.

Note: the emac node is also common between h6 opi boards.

[1] https://lkml.org/lkml/2019/4/5/857
