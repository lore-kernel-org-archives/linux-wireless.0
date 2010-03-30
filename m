Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:41278 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab0C3UNy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 16:13:54 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: CRDA and ath5k with no country code in EEPROM
References: <m3tys0tbhk.fsf@intrepid.localdomain>
	<m3eij3ym5k.fsf@intrepid.localdomain>
	<43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
	<m339zizz4o.fsf@intrepid.localdomain>
	<43e72e891003291256t7f53dcfck5f8c8cf94128eeb3@mail.gmail.com>
	<m3y6hayhv1.fsf@intrepid.localdomain>
	<43e72e891003291500w632cb789r6860dae9ccdf744c@mail.gmail.com>
	<m3r5n2qbo0.fsf@intrepid.localdomain>
	<43e72e891003300928qdd70de4vc7585d7e19d36dca@mail.gmail.com>
	<m3wrwtoekv.fsf@intrepid.localdomain>
	<43e72e891003301140p850093aya4ea6e1951e7ab9c@mail.gmail.com>
Date: Tue, 30 Mar 2010 22:13:51 +0200
In-Reply-To: <43e72e891003301140p850093aya4ea6e1951e7ab9c@mail.gmail.com>
	(Luis R. Rodriguez's message of "Tue, 30 Mar 2010 11:40:08 -0700")
Message-ID: <m3r5n1o9ds.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

>> Software (the official Atheros driver, to be precise) says 0 isn't
>> exactly US.
>> Hardware (card) manufacturer says 0 isn't US.
>
> Would it make you happy if I send a patch to clarify that?

That would fix a good part of the problem, yes. TIA.

> I've indicated that your card is already working as it was designed.

But that's not the case.

The Atheros _chips_ are probably working as designed. The card(s) does
not, since it was designed for European market, and its designer
confirms this. Yet, by default, this card (+ driver) enables channels
which should be disabled in Europe, and disables others, which should be
available.

This is caused by interaction between two pieces - the driver and the
card. Most probably each one of them, alone, is not at fault.

> The EEPROM is not something that was designed for end users to modify.

Though I'm not end user, I will leave it for others to modify, no
problem. I only need a proof (such as the driver printing "US") it
should be modified.

> Who programmed your EEPROM choose that for a reason, and only they and
> as per Atheros's documentation would know what the goal was,

and those who were told about it. The stated goal is known, and I assume
the calibration data is available as well (I don't have these cards
physically ATM).

> If you want to muck with the EEPROM/code for regulatory compliance
> that is up to you and that is simply not supported due to a few
> things. One of them is calibration data which may or not be available
> for the region you would choose blindly. Properly enabling users to
> change their regulatory domain at their own whim really requires more
> involvement, sure you'd be able to use some additional channels but it
> by no means would mean that they are in compliance or that the EIRP
> you use hits the actual desired target. The important part really is
> compliance.

Precisely. To be compliant I have to restrict usage to a specific set of
frequencies. Unfortunately it's a different set than the one in US.

> The regulatory code on for the Atheros drivers enables usage only of
> the channels dictated by the EEPROM and what we in software match that
> EEPROM code to tables in software. This is by design. The Linux
> regulatory framework allows you to further restrict the device further
> but for Atheros cards if you change countries you will not get new
> channels if your original programmed regulatory domain does not allow
> for it.

Yes, and it fits the needs nicely - if the card manufacturer's idea
about meaning of the EEPROM matches the driver.
-- 
Krzysztof Halasa
