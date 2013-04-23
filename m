Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:52132 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab3DWUeS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 16:34:18 -0400
Date: Tue, 23 Apr 2013 22:33:47 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: linville@tuxdriver.com
Cc: Thommy Jakobsson <thommyj@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry.Finger@lwfinger.net
Subject: [PATCH] b43: rename stop-index DMA op
Message-ID: <20130423223347.4007fc5f@milhouse> (sfid-20130423_235839_779438_396B502E)
In-Reply-To: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mA+U1mX6VGG.DoCzC3NDLNc"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/mA+U1mX6VGG.DoCzC3NDLNc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Rename the stop-index-write DMA operation to set_rx_stop_slot().

Signed-off-by: Michael Buesch <m@bues.ch>

---

This patch depends on:
"B43: Handle DMA RX descriptor underrun"


Index: wireless-testing/drivers/net/wireless/b43/dma.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2013-04-23 21:50:4=
7.655004059 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2013-04-23 21:51:24.132=
064549 +0200
@@ -156,9 +156,9 @@
 	return (val / sizeof(struct b43_dmadesc32));
 }
=20
-static void op32_set_current_rxslot(struct b43_dmaring *ring, int slot)
+static void op32_set_rx_stop_slot(struct b43_dmaring *ring, int slot)
 {
-	b43_dma_write(ring, B43_DMA32_RXINDEX,
+	b43_dma_write(ring, B43_DMA32_RXSTOPINDEX,
 		      (u32) (slot * sizeof(struct b43_dmadesc32)));
 }
=20
@@ -169,7 +169,7 @@
 	.tx_suspend =3D op32_tx_suspend,
 	.tx_resume =3D op32_tx_resume,
 	.get_current_rxslot =3D op32_get_current_rxslot,
-	.set_current_rxslot =3D op32_set_current_rxslot,
+	.set_rx_stop_slot =3D op32_set_rx_stop_slot,
 };
=20
 /* 64bit DMA ops. */
@@ -251,9 +251,9 @@
 	return (val / sizeof(struct b43_dmadesc64));
 }
=20
-static void op64_set_current_rxslot(struct b43_dmaring *ring, int slot)
+static void op64_set_rx_stop_slot(struct b43_dmaring *ring, int slot)
 {
-	b43_dma_write(ring, B43_DMA64_RXINDEX,
+	b43_dma_write(ring, B43_DMA64_RXSTOPINDEX,
 		      (u32) (slot * sizeof(struct b43_dmadesc64)));
 }
=20
@@ -264,7 +264,7 @@
 	.tx_suspend =3D op64_tx_suspend,
 	.tx_resume =3D op64_tx_resume,
 	.get_current_rxslot =3D op64_get_current_rxslot,
-	.set_current_rxslot =3D op64_set_current_rxslot,
+	.set_rx_stop_slot =3D op64_set_rx_stop_slot,
 };
=20
 static inline int free_slots(struct b43_dmaring *ring)
@@ -743,7 +743,7 @@
 			b43_dma_write(ring, B43_DMA64_RXCTL, value);
 			b43_dma_write(ring, B43_DMA64_RXRINGLO, addrlo);
 			b43_dma_write(ring, B43_DMA64_RXRINGHI, addrhi);
-			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
+			b43_dma_write(ring, B43_DMA64_RXSTOPINDEX, ring->nr_slots *
 				      sizeof(struct b43_dmadesc64));
 		} else {
 			u32 ringbase =3D (u32) (ring->dmabase);
@@ -758,7 +758,7 @@
 				value |=3D B43_DMA32_RXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA32_RXCTL, value);
 			b43_dma_write(ring, B43_DMA32_RXRING, addrlo);
-			b43_dma_write(ring, B43_DMA32_RXINDEX, ring->nr_slots *
+			b43_dma_write(ring, B43_DMA32_RXSTOPINDEX, ring->nr_slots *
 				      sizeof(struct b43_dmadesc32));
 		}
 	}
@@ -1749,7 +1749,7 @@
 	*/
 	current_slot =3D ring->ops->get_current_rxslot(ring);
 	previous_slot =3D prev_slot(ring, current_slot);
