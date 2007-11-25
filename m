Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXKYKto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 05:49:44 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <47494851.4070504@gmail.com> (sfid-20071125_100303_057404_A213DFC8)
References: <47494851.4070504@gmail.com>
	 (sfid-20071125_100303_057404_A213DFC8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Fvtpka4BnZQH39YXnJi6"
Date: Sun, 25 Nov 2007 11:49:33 +0100
Message-Id: <1195987773.4149.214.camel@johannes.berg> (sfid-20071125_104954_159455_43E8459E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Fvtpka4BnZQH39YXnJi6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> First  sorry for the late report, the patches from the old thread fixed=20
> the privacy mismatch issue and now I can connect to a dynamic wep=20
> network. But the connection is not very stable because I get tons of wep=20
> decrypt errors in dmesg (while the connection is working but slow).
> The same network works fine with ipw3945. Also iwl3945 works fine with=20
> static wep. I tryed the hwcrypt engine (hwcrypt=3D1) but it did not chang=
e=20
> anything.
> While connectiong with wpa_supplicant I saw that mac80211 does not=20
> support the IW_AUTH_DROP_UNENCRYPTED ioctl while ipw3945 (ieee80211=20
> based) does.
> Could this be related? ie. mac80211 tryes to decrypt unencrypted frames=20
> instead of dropping them?

Odd. I'll have to take a look. I recently noticed that mac80211 would
always *accept* unencrypted frames but it shouldn't try to decrypt them.

> Second problem is that ssid is hidden. I was able to connect to it using=20
> iwl3945 (even with hw_scan) but only with ap_scan=3D1 (while ap_scan=3D2=20
> should be used for hidden ssid and thats what nm uses). Non mac80211=20
> based drivers do not work with ap_scan=3D1 but with ap_scan=3D2. So this=20
> needs to be fixed somehow so that nm can support both wireless stacks.

Uh so say that again what works where and what doesn't?

johannes

--=-Fvtpka4BnZQH39YXnJi6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0lTPKVg1VMiehFYAQIAbxAAwMI/FakXZJBU/8ckRsORvkZ/DMY93QRE
IErbChnT5lM9O4KV+1dsqzLMyxT509OjPr5DX7CKgtgqp9797/1HqOPzc41MaL2Y
QN5b+0kyv/ZUXkUX9F1Xe4PxnrtXOJNz9Xh/V/p5gTijH3P2muBAdXrHnGO6ME6O
DIuKI24qFE/OdkRSfCRFqRK9hhV32Wti6diY5K68w6CI8ov11IB0Jz7k6MSxrmhN
D6EOS7yeZ03Lz3T5XtOl7ld5RWzkStCtekeOaUdmt+tzp/ZOmnt7IWESPunsF6hy
N8XWKZ8qvwNOUC1oWNVsGh+Q6ytLn+hSHArvUyw5AT8ES8zUXeqsg/UzNiYHQ2Jg
5VSBc/KQ5ecH3oTxfcoRM6a9G1GAJXLMi8yAfIY0YZjqvqEQz6+udaAuJI0PXIr6
dp29PRtJhzgc6iiLD1U46DmOewUvb8uL5o4svEuOEsDcQamYc6oEh8F/w87e9MmE
Mhy8BAmAG0W6ry0DVLWzj/3XdulBpj0fdyD10oRJ3Ip456hz4h+IF5Cujhk9Z6y1
QYwwG6CNkiTmzwXw6GiW+9C1J+9GeOiG38eaZ4V1yKR7OexkBX47Dh84GvcuWnMb
bfFPA2qCn1xH1QCcYDhQ4Bls1Wm5UDTZOlmwtcKBn6NXmZJwfjo5//XBdaHrnAqk
bCHe0AANudw=
=CNBv
-----END PGP SIGNATURE-----

--=-Fvtpka4BnZQH39YXnJi6--

