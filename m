Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:46478 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbbCJOeu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 10:34:50 -0400
Message-ID: <54FF00E8.4040502@ti.com> (sfid-20150310_153454_280302_B2D1F300)
Date: Tue, 10 Mar 2015 20:04:16 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Eliad Peller <eliad@wizery.com>
CC: Tony Lindgren <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
References: <1425915402-10012-1-git-send-email-eliad@wizery.com> <20150309224929.GL5264@atomide.com> <CAB3XZEdS+mK1MiB7OWiehFGRBnUzJ84s3rFrCy3-YFYhL-BNWw@mail.gmail.com> <2223973.a64rBcZvaA@wuerfel>
In-Reply-To: <2223973.a64rBcZvaA@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 10 March 2015 07:41 PM, Arnd Bergmann wrote:
> On Tuesday 10 March 2015 13:00:19 Eliad Peller wrote:
>> On Tue, Mar 10, 2015 at 12:49 AM, Tony Lindgren <tony@atomide.com> wrote:
>>> * Eliad Peller <eliad@wizery.com> [150309 14:03]:
>>>> On Mon, Mar 9, 2015 at 9:50 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> On Monday 09 March 2015 17:36:42 Eliad Peller wrote:
>>>>>> --- a/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
>>>>>> +++ b/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
>>>>>> @@ -64,4 +64,13 @@
>>>>>>         vmmc-supply = <&lbep5clwmc_wlen>;
>>>>>>         bus-width = <4>;
>>>>>>         non-removable;
>>>>>> +
>>>>>> +       #address-cells = <1>;
>>>>>> +       #size-cells = <0>;
>>>>>> +       wlcore: wlcore@2 {
>>>>>> +               compatible = "ti,wl1835";
>>>>>> +               reg = <2>;
>>>>>> +               interrupt-parent = <&gpio5>;
>>>>>> +               interrupts = <8 IRQ_TYPE_NONE>;
>>>>>> +       };
>>>>>>
>>>>>
>>>>> Why IRQ_TYPE_NONE?
>>>>>
>>>> i simply mirrored the current board file (which only sets the irq number).
>>>>
>>>>> I was expecting you to remove all calls to legacy_init_wl12xx from this file,
>>>>> including the ones for wl12xx aside from the wl18xx ones you removed, but
>>>>> if that's enough to clean out the platform_data handling from the wlcore
>>>>> driver, it's good enough as a start.
>>>> not sure i'm following - can you elaborate?
>>>>
>>>> i'll summarize the way i see it. please correct me if i'm wrong.
>>>>
>>>> both wl18xx and wl12xx use the platform data to get the irq number.
>>>> wl12xx (only) also needs some additional clock definitions to be
>>>> passed. there's currently some issue with specifying some the of clock
>>>> sources, so i preferred starting only with (the simpler) wl18xx
>>>> bindings.
>>>>
>>>> for platforms with wl18xx, we can remove the pdata-quirk, as all the
>>>> data (i.e. irq) can be passed by the new DT bindings.
>>>> however, for platforms with wl12xx, we still need to pass the clock
>>>> definitions (along with the irq), so we have to keep
>>>> legacy_init_wl12xx for the time being (and that's also why we have to
>>>> currently keep the platform_data handling in the wlcore driver)
>>>>
>>>> do you have something else in mind?
>>>
>>> I think what Arnd is saying is we've now removed all the wl12xx using
>>> legacy platforms, so all of them can boot with just data from dts.
> 
> Right, that was my idea.
> 
>> I don't think that's the case (unless i'm missing something).
>> e.g. there's still pdata-quirk for "compulab,omap3-sbc-t3730" which
>> initializes wl12xx device.
> 
> This one is just like the igep0030, as Tony was saying: the board
> boots from device tree already, so now that we have a binding for
> it, we can remove the wl12xx_set_platform_data() for it.
> 
> Unfortunately, there is still one machine that uses a board file
> in combination with this wl12xx: da850-evm calls
> wl12xx_set_platform_data() from a legacy board file without DT.
> 
> We have DT support for this file as well, but if I remember correctly,
> it is somewhat incomplete and we don't want to remove the file
> yet. Adding Sekhar and Kevin to Cc here for confirmation.

Thats true, we do not want to drop legacy booting for DA850 EVM yet.

But if its coming in the way of code consolidation, I do not mind
dropping WLAN support for that board. Anyone who really needs it can add
support to the DA850 EVM DT file.

Thanks,
Sekhar
