Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXKZQOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:14:33 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: drago01 <drago01@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1196093064.4202.46.camel@localhost.localdomain>
References: <47494851.4070504@gmail.com>
	 (sfid-20071125_100303_057404_A213DFC8) <1195987773.4149.214.camel@johannes.berg>
	 <474955E1.30603@gmail.com>
	 (sfid-20071125_110054_527140_84EF41E2)  <1196079245.4149.255.camel@johannes.berg>
	 <1196093064.4202.46.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MaPzMh2LkFf58x9kKIcS"
Date: Mon, 26 Nov 2007 17:14:23 +0100
Message-Id: <1196093663.4149.285.camel@johannes.berg> (sfid-20071126_161438_251911_0F19779F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MaPzMh2LkFf58x9kKIcS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Because in the case of hidden SSIDs, wpa_supplicant pretty much says to
> use ap_scan=3D2.
>=20
> There are a few problems here:
>=20
> 1) Historically, some drivers worked better with ap_scan=3D1 (madwifi),
> others worked better with ap_scan=3D2 (many fullmac drivers)
>=20
> 2) scan_ssid=3D1 hasn't worked consistently on all drivers because it's
> pretty new and many drivers don't support it yet.  This is supposed to
> make the driver/firmware send out probe request for the SSID in
> question.
>=20
> So basically, we're up shit creek without a paddle.  You have to use
> ap_scan=3D2 on some cards because they don't support specific-ssid
> scanning (with scan_ssid=3D1) to find the BSS you want to connect to, but
> some cards can handle ap_scan=3D1+scan_ssid=3D1 OK.

Fun. I'm pretty sure mac80211 handles ap_scan=3D1/scan_ssid=3D1 fine,
sending probe requests for that specific SSID.

> NM has logic to cache the BSSIDs of APs you've connected to before, and
> to match those up with an SSID when it sees them in the scan list if the
> AP isn't broadcasting the SSID.  Unfortunately, that information isn't
> available to wpa_supplicant because wpa_supplicant doesn't have an
> interface to handle that sort of thing.  Therefore, when faced with an a
> request to connect to a hidden network, wpa_supplicant must rely
> _entirely_ on the driver Doing The Right Thing with scan_ssid=3D1 or
> ap_scan=3D2, and that almost never works due to inconsistency in driver
> implementation.

Who invented hidden SSIDs anyway? Well, I guess I can actually test this
now that I finally have a second mac80211-based wireless card, although
iwl4965 is special wrt. scanning. I guess the trick will be to make
ap_scan=3D2 work although ap_scan=3D1/scan_ssid=3D1 works much better :(

We can fix that in nl80211 by making sure that scan_ssid is implemented
right away and whoever has nl80211 support needs to support that so that
we can rely on it...

johannes

--=-MaPzMh2LkFf58x9kKIcS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0rw3qVg1VMiehFYAQId2Q//cvIbe2lnd/nZbUT4IT1UESKZqnasFcbU
Qm0qgHkgJSEY9hAkM/fNkOOvN4GeKFGQorJlmaOQMBHeeasjn8WtPzOYA4nyjvzJ
DD8K9Zgl9328e7zCKyCsvFO7+lkNFbFqLVxrcHPunPr90lgJpYN9uVMMk07nALoN
M2KlwbLl42ECo6/fkloJRf04BET6+20NMfk7B+1KJRjQRgfbSuE0nW9Mh/NtnX1H
uJfkjNPZA5T8WAxKYrvjdWNVKO7kOyCJzoOQeVTSVpGRbhCVQGS4zQ6+9fLOoLVj
MkfRonXc4jZngwWAk7O+nnr5riG0JdNwCrS6AVs4+vCOsjHltjJaQlMhK1ja3e07
xEbYnlq/c7CpYWeLcnn4vVRG+0b3sq6sZawi21/EXL6Nnb6F8sb2t0pI4wA0orNZ
UNaUFn3DPs4RYvFjvSyKQNIzFElmkan5A3/zrg2AWKW7bUIDRsCfBwCNy4NDE3Ps
Ds8XQb43TqGQylQATCPwBH1CRvnCc2h/zAODI6xFdlgHYMBJ5lfKChzRGybtpdEr
cifkRqqSz2xBV4iorFJ2lMowAI0qDDuNj/LT5bqSFPHHNMOsnFAaDHgrQfoYApQu
IykP+F0We1euXbxRqTtkYYPgDXvCR/ftHnZLWk0RAm/u94LXktVYNsd0oa3PQ4Rn
Fd1KCypgkk8=
=47Ay
-----END PGP SIGNATURE-----

--=-MaPzMh2LkFf58x9kKIcS--

