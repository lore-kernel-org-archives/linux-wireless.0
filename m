Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbXLSPsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:48:21 -0500
Subject: usefulness of 802.1X control?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iUEA5fE6sTMQZUHPStYv"
Date: Wed, 19 Dec 2007 16:10:13 +0100
Message-Id: <1198077014.4747.7.camel@johannes.berg> (sfid-20071219_154831_424109_EDCF7658)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iUEA5fE6sTMQZUHPStYv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

After a bit of rework in my patches, we only have two places left where
we use the 802.1X flag:

tx.c:
        if (unlikely(sdata->ieee802_1x_pac &&
                     !(sta_flags & WLAN_STA_AUTHORIZED) &&
		[...]

rx.c:
        if (unlikely(rx->sdata->ieee802_1x_pac &&
                     (!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED)))=
) {
		[...]

That has me wondering if the control is actually useful. Instead of
checking this flag, we could simply require that hostapd sets the
WLAN_STA_AUTHORIZED flag on all stations if 802.1X is disabled. Do you
(or anyone else) see any problem with this?

We would of course have to set the WLAN_STA_AUTHORIZED flag on all
stations we add from within mac80211, i.e. the AP we're associating to,
other IBSS stations and the WDS peer, but that's trivial.

johannes

--=-iUEA5fE6sTMQZUHPStYv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2k0VKVg1VMiehFYAQKhjxAAvEhCp94Lhwu/JlNwEwfIPV5P0N9FfKYE
GRl62hS6XmMXdstV3nOA7pLmyyto0pY2BIaZ3UA8csvBUn1sRpwI7Tlwk7XpSteV
OW/WifsMpj0eYlI7pGKwnwK+xEksBib/ku0wOWKw4Oy7NnmgzD2qeKIy0dIxwnF+
UXevMrU6YiRfecIboqdUQ+sCHHe6PKF7LBMY3jsONkfUP9VgUL1folgnbdBPPb2k
GWWZoXP2mHVG6iQuDF2199Mw79nVfO35WCoO1CN/s8I7bHZ0RltZB6vcA4MeuiQw
JRT3ksvLDZD0IR4BSx+yCevGPaQ889GLbqDKG3vN3jZLSEu2fkzOW5Q0EP/CZx7H
yCMNZrEaugswmntGazYKIAPiAoySTPPM8B/Shmc/IIjSp9JBlOba5MzuloQmUSPM
7DsavR2Srih+kCkLZ9dwuC1hAf8qP0cCNPkAwfNFPeowzyhYdYPe+GAn5Glrs03z
9molgJb3n/2LGw7SJ4JLYj/Ngg0avbhUREKlRSFbr2A7pcHlsJMu58BgEDc/K+Be
Nsw30ohg9+nMmjAn+GnVWTDwUYuQcpyYx7MIF/igInVEV4DvhZWKUfJ0RjejUdHj
2XvIai5NYV6ZmzEHmUcbNUjA/iMOAMJCg/LyXhrHLeCO76rOeP14RfosL1tfaYsy
Gvu4453/YMQ=
=OSJM
-----END PGP SIGNATURE-----

--=-iUEA5fE6sTMQZUHPStYv--

