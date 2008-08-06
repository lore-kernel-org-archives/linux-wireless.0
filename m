Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851AbYHFOHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 10:07:46 -0400
Subject: Re: [ath5k-devel] ath5k hang up in mesh mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: YanBo <dreamfly281@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <b6c5339f0808060656v771a00dar51054236bc4ec50b@mail.gmail.com> (sfid-20080806_155653_719297_81EA5A80)
References: <1197ff4c0808060056q7e10e39cl41a5ea5a26b7cdd6@mail.gmail.com>
	 <b6c5339f0808060656v771a00dar51054236bc4ec50b@mail.gmail.com>
	 (sfid-20080806_155653_719297_81EA5A80)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oRgHFCT1KAyaPj1C2mda"
Date: Wed, 06 Aug 2008 16:00:18 +0200
Message-Id: <1218031218.23048.4.camel@johannes.berg> (sfid-20080806_160808_627241_20CB9C7A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oRgHFCT1KAyaPj1C2mda
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > [  577.639420] Mesh plink with 00:19:e0:86:0f:2f ESTABLISHED
> > [  602.864544] BUG: sleeping function called from invalid context at
> > mm/slab.c:3043
> > [  602.869975] in_atomic():1, irqs_disabled():0
> > [  602.874241] INFO: lockdep is turned off.
> > [  602.878162] Pid: 5160, comm: ath5k_pci Not tainted
> > 2.6.27-rc1-wl-14922-gb73da91 #4
> > [  602.885719]  [<c0172e5f>] kmem_cache_alloc+0xef/0x110
> > [  602.890794]  [<c04e9908>] mesh_path_add+0xb8/0x2f0
> > [  602.895610]  [<c04e9908>] mesh_path_add+0xb8/0x2f0
> > [  602.900468]  [<c04eb8c6>] hwmp_route_info_get+0x406/0x4c0
> > [  602.905886]  [<c04eb4e5>] hwmp_route_info_get+0x25/0x4c0
> > [  602.911927]  [<c04eb9f4>] mesh_rx_path_sel_frame+0x74/0x870
> > [  602.917257]  [<c04d76dd>] ieee80211_rx_bss_info+0x67d/0xe80
> > [  602.922846]  [<c04d70dc>] ieee80211_rx_bss_info+0x7c/0xe80
> > [  602.928353]  [<c04d9d40>] ieee80211_rx_mgmt_action+0x180/0x8a0
>=20
> I guess mesh_path_add should be using GFP_ATOMIC instead of GFP_KERNEL, s=
ince
> it's called under rcu_read_lock?  CCed Johannes.

Looks like it, but I don't really know. OTOH, we really could make all
that RX business non-atomic. Oh well, not now.

johannes

--=-oRgHFCT1KAyaPj1C2mda
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIma5vAAoJEKVg1VMiehFYEa4P/Rnjx3OrAw0PAbATsPHu9sF3
+KS+P1amP491SYsxKvg36cu2LNE+ilRBxSqw1JO+qc2DgEJ5IYw9mY/v6SRXzy4o
ZZFlCqM+DDE12u5i6z+iebGYMPXIMoT4SHggQnN7HLgSgmbUdd6SlMFM6C1EtaBj
sD89x653lqw9Vz2FUnzyCYV5yMHFja/RzDIfBZ3wWMAm+nAvD7iALcypbkLnfej/
7Xki6CGhVXXs40RsAtaU7UhQ7+w6WyA5Jp6VERlzGuKakClWVF+gDV/fgRTvlkme
VrbmRwshU3vS5h4HaaGKWfDPa4QahidaVBWxtkN1n37LiHoyYEH+fSLSVBNov9+N
ybB7TKMM+gD9A8CzNxk6ksrfmkScRUiSfIxBt9Fxxae6jJbeDbXsAtqpSPWBjg85
9kuXkV4PCau1rLo90kxRSYpsIgZMHHzTK0yjd+W0gouOPvpeDEbzpIgpISqE4GRb
nnnmGkvDE/raDgKtI1dmXoycEs/4Nl2AzJv2Q30PjGKrkyCgyBlncfgucZes5epo
I8Odayp5S++JRYi9DyQmMAtMNdsuu5cWjFl6bqjy3nSJbJ56QqaplmC7V8nQYJzi
U3GHwwgXbEhoEyHp9S7rY7aBX0sRBsD2NPmLpzdzpwmvydV1R58PGdvQZdkPWabc
p7DbSb/X1y71+1VXDr/+
=52n1
-----END PGP SIGNATURE-----

--=-oRgHFCT1KAyaPj1C2mda--

