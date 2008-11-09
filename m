Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60320 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbYKII42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 03:56:28 -0500
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
In-Reply-To: <491653A6.20705@hotmail.com>
References: <4902DEBB.3050205@hotmail.com>
	 <20081025112147.GA12252@Chamillionaire.breakpoint.cc>
	 <200810251325.07916.mb@bu3sch.de>
	 <20081025112813.GC12252@Chamillionaire.breakpoint.cc>
	 <49033782.5040701@hotmail.com>  <491589ED.4090904@hotmail.com>
	 <1226149894.3610.8.camel@johannes.berg>  <491653A6.20705@hotmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TKRINHvO0gDbQvrv1jEI"
Date: Sun, 09 Nov 2008 09:56:31 +0100
Message-Id: <1226220992.3614.16.camel@johannes.berg> (sfid-20081109_095632_336911_F61525F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TKRINHvO0gDbQvrv1jEI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,


> So, looking into this problem, I was able to come up with a patch=20
> (attached. Note, it also includes remnants of the patch recommended by=20
> Sebastian Andrzej Siewior in=20
> http://marc.info/?l=3Dlinux-wireless&m=3D122493409906326&w=3D2). The prob=
lem=20
> occurs within compare_ether_addr() and this immediately reminded me that=20
> the patches recommended to me way back last year=20
> (http://marc.info/?l=3Dlinux-wireless&m=3D119543627712471&w=3D2) also dea=
lt=20
> with this problem.

I think you forgot to attach the patch.

> Looking into how it was solved then, all the compare_ether_addr() calls=20
> were replaced with memcmp() calls. This is what I have done with my=20
> patch as well... but this approach did not fill me with confidence. It=20
> seemed to me like a quick fix that didn't directly address the alignment=20
> problem. And IMO my subsequent findings confirm this.
>=20
> I now hit the following kernel errors:
>=20
>  > [  240.139093] Kernel unaligned access at TPC[100f7f44]
>  > sta_info_get+0x24/0x68 [mac80211]
>  > [  240.233255] Kernel unaligned access at TPC[100f7f48]
>  > sta_info_get+0x28/0x68 [mac80211]
>  > [  240.328015] Kernel unaligned access at TPC[100f7f50]
>  > sta_info_get+0x30/0x68 [mac80211]
>  > [  240.422771] Kernel unaligned access at TPC[100f7f44]
>  > sta_info_get+0x24/0x68 [mac80211]
>  > [  240.517554] Kernel unaligned access at TPC[100f7f48]
>  > sta_info_get+0x28/0x68 [mac80211]
>=20
> Looking into this, and the underlying problem is again=20
> compare_ether_addr(). Now, I'm sure that replacing this with a memcmp()=20
> is now treading on more toes than just zd1211rw users. And for this=20
> reason, I think a better solution is going to be required.
>=20
> Does that sound right? I will persist in trying to understand the code=20
> to try and come up with a fix. But obviously, I hope that I can get help=20
> with this to make the former an education exercise, not a kernel=20
> maintenance exercise.

:)
Yes, I think you're right, it appears that the 802.11 header isn't
aligned on a 2-byte boundary, which is extremely strange. Can you, with
your patch applied, do something like

	printk(KERN_DEBUG "%p\n", skb->data);

before this code in zd_mac.c:

        memcpy(skb_put(skb, length), buffer, length);

        ieee80211_rx_irqsafe(hw, skb, &stats);


johannes

--=-TKRINHvO0gDbQvrv1jEI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFqW8AAoJEKVg1VMiehFYEAMP/ikGKbnRIf/hBNTWFNQW4tO7
BxeJEYLst3bMo0FVlCTH5j8pNM+bvjgZ1VnSNwVarPVH1MEMzl3rw5TkuT2wZuWc
HlRcRFE51dqN/CX3/iqTRIDLSdTBY/V6dlWkmmWNdM9/2KuNNWIc0CmNvGtjtaqO
y7izayIGvxkG2rlTdGAOygTZC0PX0Od/GGBgbXE1PdW1o+jrjDhtN0QO7qnbf8fV
pRWPZiWJGN2NpRZIYyoWiGKjHZuHwvHnIKOMwOIhpxIp0ArobOf+DuaPyH3neP7N
2gkGi5PC1xUKzXF6HR6jq502QJ3/8NSZI9Pl+laXMiekjlnc3qMfJcN1RGkoQ3NF
DTAsm+XmdVy4brmZZLG/8hjZSG9mUjiZEBO3zLchQ1T59TGEO86dcvuoX947o9XF
9xhdi6xrAEFmA7v8Mrx9XOulbPArlr3Zw5Somr8p553RSawbmWeN+x4RRI3lSzOq
kb1B8AVGpdEcYPa2FDveazulyQscUl1WSZT2n9o2d3YLEqrVY7hnXBl0yT3Ou4oW
gbsnYnS4UdBgo4FzEpgxuqWmotVhDBTJbTNSkfAnORxH6irTXiaNlrqeE6WdY8wk
OK1BjlLzKZnqqqc1reM97XRrkXULYPSL5fuMNYb0QLHja/tybGof3Yu2XYtSpXwV
qWKxAY2oti0GxA+YhN/0
=6Nef
-----END PGP SIGNATURE-----

--=-TKRINHvO0gDbQvrv1jEI--

