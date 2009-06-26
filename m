Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbZF0IGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2009 04:06:46 -0400
Subject: Re: [RFC 00/11] cfg80211 connect API + wireless extension move
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A43E002.2060309@gmail.com>
References: <20090624120745.239294066@sipsolutions.net>
	 <43e72e890906241324n341f4988wc6e7325ee389e71e@mail.gmail.com>
	 <4A43E002.2060309@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jWuLwbTSXW0/i3n0OspC"
Date: Fri, 26 Jun 2009 22:18:40 +0200
Message-Id: <1246047520.21314.67.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jWuLwbTSXW0/i3n0OspC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-25 at 21:37 +0100, Dave wrote:

> Do we need to maintain these interfaces? I think allowing the same
> functionality via other means should be acceptable (since any software
> using these interfaces clearly doesn't work with any other hardware).

True.

> > Hm, which ones?
>=20
> orinoco has the following private wext handlers:
>=20
> reset firmware
> reset card
> get/set adhoc port
> get/set short preamble
> get/set ibss port
> get rid
>=20
> I've only ever had occasion to use the reset ioctls recently, when my
> card started seriously misbehaving (I suspect it's about to fail).
> debugfs or something?

Sounds appropriate.

> The get/set things could be done as module parameters. Preferred values
> will be model/fw specific - though I expect we have reasonable defaults
> picked during initialisation.

That too.

> Get RID reads settings off the card. Useful for debugging or reverse
> engineering, but I hope no-one uses it for anything else. Remove complete=
ly?

I suspect you can get rid of it, yes.

> Regarding patch 11 (the internalise one), would it be better to:
>  * continue to export cfg80211_wext_* for now
>  * set mac80211s dev->wireless_handler to &cfg80211_wext_handler in
> iface.c (via a #define that's NULL if !CONFIG_WEXT)
>  * specify a release when we expect all drivers, or at least those
> anyone cares about, to have converted?

Sure. I don't think we need to specify a release since there's only
three drivers so far -- orinoco, rndis and iwm. The latter is taken care
of, and the two others shouldn't be much of a problem either.

> That removes the WE dependency from mac80211 but allows drivers to
> gradually implement cfg80211 support. I originally attempted doing it in
> one hit - that sucked, but may have been due to not having a clear idea
> of how cfg80211 is supposed to work.

Yeah, I agree, doing it in one go will probably overwork anyone who
attempts it, otoh once we actually convert everything in the tree all
the remaining drivers will have to be done in one go. So I think we
should just wait until all drivers are converted and then simply swap. I
can help with rndis/orinoco too.

> It also means orinoco can keep its wext private functions for a bit longe=
r.

Yes. Mind you, I was not only talking about iwpriv, but also about
things like orinoco's spy support or get/set sensitivity. The latter we
don't quite understand -- can you tell us what it actually does? Spy
support should just be removed, I think.

Additionally, at the wireless summit today (yesterday by the time you
read this) we decided to allow cfg80211 drivers to continue exporting
iwpriv handlers, so that existing factory calibration interfaces or
similar can be maintained going forward even with future drivers.
However, this is understood to be purely for backward compatibility with
existing calibration or similar tools.

johannes

--=-jWuLwbTSXW0/i3n0OspC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKRS0dAAoJEODzc/N7+QmaFicQAKVlx2zivqVJ6s00lSbV4lzi
I2isqoizZOlSfk9bLWHJQ7dZZomGqxvdbL1t1S3TqQwLC4JYdGI0xY35NJ05Q47L
YdAWWiGFXQHbgmCrL8iS2cw9eNWisUoL4raBZhR2Xj6gDMW78YKyDkWjYD5oci2b
KdfnMMUkom6+wCUmlWIWoocFqPLNoOrPN7X0OI0shf5djJC9Nhj65z5gPVUdMNYv
kCm21HWhrYvJG8O5tWUD4FwNUwftvJJLK2DBbD7a5n6wmB1yPD4sw8iWVLs1KueU
AAjf0qldxyQncogcuOEOjKgngEgmLzDQAGWt3UtLbBVUlqBX0+ZnWVPWalb6u6kv
QsylvfQQd7w6avR4ewJuLnnKoEas23BMxShUdl4zS8nQDlRNVYZMvCSOtt1e4O26
7ljQxIv16STzsy4CGfP58sDpzdj64ooziIF4gyq4eAycZ9ewoqyHgkdJ/eMa4POF
nLSJrq+zGWKUzWozDDNzNyNs2RzPVwRsawHiWLz73j8VzTjL8140QNlM/THTfSDA
I0ShPG8yI8+UuF/p+qzdZn9PwLd/2JiW38h4hdH5/7uhPYjoMY96JqWkqDh5PPA9
h1EY6TC4IMpWcPLQuFm5amIrszg6Qw+mnajwdNPJWrTpgpqASXEoopt00UhehqGz
zXzO4Cls27piJbZeNA3m
=lP/P
-----END PGP SIGNATURE-----

--=-jWuLwbTSXW0/i3n0OspC--

