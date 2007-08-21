Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920AbXHUKee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 06:34:34 -0400
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, jbenc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <200708202121.35543.linux@baker-net.org.uk>
References: <200708082324.17186.linux@baker-net.org.uk>
	 <200708162243.05809.linux@baker-net.org.uk>
	 <1187345617.23489.143.camel@johannes.berg>
	 <200708202121.35543.linux@baker-net.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JmBf7/AYbavgtgMLT3SR"
Date: Tue, 21 Aug 2007 12:34:45 +0200
Message-Id: <1187692485.4288.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JmBf7/AYbavgtgMLT3SR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> One is in ieee80211_if_set_type at the only point where I can see u.ap.ps=
_bc_buf could get
> initialised and as I suspected that doesn't get called.
>         case IEEE80211_IF_TYPE_AP:
>                 sdata->u.ap.dtim_period =3D 2;
>                 sdata->u.ap.force_unicast_rateidx =3D -1;
>                 sdata->u.ap.max_ratectrl_rateidx =3D -1;
>                 skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
>                 printk( KERN_DEBUG "Initiatilsing ps_bc_buf at %p\n",&sda=
ta->u.ap.ps_bc_buf);
>                 sdata->bss =3D &sdata->u.ap;
>                 break;

> The other is in ieee80211_tx_h_multicast_ps_buf just before tx->sdata->bs=
s->ps_bc_buf gets
> used. I haven't quite followed what ap structure bss should be pointing t=
o at that time but I'm
> presuming whatever it is doesn't contain an initialised ps_bc_buf hence t=
he lock failure.
>=20
>                 printk( KERN_INFO "About to queue skb %p to buffer %p\n",=
tx->skb, &tx->sdata->bss->ps_bc_buf);
>                 skb_queue_tail(&tx->sdata->bss->ps_bc_buf, tx->skb);

At that point, sdata->bss should point to the master device, which
apparently hasn't been initialised yet. The device initialisation code
is pretty black magic to me, Jiri/Michael?

johannes

--=-JmBf7/AYbavgtgMLT3SR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyr/F/ETPhpq3jKURAv3kAJwMZaNlODQ0+YIyX7BzljTjwMxz/QCfRs8L
ZQpzTWvEl/dBtPwimiL/q9c=
=kb51
-----END PGP SIGNATURE-----

--=-JmBf7/AYbavgtgMLT3SR--

