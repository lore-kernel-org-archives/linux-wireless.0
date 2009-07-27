Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZG0IsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 04:48:03 -0400
Subject: Re: Possible BUG where mac80211 fails to stop queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A6CDE26.3000409@lwfinger.net>
References: <4A6CDE26.3000409@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ox7vs8NXl/8sBa+NRUW0"
Date: Mon, 27 Jul 2009 10:48:00 +0200
Message-Id: <1248684480.19945.45.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ox7vs8NXl/8sBa+NRUW0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-07-26 at 17:52 -0500, Larry Finger wrote:
> While stress testing the newest version of the open-source firmware
> for BCM43XX devices with the latest pull of wireless-testing, I ran
> into a problem of DMA TX queue overrun. Initially I thought this was
> due to the firmware change; however, I got the same error with the
> standard firmware. I have not seen this before, but it may not be a
> regression as it seems to occur only under special circumstances.

I've also seen it under extreme stress on Intel hardware, cf.
http://thread.gmane.org/gmane.linux.kernel.wireless.general/36497

> The critical code is in b43_dma_tx(), which is called by the .tx
> callback routine registered with mac80211.
>=20
> After the fragment is transmitted by a call to dma_tx_fragment() at
> line 1353, the routine checks to see if there are sufficient free
> slots (2) to transmit another fragment using the code below:
>=20
>         if ((free_slots(ring) < TX_SLOTS_PER_FRAME) ||
>             should_inject_overflow(ring)) {
>                 /* This TX ring is full. */
>                 ieee80211_stop_queue(dev->wl->hw,
> 				skb_get_queue_mapping(skb));
>                 ring->stopped =3D 1;
>                 if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
>                         b43dbg(dev->wl, "Stopped TX ring %d\n",
> 			       ring->index);
>                 }
>         }
>=20
>=20
> The problem shows up at line 1340 for the next fragment:
>=20
>        B43_WARN_ON(ring->stopped);
>=20
>         if (unlikely(free_slots(ring) < TX_SLOTS_PER_FRAME)) {
>                 b43warn(dev->wl, "DMA queue overflow\n");
>                 err =3D -ENOSPC;
>                 goto out_unlock;
>         }
>=20
> The system generates the warning for ring->stopped and prints the "DMA
> queue overflow" message.

Right. Exactly the same behaviour as I'm seeing on Intel hardware.

> My understanding is that mac80211 serializes the calls for each TX
> queue, and that the TX callback should not have been entered for this
> case.
>=20
> If I am not understanding the way that mac80211 works, please correct
> me. I would also appreciate any suggestions for further debugging.

I stared at the mac80211 code for a long time and concluded that it was
a race condition and couldn't really be fixed, see my analysis in the
iwlwifi patch. I'd love to be proved wrong though.

Are you seeing this multiple times? I don't think you have fragmentation
on, do you? At least I didn't and still saw the problem, which seemed a
bit strange, but I really couldn't see any other way for it to happen.

johannes

--=-Ox7vs8NXl/8sBa+NRUW0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbWm8AAoJEODzc/N7+QmaAewQAJrgRT0ypvZQS4D5c88rKaZH
zypghxfEyPAhDWgV6KCSRuUC9ACq6dPyKgAMTlYoHciO0pXyXCB4GQTDZVP4gG7m
QTqxHnQn6XRDoIDgxjiC7ddLJCRycr/vKf32sBX7HLvSI+RDkH5AK0RuDcVyEjMr
KBpaS5+7j8awSJBneLYq/juG5T83tEFTMPJRaOFMyqbUqjmkOpviTXn0Rxxe/m1V
wOMz+ors+3/L2EjiWnAG3ADnu8GxAaaJE2j1S63AO7AFMs05+aXZxOqXP5X8sUDT
iuA+gYS8nQ2rowYqCF+5Ba1uzVdPJOs0kfM9GMbjK3zQxUqMo301/sSmVUMU8oP6
JHzVdu6O3t3t+KnP2r+C0vwbrGSWN7elppcApnuLriIx5zCeqSBGKS+qIZc5Hk0R
Hl+ACgZRhc3N98rPgRrp9Su8I2nkY7YDybvbnviXhbM6qbetLB2uJuYM2O4XKVNE
DQxMYXyBACou4QVhj6A2l6FSSw2esFgQeY8bduVAWjU77av/mHbLiu2YBYp6i625
MujKEzIuRyQouR1gCH6RooKqWNuRRf2fe+fHQPre+csNnfHx6oHrdVtcXRTzVA+X
b1bVRLNXkDwDI4lZ8Zr3pL+04jeolG3C+lZXpV7PhEY3SlVgRRxStNNq4Zbz633l
jsMFLrAc5IAodpi0RWkK
=FMF5
-----END PGP SIGNATURE-----

--=-Ox7vs8NXl/8sBa+NRUW0--

