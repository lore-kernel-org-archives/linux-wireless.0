Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZHTJWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 05:22:41 -0400
Subject: Re: Linux Kernel Wireless stack presentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0908200002s4dc0dbf7kc28dda3fa7afaeb9@mail.gmail.com>
References: <eb3ff54b0908200002s4dc0dbf7kc28dda3fa7afaeb9@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UxlsWfhTKA5pxtvwfd//"
Date: Thu, 20 Aug 2009 11:22:10 +0200
Message-Id: <1250760130.4100.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UxlsWfhTKA5pxtvwfd//
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-20 at 10:02 +0300, Rami Rosen wrote:

> http://tuxology.net/wp-content/uploads/2009/08/wirelessLecHerzelinux.pdf

had a quick look

 * almost all drivers support passive scanning -- all the modern ones at
   least -- maybe some old drivers don't, but all using cfg80211 do
 * your presentation is based on old code -- all the code stuff about
   scanning is already outdated in wireless-testing
 * you can scan for multiple specific SSIDs and channels:
   iw wlan0 scan freq 2412 ssid foo bar baz
 * iw has a better IE parser, so showing a result from that may be more
   instructive
 * code stuff about authentication/association is also outdated already
 * the STA_MLME_DISABLED stuff no longer exists
 * AP MLME will never be in the kernel, not just not in the near
   future :)
 * raw packets still go through the mac80211 stack, they arrive in
   monitor_start_xmit() or so
 * four-address format is not necessarily used only for WDS, the
   standard doesn't define uses for it (ToDS =3D FromDS =3D 1)
 * an AP may transmit nullfunc (!) frames to tell clients it has no data
   buffered, but it never transmits frames with the PM bit on
 * power timeout 5 is described incorrectly -- it doesn't go to sleep
   for 5 seconds, it actually stays awake for 5 seconds after each
   packet transmission -- the time spent asleep is calculated based on
   the DTIM period etc. Cf. 04fe20372e70685d9f15966216cdffd3795fe590.
 * STA may wake up in response to TIM[AID] =3D=3D 1 instead of sending
   PS-poll, which we do depends on the timeout (iwconfig wlan0 power
   timeout 0 =3D=3D PS-poll, iwconfig wlan0 power timeout 100ms =3D=3D send
   nullfunc and stay awake for 100ms)
 * "paramter" typo
 * ibss is in net/mac80211/ibss.c and has been for quite a while
 * PM in IBSS is not implemented typically
 * s/80211.s/802.11s/
 * s/80211.n/802.11n/
 * you can change the channel with iw (iw phy set freq ...) but it isn't
   really useful unless you're AP/monitor (and rejected otherwise)
 * Fedora no longer updates from wireless-testing afaik
 * wmaster0 is no longer created
 * assigning interface_modes doesn't set the mode, it just sets the
   possible modes :)
 * you can also call iterate_interfaces_atomic() in irq context
 * nobody cares about the wireless extensions version any more :)
 * for sniffing you may care about "iw dev <devname> set monitor <flag>*"

Hey that got long!

johannes

--=-UxlsWfhTKA5pxtvwfd//
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjRW+AAoJEODzc/N7+QmaM4oP+wTivpH2W76vmBI8v70CPeF3
81ziKxZ8xJOeyKcBN41FN2IQDATFIBj6Lw236MVJFrOKgMJ8FLFB0g5bO9TZWQ6D
luC1v7siBCJc8CIfmf0jXzKnoo5F9RtQegEClxdC9crPX9W9jePD3p1u++GXo6xl
+XrjZK+EWzrXQ+isAVG66Uec5j7yJyLZnMyvA9Y4BmLbEWxbRCAM9MHWyGjrQBVj
ACRGzk6hLPQ9FQhrNICwE+5XZuv6NTFgkj5CZrJ5RRoHns6cojUAPQRcxjvz0rON
Onnx/BzP0RGx/jqTtB4tEbBjs0YzCZsXL2lE9u0PQv9c4n+0DfsXyZbj1pDkK2Gr
Mwf2SUrG9+czcDeejJFTujW/FTx6kRC0+yjFo50YRnQpgNOC5XtgCl3N3mz7Rw/r
3goo8//Z+sJOjO2kKooadsrCGrJxtMrDahEMpp4XMAIxw+kz6O3UDhO4Erbq4W5T
9jVQ+tp0hble2IAx6FC1GIjIsVrlHwzG5s/zNJ+kuE/ZVh1rdEAKg+TmuiCR2X/M
WnJFwwKIPV2kqCKUsItrrei7RKrz10yxHYkHj3tJPD7jfLr3iOZJc6XF9/P9mxjJ
sJJWVjIhmxs49ND37WBBHqoX4cO4dYAcj0V5TfYgssUd7T/2H2SaLUBJCXhUYACW
vg4RMhZsooaptuW+K7zy
=X6N8
-----END PGP SIGNATURE-----

--=-UxlsWfhTKA5pxtvwfd//--

