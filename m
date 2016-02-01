Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34906 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbcBANAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 08:00:54 -0500
Received: by mail-pf0-f179.google.com with SMTP id 65so83659473pfd.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 05:00:54 -0800 (PST)
Date: Mon, 1 Feb 2016 20:58:53 +0800
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sven Eckelmann <sven@open-mesh.com>,
	linux-wireless@vger.kernel.org, thomas@net.t-labs.tu-berlin.de,
	nbd@nbd.name
Subject: Re: [PATCH] mac80211: minstrel: Scale expected_throughput by 10
Message-ID: <20160201125853.GA12011@prodigo> (sfid-20160201_140057_703781_8353E883)
References: <1454329450-31527-1-git-send-email-sven@open-mesh.com>
 <1454329837.3211.2.camel@sipsolutions.net>
 <7460390.ua0GvOE4DE@bentobox>
 <1454331473.3211.3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
In-Reply-To: <1454331473.3211.3.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 01, 2016 at 01:57:53PM +0100, Johannes Berg wrote:
> On Mon, 2016-02-01 at 13:56 +0100, Sven Eckelmann wrote:
> > On Monday 01 February 2016 13:30:37 Johannes Berg wrote:
> > > On Mon, 2016-02-01 at 13:24 +0100, Sven Eckelmann wrote:
> > > > The change from cur_tp to the function
> > > > minstrel_get_tp_avg/minstrel_ht_get_tp_avg changed the unit used
> > > > for
> > > > the
> > > > current throughtput. For example in minstrel_ht the correct
> > > > conversion between them would be:
> > > >=20
> > > > =A0=A0=A0=A0mrs->cur_tp / 10 =3D=3D minstrel_ht_get_tp_avg(..).
> > > >=20
> > > > This factor 10 must also be included in the calculation of
> > > > minstrel_get_expected_throughput and
> > > > minstrel_ht_get_expected_throughput to
> > > > get similar results as before the change.
> > > >=20
> > >=20
> > > 10 is a pretty expensive factor, perhaps that should use 16
> > > instead?
> >=20
> > Not really funny but I will change the title.
>=20
> Huh? Not sure what you mean. I really meant to change 10 to 16 overall
> as far as the factor is concerned, since division by/multiplication
> with 16 is far easier in base 2 than by/with 10.

Should we first fix the bug introduced by 6a27b2c40b48 and then (with anoth=
er
patch) improve this by changing the factor from 10 to 16 ?
The latter is going to be a bigger change because we need to make sure that=
 the
value exported via station_info gets still scaled to kbps.

Cheers,


--=20
Antonio Quartulli
Director of Embedded Software | Open Mesh, Inc.

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWr1aNAAoJENpFlCjNi1MRAO8P/iC+RohOZiPrcsa2Kd0R1aDA
XhGq9pyt+gmUYkmb8y0wCpw450POH1XOkpG/qaoQDA8d6fnVSfJU+mn5my+ii3W4
3v6xOKJTqztwklqnNoh8nHhrVTM1LtyNjuUUvCnCaY6/REqZovrGNgZDzLJ4E9oA
fkxUp1KtKKaTRoHhysWE4s7IJGyP6zZAxWzaw2jY+qrYIaSCz++Mu0yEavDZerpr
WKBnyBCnE2UzU+UDn/lp8bd65EnRpuZQ+0xC50cmCGb6OcTe33cpZ7ErJqd8aYIQ
ZqbMSaZlh4QTkhWu2vOlj3GopxiDkOe0CjvTMTVMVuOTJpHK29VPjPVuYxbQout8
rX32u850uw5QN2QcM0ROnTTMuoOM80t3mN5pt1t8vsfcjUqwliqdRzqN4XAKJJo3
rG9CzDpJZlDGIk19YyHXuv+fhECfsCKoUq00NZQqo7uP97mMduwMsqZJdJ64l3RN
e9SuIJa9gtV094DZ3B/4sjV5yNswl4od6NvlhwBcPTGPTxn9Wf8gyJ0HIS40J5Ml
mX3DC0nb42nou+W3FsjgUzLylgmtlHGjLqwZ/DxGmDRPqSjFw0dXZAZmIZ31ZQYx
8mwx2+DKnXsUfJgzMk1cIET6830MIlqrKjmES714PyySwD2UKiVAUGxJJ0tpmEty
wUs+2rQSWrQVmSdCMbtY
=1MEp
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
