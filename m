Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbZC0Wg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 18:36:56 -0400
Subject: Re: [PATCH 3/8] mac80211: rework the pending packets code
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090327222251.GB5543@bombadil.infradead.org>
References: <20090323162834.154525349@sipsolutions.net>
	 <20090323163052.298348347@sipsolutions.net>
	 <20090327222251.GB5543@bombadil.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+9DT+1wVX+JjX257lriR"
Date: Fri, 27 Mar 2009 23:36:47 +0100
Message-Id: <1238193407.4452.28.camel@johannes.local> (sfid-20090327_233701_363100_96E41B42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+9DT+1wVX+JjX257lriR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 18:22 -0400, Luis R. Rodriguez wrote:

> So this is good functional change, might be worth mentioning in the
> commit log, that is, we now requeue onto the pending queue the skb
> when the driver's tx() didn't return NETDEV_TX_OK or when __ieee80211_tx(=
)
> returns IEEE80211_TX_PENDING (which happens when the queue is stopped).
> Maybe even better as a seperate patch. Before this we were just dropping
> the skbs in the pending queue under those same conditions.

Hmm? We always did that. Well, we didn't put it on there directly, we
kept it in extra_tx or whatever it was called and then later pushed it
over to the pending_frames thing.

johannes

--=-+9DT+1wVX+JjX257lriR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzVT8AAoJEKVg1VMiehFY578P/i1a+Y5Zj2lVmnbhPgx4FmUp
BjVT7rFtH4Kx5R++1p6WVA6hELSBRrV759FJbI4gkPoshjpiorq7QzUCRAy487/G
NttaR/3qgO7vrjz/egFMJwLdbqfZs4/P9MDNJpZafQLaCXpb6Fl+UxubHLhoFehz
yEtM86N8h40oA64/4i7QaQt4dWlXKRZMu23leRd0lmMNX6DznuOJhkWRIASPF2qJ
xYBlvHsd85430LVeHMerAF7myUgxO+OVJNRCxIjYDpYa16zNfGNT2BaQco+/VgUb
w174saJUlxC9k/ARqb9fxZobzGz1CEGeHzskHYkfNr4OCYOgWiIGV2m/5Kki238E
EvHnZARzDf092QT9CJDAtG8Euw5+v7BBVfXWiAIu4idOr9A633Njtlt9VlwyFqgx
uJotN/AKtOQLZpCsx325KSlsSjf43GfCOvtulYOtVJt9j+lajrwag9AxDbDzu1fa
X8Ld0q3JTDAKPsy2CjEdlmQsLv3vSOi7yYNh0mxC/PRFyiJAoXUG+rBZJWxQ9b9e
KkcN2DwvXbjyiOycdP6MHw5nWthp8uPYhCCYOAA0EeeoJDvdZ6CpK24eAHsxhIYb
K+ZOSKmYNAxO+cP02yHVKsQ66WFhWKcOQR1qd00b+yJwVxCbmlbn/ebLDzTwkicM
lgm1DWMTWztWkHlPwrTi
=Xuzo
-----END PGP SIGNATURE-----

--=-+9DT+1wVX+JjX257lriR--

