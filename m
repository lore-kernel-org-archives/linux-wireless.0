Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZI1HlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 03:41:18 -0400
Subject: Re: [PATCH 2/2] cfg80211: fix wireless handlers assignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0909272139280.4061@sister.anvils>
References: <1254076075.6583.6.camel@johannes.local>
	 <Pine.LNX.4.64.0909272139280.4061@sister.anvils>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7PD+dtyAc7aAD8vJpNTx"
Date: Mon, 28 Sep 2009 09:41:17 +0200
Message-Id: <1254123677.6583.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7PD+dtyAc7aAD8vJpNTx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-09-27 at 21:58 +0100, Hugh Dickins wrote:

> This 2/2 patch does indeed work: many thanks.  But...

... it won't fix anything by itself.

> > This should fix the regression Hugh reported (of course requires the
> > other patch which unfortunately I forgot to CC you, Hugh, I'll send you
> > a copy in private).
>=20
> ... the 1/2 patch has a couple of problems.
>=20
> The trivial problem is that include/linux/notifier.h in Linus's git has
> #define NETDEV_PRE_UP		0x000D
> #define NETDEV_BONDING_OLDTYPE  0x000E
> #define NETDEV_BONDING_NEWTYPE  0x000F
>=20
> So it rejects the patch you posted: I changed it to add
> #define NETDEV_PRE_INIT		0x0010
> just after the NETDEV_BONDING_NEWTYPE line.

Right, that's fixable, I was evidently working against the wrong tree.

> The more serious problem is that it stops both my machines from booting,
> too early for framebuffer to show any messages, but vga=3Dnormal shows a
> long stacktrace scrolling offscreen, with some notifier stuff in there.

Ahrg. That's strange.

> I've experimented by moving your NETDEV_PRE_INIT hunk later in the
> sequence, just before the netdev_initialize_kobject(dev) (so I also
> changed the "goto out" to "goto err_uninit"): both* machines then boot
> correctly, and this mail leaves me wirelessly.
>=20
> I'll now experiment to see how early I can move that hunk.

Interesting. Thanks for that; must be some notifier that doesn't expect
to be run. For all I care, it can be right before the kobject stuff, so
maybe that makes more sense as it's a fairly last-minute fix now. Of
course then it should be POST_INIT or PRE_REGISTER I suppose.

johannes

--=-7PD+dtyAc7aAD8vJpNTx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKwGiZAAoJEODzc/N7+QmaOqgQAK7t2uYo30Raj87D/Y2ksQg5
V/Er6MzDN2IlYedSxeaeKVecwfZTEc3dy9NntadA0oMSbImyNaBad736H1qDMX+D
g9ZFIVyat+UbiqEaMSaw0H0XlatOI5r95DJ7H4EOiOu9NsRFnS5D/NgOa74Xq/9L
2RAEC2ZJshwbv7Z7MyuG2IUy4G80N/jR9+8B0S1ki9FrDwcOw2WEkm2S6IgYVt4r
80OSAhFFwTrsS16hQUD7TIw7vk2C0D7Gxxjq1sCCiORRHzjpWCtyMtkVpKByRYsG
zG8EfHHnSmXUrIIoG8Z6PCTDtryQb6MLoRtuLeyJeVIV6wk4NIchoDu2yltxk10n
Y9tQXCslNQAOgbXw0JZ8SDCA3p3eTHTZx7hKsktL4oQ4qgLyMUwaxMaOx7X8mEG5
IlUslKCEvIbRQsZiwjNl5hoLF2bh/+XjmGxI3glWjj7AoL69XzVN4teoaqTgW7Rh
cubyA/MN1fLRpndcGP3IfzDJpeuwXpxsJamYXHr8jlym2MehIHlMrGdE/ei5sw20
9fODmVXwjY/xXKh4EuCZqr18whsK+VX1EbGsWy0Mjub3cknDgQr0XVi5jfOM0jEf
YB8Yt4qqrkjN9CSXitVHi/qaDnO/lg6Ao4Fjb+ioEQBqk5dA1hVg3mOotIrn5jch
gfsBAhz8W5D2wytDSkH9
=X3+4
-----END PGP SIGNATURE-----

--=-7PD+dtyAc7aAD8vJpNTx--

