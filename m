Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbZEKN4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 09:56:52 -0400
Subject: Re: [PATCH] wext: fix get_wireless_stats locking
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090511125442.GB2721@tuxdriver.com>
References: <1241953217.12068.0.camel@johannes.local>
	 <20090511125442.GB2721@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-P3TRdDTavX5pJnWreD5Y"
Date: Mon, 11 May 2009 15:56:50 +0200
Message-Id: <1242050210.29777.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P3TRdDTavX5pJnWreD5Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 08:54 -0400, John W. Linville wrote:
> On Sun, May 10, 2009 at 01:00:17PM +0200, Johannes Berg wrote:
> > Currently, get_wireless_stats is racy by _design_. This is
> > because it returns a buffer, which needs to be statically
> > allocated since it cannot be freed if it was allocated
> > dynamically. Also, SIOCGIWSTATS and /proc/net/wireless use
> > no common lock, and /proc/net/wireless accesses are not
> > synchronised against each other. This is a design flaw in
> > get_wireless_stats since the beginning.
> >=20
> > This patch fixes it by wrapping /proc/net/wireless accesses
> > with the RTNL so they are protected against each other and
> > SIOCGIWSTATS. The more correct method of fixing this would
> > be to pass in the buffer instead of returning it and have
> > the caller take care of synchronisation of the buffer, but
> > even then most drivers probably assume that their callback
> > is protected by the RTNL like all other wext callbacks.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Is it acceptable to hold rtnl between ->open and ->release?

Hmm. It worked for me, but now I'm having doubts. This stuff confuses
me. I'll check it out.

johannes

--=-P3TRdDTavX5pJnWreD5Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCC6XAAoJEODzc/N7+QmaEtsP/1koT/ODFWyX8GybfzyrckGo
7xaQcCANpT3VlLhHJEvVl8X/98c//Ffeia02vDP/I5IoQjOjwo4shRQzHhrVI2oZ
/moljXtbk3KiM3uk1P1gaW9jLtXPYwC3mkakmNdT22aLZ4bGQqtj3y/IbqyU/ggR
gdYJ1tds9ReWlbqPpI0MmJZzImRZm4gpaFTiKDFDL1aUDUiy/ncEx7WpnfyhHWev
Czbdi4wrjR61zCt2+L8Xvvm2zsoecP8ziz8rmujBCX7u+MZZqj7T5kB8me+f9z2E
zuUlE8dHKnZmHp2mmq+tyzq5N2JlvgiJk24atbhMMsDxQvPfnH1+smyyYeFRftPs
3pLWIK9e9J8Vn0HbRU9EBiq901/H5K95zdRGPk32Tdy9waJERMTJv8ujYSQzSO+u
hTZqJugfiGf7AnFls5ZAPTWZjPA1RmQd1EymiD/ZRe4O1tPgtycxJZhuRigoHtQb
CAcWCKG+Aj1/HjPVRD/yQ8T2tHgbMgkcOYD/bwH3vzVQlV+woTmnc872rn6k77W5
NMDdMF9u38DelGD2pG3yDUvmHV5UOeP/6OOtQQk3TJXd76p1mRY6vRFcnCv8+GRY
pudlz7PBRPetGJ+mDwOV7RUQi6oFbGgNHmreqCN/g12T+T5+6/lTTrIYdE9J8WH2
mcGrJ6IWZZioKhAoV+Oh
=KkF6
-----END PGP SIGNATURE-----

--=-P3TRdDTavX5pJnWreD5Y--

