Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:15165 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753806AbXIWWdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2007 18:33:05 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: scanning implementation and sta matching
Date: Sun, 23 Sep 2007 18:31:59 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1190330446.18521.120.camel@johannes.berg>
In-Reply-To: <1190330446.18521.120.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1293199.64HUCbzzHf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709231832.05498.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1293199.64HUCbzzHf
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 20 September 2007 19:20, Johannes Berg wrote:
> In any case, this is how I broke scanning, we know nothing about the
> stations we're scanning so the frames are directed to no interface.
I still don't see how you broke scanning, at least in sta/ibss mode. As far=
 as=20
I can tell, it's working fine here because you haven't removed any of the=20
scanning special cases which relax the rx filtering and direct probe=20
responses and beacons straight to the MLME during scanning. (see the=20
misleadingly named ieee80211_rx_h_passive_scan rx handler function)

Of course, this is with the pending-mac80211 series in mac80211-misc. Did y=
ou=20
break scanning in some other patches?

=2DMichael Wu

--nextPart1293199.64HUCbzzHf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG9ullT3Oqt9AH4aERAlTyAKDYtyE/AmSU12ekrtiCAg6Naxab8gCg0Xmx
LNqdNogf07HUupQgV5KN+rs=
=ezWF
-----END PGP SIGNATURE-----

--nextPart1293199.64HUCbzzHf--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
