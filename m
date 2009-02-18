Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZBRQtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 11:49:09 -0500
Subject: Re: Missing link quality with wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <j@w1.fi>, Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1234969986.19743.7.camel@localhost>
References: <1234896777.4678.7.camel@californication>
	 <1234899806.29785.35.camel@johannes.local>
	 <1234902294.4678.12.camel@californication>
	 <1234904111.29785.44.camel@johannes.local>
	 <1234904978.4678.31.camel@californication>
	 <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net>
	 <1234933059.21412.28.camel@californication>
	 <20090218073104.GA23366@jm.kir.nu>
	 <1234944391.21412.47.camel@californication>
	 <20090218082520.GA26280@jm.kir.nu>  <1234959523.13950.47.camel@localhost>
	 <1234964271.4023.21.camel@johannes.local>
	 <1234969986.19743.7.camel@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z7wOabRNbbJTeRYwMVOa"
Date: Wed, 18 Feb 2009 17:48:31 +0100
Message-Id: <1234975711.4023.28.camel@johannes.local> (sfid-20090218_174913_779926_39E1C8D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z7wOabRNbbJTeRYwMVOa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-18 at 10:13 -0500, Dan Williams wrote:

> >         /* cfg80211 requires this, and enforces 0..100 */
> >         if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
> >                 range->max_qual.level =3D 100;
> >         else if  (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
> >                 range->max_qual.level =3D -110;
> >         else
> >                 range->max_qual.level =3D 0;
> >=20
> > Note the dBm branch -- clearly wrong. Did anyone care? Clearly not.
>=20
> Almost; I was partially wrong as well.  The comments from wireless.h
> imply that max_qual.level in the dBm case can be < 0.  Remember that
> these values are *s8*, and thus max_qual.level can be < 0 and greater
> than -127 at least.

Ok, I wasn't looking at the header file, only your explanation.

> This of course doesn't allow RSSI-based levels of > 127, but whatever.
> To get the definitive determination of RSSI vs. dBm for level, you use
> (updated & IW_QUAL_DBM).
>=20
> The understanding of max_qual.level =3D=3D 0 means dBm was probably from
> conversations with Jean and that's apparently not borne out by the
> evidence from wireless.h, unless there's something else I'm not reading.
>=20
> NM doesn't handle IW_QUAL_DBM.  It should.
>=20
> > Therefore, here's what I'm going to do:
> >  1) always set IW_QUAL_QUAL_INVALID, even in max_qual (fixes bug #1)
> >  2) set max_qual.level to 0 for dBm instead of -110 (fixes bug #2)
> >=20
> > patch below.
>=20
> I think leaving max_qual.level =3D=3D -110 is OK in mac80211 actually.  I=
t's
> NM that's got the problem by not respecting IW_QUAL_DBM.

Yeah, but now we've got three or four bugs that together mean we broke
NM. We can't really wait for NM *and* wpa_supplicant to get their
fixes...

Should we just calculate a qual.qual value anyway?

johannes

--=-z7wOabRNbbJTeRYwMVOa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJnDvZAAoJEKVg1VMiehFYm0kP/jUKpOByGn2DN8TUmkxafLpU
dJsbzfiYwSK4yQFo5dw0MVfwp+18m8PkhLu2HqOoVEKqeqYiu7MePpRVCb58jVb9
CDABFKWwPTzmajxD+0tYm/ju/GElJixq9CWejr74Z9LArSG7KYECvhMLReziqGpq
6dKFovEEdSS78m4AyM1VrZSJpWN9Ijj0JI/Vgak4Amc1tzgNoH6zwrSnGumjqz3N
aRpuKuaoVEUjI2wK3SruaTsEEJaI2kShlopc4ZH5HaWPH3oxrxJEo1butQhjl2dN
oCgImxnxlpWcUUQzhzrXPYMQBReUeCfSLxdwxG0z/5sNxggVbQdnnZ86HSveTE/N
Yt0fKnF2GFNzSlZWtvL1rEika6mmCOD+RM9+yiZeNPQ0tP3PpizeV+Tm2yEqH9n/
5dr2In0nx1XOUGUkBxpOFBFu4Irdf2q43zlkCo660K4AmeCTiw19cUTxLeotN8Ww
SztTNwbVvwCFhjAz1QzN8LIKaYXKc+8XJI5O1V+fTIRyst1e9Xc/qda6x4QoQr34
Ih1fvLV9QpDBSistIWD59sfRXpUizeZCv89HcZ2xaatIEYrWoV60o/6WqWjMV36r
AI6f4l1dER6y96JG7MPeDJZNqC0UjzGm7MnU8EOxkWKko0PE8oo+9jcrh7aR3GAp
dBkXl2S3wnFBseNcp4D5
=hWPt
-----END PGP SIGNATURE-----

--=-z7wOabRNbbJTeRYwMVOa--

