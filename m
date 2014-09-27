Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:47723 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaI0IFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 04:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <2539898.4te2VKk57a@wuerfel>
References: <1411741733-13888-1-git-send-email-zajec5@gmail.com>
	<2539898.4te2VKk57a@wuerfel>
Date: Sat, 27 Sep 2014 10:05:44 +0200
Message-ID: <CACna6rwwfJOdnxhmnW7MUuUC1YBPx8bmDbiaSy1+G39hF4p7OA@mail.gmail.com> (sfid-20140927_100552_878619_46C2CEBA)
Subject: Re: [PATCH] bcma: use device from DT (brcm,bus-gpio) for SoC GPIO chip
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 September 2014 00:03, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 26 September 2014 16:28:53 Rafał Miłecki wrote:
>> +The top-level axi bus may contain following children:
>> +
>> +- gpio: GPIO chip on the SoC
>> +
>> +  Required properties:
>> +  - compatible: "brcm,bus-gpio"
>> +  - gpio-controller : makes the node a GPIO controller
>> +  - #gpio-cells : size of the GPIO specifier, must be 2
>> +
>>
>
> I wonder if it would be better to avoid the subnode here and just
> make the parent itself the gpio controller.
>
> Is the gpio controller part of the bus itself in reality, or is it
> a device that gets probed on the bus?

I'm not sure how to treat this chip.
We control GPIOs using ChipCommon regs (and ChipCommon is one of
cores/devices on the bus), so you could also consider GPIO chip a
sub-device of ChipCommon.
I believe every Broadcom bus has a GPIO chip. In the ancient (MIPS)
times, even if we didn't have ChipCommon, there was an EXTIF core that
used to provide access to the GPIO chip.

What do you think? Should I make it separated device, even it if
depends on the SoC and its ChipCommon core (device)?

-- 
Rafał
