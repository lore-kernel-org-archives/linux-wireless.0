Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbXHaXjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 19:39:19 -0400
Subject: Re: [PATCH 2/3] mac80211: revamp key handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708311503.35568.mb@bu3sch.de>
References: <20070821155725.489738000@sipsolutions.net>
	 <20070821160001.763985000@sipsolutions.net>
	 <1188517504.7585.17.camel@johannes.berg>  <200708311503.35568.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jXiPXQwTyD+Jl4OQlTh7"
Date: Sat, 01 Sep 2007 01:40:32 +0200
Message-Id: <1188603632.7585.91.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jXiPXQwTyD+Jl4OQlTh7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-31 at 15:03 +0200, Michael Buesch wrote:

> I am sorry. I introduced this as I didn't understand my own weird code an=
ymore. :)
> I think I'll fix this by using the hw_key_idx.

Well, I made it buggy :)

I noticed another thing: The code there sets the "default keys valid"
bit depending on WEP or not, while the v3 specs may say that it's a
weird thing to do. I suggest setting the "default keys valid" bit in STA
mode when group keys are configured and clearing it in AP mode; that
way, in AP mode, the four group key slots can also be used for the
transmit-only keys that have zeroed MAC addresses.

johannes

--=-jXiPXQwTyD+Jl4OQlTh7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2Kbw/ETPhpq3jKURAiEZAJ0dp36nyoKxbM/ijLzgW8Lr2oZ4QwCffJVn
jksyCURP7EIklpuCctovzwE=
=MLaV
-----END PGP SIGNATURE-----

--=-jXiPXQwTyD+Jl4OQlTh7--

