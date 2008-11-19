Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYKSM3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 07:29:36 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240811190424v4b9074e5u4e679bea278b1f3@mail.gmail.com> (sfid-20081119_132502_191402_DA089F51)
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227055693.4014.95.camel@johannes.berg>
	 <1ba2fa240811190121h3ff51824o90b72a206192e793@mail.gmail.com>
	 <1227094832.26243.10.camel@johannes.berg>
	 <1ba2fa240811190424v4b9074e5u4e679bea278b1f3@mail.gmail.com>
	 (sfid-20081119_132502_191402_DA089F51)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2ARwvjIcdMNmH8m/NHzF"
Date: Wed, 19 Nov 2008 13:28:57 +0100
Message-Id: <1227097737.26243.28.camel@johannes.berg> (sfid-20081119_132939_630525_7FD5CF77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2ARwvjIcdMNmH8m/NHzF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 14:24 +0200, Tomas Winkler wrote:
> On Wed, Nov 19, 2008 at 1:40 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2008-11-19 at 11:21 +0200, Tomas Winkler wrote:
> >
> >> > Indeed. One would seem to be the buffer list itself, which also need=
s to
> >> > fit within a 40-bit mask with 256 alignment (rxq->bd), the rb_stts n=
eeds
> >> > 16-byte alignment which probably is always satisfied, but I'm not su=
re,
> >> > you'll need to research the alignment guarantees.
> >>
> >> Note these are allocated using persistent calls and not kmalloc I hope
> >> at least does are page alignment.
> >
> > Good point. On powerpc at least that uses alloc_pages internally.
>=20
> Not sure if if wouldn't be better just work directly with pages in RX?

Well, in theory yes, but it's not possible to have skb->data point to a
separate page rather than a kmalloc area. And while you could allocate
an skb with very little headroom and the rest of the skb data in the
fraglist with pages, mac80211 couldn't handle it.

johannes

--=-2ARwvjIcdMNmH8m/NHzF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJAaFAAoJEKVg1VMiehFY53oP/3xyJxL9BXbnRQry9bzPB7JL
73f0V8AAHxU1Oo5Nd/Bqin7IKIJ4xsNhbNSoYdC0McDsJPGG2uqPWtjJJRMutSU2
8ILI2U8RQThhUWz8Ta2aMAX46IfdQ1JfTFTk2COAIC6RygOSFU3x09olALX4DWx9
4ehjA+v3QdxV6NgnSuoaeE0NSRVKZBgpCsO7fyxV0ABXYjYovXd2ak6/guvIRrdz
Kl7nnhLGMOdcQjY4/Ts0xgJzQl21DvXGv/jHADW0gzO0FMfgmsrieKp6Csovlu+z
HHxS0oK3v0hHep2tCw4W6jViPx+MggQ63U5nSsta60e9hzhHgMkoLLgp9QG1RITX
sKKWYhj8Tdd0jrLzFof6JUM8K3kSTR0ZEoj8bBhnuu48ZXUBjPcrlil57x5X0d8u
F60hHDqVzzXm5piaiP8A0Z5jwiN7/8AfWjGBZx1BnCWztcsIqMDZTHsHmk5Umbb/
z5em/qCWkcEKPaRR5Lx8qjwkMBXvsEdaoazAJ7535Y9YcHMAk6qjopM/CvjjKU4b
YmOBKHG95fTes14BjCcw9E76iEYQQKfh4tNHaf7LaoRNwShPGrytMTZo3iOMofaX
YyWufE2P9aOC75wSacDhCbZ7I3FO1gmfXwRIopwa1EPTwxGRy2AAitsyxBu2YkJB
DxSGEv+XPv3yZV3dYvxF
=P4Et
-----END PGP SIGNATURE-----

--=-2ARwvjIcdMNmH8m/NHzF--

