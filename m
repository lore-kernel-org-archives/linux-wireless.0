Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYIFTmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 15:42:01 -0400
Subject: Re: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <48C2DBCB.1030706@lwfinger.net>
References: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net>
	 <200809062055.51797.mb@bu3sch.de> <1220727470.10102.9.camel@johannes.berg>
	 <200809062104.15274.mb@bu3sch.de>  <48C2DBCB.1030706@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k4cyUyQ4Z+2NGGg3PUBl"
Date: Sat, 06 Sep 2008 21:41:55 +0200
Message-Id: <1220730115.10102.15.camel@johannes.berg> (sfid-20080906_214207_051861_3653CFA7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k4cyUyQ4Z+2NGGg3PUBl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-06 at 14:36 -0500, Larry Finger wrote:

> What I see are lots of
>=20
> b43legacy: In b43legacy_handle_hwtxstatus, hw->flags =3D 0x1
>=20
> and this is the only one that ever triggered. ATM, I'm not sure why=20
> handle_irq_transmit_status() is not called.

The mechanism depends on the card revision, but according to
drivers/net/wireless/b43legacy/dma.c it's always via the dma/pio
mechanism for legacy cards:

        if (dev->dev->id.revision < 5) {
                ring =3D b43legacy_setup_dmaring(dev, 3, 0, type);
                if (!ring)
                        goto err_destroy_rx0;
                dma->rx_ring3 =3D ring;
        }

johannes

--=-k4cyUyQ4Z+2NGGg3PUBl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwtz/AAoJEKVg1VMiehFYoUYP/jNHgfkW6yUj4OC3LwRbyPsS
UxOV7suWUcjwB2DsnpBwVnkCzBWxlIh74qDVXrY9vBxUXiMKbcLTVbaBnlJ5tIE+
/jH8AaX6xfCdJdzkI61SJ61cfnG7ePzXDUpjx8p6fSg/RE6Czt8D0vOfvtQRGfjY
RAwn6hKCYiKEdF4qZFjwt02I0FbVGzscY4BaQifZmNBt+y2x5znNtqd1tiepF5bn
1nwRmJ0jU5lyLvwFUyvLGsfjIuFUsPsi5FmjB/bUFHDuonxVKWpfTaJNMf02tuHK
Voo8mHRWIlZlxcG8vNCtCET6nV8vMt94ExrRNHGGpIacSrPZUshfX/Bf9sMPemMZ
1vVHAMwJ5YC/MZNlR0JsPQCRL25ibb+WSe3akpl2k5Sg7E5qCplHNddag9Ohk6+H
xszu9mS9zuktMr5NXEyhyTnhbASG8vist4e0zSTIu4oO3kaVnFUGm8MMf9h9MFOZ
K2DMx4Tv8I5j0nlyq1rCY7suDfVtm+/a5mZx2fX4v0zwczxyVbkhD4XclqD3KBhq
nhk5Ud6store+weHiLvtD+GbKRSrkdS1Qkj/EMxglS9zawT1KBOqyCqrXAzGDc47
EqlF02d/+sk92NT8G27XcJE0NRQzqRABkthBvHLGjHBEiaaAZ8LumeUd3o0eCWSP
9IlEQQBK8YYvw4JSSY24
=Z3LW
-----END PGP SIGNATURE-----

--=-k4cyUyQ4Z+2NGGg3PUBl--

