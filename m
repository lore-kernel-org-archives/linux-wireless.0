Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:51917 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYGICWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 22:22:10 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3387442rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 19:22:09 -0700 (PDT)
Message-ID: <b6c5339f0807081922q2941a597m6e135fc7fb907fb@mail.gmail.com> (sfid-20080709_042229_864639_D7475156)
Date: Tue, 8 Jul 2008 22:22:09 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Helge Deller" <deller@gmx.de>
Subject: Re: [ath5k-devel] [PATCH] ath5k: convert LED code to use mac80211 triggers
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <g50s14$8n1$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080622181134.GA26571@hash.localnet>
	 <20080626023528.GA16068@hash.localnet> <g50s14$8n1$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 8, 2008 at 7:08 PM, Helge Deller <deller@gmx.de> wrote:
> I tested it against Linus' head version (it applied with minor
> modifications) on my HP NC6000 laptop with this built-in Atheros card:
[...]
>
> Basically it works, but I think the sc->led_on in:
>> +     sc->led_on = 0;  /* active low */
>
> needs to be:
>> +     sc->led_on = 1;  /* active high */
> for the AR5212 in the HP laptop.

Thanks for the test!

> See also the changes to if_ath_pci.c in:
>  http://madwifi.org/attachment/ticket/1018/led.patch
> and
>  http://madwifi.org/ticket/1018
> for an old discussion about madwifi for LEDs in the HP box.

So current madwifi doesn't have this change unless I missed something?
 It appears to use active-low leds in the current version regardless
of the vendor.

> Without this change the LED stays on after a "rmmod ath5k" as well.

Yeah, that would definitely happen if the logic was backwards.  I
guess the conservative approach is to just use sc->led_on = 1 in the
VENDOR_ID_COMPAQ branch.

-- 
Bob Copeland %% www.bobcopeland.com
