Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYKSNNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 08:13:10 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <1227100190.26243.36.camel@johannes.berg> (sfid-20081119_141052_748770_CFCF3F4F)
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227021904.4014.58.camel@johannes.berg>
	 <1ba2fa240811190115i6bad0c89wb1d9c8ee281be2f8@mail.gmail.com>
	 <1227094594.26243.6.camel@johannes.berg>
	 <1ba2fa240811190422o4eebb26ai17ea12825ae8e708@mail.gmail.com>
	 <1227097994.26243.33.camel@johannes.berg>
	 <1ba2fa240811190502j274595e6lf02b957ae047b4c4@mail.gmail.com>
	 (sfid-20081119_140215_205729_C9D74877)  <1227100190.26243.36.camel@johannes.berg>
	 (sfid-20081119_141052_748770_CFCF3F4F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8VUsOyRqyQaV13m4e+/B"
Date: Wed, 19 Nov 2008 14:12:27 +0100
Message-Id: <1227100347.26243.38.camel@johannes.berg> (sfid-20081119_141314_720850_5E82DA6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8VUsOyRqyQaV13m4e+/B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 14:09 +0100, Johannes Berg wrote:
> On Wed, 2008-11-19 at 15:02 +0200, Tomas Winkler wrote:
>=20
> > > Here's a thought: iwl_rx_queue_update_write_ptr doesn't synchronise t=
he
> > > pointer rxq->bd memory to the device. So if you have a platform that'=
s
> > > not cache coherent for IO devices (mine is) that might be a problem.
> >=20
> > Need to issue wmb() there or something like this?
>=20
> well rb is also dma memory, no? So you'd have to use dma_sync_ or
> something, just like with skb data, no?

or maybe not? I can't look into this today, sorry.

johannes

--=-8VUsOyRqyQaV13m4e+/B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJBC3AAoJEKVg1VMiehFYzc4P/3itPTENG2h+/x9UbRpT4FxA
KoWRNEMN8glpGffL6VbLJfleKu2KxY4bZOSJ6sWA06KpF/1BXLqWL8S7hjAiQxmN
kQxDspjHocQ3qYLVSvAnPRyGHI7e20r4GMSSreWrzGNV7f537fVRXAU22DqmpebO
JCc/mhAs5PqMO2XcDhiucJZ7hq7R/ZtR4/pIbG1BXQeSnm99l372sHeWLvCEjb/l
JxlxHouoYWxL2nbm3CSG5ZEOqunpYQsO9evknSZB7/GfymUMRTXPmaHInYr/Ke3A
zU+oOHvXeJyRCv0sjru8LmM9VN52RnanwEGDCw5McU19fdfJ+E5AOg4Iw6NWzuKM
t/kwmdG/zgSoTJGI/CCef6PTfPLmKdFSLpME5Zdg5U3DmyxxU9+OP+QyA8MftxxQ
I/q3gK2C6JnkY4e2pGhv4nUJlJzkojOX9dEMyOtHddLs7nuUs/PNfTi8s5y7iZDi
w9n+cKq7/f6kTlXpmYwxh34YB7ptlXM4L8fZEBv7vXnbDTw4zSAnz3KLrnkExDid
Oggvh+p5Lg3icRzjvwgGuBhiyuSyToO0AQXQRKpZZzKOMwT0rytKNuf+ZPBVpV20
FK1MkePhji7S49VGxD2FS9ormRs3DExnebGlhyNKOcswVPFa//pVH0XR2YWgTkZd
EkQbTCNOcccCjoL/FaE5
=fohV
-----END PGP SIGNATURE-----

--=-8VUsOyRqyQaV13m4e+/B--

