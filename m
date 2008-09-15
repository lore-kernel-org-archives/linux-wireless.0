Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYIOTQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 15:16:26 -0400
Subject: Re: [RFC] Redesigning aggregation on mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890809151203p213fae37ia3bd6871c3bfe2c2@mail.gmail.com> (sfid-20080915_210344_710978_CE092643)
References: <43e72e890809151203p213fae37ia3bd6871c3bfe2c2@mail.gmail.com>
	 (sfid-20080915_210344_710978_CE092643)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dJTxK8x3aO6ADMIzuVxb"
Date: Mon, 15 Sep 2008 21:15:42 +0200
Message-Id: <1221506142.3700.75.camel@johannes.berg> (sfid-20080915_211640_834517_0D147859)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dJTxK8x3aO6ADMIzuVxb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 12:03 -0700, Luis R. Rodriguez wrote:

> I'll start with Atheros hardware and mac80211. Atheros hardware uses 4
> main HW queues, one for each AC, and we also have one for beacons,
> another for queued stuff after beacon (aka "Crap After Beacon") where
> things like queued frames for broadcast / multicast or for frames for
> stations in power save mode, and I think another hw queue for uapsd.
> Right now mac80211 queues skb's for drivers into the netdev_queues.
> Under the current mac80211 design we have 4 netdev_queues, one for
> each AC and then there is a number of "aggregation queues". We
> essentially just declare one "aggregation" queue as we do our own
> queue mapping internally to our own hardware queues -- and that
> consist of just mapping frames to each HQ queue as per AC.

Except that declaring one "aggregation queue" also limits you to a
single aggregation session, no big deal in STA mode but punishable by
death in AP mode.

> Anyone know about Marvell's stuff? How about Broadcom?

Consider Broadcom's stuff to work just as yours. Details may differ, but
not by much.

johannes

--=-dJTxK8x3aO6ADMIzuVxb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzrRbAAoJEKVg1VMiehFY1NsP/jCtd+Bxx+bmlq0ppO5IYElF
0qDEUrhU6f28r+Wsu34JSWd85jLskpg1vIYpju9rH/yahm9co3M+Y2MwPmFfzyJx
9f9PcSAPrppzOXuFwBUMq0ay0wD01FZVAqSJl1He0Hlgmqgamw847Jdpem+a2Hlf
3bjIGilZg+YoCxBr/xfCsBfZIcYKYu1XsgEmI9MAQkVBNzW7RnQ4OtO9OZBGWIfo
CjgRt/MnUBr4lHeBPaxNsdwkn0jD1n6AQo+4GAE5qBxdY+QfmOp84NR4udUfKxCq
FttMhVwyx93ZE9ugSxOybidKNxPWHm96+14UEkmQjkAVQzzB2ckv1YGigforgfmg
PeVDc9bsmyzDSP4vUTvcpkA5EYsskQ4pMTWK13M9bLqKpxjTsNCHtvjkvQpI+Tgk
4yIMaqj2KhhvRULuZdE1Sfao3ojnOTmY7MaWUx4QrImDyNjTLh3OydbagRvHXTWJ
rKowAgMMi5flmTgYm6wJVP7gHsse9azDvNplZ/m3SJgyVctdC5obeXnVA8IAB5RU
fmm+dtjQpezG5za3K52ZPmoNw7Zfav+UFVueBQ89neGrSfkQDjOTGnrPAKXRyeQP
f6+FH4jwbUla956+8NuOIZRBvBCKSYmcpYBfrhWKyj5sKAdoOb9MRzHAB1DDLQtx
Xqx9zFlXSWh4AuZopHOm
=+XRe
-----END PGP SIGNATURE-----

--=-dJTxK8x3aO6ADMIzuVxb--

