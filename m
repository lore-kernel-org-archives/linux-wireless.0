Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYJFQvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 12:51:47 -0400
Subject: Re: [PATCH v2] iwlwifi: fix DMA code and bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810060949w5404944dud9f7b6b373542981@mail.gmail.com> (sfid-20081006_184903_690814_3BC35C90)
References: <1223308831.15196.28.camel@johannes.berg>
	 <1223309405.15196.32.camel@johannes.berg>
	 <1ba2fa240810060949w5404944dud9f7b6b373542981@mail.gmail.com>
	 (sfid-20081006_184903_690814_3BC35C90)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w7mNe51ONMs+eD6MYWQl"
Date: Mon, 06 Oct 2008 18:51:16 +0200
Message-Id: <1223311876.15196.38.camel@johannes.berg> (sfid-20081006_185150_705636_45A51E0F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w7mNe51ONMs+eD6MYWQl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 18:49 +0200, Tomas Winkler wrote:
> On Mon, Oct 6, 2008 at 6:10 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > This patch cleans up the DMA code to be understandable and not
> > completely wrong. In particular:
> >  * there is no need to have a weird iwl_tfd_frame_data struct that is
> >   used 10 times, just use an address struct 20 times
>=20
> In the hardware this is defined as couples

So? That doesn't actually matter at all.

> >  * therefore, all the is_odd junk goes away
> >  * fix a bug in iwl_hcmd_queue_reclaim where it would reclaim all the
> >   fragments of a descriptor rather than all descriptors (this may be
> >   the cause of the dma unmapping problem I reported)
> >  * some more cleanups
>=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > --
>=20
>=20
> > Tested on 5000 hw, please apply.
>=20
> Great job,  however do not apply this before I review it I had strong
> feeling this will not
> work with aggregation flows.

I cannot imagine why you think that, care to explain?

johannes

--=-w7mNe51ONMs+eD6MYWQl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6kIAAAoJEKVg1VMiehFYLskP/22LT0Snp54CMcCFxnMPj7pO
4DDKF9j5zCZMsxgQGH9L8bIpNFK79UTSMtwX1PRwsFMhNsaRggqW127krNLJX7yx
3RLk3R5+O6fxTwvjxUNqWXLEVN9X3xReQHqnXzSTJaV9TAEGTri1Dwt2qoqytqur
ggNHB8ACzy9Jej5yFGNDnoyt3IiepUi6ARj2klHzgHFieQP45Jrf6cv62nw0KDg8
JXc5gfxGnPak35g9pJp4toq79TqntgvLteKnWicspeHW06vL4MbzQUijW1zy4wdd
WeuYUJOpWvNqDCFjb87F6CdG1dVe15QNIckkhoutkfYxsTXirkWPPq/mHNUYyQO9
wBT+BAbUBOI8z5gu0ppoplxajbptFj0vtm0OFBVRB1UcHz3XV5XKQj3Eo0wuLFGb
7dEpSqLlYSLJpwjiJW/g4qaGmDZAra1EvYOJ7S1pzdTgoP78zkLD9eg2yJRBuqhd
KgTU5HoLL0bVtnNVv29vuffDJ2s56L609Ytrsmx1nvIAKuseiVJ05hl5PnE2HbIz
Ea8B0KgW7jHmAP412qEkCxfTXNe9gOt/I/1+xu7Gkp2ce+RoVEqoLIELsbtWaQ3K
abiyZl9TBaxSe+7BLGdpyPmN3GvFORdlgBNnnrB6J/URC9LpkXnX/ZhGIlv4Br+L
kM1M+9SonELMw8R43crD
=sf7d
-----END PGP SIGNATURE-----

--=-w7mNe51ONMs+eD6MYWQl--

