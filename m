Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51914 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZDPAot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 20:44:49 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <Kalle.Valo@nokia.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1239841291.25334.18.camel@johannes.local> (sfid-20090416_022212_435684_EEC24EF6)
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239841291.25334.18.camel@johannes.local>
	 (sfid-20090416_022212_435684_EEC24EF6)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Zp8FC6ma4oecpmTVk0+t"
Date: Thu, 16 Apr 2009 02:44:16 +0200
Message-Id: <1239842656.25334.20.camel@johannes.local> (sfid-20090416_024451_966969_A00E0DDC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Zp8FC6ma4oecpmTVk0+t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > After a long debugging session with Reinette we finally tracked down
> > what is going on here. A full scan with this card takes 7-9 seconds and
> > that seems to be too long and trigger IEEE80211_MONITORING_INTERVAL
> > which then deauthenticates us with the AP (reason=3D6).=20
>=20
> Yeah, this is a bug. We analysed this problem a couple of days ago and I
> thought Kalle was going to fix it -- maybe he forgot. I forgot what
> exactly it was and how to fix it, hmm. Right now I'm confused and can't
> seem to reproduce my analysis. I thought it had something to do with
> using a different timer but we do seem to use the regular mgd.timer, so
> I'm not sure.

Hmm. Can't seem to find what's going on -- can you enable
CONFIG_MAC80211_VERBOSE_DEBUG and check for the beacon loss messages?

johannes

--=-Zp8FC6ma4oecpmTVk0+t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5n9dAAoJEKVg1VMiehFYszgP/0jGrT0A9DxqtZSqq0BmTRUB
14/CNZM8PVVs4k2xWW4bOjS0Pz0HN4bQCVX8um4FtFkaHIIq+nN9+Mj4ELNI1xcX
IsuGHtgh7WcR1sab2IqeQ48A55gBStbgx+XsCM00ppm3dcAwaJpaC7grKGElC7AA
cucIDqJiCfdFxHyFwReG3nAhKhOMXB4FZSFMrZcTobj3pHhy4titjEtrsAo/NDps
S/hAESXztGdzegXz3v2Df1RkRIVKjSU34INhV++ViJ5KQh9fZyCdvXPMAO4ytqZT
b3Y6meH03X+GvAV/r3hvLEdgct68DCq/77SRi8uzYb2Lo6NeIdBbTkOi/CUT+g6V
eqViqhZG23P45b3Ck37HMbmYfpgi6lz7j5PedvNNR8UaJBouVrlI1CT3I0oNDtd4
c1uOlHiTAVcVdCv9UPoUlVHVOnSKHLvR3VfiDosZXiZQJpb0AuT18iwe24pEAXbp
cUdGb+F1GxzXk68rRdKTjpxAuVEsxK8hC23+jsC+xkOEug6DV0VI+eJEV7H2D52u
3qhI+Yh5alPy3kwIxCEFGXMswkkHguYirGh68hqjR3o91Ib89Bi/DprHXZ7Od7XE
INdI25HaK+UHHmmMxNXu9lwVmWVQ76SFE1NPOOlFk0u9o8286yWLdNk8My0aA9da
IrX5TP2kMg8W6qgQYY+q
=P4aU
-----END PGP SIGNATURE-----

--=-Zp8FC6ma4oecpmTVk0+t--

