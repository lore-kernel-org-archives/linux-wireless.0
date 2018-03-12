Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:32968 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbeCLH4E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 03:56:04 -0400
Received: by mail-wr0-f178.google.com with SMTP id v18so14616063wrv.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2018 00:56:03 -0700 (PDT)
From: Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Julian Calaby <julian.calaby@gmail.com>,
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
 <40dc5bc3-d77e-397d-f3db-2efb70ff82ae@dd-wrt.com>
Message-ID: <4345c367-e786-ef44-fed7-8658f519a689@kresin.me> (sfid-20180312_085609_422894_AF75B5BF)
Date: Mon, 12 Mar 2018 08:53:50 +0100
MIME-Version: 1.0
In-Reply-To: <40dc5bc3-d77e-397d-f3db-2efb70ff82ae@dd-wrt.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.03.2018 08:56, Sebastian Gottschall:
> 
>>> taken a look at the specific code, and from my point of view the code
>>> that sets up the LED (including callback) is so trivial that it's simply
>>> not worth dealing with adding the leds-gpio driver to the mix.
>>> It adds extra complexity and an extra dependency for no reason at all.
>>> There's no extra functionality to be gained by using it.
>> Stupid question: If the LED driver isn't using the GPIO subsystem
>> (when enabled), what happens if the user uses the GPIO subsystem to
>> fiddle with the pin the LED is connected to?
> 
> in our case here it can coexist and will not have a negative effect 
> since the led will still run. (except if you reconfigure the gpio to input)
> for sure it makes no sense.

Well, it will have negative effects as I noticed in OpenWrt. If the same 
GPIO is controlled by the internal LED function it can't be really used 
via the GPIO controller as there will be "bogus" changes of the GPIO pin 
state.

> but however i can block the gpio for beeing reused if the led driver 
> took it. this has been made in ath9k for instance.

Most likely I'm not aware of the upstream code you are talking about. 
But OpenWrt has a custom patch which registers the ath9k pins as GPIO 
controller.

As soon as there are pins, manufactures will use them and the assumption 
about a default led connected to a specific pin will fail.

I've seen (home)routers routers using the "default" ath9k LED pin as 
button or for LEDs with a different purpose than "wireless". I never was 
able to find any kind of information which explains why exactly this 
specific pin is used for the ath9k-led. But that's another story.

My solution for OpenWrt was a patch which prevents the creation of the 
ath9k-led if the "default" pin is used as GPIO.

If mach files are used, the ath9k led isn't created (ath9k led pin is 
set to -1) in case the platform data have a button or led using the same 
pin. If the device tree is used, the ath9k led isn't created (ath9k led 
pin is set to -1) if the devicetree node for the ath9k device has the 
gpio-controller property. I'm not really proud of the code and it can be 
most likely done better, but it fixes the issue outlined above.

I've done it this way since the use of the GPIO controller should always 
override any kind of default LEDs.

In the end ath[0|10]k-led is only required for hardware configurations 
where the wireless isn't fixed like with miniPCIe, USB ... wireless 
cards. If the configuration is fixed - like it is for most of the 
(home)routers - the GPIO controller can be registered via the devicetree 
and gpio-leds can be used. Something similar can be most likely done via 
mach files (I barely touch mach files).

I'm aware of the issue since the first version of your patch. But since 
I'm very interested in getting the ath10k pins exposed as gpio 
controller, I planned to add a workaround similar to what we have for 
ath9k to OpenWrt.

Mathias
