Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:62704 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab3FKL5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 07:57:24 -0400
Date: Tue, 11 Jun 2013 13:55:25 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCHv4 4/4] nl80211: allow sending CMD_FRAME without
 specifying any frequency
Message-ID: <20130611115525.GB1466@ritirata.org> (sfid-20130611_135727_136516_39F75DFD)
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
 <1370444989-2095-4-git-send-email-ordex@autistici.org>
 <1370951598.8356.21.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
In-Reply-To: <1370951598.8356.21.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 01:53:18PM +0200, Johannes Berg wrote:
> > +	/* get the channel if any has been specified, otherwise pass NULL to
> > +	 * the driver. The latter will use the current one
> > +	 */
> > +	chandef.chan =3D NULL;
> > +	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
> > +		err =3D nl80211_parse_chandef(rdev, info, &chandef);
> > +		if (err)
> > +			return err;
> > +	}
>=20
> I think not specifying a channel but setting
> NL80211_ATTR_OFFCHANNEL_TX_OK must be an error.

You are right. Indeed this check is done in mac80211. Other drivers do not =
use
NL80211_ATTR_OFFCHANNEL_TX_OK at all. But for consistency I guess it would =
be
correct to do the check here too.

I'll send a new version including this change.

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRtxAtAAoJEADl0hg6qKeOTKgP/3tBW1xBFid91DhZLhg8ujOq
Nu5pUixhqFcsXWgfGQ3axOQ1FUhF5wD5nxpC0bZcHVbQe+w9gZ0yEsqQIvLQml41
ndYXQtqYeRg7W7ARekJc8KNtIt5tLsSDb05yvHmqJ4rcduUHZXhRwCeOv+yqacok
KUyo8+AO9TzL9VJYg2blqs0PBEQyE8oQBzuPyu12wTu79X9KmRJ1MQeYKbrcy4/w
FI3Irt9WRFJ/ecl0Oe6/wQwwhVHguPAfPFoQ1FpZz35uG/t0qQTECysyM32wvkrj
mQucAJb8P4sxUqEczN3qKyfuEU02CE6O180x1NHDu0tJvtpkVf8Jki3gKfPDllLc
t+jpNk+MSOfQ0GB22LW+MTtBQKjgfGXv6XhZmM3NPiurKnaDt5Ctewnc7QcpogeB
q9qBdAt5u4cSFPnNgBCkYQP8xtQl97EBdACKGydonldaZdxJ/GmHeRYGSA53gHpz
Jfbf9ftykOXeBNAXNM16HrhsGBZRKmEjSPIl8kYYi0Osra/w9j13b/T/aKxNcYT6
/1lHxPvJZQrRGinqpkMe0rw8sA/ghZfpL23o9Y5vsx6JaKxtNk6NGfsjfZQscu72
cM48/SskuLm4l2EO8qBp6gDAO9dcImXjklhlbud67++Np8a2itYmWeAkQ5C+KtAk
GjMbPWemxJ58pijwIRAF
=Gm1G
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
