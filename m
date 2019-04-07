Return-Path: <SRS0=5Jnr=SJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD18DC282DE
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Apr 2019 15:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8156720880
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Apr 2019 15:30:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JGtTZR4Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfDGPaU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Apr 2019 11:30:20 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42757 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfDGPaT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Apr 2019 11:30:19 -0400
Received: by mail-yw1-f67.google.com with SMTP id e76so4056287ywa.9;
        Sun, 07 Apr 2019 08:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ixHI/QSIq6h0wFos1VtE91H10sU7YXkJq6lUNwuj4Zw=;
        b=JGtTZR4QU6ytZyBR73Tpxn/GbgBMB1+ZnT0/WvxMr9SDQTl8dEFOb1XpUrNk8LMpoM
         jKLE2SIR00UlWAgtiVPNYVxx+Zr0fxQb2vPmi8nf8X2uWH6+4nE/YFPmDLbSooZFq2pu
         CamDuzbnXr/4WfcvGcXfJLf/Fjg/41OcPINBdrc6nwWeuYdXoXuU39SOTtn8TYmKnCtp
         gVq4JzqoQqTZRdq1lJ2ju/bGP2EFHXkyzeCEp3z12SYhMoAOp05tge3oRMGLNeJHTI/q
         VxRcF0qYTt3mLTmkioZeQ/zOKBcOQFHpHwFEKqr5JmSwPK71PILFNY+iLpsymvYJ8Sts
         SAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ixHI/QSIq6h0wFos1VtE91H10sU7YXkJq6lUNwuj4Zw=;
        b=Bc0VE8WVOhzXIaPnBJEq+lubaOS6qkDiwapSXCTxL0gsArirt2BcHvIZC/w5m43N8D
         z01CMgyczxQ4u6k3mKV6HwgNz17K8zz1jg++RecB8DMRtwGSPdsqnUFua4yFoHgGnQxs
         7aElNQFM2nu7pzurbE/VyAxPjaNy8SGMO7ZOreU1gALMmY8Wuzcr6JKIkvWhXM9GLGGk
         r5mei8iNf49snYcwOBhLelIg+XNak2PeAJTPXI/GtAcxp2jQ7vSW9su+3SJ6Qpfa6mNE
         u8jAB3HnaEF+qWupUBjwSMRSiND3LdFxDnSmpjYqSDDXym9J8rkCJuc43w72taND6tdI
         DaDw==
X-Gm-Message-State: APjAAAVqLxkfoB+fn1nFrxnX/FGJn55NMI4APWnmtnst+T+13HpeyJjD
        oRdkvLD8Fj8S/xSdeBGUumvO7nJrShdLxO5IvN4=
X-Google-Smtp-Source: APXvYqy813tFP5IYoAZ1SpWytDUBaZgQyG5WIOziWnfsm7qhMhv229R7yvdIFlaS8twfxPvFmzJL8/v79HK1LDLd7gs=
X-Received: by 2002:a81:7509:: with SMTP id q9mr19890761ywc.216.1554651018137;
 Sun, 07 Apr 2019 08:30:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190405234514.6183-1-megous@megous.com> <20190405234514.6183-13-megous@megous.com>
In-Reply-To: <20190405234514.6183-13-megous@megous.com>
From:   =?UTF-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>
Date:   Sun, 7 Apr 2019 17:31:52 +0200
Message-ID: <CAJiuCcdRHj56p_KFRhK8H9xO+M3ycNp1Jpzw_QWcKQZorcKGpA@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH 12/12] arm64: dts: allwinner: orange-pi-3:
 Enable WiFi
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com,
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
        dri-devel@lists.freedesktop.org,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Sat, 6 Apr 2019 at 01:45, megous via linux-sunxi
