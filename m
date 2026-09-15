Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E4B3B4EB3
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487995; cv=none; b=pcCWqaNXVvJtxmug+pSc+V9Rwlxfz1QXC8ZmH/EaWVYNL8DHEl+YFOeRe3qcwWy1lE2Mater6UBlyp+6tu/uHLE+qUgFbsgkHx+JvRwQjghI3qI4Ix6JYVKvLUUYw4guTS4D3xdh12p7UBEnjdv2e3mqKaD1i3sLDQ5sn+C9L/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487995; c=relaxed/simple;
	bh=tu3isjCkJ9whd6wOUuxDJ+8nmbLRSLBlYLxu4cvur1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MxaIMuObwAUuhbF1zU+qagmJQtRX0truwq+dyOqiUd4A+jEqT+eB4vszlRgTGyeZdQGoTVxroRO9gWUIq2rx1BOxXEPkVHL62O/rXmRQQp3YGfp3PZU9kwYbufPdrlBhJYpYXgbxT2bwq/nAxKx2Gpq3IL4TmXJPiI0a9N1XJiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=JxXfR391; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="JxXfR391"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c17f382ff5so1300188b6e.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 08:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1789487989; x=1790092789; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u17cMuYGc5vtBTFcb6UewtH/WxUd/WeV4HHc12mdl6E=;
        b=JxXfR391zYMFKrDJDhFG0LZHM2foJZUzxKIJhGS4A8uC5HhMG4HqnsOaWuiDb1iB1r
         NkW1Xh6vaFaqf3V3vvF6XfjXZ+mprMAvq1CPUv7Pul1Xw1PfRr9iDqAfeg3o1V8wdVAs
         olOkoNaj+tZQ8BerD6q7SsPc03yfsRiu3F5Mw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789487989; x=1790092789;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u17cMuYGc5vtBTFcb6UewtH/WxUd/WeV4HHc12mdl6E=;
        b=P4gBU+ykvf/o96c7Z4ACxA5EpZ6pIhbeW8ff9+8ONeKdyq++3sSb7YQklFUhNNutUK
         mnBdhpWrsy0BgFHmPHCRJlwzzzG+W2qBehFt+bSTA6UUDNgNLSoYJ9RfCgI3szb+9fOX
         25jBvpv5dFR3dQMs1Hif4VE+PIV0D39YvX4sVgyWUFCXSnCeBBXezO5cRPx2BMCnZPif
         7t2G8hH7Zu3wH7kIPleGx1NyCGcKfniWxOxuvZrLMA2U7uM7KzQRWwGtoofx9D4rYYLR
         MaHeZWdlVTXzr6UYNPk3wFUYeJeiQPspstmjv8xUXPg36E9Ssm+/GS413nx+F//7w0uO
         Kfyg==
X-Forwarded-Encrypted: i=1; AKwUvBzBSQhWmEY0WqEdsNMjFtDAbd+tyb4DgSBJqWWVJGq6RJU6QgMqUoCszMbLiQJUKK1HxUaZYqW/RcbYnEMtpw==@vger.kernel.org
X-Gm-Message-State: AFuF++mEOZOwX5SQfKpaNw2pKt8KtM303GTI1xDmyZ+LqNkH1NM/h7QY
	EoMK3QVpdm0z2Ep6w+4MGsuluZjVB7LzHUHX8Uopnjvzt3nOTUsLzs/5B6lJpzC5vg==
X-Gm-Gg: AYBFou03qa5dTrnO3SbcAnyRDYA+X4UKJhta4nH8zhk23+c6H/xi7Y8T2rKZ1QG+WiX
	V/JapOfAGpPZmTKi28BPKCNt0I7Q5TMWKTWzZaMfMx8y/dBbYQVPZ4iLQhzRrevFzajFRM0Nre7
	6O8+UMDXpl/hNwIo0Q4h6Pzo+e2HP1i0gJfP7uno5SPfdAk+GNaw+bUZ0G4pdK9YeZZCxk/ZCAf
	WvmdsgTGQUS2MgWSg5Iw85eYqolwr5u78Y3rFRNL4RQCkNB6svBvIW2gGk66w1iDWTEgRzuChza
	lizoO4xc46F72PREXGLi8qiXlQRW6DD5u8DUl8W7/YqJUttP52drqqqNTsvYe1W/c0+u6qtnULA
	9PwV7p11lqYTowf3+45hgAy2e3nTuoDKAvE1lt+bt7Hj7k33Vx2jZq6Lj0Le7Z+76hxf7MG7Vuo
	fclHBPG3/ikG3rv4mmHagGiLW5Rk8Tb5STfnLlKhPt7WBunQ/xUybRPdIE9nxsU+azRw==
