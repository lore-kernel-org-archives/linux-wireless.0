Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbYBAW3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 17:29:43 -0500
Subject: Re: mac80211 QoS/aggregation questions, thoughts
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Tomas Winkler <tomasw@gmail.com>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <200802012316.44283.IvDoorn@gmail.com> (sfid-20080201_221713_668460_903968FC)
References: <1201882512.4188.66.camel@johannes.berg>
	 <200802012316.44283.IvDoorn@gmail.com>
	 (sfid-20080201_221713_668460_903968FC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/UWid+CvGfMksgrasqAa"
Date: Fri, 01 Feb 2008 23:29:35 +0100
Message-Id: <1201904975.4188.88.camel@johannes.berg> (sfid-20080201_222946_835559_081E572C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/UWid+CvGfMksgrasqAa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

> All patches are currently in testing, and I hope to send them to wireless=
-2.6
> next weekend.

Ah cool, I'll hold off on doing anything then until then.

> rt2400pci, rt2500pci and rt2500usb have a special dedicated queue which i=
s called
> the ATIM queue. The implementation is a guess since it was never used in =
the
> legacy drivers. But it is clear it contains frames which are send directl=
y after the beacon.

Well I'd guess this is for the ATIM window. Broadcom firmware actually
has an ATIM queue *and* a broadcast/multicast queue, I would expect that
you should actually put broadcast/multicast traffic onto the beacon
queue (unless the beacon queue only sends one packet per beacon
interval)

ATIM is actually one of the things I haven't fully understood yet, see
IEEE 802.11 11.2.2.

> >      4. remove IEEE80211_TX_QUEUE_SVP, it's something strange and
> >         atheros specific
>=20
> I always wondered what the queue was. ;)

spectralink voice protocol. I have not even the slightest clue.

> HCCA queue is a big mysterie, there are registers to initialize it inside=
 the device,
> but in implementation of the legacy driver the queue was unused, I haven'=
t found a
> correct entry point yet to send frames over it, since that interface seem=
s to be missing
> in the device... So either I am missing something or the queue was half-i=
mplemented
> in the device itself.. :S

No idea, that's HCF (802.11e) stuff. Maybe they just never got around to
finishing that implementation.

johannes

--=-/UWid+CvGfMksgrasqAa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6OdTqVg1VMiehFYAQK/Mw//Udy/gKp+MpqUQjWqa+F5wCxjUqKWGm3c
vHZiCTJdkM86JV/507OUXXOeiKTZR9KTq49kZUefPR6IMYWJn2Ye4xiJLnzgX3dv
yvGIJoXGCeuGNjF6nXHxf6JViQ96XwmWzOnALHkAMPX5f2DyI8Is8O3GwdxSm8J0
AzvcCgOd04nUDThaBFiLNJHoyUFgNnYiDxtZMy3Z53d5SJqjYnvCJgKKh1I8tXVY
LJZ8DXmG6pMSPgZpDAc+uthe3V+xv/55yG/gwTkHmVjDC0e1Tg+Z+uuTPFtsroqQ
ThpFDXrGBqGIz3ah5QJAblwd8BLlDZGtaw/GAp3F6VqamGBgXzAPi/1GyHW4QxdC
hY8Z11TioN9dtKoDOtnDGobZHu8NBpYp2qRS8K7gTYRhuQhwO5Lkwp5mke6ntoKv
KncVcDOALgEfys9jBWQleP2wppBg/BKHJ88ZUde5drLDTIAQRAKr9hPeWWXilJZy
PvOijhanXJYxAccE2UneF+cwNlLJEhabfzOOMt0myBVz4MpctiyyEXHuFSwOyr9n
aCRV0YS7T/9N0caFLh49hC48vjvEyxCFVtFIMPJDB3O56kWcy4wrgxEcBVrytQ+b
gnyoZLrVsCOAP3QCen20rFwgQ+W8/gvhyplz94urOrEGplVNdEQ506jIb29IetIf
y5cwGynwheA=
=aWVh
-----END PGP SIGNATURE-----

--=-/UWid+CvGfMksgrasqAa--

