Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36245 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753170AbdGXRyn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 13:54:43 -0400
Date: Mon, 24 Jul 2017 12:54:40 -0500
From: Rob Herring <robh@kernel.org>
To: Icenowy Zheng <icenowy@aosc.io>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH] dt-bindings: add device tree binding for Allwinner XR819
 SDIO Wi-Fi
Message-ID: <20170724175440.s7f6lk77wv2vpszz@rob-hp-laptop> (sfid-20170724_201349_921559_588F213A)
References: <20170718072940.17872-1-icenowy@aosc.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170718072940.17872-1-icenowy@aosc.io>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 18, 2017 at 03:29:40PM +0800, Icenowy Zheng wrote:
> Allwinner XR819 is a SDIO Wi-Fi chip, which has the functionality to use
> an out-of-band interrupt pin instead of SDIO in-band interrupt.
> 
> Add the device tree binding of this chip, in order to make it possible
> to add this interrupt pin to device trees.
> 
> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> ---
>  .../bindings/net/wireless/allwinner,xr819.txt      | 37 ++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt b/Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
> new file mode 100644
> index 000000000000..64dd9c1c0584
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
> @@ -0,0 +1,37 @@
> +Allwinner XRadio wireless SDIO devices
> +
> +This node provides properties for controlling the XRadio wireless device. The
> +node is expected to be specified as a child node to the SDIO controller that
> +connects the device to the system.
> +
> +Required properties:
> +
> + - compatible : Should be "allwinner,xr819".

reg is also required.

> +
> +Optional properties:
> + - interrupt-parent : the phandle for the interrupt controller to which the
> +	device interrupts are connected.
> + - interrupts : specifies attributes for the out-of-band interrupt (host-wake).
> +	When not specified the device will use in-band SDIO interrupts.
> +
> +Example:
> +
> +mmc1: mmc@01c10000 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&mmc1_pins_a>;
> +	vmmc-supply = <&reg_vcc_wifi>;
> +	mmc-pwrseq = <&wifi_pwrseq>;
> +	bus-width = <4>;
> +	non-removable;
> +	status = "okay";

Don't show status in examples.

> +
> +	xr819: sdio_wifi@1 {

wifi@1

> +		reg = <1>;
> +		compatible = "allwinner,xr819";
> +		interrupt-parent = <&pio>;
> +		interrupts = <6 10 IRQ_TYPE_EDGE_RISING>;
> +	};
> +};
> -- 
> 2.13.0
> 