X-Received: by 2002:a05:6808:1512:b0:4b9:a88b:888f with SMTP id 5614622812f47-4c7b5d89f12mr5055793b6e.37.1789487989169;
        Tue, 15 Sep 2026 08:59:49 -0700 (PDT)
Received: from [172.22.22.28] ([73.62.185.64])
        by smtp.googlemail.com with ESMTPSA id 586e51a60fabf-4842a33f8b2sm18328fac.14.2026.09.15.08.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 08:59:47 -0700 (PDT)
Message-ID: <28bbceed-ec75-4916-b579-f33f63bff5d4@ieee.org>
Date: Tue, 15 Sep 2026 10:59:44 -0500
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 net-next] dt-bindings: net: Use consistent indentation
 in the example
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
 Justin Chen <justin.chen@broadcom.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Hans Ulli Kroll <ulli.kroll@googlemail.com>,
 Linus Walleij <linusw@kernel.org>, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?=
 <clement.leger@bootlin.com>, Vladimir Oltean <olteanv@gmail.com>,
 Heiner Kallweit <hkallweit1@gmail.com>, Russell King
 <linux@armlinux.org.uk>, Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Felix Fietkau <nbd@nbd.name>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>,
 Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Jeff Johnson <jjohnson@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Magnus Damm <magnus.damm@gmail.com>,
 "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
 Claudiu Manoil <claudiu.manoil@nxp.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Alex Elder <elder@kernel.org>, Siddharth Vadapalli <s-vadapalli@ti.com>,
 Roger Quadros <rogerq@kernel.org>, bcm-kernel-feedback-list@broadcom.com,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-renesas-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
 ath10k@lists.infradead.org
