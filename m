Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbZG1PZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 11:25:56 -0400
Subject: Re: rt2x00: rt73usb doesn't receive PS Poll frames in the AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Perminov <igor.perminov@inbox.ru>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248790678.29068.94.camel@sunlight>
References: <1248784603.29068.44.camel@sunlight>
	 <1248787142.8113.10.camel@johannes.local>
	 <1248790678.29068.94.camel@sunlight>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VJbG85N6Z+qyQ/72vkpB"
Date: Tue, 28 Jul 2009 17:25:24 +0200
Message-Id: <1248794724.8113.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VJbG85N6Z+qyQ/72vkpB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-28 at 18:17 +0400, Igor Perminov wrote:

> And in case we introduce the FIF_PSPOLL flag, what the exact semantics
> will it have? When the FIF_CONTROL flag is passed to a driver, but the
> FIF_PSPOLL one isn't, should the driver filter out PS Poll frames (a) or
> not (b)?

Like all filter flags, FIF_PSPOLL would mean "give us PSPOLL frames
please", so (b).

> May be it would be better to take into account the FIF_PSPOLL flag when
> the FIF_CONTROL one isn't passed only (choice b) to be compatible with
> the current implementation? I.e. the device should receive PS Poll
> frames if either FIF_CONTROL or FIF_PSPOLL is passed (or both of them,
> of course).

I think it might make more sense to just set FIF_PSPOLL in mac80211 if
FIF_CONTROL is being set for some reason.

johannes

--=-VJbG85N6Z+qyQ/72vkpB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbxhfAAoJEODzc/N7+QmavrsQALaO/AUTN/xVcOIR5hEV7NOO
59yN7QCu7ggDkIPavlQNNqvbwD7jRq+gjatP07D2bFQ2AvfSGEEVVOAKCkcMYRs/
uiP6DnVMU1ytUHw2+wcuhXcCJYQNzxpwdB06r+NmwmH14UoGP9xkgrEaK/97rwda
4ahV8xXgTDif1y7+XKoAuNBm4zw/VF87COaL3Nmrr4ufIv8PBopZ/GPrRf/ocsJt
eDut4PzfGq42TGq8AiUd9adt9dn+EOTTQQjxXkaDR5IkoU0VOsDSdXIaC/OEp2Y6
epVcWRFVynklcunK0QoHhWqh66EyHbER/OHI/f5Hu0LXgMKQcu0pY6ikVd3xjDYq
xIJgwdd0TXQTtGCQrME3bNvVOXXYGKb4Isg1rAeQvv7TxfNn7+Nph/M3nZC27Jft
L07QRr1fiS+tdYxsYjSvPSJH9SfCB8U9kBr7QbetV/B9nZlUYWgxa87skXnPCen5
i+xHajvuqhwSek0+qKsW/VZhaeWwgyZgAJKE78BCcne7qYEJrDiw/tUwjIe+xgeI
ygTPwT/lURP769khoWhG3xQKAcG+g3wpct5WBDzGOYCLTJmEPfV4y5tkuYHmM89a
kK+Q3Gdk3u3tX9/LxdC4mpX9zZ61ygGoooKE86drX3vu89clfCdtl39Ly9YsyGHz
cKZXZx73pzwo55qUJUMG
=p2Qg
-----END PGP SIGNATURE-----

--=-VJbG85N6Z+qyQ/72vkpB--

