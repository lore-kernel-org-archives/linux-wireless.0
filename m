Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbYKET7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 14:59:33 -0500
Subject: Re: [PATCH 5/7] cfg80211: expect different rd in cfg80211 when
	intersecting
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890811051155q3cf0a16exa0911675d86959ae@mail.gmail.com> (sfid-20081105_205524_966915_1FB112C2)
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225886489.3619.84.camel@johannes.berg>
	 <43e72e890811051155q3cf0a16exa0911675d86959ae@mail.gmail.com>
	 (sfid-20081105_205524_966915_1FB112C2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xBPOkcfw/v8WO0oDhgof"
Date: Wed, 05 Nov 2008 20:59:33 +0100
Message-Id: <1225915173.3619.161.camel@johannes.berg> (sfid-20081105_205938_520057_E3553354)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xBPOkcfw/v8WO0oDhgof
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 11:55 -0800, Luis R. Rodriguez wrote:

> >>       /* This would make this whole thing pointless */
> >> -     BUG_ON(rd !=3D cfg80211_regdomain);
> >> +     if (!last_request->intersect)
> >> +             BUG_ON(rd !=3D cfg80211_regdomain);
> >>
> >>       /* update all wiphys now with the new established regulatory dom=
ain */
> >>       update_all_wiphy_regulatory(last_request->initiator);
> >>
> >> -     print_regdomain(rd);
> >> +     print_regdomain(cfg80211_regdomain);
> >
> > Maybe the printing here should be removed? It seems confusing now.
>=20
> Well IMHO its correct to print it here as *this* is after its been set
> and passed through all wiphys. ACK?

Ah, hmm, rd is intersected before this, right? I think I just got
confused with the code flow, yeah, seems fine.

johannes

--=-xBPOkcfw/v8WO0oDhgof
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEfsiAAoJEKVg1VMiehFYYb0P/jsqfkRnzQU8kKUxA6xKWs6L
xFNDBJZMwjkABldaE6QiL8NRnyHiIcyEMx6i7pkLWP5hTv7saunhZ1ds+B3mPkO9
zOBmzkccgikPA51689ws7YtXbVrPoUCyvZ80kIwmm9raoDLOQY8ozKg51ZRA4aWe
+fDBsdNhTBtZNK10OHSg0UjwpoEPo7VKYXRisdwrF8V1EpGJtS/JdNspZTGUd4ee
4BfM9F6y3DsJe8F1CmM5MXhnJNN67AMo7N4r54PyDpcl4oSi2y7Q6cVKE6e1BG+j
8PKty8CdfIs2sbZ4IYc1WeeveUZQbhqmMn4MLyKGQ8hDYBQw82w+bmbPY0Dkx6ey
3deev6BNs5qC9ZGbA0TSDE2+C6ORgtdg6b3p4hPgeGFr5swxjPa67fbmkNOsU4N2
R6PDXnwkQP8jUT45x1qMyBM5vnwn9MTSZ+SGgzJiVhFwEAgS/yTbKLENd/2O2vNe
Mf8IfTSq2ozu+eFsnEX4s+eW9/22FsFr1DmuDa4WSAovF+z5bKT4bEx0P2uS8VVP
lEeEZjK6J+ftcasjjOt1GqctEZ8uSAG62BShw/xVCnDrjisgNbsowHpyWYg6kQtf
oS7qPHYcpB/ZmTiJ+R6qIlqXBk/6JNn6bKplrDro9KVyYMoeqHMBasv9rZHiB23T
L5W4aZibgin3bzKY6RAZ
=Hep9
-----END PGP SIGNATURE-----

--=-xBPOkcfw/v8WO0oDhgof--

