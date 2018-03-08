Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:37177 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756023AbeCHPb7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:31:59 -0500
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Pavel Machek <pavel@ucw.cz>
Cc: Rafa?? Mi??ecki <zajec5@gmail.com>,
        "open list:LED SUBSYSTEM" <linux-leds@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
References: <CACna6rzD6z3DC6yjMCgBxgxx+DF+GGu69Ot5QA6xpJ41Ewb2=A@mail.gmail.com>
 <82d8ac0c-b391-6099-4c7f-991cc35445aa@dd-wrt.com>
 <20180302090312.GA30267@amd>
 <e77d25d4-a824-380a-c51a-e81175ba6205@dd-wrt.com>
 <CACna6rys85VEkzRGDVUAkBy7KgHS2y0DET7YvedboX-YEQHrkg@mail.gmail.com>
 <890a4dcc-f549-6487-2ce5-3b62874cd266@dd-wrt.com>
 <20180308090216.GC17761@amd>
 <d443856e-cfc8-2d50-900d-edf22e5360e3@dd-wrt.com> <20180308140515.GA4889@amd>
 <c2d75791-5822-ac55-35ad-734947e22d45@dd-wrt.com>
 <20180308150431.GA12475@localhost>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <d7f09cd5-c434-a2bb-c721-68e90c0c72b6@dd-wrt.com> (sfid-20180308_163203_044721_FFD42FD3)
Date: Thu, 8 Mar 2018 16:31:52 +0100
MIME-Version: 1.0
In-Reply-To: <20180308150431.GA12475@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 08.03.2018 um 16:04 schrieb Pavel Machek:
> Hi!
>
>> show me a proof that its copy & paste. because its not
> I don't have to prove you anything. Sorry.
then i will deny your argument because its false.
>
> But you said:
>
>>>> see ath9k. its exact the same implementation.
> We don't want to have exact same code multiple times in the tree.
it isnt the exact same code, its just the way its done. i mean 
registering a led driver function happens multiple times in the kernel
you cannot say that calling led_classdev_register with the required 
parameters and function implementation is a case of code duplication.
then i would just say using of "printk" is a case of code duplication.
registering a led driver is nothing unusual, the implementation of the 
led driver is different each time. the implementation for led_brightness 
is very different
there are many led drivers in the kernel. all are going the same way.

i checked the kernel drivers just right now. almost all major wireless 
drivers are comming with a led driver without using gpiolib
your way is a case of codebloating since a registering gpio-leds 
requires a gpio driver for each wireless driver, even if its sometimes 
just a single register write for a led  and no real gpio.
a gpio driver is more complex and bigger than just a led driver. i just 
wrote a optional gpio driver to get access to all gpios available on the 
card. some vendors are using these in a unusual way
i have seen that vendors used them for reset button input etc. this is 
why i made it. so dont take this as a argument for going a impossible 
way (again. the kernel does not support multiple platform datas with the 
same name
THE KERNEL not leds-gpio. so once a leds-gpio platform data is 
registered, no other driver can register a new one.
in addition the kernel must have gpiolib support which increases the 
kernel size. the best way is always the most simple way and the smallest 
performant way.

and again. i did not duplicate the code of ath9k, i just used it as 
documentation to write a own led driver in a simple way

now a list of wireless drivers with a led driver
intersil
carl9170
ath5k
rt2x00
b43legacy
b43
iwlegacy
rtl8187
brcmsmac
iwlwifi

Sebastian

>   
> 									Pavel


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
