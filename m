Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763726AbXJRMja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 08:39:30 -0400
Subject: Re: Mode/Channel/Bitrate API
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890710170715ibeee99eja865dc3291e7e37d@mail.gmail.com> (sfid-20071017_151536_588394_24595448)
References: <1192222110.4770.81.camel@johannes.berg>
	 <200710161640.54332.flamingice@sourmilk.net>
	 <1192608587.8841.2.camel@johannes.berg>
	 <43e72e890710170715ibeee99eja865dc3291e7e37d@mail.gmail.com>
	 (sfid-20071017_151536_588394_24595448)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WFAOWVFvPXz5ZZ8XpIxI"
Date: Thu, 18 Oct 2007 14:40:32 +0200
Message-Id: <1192711232.15285.13.camel@johannes.berg> (sfid-20071018_133947_166474_15A271A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WFAOWVFvPXz5ZZ8XpIxI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-17 at 10:15 -0400, Luis R. Rodriguez wrote:
> On 10/17/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2007-10-16 at 16:40 -0400, Michael Wu wrote:
> > > On Friday 12 October 2007 16:48:30 Johannes Berg wrote:
> > > >  (a) the driver registers which channel center frequencies it can
> > > >      operate with, it could in theory just be a range (e.g. 2400-25=
00
> > > >      MHz) or more practically be list of center frequencies.
> > > List would be best, but..
> > >
> > > >      Just
> > > >      contains frequencies and possibly hardware dependent values fo=
r the
> > > >      frequency. This is done in "bands", something like
> > > >      FREQUENCY_BAND_2_4GHZ and FREQUENCY_BAND_5GHZ, "bands" replace=
 the
> > > >      current "modes".
> > > Being able to just register frequency bands would work for many (but =
not all)
> > > drivers out there and would be more convenient than listing everythin=
g.
> >
> > Yeah but it doesn't help when the user wants to enable/disable certain
> > channels or the regulatory code needs to, so it seems we need to go wit=
h
> > a list.
>=20
> The regulatory work can just iterate over the currently established
> channels for each wiphy. Who defines those or how is not important to
> the regulatory work. I'm not sure why the range approach would not
> work here. A card usually works on a range of frequencies anyway.

Right. But the regulatory code may need to have power restrictions
different on different channels and generally wants to be able to
restrict things for each channel, so it'd be good to have the list
defined right away by the driver. It seems that if we don't put this
into the driver but rather have a frequency range there, we need to
allocate an array of channels later for this work and that's not needed
if we start out with an array of channels.

johannes

--=-WFAOWVFvPXz5ZZ8XpIxI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxdUP6Vg1VMiehFYAQIOBA//S08iCCXY/lYtwI3iL6aIcbt/bIuHZDt8
oFOaEwfSlV6bTfYMKPU2Yb+0E+b5yE44B4kdpWI2jO+NLeJBamG3AN8pFqi43nO7
HBPYQdCIeSMYW7vth+BIMfJLDWpUjMDvEG6l9bLvBYlrCsDyv7xTKqZb4/cTDomX
WWJFMU7IzHZR0USvmskGn5o3OrT5S1Uk8fwfVTknDe3nYkIz9Z4RU4sIIpPmdCsv
Y7a+Z7zlqBgleMLLhTXFk/7X9mdOMHvZhmpzOmnC01PeBbXaSZYpSljdhAwP1rD6
zVhYV6VYAl3J0doSaQIgs0l4OWTT8BtEOrX/4D+VFeJIqVOlaPy5LZvsgLks7HtK
/5rB5hnZCGxnuHBDb9lT6jM5o2hZii6pbFNYOEPeUNKSwPiImUbOQXbASeGG2Y3V
BoOkNk08TKKySCaXlnj/JA+nySDT2t7YUrTQHLBOVXLG2oeIWDHTr6F7a0i2h9A7
dM+aJqs3mubk70ZPp1zISQlDVpmd9a7WsPdLj0sIb/LY1YsGYgYMkKKiVZGyTbGK
tD0xJEPqXk/w/KFOMtA0qVXzXKRp0zuenwhafh669irpBRlumtLo5Cq0r1gymIMH
4PMVHa5ArPnH+dLxUVnRCnB3wB3rI3mWCU+wdUxlQZmIYFDziVsOvUa8EUpUhBkV
3IV1wU3sZqY=
=umhP
-----END PGP SIGNATURE-----

--=-WFAOWVFvPXz5ZZ8XpIxI--