-	ring->ops->set_current_rxslot(ring, previous_slot);
+	ring->ops->set_rx_stop_slot(ring, previous_slot);
 }
=20
 void b43_dma_rx(struct b43_dmaring *ring)
@@ -1768,7 +1768,7 @@
 		update_max_used_slots(ring, ++used_slots);
 	}
 	wmb();
-	ops->set_current_rxslot(ring, slot);
+	ops->set_rx_stop_slot(ring, slot);
 	ring->current_slot =3D slot;
 }
=20
Index: wireless-testing/drivers/net/wireless/b43/dma.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/b43/dma.h	2013-04-23 21:50:4=
7.655004059 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.h	2013-04-23 21:50:47.635=
003479 +0200
@@ -49,7 +49,7 @@
 #define		B43_DMA32_RXADDREXT_MASK		0x00030000
 #define		B43_DMA32_RXADDREXT_SHIFT		16
 #define B43_DMA32_RXRING				0x14
-#define B43_DMA32_RXINDEX				0x18
+#define B43_DMA32_RXSTOPINDEX				0x18
 #define B43_DMA32_RXSTATUS				0x1C
 #define		B43_DMA32_RXDPTR			0x00000FFF
 #define		B43_DMA32_RXSTATE			0x0000F000
@@ -117,7 +117,7 @@
 #define		B43_DMA64_RXPARITYDISABLE		0x00000800
 #define		B43_DMA64_RXADDREXT_MASK		0x00030000
 #define		B43_DMA64_RXADDREXT_SHIFT		16
-#define B43_DMA64_RXINDEX				0x24
+#define B43_DMA64_RXSTOPINDEX				0x24
 #define B43_DMA64_RXRINGLO				0x28
 #define B43_DMA64_RXRINGHI				0x2C
 #define B43_DMA64_RXSTATUS				0x30
@@ -207,7 +207,7 @@
 	void (*tx_suspend) (struct b43_dmaring * ring);
 	void (*tx_resume) (struct b43_dmaring * ring);
 	int (*get_current_rxslot) (struct b43_dmaring * ring);
-	void (*set_current_rxslot) (struct b43_dmaring * ring, int slot);
+	void (*set_rx_stop_slot) (struct b43_dmaring * ring, int slot);
 };
=20
 enum b43_dmatype {


--=20
Michael

--Sig_/mA+U1mX6VGG.DoCzC3NDLNc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdvArAAoJEPUyvh2QjYsODfsQAJWZtRWMQnvEt9WHxawtFycB
dKTvhD0ph5af6PihUKVymKYpKkZ+r+mW2K2PPA/xOGK612mOwT99bAQR+5ZREGgT
z/XftJdWbwNIVAFV/JwD3xa9YAoNr+apVR3TaYIWs0NH7KgM0i90r3HST97SLS8o
tvx8J9mdb6HafdM+lj4In8hph4m7keN8MI+ex/HmB6oObNpV+CNBoOflx4dPmdUM
MvnTJmDkqlvI7fKMvdAS7Wv61YQMtS7SQ73fyqaOvETCq38JMicpcaalQ5dY7gsA
3cWraWPgSELwaNy2M2RPccTLBUwSY2hwvaSUDknyrXrcU3q1JgnHWRy28h3HckZb
4p/kVi2hp+lJc9DiC7+ZZxR8Xqi7+ZiQu9aaTByEr6Iq7v29KEOzi4fWV37bAafz
MMX0gaxUGJ0gPdjW7iykDBPCWWfadA4KIAl5mwDLAd/ObcTWgnHqnd0jw1Jv8zgd
pBzWz7ITPLlGRWx/dAlnIhP/1hAfU3b/RZJThmYdbrc6PKaiynuJpThYnzCx1HNR
sqJuY7RrMOPiQvywp5JdKW0KYXbJG3hoqT7ISxvG0vDRatPoBbOks94phG/KS/KX
9BOc2IZzUpOSSguVDqUR9NcXn1car5ccM93AcH2XA0L82fJVMLGTsuy66PmR/MGB
IEwU0xFH/IZKKWjJpHb3
=2YkK
-----END PGP SIGNATURE-----

--Sig_/mA+U1mX6VGG.DoCzC3NDLNc--
