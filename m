Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbXH3M4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 08:56:08 -0400
Subject: [FYI] b43 vulnerable to CCMP replay attacks
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Buesch <mb@bu3sch.de>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GLnu+dLsBqIaynHSRrlW"
Date: Thu, 30 Aug 2007 14:57:16 +0200
Message-Id: <1188478636.2963.26.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GLnu+dLsBqIaynHSRrlW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

b43 contains the following code (with - because I copied it from a patch
I have that removes it):

-                       if (skb->data[wlhdr_len + 3] & (1 << 5)) {
-                               /* The Ext-IV Bit is set in the "KeyID"
-                                * octet of the IV.
-                                */
-                               iv_len =3D 8;
-                               icv_len =3D 8;
-                       } else {
-                               iv_len =3D 4;
-                               icv_len =3D 4;
-                       }
-                       if (unlikely(skb->len < (wlhdr_len + iv_len + icv_l=
en))) {
-                               b43dbg(dev->wl,
-                                      "RX: Packet size underrun (4)\n");
-                               goto drop;
-                       }
-                       /* Remove the IV */
-                       memmove(skb->data + iv_len, skb->data, wlhdr_len);
-                       skb_pull(skb, iv_len);
-                       /* Remove the ICV */
-                       skb_trim(skb, skb->len - icv_len);

This means that it is vulnerable to CCMP replay attacks when hardware
crypto is used because the hardware doesn't verify the CCMP PN and
mac80211 cannot.

The patch quoted above fixes this but does a bunch of changes in
mac80211 too and needs to get some review. I hope we can get to that
before 2.6.24 so that b43 can finally go mainline.

johannes

--=-GLnu+dLsBqIaynHSRrlW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1r6s/ETPhpq3jKURAiEvAKCdEws5ys+MZApB3JoWvUCp6JPqAgCeLjAE
uKPpYNoSs9R86pkmYNc0snY=
=f6oq
-----END PGP SIGNATURE-----

--=-GLnu+dLsBqIaynHSRrlW--

