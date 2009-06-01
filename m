Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZFAOdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 10:33:09 -0400
Subject: Re: [PATCH] ath9k: Add sanity check for beacon_int in adhoc/mesh
 case
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1243865135.1930.2.camel@jm-desktop>
References: <20090528162528.GA8117@jm.kir.nu>
	 <87skikt72k.fsf@litku.valot.fi>  <1243865135.1930.2.camel@jm-desktop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8NRFY6xj1yQSjZG7vey/"
Date: Mon, 01 Jun 2009 16:33:05 +0200
Message-Id: <1243866785.5299.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8NRFY6xj1yQSjZG7vey/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 17:05 +0300, Jouni Malinen wrote:
> On Mon, 2009-06-01 at 06:30 -0700, Kalle Valo wrote:
> > Jouni Malinen <jouni.malinen@atheros.com> writes:
> >=20
> > > +     /*
> > > +      * It looks like mac80211 may end up using beacon interval of z=
ero in
> > > +      * some cases (at least for mesh point). Avoid getting into an
> > > +      * infinite loop by using a bit safer value instead..
> > > +      */
> > > +     if (intval =3D=3D 0)
> > > +             intval =3D 100;
> >=20
> > Maybe a big fat warning here would help with debugging the issue?
>=20
> If we agree that this should never happen, such a thing could be added.
> Though, it would probably be better to place that in mac80211 so that it
> would catch the issue with any driver. The beacon_int=3D0 notification is
> not really in any way specific to ath9k; only this workaround for driver
> behavior is.

Has anyone identified why this happens? :) I'm not particularly happy
with the mesh configuration code anyway, but this is a stupid thing that
should be trivial to fix.

johannes

--=-8NRFY6xj1yQSjZG7vey/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI+aeAAoJEODzc/N7+QmaAhEQANON42pOV0QficzJWAtg78Fp
8K+swEvjLjxWVU3XReTq/XvKdAo9tPnbIPLpcIXJin6pJKEQ5GqhykpUhJY4m18T
HAfAnxM8AA5B4O3yeKXPrAaxXaVgNOwY+p/WTQFGpLfNjazRC+rV+80zWKk4gCJk
qXLjv/Ds4vjFPiH3ueGCC/b+rffxYYOR3bOaydSLCX9DzZ2Mw4j/GxZ0s0r8dHJi
S9feobtet+Kh7469ryj2rV5lw/OPpcDFqtFWkBjsDXV/VCQjb9uEXzmeeqoZ9gNC
CiXVZAvOwykRM9SZsDQ1xQ+HiAzvtgOQoacth6UWrI+tix+bGeQVHXyJCW8kFy/I
ucV18NkesmLoB5P8L7gUR4ZbiJppAKzMhWyqELrCUlZJ+ex7skLCHqy4Rv3XzC4F
HdzoB4nU6mVt3yrr9uD7FWizg1n23iypA9cyS0dY4UKGo+7sIpJkd/wmkR5PnWQg
Z4DAt3OYdOUtHB48BlZfkSsVTCzuKFFeY3PBcjJSA/DDOW8+n+y7VHycGkN76lJz
eApKah/kESPmSeqaPt+uhMOy7Q0PxINmnrjPrfE7L9iaZ6PDpZFsSxwG5140z9Gw
GjUTpO2+3OwAb/C81tGV/Y9DQaByPyV0EBQaUrKoeLcXkZ11yZoLaNYZpJaVj7cD
VcXYAQ6gTqsBORGH6Kv7
=CIuO
-----END PGP SIGNATURE-----

--=-8NRFY6xj1yQSjZG7vey/--

