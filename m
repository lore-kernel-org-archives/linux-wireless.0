Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:51552 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750829AbeCJH4P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 02:56:15 -0500
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Julian Calaby <julian.calaby@gmail.com>,
        Felix Fietkau <nbd@nbd.name>
Cc: Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:LED SUBSYSTEM" <linux-leds@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
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
 <1b1f6344-d588-d2f2-4b3d-a0a4043e801f@nbd.name>
 <CAGRGNgWSnObB8PomPPEGs533dmFyQQkOEsvxzyJ=BfBBcWT2Ug@mail.gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <40dc5bc3-d77e-397d-f3db-2efb70ff82ae@dd-wrt.com> (sfid-20180310_085631_212069_AEB70739)
Date: Sat, 10 Mar 2018 08:56:07 +0100
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWSnObB8PomPPEGs533dmFyQQkOEsvxzyJ=BfBBcWT2Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> taken a look at the specific code, and from my point of view the code
>> that sets up the LED (including callback) is so trivial that it's simply
>> not worth dealing with adding the leds-gpio driver to the mix.
>> It adds extra complexity and an extra dependency for no reason at all.
>> There's no extra functionality to be gained by using it.
> Stupid question: If the LED driver isn't using the GPIO subsystem
> (when enabled), what happens if the user uses the GPIO subsystem to
> fiddle with the pin the LED is connected to?

in our case here it can coexist and will not have a negative effect 
since the led will still run. (except if you reconfigure the gpio to input)
for sure it makes no sense.
but however i can block the gpio for beeing reused if the led driver 
took it. this has been made in ath9k for instance.
in ath10k i did not do it, since there is no technical requirement for it.
but that might not be the case for all gpio controllers, so there is no 
generic answer. for ath10k. harmless

Sebastian
>
> Thanks,
>

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
