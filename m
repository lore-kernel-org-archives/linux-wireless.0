Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZC3VU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 17:20:57 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20090330210233.GE23749@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <1238406057.24972.23.camel@johannes.local>
	 <20090330132911.GC11934@khazad-dum.debian.net>
	 <1238422114.5970.6.camel@johannes.local>
	 <20090330173421.GB23749@khazad-dum.debian.net>
	 <1238434878.5970.17.camel@johannes.local>
	 <20090330204800.GC23749@khazad-dum.debian.net>
	 <1238446338.5970.41.camel@johannes.local>
	 <20090330210233.GE23749@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hEyTwF2n0bEBMrwkwutd"
Date: Mon, 30 Mar 2009 23:20:23 +0200
Message-Id: <1238448023.5970.43.camel@johannes.local> (sfid-20090330_232100_092641_3175D763)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hEyTwF2n0bEBMrwkwutd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 18:02 -0300, Henrique de Moraes Holschuh wrote:

> > > It is probably a good idea to have the rfkill core sanitize the
> > > attempt to set the default state, and force it to "block" if EPO is
> > > active (I don't recall if I checked for this failure mode in the old
> > > code).
> >=20
> > No, but it rejects any calls to set the default state when any rfkill
> > struct has been registered already. So this isn't a concern.
>=20
> Suppose something entirely different (an input device) issued SW_RFKILL_A=
LL,
> and EPO is in effect.  It happened right at boot because the user turned =
the
> laptop on with the rfkill switch active, and that driver loaded first.
>=20
> Now another driver is loading, and is registering the first rfkill struct=
 of
> type foo (say, for an USB 'foo' dongle that has no idea whatsoever of any
> platform rfkill switches), and that USB 'foo' dongle is a really well-mad=
e
> device that even has NVRAM with lots of state pertaining to 'foo', includ=
ing
> a bit used to keep persistent on/off state.
>=20
> It will try to set the default state for type 'foo' (which might well be
> unblock) while EPO is active.  This attempt to set the default for 'foo' =
to
> ubblock can succeed or not (whatever is easier on the rfkill core code), =
but
> either way it must _not_ cause any switches to be unblocked, and that
> includes any subsequent rfkill_register (because EPO _is_ active)...

Interesting scenario -- I'll have to think about that, but you're
probably right and it needs some stuff to check for epo when setting
default.

johannes

--=-hEyTwF2n0bEBMrwkwutd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0TeVAAoJEKVg1VMiehFYTaQQAIYBzKhWnKvZq/9xfCs2Dgf+
pBw6OKKt+3WJi1hbXtNCCbvYZfbwIKOSlxzKnR3LgsEattxQcqqhENihk6SeIWNH
twM2DnjwrRkpX5uZFCB6dqpi+aCSUHAddufxOqh9N+X6q5ut7fulMVFNe94DtIK2
H/JumGOu4uEWfTLGi7pds7mnscmrySmESZoO6FIcF3ZzoN+2U+qLp4TGTaKeKKIe
3vI38W6SrmzAJvk90gkbxwXMEuDdzImG0aZGbqp0u8RVpeItyUyEeaGZM5kZqAwX
c8ySwuZMMQ/A3c+uijwg2FbVWScU89fPqQbeJBGn36uC2tpZAZ6d8WFdkso/eonE
TSZyKaF+wnLRvkZx1k/omzXBPT9mf8+P7ZjaUkqH8BlULofXeu3Gs6PSRN5bQ/Yu
HLGlP28j7FQt2CW3ZsEE6QAnHg1Ky1WyvfUHAS59sVXv2FodOQ0lI6XjD5koezMr
nqxyJ5cvpPLFQRf/SSoJHFrWmFshk+WkLEpN3a1V2IsDABpQvmc45K7+X2Tb4fcd
+d0uIR4RD2RmsQwdJNfshSXFpZ7z5u8xwvut59Lyp/KvJkWhbZE6xJwmbgj3+HWV
qUmIK1EcRqMtqf3ZdGQzodVci0b/pGsS0+cleplHgHrFVBYCrAqB5nbYTMOd56nX
c3PkbzKDEEu/txxt2RBz
=C9LA
-----END PGP SIGNATURE-----

--=-hEyTwF2n0bEBMrwkwutd--

