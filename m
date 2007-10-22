Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway.drzeus.cx ([85.8.24.16]:48216 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbXJVRFi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 13:05:38 -0400
Date: Mon, 22 Oct 2007 19:05:32 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: make if_sdio align packets
Message-ID: <20071022190532.5077ce3d@poseidon.drzeus.cx> (sfid-20071022_180541_012397_9EB49925)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-25574-1193072701-0001-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-25574-1193072701-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Incoming packets have to be aligned or the IP stack becomes upset.
Make sure to shift them two bytes to achieve this.

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
---

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless=
/libertas/if_sdio.c
index 5b13705..56dd568 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -175,12 +175,20 @@ static int if_sdio_handle_data(struct if_sdio_card *c=
ard,
 		goto out;
 	}
=20
-	skb =3D dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE);
+	skb =3D dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + NET_IP_ALIGN);
 	if (!skb) {
 		ret =3D -ENOMEM;
 		goto out;
 	}
=20
+	/*
+	 * The IP stack is littered with silly assumptions on alignment,
+	 * so we need to do a bit of layering violation here and make
+	 * assumptions about the size of the headers between us and the
+	 * IP stack.
+	 */
+	skb_reserve(skb, NET_IP_ALIGN);
+
 	data =3D skb_put(skb, size);
=20
 	memcpy(data, buffer, size);

--=_hera.drzeus.cx-25574-1193072701-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHHNhc7b8eESbyJLgRAkD3AKCJxw2E0gwxjybZ6fIx55Ar7yjcZwCdHYXD
M31OoAywKB6TuIUzPnh6TII=
=VdJc
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-25574-1193072701-0001-2--
