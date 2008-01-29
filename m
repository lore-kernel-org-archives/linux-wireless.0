Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42109 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbYA2Rqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 12:46:47 -0500
Subject: Re: [PATCH] use is_valid_ether_addr() macro in wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Helge Deller <deller@gmx.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200801262238.18719.deller@gmx.de> (sfid-20080126_213919_942850_5B9C718A)
References: <200801262238.18719.deller@gmx.de>
	 (sfid-20080126_213919_942850_5B9C718A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Appmit1DEkqbIS/NU86/"
Date: Tue, 29 Jan 2008 17:29:35 +0100
Message-Id: <1201624175.4394.54.camel@johannes.berg> (sfid-20080129_174652_902934_23712EFE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Appmit1DEkqbIS/NU86/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-01-26 at 22:38 +0100, Helge Deller wrote:
> use is_valid_ether_addr() macro instead of hand-coded checks for=20
> valid IP address.

Ahem. IP addresses? In any case, this patch is totally bogus, these are
not checks for invalid MAC addresses but rather a check for the special
any/off addresses. Please read the iwconfig man page.

> -	else if (!memcmp(any, awrq->sa_data, ETH_ALEN) ||
> -	         !memcmp(off, awrq->sa_data, ETH_ALEN)) {
> +	else if (!is_valid_ether_addr(awrq->sa_data)) {

NACK anyway. These adresses ("any", "off") are actually special for
wext, this has nothing to do whether they are invalid or not.

> > > -   if (!memcmp(bcast, wrqu->ap_addr.sa_data, ETH_ALEN)) {
> > > +   if (!is_valid_ether_addr(wrqu->ap_addr.sa_data)) {
> > >             /* FIXME: rescan? */
> > >     } else
> > >             memcpy(this->bssid, wrqu->ap_addr.sa_data, ETH_ALEN);
> >=20
> > This is a semantical change.
> > If the original code is correct, this should be
> is_broadcast_ether_addr()
>=20
> Yes, but the original code is probably wrong.
> So I think my patch fixes a bug here as well.

Not at all. Yes, it is unfortunate that drivers have to have this
knowledge about wext internals, but that's how wext is designed.

johannes

--=-Appmit1DEkqbIS/NU86/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR59UbqVg1VMiehFYAQLF0A/+NwR8As3VdyHcRFqeDR2EDtYLVbhJ++we
qcK2TivrVAYqon5E6W+5cSeMiUGWNwFBZYRRAZkotCyOXA99K/BlHyBDaXWhZ1UT
xMr4Zj4TRKygsWcokAR9n4U3cWFNEnbD9oKxXhWqaa9hy4oZzRGe+/RxHt1w56V2
e4jIRcEUckiXousQBPw4nZsNHTYCfs+GF3OWq3MRC4I3wU7eCWStN6PoZreeyGn7
PsGOdy1QwgCfu0N1gXPF94FwBOTqqprwUJ7peg71c47Z/LeCepSGnishy5YwtRzE
wxneuPlFp+AS9W+1COyP4x+0GYOnpYRW8Njqo2WMgoJz+41J228qgRa4elSYJkzf
1SVTY8PPlQmmXB29XEswGJwvD9oOhsosqWT5d+qB/N9udgV9PnZog2nRjwS27qNl
XlR1GPI1ygk/S8qZLxSmsCq3pKsUSAVd+1Hl+gxeoUx1eyaSdpZSsQmHTSHz3Qm7
06PcSXkaAfJYBi0xYQV4qCEVWXKRrf9VpiJSGz03iaMJrLy+1EvcWJVNnyOPd6OS
zkCRqA2MmxZb0kWMIMyF8MiYl44MH9GJa4aoXmtP0w4Q+O0UB/5lnHodOzqKoEDl
EcfV3hcrSsG3Xqjn2NZLKP7T8hCCpaTBY8lp+4S2stgMnhQE6eErwK1p9/ocFYAd
cW1Oq8KcZBE=
=hQbk
-----END PGP SIGNATURE-----

--=-Appmit1DEkqbIS/NU86/--

