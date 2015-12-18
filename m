Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34464 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbbLROqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 09:46:52 -0500
Received: by mail-ob0-f176.google.com with SMTP id iw8so80841381obc.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2015 06:46:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKdAkRR6kEzEOtjxXqS4BPToEzKGBsLb=SzePFAiLSDhh+=qnw@mail.gmail.com>
References: <1449666515-23343-1-git-send-email-linus.walleij@linaro.org>
	<20151209193034.GE27131@dtor-ws>
	<CACRpkdZDFPFOH=9FfYzLeKo5b-oXG4rPjoU4Rpq9Wv1-RvY6uQ@mail.gmail.com>
	<CAKdAkRR6kEzEOtjxXqS4BPToEzKGBsLb=SzePFAiLSDhh+=qnw@mail.gmail.com>
Date: Fri, 18 Dec 2015 15:46:51 +0100
Message-ID: <CACRpkdb+jJyt1DLqsMfbFJ+md1mUrFprzG1m+6W2S-9pZV+PxA@mail.gmail.com> (sfid-20151218_154703_081817_F5D2F8E1)
Subject: Re: [PATCH 000/182] Rid struct gpio_chip from container_of() usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Michael Welling <mwelling@ieee.org>,
	Markus Pargmann <mpa@pengutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Brown <broonie@kernel.org>,
	Amit Kucheria <amit.kucheria@linaro.org>,
	"arm@kernel.org" <arm@kernel.org>,
	Haavard Skinnemoen <hskinnemoen@gmail.com>,
	Sonic Zhang <sonic.zhang@analog.com>,
	Greg Ungerer <gerg@uclinux.org>,
	Ralf Baechle <ralf@linux-mips.org>,
	Linux MIPS <linux-mips@linux-mips.org>,
	Anatolij Gustschin <agust@denx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>,
	Lee Jones <lee.jones@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2015 at 8:25 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Mon, Dec 14, 2015 at 1:18 AM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> At this point we have to cross-reference the pointer to my chip to
>> find the chip to remove. This goes for anything that takes the struct
>> gpio_chip *
>> as parameter, like gpiochip_add_pin_range(), gpiochip_request_own_desc()
>> etc etc. So something inside gpiolib must take a gpio_chip * pointer and
>> turn that into the actual state container, e.g, a struct gpio_device.
>> Since struct gpio_chip needs to be static and stateless, it cannot contain
>> a pointer back to its struct gpio_device.
>
> Why does gpio_chip have to be stateless? I am not saying that it
> should or should not, I just want to better understand what you are
> trying to achieve.

Because the allocation of gpio_chip is currently inside each driver
(often as part of their own state struct) and will go away with the
driver. I want to make that const parameter that the drivers supply
to the core gpiolib, and the gpiolib handled all states using something
like that struct gpio_device you suggested or a more elaborate
solution.

>> If I compare to how struct input_dev is done, you appear to also use the
>> pattern Russell suggested with input_dev_allocate() akin to
>> netdev_alloc(), and the allocated struct holds all the vtable and states etc,
>> and I think it is a good pattern, and that GPIO should conform.
>
> The main difference between gpio_chip (at least as it stands
> currently) and input devices and corresponding private driver data is
> that input device and driver data has different lifetimes; input
> devices may stick around even though driver is unbound from
> corresponding device and driver's private data freed.

I would like to achieve something similar for GPIO devices.

Yours,
Linus Walleij
