Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbYE2IeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:34:14 -0400
Subject: Re: question about ...: wrong count at exit"
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1ba2fa240805290107r2c3b68cbh4bf18e86c9f96335@mail.gmail.com> (sfid-20080529_100723_276189_896310A7)
References: <200805290937.22146.hs4233@mail.mn-solutions.de>
	 <1212047361.16917.6.camel@johannes.berg>
	 <1ba2fa240805290107r2c3b68cbh4bf18e86c9f96335@mail.gmail.com>
	 (sfid-20080529_100723_276189_896310A7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZF77AW6J62bGApLbFSu8"
Date: Thu, 29 May 2008 10:33:07 +0200
Message-Id: <1212049987.16917.23.camel@johannes.berg> (sfid-20080529_103424_231719_C5708594)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZF77AW6J62bGApLbFSu8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> However, the function looks quite innocent, and I cannot see
> >> any imbalance there. Did I oversee something or is that a
> >> problem of sparse?
> >
> >>         spin_lock_irq(&priv->driver_lock);
> >>         priv->infra_open =3D 0;
> >>         netif_stop_queue(dev);
> >>         spin_unlock_irq(&priv->driver_lock);
> >
> > I think it's a sparse problem caused by my patch, I sent further patche=
s
> > to fix it but they were never applied (and had a slight remaining
> > problem too). If you look at the pre-processed function it should becom=
e
> > obvious.
> >
>=20
> I got plenty of this in the mac80211 reported with newest sparse, but
> they looks false caused by 'goto statements'

Probably similar issues. I have patches that haven't been applied and
with those, mac80211 is clean except for a new warning from netdevice.h,
one that I'll send a patch for in a minute, and the rc-pid algo one.

johannes

--=-ZF77AW6J62bGApLbFSu8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD5qQqVg1VMiehFYAQIkDg//WXHDJ6Uh6TidJI5mKy/3jEa5Yrv9X6C6
lj19AstXhSYINbfPELDF0Lq2w6hDijM+pZRc/uQoAfiqKqwXto0CbzeFBkF+dj4P
LmOryYW/2DTxFlD7sDSzMIrt4G0Oly3EqfiIwo8qlvc3ZYMTXw0UWDnhZgmxD6pl
0Z/cG7IDKYow285zB5o+am0Uun96xFStbJVBqAlGQaN9zrOb1tUql3njK90lIa9d
a9lyXrZdiIGLfBWH+EhDdkA5QiRhMlREV40aKzw8BlIUNtJDDN+jEOrkn0IQog8b
Zw3FsODIKRQ4n4iU/5BWbn+7/TrGL7TZtQ+ubbD2shNJnG2aoPuLadUwrdgZV4aN
7C79tYBFo6OwHK4h62Dancv82u6Fsh+4EVnSZJg9xrcEBfzVE27g1nb+N65qPEoT
AYI011u3pkqlBitDC5LbjMIHTSF1jruyZKUQQOApRfMO183/4fombIH3UdEIaPTv
nDIx27DM5Zoilt5XsTcHcA76psjFf9YQw06JPsEViecNjiRsh37XODRDW4h4jDOF
dTy8kCLSRW1hgtXDuuAs1LceNEn3I9c2ZjxaFoMnOLhz6y9Z/5JBTA5+54cxkHdk
npvQrPQ4/fM3crCeqBRm3gfwYRbGF23QHxSe8s00J7qVMiXSLo6NpfpSAMV1jdI+
1cHQSc+ac+c=
=wIAW
-----END PGP SIGNATURE-----

--=-ZF77AW6J62bGApLbFSu8--

