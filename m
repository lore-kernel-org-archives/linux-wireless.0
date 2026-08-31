Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136EE41D123;
	Mon, 31 Aug 2026 13:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182561; cv=none; b=mFJZ+QWX0gMG/9a0VdrByHUkE9SLuP/EgorgECqwfIsgaRCzFrDJE70e0kj0qNGz2lmA1+3tv34b0NZ3kUEYNUNtm5JVR9uK4A6GsJLP5QOaGo1zgVUgeFaRdbwjjRrUEcOJVLK92xwrzbNd8tLfbBxvp662wD9ePrI9kbJr63w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182561; c=relaxed/simple;
	bh=1ax5367DfrVjUTnqHyEVHjPHXQLj/zP6PwXkYSJHocc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qcpSDrxYWVZBuinBo+GIxBYdiVe9g5+pSojPuabab1AACK8Nmf6x9XeKkQYozC0vxjojKX5Pcc3fFfJaGPaak+XWapVd0BCXpfF865PimZ8zVAOVFTXqrZr4BM3ANbdfKmHu0eitHWCHpnTW92DCegWztcMJp7m5BC+s4CQfVeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjJ9C3c9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjJ9C3c9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B14B1F00A3D;
	Mon, 31 Aug 2026 13:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788182559;
	bh=Uub/7gq/t5L9LR3b1cPyhosYuN9EQDZJSoPIbu/ldsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fjJ9C3c9O2yl4Fpv5CWEdLXlbhdWB8E0ohvu+wW8xAIFUCDXmuvbudcc7NQU/6Row
	 iFDwM5Ez/y8BUqhzyXyxgD0TI2IdsTx3EhP8qkxGxh3JkLePEZnlnIM4k6U0Zt+WO/
	 DUR4VxnYlacgA/mcbl/KNOlt0fQbUTLkjjYOAh9bIin0oxWrae00bXvVmbcyevv3p8
	 pycpQ5Y+L17Fa16HnymAfKkAdAY6+/cQtP03tYQEh+KSDrrJgDCw6z4rJcxwkvy31V
	 ftFQTPYqcMl3fvXPYJPeSUByJbxBzrRfCQp4SejAFxeKh3jdvqYtSqs6qgzITr/w1e
	 m1vSvpthzHI/g==
Date: Mon, 31 Aug 2026 08:22:39 -0500
From: Rob Herring <robh@kernel.org>
To: Eduard Bostina <egbostina@gmail.com>
Cc: Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	daniel.baluta@nxp.com, simona.toaca@nxp.com, goledhruva@gmail.com,
	m-chawdhry@ti.com
Subject: Re: [PATCH] dt-bindings: net: wireless: Convert WL1251 to DT schema
Message-ID: <20260831132239.GA662228-robh@kernel.org>
References: <20260815083326.2146602-1-egbostina@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815083326.2146602-1-egbostina@gmail.com>

