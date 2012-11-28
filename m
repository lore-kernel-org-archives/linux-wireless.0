Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep13.mx.upcmail.net ([62.179.121.33]:37010 "EHLO
	fep13.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2K1Onh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 09:43:37 -0500
Message-ID: <50B62317.1090001@think.ch> (sfid-20121128_154341_816489_4326C229)
Date: Wed, 28 Nov 2012 15:43:35 +0100
From: Erich Titl <erich.titl@think.ch>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: regulatory domain settings overwritten
References: <50B470CE.8070402@think.ch> <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com> <50B4B7B6.7020205@think.ch> <CAGRGNgXz9L+DBuxii7p+r0m2SEa0Xy1JgDZqGf2-8xWuHBYdfQ@mail.gmail.com> <50B5B915.2030706@think.ch> <CAGRGNgUzQk=m1vzp2+LbosDaddGnhwJC2P0cJHTW57EemNus+w@mail.gmail.com>
In-Reply-To: <CAGRGNgUzQk=m1vzp2+LbosDaddGnhwJC2P0cJHTW57EemNus+w@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090504040900010903030006"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dies ist eine kryptografisch unterzeichnete Nachricht im MIME-Format.

--------------ms090504040900010903030006
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Julian

on 28.11.2012 09:18, Julian Calaby wrote:
> Hi Erich,
>=20
> On Wed, Nov 28, 2012 at 6:11 PM, Erich Titl <erich.titl@think.ch> wrote=
:
>> Hi Julian
>>
=2E..

>=20
> So it's unlikely to have been tested to comply with Swiss regulations,
> therefore the EEPROM is set to use the defaults.

It is pretty unlikely to have been tested against US regulations either.

>=20
=2E...
>=20
> It's no different. In this case, the card saying "I don't know what I
> am" is specified to be equivalent to it saying "I'm a US card".

You don't really want to say that anyone who does not know better is a
US citizen ;-)

>=20
>>> The card is not "open", it's using the default configuration. The
>>> default configuration is that it's configured for US operation.
>>
>> No, it is not, the card pretends nothing, the driver does.
>=20
> The card says to use the default, the default is US.

And this IMHO is just plain wrong. US is not the navel of the world, if
there is one at all.

> ..
>=20
> We are required by law to do our best to ensure that the card complies
> with whatever regulations are in force, wherever we are in the world.
> The simplest way to do this is to ensure that we comply with every
> piece of information we have. If the card says that we're in the US
> and the user says we're in Switzerland, then we restrict it to the
> minimum of both sets of regulatory rules so that we can be sure that
> the card is, to the best of our knowledge, complying with the rules.

I know now, by inspecting the code that this is exactly what happens. I
agree with you that if the card says 'I am a US branded card' this is
the right thing to do.
I disagree though that for a card that says 'Never mind, just specify
your location' US is the right choice.

I believe instead of using

reg->country_code =3D CTRY_UNITED_STATES;

should be something like

reg->country_code =3D CTRY_NEUTRAL;

>=20
> On the other hand, some cheaper manufacturers use reference designs
> and keep things default to cut costs. Therefore the manufacturer of
> the chip specifies a default which is hard coded in the driver.

Yes, but the hard coded regdomain US is doubtful.

>=20
>> It's also
>>> possible that it can comply with the regulations perfectly, but has
>>> never been tested and had the EEPROM set to indicate that it can
>>> comply with them.
>>
>> Yes of course, it could be that way, but my past experience in IT lead=
s
>> me to believe that manufacturers shy away from market specific hardwar=
e
>> design. This is why the CM9 does not specify a country code, but a
>> 'default' setting.
>=20
> CM9 is getting rather old now and there are now facilities in the
> kernel to detect which region we're in from the information the phone
> would get from a cell phone tower, I don't know for sure, but I'd
> expect that this will be used in the future to ensure that we comply
> where possible.

For phones that may be a good thing, though I would not want my phone
somehow to sample my position without asking me. For things that don't
depend on the public telephone system this method is unsafe at best.

>=20
=2E..
>=20
> The default is not imposed by some midwest driver author, the default
> is imposed by the manufacturer of the chip as a default when the
> regulatory information is incorrect or unavailable.

Right, in EEPROM this is unavailable, but now the driver translates this
to a hardly comprehensible region which apparently is somehow restricted.=


>=20
> And this will be trying to use the card against it's specifications
> and will probably be rejected because of that.

That my or may not be the case. Anyway, cfg80211 can set the card to the
world domain and can also set it to country code CH. Unfortunately the
driver is overlaying this.

I tried several CTRY settings, as I don't want to mess up unnecessarily.
CRTY_DEFAUT just makes it cough.

What is a usable CTRY code to cover the broadest possible country range,
which can then be controlled through the correct country code. I could
use something like CTRY_AUSTRALIA but then that would be as bad as
CRTY_UNITED_STATES as it is not a neutral setting.

Is there a neutral CTRY value which does not mess up the worldwide settin=
gs?

And yes, we do not need to agree on the universalness of
CTRY_UNITED_STATES ;-)

Thanks

Erich



--------------ms090504040900010903030006
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Kryptografische Unterschrift

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
--------------ms090504040900010903030006--
