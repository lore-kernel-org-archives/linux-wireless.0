Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759AbZJaNgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 09:36:50 -0400
Subject: Re: [PATCH] cfg80211: fix NULL ptr deref
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Parag Warudkar <parag.lkml@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890910310635q6015cf3bq639426d5c1502454@mail.gmail.com>
References: <1256971237.3555.87.camel@johannes.local>
	 <43e72e890910310635q6015cf3bq639426d5c1502454@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OTxNse7KFsOsqJOJZ6+R"
Date: Sat, 31 Oct 2009 14:36:51 +0100
Message-ID: <1256996211.3555.131.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OTxNse7KFsOsqJOJZ6+R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 06:35 -0700, Luis R. Rodriguez wrote:
> On Fri, Oct 30, 2009 at 11:40 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >  commit 211a4d12abf86fe0df4cd68fc6327cbb58f56f81
> >  Author: Johannes Berg <johannes@sipsolutions.net>
> >  Date:   Tue Oct 20 15:08:53 2009 +0900
> >
> >      cfg80211: sme: deauthenticate on assoc failure
> >
> > introduced a potential NULL pointer dereference that
> > some people have been hitting for some reason -- the
> > params.bssid pointer is not guaranteed to be non-NULL
> > for what seems to be a race between various ways of
> > reaching the same thing.
> >
> > While I'm trying to analyse the problem more let's
> > first fix the crash. I think the real fix may be to
> > avoid doing _anything_ if it ended up being NULL, but
> > right now I'm not sure yet.
> >
> > I think
> > http://bugzilla.kernel.org/show_bug.cgi?id=3D14342
> > might also be this issue.
> >
> > Reported-by: Parag Warudkar <parag.lkml@gmail.com>
> > Tested-by: Parag Warudkar <parag.lkml@gmail.com>
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Do we know if this will also affect 2.6.32?

I'm pretty sure -- have we got any changes to this code that are not
in .32?

johannes

--=-OTxNse7KFsOsqJOJZ6+R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7D1vAAoJEODzc/N7+QmaM3oQAJSUhLWr210uOweZWQy2VWJt
saE5mem7lLZ/5uo274OdxaP8U5aRuMIb1X0D8B0icL/3V6uhvH1VFBJPXVKA4k2q
KGQ7UzG3W7UV82TYIiFWyQa9oiVHLjY0B0ydqpCKPTmL4wwPkFLHNnzjzwIOiofT
MX+DGDjJ0SkVMLMrmdRtCNTzWu57zRxR24jQpXNSrWcztq8+c1EehaEp79QNrodK
3FchP03gZnqyB3qptE/HHpsVB4i90E0DDWLy6hqCv1u41p9xfA0cOIvVe/V/XVdH
sjThl1nmzOwWeYw2zoQgMZ4+3sSmuBG2b0L8bS7Fv8Kqsh4Ts/VuPWmhVRnO9hjO
PitoHkJ30L17n7jhvVMHgqtW6pMZsBPSUbcAuEbvzcb10I+uprs5pvrsnLQOFkzC
+OfqF7J7AhH1bz/DX8zFe3/Z7SW9NzP/BbY/tNC6spll6AvQPcWDC1yMe3Jm/Fki
Idk1r2VbBEz9KgwRPQvXwKkLjh5HE5LW2QBxl3Y1EQX0HMpuQe40fxugeogCxeP5
50pyLxa6TcWmPMeCscTPbJYW2iYIHX+8Xzle6PTbeSNsvFMte9ZMExfL8o99APje
46ev8FraQsrAUvYC0ovBw53C/3RN1uTZP9K/SHDweRgFmToX/Mm6dn1TUbFrs+Hz
lk3n8sF2yRA4ZCRZ6T6l
=wA5K
-----END PGP SIGNATURE-----

--=-OTxNse7KFsOsqJOJZ6+R--

