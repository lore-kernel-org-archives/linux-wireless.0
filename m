Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:55709 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbbBPKGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 05:06:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v2] wlcore: add basic device-tree support
Date: Mon, 16 Feb 2015 11:06:14 +0100
Message-ID: <2344371.zDnvJJhFdD@wuerfel> (sfid-20150216_110622_419620_3B16066E)
In-Reply-To: <1423998550-8829-1-git-send-email-eliad@wizery.com>
References: <1423998550-8829-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 15 February 2015 13:09:10 Eliad Peller wrote:
s
> +
> +This node provides properties for controlling the wilink wireless device. The
> +node is expected to be specified as a child node to the SDIO controller that
> +connects the device to the system.
> +
> +Required properties:
> +
> + - compatible : Should be "ti,wlcore".

I think you should use the specific model number here. If I understand
correctly, wlcore is the name of the driver that is used for multiple
device implementation.

> + - interrupt-parent : the phandle for the interrupt controller to which the
> +	device interrupts are connected.

interrupt-parent should not be required

> +&mmc3 {
> +	status = "okay";
> +	vmmc-supply = <&wlan_en_reg>;
> +	bus-width = <4>;
> +	cap-power-off-card;
> +	keep-power-in-suspend;
> +
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	wlcore: wlcore@0 {
> +		compatible = "ti,wlcore";
> +		reg = <2>;
> +		interrupt-parent = <&gpio0>;
> +		interrupts = <19 IRQ_TYPE_NONE>;
> +	};
> +};

It could make sense to specify a few extra properties here:

- The platform data lists two clocks. How about adding them
  here as optional clocks so we don't need to change the binding
  again.

> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> index d3dd7bf..317796b 100644
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c

Please make this a two-patch series and keep the dt binding in a separate
patch from the driver change.
  
> +#ifdef CONFIG_OF
> +static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct wl12xx_platform_data *pdata;
> +
> +	if (!np || !of_device_is_compatible(np, "ti,wlcore")) {
> +		dev_err(dev, "No platform data set\n");
> +		return NULL;
> +	}
> +
> +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return NULL;

Your method seems overly complicated. While a lot of drivers do the same
thing, allocating a platform_data structure at probe time is really
just extra work compared to making the platform_data optional and
adding the required fields into the driver-private structure.

	Arnd

