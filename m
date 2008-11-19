Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbYKSLlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 06:41:09 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240811190121h3ff51824o90b72a206192e793@mail.gmail.com> (sfid-20081119_102145_152719_5F0C41AF)
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227055693.4014.95.camel@johannes.berg>
	 <1ba2fa240811190121h3ff51824o90b72a206192e793@mail.gmail.com>
	 (sfid-20081119_102145_152719_5F0C41AF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aa3zvAAdEJbdrLXKG6IL"
Date: Wed, 19 Nov 2008 12:40:32 +0100
Message-Id: <1227094832.26243.10.camel@johannes.berg> (sfid-20081119_124113_117458_AF871637)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aa3zvAAdEJbdrLXKG6IL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 11:21 +0200, Tomas Winkler wrote:

> > Indeed. One would seem to be the buffer list itself, which also needs t=
o
> > fit within a 40-bit mask with 256 alignment (rxq->bd), the rb_stts need=
s
> > 16-byte alignment which probably is always satisfied, but I'm not sure,
> > you'll need to research the alignment guarantees.
>=20
> Note these are allocated using persistent calls and not kmalloc I hope
> at least does are page alignment.

Good point. On powerpc at least that uses alloc_pages internally.

> We have some alignment requirements also on TX side
>=20
> >
> > Another, different, question: I don't see where the driver tells the
> > hardware how large the buffers are it allocated. Can you point me to
> > that? You can switch 4k/8k ampdu but I don't see where you tell the
> > hardware.
>=20
> in iwl_rx_init
>  rb_size =3D
>  FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K .. 8K .. can go up to 16K.
> This  amsdu size (not ampdu) influence the size of RB we choose

Thanks. Yeah, ampdus are deaggregated already, my mistake.

johannes

--=-aa3zvAAdEJbdrLXKG6IL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJI/ssAAoJEKVg1VMiehFYagoP/j6RvxQZDE5kfghS04kq8h/g
9dFIru+9kGMv/jRu6fBny8zGvnbMizdo7GWJZS/fyVNtiwzNdOAkD5Rr3AABDtMM
26BknALD9qo1fmwgMXK2wk8N9696C9Vi+ZFt6ouF8t1ZDmUH1v0w2BznQcjeNOZ0
DqDQWlJCJL7IHHw2bBY6Itlvc8HG7/v/9J1wYLkRwEU5ZGt8c94mZyKCr+P7Ji7k
h4OznK0kHCCy5hkHnkwxGA1pDEJ67ldt7MYKRSqFj5uWD1VcGQSbavlVW3QobAic
FUHdbSXnJXUt+35QrXFr+kuqnkywBeMIDp+mBFKjKvXrKUSxRlD+yKPaq2sWEGSQ
e1iH/u0MSs9TqKGxOxHExx6qFQv2L6ndN+FpSsOhdDPhINa693UO684XnbIFkrj9
NsgBW7OK4LZtbwbIf9U8GZ/xhOtx00gYO0JbVW2gBdHBEEEiii+7TCKoclRZQcrU
oFG8BdkyWvXsNZZmqFvaaFf2fNr8M5wCRxs5CfNPUlZizZ8nJzttrunMZbnhLs5e
5mRwk6ZcF521c0WBwNZW0IH8oYN3Z80tZGxGRzwUKArXGq1pAorwH0lHv/iF22Oq
OJLYIjN7Bqk5y/6iX9Sh/cD2cEptEULeGENHC/cdfaK5yBn0yQgxGMbZ487Gi1O6
aBUQz7JPH5MMNMlQeC0b
=6FR7
-----END PGP SIGNATURE-----

--=-aa3zvAAdEJbdrLXKG6IL--

