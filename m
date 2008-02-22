Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152AbYBVN5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 08:57:15 -0500
Subject: mac80211: sta info locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4tk9C2tRx4VqLsvjVXdR"
Date: Fri, 22 Feb 2008 11:44:29 +0100
Message-Id: <1203677069.26341.52.camel@johannes.berg> (sfid-20080222_135720_471936_0AF8A1E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4tk9C2tRx4VqLsvjVXdR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Ron, I noticed you added spinlocks to ampdu_mlme for both the and TX
processing. Generally, the locking in sta_info is lacking, for example
the flags member is simply updated all over the place without regard for
locking.

I have boiled down the locking requirements to various things:

 * static sta info members, set on allocation (fine now after a patch
   that splits allocation and hash table insertion, except in one
   place where an AP entry is added, need to review)
 * semi-static information, to review, but most likely updated only
   on external events like cfg80211 which are synchronized
 * flags, needs locking badly
 * powersave frame queues (have internal locking)
 * sta info members updated only within the TX status path
   -> fine per my previous mail
 * sta info members updated only within the RX path
   -> also fine per my previous mail
 * debug counters we don't really care about (channel use)
 * AMPDU stuff (own locking)

Hence, I think we can actually get away without more locking if we
protect the flags better. Should we use a spinlock or the atomic
set_bit()/clear_bit()/etc. operations?

If we were to use a spinlock, could the AMPDU stuff use that too? Does
it really need one spinlock for TX and one for RX?

I don't think the spinlock would be contended a lot, but it is possible
that, at the same time,
 * the TX path is trying to clear the PSPOLL flag
 * hostapd is trying to clear the WLAN_STA_AUTHORIZED flag
 * the RX path is trying to set the PS flag

....

I hope you're all (not just Ron, I just addressed you because of the
ampdu stuff) reading this and trying to wrap your head around the
synchronisation issues in mac80211, I don't want to be the only one with
then somehow magic knowledge about it... Once I understand it I'll try
to document it too.

johannes

--=-4tk9C2tRx4VqLsvjVXdR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR76njKVg1VMiehFYAQKfMw/+KgJ9t139hT+RzQEiX7icdTxKLQufJ8tm
rUSDPN89UK9zTSqtRBcgVAIWZlkLh60EPh1XKe5nmdxCUkoQj3JF5R9qmPACHS2v
0nLWYYudOZN0p1tI4HlL62LWEpJ5X10ZydfMNdz72hyOuhWr3b4pLM6zr9drIKzs
aIgOlN6CCb/eAJ7XaG4FsQ4CTFarOZL0IR6H2yIxXHlY1LqN6PI0VRtJYUfQ9pEp
r9IVWB7aqviDQv+d6iXX7RkezgnN4HmP7xhjlsLNJfSmbxmuUbPxLgtfA8IxSQlU
jWNFQ1bz/D/21KdxPp12p/CgcE2XBKMKvLEmGrMQbLbzSb7W/jzXoBv3A4zoapj6
OUPmZpuEBxsFW98cvBYSUNiatE1FALfimnXgixQb8mQ2ScMyJOTceBZ6TzqcqGGH
uHnKbxnmeziV0ksYdS2kUjgCoOtWkj+f/qPG/cGLlPZY/Af6hrB93sDcUcutyVpS
L8/vDbYDloxZ+hdI0DjpwGVlBsBi0cfWxvjWrMiWkXNBu7T+Plz8488QaKvQU/Uv
L+NPYD2uCQ6AgEE6e/4A5VPPhMzw/MxsAqovebOoSXRh7rdfOgUO/rUQnWxorjSe
49S5ie/jS2fp3bRqJEi/eseLtX6c35s+0c3UBgM2yVm3xzIqj7foxAqNM3tvGEd0
OZ3FcEmVG60=
=carX
-----END PGP SIGNATURE-----

--=-4tk9C2tRx4VqLsvjVXdR--

