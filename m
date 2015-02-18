Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:54110 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbBRIOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 03:14:34 -0500
MIME-Version: 1.0
In-Reply-To: <20150217154538.GP8994@leverpostej>
References: <1423998550-8829-1-git-send-email-eliad@wizery.com>
	<2344371.zDnvJJhFdD@wuerfel>
	<CAB3XZEe1HmOwQ3GcU5T3ruFybKdCVNiBwQbeLS3X4MMkL2G5uA@mail.gmail.com>
	<20150217154538.GP8994@leverpostej>
Date: Wed, 18 Feb 2015 10:14:33 +0200
Message-ID: <CAB3XZEfESwUr6Tpcw71rzgZEnXZZpdgM0E1cdivBD01kGc1P0Q@mail.gmail.com> (sfid-20150218_091442_746532_03F8AF8A)
Subject: Re: [PATCH v2] wlcore: add basic device-tree support
From: Eliad Peller <eliad@wizery.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 17, 2015 at 5:45 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Feb 17, 2015 at 03:39:03PM +0000, Eliad Peller wrote:
>> On Mon, Feb 16, 2015 at 12:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Sunday 15 February 2015 13:09:10 Eliad Peller wrote:
>> > s
>> >> +
>> >> +This node provides properties for controlling the wilink wireless device. The
>> >> +node is expected to be specified as a child node to the SDIO controller that
>> >> +connects the device to the system.
>> >> +
>> >> +Required properties:
>> >> +
>> >> + - compatible : Should be "ti,wlcore".
>> >
>> > I think you should use the specific model number here. If I understand
>> > correctly, wlcore is the name of the driver that is used for multiple
>> > device implementation.
>> >
>> right, wlcore is the common driver part of wl12xx and wl18xx device drivers.
>> these DT properties are common for both.
>> can't we use a common binding as well in this case?
>
> Just have a string for each; the driver can easily match them all and
> handle them identically for now until we decide/realise we need to
> handle them differently later.
>
> Regardless, the compatible string should match some real part number
> and/or standard rather than the Linux driver name.
>
ok, makes sense.

>> >> +&mmc3 {
>> >> +     status = "okay";
>> >> +     vmmc-supply = <&wlan_en_reg>;
>> >> +     bus-width = <4>;
>> >> +     cap-power-off-card;
>> >> +     keep-power-in-suspend;
>> >> +
>> >> +     #address-cells = <1>;
>> >> +     #size-cells = <0>;
>> >> +     wlcore: wlcore@0 {
>> >> +             compatible = "ti,wlcore";
>> >> +             reg = <2>;
>> >> +             interrupt-parent = <&gpio0>;
>> >> +             interrupts = <19 IRQ_TYPE_NONE>;
>> >> +     };
>> >> +};
>> >
>> > It could make sense to specify a few extra properties here:
>> >
>> > - The platform data lists two clocks. How about adding them
>> >   here as optional clocks so we don't need to change the binding
>> >   again.
>> >
>> There were some very long threads previously regarding the correct way
>> to describe these clocks.
>> I prefer starting a working basic implementation and add the
>> controversial parts later on, as needed.
>
> This could be problematic. Elsewhere we've later added properties that
> should have been mandatory from the start but were masked by some
> platform data somewhere. It would be very good to avoid that.
>
that's a good argument.
in this case, i'll start with submitting a binding only for wl18xx,
which doesn't need the clock bindings (they are needed only for
wl12xx).

> What is problematic about describing the clock inputs to this block? Is
> the problem specific to this block or to the specific clock
> controller(s) it happens to be wired to?
i'm referring to patches like this one:
http://thread.gmane.org/gmane.linux.kernel/1520752

Eliad.
