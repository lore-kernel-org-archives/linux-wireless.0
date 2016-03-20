Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47307 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485AbcCTAuo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 20:50:44 -0400
Date: Sat, 19 Mar 2016 19:50:39 -0500
From: Rob Herring <robh@kernel.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	devicetree@vger.kernel.org, Wei-Ning Huang <wnhuang@chromium.org>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v5 1/2] dt: bindings: add MARVELL's sd8xxx wireless device
Message-ID: <20160320005039.GA10937@rob-hp-laptop> (sfid-20160320_015048_479375_43C9367E)
References: <1458299032-31929-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458299032-31929-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2016 at 04:03:51AM -0700, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> Add device tree binding documentation for MARVELL's sd8xxx
> (sd8897 and sd8997) wlan chip.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> Listing changelist for both 1/2 and 2/2 patches
> v3: Don't update adapter->dt_node if mwifiex_plt_dev is NULL
> 
> v4: a)Corrected the 'name' and 'compatible' property names.(Arnd Bergmann and Rob
>     Herring)
>     b)Patch description wraped in 72 columns(Rob Herring)
>     c)Moved DT binding file to bindings/net/wireless/(Rob Herring)
>     d)Renamed "mwifiex,chip-gpio" to "marvell,wakeup-gpios"(Rob Herring/
>     Arnd Bergmann)
>     e)Replaced #ifdef with __maybe_unused(Arnd Bergmann)
> 
> v5: a)Removed wildcards from compatible string(Arnd Bergmann)
>     b)Prepared single patch for all binding changes(Rob Herring)
>     c)Specified our node as a subnode of SDIO controller. With this approach, we
>     don't need to register new platform driver. (Rob herring)
> ---
>  .../bindings/net/wireless/marvell-sd8xxx.txt       | 56 ++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> new file mode 100644
> index 0000000..c43d488
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> @@ -0,0 +1,56 @@
> +Marvell 8897/8997 (sd8897/sd8997) SDIO devices
> +------
> +
> +This node provides properties for controlling the marvell sdio wireless device.
> +The node is expected to be specified as a child node to the SDIO controller that
> +connects the device to the system.
> +
> +Required properties:
> +
> +  - compatible : should be one of the following:
> +	* "marvell,sd8897"
> +	* "marvell,sd8997"
> +
> +Optional properties:
> +
> +  - marvell,caldata* : A series of properties with marvell,caldata prefix,
> +  		      represent Calibration data downloaded to the device during
> +		      initialization. This is an array of unsigned values.

You need to list out the specific property names and size of the data.

> +  - marvell,wakeup-pin : 'wakeuppin' is a wakeup pin number of wifi chip which will
> +  		      be configured to firmware. firmware will wakeup host side use
> +  		      the pin during suspend/resume stage.
> +  - interrupt-parent: phandle of the parent interrupt controller
> +  - interrupts : interrupt pin number to the cpu. driver will request an irq based on
> +  		 this interrupt number. during system suspend, the irq will be enabled
> +  		 as system wakeup source, so that the wifi chip can wakeup host
> +  		 platform under certain condition. during system resume, the irq will
> +  		 be disabled to make sure unnecessary interrupt is not received.
> +
> +Example:
> +
> +Tx power limit calibration data is configured in below example.
> +The calibration data is an array of unsigned values, the length
> +can vary between hw versions.
> +IRQ pin 38 is used as system wakeup source interrupt. wakeup pin 3 is configured
> +so that firmware can wakeup host using this device side pin.
> +
> +&mmc3 {
> +	status = "okay";
> +	vmmc-supply = <&wlan_en_reg>;
> +	bus-width = <4>;
> +	cap-power-off-card;
> +	keep-power-in-suspend;
> +
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	mwifiex: mwifiex@3 {

The unit address and reg value don't match. IIRC, the correct value is 
the SDIO function number.

> +		compatible = "marvell,sd8897";
> +		reg = <1>;
> +		interrupt-parent = <&pio>;
> +		interrupts = <38 IRQ_TYPE_LEVEL_LOW>;
> +
> +		marvell,caldata_00_txpwrlimit_2g_cfg_set = /bits/ 8 <
> +	0x01 0x00 0x06 0x00 0x08 0x02 0x89 0x01>;
> +		marvell,wakeup-pin = <3>;
> +	};
> +};
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
