Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35347 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbXLWHn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 02:43:29 -0500
Subject: Re: [RFC PATCH 7/7] mac80211: fix sta_info locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071223050844.4e6b8c13@morte>
References: <20071223033633.710907923@polimi.it>
	 <20071223050844.4e6b8c13@morte>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bCb4HM6QxpI5izITjp+K"
Date: Sun, 23 Dec 2007 08:38:56 +0100
Message-Id: <1198395536.6630.13.camel@johannes.berg> (sfid-20071223_074335_459396_0CFECD6D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bCb4HM6QxpI5izITjp+K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> EIP at delay_tsc+0x22/0x50
> [couldn't read the EBX and such, but I guess you won't care]

It'd be good to know actually, along with disassembly.

> So I guessed that locking was lacking somewhere. The following patch fixe=
s
> the issue for me, but I'm not sure at all that it's the right fix. Thanks=
.

Definitely not. If you look at the code in question, it has nothing at
all that needs locking. It's not accessing any shared structures at all.

johannes

--=-bCb4HM6QxpI5izITjp+K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR24Qj6Vg1VMiehFYAQJgfRAArR1z60G1Odkw4+odlvMB5h7rXr/cHWWr
KHUxsm2tl5IP2oplIUvgm48rYhrK0n/cWgF+x8yxKj1gwbDVSCvReuyrd3nm6kRW
+m9TxaZzTtAhNKjlOCcTe1UEBMTqSNTIBI6udMhyiY2kKuVGBSorW4t9E0EUxQZ3
1lO1yEJUcMUhTNzwb3umQL7wLfZEg0lzEVzhV4ioXYTCTbrLIVoBAP+6Tjoz8rig
ErR6Nqv2tejW44pAQ+uayQqlouE786j+kNW1n7ZaOMqWIWdbmqRp5IZnKiPop46/
7ed0L+MGHiUWiEpft47o9i9h7QuWiSETltxaay3k0PA699RsfUqTnY+G2uMskKXD
UQjpPzZDLX5py9yDtf0cR5ctKgjqnL97K4GIbnF2IAbcR5Dn6VYq/+5Lm4qfEwWj
Y0z2ZQ2076On7aPnJ/1ynB3OjATYWdMQhq/KAF4rjCYk9dSCQgBlfb4FW2PfTl+q
dwgLmkBL+X2GN6vnAsDln1q17xrNdl4GvDu07LIjhlQiwjZOYk8shrQ4DKIrYCxb
vFcTkEo9xC4gLw4mlXtfeR7VF5M0oyhbwl339Ss8uxaAdJn4soyWS/z+McIBuWKS
ZsU/3yKpJiblNGLjjgXkDgZjtlgFtsbv+q0PZGg2wQmfXQkOqVXFZ50sH09W2J9p
cAf8xWul61c=
=HW/W
-----END PGP SIGNATURE-----

--=-bCb4HM6QxpI5izITjp+K--

