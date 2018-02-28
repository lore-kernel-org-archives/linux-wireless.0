Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:43778 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751521AbeB1Bty (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 20:49:54 -0500
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:LED SUBSYSTEM" <linux-leds@vger.kernel.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
 <CACna6rzD6z3DC6yjMCgBxgxx+DF+GGu69Ot5QA6xpJ41Ewb2=A@mail.gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <82d8ac0c-b391-6099-4c7f-991cc35445aa@dd-wrt.com> (sfid-20180228_024958_627428_43E94EC2)
Date: Wed, 28 Feb 2018 02:49:44 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rzD6z3DC6yjMCgBxgxx+DF+GGu69Ot5QA6xpJ41Ewb2=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 27.02.2018 um 23:08 schrieb Rafał Miłecki:
> On 26 February 2018 at 09:44,  <s.gottschall@dd-wrt.com> wrote:
>> From: Sebastian Gottschall <s.gottschall@newmedia-net.de>
>>
>> Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984 based chipsets with on chipset connected led's
>> using WMI Firmware API.
>> The LED device will get available named as "ath10k-phyX" at sysfs and can be controlled with various triggers.
>> adds also debugfs interface for gpio control.
> Hi Sebastian,
>
> I just noticed this patch and have one question. It seems you register
> GPIO chip and that WiFi LED is controller by a GPIO. Shouldn't you use
> leds-gpio driver and just register platform device with
> gpio_led_platform_data? That way you could avoid some code duplication
> I think? It seems to be the purpose of leds-gpio driver.
leds-gpio is crap and limited. you can just register one platform data 
at kernel runtime since its identified by its object name "led-gpio" but 
the kernel forbidds to register 2 platform datas with the same name
consider the ar71xx devices with qca988x wifi chipsets. they all have 
already a led platform data registered
at boottime. a second can't be registered anymore so gpio_led is useless 
at all for most developers on such platforms. its mainly used for early 
kernel platform data initialisation for system leds.
at the beginning of development of this patch i started in that way and 
found out this limitation, so i had to rewrite everything.
the good point now is, it works even without gpiolib support since the 
gpio device is just a option, but not required for led control.

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
