Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:47753 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab0H3PMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 11:12:13 -0400
Date: Mon, 30 Aug 2010 12:12:04 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Rogerio Luz Coelho <rogluz.news@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
Message-ID: <20100830151203.GA2950@barata.holoscopio.com>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com>
 <4C798080.8010002@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
In-Reply-To: <4C798080.8010002@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 28, 2010 at 04:32:48PM -0500, Larry Finger wrote:
> On 08/28/2010 12:54 AM, Thadeu Lima de Souza Cascardo wrote:
> > The code for rtl8187 does not do per packet TX AGC. Resetting the per
> > packet TX AGC for rtl8187b appears to increase its overall TX power.
> > This allows the device to associate and a connection be established
> > using APs a little further away.
> >=20
> > Tested-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Rogerio Luz Coelho <rogluz.news@gmail.com>
> > Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > Cc: Hin-Tak Leung <hintak.leung@gmail.com>
> > ---
>=20
> I'm a little confused here. The subject says not to set the per packet TX=
 AGC,
> while the submission text says that setting it helps. I don't have access=
 to any
> documents that describe this register, but I expect that clearing
> RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT would disable that feature. As a =
result
> the code change seems to match the subject.

Hello, Larry.

I meant rtl8187 versus rtl8187b, since the driver does that distinction.
You may note that in function rtl8187_start, if priv->is_rtl8187b fails,
it will reset RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT, just before
writing to TX_CONF. That's why I've decided to do it too before writing
in TX_CONF in the priv->is_rtl8187b true case.

And I meant resetting and "setting to zero". Perhaps, I may clarify that
too.

>=20
> I have not yet tested this code, but I do note that all the Realtek drive=
rs for
> the RTL8187B set this bit.
>=20

Well, rtl8187B_linux_26.1056.1112.2009.release does reset it to zero
too. And that's what has hit me into trying it.

> Until testing, I withhold judgment on the actual code change, but NACK fo=
r the
> inconsistency.
>=20

I will send another version, clarifying the commit message. Thanks for
the comments.

Regards,
Cascardo.

> Larry
>=20

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJMe8pDAAoJEEWxSg7udFZIbBgQAJsji14/Ue3yLm0Hge4gwktU
Dr6if+T7CHeeQhthK06pLdnYrLFC0CUQb8FyETeKsmKRknwO30gcMMd/OZfqeVKJ
nFbmjbh4jhZ2DoJBF6KNQnYDJdVzab2th9Ec1dDjixGHTTFDgjUGml4olYApHjBC
8f5V0DyUPpAJjnjjuRFRo9tGS3z7H05grRfbOVfrpz6gomRdUT43JX9DAQUYVaPR
OdudNfZp30dayu28qqgX8HVSlbCXYUzCsuJTemEUTBflTm1dujQkTFso/jYN5JvV
alNOvyEGTw50pgGbUbYPlbW9M3gmMKYMwqAObOvda1LhB0mx/MLY0055jU55OHMX
YG4LRolLJc2oyj4GlEmROLQwz2E3+olW4eiTMYTp9qjBTvb3mwU+YyVSgEuK2uGZ
0/8QHYDdCNAitGFq6jOZW+Ur3+b92Ae2TKbkqK/MyuLe8t4dcq1zRrbCZ3KvKcWA
tQdAjJF0ABBEE8ZHG6qOwflCTtWeqJvomEo+zICIIxqg8QLXFFgW+1hH6WjcimpS
Ws69FtzV2q4ZRAo+eGnNWwxI2Jrc7KyOyjF2VloQmu++Z8ovw8oc96sNLm0WRWJJ
n7vZzjHsrYFoHeiDnao29S2V5hO/FoKnHvYrJO4rhF1mL+P9VGaF5TbuWQMtNtfS
TWzIFLpLoEPer7Kyyb4S
=0Uhn
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
