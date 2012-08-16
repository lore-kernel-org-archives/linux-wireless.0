Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36358 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab2HPTgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 15:36:24 -0400
Message-ID: <502D4B70.4010509@phrozen.org> (sfid-20120816_213627_710429_321C877B)
Date: Thu, 16 Aug 2012 21:35:12 +0200
From: John Crispin <john@phrozen.org>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/3] MIPS: BCM47xx: rewrite GPIO handling and use gpiolib
References: <1345132801-8430-1-git-send-email-hauke@hauke-m.de> <1345132801-8430-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1345132801-8430-4-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/08/12 18:00, Hauke Mehrtens wrote:
> int gpio_get_value(unsigned gpio)
> +{
> +	if (gpio < bcm47xx_gpio_count)
> +		return bcm47xx_gpio_in(1 << gpio);
> +
> +	return __gpio_get_value(gpio);
> +}
> +EXPORT_SYMBOL(gpio_get_value);

Hi,

You are using a gpio_chip. simply doing this

#define gpio_get_value __gpio_get_value

inside your arch/mips/include/asm/mach-bcm47xx/gpio.h will be enough.
__gpio_get_value() will then automatically find and use
bcm47xx_gpio_get_value() via the gpio_chip.

John