On Sat, Aug 15, 2026 at 08:33:26AM +0000, Eduard Bostina wrote:
> Convert the Texas Instruments WL1251 Wireless LAN Controller bindings to DT
> schema.
> 
> During the conversion, the following updates were made:
> - Added the 'clocks' property. It was missing from the txt binding but
>   is used in device trees (omap3-n900.dts).
> - Added 'spi-cpol' and 'spi-cpha'. These were present in the original
>   txt binding's example but missing from its property list.
> - 'vio-supply' and 'spi-max-frequency' are no longer required. The txt
>   binding listed them as required, but they are only applicable when
>   the chip is connected via SPI.
> 
> Signed-off-by: Eduard Bostina <egbostina@gmail.com>
> ---
>  .../bindings/net/wireless/ti,wl1251.txt       | 64 -------------
>  .../bindings/net/wireless/ti,wl1251.yaml      | 92 +++++++++++++++++++
>  2 files changed, 92 insertions(+), 64 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl1251.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
> deleted file mode 100644
> index 88fd28d15eac..000000000000
> --- a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
> +++ /dev/null
> @@ -1,64 +0,0 @@
> -* Texas Instruments wl1251 wireless lan controller
> -
> -The wl1251 chip can be connected via SPI or via SDIO. This
> -document describes the binding for the SPI connected chip.
> -
> -Required properties:
> -- compatible :        Should be "ti,wl1251"
> -- reg :               Chip select address of device
> -- spi-max-frequency : Maximum SPI clocking speed of device in Hz
> -- interrupts :        Should contain interrupt line
> -- vio-supply :        phandle to regulator providing VIO
> -
> -Optional properties:
> -- ti,wl1251-has-eeprom : boolean, the wl1251 has an eeprom connected, which
> -                         provides configuration data (calibration, MAC, ...)
> -- ti,power-gpio :	 GPIO connected to chip's PMEN pin if operated in
> -			 SPI mode
> -- Please consult Documentation/devicetree/bindings/spi/spi-bus.txt
> -  for optional SPI connection related properties,
> -
> -Examples:
> -
> -&spi1 {
> -	wl1251@0 {
> -		compatible = "ti,wl1251";
> -
> -		reg = <0>;
> -		spi-max-frequency = <48000000>;
> -		spi-cpol;
> -		spi-cpha;
> -
> -		interrupt-parent = <&gpio2>;
> -		interrupts = <10 IRQ_TYPE_NONE>; /* gpio line 42 */
> -
> -		vio-supply = <&vio>;
> -		ti,power-gpio = <&gpio3 23 GPIO_ACTIVE_HIGH>; /* 87 */
> -	};
> -};
> -
> -&mmc3 {
> -	vmmc-supply = <&wlan_en>;
> -
> -	bus-width = <4>;
> -	non-removable;
> -	ti,non-removable;
> -	cap-power-off-card;
> -
> -	pinctrl-names = "default";
> -	pinctrl-0 = <&mmc3_pins>;
> -
> -	#address-cells = <1>;
> -	#size-cells = <0>;
> -
> -	wlan: wifi@1 {
> -		compatible = "ti,wl1251";
> -
> -		reg = <1>;
> -
> -		interrupt-parent = <&gpio1>;
> -		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;	/* GPIO_21 */
> -
> -		ti,wl1251-has-eeprom;
> -	};
> -};
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.yaml b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.yaml
> new file mode 100644
> index 000000000000..1f46f1235035
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.yaml
> @@ -0,0 +1,92 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/wireless/ti,wl1251.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Texas Instruments WL1251 Wireless LAN Controller
> +
> +maintainers:
> +  - Eduard Bostina <egbostina@gmail.com>
> +
> +properties:
> +  compatible:
> +    const: ti,wl1251
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  vio-supply:
> +    description:
> +      Phandle to the regulator providing VIO. Required when connected via SPI.
> +
> +  ti,power-gpio:
> +    maxItems: 1
> +    description:
> +      GPIO connected to chip's PMEN pin if operated in SPI mode.
> +
> +  ti,wl1251-has-eeprom:
> +    type: boolean
> +    description:
> +      The wl1251 has an EEPROM connected, which provides configuration
> +      data (calibration, MAC, ...).
> +
> +  clocks:
> +    maxItems: 1
> +
> +  spi-max-frequency: true
> +  spi-cpol: true
> +  spi-cpha: true
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +allOf:
> +  - $ref: /schemas/spi/spi-peripheral-props.yaml#
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/gpio/gpio.h>
> +    spi1 {

spi {

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        wl1251@0 {
> +            compatible = "ti,wl1251";
> +            reg = <0>;
> +            spi-max-frequency = <48000000>;
> +            spi-cpol;
> +            spi-cpha;
> +            interrupt-parent = <&gpio2>;
> +            interrupts = <10 IRQ_TYPE_NONE>;
> +            vio-supply = <&vio>;
> +            ti,power-gpio = <&gpio3 23 GPIO_ACTIVE_HIGH>;
> +        };
> +    };
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    mmc3 {

mmc {

> +        vmmc-supply = <&wlan_en>;
> +        bus-width = <4>;
> +        non-removable;
> +        ti,non-removable;
> +        cap-power-off-card;
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&mmc3_pins>;

Drop all these. Not relevant to this binding.

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        wifi@1 {
> +            compatible = "ti,wl1251";
> +            reg = <1>;
> +            interrupt-parent = <&gpio1>;
> +            interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;
> +            ti,wl1251-has-eeprom;
> +        };
> +    };
> -- 
> 2.43.0
> 
> 
