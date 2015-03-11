Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35549 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbbCKBBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 21:01:00 -0400
Received: by wibbs8 with SMTP id bs8so34830218wib.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 18:00:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150310173550.GT5264@atomide.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com>
	<2223973.a64rBcZvaA@wuerfel>
	<CAB3XZEftjwUGS_Kj2dCxYY1m82C+a1_=akbnG3_hLETCr+Dddg@mail.gmail.com>
	<5683860.JYkc24rKim@wuerfel>
	<CAB3XZEfEQnb7qsxuAAr6pUehm1nw6Eu4ZsV1+E477yF5K1hczA@mail.gmail.com>
	<20150310161801.GR5264@atomide.com>
	<CAB3XZEdK2O7tSSTchvRQtaefzCECjjQ-biQmOBHGdzJaBknSFQ@mail.gmail.com>
	<20150310173550.GT5264@atomide.com>
Date: Wed, 11 Mar 2015 02:00:59 +0100
Message-ID: <CABxcv=ndnNj4MhoXeW=GHXT4aEWQYHdbu-Mg4R2Zhf9CJTrJCA@mail.gmail.com> (sfid-20150311_020107_109916_3F54F0B3)
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Eliad Peller <eliad@wizery.com>, Arnd Bergmann <arnd@arndb.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Tony,

On Tue, Mar 10, 2015 at 6:35 PM, Tony Lindgren <tony@atomide.com> wrote:
>>
>> we do have to make sure these wl18xx bindings are future-compatible
>> with the wl12xx ones, but i think the current bindings are pretty much
>> standard (and are actually a subset of the bindings needed by wl12xx),
>> so it should be fine.
>
> Well how about add just the parsing of the clock and assume it's always
> WL12XX_REFCLOCK_38 for now as that's the only thing we're currently
> using. Then we can add a property or compatible value if using something
> else as needed.
>

What do you mean by parsing here? IIUC there isn't a clock driver for
these clocks and are setup directly in the
drivers/net/wireless/ti/wl12xx/main.c driver.

So you can't make the WLAN chip dev node a consumer of these clocks by
adding a phandle to a clock provider and clock specifiers since there
isn't a provider to be referenced in the DT. Or did I misunderstand?

> Regards,
>
> Tony

Best regards,
Javier
