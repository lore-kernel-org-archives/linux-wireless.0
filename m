Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbYE3TDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 15:03:44 -0400
Subject: Re: [PATCH] p54: fix skb->cb tx info conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>
In-Reply-To: <20080530161511.GA24013@tuxdriver.com>
References: <1211813099.4843.12.camel@johannes.berg>
	 <20080530161511.GA24013@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CO0c51517G9mbrW2deOO"
Date: Fri, 30 May 2008 21:03:39 +0200
Message-Id: <1212174219.7238.3.camel@johannes.berg> (sfid-20080530_210348_563484_6905F87B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CO0c51517G9mbrW2deOO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> > +				ni =3D IEEE80211_SKB_CB(entry->next);
> > +				freed =3D ((void *)ni->driver_data)->start_addr
> > +						- last_addr;
> > +			} else
> >  				freed =3D priv->rx_end - last_addr;
> > =20
> >  			last_addr =3D range->end_addr;
>=20
>   CC [M]  drivers/net/wireless/p54/p54common.o
> drivers/net/wireless/p54/p54common.c: In function =E2=80=98p54_rx_frame_s=
ent=E2=80=99:
> drivers/net/wireless/p54/p54common.c:406: warning: dereferencing =E2=80=
=98void *=E2=80=99 pointer
> drivers/net/wireless/p54/p54common.c:406: error: request for member =E2=
=80=98start_addr=E2=80=99 in something not a structure or union
>=20
> Looks like you are missing a (struct memrecord *) for the freed
> assignment...?

Umm, yes, this can't work. I wonder what I did, I sure have compiled
this kernel. Must have backed out the patch accidentally. Sorry, will
follow up with a fixed one.

johannes

--=-CO0c51517G9mbrW2deOO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEBPiqVg1VMiehFYAQKWng/+MhvsfTlONLHMmpdZor9+Ehv7xTlInwlT
PO8v4lAV2A0PlWUseS4bvfH9yjvysQrwrzyuie02H7+erEAK6mk6/2lxFD3lToxG
rNsULRPUgOla/yHN6cjmc4RaMjL9FweiE05M4olfbUig7dybcT3iCNKm0B/KNzdz
/WzTVDDIWhU+FmpYgxrVhyBIEW72uw986wyIjRO1DaikrWT1LRXYn7vu8gJ9sch8
zjJeYqtbb6F7+oHhBkv4C3vO+mygVE4EJoakbKxqULy5TxllfF/HL4c5fcUg0dby
Bmmo/xcJ67SINxa2sPgC12rBmUfibi8lAjiTY0JWgDgrDwKV55r8GDHYjkR9lAgV
6JHRsa0TrXlysMBUs6uU1IRM9RTPSkVyxOOE/bjz8iiRAG493IvG67qtY15GO8wI
0sDG5ha6z+w1je5FxFiHvZ/u4luZo927Cgk9fMMnh2JuDBtRcLhir1UuR1v5jEcS
5+rsO2yiIjxfe/DAQ8wpDYtA4s7ED4XAdkToB+b8+2cMB6+ibwuMzPlsdWzKtzJo
mapNQM4qO1yqxUgNtyDnDLODZgyMbexFvztqM7Bx/WwoAMZDy7UGr2txiMKEvlP5
YBxRV5NHiujQN+/DytDB9KsOvQcZ+wXV7rW9VHWc38x6Uz5N27i+JIEbPfz5/Hbo
PUc89VbAGyo=
=BFDj
-----END PGP SIGNATURE-----

--=-CO0c51517G9mbrW2deOO--

