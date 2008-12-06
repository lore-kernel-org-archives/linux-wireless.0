Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54526 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbYLFPsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 10:48:13 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812061603.21930.hrogge@googlemail.com> (sfid-20081206_160326_185011_DE170A7B)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812061511.05473.hrogge@googlemail.com>
	 <1228575081.16752.8.camel@johannes.berg>
	 <200812061603.21930.hrogge@googlemail.com>
	 (sfid-20081206_160326_185011_DE170A7B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mFb3HJ4LWJL93Aeg6y4b"
Date: Sat, 06 Dec 2008 16:48:07 +0100
Message-Id: <1228578487.16752.12.camel@johannes.berg> (sfid-20081206_164827_665688_BD1C3A58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mFb3HJ4LWJL93Aeg6y4b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-06 at 16:03 +0100, Henning Rogge wrote:

> > can you please move the rate parts into a new struct, so we can use
> > tx.flags, tx.mcs etc. and later just need to add a second instance of
> > the struct for rx
>=20
> struct bitrate_info ?
> or maybe
> struct cfg80211_bitrate_info ?

Either one is fine I guess.

> > Also, if we really really need this information (I still don't see why
> > the kernel has to calculate it) then it should be in cfg80211 not
> > mac80211 so other drivers could potentially make use of it. Personally,
> > I'd just leave it out though.

> Hmm... is "cfg.c" not part of cfg80211 ?

No, cfg.c is part of mac80211, it's mac80211's code to interact with
cfg80211, it won't be called for non-mac80211 drivers.

> We need the "total bitrate" for 802.11abg rates. They have no mcs rates.
> The "legacy index" for non 802.11n bitrates points to a hw specific "band=
"=20
> array, so I don't think we can export it to userspace as an index.

But we can name it _legacy and put the bitrate there in units of
100kbps, and leave it out for MCS rates then.

johannes

--=-mFb3HJ4LWJL93Aeg6y4b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOp6zAAoJEKVg1VMiehFYxHEP/1roC+qkxGvJ87bGFU6ql2FK
dbaqDu9n3iKeWhTkKm3XW4ctSOERM+fjbI64YyUMlepcPO5Cok+LNdOMprzNZBcl
Lcghoz+7vt8uRm3VXBf3SqLWJV/3Or4b6WzM2jVkmlLLYqqZfQxkXV0nphcTxKZf
+Abw5Gww4Oqo47vkxynEdKUVG2OWu6mavyfmBWePOudqmeAoIw4+Jx65Fpi7pJ76
bwQRxpnNJfppiIe1kH2tqfJTF6JSaE9GIAknkucgRaHLtGQX2feAdSCL3JyTWUXr
cDadh/M0ygX02ssavkfGbPKhiMQy6LOPXWydlvtXb8wRhYHDeRyNdY7jC1DpzJ82
8woJQzKl3vnyEkQch+tKqetEj2Ptop+ihT0nAedFvURAjn2rkDl6hdWanZh0ESUl
n/cV+JewIfItJptrYXz04yGN5V40TXlB2WSxhI2Sxl8eZEgxTbNkSPETU+fkS3iv
ELrytpKl5uczZuRJlOvdv5IYF2eT5b9moVZm/NaYjnwSFS7v2MCnzJHkoBXhJfpf
5cadDmwojOJoFop5Y3QxkK5PfN5HT1vb3a37zEoEm0uQLHgP63Mgqv6gDLoyvbK/
KO+uEtyiJSzf+qeN0jXDlzyLikJ8CX6kTV7jSo1+rXa2cKI4C5ahAur/xoJDFTN7
du49DsR5iuE8oXP2OcdI
=8ZNJ
-----END PGP SIGNATURE-----

--=-mFb3HJ4LWJL93Aeg6y4b--

