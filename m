Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbXKZPrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 10:47:47 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <474955E1.30603@gmail.com> (sfid-20071125_110054_527140_84EF41E2)
References: <47494851.4070504@gmail.com>
	 (sfid-20071125_100303_057404_A213DFC8) <1195987773.4149.214.camel@johannes.berg>
	 <474955E1.30603@gmail.com> (sfid-20071125_110054_527140_84EF41E2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L1R4/CeLtM1RNck20Kli"
Date: Mon, 26 Nov 2007 13:14:04 +0100
Message-Id: <1196079245.4149.255.camel@johannes.berg> (sfid-20071126_154751_406294_B7A8228C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L1R4/CeLtM1RNck20Kli
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> what works:
> connect to a hidden ssid with ap_scan=3D1 in wpa_supplicant.conf
> what does not work:
> connect to a hidden ssid with ap_scan=3D2 in wpa_supplicant.conf
> ---
> for non mac80211 drivers its the opposite ie.  ap_scan=3D2 can connect to=
=20
> hidden ssid while ap_scan=3D1 works
> (thats also whats documented in the wpa_supplicant docs and what nm uses)=
.
>=20
> so NM can't support mac80211 and non mac80211 drivers at the same time=20
> without ugly hacks due to this issue.

That's weird. But why does it use ap_scan=3D2 to start with? With
mac80211, ap_scan=3D1 is *much* much better because it lets wpa_supplicant
control much of roaming, mac80211 really is designed that way.

I don't see why ap_scan=3D2 doesn't work though, can you enable some
wpa_supplicant debugging and send me the logs? Or can you turn off
encryption and see if you can connect to a hidden SSID? I'd think it
should work because we do a directed scan so the probe response should
tell us the SSID.

johannes

--=-L1R4/CeLtM1RNck20Kli
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0q4i6Vg1VMiehFYAQLzPRAAgX6WUwf8PbuUc0Zea/dziLSqr0Ty6SKx
S36Qwclz13v71qUgKjvDFV9h8zvHh9ewb6iG3hoxmHBG/8tBNATX8vEGsw9wxy98
kos2tTfKuCxxpknM/pOo5JaLxTObjNoyB2m0DTWwgKpEH/zen0oPnFeY+FNVaqcS
iY92vQPh+Q768jymjIMWLdEZ5pcPi2SuLR115YttW+96cwIl/VhS0iPru/Epc7ZO
pk3DMZol1hBFeRY9j5OVJaTAc3cE9W0gSaduEXyp4hoXnof6WpDsetlV8/pfSiTi
ivkPgMaeDz6GLB8E1QD+Q23Q3ZNIZOFtJsgrSFfqZe4aoppFywVh+ZUH0s1Z3IBk
/W+h3L+PR45ZgtG+e4hwtZdu2K3SjxuBP2H0YbWtUtgW8H3IjaWdhK/EbgiqVrkt
mSCiezC4o1nHIAu43nAjflhzwbuK1S6GVOs4CxRqxVTYWTHRswENTGIhUOH7Y/iQ
s1b31q3qk77E6u6tUzinHcEqtCG6eiGYYvMZGSqB48RmkpnaWFxxJZjIjQn1mBAR
Nr08WWoesD/7SSOQv790kruaNlLdtKXnNbz7Yj3mdJYACAjQUCDfyRr/gjEs0fLg
1u1INGhQ+neclB2qHslngj9xBvTX6x3mL/kuWsFTTzn/GgCebjI9Z7Qw5lbgcxaL
312XDLZyuYk=
=Ohy3
-----END PGP SIGNATURE-----

--=-L1R4/CeLtM1RNck20Kli--

