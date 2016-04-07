Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45216 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbcDGMYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 08:24:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Eyal Reizer <eyalreizer@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eyal Reizer <eyalr@ti.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] wlcore: spi: add wl18xx support
References: <1459343218-24536-1-git-send-email-eyalr@ti.com>
Date: Thu, 07 Apr 2016 15:24:40 +0300
In-Reply-To: <1459343218-24536-1-git-send-email-eyalr@ti.com> (Eyal Reizer's
	message of "Wed, 30 Mar 2016 16:06:58 +0300")
Message-ID: <87shyx38tz.fsf@purkki.adurom.net> (sfid-20160407_142505_941019_7620A32C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eyal Reizer <eyalreizer@gmail.com> writes:

> Add support for using with both wl12xx and wl18xx.
>
> - all wilink family needs special init command for entering wspi mode.
>   extra clock cycles should be sent after the spi init command while the
>   cs pin is high.
> - switch to controling the cs pin from the spi driver for achieveing the
>   above.
> - the selected cs gpio is read from the spi device-tree node using the
>   cs-gpios field and setup as a gpio.
> - See the example below for specifying the cs gpio using the cs-gpios entry
>
> &spi0	{
>  	status = "okay";
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&spi0_pins>;
> 	cs-gpios = <&gpio0 5 0>;
> 	#address-cells = <1>;
> 	#size-cells = <0>;
>  	wlcore: wlcore@0 {
> 		compatible = "ti,wl1835";
> 		vwlan-supply = <&wlan_en_reg>;
> 		spi-max-frequency = <48000000>;
> 		reg = <0>;      /* chip select 0 on spi0, ie spi0.0 */
> 		interrupt-parent = <&gpio0>;
> 		interrupts = <27 IRQ_TYPE_EDGE_RISING>;
>  	};
> };
>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>

[...]

>  static const struct of_device_id wlcore_spi_of_match_table[] = {
> -	{ .compatible = "ti,wl1271" },
> +	{ .compatible = "ti,wl1271", .data = &wl12xx_data},
> +	{ .compatible = "ti,wl1273", .data = &wl12xx_data},
> +	{ .compatible = "ti,wl1281", .data = &wl12xx_data},
> +	{ .compatible = "ti,wl1283", .data = &wl12xx_data},
> +	{ .compatible = "ti,wl1801", .data = &wl18xx_data},
> +	{ .compatible = "ti,wl1805", .data = &wl18xx_data},
> +	{ .compatible = "ti,wl1807", .data = &wl18xx_data},
> +	{ .compatible = "ti,wl1831", .data = &wl18xx_data},
> +	{ .compatible = "ti,wl1835", .data = &wl18xx_data},
> +	{ .compatible = "ti,wl1837", .data = &wl18xx_data},
>  	{ }

Shouldn't you also update bindings/net/wireless/ti,wlcore,spi.txt? Now
it only mentions about ti,wl1271 and not anything about the rest.

Adding devicetree list for further comments.

-- 
Kalle Valo
