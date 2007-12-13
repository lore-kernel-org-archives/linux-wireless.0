Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbXLMLjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 06:39:32 -0500
Subject: Re: [RFC] mac80211: clean up frame receive handling
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Tomas Winkler <tomasw@gmail.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <f6ca9fed0712121039n1c287f48n7ece3107bd0b50ca@mail.gmail.com> (sfid-20071212_184013_928458_78921AE4)
References: <1197483844.6558.158.camel@johannes.berg>
	 <f6ca9fed0712121039n1c287f48n7ece3107bd0b50ca@mail.gmail.com>
	 (sfid-20071212_184013_928458_78921AE4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZOk6UhIM3vb06j3bbswg"
Date: Thu, 13 Dec 2007 12:35:40 +0100
Message-Id: <1197545740.6558.240.camel@johannes.berg> (sfid-20071213_113935_109542_11872D2F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZOk6UhIM3vb06j3bbswg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > This cleans up the frame receive handling. After this patch
> >  * EAPOL frames addressed to us or the EAPOL group address are
> >    always accepted regardless of whether they are encrypted or not
>=20
> why? userspace (wap_supplicant) tryes to control this depending on the
> network settings.

No, wpa_supplicant actually requires EAPOL frames to go through. hostapd
currently wants them on the management interface but on the data
interface makes much more sense and doesn't matter for any sort of
control since we only let link-local and unicast packets through the
port control/drop_unencrypted.

johannes

--=-ZOk6UhIM3vb06j3bbswg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2EZC6Vg1VMiehFYAQJKBRAAicoEgLB4Y0oFbuhDMEOUsbBb9x/1Dy3G
XIMimT4jxhsvFBLLSDVIgLtPGvipopdMcOK2xiiBkuHJpxrsmyucoDbJ2CldgDgR
1p/e0Ma8KQLJphQt912fTpYtuHKl++8J9rxCf2DgYJokzab6TOMBoxuGnC8J2nVC
r8Lb2ZtBMmBifOoXnmDLJxE/1WtgO0KGEazaSiR3hcUqQm350xBiK9+pE4nHeCzv
I6K9PbzWvHP6GJQQEKxxp8XRWozfa3tN/SHu8QJ0JPSy5gS/l0S36w98mbZyv7yF
BdL2AO1c5Cd0BEqKitA+VKy7WsHT/Pm68kdODNRaxRo8LQ2dG7taq/LT2kP+nw8T
yCLId9J5yw3YoyDerCVMNaIurqimdOexIP4XixyvBpTlp2uShSougXVkdbSAyU3F
c11UQxMWfyUQ9siIeUXus4jBMnioqinppfDjVjK4Q7OhOfezKLkKYAGmXbqDcCcK
HMdNf9qiCabLlg567hSLDSXiNUXwFtkLK9cjW6NWr7whOzsL408pBsxVT0aUzwal
y7Qc5Wvj9CXcdS18BB52rSWdtn4ATT7I4J9zxCXoC1inEqaRbJ4bgtMIvDfBR+Z2
aCF/v8FaGfpgY6UXT6AtQ0f0TT316xYB3AqxV5D8CNLr5QPfikb4j7peYZrvFsPP
waX4V6GzBCE=
=qva2
-----END PGP SIGNATURE-----

--=-ZOk6UhIM3vb06j3bbswg--

