Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53127 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab2HPWd6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 18:33:58 -0400
Message-ID: <502D754F.9090908@hauke-m.de> (sfid-20120817_003401_826673_0121034A)
Date: Fri, 17 Aug 2012 00:33:51 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: John Crispin <john@phrozen.org>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/3] MIPS: BCM47xx: rewrite GPIO handling and use gpiolib
References: <1345132801-8430-1-git-send-email-hauke@hauke-m.de> <1345132801-8430-4-git-send-email-hauke@hauke-m.de> <502D4B70.4010509@phrozen.org>
In-Reply-To: <502D4B70.4010509@phrozen.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2012 09:35 PM, John Crispin wrote:
> On 16/08/12 18:00, Hauke Mehrtens wrote:
>> int gpio_get_value(unsigned gpio)
>> +{
>> +	if (gpio < bcm47xx_gpio_count)
>> +		return bcm47xx_gpio_in(1 << gpio);
>> +
>> +	return __gpio_get_value(gpio);
>> +}
>> +EXPORT_SYMBOL(gpio_get_value);
> 
> Hi,
> 
> You are using a gpio_chip. simply doing this
> 
> #define gpio_get_value __gpio_get_value
> 
> inside your arch/mips/include/asm/mach-bcm47xx/gpio.h will be enough.
> __gpio_get_value() will then automatically find and use
> bcm47xx_gpio_get_value() via the gpio_chip.

With this code gpio_get_value() is faster as the hole gpiolib is not
called for the get and set methods. I assume then these gpios are the
first being registered and all calls to these gpios are directly handled
by this methods and are not going through the gpiolib code.
This is based on the way it is done for ath79.

Hauke


