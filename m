Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:35432 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753123Ab3FEKAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 06:00:16 -0400
Date: Wed, 5 Jun 2013 11:53:11 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Antonio Quartulli <ordex@autistici.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] nl80211: allow sending CMD_FRAME without specifying
 any frequency
Message-ID: <20130605095311.GA2349@open-mesh.com> (sfid-20130605_120020_315188_3F9415FB)
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
 <877gi8khyi.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
In-Reply-To: <877gi8khyi.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 02:47:01AM -0700, Kalle Valo wrote:
> Antonio Quartulli <ordex@autistici.org> writes:
>=20
> > From: Antonio Quartulli <antonio@open-mesh.com>
> >
> > Users may want to send a frame on the current channel
> > without specifying it.
> >
> > Make mgmt_tx pass a NULL channel to mac80211 if none has
> > been specified by the user.
> >
> > Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
>=20
> Why? And what users are we talking about here? It would be nice if the
> commit log would give some context here for use who nothing about this
> patch. "Users may want" is not very informative :)

Hello Kalle,
thanks for your feedback.

Sure, I can change the commit log.

However, I already wrote a couple of (userspace) applications which wanted =
to
send a message on the current channel and the only way to do it was to firs=
t get
the current channel and then pass it when sending a CMD_FRAME via nl80211. =
Of
course this approach is just a bit racy :-)

Moreover, I'm currently working on improving IBSS/RSN support in wpa_suppli=
cant
and sending frames on the current channel is needed.

Do you think it is worth mentioning userspace applications like wpa_s in the
kernel commit message?

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRrwqHAAoJEADl0hg6qKeO9+IQAIOZdv7FeiaXWaAalJxb04TW
Xv0szTCLSut8RQISPGnv6wKBuPlDOXbfTpD2K/XVxqCsA6n8XciYcB07Vrtq8S9Q
XCX1QZJo14KefLhd08bmcwGCr4hw7ecVvu/ZjQGst6w17Jc/B8a6wARckEF40TdF
E22b+5A3N0SXbwWp/u//Vjj49+hDLCDtmaOo6n8MzAHxIYO1unbB3khp/34oqJKq
SbLEhEFiEyEOepc0SW+f8ZlKi7I1KMRtsY5DmVzeZAghkrgLCsnau2+GQjWF1YwI
s812zfUyujc0dfmvjoX2ZzF5sNTngF98pGdo/jx7Rkp87lrOsq/vxlFtYCj7R/8z
AMR93M3eleNyIPtCVoFTLSZK8rY126IvfRa8ekPIM76HH2Yhf1xkKA6h+Nu71j8H
IuGhYDbulzE7Z9bfJChKzKaRTO3YIYKqFjA48Djj8CKzNxC4sglVgR++UgsfaJoE
jXpW+LoYMvTEHqVhxLF9d50jrDv3bxPRb6gIIc0mvTSKf/ydteOo1ietqLdOPhof
J/t1DV4kT9pM0rvX8jqYVyBaNg3bLxE5knbbLp11phQ9uTGAas3zYNnU1CodOTUS
O51NbxZzxKOrLvmhq9r61vz0dM4+kRNGIS+0y+nxYKW5FIEYwrsWejuosDPjuCMR
xW3d0oeFcqMqIFsshVKG
=37qp
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
