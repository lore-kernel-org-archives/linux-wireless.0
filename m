Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbYDAMCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:02:34 -0400
Subject: Re: [PATCH] mac80211: fix deadlocks in debugfs_netdev.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	linville@tuxdriver.com
In-Reply-To: <47f18973.1498600a.3eb4.ffffbefb@mx.google.com> (sfid-20080401_020142_502048_1A55C83F)
References: <47f18973.1498600a.3eb4.ffffbefb@mx.google.com>
	 (sfid-20080401_020142_502048_1A55C83F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BiREdqUA67avcUBQ14dw"
Date: Tue, 01 Apr 2008 14:02:30 +0200
Message-Id: <1207051350.5143.56.camel@johannes.berg> (sfid-20080401_130237_362232_6F4BF7D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BiREdqUA67avcUBQ14dw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-31 at 15:10 -0700, Luis Carlos Cobo wrote:
> The bug shows up with CONFIG_PREEMPT enabled. Pointed out by Andrew Morto=
n.

> @@ -51,13 +53,13 @@ static ssize_t ieee80211_if_write(
> =20
>  	memset(buf, 0x00, sizeof(buf));
>  	buf_size =3D min(count, (sizeof(buf)-1));
> -	read_lock(&dev_base_lock);
>  	if (copy_from_user(buf, userbuf, buf_size))

Do we actually still need all this ieee80211_if_write code? It seems
that nl80211 can fully replace it now.

johannes

--=-BiREdqUA67avcUBQ14dw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/IkVaVg1VMiehFYAQJZ/g//eyIM4iQ7x3gwjmOlrsBQDFDMWQy26YZr
Hipddm7jQeUrZLdHwY42BbT3WJC6AMuoE2z0lGEqLIWS5I/RfyF3zON5/pe8ad9n
HyiBqdBPocd/cbTC9k0lu0DlgjuNAMnFV13wz7rjqpQaIYHTaWMgPSLIgwNK+2U9
DlQ1w41Z6YQlqUwo0Yg9jhmmCadTht/ihh4RZJrl7usoCrNihrik61PHCNLo026X
WyUbpLFfBq5LU65H0kxC5hCmXfUvMc79EvnLEYbTPD4VXfViyM6+Sedc+wnDqPho
HfNjUWWta6R0y0Ovtp7+7IXNPsYzZi9Zm+q3wydRzJQRIwFjtKJkCbaW166ZP8sa
LNvCps/QPLINU7NtX5la/PzVWvQe0kdTCF9exBdhlrlvgzkRflV0lbtXApzIHUWi
mmtLAr9lpk6vE2RiFVAAEWe2nRshU4nNfJVXpkXA1PIRp4l6uxNcymcPe+hg5DBb
XkIyGB15qzAhi5vsi3tpznDri2prIqX9p41jetxMArc72yOTNbEbmc4TknUCS3l8
iWF9EYdli8e6EupsH9vEbGOzeaaRO/bsJ90w1QZxKS8BGgq27rPvS+p1fgGIRk7C
0rKX0yKQOXUZb1P7dm0kpI4n/dG150pxnjsPUmV9+gDp2NPjv4SicvCjZvAz3Ns8
UlziQ4enJDQ=
=iAwB
-----END PGP SIGNATURE-----

--=-BiREdqUA67avcUBQ14dw--

