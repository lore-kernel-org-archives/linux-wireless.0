Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54770 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0APVHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2010 16:07:10 -0500
Subject: Re: [PATCH] cfg80211/mac80211: Add TX/RX commands for Action frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100113113000.GA20835@jm.kir.nu>
References: <20100113101126.GA12548@jm.kir.nu>
	 <1263377951.5093.326.camel@johannes.local>
	 <20100113113000.GA20835@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZH15dikC9ahJBRmrI3LR"
Date: Sat, 16 Jan 2010 22:06:59 +0100
Message-ID: <1263676020.14317.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZH15dikC9ahJBRmrI3LR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-13 at 13:30 +0200, Jouni Malinen wrote:

> One problem with the registration mechanism is that it may not be
> obvious at this point what exactly we want to export into user space
> in
> the future and what gets handled inside the kernel. One obvious place
> would be to do register to process all Action frames of a specific
> category, but that may not be enough since it is possible that some
> categories will be handled both in kernel and in applications.
>=20
> The mechanism for specifying which Action frames are handled will
> likely
> need to be quite extensible.. This would require at least one
> attribute
> for specifying the Category value. Then based on the Category value,
> we
> may need to be able to specify the Action Value as an option
> attribute.
> In addition, the vendor specific Action and Public Action fields would
> need to get OUI as another optional attribute. With vendor specific
> values, we may even need yet another optional attribute to specify the
> subtype of the vendor specific information since some protocols may be
> handled in kernel and some in applications (i.e., more than one
> application for the same vendor OUI).

Ok let me recap what we have
 1) regular action frames -- by category and maybe action subclass
 2) vendor action frames -- category + OUI + vendor-specific stuff
 3) public action (this is a category, can't find a vendor-subclass?)

In all these cases, it would appear to be very easy to handle by just
using the first N bytes. Case 1) would have 1 or two bytes, case 2)
would be 4 or more bytes and case 3) seems like it could be done with 2
or more bytes ...

I've gone ahead and implemented that, will follow up with patches once I
give them some basic testing.

johannes

--=-ZH15dikC9ahJBRmrI3LR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLUipvAAoJEODzc/N7+QmaZrsQAJaMF5h4oipR0pfl5EAjZipc
5RiM837e6bVgd9elNL3SHBVVpebUgWCnHr1BAgelPrgB5KpJa8WuFixUHOMed5k8
BVTrmJecelW+O5k8NrL29gWnRLe6yvnP2tvDFmbW4NVvsXqR4SHJVKGddoIldtBg
EDI3EX59k/++NKcL5xh5SlyEW0cQWurUquRCJAxivfaNj+9xYehDaYX3GymYZzqd
GKseM0/DtMvYyfNijAjRiISxDAPxLIO8ocgZYRBT5T8ZyUSD7yjUIMKj97300GkK
uJwpV9X7Ft4qA5xYZGNUzXTWpCGnXwavTRJc56KiPBIiTnY6Ht+DfpNF8orK6ee8
B2QBay+MsSu4yXiMs9TURVZOalFW9YylycO1B5wO4HgPYdKiF4x2akeqWGHHt6bG
bfLB98ztrMRqBqLeg+qluDuXNvEyapgcJKEvGHaHR1e2N65//DZRvJsQYeZIZ4vQ
MpPh0qERjrPTlgb/evvX7wZHDNJWDpiEKB9umb6cYLiYktlhDlZN/JfXRcBONN8O
+SenCCH2n+fVrB2A61dtz26/u06CHXc7zd2rFQvPRiZGVOya+eItmmMKkXyu3XkT
3jcZNzmzXjWDCgtlDAEPuIEhGFGeijUpj9YrBHmEuozdy0t+N7vOMY79mcNFq/74
Mw1tddAW8NbDLHSGzct0
=7CcM
-----END PGP SIGNATURE-----

--=-ZH15dikC9ahJBRmrI3LR--

