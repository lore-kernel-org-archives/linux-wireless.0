Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbXJQIJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 04:09:05 -0400
Subject: Re: Mode/Channel/Bitrate API
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <200710161640.54332.flamingice@sourmilk.net>
References: <1192222110.4770.81.camel@johannes.berg>
	 <200710161640.54332.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fCXhTYYnoVupTopcupdj"
Date: Wed, 17 Oct 2007 10:09:47 +0200
Message-Id: <1192608587.8841.2.camel@johannes.berg> (sfid-20071017_090916_614810_A59B2BE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fCXhTYYnoVupTopcupdj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-16 at 16:40 -0400, Michael Wu wrote:
> On Friday 12 October 2007 16:48:30 Johannes Berg wrote:
> >  (a) the driver registers which channel center frequencies it can
> >      operate with, it could in theory just be a range (e.g. 2400-2500
> >      MHz) or more practically be list of center frequencies.=20
> List would be best, but..
>=20
> >      Just=20
> >      contains frequencies and possibly hardware dependent values for th=
e
> >      frequency. This is done in "bands", something like
> >      FREQUENCY_BAND_2_4GHZ and FREQUENCY_BAND_5GHZ, "bands" replace the
> >      current "modes".
> Being able to just register frequency bands would work for many (but not =
all)=20
> drivers out there and would be more convenient than listing everything.

Yeah but it doesn't help when the user wants to enable/disable certain
channels or the regulatory code needs to, so it seems we need to go with
a list.

> >  (b) additionally, the driver registers as flags
> >      - whether it can support G mode short slot operation
> >      - whether it can receive B mode short barker preambles
> >      (both of which are only relevant if it supports 2.4 GHz operation)
> I haven't seen any softmac 11b hardware that doesn't support receiving sh=
ort=20
> preamble yet.

Ok, I guess we can add that whenever we have a 2.4GHz channel.

> >  (d) now, selecting a channel by frequency is unique, but we need to
> >      give new options to select short slot, short preamble and allowed
> >      bitrates.
> Short preamble? What would the hardware do with this bit?

Why hardware? For one, we need to advertise whether we support short
preamble or not in our association frame. So we need to know whether the
hardware supports it or not (which, together with OFDM support, is
basically 802.11g iirc).

> > Does anyone see problems with this?
> More specific examples of the API you have in mind would be helpful.

Don't really have any API in mind yet except for what I posted a long
time ago in Luis's thread.

johannes

--=-fCXhTYYnoVupTopcupdj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxXDSqVg1VMiehFYAQIbQw/8DjxUJjCdTep8KoERnniUZLyqbQC0/QZQ
OB0HLcYYni1M5SUI/Y5WhdNEc2s9qsqwbwInReUyUgbSSZ94HagDVhXtKpFNbEsI
XcnoWGLzKGDU1RhwkiPfzrJumxH0yjTgsgoiakmpJXhMhWR7Cm1J2LrFBCq9kM5s
OKg5KFC8QWcFfWKCW97UhGTNFhnPbznOLPjKHRnyd021gFhLosQErM8wnyjJ3Xhi
UrPp/rdEqVA7I28fOg36xwX+FMZtc7tbUHavLUyuPpxAuHQpPAA1jY4hdRSTI6dM
Ji+4KLEQEhLkgq1rezK7vNh4mQO9/xwsOHoVPVafWnTbNif95VMWYoeqwxXgnC7Q
bzFANi74r+miEYT8i1TIU8UBZR0ovEwEu933jkOVzzC+mtPqSpXt6uxgNV8eR26r
vOXBcfXPi9POYDHqoj0yxxTt5WuugJtvFBO8nTugGPqx8cqFVYiB1xmFyEuBoH4z
40zpvWP3UtfhTtXPgQhii56yb/Lxhz4/6gpjbJTOuP8ulMQDZklhquCwiLrd8aYr
BJviPwSAw9s0uK6uh8lwmFl16gZ7G+UVH0K/HIHQ7FbeQqIPrKGM2CC2m+PBA+eT
6T3vVMWK2cXdC5+2mJ2emceCVzmrxdNI9OS7gQU+66PZTgBn01A4iIlTR5Cg7RRE
C1F556x8+uY=
=b23B
-----END PGP SIGNATURE-----

--=-fCXhTYYnoVupTopcupdj--

