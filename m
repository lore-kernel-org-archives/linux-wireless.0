Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:6086 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbYFYN4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 09:56:35 -0400
Received: by rv-out-0506.google.com with SMTP id k40so8208629rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 06:56:34 -0700 (PDT)
Message-ID: <b6c5339f0806250656r7c7437e8o5bc629f4c9c30b67@mail.gmail.com> (sfid-20080625_155638_617441_B4F3389A)
Date: Wed, 25 Jun 2008 09:56:34 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH] ath5k: convert LED code to use mac80211 triggers
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <40f31dec0806250512x1a210cc0vef87c5ec44629cec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080622181134.GA26571@hash.localnet>
	 <40f31dec0806250512x1a210cc0vef87c5ec44629cec@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I do have a micro-update to this after reading over it one last time.
I'll post a respin tonight.

>>        tristate "Atheros 5xxx wireless cards support"
>>        depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
>> +       select MAC80211_LEDS
>> +       select LEDS_CLASS

+ select NEW_LEDS

Randy Dunlap posted a patch series a few weeks ago that said NEW_LEDS
was required where LEDS_CLASS was used.

>> -ath5k_led_off(unsigned long data)
>> +ath5k_led_enable(struct ath5k_softc *sc)
[..]
>> +       if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
>> +               ath5k_hw_set_gpio_output(sc->ah, sc->led_pin);
>> +               ath5k_hw_set_gpio(sc->ah, sc->led_pin, 0);

That was carried over from the original code but I think it was supposed to be:

>> +               ath5k_hw_set_gpio(sc->ah, sc->led_pin, !sc->led_on);

(This changes it from 'on' to 'off' but either way I'm not sure it matters.)

> I don't have an IBM card either, anyway we need the cleanup more than
> blinking leds :-)
>
>
> Acked-by: Nick Kossifidis <mickflemm@gmail.com>

Thanks!

-- 
Bob Copeland %% www.bobcopeland.com
