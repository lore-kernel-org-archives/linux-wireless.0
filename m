Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbXI3ImP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 04:42:15 -0400
Subject: Re: Kernelspace --> Userspace MLME move and related items
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070929161740.GB6130@tuxdriver.com>
References: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com>
	 <1191066581.22960.55.camel@johannes.berg>
	 <20070929161740.GB6130@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qXOS2iqp0/dVD6x4vtw1"
Date: Sun, 30 Sep 2007 10:43:35 +0200
Message-Id: <1191141815.22960.134.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qXOS2iqp0/dVD6x4vtw1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-29 at 12:17 -0400, John W. Linville wrote:

> Can you elaborate some on why you think umlme is required for these
> (or other) functions?  It isn't obvious to me that all of these MLME
> functions are so complex as to require userland implementations.

> >  * 802.11r (fast roaming)

Already has a (partial?) implementation in wpa_supplicant.

> >  * 802.11s (mesh networking) (not entirely sure what management stuff
> >    this includes)

Not sure really.

> >  * 802.11w (encrypted management)

All the key handling is in wpa_supplicant so we will not be able to
support it in the kernel w/o wpa_supplicant and I don't see a good way
to do it in the kernel either (not too familiar with the spec though),
and wpa_supplicant already has a (partial?) implementation.

> >  * DLS features of 802.11e

We've had this in the kernel and I'm not generally against it but it's
somewhat strange to have something in the kernel and not be able to use
it. We will of course need some support in the kernel for actually
sending and receiving direct-link data frames.

johannes

--=-qXOS2iqp0/dVD6x4vtw1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARv9htqVg1VMiehFYAQLe/Q//VTvpbuJQ2RjP5ByrYAdWolPFU5stB/pX
I3VOKBHCW1lbBhtU5Z4kVuapzDskXXJnlohjnN9tcfBte4aCPrubLGHHPb5uWwwM
zbOvuOLQy0gWca0UEGTxci4lkcWzngmPwBrDr1W1gkpGXkJD+s7Ea+is/uGqrPaJ
TfPp7tqhSuW4F07wOTA1M9qbf7+Tz5HCrPxt7ucJb/gu4hl1BtJo7KcCLAyXXiAI
igEtwgcTuOPr180N997Pfi4R2gngXVhL00LaDcaGV+21lGEOtuAush2cld18Om8H
HthLOjujvlImm9xnHV37wlyCl0SWhU2T3lsSNFMV5xpRP5u+IgO46lKpvZuTO+Yz
qxgYLG39qrvNbiNLdjy5/KNhCMcdm8hf2A8C/BB8jLZuXl+igqRVUhjkeFTOsYr4
zKVm4c5DO3BBIeNfsfuP4AlbyBgLhL7yHVSTunMGyckp54KzSP9nJZWQyzWNh0Ue
md+h2JRSvT9ReIhMYhC7JH7u4npyZIOHDNFeFZgxrC7cTOWAfYFc+WfG3/HpyFsk
2dqpn/cqgCUnaUa3DZJHxHbm56LrCpwVSD/ErV8HoIqsC96FAMivFx09EpZ2jo82
kV8F0ZODQXEv76TJYLt/YgF8pZ91Tm/rD0f7hbHSzXD35Lp5KlSguWhE9RRZNsCw
gksVvIkV2Qc=
=c+xH
-----END PGP SIGNATURE-----

--=-qXOS2iqp0/dVD6x4vtw1--

