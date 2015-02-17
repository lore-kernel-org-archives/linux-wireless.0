Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:45414 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbbBQPjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 10:39:04 -0500
MIME-Version: 1.0
In-Reply-To: <2344371.zDnvJJhFdD@wuerfel>
References: <1423998550-8829-1-git-send-email-eliad@wizery.com>
	<2344371.zDnvJJhFdD@wuerfel>
Date: Tue, 17 Feb 2015 17:39:03 +0200
Message-ID: <CAB3XZEe1HmOwQ3GcU5T3ruFybKdCVNiBwQbeLS3X4MMkL2G5uA@mail.gmail.com> (sfid-20150217_163912_560553_4FDB7454)
Subject: Re: [PATCH v2] wlcore: add basic device-tree support
From: Eliad Peller <eliad@wizery.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2015 at 12:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 15 February 2015 13:09:10 Eliad Peller wrote:
> s
>> +
>> +This node provides properties for controlling the wilink wireless device. The
>> +node is expected to be specified as a child node to the SDIO controller that
>> +connects the device to the system.
>> +
>> +Required properties:
>> +
>> + - compatible : Should be "ti,wlcore".
>
> I think you should use the specific model number here. If I understand
> correctly, wlcore is the name of the driver that is used for multiple
> device implementation.
>
right, wlcore is the common driver part of wl12xx and wl18xx device drivers.
these DT properties are common for both.
can't we use a common binding as well in this case?

>> + - interrupt-parent : the phandle for the interrupt controller to which the
>> +     device interrupts are connected.
>
> interrupt-parent should not be required
>
sure. i'll make it optional.

>> +&mmc3 {
>> +     status = "okay";
>> +     vmmc-supply = <&wlan_en_reg>;
>> +     bus-width = <4>;
>> +     cap-power-off-card;
>> +     keep-power-in-suspend;
>> +
>> +     #address-cells = <1>;
>> +     #size-cells = <0>;
>> +     wlcore: wlcore@0 {
>> +             compatible = "ti,wlcore";
>> +             reg = <2>;
>> +             interrupt-parent = <&gpio0>;
>> +             interrupts = <19 IRQ_TYPE_NONE>;
>> +     };
>> +};
>
> It could make sense to specify a few extra properties here:
>
> - The platform data lists two clocks. How about adding them
>   here as optional clocks so we don't need to change the binding
>   again.
>
There were some very long threads previously regarding the correct way
to describe these clocks.
I prefer starting a working basic implementation and add the
controversial parts later on, as needed.

>> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
>> index d3dd7bf..317796b 100644
>> --- a/drivers/net/wireless/ti/wlcore/sdio.c
>> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
>
> Please make this a two-patch series and keep the dt binding in a separate
> patch from the driver change.
>
sure.

>> +#ifdef CONFIG_OF
>> +static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
>> +{
>> +     struct device_node *np = dev->of_node;
>> +     struct wl12xx_platform_data *pdata;
>> +
>> +     if (!np || !of_device_is_compatible(np, "ti,wlcore")) {
>> +             dev_err(dev, "No platform data set\n");
>> +             return NULL;
>> +     }
>> +
>> +     pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
>> +     if (!pdata)
>> +             return NULL;
>
> Your method seems overly complicated. While a lot of drivers do the same
> thing, allocating a platform_data structure at probe time is really
> just extra work compared to making the platform_data optional and
> adding the required fields into the driver-private structure.
i see your point here.
however, the driver already holds (and uses) a pointer describing the
platform_data (in the non-dt case), so this patch simply takes
leverage of the current behavior (and returns a similar pointer).

thanks for the review!

Eliad.
