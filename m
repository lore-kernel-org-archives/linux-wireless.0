Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34377 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0C2T5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 15:57:10 -0400
Received: by pwi5 with SMTP id 5so6961114pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 12:57:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m339zizz4o.fsf@intrepid.localdomain>
References: <m3tys0tbhk.fsf@intrepid.localdomain> <43e72e891003281645m1da47a1en882df4432733977d@mail.gmail.com>
	<m3eij3ym5k.fsf@intrepid.localdomain> <43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
	<m339zizz4o.fsf@intrepid.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 29 Mar 2010 12:56:50 -0700
Message-ID: <43e72e891003291256t7f53dcfck5f8c8cf94128eeb3@mail.gmail.com>
Subject: Re: CRDA and ath5k with no country code in EEPROM
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 29, 2010 at 12:49 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>
>>> I'm not sure how the modified regulatory.bin could work, though:
>>> I really don't want to use restricted frequencies etc. when the
>>> regulatory domain is set to US (i.e. when operating in USA), I only want
>>> to use the extra channels etc. when in e.g. Europe.
>>
>> I agree with that wishful thinking, however current legislation does
>> now allow for dynamic enabling of frequencies on devices certified
>> under part 15 rules. We can likely work towards changing the
>> legislation for this but that's something I haven't seen many
>> companies willing to lobby for. We'd need a big company to help with
>> this lobby.
>
> But... isn't the modifying of the regulatory.bin (the US part of it)
> to include channels valid in e.g. Europe breaking the (US) rules?

Not if you sign off on it, which is exactly why the whole singing
thing was invented. You would do this if say, you sell an AP and you
verify and tested regulatory compliance against a different regulatory
region.

> I'm
> not asking you for a legal advice binding Atheros as the manufacturer in
> the USA, I'm asking how to enable the user to be technically compliant
> here in Europe where the hardware is sold, and also in the USA if the
> user gets there and sets the regdomain (and elsewhere in the world, in
> fact).

The only way to be legally compliant is if the vendor who you bought
the device from got regulatory testing for the device. That's all. Its
not cheap to do this work, so its also likely a reason why legislation
does not address this yet, and why SDR certification seems to be a
pain in the ass and no one I know is doing it these days.

IMHO the easy way to address this in legislation is simply to say that
if the user changes some regulatory components the liability passes on
to them. That would take care of the legal issues AFAICT. But we're
not there yet.

> Modifying regulatory.bin doesn't seem to help here, does it?
>
>>> A driver modification to ignore the default restrictions (while obeying
>>> the regulatory.bin, on a 0-country cards only, of course) - that would
>>> work.
>>
>> And it would also make our drivers break regulatory rules. We're not
>> going to do that on Linux because proving that we can be responsible
>> is in fact what does allow us to get proper vendor support for 802.11
>> drivers.
>
> I'm not asking you to do that, I only need to know if it's the correct
> (and only?) way of fixing this problem (while still providing
> compliance of the whole device). Fortunately I'm not responsible for the
> legalities.
>
>
> The other thing is the meaning of country=0 in case of Mikrotik cards
> (and maybe others). Perhaps they should get them back. I wonder if
> their drivers break the FCC rules, allowing "0" (=US) cards to use
> channels restricted in the US.

country code programmed to 0 is defined by Atheros documentation to be
in the "US". Mikrotek likely does their own testing for what they
allow, vendors who sell APs or hardware for APs have to anyway, as
Atheros does not do this for those customers.

  Luis
