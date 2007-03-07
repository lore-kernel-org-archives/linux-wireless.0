Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422948AbXCGRvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 12:51:39 -0500
Subject: Re: Crash in cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200703061907.19929.mb@bu3sch.de>
References: <200703061907.19929.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TElGauBwXfohUHQZStfl"
Date: Wed, 07 Mar 2007 18:51:27 +0100
Message-Id: <1173289887.9108.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TElGauBwXfohUHQZStfl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-06 at 19:07 +0100, Michael Buesch wrote:
> BUG: unable to handle kernel paging request at virtual address
> 00100104

Apparently the notifier was called twice and on the second time around
the device had been removed from the list already (0x00100100 is
LIST_POISON1.)

I'll look into it and post a patch later.

johannes

--=-TElGauBwXfohUHQZStfl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7vue/ETPhpq3jKURAoERAKCTtTCaEI78AnS6DXaoLATXx/NABACfYzJf
S3+rddRGMG79k4kiFrFtxFY=
=72NH
-----END PGP SIGNATURE-----

--=-TElGauBwXfohUHQZStfl--

