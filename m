Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYA2RpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 12:45:20 -0500
Subject: Re: [PATCH 06/12] mac80211: A-MPDU Tx adding qdisc support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <rindjon@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470801270926g1f84fc8t5905b458b4eee012@mail.gmail.com> (sfid-20080127_172655_676465_47F33706)
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163392546-git-send-email-ron.rindjunsky@intel.com>
	 <1201167778.3454.75.camel@johannes.berg>
	 <c85cb4470801270926g1f84fc8t5905b458b4eee012@mail.gmail.com>
	 (sfid-20080127_172655_676465_47F33706)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u0pILNK0svVqOUgP5Tgd"
Date: Tue, 29 Jan 2008 17:12:49 +0100
Message-Id: <1201623169.4394.35.camel@johannes.berg> (sfid-20080129_174530_485563_881AAD5C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u0pILNK0svVqOUgP5Tgd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> well, this bit just tells the driver that this frame should be
> aggregated. it does not, in any case, determines to low-level driver
> what will be be distribution of frames per A-MPDU or the order of
> them, as this is the low-level's driver/HW job. so i believe Braodcom
> can do what iwlwifi do, just check this bit and decide if they
> aggregate the frame or not, and in which A-MPDU. the rest of the
> information needed can be extracted easily from start/stop aggregation
> flows.

Oh, you're right, mac80211 doesn't do that decision, the driver will
have to do it.

> I can change this book keeping, though current solution provides us up
> to 32 HW queues, which is really a huge amout of queues in terms of
> HW. if needed after all, i would prefer to do it on top of this
> series.

Well you don't really need to change any code I think, only use

	unsigned long qdisc_pool[BITS_TO_LONGS(NUM_TX_DATA_QUEUES_AMPDU)];

instead and that way we should already be safe for future increases of
the NUM_TX_DATA_QUEUES_AMPDU value. set_bit/clear_bit/etc. are already
prepared to handle such an array so I'd prefer to have it right away
just so there are less gotchas when that happens.

johannes

--=-u0pILNK0svVqOUgP5Tgd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR59QgKVg1VMiehFYAQKd4Q//RcEviCxf2CUDG4hFtCjQlMZvdE/6bT2e
wRX/P+1SZswUpN8NZS/9KvADkZGKOJ9t1B+18fg1ggx+DZQely7iJ6N2iBYbl396
65PfAaU2Jn++SORuXJVtanFAVtZy43ufsCwO4marXzTN27HSWIOVi6buvGhNnkDO
naZkLkDwU76mVuuwZIs7RdW34ptw8knzgLkNCXFlp4DoQe1WFzfEicAGJKUagjRy
aYTWGvLgY+eCVXH+IQd21NSbjEILYPwpo1k+vuO9FWHh/mMkLY5tjhfIgC6wc9Ld
sUU6bQWsv8H+vieFNGN3Qq/+op5yHBH4ZFrPc8dOe1HWnQrveUfZn4uDpT0FJeO2
G72MxBwH6iULB8t02L1OS3f4Uk2/02mYsfF1ZypVNfFJiANw4mVojMS1uNA0I6fq
MriraGoNiJYOMpNOePJwQbTLMzdD5ZnIxlPFwnprJ3GZ0PghYnXbQXj3AQVoK5Vn
Agev+VSYq26cUHS/nVtxCvVf3XXf52iWGx6vj4Od4MHJLWUQZDoSOpqgM4gzUQG8
5AaYPHPG3Btt9nIe+EDLOJ0obVH+zQ+cCEKUGXERJZpSy9BPTpPEHCUC1qMKY19H
6hymbj2UvmeJOKNNYXaQgdcGxm2pPRScFBcmZhuTtMqPsJ+FB4INZCin2NRkkFvi
PvvO0mRLLow=
=8HQ6
-----END PGP SIGNATURE-----

--=-u0pILNK0svVqOUgP5Tgd--

