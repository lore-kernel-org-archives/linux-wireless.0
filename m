Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965390AbXIGNYs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 09:24:48 -0400
Subject: Re: [PATCH net-2.6.24] cfg80211: use idr layer for wiphy indizes
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1188480704.2963.41.camel@johannes.berg>
References: <1188480704.2963.41.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1MdhsD7e72dkOYcj6/xl"
Date: Thu, 06 Sep 2007 19:56:56 +0200
Message-Id: <1189101416.28781.115.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1MdhsD7e72dkOYcj6/xl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-30 at 15:31 +0200, Johannes Berg wrote:
> This makes cfg80211 use the idr layer instead of keeping
> an own list of registered devices.

Hmm. Come to think of it, this is not good as it makes us reuse the
wiphy numbers. Normally that would be fine, however, here it would
probably be nicer for tools to know that a specific wiphy no longer
exists when they have an old index.

Please don't apply. I'll make a new patch to still keep a list but
introduce the walking helper.

johannes

--=-1MdhsD7e72dkOYcj6/xl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4D9o/ETPhpq3jKURAofeAJ0YgfQtZBSUn8rUlXwskpEKK7sPqACcDray
sGJCKzlTmTywwGI51j7NkO0=
=aCWl
-----END PGP SIGNATURE-----

--=-1MdhsD7e72dkOYcj6/xl--

