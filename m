Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50572 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310Ab0G0XPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 19:15:39 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, stable@kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100727224008.GM14257@kroah.com>
References: <1275904827-6598-1-git-send-email-sgruszka@redhat.com>
	 <20100727224008.GM14257@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f8iDNbW2LSvRkGhLhSxW"
Date: Wed, 28 Jul 2010 00:15:25 +0100
Message-ID: <1280272525.13192.67.camel@localhost>
Mime-Version: 1.0
Subject: Re: [stable] [PATCH 1/4 2.6.33.y] mac80211: explicitly
 disable/enable QoS
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f8iDNbW2LSvRkGhLhSxW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-07-27 at 15:40 -0700, Greg KH wrote:
> On Mon, Jun 07, 2010 at 12:00:24PM +0200, Stanislaw Gruszka wrote:
> > commit e1b3ec1a2a336c328c336cfa5485a5f0484cc90d upstream.
> >=20
> > Add interface to disable/enable QoS (aka WMM or WME). Currently drivers
> > enable it explicitly when ->conf_tx method is called, and newer disable=
.
> > Disabling is needed for some APs, which do not support QoS, such
> > we should send QoS frames to them.
>=20
> Why is this a patch for a -stable tree?  It looks like it adds a new api
> for a new feature, right?
[...]

It extends the interface between the 802.11 stack and drivers so that
drivers can avoid sending QoS frames to APs that don't support them.
There is no new interface to userland.  My understanding is that iwlwifi
becomes unable to communicate with non-QoS-capable APs after having once
associated with a QoS-capable AP, without this and the following change
in iwlwifi itself.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-f8iDNbW2LSvRkGhLhSxW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATE9oh+e/yOyVhhEJAQJ1Vg/+KmWNPePvkTb/uq2sPqcOuZWSKSjP5khl
woVUVMnQ4my3XgMn4+zNQpJ5MoIiGAmESVXke2sxmc2UBZdLi/Z1KC6go2MunJ/9
RPcBPmJNy9KiYd7Yz5Vh6zqJAbd6nVW8ArN+nHRslLgmazG5SgWZbmXOgiZBEX0N
iRrcQoRUfiW5bcSXoUtcbVBidM3vMTrRc1S52A12zclYucIaAjDSThOZunkWnIoW
pD40AFNIb67zGfzIwzLbZSQmlVB4UWIQraUIkbkQYjei5hdw38GIsIYW6EbKQpwa
Q7m/L3VWm80nGdFZ385kBQ7fd5m9uUg4b28LadNkZ1n86FRk82d4yo0XlRBaaVfC
sCHIOIx+Uyw1CUL9gftj2bvDHvOBAMtoFIu5jZqlXelQpRke+ANP0Ldq9A9hPgR6
6LrH70JsCE9rsDTpfA8bi/eSPoNpxR1X8x4dwqNjuNkIVfMrS5OYZEvNBqJJ0ibo
5mnrWgaRw3k+Uj1tdqPQkYFHfl+Y4tH0RM6Cs+NzpqRWs5ET/LnJnW9iKvgMVQ7u
CI/BtcqignfOaVM6H+j0YtnGNDRxdUZ3EFjytEL+8FvAgrb0P9gkGBnlzH8IR2Sp
yln9FVqNyQn+kE6n0RQr/f64ZidtFVb0a8ZYYNoYFjxjj90x6jdn/pHUeFV4RiJc
hUWCPfC4YyI=
=cIHf
-----END PGP SIGNATURE-----

--=-f8iDNbW2LSvRkGhLhSxW--