<linux-sunxi@googlegroups.com> wrote:
>
> From: Ondrej Jirman <megous@megous.com>
>
> Orange Pi 3 has AP6256 WiFi/BT module. WiFi part of the module is
> called bcm43356 and can be used with the brcmfmac driver. The module
> is powered by the two always on regulators (not AXP805).
>
> WiFi uses a PG port with 1.8V voltage level signals. SoC needs to be
> configured so that it sets up an 1.8V input bias on this port. This is
> done by the pio driver by reading the vcc-pg-supply voltage.
>
> You'll need a fw_bcm43456c5_ag.bin firmware file and nvram.txt
> configuration that can be found in the Xulongs's repository for H6:
>
> https://github.com/orangepi-xunlong/OrangePiH6_external/tree/master/ap6256
>
> Mainline brcmfmac driver expects the firmware and nvram at the
> following paths relative to the firmware directory:
>
>   brcm/brcmfmac43456-sdio.bin
>   brcm/brcmfmac43456-sdio.txt
>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 48 +++++++++++++++++++
>  1 file changed, 48 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> index 5270142527f5..6a201829bb62 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> @@ -66,6 +66,26 @@
>                 regulator-always-on;
>         };
>
> +       reg_vcc33_wifi: vcc33-wifi {
> +               /* Always on 3.3V regulator for WiFi and BT */
> +               compatible = "regulator-fixed";
> +               regulator-name = "vcc33-wifi";
> +               regulator-min-microvolt = <3300000>;
> +               regulator-max-microvolt = <3300000>;
> +               regulator-always-on;
> +                vin-supply = <&reg_vcc5v>;
> +       };
> +
> +       reg_vcc_wifi_io: vcc-wifi-io {
> +               /* Always on 1.8V/300mA regulator for WiFi and BT IO */
> +               compatible = "regulator-fixed";
> +               regulator-name = "vcc-wifi-io";
> +               regulator-min-microvolt = <1800000>;
> +               regulator-max-microvolt = <1800000>;
> +               regulator-always-on;
> +                vin-supply = <&reg_vcc33_wifi>;
> +       };
> +
>         /*
>          * The board uses 2.5V RGMII signalling. Power sequence
>          * to enable the phy is to enable GMAC-2V5 and GMAC-3V3 (aldo2)
> @@ -86,6 +106,14 @@
>                   */
>                  vin-supply = <&reg_aldo2>; /* GMAC-3V3 */
>          };
> +
> +       wifi_pwrseq: wifi_pwrseq {
> +               compatible = "mmc-pwrseq-simple";
> +               clocks = <&rtc 1>;

Maybe I missed something, but the RTC in H6 is not yet available :
https://lkml.org/lkml/2018/10/31/822

Regards,
Clement

> +               clock-names = "ext_clock";
> +               reset-gpios = <&r_pio 1 3 GPIO_ACTIVE_LOW>; /* PM3 */
> +               post-power-on-delay-ms = <200>;
> +       };
>  };
>
>  &cpu0 {
> @@ -146,6 +174,25 @@
>         status = "okay";
>  };
>
> +&mmc1 {
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&mmc1_pins>;
> +       vmmc-supply = <&reg_vcc33_wifi>;
> +       vqmmc-supply = <&reg_vcc_wifi_io>;
> +       mmc-pwrseq = <&wifi_pwrseq>;
> +       bus-width = <4>;
> +       non-removable;
> +       status = "okay";
> +
> +       brcm: sdio-wifi@1 {
> +               reg = <1>;
> +               compatible = "brcm,bcm4329-fmac";
> +               interrupt-parent = <&r_pio>;
> +               interrupts = <1 0 IRQ_TYPE_LEVEL_LOW>; /* PM0 */
> +               interrupt-names = "host-wake";
> +       };
> +};
> +
>  &ohci0 {
>         status = "okay";
>  };
> @@ -157,6 +204,7 @@
>  &pio {
>         vcc-pc-supply = <&reg_bldo2>;
>         vcc-pd-supply = <&reg_cldo1>;
> +       vcc-pg-supply = <&reg_vcc_wifi_io>;
>  };
>
>  &r_i2c {
> --
> 2.21.0
>
> --
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
