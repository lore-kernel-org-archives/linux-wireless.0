Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYHGTpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 15:45:49 -0400
Subject: Re: [RFC] cfg80211: keep track of supported interface modes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890808071102t281f3c4ctb9d1f1c5822dbc8f@mail.gmail.com> (sfid-20080807_200211_500676_B1F52107)
References: <1218122495.3630.2.camel@johannes.berg>
	 <43e72e890808071102t281f3c4ctb9d1f1c5822dbc8f@mail.gmail.com>
	 (sfid-20080807_200211_500676_B1F52107)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZNjX8c87FnDegkHzeDpo"
Date: Thu, 07 Aug 2008 21:45:23 +0200
Message-Id: <1218138323.3630.57.camel@johannes.berg> (sfid-20080807_214552_902265_81095E0C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZNjX8c87FnDegkHzeDpo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > --- everything.orig/drivers/net/wireless/b43/main.c     2008-08-07 16:4=
9:57.000000000 +0200
> > +++ everything/drivers/net/wireless/b43/main.c  2008-08-07 16:57:12.000=
000000 +0200
> > @@ -4165,11 +4165,11 @@ static int b43_op_add_interface(struct i
> >
> >        /* TODO: allow WDS/AP devices to coexist */
> >
> > -       if (conf->type !=3D IEEE80211_IF_TYPE_AP &&
> > -           conf->type !=3D IEEE80211_IF_TYPE_MESH_POINT &&
> > -           conf->type !=3D IEEE80211_IF_TYPE_STA &&
> > -           conf->type !=3D IEEE80211_IF_TYPE_WDS &&
> > -           conf->type !=3D IEEE80211_IF_TYPE_IBSS)
> > +       if (WARN_ON(conf->type !=3D IEEE80211_IF_TYPE_AP &&
>=20
> When would we hit the WARN_ON() ?

When I make a mistake in mac80211 :) Might as well leave it out.

johannes

--=-ZNjX8c87FnDegkHzeDpo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIm1DPAAoJEKVg1VMiehFY5cMP/RZk9j5l1u1nQBvn3Xe8TsYQ
7hTwgrJPZgt3y6+dx0Tosq44f6hs4YgCTfIHE3L9HMVMdh/6LvA6gasttR1dAMVZ
oEXtx4r3NWGxEgWrEbCTvdpzpdAr9tmjaPifWgAMV+YMn5NDhCEx77XaswMvg/qZ
qfpC7bySLBhfzRpEwxIQ8I6YFan+fcnLKaT00FfNF9+/EZNUq3/QyeIYS+q3wVmi
NsViw0TzQzH1cC/KJnbEOAtGQ9lNM4RmhCBjQnr1UotAlVBqsXox2sE8ata8qGHd
N4gRtZCgzaertlF0cZdmQSE6IQ5lfkkDuk68vjWfjSPi6qVhF8bXwWJ+eQK5vI25
F3WzRirBbrKV087/NzRjyfmwQ/2lftXpW0UK/V4tDO4uHzju63Kv4bwNtaLNrHBK
12g8CjcVZotq6MxRzilPkb9A9TKS16grDUlCa6/rm5naO/LA9DJ3gESQCXawRGxD
t6nv8yhVJj8UKct6K5KKA70GLmgdpXvewbyTk4hw0s2qkb/SK+5xQYSjV7FDL6Iq
GIUc3s3VNw7g/74tHYsVuTQXmkaaIprlC8ujjW4NE/6sTGbNaFimaiPdfNAEmbeI
3VURw1KbvR2N1gYA63VWg+4v/8nqIox00HhwuTuXmVe8/C9OnH33SAuet7HXQEka
XDsqq/0gyf02UvJLxitf
=ibS7
-----END PGP SIGNATURE-----

--=-ZNjX8c87FnDegkHzeDpo--

