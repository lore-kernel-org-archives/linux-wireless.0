Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZCVVdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 17:33:14 -0400
Subject: Re: [RFC] regulatory information interpretation rules
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Quan <David.Quan@atheros.com>
In-Reply-To: <43e72e890903221348q3db85b30k7975d996c5269c28@mail.gmail.com> (sfid-20090322_214839_974223_5BC1E9BB)
References: <1237712542.5100.766.camel@johannes.local>
	 <43e72e890903221348q3db85b30k7975d996c5269c28@mail.gmail.com>
	 (sfid-20090322_214839_974223_5BC1E9BB)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QXa3k3lXaPVtKh6FBnUv"
Date: Sun, 22 Mar 2009 22:33:03 +0100
Message-Id: <1237757583.19647.50.camel@johannes.local> (sfid-20090322_223317_454457_55BC227D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QXa3k3lXaPVtKh6FBnUv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-22 at 13:48 -0700, Luis R. Rodriguez wrote:

> >  1) MIN values are really something like MIN+, i.e. approaching the MIN
> >    from above, that means that the value "2452 MHz" falls into the
> >    first of the ranges, not the second [3]
>=20
> I rather be more exact. Can you elaborate a little more on this?

Hmm, ok, well, let me put it this way:

Given

	MIN - MAX @ ...

and centre =3D MIN, we do not say that centre falls into that range.

Basically we do "MIN < freq <=3D MAX" rather than "MIN <=3D freq <=3D MAX" =
to
avoid problems with
	A - B @ ...
	B - C @ ...
and then determining which range "B" falls into. My interpretation says
that it belongs into the _first_ rather than the second range.

> > "Channels 1-11 allow 40 width channels, so HT40 is allowed."
> >
> >        Channel 11 has center frequency 2462, but when used with HT40
> >        the center of the used bandwidth falls to 2452 or 2472.
>=20
> >        2452 falls into the first range, so can use 40 MHz,
>=20
> Hm, so the two modified rules that we should look at for a channel
> who's center freq is 2452 MHz are:
>=20
>         ( 2402.000 - *2452.000 @ 40.000), (N/A, 20.00)
>         (*2452.000 -  2482.000 @ 20.000), (N/A, 20.00)
>=20
> I cannot clearly see how a 40 MHz width channel would be allowed here
> if its center of freq is 2452 MHz given the interpretation rules
> above.

This is why I needed the rule 1), to specify that 2452 falls into the
first range which specifies @40.

> It would seem to me the two regulatory rules would be required
> to make that determination since the start freq and end freq of the
> HT40 channel would only fit when considering both rules. Why would we
> determine we can use 40 MHz on this HT40 channel? What if the allowed
> bandwidth for the second rule was 10 MHz instead of 20 MHz?

That seems irrelevant -- I said that the maximum usable bandwidth
depends on the range the centre frequency falls into, and all the ranges
we've defined.

Maybe I should clarify some things more -- it was obvious to me after
thinking about it, but I suppose I formulated it more as a mathematician
than a recipe for an engineer ;)

> The overlapping suggestions make sense.
>=20
> Apart from creating a clarification on how we would deal with
> overlapping regulatory rules this also clarifies the way we should
> logically think of channels in terms of regulatory for our
> infrastructure. 802.11 HT40 channels are now viewed as a singular
> channel with its own center of frequency and the question that is
> asked is:
>=20
> "is this HT40 channel allowed?"

Right. It's also a clarification that overlapping ranges should not be
allowed (and we should thus check for that somewhere), and how to handle
all the possible cases without overlapping ranges, mostly due to 2).

> The notion of the two channels involved required to make use of HT40
> work is ignored and while this works it should be considered for
> implementation.

Indeed, this is first and foremost a definition of how to interpret the
database that we have, and not how to implement it.

> For example we want to allow a channel change to occur
> as quickly as possible so if the above regulatory questions can be
> saved into flag form to avoid a direct regulatory rule lookup during
> channel change I think it would be great. How would we cache the
> answer to the HT40 question on the channel?

Yeah, I need to think about this. We also need to think about 5/10 MHz
channels. I'm thinking that maybe the best way to do that is to add a
"supported channel types" bitmap to each channel, which we could then
modify to include HT40+/- as appropriate as well. Something like we have
with orig_flags and flags already.

> The same HT40 question could be made but instead of looking at the
> HT40 channel as an individual channel we'd be trying to answer this by
> looking at the two channels involved to make the HT40 channel happen.

I kinda disagree here. How should we know whether 20+20 is allowed or
not if we don't treat it as 40?

> We'd know if HT40 is allowed by the allowed bandwidth in the given
> regulatory domain, we'd still have to find out whether or not HT40- or
> HT40+ is allowed but to answer this we first need to know on which
> channels HT40 is allowed and which channels are disabled. The
> assumption is if a channel is allowed then the channel can use 20 MHz.

Not exactly -- we could have pure 10 MHz bands in the regdb in the
future.

> For example to find out whether or not HT40- is allowed we'd first
> check if the control channel (aka primary channel):
>=20
>   o exists
>   o allowed
>   o allows HT40
>=20
> We'd then check if the same for the extension channel (aka secondary
> channel) exists. If both of these channel checks check out OK then
> HT40- can be marked as allowed on the primary channel. The answer then
> becomes cached for later lookups upon channel change.

Ok, yes, we could do that, but it would be disregarding the MAXBW, no?
Or rather, how do you define "allows HT40"?

> How would we go about this with the proposed changes on considering
> HT40- upon a channel change?

?

Anyhow, yes, there are different ways to implement this, but then it
seems we'd need more regulatory flags, and I don't see a reason for that
given the information we have -- which is only a little quirky for JP
and KP.

johannes

--=-QXa3k3lXaPVtKh6FBnUv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxq6NAAoJEKVg1VMiehFYni4P+wUPaqH+2w1Y9cmH5Kd1Vyr7
NK1jxcO1FD49Dp54BjB1SS1ezWxyyWrnSuAIWnIF2FqhnR8MZ/Xm1772WVDZFmfo
+oEG+kXpKK8DLlu1GJKg8tHfR4HEW9+BWdE5UfT/vbA1uTNatM/hl2lJZI4sPj9v
s92N16+UknHCySFAJ16bEtuZosxM99UY+kYHKgetPiK/GmHeI6xsbCg/ZFpjR+OZ
C2rOJ68PsXDOc+QgC3RxfoclbsplS3cyQKDlwRJchJuSaYNkhePTPMH5bcMJcRN1
X1NPBvUOON5HI1ajW2blOR73yBaWaxgLbju1UgM7VSpnLUQQxX3yUR5YoXlAdbR6
aZp+wUDWGuhRZUWQv4NP0S7LlTfu1mgEp0VaPkXDw112Wo+MAqLt48uiVmplW/Ra
cb+Bte10yWQbk0xnqxBP/sLKEpo8RaQRHs22Dm9zyjjyhvUpnYHD8seTqwgCFKWc
9Jt0X/58L5Dii0tFkYskXhGAX18PvmbPZIiOsGFsj1U7sUdIvRpk6Bp+OLBFcxkD
iyJQxz2Y0x0i3XjQudTl0mXifZHDYUdVGgegFhi8HG1cF02Z+iiWKIEaC2Tb1YeL
c3GKc9dCg4Ur9PcsG+ZxKm0H/QvDlIMvJGHpPsJfvXNxlxlFVIoTOow1AileI8cB
+wopoc1uINmp4/iVLO/X
=X0RA
-----END PGP SIGNATURE-----

--=-QXa3k3lXaPVtKh6FBnUv--

