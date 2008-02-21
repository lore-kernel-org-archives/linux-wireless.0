Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbYBUJ3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 04:29:31 -0500
Subject: Re: [PATCH] rndis_wlan: fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080220202015.GC3825@tuxdriver.com>
References: <1203504466.17534.16.camel@johannes.berg>
	 <20080220202015.GC3825@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k3WOuRtTtywEqGHtMFT9"
Date: Thu, 21 Feb 2008 10:29:17 +0100
Message-Id: <1203586157.17534.125.camel@johannes.berg> (sfid-20080221_092939_792450_525D9062)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k3WOuRtTtywEqGHtMFT9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > --- everything.orig/drivers/net/wireless/rndis_wlan.c	2008-02-20 11:43:=
22.000000000 +0100
> > +++ everything/drivers/net/wireless/rndis_wlan.c	2008-02-20 11:45:35.00=
0000000 +0100
> > @@ -228,9 +228,9 @@ struct NDIS_WLAN_BSSID_EX {
> >  	struct NDIS_802_11_SSID Ssid;
> >  	__le32 Privacy;
> >  	__le32 Rssi;
> > -	enum NDIS_802_11_NETWORK_TYPE NetworkTypeInUse;
> > +	__le32 NetworkTypeInUse;
> >  	struct NDIS_802_11_CONFIGURATION Configuration;
> > -	enum NDIS_802_11_NETWORK_INFRASTRUCTURE InfrastructureMode;
> > +	__le32 InfrastructureMode;
> >  	u8 SupportedRates[NDIS_802_11_LENGTH_RATES_EX];
> >  	__le32 IELength;
> >  	u8 IEs[0];
>=20
> This suggests that the values in the enum need to be explicitly
> defined, does it not?

Yeah, well, it is probably understood that those values are from
hardware. We don't always explicitly define them even when they are
defined elsewhere since afaik C guarantees starting at 0 and increasing
order.

johannes

--=-k3WOuRtTtywEqGHtMFT9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR71EbKVg1VMiehFYAQISSg//QHoeNUKSmVaAGFXSJw+ZTz+ajcuywRDD
80oB9m2k9C1wj3MtBLQAjHMQSDaFLzDI6d4gYBOndBT1RTa/L0yvOTCAcMZTnJlR
gvjZSTGKaR+H3pnsNNXqkhfG3XU4u2n3T2AganfujiJMblN+hn4C4N1yNKyFL9+F
R6f4toHX24RDAibsufWx6Osc3bcoO/7nbrFnwsPiQnkM4iaLNpLgU5wViGCZKtii
88HTq0zsN4XNAgMqQU5ibTY9NGkpsrGK14a7M/wn+mDBfk/kYO9HGvyOYzJm2vBn
P5FrrXh3b63rwHpVU4qwA/vDAlYQB7Q/tero7eEOkRlw6+RTZYTzigsW00CpbKGc
cVAi+BKU8lUZKbElfwUFomdt5NAW4Ia/YbumrrCK0CAbTX1vviRTkeSZ99e8dryh
h9j/wJC2Z1uSRGAcfE+26L3s8Vjcdk0b0KPhWpXEZWRNswuqg7c/Fi4LqT2oVsza
PBso4RYlacaiv/L+eOEQvyCud2NkOwFBdOzMoWzU/4OCQL4G7HRp7AxWWu2z0HUJ
I/uhSp5YQQagDP3I9kq707yMmPZK3+t0m62q9VIg9qNiyBugVyobTTZ/QrikSXUl
MpF/j0r91PRQPtay1rOg1Q8WZpTOChyBejcvYucRfT7ELFBtv6qJmHz9hfpdX5HS
b75ByVHzC6c=
=JH0+
-----END PGP SIGNATURE-----

--=-k3WOuRtTtywEqGHtMFT9--

