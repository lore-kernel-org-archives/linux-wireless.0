Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:52310 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752023AbeCHOnq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 09:43:46 -0500
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Kalle Valo <kvalo@codeaurora.org>, Pavel Machek <pavel@ucw.cz>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:LED SUBSYSTEM" <linux-leds@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
 <CACna6rzD6z3DC6yjMCgBxgxx+DF+GGu69Ot5QA6xpJ41Ewb2=A@mail.gmail.com>
 <82d8ac0c-b391-6099-4c7f-991cc35445aa@dd-wrt.com>
 <20180302090312.GA30267@amd>
 <e77d25d4-a824-380a-c51a-e81175ba6205@dd-wrt.com>
 <CACna6rys85VEkzRGDVUAkBy7KgHS2y0DET7YvedboX-YEQHrkg@mail.gmail.com>
 <890a4dcc-f549-6487-2ce5-3b62874cd266@dd-wrt.com>
 <20180308090216.GC17761@amd>
 <d443856e-cfc8-2d50-900d-edf22e5360e3@dd-wrt.com> <20180308140515.GA4889@amd>
 <87371ahc8f.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <002c7d68-78cd-a3ef-5b60-b69d8c554fd3@dd-wrt.com> (sfid-20180308_154350_725851_F5F23DF8)
Date: Thu, 8 Mar 2018 15:43:40 +0100
MIME-Version: 1.0
In-Reply-To: <87371ahc8f.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 08.03.2018 um 15:29 schrieb Kalle Valo:
> Pavel Machek <pavel@ucw.cz> writes:
>
>>>>>> ath10k_leds.gpio = ar->hw_params.led_pin;
>>>>>> gpio_led_register_device(0, &ath10k_leds);
>>>>> the problem are other architectures which have already registered gpio_led
>>>>> at system start like ar71xx
>>>>> you cannot register a second one. so a independend led driver is a
>>>>> requirement for direct control
>>>> If the limitation indeed exists, please fix the limitation rather than
>>>> working around it in each and every driver.
>>> see ath9k. its exact the same implementation.
>> Ok, so one more driver to fix.
>>
>>> in addition my variant does also work without gpiolib support. so it
>>> can be used even if the kernel is configured without gpio support.
>>> and not to forget, using a own led driver is more ligthweight from
>>> the call path for each led on / off event which is important for low
>>> performance embedded devices
>> We are not going to copy&paste code because such code works without
>> libraries, and we are not going to copy&paste code because that uses
>> less cache during calls. Sorry.
>>
>> NAK. Please fix your patch.
> To me it's not that black and white, sometimes copying code is simpler
> than trying to bring up complicated or restricting frameworks (talking
> in general here).
>
> I haven't been able to review this patch in detail yet but from a quick
> look most of the code is about standard ath10k infrastructure code. How
> many lines of code would using leds-gpio save?
nothing. the led driver code is already very small. (see gpio.c in the 
patch) i had a leds-gpio implementation but it will not work since a 
platform data with the name "leds-gpio" does already exist on various 
platforms (ath79 for instance)
so a second leds-gpio can't be registered. so this solution does simply 
not work and asking me for fixing the kernel generic platform data 
handling like pavel did, is really out of mind
and a own led driver has also better performance than using the 
leds-gpio->gpiolib->ath10k gpio driver callpath.
if someone is still complaining that i added a gpio feature driver as 
well to my patch, i can simply remove that usefull feature and all would 
be happy. but i think having access to all gpios of the card
instead of just the led gpio makes sense to. thats why i implemented a 
gpiolib driver as well

Sebastian


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
