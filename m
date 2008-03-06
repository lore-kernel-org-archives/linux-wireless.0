Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935080AbYCFSG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 13:06:27 -0500
Subject: Re: [RFC] mac80211: handling Qdisc issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	root <root@localhost.localdomain>
In-Reply-To: <200803061902.33865.IvDoorn@gmail.com> (sfid-20080306_180316_223106_0E5FAF45)
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
	 <200803061902.33865.IvDoorn@gmail.com>
	 (sfid-20080306_180316_223106_0E5FAF45)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xHipbYxXs5RoZ1eVJvBP"
Date: Thu, 06 Mar 2008 19:06:07 +0100
Message-Id: <1204826767.25502.135.camel@johannes.berg> (sfid-20080306_180701_932464_1111A603)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xHipbYxXs5RoZ1eVJvBP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > +#if TODO
> > +Is this correct??
> > +#endif
> > +	rt2x00lib_write_tx_desc(rt2x00dev, skb, control, queue->qid);
>=20
> This is incorrect, even though it theoretically would work.
> The qid !=3D queue number, for most TX queues the value will be the same,
> but the meaning of the field is different.

Hence my #if TODO which causes sparse to warn about the code :) I meant
to ask you but never had time to continue working on this patch.

> Resolving this issue will also be something I can fix relatively fast aft=
er this
> patch is accepted and applied to wireless-testing.

You could also just make a patch for exactly this and ask Ron to merge
it together with this?

johannes

--=-xHipbYxXs5RoZ1eVJvBP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9AyjqVg1VMiehFYAQLt8w//URBcDDx+aC9uHZ7acQX7N+/PVoDGI0W1
Gr7LuAOChGZYH0LlpzQrgHqvWkWVH2O1OMVE9ekUwD+ZHdQK7vjVemjuv2duWkD8
Gs+oJNJsuhWhpLLfciJiOfqwwtM8/w/7URRjzEw8kIq5xanzuefzM5CV4aIW+RCn
fGN1vYvrAv/68InEq2pnVwCp0SKHoMRiYkvD8OeGH/kyjuVhO5Kbq4JGPN+XVjQI
6OLLOswYDNe3xtdjcsAvGiOi/v18EkQNjNswa480x6FTep7yXh2NWESa3aNs4NGy
FHECjDkGPXYkKrBFkBpvI2I8OSkunnSq14K7yGPtnIxvwfZSUiwiXAAi5V8dxbEo
VcdkthCHGnP8bh7HkvCPJkgoI1AzAEdi946nmm1tpC1ZCbTFN1hA97Q0VfKrRitx
Nht7HNd5+WHh8ZcXMT4X76eBNjDMUFkeXTcjGCS26VH1InweLLEDW9nylsn+6rHT
qxKLjSzydOseTnKL6dGIpBG1OtA6quuKHyaO2y6RZwLaeKNCl2gVW2TaFrbbPDEq
YN/aNTd+UVZz1Im3UFBkyZGI/ctImZU+hLdIBhS4GJzIDHDXwuYRWuoI/nnIt8e0
ErWzvNszm1M5TvI5CeYNY/6Os1h+mt/25dYr11AUdQYElz8oKwN4JgOpqCKhelZB
GmmjUUZntTA=
=WQEU
-----END PGP SIGNATURE-----

--=-xHipbYxXs5RoZ1eVJvBP--

