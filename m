Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:20484 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbZBIQWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 11:22:16 -0500
Received: by wa-out-1112.google.com with SMTP id v33so940904wah.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 08:22:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090209151221.M9585@bobcopeland.com>
References: <f9d2a5e10902082209h33afe4dey4930f23c3f178bc8@mail.gmail.com>
	 <20090209151221.M9585@bobcopeland.com>
Date: Mon, 9 Feb 2009 09:22:16 -0700
Message-ID: <f9d2a5e10902090822i36989c8bl45c4a34c0cbb90b8@mail.gmail.com> (sfid-20090209_172220_651293_BAE263DA)
Subject: Re: ath5k LEDs on Acer Ferrari 5000 laptop
From: Russ Dill <russ.dill@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 9, 2009 at 8:14 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sun, 8 Feb 2009 23:09:49 -0700, Russ Dill wrote
>> I have an Acer Ferrari 5000 laptop with an ath5k wireless chipset. It
>> has an LED built into the rfkill switch on the front of the laptop. I
>> testing various settings within the ath5k driver an the led is on pin
>> 1 (sc->led_pin = 1) and it is active high (sc->led_on).
>
> When you say it is hooked up to rfkill, do you mean that enabling
> the rfkill turns off the led without the emachines patch?  Some
> laptops have the led tied to rfkill in such a way that we don't
> actually need/want to program it from software.
>

I mean that there is a physical rfkill switch (actually more like a
toggle button) on the laptop:

http://i146.photobucket.com/albums/r245/MechNinja/IMG_2844.jpg

Because they are just buttons and not actual switches, they are lights
that should indicate whether or not a radio is on or off. This works
for bluetooth, but not for wireless lan. Without informing the driver
of the LED pin, the wireless lan LED never lights. Its a 100% soft
LED.

So no, the LED does not work with or without the emachines patch. It
only works if I instead set sc->led_pin to 1 and sc->led_on to 1. I
only mention the emachines patch because it tries to cover 100% of
AMBIT systems, whereas my laptop wireless chipset identifies as AMBIT,
but its LED is wired differently.
