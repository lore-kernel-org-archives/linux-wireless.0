Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:41659 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaI0Idk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 04:33:40 -0400
Message-ID: <54267661.5000401@hauke-m.de> (sfid-20140927_103355_820031_5BC7AE7B)
Date: Sat, 27 Sep 2014 10:33:37 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] bcma: use device from DT (brcm,bus-gpio) for SoC GPIO
 chip
References: <1411741733-13888-1-git-send-email-zajec5@gmail.com>	<2539898.4te2VKk57a@wuerfel> <CACna6rwwfJOdnxhmnW7MUuUC1YBPx8bmDbiaSy1+G39hF4p7OA@mail.gmail.com>
In-Reply-To: <CACna6rwwfJOdnxhmnW7MUuUC1YBPx8bmDbiaSy1+G39hF4p7OA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2014 10:05 AM, Rafał Miłecki wrote:
> On 27 September 2014 00:03, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Friday 26 September 2014 16:28:53 Rafał Miłecki wrote:
>>> +The top-level axi bus may contain following children:
>>> +
>>> +- gpio: GPIO chip on the SoC
>>> +
>>> +  Required properties:
>>> +  - compatible: "brcm,bus-gpio"
>>> +  - gpio-controller : makes the node a GPIO controller
>>> +  - #gpio-cells : size of the GPIO specifier, must be 2
>>> +
>>>
>>
>> I wonder if it would be better to avoid the subnode here and just
>> make the parent itself the gpio controller.
>>
>> Is the gpio controller part of the bus itself in reality, or is it
>> a device that gets probed on the bus?
> 
> I'm not sure how to treat this chip.
> We control GPIOs using ChipCommon regs (and ChipCommon is one of
> cores/devices on the bus), so you could also consider GPIO chip a
> sub-device of ChipCommon.
> I believe every Broadcom bus has a GPIO chip. In the ancient (MIPS)
> times, even if we didn't have ChipCommon, there was an EXTIF core that
> used to provide access to the GPIO chip.
> 
> What do you think? Should I make it separated device, even it if
> depends on the SoC and its ChipCommon core (device)?
> 
I would make GPIO a subdevive of chipcommon. The chipcommon core has an
own IRQ which is also used for GPIO.

Hauke
