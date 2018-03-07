Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:44907 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933468AbeCGQWz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 11:22:55 -0500
MIME-Version: 1.0
In-Reply-To: <e77d25d4-a824-380a-c51a-e81175ba6205@dd-wrt.com>
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
 <CACna6rzD6z3DC6yjMCgBxgxx+DF+GGu69Ot5QA6xpJ41Ewb2=A@mail.gmail.com>
 <82d8ac0c-b391-6099-4c7f-991cc35445aa@dd-wrt.com> <20180302090312.GA30267@amd>
 <e77d25d4-a824-380a-c51a-e81175ba6205@dd-wrt.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 7 Mar 2018 17:22:53 +0100
Message-ID: <CACna6rys85VEkzRGDVUAkBy7KgHS2y0DET7YvedboX-YEQHrkg@mail.gmail.com> (sfid-20180307_172259_498949_F39C6CF2)
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        "open list:LED SUBSYSTEM" <linux-leds@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 March 2018 at 10:22, Sebastian Gottschall <s.gottschall@dd-wrt.com> wr=
ote:
>>> leds-gpio is crap and limited. you can just register one platform data =
at
>>> kernel runtime since its identified by its object name "led-gpio" but t=
he
>>> kernel forbidds to register 2 platform datas with the same name
>>> consider the ar71xx devices with qca988x wifi chipsets. they all have
>>> already a led platform data registered
>>> at boottime. a second can't be registered anymore so gpio_led is useles=
s
>>> at
>>> all for most developers on such platforms. its mainly used for early
>>> kernel
>>> platform data initialisation for system leds.
>>
>> If leds-gpio has limitations, please fix those, rather then
>> introducing duplicated code.
>
> there is no duplicated code introduced and there is no solution for it.
> consider that all wifi drivers with softled support
> are going that way with registering a own led driver. see ath9k for
> instance. gpio-led cannot be used for it and there is no way to
> support multiple platform datas with the same name. its a kernel limitati=
on

I just reviewed some mips arch patch adding support for more LEDs for
selected devices:
[PATCH] MIPS: BCM47XX: Add Luxul XAP1500/XWR1750 WiFi LEDs
https://patchwork.linux-mips.org/patch/18681/

It seems to be simply adding another call to the
gpio_led_register_device(). It seems to me you can call that function
multiple times and register multiple structs with LEDs.

Isn't all you need something like this?

static const struct gpio_led ath10k_leds[] =3D {
        {
                .name =3D "ath10k:color:function",
                .active_low =3D 1,
                .default_state =3D LEDS_GPIO_DEFSTATE_KEEP,
        }
};

static struct gpio_led_platform_data bcm47xx_leds_pdata_extra =3D {
        leds =3D ath10k_leds;
        num_leds =3D ARRAY_SIZE(ath10k_leds);
};

ath10k_leds.gpio =3D ar->hw_params.led_pin;
gpio_led_register_device(0, &ath10k_leds);

--=20
Rafa=C5=82
