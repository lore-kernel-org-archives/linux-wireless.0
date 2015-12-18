Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34463 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbbLROm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 09:42:29 -0500
Received: by mail-oi0-f50.google.com with SMTP id o124so60622053oia.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2015 06:42:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151214124626.GG23327@localhost>
References: <1449666515-23343-1-git-send-email-linus.walleij@linaro.org>
	<20151209134410.GH8644@n2100.arm.linux.org.uk>
	<CACRpkdZcz73vtgZsCKZCJ=G3nq-yCPiO8hws4ro5HVWd8AVRCw@mail.gmail.com>
	<20151214124626.GG23327@localhost>
Date: Fri, 18 Dec 2015 15:42:27 +0100
Message-ID: <CACRpkdZ9vZmMWHemb8_XDwdhMDjMNoE7EyLUSnvVS6R5yU3i_A@mail.gmail.com> (sfid-20151218_154236_438775_578FDBFA)
Subject: Re: [PATCH 000/182] Rid struct gpio_chip from container_of() usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Michael Welling <mwelling@ieee.org>,
	Markus Pargmann <mpa@pengutronix.de>,
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
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2015 at 1:46 PM, Johan Hovold <johan@kernel.org> wrote:

> Ok, but let's take a step back. So you have all this in place and a
> consumer calls gpiod_get_value() that returns an errno because the device
> is gone. Note that this wasn't even possible before e20538b82f1f ("gpio:
> Propagate errors from chip->get()") that went into *v4.3*, and I assume
> most drivers would need to be updated to even handle that that gpio
> call, and all future calls, are now suddenly failing.

I actually have a revert of that in my fixes queue. So another step back
and two forward for v4.5 (hopefully): audit all drivers to respect this.

Yours,
Linus Walleij
