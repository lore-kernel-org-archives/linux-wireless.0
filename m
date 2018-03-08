Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49138 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932085AbeCHPqR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:46:17 -0500
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Pavel Machek <pavel@ucw.cz>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
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
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <1b1f6344-d588-d2f2-4b3d-a0a4043e801f@nbd.name> (sfid-20180308_164621_949287_CE40A981)
Date: Thu, 8 Mar 2018 16:46:11 +0100
MIME-Version: 1.0
In-Reply-To: <20180308140515.GA4889@amd>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-08 15:05, Pavel Machek wrote:
> On Thu 2018-03-08 13:33:29, Sebastian Gottschall wrote:
>> Am 08.03.2018 um 10:02 schrieb Pavel Machek:
>> >On Wed 2018-03-07 18:54:41, Sebastian Gottschall wrote:
>> >>Am 07.03.2018 um 17:22 schrieb Rafał Miłecki:
>> >>>On 2 March 2018 at 10:22, Sebastian Gottschall <s.gottschall@dd-wrt.com> wrote:
>> >>>>>>leds-gpio is crap and limited. you can just register one platform data at
>> >>>>>>kernel runtime since its identified by its object name "led-gpio" but the
>> >>>>>>kernel forbidds to register 2 platform datas with the same name
>> >>>>>>consider the ar71xx devices with qca988x wifi chipsets. they all have
>> >>>>>>already a led platform data registered
>> >>>>>>at boottime. a second can't be registered anymore so gpio_led is useless
>> >>>>>>at
>> >>>>>>all for most developers on such platforms. its mainly used for early
>> >>>>>>kernel
>> >>>>>>platform data initialisation for system leds.
>> >>>>>If leds-gpio has limitations, please fix those, rather then
>> >>>>>introducing duplicated code.
>> >>>>there is no duplicated code introduced and there is no solution for it.
>> >>>>consider that all wifi drivers with softled support
>> >>>>are going that way with registering a own led driver. see ath9k for
>> >>>>instance. gpio-led cannot be used for it and there is no way to
>> >>>>support multiple platform datas with the same name. its a kernel limitation
>> >>>I just reviewed some mips arch patch adding support for more LEDs for
>> >>>selected devices:
>> >>>[PATCH] MIPS: BCM47XX: Add Luxul XAP1500/XWR1750 WiFi LEDs
>> >>>https://patchwork.linux-mips.org/patch/18681/
>> >>>
>> >>>It seems to be simply adding another call to the
>> >>>gpio_led_register_device(). It seems to me you can call that function
>> >>>multiple times and register multiple structs with LEDs.
>> >>>
>> >>>Isn't all you need something like this?
>> >>>
>> >>>static const struct gpio_led ath10k_leds[] = {
>> >>>         {
>> >>>                 .name = "ath10k:color:function",
>> >>>                 .active_low = 1,
>> >>>                 .default_state = LEDS_GPIO_DEFSTATE_KEEP,
>> >>>         }
>> >>>};
>> >>>
>> >>>static struct gpio_led_platform_data bcm47xx_leds_pdata_extra = {
>> >>>         leds = ath10k_leds;
>> >>>         num_leds = ARRAY_SIZE(ath10k_leds);
>> >>>};
>> >>>
>> >>>ath10k_leds.gpio = ar->hw_params.led_pin;
>> >>>gpio_led_register_device(0, &ath10k_leds);
>> >>the problem are other architectures which have already registered gpio_led
>> >>at system start like ar71xx
>> >>you cannot register a second one. so a independend led driver is a
>> >>requirement for direct control
>> >If the limitation indeed exists, please fix the limitation rather than
>> >working around it in each and every driver.
>> see ath9k. its exact the same implementation.
> 
> Ok, so one more driver to fix.
> 
>> in addition my variant does also work without gpiolib support. so it can be
>> used even if the kernel is configured
>> without gpio support.
>> and not to forget, using a own led driver is more ligthweight from the call
>> path for each led on / off event which is important for
>> low performance embedded devices
> 
> We are not going to copy&paste code because such code works without
> libraries, and we are not going to copy&paste code because that uses
> less cache during calls. Sorry.
> 
> NAK. Please fix your patch. Since this discussion seems to have taken a rather weird turn, I've
taken a look at the specific code, and from my point of view the code
that sets up the LED (including callback) is so trivial that it's simply
not worth dealing with adding the leds-gpio driver to the mix.
It adds extra complexity and an extra dependency for no reason at all.
There's no extra functionality to be gained by using it.

- Felix
