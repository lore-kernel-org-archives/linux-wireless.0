Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbZCYKqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 06:46:00 -0400
Subject: Re: wireless powersaving (in NM?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1237890734.4740.7.camel@localhost.localdomain>
References: <1237891149.4320.73.camel@johannes.local>
	 <1237890734.4740.7.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H+tKhgfNYIjoSoU6qHh4"
Date: Wed, 25 Mar 2009 11:45:25 +0100
Message-Id: <1237977925.4320.138.camel@johannes.local> (sfid-20090325_114608_425965_59180286)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H+tKhgfNYIjoSoU6qHh4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 11:32 +0100, Marcel Holtmann wrote:

> I prefer that we not export this over WEXT at all and only via nl80211
> so we get async notification if some one changes it. We should extend
> wpa_supplicant with an option to set power saving on/off/default and
> then make sure it gets exported via its CLI or D-Bus. So if Network
> Manger or ConnMan cares to change these values they can.
>=20
> However personally I think the need for enabling or disabling power
> savings is not really useful except for testing purposes. In a real life
> deployed system it should be enabled all the time. Broken drivers or
> hardware that is limited can disable it on kernel level, but for
> userspace we only need this for debugging.

Kalle makes a point about broken APs, which I personally haven't run
into but I'm sure exist -- and I see no way to automatically detect
that. Therefore, it seems necessary to allow overriding this even for
non-debugging purposes.

I have no problem with just changing the default to be enabled though,
but that requires some work to turn off automatically for most virtual
interface combinations. As I said before -- this needs to be fairly
conservative and only when applications register their requirements can
we go to lower power states with higher latency.

johannes

--=-H+tKhgfNYIjoSoU6qHh4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJygtCAAoJEKVg1VMiehFYIG8P/jmuGp0r4I/rOJFp8l16A6Pj
bgVO0vbhteXwEQ4km9foiKtkYeG5qpyEj/68/hBSvW9cp0Iy4YykwFT65lIJUgdp
5YscNwzvBhshMy5Ilwro2xzJirJrDZLcv7eKT+G4tLH823Mrg2AiVhj3nD0nBl1C
1SLR7cuz663ceiCwpvs6wuIhmw7dm+NKaKICSCebfIKsZ+UAgObQIeZosEV0sSFx
iz+J0YKYX3KpTfu3XL9v4HY9qGH549Z25Ds5wV/7Q3PxzgRuyOHdRyI2D3aCZrT/
mW0dJo3P/tAl3g5sDRb+ZQidsDNH9q3Y9TvJa8FQJ+SG+faBw6xhskFUp7sp6EPv
Ds06aj3M+BWqirJ/Pi6ndEvx2SmPx9lqqMWkjKs5dAyaPQwFha8jIlukpX7QnGnw
z7dqi6rNL5ps7izzTpBO9skkMicNb56l+jCPHpfVl8x8BOn95WQQz5QrJs7kkwXi
OqjWDBIIuZPif15nq7UoFLJpKXKcFZEQ2uz/axaE0WXptmAPLJdimRRLfN/brrDn
TSw22pmdq6QiBHHM6PRZSESdN2n+WvDRgocQvabFFcfyBm5i2eDB22pJcDPujI3l
gvg8AnUcu1m0tZXFIAEMGWt1BJoU0wuGBXPt2b5pq1BD2N3VFszLh7PoFrrykvKR
SgOb9oAuHUoBdrC2P6Sk
=n8CZ
-----END PGP SIGNATURE-----

--=-H+tKhgfNYIjoSoU6qHh4--

