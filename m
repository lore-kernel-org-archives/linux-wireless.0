Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33774 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbbLITai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 14:30:38 -0500
Date: Wed, 9 Dec 2015 11:30:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, Johan Hovold <johan@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Michael Welling <mwelling@ieee.org>,
	Markus Pargmann <mpa@pengutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Brown <broonie@kernel.org>,
	Amit Kucheria <amit.kucheria@linaro.org>, arm@kernel.org,
	Haavard Skinnemoen <hskinnemoen@gmail.com>,
	Sonic Zhang <sonic.zhang@analog.com>,
	Greg Ungerer <gerg@uclinux.org>,
	Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
	Anatolij Gustschin <agust@denx.de>,
	linux-wireless@vger.kernel.org, linux-input@vger.kernel.org,
	Lee Jones <lee.jones@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 000/182] Rid struct gpio_chip from container_of() usage
Message-ID: <20151209193034.GE27131@dtor-ws> (sfid-20151209_203044_336639_141DA88E)
References: <1449666515-23343-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449666515-23343-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 09, 2015 at 02:08:35PM +0100, Linus Walleij wrote:
> This removes the use of container_of() constructions from *all*
> GPIO drivers in the kernel. It is done by instead adding an
> optional void *data pointer to the struct gpio_chip and an
> accessor function, gpiochip_get_data() to get it from a driver.
> 
> WHY?
> 
> Because we want to have a proper userspace ABI for GPIO chips,
> which involves using a character device that the user opens
> and closes. While the character device is open, the underlying
> kernel objects must not go away.
> 
> Currently the GPIO drivers keep their state in the struct
> gpio_chip, and that is often allocated by the drivers, very
> often as a part of a containing per-instance state container
> struct for the driver:
> 
> struct foo_state {
>    struct gpio_chip chip;  <- OMG my state is there
> };
> 
> Drivers cannot allocate and manage this state: if a user has the
> character device open, the objects allocated must stay around
> even if the driver goes away. Instead drivers need to pass a
> descriptor to the GPIO core, and then the core should allocate
> and manage the lifecycle of things related to the device, such
> as the chardev itself or the struct device related to the GPIO
> device.

Yes, but it does not mean that the object that is being maintained by
the subsystem and that us attached to character device needs to be
gpio_chip itself. You can have something like

struct gpio_chip_chardev {
	struct cdev chardev;
	struct gpio_chip *chip;
	bool dead;
};

struct gpio_chip {
	...
	struct gpio_chip_chardev *chardev;
	...
};

You alloctae the new structure when you register/export gpio chip in
gpio subsystem core and leave all the individual drivers alone.

Thanks.

-- 
Dmitry
