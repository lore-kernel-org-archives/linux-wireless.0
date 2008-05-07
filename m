Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811AbYEGTRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 15:17:46 -0400
Subject: Re: b43 doing tx-status reports with NULL frames?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200805071500.32033.mb@bu3sch.de> (sfid-20080507_150018_586767_9F2BD6EE)
References: <1210158511.5642.1.camel@johannes.berg>
	 <200805071500.32033.mb@bu3sch.de> (sfid-20080507_150018_586767_9F2BD6EE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zTV3BIBjXpC8UDdQqhgR"
Date: Wed, 07 May 2008 21:17:05 +0200
Message-Id: <1210187825.5642.25.camel@johannes.berg> (sfid-20080507_211713_151613_EF77E765)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zTV3BIBjXpC8UDdQqhgR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > That WARN_ON is:
> >=20
> >         if (WARN_ON(!skb))
> >                 return;
> >=20
> > This was with dma overflow injection and a few patches, but nothing
> > relevant inside b43.
>=20
> hm, this is interesting.
>=20
> Is it this one?
> 1379                 if (meta->is_last_fragment) {
> 1380                         B43_WARN_ON(!meta->skb);

Uh, yes. I had added one in mac80211 (see above) because it crashed for
me at that place once, but that one triggered as well:


May  7 13:04:02 johannes kernel: [  847.811168] Badness at drivers/net/wire=
less/b43/dma.c:1380
May  7 13:04:02 johannes kernel: [  847.811174] NIP: f2530de4 LR: f2530dc8 =
CTR: f252ff70
May  7 13:04:02 johannes kernel: [  847.811182] REGS: d191bb20 TRAP: 0700  =
 Not tainted  (2.6.25-wl-06933-g0bacadf-dirty)
May  7 13:04:02 johannes kernel: [  847.811188] MSR: 00021032 <ME,IR,DR>  C=
R: 48242484  XER: 00000000
May  7 13:04:02 johannes kernel: [  847.811205] TASK =3D d1918000[5078] 'wp=
a_supplicant' THREAD: d191a000
May  7 13:04:02 johannes kernel: [  847.811211] GPR00: 00000001 d191bbd0 d1=
918000 edb89248 00000208 d191bbd8 00000000 000003cc=20
May  7 13:04:02 johannes kernel: [  847.811230] GPR08: 00000001 00000000 00=
010004 edb89200 48242488 10083d28 100e0000 100876e9=20
May  7 13:04:02 johannes kernel: [  847.811249] GPR16: 100876d9 100876b1 22=
042442 0000008a 00000002 1006071c ed88703c 00000000=20
May  7 13:04:02 johannes kernel: [  847.811268] GPR24: d191bbd8 f2537d24 ee=
513120 d191bc28 00000001 0000029e 00000041 ed887000=20
May  7 13:04:02 johannes kernel: [  847.811288] NIP [f2530de4] b43_dma_hand=
le_txstatus+0xd4/0x2e8 [b43]
May  7 13:04:02 johannes kernel: [  847.811336] LR [f2530dc8] b43_dma_handl=
e_txstatus+0xb8/0x2e8 [b43]


> The "is_last_fragment" actually means "is last s/g fragment".
> (not 802.11 fragment).

Right, I know :)

> So basically this assertion checks the presence of the skb buffer
> for each s/g fragment. We use two s/g fragments for each TX packet.
> One for the header and one for the skb. You already know that.
> So, for the first s/g fragment we have meta->skb=3DNULL and for the
> second meta->skb!=3DNULL.
> I'm not sure why this assertion triggers. I can't see where in the TX pat=
h
> the allocation of the slots or the meta->skb assignment can go wrong.
> Allocation basically always allocates the ring descriptors in pairs.
> Either both or none (in case of a DMA error, but _not_ an overflow).
> The ring suspend (or suspend injection) basically is independent from
> the allocation.
>=20
> Can you add the following assertion into b43_dma_tx() after the
> b43_dma_tx_fragment call, please?
>=20
> WARN_ON(free_slots(ring) & 1);
>=20
> This shouldn't ever trigger, as we always allocate the slots in pairs.

I don't even know if I can reproduce this, sorry. Also, if I can, with
my patch to put things into skb->cb it'll all just crash...

johannes

--=-zTV3BIBjXpC8UDdQqhgR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCIAL6Vg1VMiehFYAQKtWQ//fmlSz5sv3CytJRQYgo0zkK/j0+0lKjvM
GQn5adye8Pp8bRXbFuPDjrK075XJcb7D1iI8SOCI70OZEpBVyQvpmsKhtksVyL36
U6sw7uwejMxmy9/h5jBMQjbJ1GSjbPgail+FxhPyKzonB3+Q+zg18Mcy4nSelgTP
0VgWDizsLQ3j0Wg1IAkH86P1QuUwbiKJHKEie+lfuYpAl4SxD+lFX+VxNnASUa7N
7H3npms2OlsbRG3teskOK9kTTLhkrsYdyejQJOlA1UGQksNVZntAcYj1lutZ/GDc
dtm5ZbB3xLjdIWdM4h7RigFvniMSTdUIluS7fHgkgFMXFvYisD31PYBHoAER4Cbk
evEWY97B02+yuWyApRxFbavY+PKOskawC7YlgxhfjNiNaytdOyjJufNSrbY3hlOK
bQ3OKl79Iuq5cqtLhIoUfXlXXpp6fu1wXgVoP/bLeUF45v8fF8HjvKW9tfWYl5jI
mqeWLHP2oY62DVwHc8elS9KalxVkYhoqW2IHkqJu/hfQI015FjNTMAY9tLCmfNHj
V1i4vM6/S45gBdDH0sbW7xEPSqrhlCWIHS4dfQkf2yba3B8p8PueNzgcmzvCdijg
q1lgZuAT/QipTC152UmEo330eyKEiLIRC4/70w5rgaVlK/v0Wl9BgbVUfrOxI6T/
QS+RRrQV9qw=
=Tc/A
-----END PGP SIGNATURE-----

--=-zTV3BIBjXpC8UDdQqhgR--

