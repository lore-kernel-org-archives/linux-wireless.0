Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbZJZJWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 05:22:35 -0400
Subject: Re: Questions about cfg80211's cfg80211_connect_params->crypto
 settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200910260947.48365.hs4233@mail.mn-solutions.de>
References: <200910260947.48365.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0thTEhV+pFTvU7N9LeJZ"
Date: Mon, 26 Oct 2009 10:22:29 +0100
Message-ID: <1256548953.28230.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0thTEhV+pFTvU7N9LeJZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-26 at 09:47 +0100, Holger Schurig wrote:

> I'm a but confused about what fields in "struct=20
> cfg80211_connect_params" (now abbreviated as sme->)
> are relevant for me.
>=20
>=20
> sme->private
> ------------

I think you mean "privacy". I'm not sure about it right now, would have
to dig, but maybe the answer to the others helps you?

> sme->crypto.wpa_versions

> sme->crypto.n_ciphers_pairwise, sme->crypto.ciphers_pairwise

> sme->crypto.n_akm_suites, sme->crypto.akm_suites

All these pretty much exist for hw that doesn't want to use the IE(s)
contained in the connect parameters. If you send an assoc request with
those IEs, you can safely ignore the parameters here. It's just there so
one doesn't have to parse the IEs.

johannes

--=-0thTEhV+pFTvU7N9LeJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5WpRAAoJEODzc/N7+QmaVaoQANQTgAMLrcLa61ONEfdsMyx0
Bjd5EFslLmnovPifZNvIBIqZlxUudcU+oFDvCAen5D3/EcEupv/V6GhBk96Pn9uJ
ksIG2uIdsUbpeFbRy0b0brgOv9JtZZFBPqDvxt2zYf98doPT2IZ8p/i1pCbQHrOi
rsiGFhKFF2IJGVHTrYrsOUjKL48xT+EL2QjaJagU3Dy/qEIJb+Eyz353obsQUE8e
dFqsVosFZeu99+PyA10foENTFrUEu3LPbSPt5DvX93tIKe9j7yf4zRNyTsfN8ZyJ
UlUjd+Uwug6T6Wm2hcSqTWSZUDpmYKTUYsz3/H8+mDNJZTcS4eYc/9T8XvuzDzbn
BVidyF1zJaKGU/wyn5Nkw/rdl5FFdtt7eMc9KVkyG5oyAWDjM5OvXEKmzSUxMWrU
Pt7Vmx6xJwSEX5FB04K7Sgdfx0zYXyWKQsyY9xXW12RfOUDNl+ibPaHhdAOp5apu
Qz5bsF0rAEM2GRdJSsAzKBZs2mYE/qhwMlLMHJDaWHd3EmVEn8QlwAdK3reeqQbj
A4hcUPPA1fPkDM4YOzkCrkpOxya0qJ6FM/hiEkQu3/jfpCtGU66o1KuukUjXZxqH
x1XaQbbmzc+tyRfXrxLSRGkvHQmEJ7qNxZTmyRLckgMnCpaCAQNdtgfm96YipW87
RXjFIGMF4ty3leOq4H26
=nQ5u
-----END PGP SIGNATURE-----

--=-0thTEhV+pFTvU7N9LeJZ--