References: <20260914155645.112508-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
From: Alex Elder <elder@ieee.org>
In-Reply-To: <20260914155645.112508-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/14/26 10:56 AM, Krzysztof Kozlowski wrote:
> Correct indentation in the examples to consistent 2- or 4-spaces
> indentation to fix dt-check-style warnings ("example 0
> [indent-consistent] indent mismatch ...").  Preferred is 4-spaces, but
> re-indenting entire example just for that is too much churn.
> 
> In cortina,gemini-ethernet.yaml also drop the wrongly indented mdio bus,
> because it is not necessary for the example.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Overall looks good to me (but the IPA binding in particular is good).

Acked-by: Alex Elder <elder@riscstar.com>
> 
> ---
> 
> Changes in v2:
> 1. Mention mdio bus removal.
> ---
>   .../bindings/net/brcm,asp-v2.0.yaml           |  2 +-
>   .../bindings/net/cortina,gemini-ethernet.yaml | 52 ++++++--------
>   .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  4 +-
>   .../bindings/net/intel,dwmac-plat.yaml        |  6 +-
>   .../devicetree/bindings/net/mdio-gpio.yaml    | 16 ++---
>   .../bindings/net/mscc,vsc7514-switch.yaml     |  8 +--
>   .../devicetree/bindings/net/qcom,ipa.yaml     | 10 +--
>   .../bindings/net/realtek,rtl82xx.yaml         |  6 +-
>   .../bindings/net/socionext,uniphier-ave4.yaml | 32 ++++-----
>   .../bindings/net/ti,cpsw-switch.yaml          | 70 +++++++++----------
>   .../bindings/net/wireless/mediatek,mt76.yaml  | 32 ++++-----
>   .../bindings/net/wireless/qcom,ath10k.yaml    |  2 +-
>   12 files changed, 114 insertions(+), 126 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> index a3db6d594c8c..7fcc564e820c 100644
> --- a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> +++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> @@ -123,7 +123,7 @@ examples:
>               phy0: ethernet-phy@1 {
>                   reg = <1>;
>               };
> -       };
> +        };
>   
>           mdio@ce14 {
>               compatible = "brcm,asp-v2.1-mdio";
> diff --git a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
> index f0b5bea2458d..da9bc170cd54 100644
> --- a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
> +++ b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
> @@ -87,18 +87,6 @@ examples:
>       #include <dt-bindings/interrupt-controller/irq.h>
>       #include <dt-bindings/clock/cortina,gemini-clock.h>
>       #include <dt-bindings/reset/cortina,gemini-reset.h>
> -    mdio0: mdio {
> -      #address-cells = <1>;
> -      #size-cells = <0>;
> -      phy0: ethernet-phy@1 {
> -        reg = <1>;
> -        device_type = "ethernet-phy";
> -      };
> -      phy1: ethernet-phy@3 {
> -        reg = <3>;
> -        device_type = "ethernet-phy";
> -      };
> -    };
>   
>       ethernet@60000000 {
>           compatible = "cortina,gemini-ethernet";
> @@ -110,28 +98,28 @@ examples:
>           ranges;
>   
>           gmac0: ethernet-port@0 {
> -                compatible = "cortina,gemini-ethernet-port";
> -                reg = <0x60008000 0x2000>, /* Port 0 DMA/TOE */
> -                      <0x6000a000 0x2000>; /* Port 0 GMAC */
> -                interrupt-parent = <&intcon>;
> -                interrupts = <1 IRQ_TYPE_LEVEL_HIGH>;
> -                resets = <&syscon GEMINI_RESET_GMAC0>;
> -                clocks = <&syscon GEMINI_CLK_GATE_GMAC0>;
> -                clock-names = "PCLK";
> -                phy-mode = "rgmii";
> -                phy-handle = <&phy0>;
> +            compatible = "cortina,gemini-ethernet-port";
> +            reg = <0x60008000 0x2000>, /* Port 0 DMA/TOE */
> +                  <0x6000a000 0x2000>; /* Port 0 GMAC */
> +            interrupt-parent = <&intcon>;
> +            interrupts = <1 IRQ_TYPE_LEVEL_HIGH>;
> +            resets = <&syscon GEMINI_RESET_GMAC0>;
> +            clocks = <&syscon GEMINI_CLK_GATE_GMAC0>;
> +            clock-names = "PCLK";
> +            phy-mode = "rgmii";
> +            phy-handle = <&phy0>;
>           };
>   
>           gmac1: ethernet-port@1 {
> -                compatible = "cortina,gemini-ethernet-port";
> -                reg = <0x6000c000 0x2000>, /* Port 1 DMA/TOE */
> -                      <0x6000e000 0x2000>; /* Port 1 GMAC */
> -                interrupt-parent = <&intcon>;
> -                interrupts = <2 IRQ_TYPE_LEVEL_HIGH>;
> -                resets = <&syscon GEMINI_RESET_GMAC1>;
> -                clocks = <&syscon GEMINI_CLK_GATE_GMAC1>;
> -                clock-names = "PCLK";
> -                phy-mode = "rgmii";
> -                phy-handle = <&phy1>;
> +            compatible = "cortina,gemini-ethernet-port";
> +            reg = <0x6000c000 0x2000>, /* Port 1 DMA/TOE */
> +                  <0x6000e000 0x2000>; /* Port 1 GMAC */
> +            interrupt-parent = <&intcon>;
> +            interrupts = <2 IRQ_TYPE_LEVEL_HIGH>;
> +            resets = <&syscon GEMINI_RESET_GMAC1>;
> +            clocks = <&syscon GEMINI_CLK_GATE_GMAC1>;
> +            clock-names = "PCLK";
> +            phy-mode = "rgmii";
> +            phy-handle = <&phy1>;
>           };
>       };
> diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> index ea285ef3e64f..fab6aa6237e9 100644
> --- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> @@ -127,8 +127,8 @@ examples:
>                   phy-mode = "internal";
>   
>                   fixed-link {
> -                  speed = <1000>;
> -                  full-duplex;
> +                    speed = <1000>;
> +                    full-duplex;
>                   };
>               };
>           };
> diff --git a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> index 62c1da36a2b5..d1522216d32b 100644
> --- a/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> +++ b/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml
> @@ -91,9 +91,9 @@ examples:
>           snps,tx-queues-to-use = <2>;
>           snps,tx-sched-wrr;
>           queue0 {
> -           snps,weight = <0x10>;
> -           snps,dcb-algorithm;
> -           snps,priority = <0x0>;
> +            snps,weight = <0x10>;
> +            snps,dcb-algorithm;
> +            snps,priority = <0x0>;
>           };
>   
>           queue1 {
> diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.yaml b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
> index eb4171a1940e..36e51aaae9c0 100644
> --- a/Documentation/devicetree/bindings/net/mdio-gpio.yaml
> +++ b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
> @@ -45,13 +45,13 @@ examples:
>       };
>   
>       mdio0: mdio {
> -      compatible = "virtual,mdio-gpio";
> -      #address-cells = <1>;
> -      #size-cells = <0>;
> -      gpios = <&qe_pio_a 11>,
> -              <&qe_pio_c 6>;
> -      ethphy0: ethernet-phy@0 {
> -        reg = <0>;
> -      };
> +        compatible = "virtual,mdio-gpio";
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        gpios = <&qe_pio_a 11>,
> +                <&qe_pio_c 6>;
> +        ethphy0: ethernet-phy@0 {
> +            reg = <0>;
> +        };
>       };
>   ...
> diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> index 86a9c3fc76c8..d825130b54b4 100644
> --- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> @@ -197,10 +197,10 @@ examples:
>               <0x71040000 0x10000>,
>               <0x71050000 0x10000>,
>               <0x71060000 0x10000>;
> -            reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
> -            "port2", "port3", "port4", "port5", "port6",
> -            "port7", "port8", "port9", "port10", "qsys",
> -            "ana", "s0", "s1", "s2";
> +      reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
> +                  "port2", "port3", "port4", "port5", "port6",
> +                  "port7", "port8", "port9", "port10", "qsys",
> +                  "ana", "s0", "s1", "s2";
>   
>         ethernet-ports {
>           #address-cells = <1>;
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 68ec76fe4473..38e3830512fe 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -246,14 +246,14 @@ examples:
>           qcom,remote-pid = <5>;
>   
>           ipa_smp2p_out: ipa-ap-to-modem {
> -                qcom,entry-name = "ipa";
> -                #qcom,smem-state-cells = <1>;
> +            qcom,entry-name = "ipa";
> +            #qcom,smem-state-cells = <1>;
>           };
>   
>           ipa_smp2p_in: ipa-modem-to-ap {
> -                qcom,entry-name = "ipa";
> -                interrupt-controller;
> -                #interrupt-cells = <2>;
> +            qcom,entry-name = "ipa";
> +            interrupt-controller;
> +            #interrupt-cells = <2>;
>           };
>       };
>   
> diff --git a/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml b/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
> index 45033c31a2d5..07b39ef1fc62 100644
> --- a/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
> +++ b/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
> @@ -91,8 +91,8 @@ examples:
>           #size-cells = <0>;
>   
>           ethphy1: ethernet-phy@1 {
> -                reg = <1>;
> -                realtek,clkout-disable;
> -                realtek,aldps-enable;
> +            reg = <1>;
> +            realtek,clkout-disable;
> +            realtek,aldps-enable;
>           };
>       };
> diff --git a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
> index 4eb63b303cff..8c8622160abb 100644
> --- a/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
> +++ b/Documentation/devicetree/bindings/net/socionext,uniphier-ave4.yaml
> @@ -121,22 +121,22 @@ examples:
>     - |
>       ether: ethernet@65000000 {
>           compatible = "socionext,uniphier-ld20-ave4";
> -                reg = <0x65000000 0x8500>;
> -                interrupts = <0 66 4>;
> -                phy-mode = "rgmii";
> -                phy-handle = <&ethphy>;
> -                clock-names = "ether";
> -                clocks = <&sys_clk 6>;
> -                reset-names = "ether";
> -                resets = <&sys_rst 6>;
> -                socionext,syscon-phy-mode = <&soc_glue 0>;
> +        reg = <0x65000000 0x8500>;
> +        interrupts = <0 66 4>;
> +        phy-mode = "rgmii";
> +        phy-handle = <&ethphy>;
> +        clock-names = "ether";
> +        clocks = <&sys_clk 6>;
> +        reset-names = "ether";
> +        resets = <&sys_rst 6>;
> +        socionext,syscon-phy-mode = <&soc_glue 0>;
>   
> -                mdio {
> -                        #address-cells = <1>;
> -                        #size-cells = <0>;
> +        mdio {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
>   
> -                        ethphy: ethernet-phy@1 {
> -                                reg = <1>;
> -                        };
> -                };
> +            ethphy: ethernet-phy@1 {
> +                reg = <1>;
> +            };
>           };
> +    };
> diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> index 8b5da602a2e8..4d24dadfaa5d 100644
> --- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> @@ -192,50 +192,50 @@ examples:
>           interrupt-names = "rx_thresh", "rx", "tx", "misc";
>   
>           ethernet-ports {
> -                #address-cells = <1>;
> -                #size-cells = <0>;
> +            #address-cells = <1>;
> +            #size-cells = <0>;
>   
> -                cpsw_port1: port@1 {
> -                        reg = <1>;
> -                        label = "port1";
> -                        mac-address = [ 00 00 00 00 00 00 ];
> -                        phys = <&phy_gmii_sel 1>;
> -                        phy-handle = <&ethphy0_sw>;
> -                        phy-mode = "rgmii";
> -                        ti,dual-emac-pvid = <1>;
> -                };
> +            cpsw_port1: port@1 {
> +                reg = <1>;
> +                label = "port1";
> +                mac-address = [ 00 00 00 00 00 00 ];
> +                phys = <&phy_gmii_sel 1>;
> +                phy-handle = <&ethphy0_sw>;
> +                phy-mode = "rgmii";
> +                ti,dual-emac-pvid = <1>;
> +            };
>   
> -                cpsw_port2: port@2 {
> -                        reg = <2>;
> -                        label = "wan";
> -                        mac-address = [ 00 00 00 00 00 00 ];
> -                        phys = <&phy_gmii_sel 2>;
> -                        phy-handle = <&ethphy1_sw>;
> -                        phy-mode = "rgmii";
> -                        ti,dual-emac-pvid = <2>;
> -                };
> +            cpsw_port2: port@2 {
> +                reg = <2>;
> +                label = "wan";
> +                mac-address = [ 00 00 00 00 00 00 ];
> +                phys = <&phy_gmii_sel 2>;
> +                phy-handle = <&ethphy1_sw>;
> +                phy-mode = "rgmii";
> +                ti,dual-emac-pvid = <2>;
> +            };
>           };
>   
>           davinci_mdio_sw: mdio@1000 {
> -                compatible = "ti,cpsw-mdio","ti,davinci_mdio";
> -                reg = <0x1000 0x100>;
> -                clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0>;
> -                clock-names = "fck";
> -                #address-cells = <1>;
> -                #size-cells = <0>;
> -                bus_freq = <1000000>;
> +            compatible = "ti,cpsw-mdio","ti,davinci_mdio";
> +            reg = <0x1000 0x100>;
> +            clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0>;
> +            clock-names = "fck";
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            bus_freq = <1000000>;
>   
> -                ethphy0_sw: ethernet-phy@0 {
> -                        reg = <0>;
> -                };
> +            ethphy0_sw: ethernet-phy@0 {
> +                reg = <0>;
> +            };
>   
> -                ethphy1_sw: ethernet-phy@1 {
> -                        reg = <1>;
> -                };
> +            ethphy1_sw: ethernet-phy@1 {
> +                reg = <1>;
> +            };
>           };
>   
>           cpts {
> -                clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 25>;
> -                clock-names = "cpts";
> +            clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 25>;
> +            clock-names = "cpts";
>           };
>       };
> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> index ae6b97cdc44b..bf4116b057d2 100644
> --- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> @@ -325,22 +325,22 @@ examples:
>             r0 {
>               regdomain = "FCC";
>               txpower-5g {
> -               b0 {
> -                   channels = <36 48>;
> -                   rates-ofdm = /bits/ 8 <23 23 23 23 23 23 23 23>;
> -                   rates-mcs = /bits/ 8 <1 23 23 23 23 23 23 23 23 23 23>,
> -                               /bits/ 8 <3 22 22 22 22 22 22 22 22 22 22>;
> -                   rates-ru = /bits/ 8 <3 22 22 22 22 22 22 22 22 22 22 22 22>,
> -                              /bits/ 8 <4 20 20 20 20 20 20 20 20 20 20 20 20>;
> -               };
> -               b1 {
> -                   channels = <100 181>;
> -                   rates-ofdm = /bits/ 8 <14 14 14 14 14 14 14 14>;
> -                   rates-mcs = /bits/ 8  <4 14 14 14 14 14 14 14 14 14 14>;
> -                   txs-delta = <12 9 6>;
> -                   rates-ru = /bits/ 8  <7 14 14 14 14 14 14 14 14 14 14 14 14>;
> -               };
> -             };
> +              b0 {
> +                channels = <36 48>;
> +                rates-ofdm = /bits/ 8 <23 23 23 23 23 23 23 23>;
> +                rates-mcs = /bits/ 8 <1 23 23 23 23 23 23 23 23 23 23>,
> +                            /bits/ 8 <3 22 22 22 22 22 22 22 22 22 22>;
> +                rates-ru = /bits/ 8 <3 22 22 22 22 22 22 22 22 22 22 22 22>,
> +                           /bits/ 8 <4 20 20 20 20 20 20 20 20 20 20 20 20>;
> +              };
> +              b1 {
> +                channels = <100 181>;
> +                rates-ofdm = /bits/ 8 <14 14 14 14 14 14 14 14>;
> +                rates-mcs = /bits/ 8  <4 14 14 14 14 14 14 14 14 14 14>;
> +                txs-delta = <12 9 6>;
> +                rates-ru = /bits/ 8  <7 14 14 14 14 14 14 14 14 14 14 14 14>;
> +              };
> +            };
>             };
>           };
>         };
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> index e667d78b3ab3..a52cb8a0d409 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> @@ -408,4 +408,4 @@ examples:
>                             "msi15",
>                             "legacy";
>           ieee80211-freq-limit = <5470000 5875000>;
> -      };
> +    };

