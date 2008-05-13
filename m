Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYEMMex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 08:34:53 -0400
Subject: Re: 11n + wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <20080513122718.GA6309@jm.kir.nu>
References: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com>
	 <20080513122718.GA6309@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hb5JUxJ8SM1uQW8PekFZ"
Date: Tue, 13 May 2008 14:34:40 +0200
Message-Id: <1210682080.3646.73.camel@johannes.berg> (sfid-20080513_143456_579757_53AF3CE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hb5JUxJ8SM1uQW8PekFZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> In most cases, the pairwise cipher is selected during association, not
> during 4-way handshake. Consequently, the driver/firmware should refuse
> to send an (Re)Association Request that requests TKIP as the pairwise
> cipher when using .11n.

So to do this we should look at the associate IE(s) we get from
userspace for association, right?

> The exact mechanism depends on whether ap_scan=3D1 or ap_scan=3D2 is bein=
g
> used, i.e., whether wpa_supplicant is responsible for selecting a BSS
> from scan results or not.
>=20
> In ap_scan=3D1, I would say that it would be useful for wpa_supplicant to
> know whether the BSS (and the local wlan driver/hardware for that
> matter!) supports .11n. If the scan results indicate this in some
> reliable way (e.g., all IEs are delivered to wpa_supplicant), the AP's
> support for 11n can be figured out. The local side support would need to
> be added, e.g., to driver capabilities reporting.
>=20
> In ap_scaqn=3D2, wpa_supplicant requests the driver to select a BSS based
> on configuration (SSID, security policy, including a specific cipher
> suite), i.e., the driver would be told about TKIP use before
> association and the driver would be responsible for not trying to use
> 11n in that case. The corner case of AP/Authenticator requesting another
> pairwise cipher would still be possible here, but not really something
> that I would consider a real problem that needs to be solved.

I'd think we can also just include the HT IE in the scan result. Or, why
not just include all of them, parsers must be able to tell them apart
anyway and NM could display an HT icon for example then.

johannes

--=-hb5JUxJ8SM1uQW8PekFZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCmK3qVg1VMiehFYAQKSOA/7BDBAlgmfi1cFLaZytFnp3TfXYPb4rTUR
+5jc+sZfj4vcmgYbkfMYKCS8ruNo5NDxTOh5zBFeXuNVTv+O2rIzQdIMxsx/TMAf
dCrk8VNCFdx8QtR8MYxuVSMZ25iX+YHrPWPzG6wFVV/WaSpUcufi2lcZYKkrGTAJ
BwwaQndDewJDNvYSJO1hwgo1A1DXruVaFy7+sy/IoLCllZvaRTG7NX2XjlR6sHdL
JMw//6qyLorYU3r/EwhD9VuRjqoX5lrx7rv6H9X2QMKL6Q1qBXTfkS6lCT9Ald8J
H3DcsPbIRv47vfsnfokWYP7CUI/yhrqHRtFhdJLTa5s0cV0fMoWak5IElOTb/FNC
Dwu6p2StI92cihXalDDsQAdJnnea5UYPM60rqdcJ7B3BsXHOyLshIrCDl9ifSqnJ
sgfTBaPDJPEOJuj3lH5h32pLxS3R519inhL6VzoIPfa4CGpAe/GNE1sjXx0CKlQ+
eVIKIKiyBHVBlPHL0CJch5CWXtaqhTu8beZtMtL8U1GKhdV9iBVH8eTFPNvoC0u7
f/lSdupcIZ49WFDOn3s8JDvKEPhZmWKgtY04L2cQFI3c6h3GGqsIWVE61dsTYcKZ
v3Yd0yjyi4nWzo9JGwo52MBPhqZMypN1B7KKi/l235ggjhzRNGh8FJXpzePWNCzT
j2DScSTyxnk=
=OPo3
-----END PGP SIGNATURE-----

--=-hb5JUxJ8SM1uQW8PekFZ--

