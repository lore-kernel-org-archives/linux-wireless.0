Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:42078 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaI0Urr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 16:47:47 -0400
Message-ID: <5427226F.8080601@hauke-m.de> (sfid-20140927_224751_754107_3A9BB2C0)
Date: Sat, 27 Sep 2014 22:47:43 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] bcma: use device from DT (brcm,bus-gpio) for SoC GPIO
 chip
References: <1411741733-13888-1-git-send-email-zajec5@gmail.com>	<2539898.4te2VKk57a@wuerfel>	<CACna6rwwfJOdnxhmnW7MUuUC1YBPx8bmDbiaSy1+G39hF4p7OA@mail.gmail.com>	<54267661.5000401@hauke-m.de> <CACna6rwYcSh7-uFYA+paNehNwrqddmn2az+a9ZwggVGofbDR7w@mail.gmail.com>
In-Reply-To: <CACna6rwYcSh7-uFYA+paNehNwrqddmn2az+a9ZwggVGofbDR7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2014 12:37 PM, Rafał Miłecki wrote:
> On 27 September 2014 10:33, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> I would make GPIO a subdevive of chipcommon. The chipcommon core has an
>> own IRQ which is also used for GPIO.
> 
> Which ChipCommon do yo mean?
> 1) chipcommonA (compatible = "simple-bus")
> 2) chipcommon@0 (child of axi@18000000 AKA brcm,bus-axi)

We should combine this (both are describing the same core) I added
chipcommonA to get some serial without adding bcma support first. When
we have dts support added to bcma, I would like to remove chipcommonA
from dtsi and add a chipcommon as a child of axi.

> 
> It seems that for some reason both of them use IRQ 85, while the IRQ
> for ChipCommon is 117 I believe.

That's the same.

In the dtsi file it says:
interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
this will result in the IRQ number 117, when it is GIC_SPI you have to
add 32 to the irq number to get the actual number which will be given to
request_irq().

Hauke
