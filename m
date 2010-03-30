Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63932 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab0C3Sk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 14:40:29 -0400
Received: by pva18 with SMTP id 18so2962675pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 11:40:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3wrwtoekv.fsf@intrepid.localdomain>
References: <m3tys0tbhk.fsf@intrepid.localdomain> <m3eij3ym5k.fsf@intrepid.localdomain>
	<43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
	<m339zizz4o.fsf@intrepid.localdomain> <43e72e891003291256t7f53dcfck5f8c8cf94128eeb3@mail.gmail.com>
	<m3y6hayhv1.fsf@intrepid.localdomain> <43e72e891003291500w632cb789r6860dae9ccdf744c@mail.gmail.com>
	<m3r5n2qbo0.fsf@intrepid.localdomain> <43e72e891003300928qdd70de4vc7585d7e19d36dca@mail.gmail.com>
	<m3wrwtoekv.fsf@intrepid.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Mar 2010 11:40:08 -0700
Message-ID: <43e72e891003301140p850093aya4ea6e1951e7ab9c@mail.gmail.com>
Subject: Re: CRDA and ath5k with no country code in EEPROM
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 11:21 AM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>
>> My point was that this is not something meant to be interpreted by
>> anyone for what "default country" means, the documentation I pointed
>> out clearly states that 0x0 is designed to mean to match the "US" by
>> Atheros hardware as per hardware documentation provided to ODMs.
>
> I understand this, but the reality is that I have to work with hardware
> and software, not with the docs provided by Atheros to some other
> parties.
>
> Software (the official Atheros driver, to be precise) says 0 isn't
> exactly US.
> Hardware (card) manufacturer says 0 isn't US.

Would it make you happy if I send a patch to clarify that?

> What do you think can I do?

I've indicated that your card is already working as it was designed.
The EEPROM is not something that was designed for end users to modify.
Who programmed your EEPROM choose that for a reason, and only they and
as per Atheros's documentation would know what the goal was,
regardless of what you see in software. I have tried clarifying to you
what the goal was, and if software uses a macro for "DEFAULT" for 0x0
just ignore that, I am telling you that is supposed to be "US".

If you want to muck with the EEPROM/code for regulatory compliance
that is up to you and that is simply not supported due to a few
things. One of them is calibration data which may or not be available
for the region you would choose blindly. Properly enabling users to
change their regulatory domain at their own whim really requires more
involvement, sure you'd be able to use some additional channels but it
by no means would mean that they are in compliance or that the EIRP
you use hits the actual desired target. The important part really is
compliance.

The regulatory code on for the Atheros drivers enables usage only of
the channels dictated by the EEPROM and what we in software match that
EEPROM code to tables in software. This is by design. The Linux
regulatory framework allows you to further restrict the device further
but for Atheros cards if you change countries you will not get new
channels if your original programmed regulatory domain does not allow
for it.

  Luis
