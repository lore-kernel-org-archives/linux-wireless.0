Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964AbXCALaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 06:30:17 -0500
Subject: Re: [PATCH] allow wiphy renaming
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Greg KH <greg@kroah.com>
In-Reply-To: <1172672119.5015.11.camel@johannes.berg>
References: <1172672119.5015.11.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pfF90A2VyDsO7NRn1AJ0"
Date: Thu, 01 Mar 2007 12:29:52 +0100
Message-Id: <1172748592.11911.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pfF90A2VyDsO7NRn1AJ0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 15:15 +0100, Johannes Berg wrote:
> This patch enables userspace to rename 802.11 PHYs via nl80211. It adds
> the first multicast group and notifies it of these renames as well.

> Tested and works :)

Well, I forgot to test the corner cases. The patch is somewhat broken.

> +	/* prohibit calling the thing phy%d when %d is not its number */
> +	sscanf(newname, PHY_NAME "%n", &idx, &taken);
> +	if (taken =3D=3D strlen(newname) && idx !=3D rdev->idx)
> +		return -EINVAL;

sscanf has a bug that makes this use case not work. If it worked
correctly, this would also disallow things like 'phy007' when the index
is not 7.

The whole point in disallowing something other than the own number was
to simplify code in other places so I don't have to check for used
numbers when assigning new ones. Any comments on the whole thing? I
kinda fear that if I go through with this someone will show up who
really desperately needs to call something phy7 when it has index 22 and
I will be held responsible ;)

OTOH, this may be an incentive to not use phy* for stable names to begin
with, avoiding the problem we see with netdevs and people continually
complaining about unstable names...

johannes

--=-pfF90A2VyDsO7NRn1AJ0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5rkw/ETPhpq3jKURAtHaAJ9Sse4mgPgE2l6T4cQzSThrX5gAKwCfVofg
4um3AEDmlsWTc0gTuJbppz8=
=jjxo
-----END PGP SIGNATURE-----

--=-pfF90A2VyDsO7NRn1AJ0--

