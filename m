Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:47527 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaH0SWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 14:22:33 -0400
Message-ID: <53FE21C9.7060909@gmail.com> (sfid-20140827_202240_125008_F6190A2F)
Date: Wed, 27 Aug 2014 11:22:01 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mips@linux-mips.org
CC: zajec5@gmail.com
Subject: Re: [RFC 7/7] ARM: BCM5301X: register bcma bus
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de> <1408915485-8078-9-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1408915485-8078-9-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2014 02:24 PM, Hauke Mehrtens wrote:
> ---
>  arch/arm/boot/dts/bcm4708.dtsi | 58 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)

We probably want a compatible string for each of these aix subnodes you
are adding, so we can match them.

> 
> diff --git a/arch/arm/boot/dts/bcm4708.dtsi b/arch/arm/boot/dts/bcm4708.dtsi
> index 31141e8..7c240ab 100644
> --- a/arch/arm/boot/dts/bcm4708.dtsi
> +++ b/arch/arm/boot/dts/bcm4708.dtsi
> @@ -31,4 +31,62 @@
>  		};
>  	};
>  
> +	nvram0: nvram@0 {
> +		compatible = "brcm,bcm47xx-nvram";
> +		reg = <0x1c000000 0x01000000>;
> +	};
> +
> +	sprom0: sprom@0 {
> +		compatible = "brcm,bcm47xx-sprom";
> +		nvram = <&nvram0>;
> +	};
> +
> +	aix@18000000 {
> +		compatible = "brcm,bus-aix";
> +		reg = <0x18000000 0x1000>;
> +		ranges = <0x00000000 0x18000000 0x00100000>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		sprom = <&sprom0>;
> +
> +		usb2@0 {
> +			reg = <0x18021000 0x1000>;
> +			interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		usb3@0 {
> +			reg = <0x18023000 0x1000>;
> +			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		gmac@0 {
> +			reg = <0x18024000 0x1000>;
> +			interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		gmac@1 {
> +			reg = <0x18025000 0x1000>;
> +			interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		gmac@2 {
> +			reg = <0x18026000 0x1000>;
> +			interrupts = <GIC_SPI 149 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		gmac@3 {
> +			reg = <0x18027000 0x1000>;
> +			interrupts = <GIC_SPI 150 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		pcie@0 {
> +			reg = <0x18012000 0x1000>;
> +			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
> +		pcie@1 {
> +			reg = <0x18013000 0x1000>;
> +			interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +	};
>  };
> 

