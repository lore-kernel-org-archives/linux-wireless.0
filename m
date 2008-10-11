Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37529 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYJKAEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 20:04:54 -0400
Subject: Re: [PATCH 1/2] ath9k: remove nasty FAIL macro from
	ath9k_hw_reset()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890810101359n529f932fw8cd47822b27b4685@mail.gmail.com> (sfid-20081010_230026_072161_8E9C4FD5)
References: <1223641374-11872-1-git-send-email-lrodriguez@atheros.com>
	 <1223667649.3748.38.camel@johannes.berg>
	 <43e72e890810101359n529f932fw8cd47822b27b4685@mail.gmail.com>
	 (sfid-20081010_230026_072161_8E9C4FD5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R1HLu18qtTqlNuJkizQG"
Date: Sat, 11 Oct 2008 02:04:51 +0200
Message-Id: <1223683491.29811.15.camel@johannes.berg> (sfid-20081011_020513_711922_D3A74B13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-R1HLu18qtTqlNuJkizQG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 13:59 -0700, Luis R. Rodriguez wrote:
> On Fri, Oct 10, 2008 at 12:40 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2008-10-10 at 05:22 -0700, Luis R. Rodriguez wrote:
> >
> >>       ecode =3D ath9k_hw_process_ini(ah, chan, macmode);
> >> -     if (ecode !=3D 0)
> >> +     if (ecode !=3D 0) {
> >> +             ecode =3D -EINVAL;
> >>               goto bad;
> >
> > didn't this actually want to pass up ecode?
>=20
> Fuck yeah,
>=20
> bad:
>         if (status)
>                 *status =3D ecode;
>         return false;

What I meant was that it's overwriting the return value from process_ini
now, was that intentional?

johannes

--=-R1HLu18qtTqlNuJkizQG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7+2fAAoJEKVg1VMiehFYNI8P/jKql7y9sAWeF6Ndhmw3S7vb
XOHXc/iM0rsOZGjiCDCQNhIrFIXzCbQGMBBE2vjYqzMJRJQEmvqn/GEnV9dvSe+h
Apc8tMoej0OyD5WzfVVM+pHMXq7Cc1bqReVAE1c743/Q4IHWgwAEjpRW46qdEbR1
NX5Kw3dkkIIVmjbvHLUSp7GoOuM/bdcKEBZKuhWtv53RfiiI1omADkmq16WIWSun
yCBXAfYOoBH4ZTGjvNzvC+gwQV6Tji/b7BoqnG4oLgHJIGyHsz/pUm3S06411PL3
+kM5Rq1753JOy6E76qfZFC81VG88JCQpKFUjz08HeBAEgIAz5M8aLIhOBDsrUD5B
vtYFQcvalrsCa5NZ4XusJ6iFnpcDjKqfOhC6gWBYgO2wjhKe2ZaMgIx3a9FC616y
t2j+XMUmu5m/5b3v7KwaIDH5hAdGaa/1Gr22sHfo6AxtQQdmoWCK93BD/ruSQ7ru
PvfNvzHHQfXzZ2xW6oqKCkV/tDIWABD3FmiyZ8SNiiPFwrdTaujN8gH6zaqGR21t
yBP5ry5pzxexJxET9elT7Mcu2S4FZ98oFuyxjUI9Jv90qUZG1HEH3hf4FIgSkqML
psPyvcuy4QWS5BlIQKCP0VSdfZkpbm35CQDcheg1Jb8Mixv7xwgAWbaKpWzCXF52
U/jrkPMeEWRRU+qcPwry
=MnbS
-----END PGP SIGNATURE-----

--=-R1HLu18qtTqlNuJkizQG--

