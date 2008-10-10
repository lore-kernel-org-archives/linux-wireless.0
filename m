Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYJJJPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 05:15:12 -0400
Subject: Re: [PATCH/RFT] iwlagn: remove pointless TX frame check
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810091308r167b9147p46f74421329a55c1@mail.gmail.com> (sfid-20081009_220831_876301_EA9D5BD1)
References: <1223547733.22490.43.camel@johannes.berg>
	 <1ba2fa240810091308r167b9147p46f74421329a55c1@mail.gmail.com>
	 (sfid-20081009_220831_876301_EA9D5BD1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0GyIulBkEdtLzIpIVHM0"
Date: Fri, 10 Oct 2008 11:14:49 +0200
Message-Id: <1223630089.3930.71.camel@johannes.berg> (sfid-20081010_111517_870111_CBA3F26D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0GyIulBkEdtLzIpIVHM0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-09 at 22:08 +0200, Tomas Winkler wrote:
> On Thu, Oct 9, 2008 at 12:22 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > mac80211 will not send data frames on a STA mode interface
> > that is not associated because the queue for it is stopped,
> > and all remaining data frames that might be sent, e.g. by
> > packet injection, are accepted here anyway, so remove this
> > pointless check. Also hold the spinlock for less time.
> >
> > This will with great probability improve performance in the
> > driver more than the proper descriptor layout can possibly
> > cost.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Haven't tested this so far, so RFT, but I'm fairly certain it's correct=
.
>=20
>=20
> NACK, the completion of association of mac80211 and iwlagn isn't fully
> synchronized so there is still
> a race.

Can we fix that?

johannes

--=-0GyIulBkEdtLzIpIVHM0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7x0FAAoJEKVg1VMiehFYvU8P/R6o5q4yfYtHMo/E3MhwW52A
2UDAnWhA5SbTxUUIHxHsajnxtg/pUmKjzXXljR4x3LtBZOqEFOxsAK0ZIZNlJu7J
50hWOvEI5gP51GzvQ3b1JttQqflPfOGgTLVtxcQehL5H5AKpk6se8TPYgD4yEcqx
yYGm9GHAkRWyv0l6nPxk7u2HDzxqpCvdiyfqZsfFl2snLOsq1WrwRtvgxBy1KQc1
NUVJLhVpQJKjXxNC9Uk3ZNFNq+/HscWgcc0Z/20QJvawb3Wm0w9X/d/mfSV6g4Bf
sQnl/DwYOucmHDr/FJ/IEjCD0Vgsc7tEulsGJDEawEtlf+oiZhpOMJH+dLU7LWFi
wQZ/i+taomBrUaDQD/CK+Us6gobUFd/vFsCEcMpZirJvYQ7icCWYcGOX8rFmU/qc
Uopj8cKlPzaS6w9opRzoSb6uYktgguXAPtkOR+VM1Rg5Cw2f95bubLkKkPS7Bhqa
NkirYAVgOkxVg7HcY6XgM7B7q/quOIxDx0elS4aCWMbyX9Ue0V0vVnURBF977iV4
crWpfiYzppBQDQAZSBSoAKqCo1Tny1RhoRTmYir2/qjwa4D/U7vDliVSV3d+UfOG
1/XuXCribzACXwSowZY1ZpUSi2mAglIzJbrt6uTQVGr+zVM66xdklMNROYWIWhlj
5fjzD+HWfL7GdGyxylLF
=qiJE
-----END PGP SIGNATURE-----

--=-0GyIulBkEdtLzIpIVHM0--

