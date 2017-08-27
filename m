Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35136 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751162AbdH0POP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Aug 2017 11:14:15 -0400
Message-ID: <1503846841.3688.92.camel@decadent.org.uk> (sfid-20170827_171418_765074_AC183349)
Subject: CVE-2017-9417 and brcmfmac
From: Ben Hutchings <ben@decadent.org.uk>
To: brcm80211-dev-list.pdl@broadcom.com
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org
Date: Sun, 27 Aug 2017 16:14:01 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-QtyYaqm+xauABz0YjTqH"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QtyYaqm+xauABz0YjTqH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The CVE-2017-9417 aka "Broadpwn" vulnerability is said to affect the
firmware for various Broadcom BCM43xx wifi chips, some of which are
supported by the in-tree brcmfmac driver and firmware in linux-
firmware.git.

The bcmdhd driver for Android was patched to improve validation of
events from the firmware:
https://android.googlesource.com/kernel/msm.git/+/android-6.0.1_r0.92%5E!/
But the event handling code in
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c still seems to
lack most of those checks.  Should it be patched?

I also haven't seen any related updates for BCM43xx firmware in linux-
firmware.git.  Is any of this firmware vulnerable?

Ben.

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-QtyYaqm+xauABz0YjTqH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlmi4bkACgkQ57/I7JWG
EQkVxg//YNOMQhU64pI14TgIdg2prqdhgna0TLcCQA/ZkdmdIFME0VPwAWnQNdZh
/6QYxUujPA8plTSnGJE9tf+hBD6mvraJq6qD7apMB+z9jsOrJE21UW7UFThlMPNY
oUPqUC1SGZWSpebRuOGRbFUC5Th+SWzgoUBPyzcI+TTy2pKRMLXk+UGC8oCDYASH
l04kziXd27IYckAoyuO7tf8OzqalvqpjAsrW9IJw20RFxwY1ONqNG/EJ0vYSZNRC
8mqIegYB4pRLQNLCsh0iR6ieNyQ8H+rwik4M6W8SrZrlR/bgW6w23fqzQm1updqt
adYwokodBfbZanPRjOHb1PgPHF8sWu++5jgnFO0HNsGsdSRZ0hbJrjJOzssYl02L
UZMpQIg7OCi1dqxhnf7+ormC0hNnpjfD7+6zWnNU9BsyfIdJQVthxfm4dFUt9Xvx
gFPSmeSXkNnTWkxMrqtTiEcRVJPR2tEzopb6dj5uTzeO/0A27KmSFGu1zLmhqQWL
/DJlL+Avf4YjVBgjlNg+wmGYEk0AmXnkj/BQrX51MZoO6ouMWxwqeDQOZKU4QHRq
0tMyY/So5ZJKLzgadUh2gS0Se4OyFFVzs5XK0Hur8Wc3yD3CXnGaOLg0/oWT9IV9
JP7uRH46lf0qRr5gYlFg78YaRPMoy66XF5MM37bmNNLkYR2Hh1s=
=CXwq
-----END PGP SIGNATURE-----

--=-QtyYaqm+xauABz0YjTqH--
