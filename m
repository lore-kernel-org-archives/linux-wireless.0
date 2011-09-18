Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s2.udvp.de ([188.40.48.165]:46966 "EHLO s2.udvp.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255Ab1IRVfy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 17:35:54 -0400
Received: from [192.168.0.30] (agsb-5d8517b0.pool.mediaWays.net [93.133.23.176])
	by s2.udvp.de (Postfix) with ESMTPA id 1BE3E28C083
	for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 23:36:02 +0200 (CEST)
Message-ID: <4E766435.3010707@somakoma.de> (sfid-20110918_233557_795372_CECCB971)
Date: Sun, 18 Sep 2011 23:35:49 +0200
From: Manuel Munz <freifunk@somakoma.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: No beacons in ad-hoc mode with b43
References: <4E751496.30903@somakoma.de>
In-Reply-To: <4E751496.30903@somakoma.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig123CA4002C3880B12A9840ED"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig123CA4002C3880B12A9840ED
Content-Type: multipart/mixed;
 boundary="------------080309060705040601050303"

This is a multi-part message in MIME format.
--------------080309060705040601050303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17.09.2011 23:43, Manuel Munz wrote:
> Hi,
>=20
> i want to use b43 on older broadcom wireless routers with openwrt, but
> there seems to be a problem: The router doesn't send beacons in adhoc
> mode (verified with wireshark), which means users can't see the network=

> in a network scan. So is there a problem in the adhoc implementation
> with b43? Could someone please have a look at this? It is preventing us=

> from using b43 in our mesh for too long now.
>=20

Hi,

after trying various things i came up with the following patch which
seems to address the issue for me.

regards, Manuel




--------------080309060705040601050303
Content-Type: text/x-patch;
 name="820-b43-fix-beacons.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="820-b43-fix-beacons.patch"

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1616,7 +1616,8 @@ static void handle_irq_beacon(struct b43
 	u32 cmd, beacon0_valid, beacon1_valid;
=20
 	if (!b43_is_mode(wl, NL80211_IFTYPE_AP) &&
-	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
+	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT) &&
+	    !b43_is_mode(wl, NL80211_IFTYPE_ADHOC))
 		return;
=20
 	/* This is the bottom half of the asynchronous beacon update. */

--------------080309060705040601050303--

--------------enig123CA4002C3880B12A9840ED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk52ZDUACgkQ+zov67K9xz53owCePM86ThlnYQMZ8/GOmKg5H8Rd
G7gAn1z8rss53CMBdhHCbGRbwJhpxApG
=m/J6
-----END PGP SIGNATURE-----

--------------enig123CA4002C3880B12A9840ED--
