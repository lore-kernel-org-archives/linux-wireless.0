Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYKSNPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 08:15:45 -0500
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
In-Reply-To: <1227100347.26243.38.camel@johannes.berg> (sfid-20081119_141314_720850_5E82DA6A)
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
	 (sfid-20081119_141052_748770_CFCF3F4F)  <1227100347.26243.38.camel@johannes.berg>
	 (sfid-20081119_141314_720850_5E82DA6A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RLq6GQP+xmidG21+ocsp"
Date: Wed, 19 Nov 2008 14:14:56 +0100
Message-Id: <1227100496.26243.40.camel@johannes.berg> (sfid-20081119_141549_012238_DE9A210C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RLq6GQP+xmidG21+ocsp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 14:12 +0100, Johannes Berg wrote:
> On Wed, 2008-11-19 at 14:09 +0100, Johannes Berg wrote:
> > On Wed, 2008-11-19 at 15:02 +0200, Tomas Winkler wrote:
> >=20
> > > > Here's a thought: iwl_rx_queue_update_write_ptr doesn't synchronise=
 the
> > > > pointer rxq->bd memory to the device. So if you have a platform tha=
t's
> > > > not cache coherent for IO devices (mine is) that might be a problem=
.
> > >=20
> > > Need to issue wmb() there or something like this?
> >=20
> > well rb is also dma memory, no? So you'd have to use dma_sync_ or
> > something, just like with skb data, no?
>=20
> or maybe not? I can't look into this today, sorry.

Ah, no, you don't have to because this is allocated with
pci_alloc_consistent. I'm getting confused, sorry.

johannes

--=-RLq6GQP+xmidG21+ocsp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJBFMAAoJEKVg1VMiehFYnKIQAJs8t6D5f/1M9BWaWi+8UlPk
3Wnbn/+w1mr63WZCNNImbtxaw5UGGVN5xuGLmRUUk+EFWrf47OHB36yyMY3W61/o
A5ETxNGmboUv3JuTyhMzajg7r4FXZfmdt5y2OPDm4bHOzHzte9hzFqujT9H9Zaco
KAplUYnNH4tzz4wb3EwIw884KVuO2c8/oY3ANe9zYuD97itZYFbijMdW8ZUwLrk1
227Lk8qiz3w6B1+I1ZLmjDvPfM9a28npurJFJAqkdQTaRbdGl/ovSU5DFcBhV+Hr
mckmWiCeqcSw2SnESqcwmsv05zqJ6CykjVLP4m9BnIaSNSYcNMywBEYMk2VQoPhc
RpoC1/AVjnmljDrRKEjBK53j5dmPSh5fn4/uTEj/jk6RDtNfJwAjANfNZLSxUqUb
GuIN3U0a6RXHoYYztxsf4xopZWHciDaWbiaIZXihZRhWjV2LnhUhuWV4Dd1Vuc6+
tL8xRynGm2ZR5eYHMY20ruA/89GUoTLm7uNJbXzpi8jndVnLUIbqSweMPwbEPk13
Px+zY+E/0a+I6Azot0dP8tt1RkroK14eNmneDiTg1QXRChUtrYCK8JxR5ysuNWWb
Ai4XrHZfP0+9mNkn/cCPu2Qt6iC8nN36brs6DSkN34XAzKRdtJmB6aPBhSNneYDs
xpn6DLIWkzVcP7WE6xlC
=ou0J
-----END PGP SIGNATURE-----

--=-RLq6GQP+xmidG21+ocsp--

