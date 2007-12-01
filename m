Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:27555 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755907AbXLABxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 20:53:18 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: don't use if_id, use if_priv
Date: Fri, 30 Nov 2007 20:59:19 -0500
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1196423301.6058.187.camel@johannes.berg>
In-Reply-To: <1196423301.6058.187.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2243303.nA2TFVrn1F";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711302059.23415.flamingice@sourmilk.net> (sfid-20071201_015322_437195_B2223F1F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2243303.nA2TFVrn1F
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 30 November 2007 06:48:21 Johannes Berg wrote:
> Here's a non-functioning (except for b43/b43legacy) patch that gets rid
> of the if_id stuff all over in favour of a new if_priv pointer.
>
Note that a good chunk of the if_id stuff in the api was just brain damage=
=20
from the ERP info changes. Anywhere we have access to a skb, we have access=
=20
to a netdev, and we don't need an extra if_id argument to tell us what we=20
need to know. I would love to see that get fixed first as that simplifies a=
ll=20
drivers.

Having said that, a per-interface private area for drivers is a great idea =
if=20
drivers need it. They probably do.

=2DMichael Wu



--nextPart2243303.nA2TFVrn1F
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHUL/7T3Oqt9AH4aERAtNhAKDRaiGFVU1hBsgvMAixFg8AoFK+mQCeO8pS
IB9naCUXYiAlc9+HQUg2Jug=
=YfqB
-----END PGP SIGNATURE-----

--nextPart2243303.nA2TFVrn1F--
