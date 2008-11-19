Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58036 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYKSNKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 08:10:47 -0500
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
In-Reply-To: <1ba2fa240811190502j274595e6lf02b957ae047b4c4@mail.gmail.com> (sfid-20081119_140215_205729_C9D74877)
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227021904.4014.58.camel@johannes.berg>
	 <1ba2fa240811190115i6bad0c89wb1d9c8ee281be2f8@mail.gmail.com>
	 <1227094594.26243.6.camel@johannes.berg>
	 <1ba2fa240811190422o4eebb26ai17ea12825ae8e708@mail.gmail.com>
	 <1227097994.26243.33.camel@johannes.berg>
	 <1ba2fa240811190502j274595e6lf02b957ae047b4c4@mail.gmail.com>
	 (sfid-20081119_140215_205729_C9D74877)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+SecWZcPoBQQ2SckUN1C"
Date: Wed, 19 Nov 2008 14:09:50 +0100
Message-Id: <1227100190.26243.36.camel@johannes.berg> (sfid-20081119_141052_748770_CFCF3F4F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+SecWZcPoBQQ2SckUN1C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 15:02 +0200, Tomas Winkler wrote:

> > Here's a thought: iwl_rx_queue_update_write_ptr doesn't synchronise the
> > pointer rxq->bd memory to the device. So if you have a platform that's
> > not cache coherent for IO devices (mine is) that might be a problem.
>=20
> Need to issue wmb() there or something like this?

well rb is also dma memory, no? So you'd have to use dma_sync_ or
something, just like with skb data, no?

johannes

--=-+SecWZcPoBQQ2SckUN1C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJBAaAAoJEKVg1VMiehFYcE0QAIWMKJsMO59xEhgenEAi7Jff
1H3eOGvFXL6cxPGNyTpbhy3RSRQrtt4tlt+equ8tR8KXNTO0Ij3n8U/JZudNqgWc
/k2hxuSOwIxZUcwl+rM7PqfvihVR/hhv6SIQgNu23ioJndV3e9JSzDwrH9JQLipL
/6gOTLt+fgk3Nn1DBB1z8NK//MfWukVmnxE4gUdRfzZm+94OXmA9Xs9ENOAp5Y4f
gDQX8VdLvhl6eZLGNfnLzbc0Dt9569g5P+h8d4ic/BuhD1L1MZqPxtq/vBSTiXoN
X1tVIog0r/SRxn6zZia2+KGY3th+wyXigITm95x6oJND+gwaVUHBQP6yJhRoXWHH
PzI16RW+5DBHrA4KAfYaIiAxz9IC3bg8nMrplY1i934tiU6FyO5IIbRB4aG19XdT
TGTYj+vCrKIBtYK93lieyjP0NMefweK1ejtV/lRYGoqhORQkAShYNbC9ynWcWPn0
j84ApvDtLfFGFSXFrXNUWQAjggEYWOfyORp6nSNmVZrwJZMORim/b0nqPJ7w7npo
X7tkHTrPmW8imjVbHCrzDd3ajmDs9MSDwfrI2mPKtCBvzOsxN6UZ206Wm4hxXAty
xDp7D0LPifFfYCnKtyyhsAhI4+xCQkkHjYDmI2Ge1vyF+HlHQOPu33d10FwwSNxP
t9k1Ii1LX78wdWtB03we
=VYcm
-----END PGP SIGNATURE-----

--=-+SecWZcPoBQQ2SckUN1C--

