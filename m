Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZGGBGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 21:06:19 -0400
Subject: Re: [PATCH] Fix regression in mesh forwarding path.
From: Johannes Berg <johannes@sipsolutions.net>
To: javier@cozybit.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <1246927941-27148-1-git-send-email-javier@cozybit.com>
References: <1246927662-25461-1-git-send-email-javier@cozybit.com>
	 <1246927941-27148-1-git-send-email-javier@cozybit.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GtCDeI4JodrdfdN2QLW/"
Date: Tue, 07 Jul 2009 03:06:20 +0200
Message-Id: <1246928780.4652.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GtCDeI4JodrdfdN2QLW/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-06 at 17:52 -0700, javier@cozybit.com wrote:
> From: Javier Cardona <javier@cozybit.com>
>=20
> The removal of the master netdev broke the mesh forwarding path.  This pa=
tch
> fixes it by using the new internal 'pending' queue.

Sorry, never tested mesh recently.

> As a result of this change, mesh forwarding no longer does the inefficien=
t
> 802.11 -> 802.3 -> 802.11 conversion that was done before.

That sounds good!

>  	while ((skb =3D skb_dequeue(&mpath->frame_queue)) &&
> -			(mpath->flags & MESH_PATH_ACTIVE))
> -		dev_queue_xmit(skb);
> +			(mpath->flags & MESH_PATH_ACTIVE)) {
> +		ieee80211_select_queue(mpath->sdata->local, skb);
> +		ieee80211_add_pending_skb(mpath->sdata->local, skb);
> +	}

That does a lot of locking operations -- can you not select the queue
earlier, and use ieee80211_add_pending_skbs?

johannes

--=-GtCDeI4JodrdfdN2QLW/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKUp+JAAoJEODzc/N7+QmahNsQALIPH4/4Sbxb+I5QGvyq1zYe
XUcXUf0w+qO1Ba7Rf4hFFv+Jf3iembMO2n00EkIj4a2nAKe9qOMeY27dJoDLRsOc
i4AfLV+La8hh5cp4aCUtRl4xCO26j2b/QbHzNoTT2FHfNvsc28zf6R7iJIVW8tjZ
5Mzgl36zJuiLl7S4KcMA0/lmCGySql+ZgTinkWaBhvz3uQDTlqPSYhruTehAlFAP
PvNOZ5QuiTBvN/EjFyeQNxArxNO71NhKWwGf7/lA66dpMCTysaYTJQfkwjcRp2d0
ga5YI8izRbCfbe6VZvWPTV65QkNATpNK1BzDPn8sojDpvDnQTnXTNWkABL/i37Zv
wGIy+sCgw2EtM6VFDzVjG4stjU2zAfh0mDQ6+le8OWIoJAHZynv7xLnb6ob46ZxN
fr/OMjbKETX2ybdmOXhaeaQykKwCrtjzeH79E3RUbOiob8vszDBcOAzIVYsEzxVt
D47zClPuuMvb4+FVEU0QlF2sWr6KlLsOi6dv4rbLegOcXEO0cRRk79SmERmp/wqn
qFNpmQgDfIazI6nGlido4RI3ETzio+tkn7fCzC92n+41VAhL0Ir1SyA53LU+v4JZ
xLGCXUI8mqVphiky9Ox6zese/coUv11U9y9COUL0fObkiVi5oM7hiyfxEwl1+OtC
xRNkuUW1aDc9/GDaH5ZU
=m1A3
-----END PGP SIGNATURE-----

--=-GtCDeI4JodrdfdN2QLW/--

