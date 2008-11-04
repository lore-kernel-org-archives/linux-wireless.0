Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYKDKcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 05:32:08 -0500
Subject: Re: [RFC/RFT PATCH 0/2] rtl8187: implement conf_tx
	callback/correctly ack tx pkts
From: Johannes Berg <johannes@sipsolutions.net>
To: htl10@users.sourceforge.net
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <118209.17192.qm@web23108.mail.ird.yahoo.com>
References: <118209.17192.qm@web23108.mail.ird.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iugzhZUYGgHhGENNgZlh"
Date: Tue, 04 Nov 2008 11:31:53 +0100
Message-Id: <1225794713.3619.69.camel@johannes.berg> (sfid-20081104_113213_214395_924D103B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iugzhZUYGgHhGENNgZlh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> if (condition)
>     info->flags |=3D IEEE80211_TX_STAT_ACK;
> else=20
>     info->status.excessive_retries =3D 1;
> ---------------
>=20
> But the else-clause is missing in the latest patch (of two), which also s=
eems to be where both you and Larry are having rate stuck at 1Mb/s for.
> - and the line below
> "info->status.rates[0].count =3D pkt_rc +1 ;" doesn't compile
> under 2.6.27, so I changed the rates[0].count to the retry_count,
> and simultaneously adding the else-clause back.=20
>=20
> My question is this: is the removal of the else-clause unintensional,
> could it result in your 1Mb/s rate?

The excessive_retries status thing has been removed and mac80211 ought
to always use STAT_ACK now.

johannes

--=-iugzhZUYGgHhGENNgZlh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJECSVAAoJEKVg1VMiehFYxGYP/3Ln1OfitGUD8GJihNyKC7lS
zSMjLj93NneYj/Xx44pvdQwOvDNaro5x0qTRjki4do5R5Bhd/NOvFhD9JYAE45yt
Y42DFPL5U2ZtbrA6j6X18KZl7djyi5rEyTU6N/M+XVFf6ZIrppdK730NHLpboFHY
Ti6zFCz61wbkaC9+dUgxAwUEdOvXtD356l0+9hJCyJn3FBCG6JVwG+bI3/aQ52oZ
sckABM8xRfdglu+j8Bz5Y5gUTwOiXUk4mag3liXXqjAG5xPpoVFrG4VydOVxqO6t
Xho1+FS17q/mqhUCXKqzhYCSYVaX+vN/hW3YUAGNXfZTsCSG174B2c/XmgQKK8km
U7dCYIdlueWtzvpUWVVLfM3dP37bnvw3OoIP48NmDJSTiSrfYHyVnGruwmZayH5W
ZFPnG/ty6k4j21WFyWgUKaKdRVHjcOGsoLtPUT3c/YFHZh36U7IM/Y0TzQOPGPMs
l5QBwbxLBjGsf9/kfCS8zktJ9UqR8k6L4v3BA+LxZRusP5X+MykZg/EbOoNmr+r3
4eXxnaBeRyKDXIuxCHg+NSl34hepz+7jTsbppli8n5XZKwDFpQ3hBQBGGLISmGfj
/EWAn37634OB2dCCM02qqRTpsZNJd3giEn2dw/+WaYUO0sAq3Is1DJg0aJq3XyxX
c5VvUt99QsyDx9E42c5f
=T1Ec
-----END PGP SIGNATURE-----

--=-iugzhZUYGgHhGENNgZlh--

