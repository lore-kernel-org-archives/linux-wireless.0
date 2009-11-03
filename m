Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZKCIHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 03:07:44 -0500
Subject: Re: Incorrect signal levels reported using wpa_supplicant's
 driver_nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	networkmanager-list <networkmanager-list@gnome.org>
In-Reply-To: <1257190833.1027.4.camel@localhost.localdomain>
References: <1256953837.9681.13.camel@maxim-laptop>
	 <1257190833.1027.4.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-d3xImjReqNJ2NXOM+3sn"
Date: Tue, 03 Nov 2009 09:06:55 +0100
Message-ID: <1257235615.28469.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d3xImjReqNJ2NXOM+3sn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-02 at 11:40 -0800, Dan Williams wrote:

> > 	--> dbm: used only if:
> > 		* valid and zero max_qual->level (but now set to -110....)=20
>=20
> IIRC non-zero max_qual->level was the indication that the driver wanted
> to use RSSI, not dBm.

Are you sure? Weird ... we've had it set at -110 practically forever in
mac80211-based drivers.

> Since the real "max" dBm is around 0 (ie, that's
> the highest signal strength you'll ever really see), max_qual->level
> meant the driver was reporting signal strength in dBm.  max_qual->level
> =3D=3D -110 is kinda wrong, because that's the _minimum_ level, not the m=
ax.
> The noise floor is almost always around -100 dBm so setting
> max_qual->level is pretty useless.
>=20
> This is *exactly* why 'qual' is there: so that the driver itself can
> figure out what the hell it's signal level is, and so that NM doesn't
> have to go around assuming stuff.
>=20
> For WEXT reporting, mac80211 should really be constructing a 'qual'
> instead of leaving it 0.  Then we don't have ambiguities with dBm, RSSI,
> unspec, etc.

We do that -- I think the problem here is not the max_qual value but
that you're not getting a "qual" value since -Dnl80211 doesn't construct
that.

What effectively happens is that you're trying to discover device
capabilities based on wext, but then use the information provided by
nl80211, which while effectively the same information comes in a
different format. When using nl80211, you really should discover whether
the device uses dBm or RSSI values by the kind of attribute it gave you
in the scan result.

So IMHO the solution is to move all that "what kind of crap am I
getting" detection into driver_wext and only export the sanitised values
from wpa_supplicant.

johannes

PS: Please trim your quoting, it should be easy enough to kill
everything after your signature.

--=-d3xImjReqNJ2NXOM+3sn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7+SbAAoJEODzc/N7+QmaUicP/jcU/sSLVxiNQvE+mMaX5Ten
COBDV7DzIrZPBbpP7qmbpD6iqum5OhdPAleDJdHhXc4mV+ndrktB2Poa3/8IqZRO
UrnbqOdnKNyAxnQ9qWcfn0oszbqDY4uftkvhAaWd8d4elLBIdhvIvQwTNU8jGbIH
gZDPP9zbpo45WekDOSGyZQG4lly+R7ib0tyA7JeIx+worQUgqVpfYHFmsMReQoiW
6aKHk0eEmHbmjcbPpGIMgVWhj+dhI60Y5ulp90lJq9H8GoaFxMwCjulwzmS6VZxd
HkJN32O1Zz4bX3ohgUlwcTEpHetpY4zUXWlZfLpRj4UC1HId8wuwSsKMWf6d31Cb
20FIkPRfqBKLkZJvrutKGtGrdp7jmKFbfNoyiipSHvGO9WNB+aFLi2xPNbK5FP51
yeLgwr8S+lTDutHkawh4VTLkgWPxKzN5MXgICKoOTSQvR2491v1nya23YaQlo+UX
2VHGlRFTPK/essrnM44JrI6UqCJJPykMBL57cxGtU58FAu7n0wkqiYEHhjbpbDly
fPkeU5maiMiaI1W6GfzqM3KYquUJm6ooLKYCwBL+WCm9HDNhi35U/v33cBGrAIFl
KVtlcGpRitjSYVn2d+khHZk77phJ4lBCAOulAhksBwbosBBW6nA1U7JicnGgMM/s
rOXJw61HXsoGPCvyuIIW
=fzbF
-----END PGP SIGNATURE-----

--=-d3xImjReqNJ2NXOM+3sn--

