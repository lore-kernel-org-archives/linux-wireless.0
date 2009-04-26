Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZDZIcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 04:32:35 -0400
Subject: Re: [PATCH RFC] cfg80211: Add ies_allocated check before copying
 ies
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <200904252236.34802.mb@bu3sch.de>
References: <200904252236.34802.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Y16R8kEcIQtUA99klMfz"
Date: Sun, 26 Apr 2009 10:32:32 +0200
Message-Id: <1240734752.17781.3.camel@johannes.local> (sfid-20090426_103238_101566_2C594CEE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y16R8kEcIQtUA99klMfz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-25 at 22:36 +0200, Michael Buesch wrote:
> I don't fully understand the code, but let's imagine the following situat=
ion:
>=20
> - cfg80211_bss_update was called and the ie was stored to allocated space=
.
> - The information_elements pointer is changed to the allocated space.
> - cfg80211_bss_update is called again, but now the ie fits into the
>   space after the "found" structure.
> - But the information_elements pointer still points to the allocated spac=
e.
>   So it may overrun the buffer and crash.
>=20
> Is this scenario possible?
> If yes, please consider the following patch.

Yeah, looks like a bug, good catch. I don't think the fix is correct
though -- you lose the data in this case.

I think it should simply be:

>  			size_t ielen =3D res->pub.len_information_elements;
> =20
> -			if (ksize(found) >=3D used + ielen) {
> +			if (!found->ies_allocated && ksize(found) >=3D used + ielen) {
>  				memcpy(found->pub.information_elements,
>  				       res->pub.information_elements, ielen);
>  				found->pub.len_information_elements =3D ielen;
>=20

so that the else branch gets a chance to reallocate if necessary, would
you agree?

johannes

--=-Y16R8kEcIQtUA99klMfz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ9BwbAAoJEKVg1VMiehFYqHIP/1p/uHf8Q/qHZtDojaNZ2+LU
jcgbKRIxbkhqBY/5dJ0zoabMNnwScBbOW4eVFWvb45crCzUxxHgc51Zofl1PQkUj
EmxFhGzWNMbOF8LcrcpfObcNCq8LyaX7lbWP+BNeJY4K+c2Qe2b0ww6R4iVhsmpn
SF/mtCS/vPM3y97SXi0+6++Rj/3WlnMAUdNKDnuJckCITxsecMHh3jTd6yGll61x
OYBdM5U7KmhiTSwCWq68l8ls8Qh3/J5IbtO+RScAsPNk8c+uoDQShOoTdff/w9w2
kZUZCos5AfUVDGatpyjqLNw22jKl+8ipQZ5c2YblX/YhfH9Wi2zFKAXqe6xzttZf
Dw+19xnzOTaR+vzVtNTjvzHR6Man1c0ag94VwwRJhqEaqdjrVC/Xri5onuPUz46n
1djX16T2pTV6JntM+ck81vnS6/4G/2uXyz/HQu9NGI0dQg4fWGm9+mmncN4YQJw4
eXOHJ9PEM/F+1dTWvgwFms+PXql7sbnMQttR+QQBh780pw2qU/LVRHoMIFaI98c2
UNqXHZdPuoa8mFXyIrmyV2ctD87aYMcoVcvInsdjpHECyu7rL2lZ1r621jUYOWwi
QSQVPRM3KUpUPBjn6AMSYk/DcIMlIFXI9wYYgHqCHohLvNyaQhbOCcFRsuhNvcSd
BzhgqjlRYVQsIMG/n/3R
=m4k+
-----END PGP SIGNATURE-----

--=-Y16R8kEcIQtUA99klMfz--

