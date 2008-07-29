Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46107 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbYG2MHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 08:07:30 -0400
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217333020.6379.31.camel@localhost> (sfid-20080729_140346_036234_85BD2AA9)
References: <1217323927.10489.9.camel@johannes.berg>
	 <1217330604.6379.12.camel@localhost>
	 (sfid-20080729_132329_995714_6D2C9701)  <1217330667.10489.19.camel@johannes.berg>
	 <1217331773.6379.25.camel@localhost>
	 (sfid-20080729_134300_214751_172329C5)  <1217332288.10489.33.camel@johannes.berg>
	 <1217333020.6379.31.camel@localhost> (sfid-20080729_140346_036234_85BD2AA9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-miDVo34IvkqnGLtsMlgb"
Date: Tue, 29 Jul 2008 14:07:27 +0200
Message-Id: <1217333247.10489.35.camel@johannes.berg> (sfid-20080729_140733_522709_AC1B94E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-miDVo34IvkqnGLtsMlgb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 14:03 +0200, Luis Carlos Cobo wrote:
> On Tue, 2008-07-29 at 13:51 +0200, Johannes Berg wrote:
> > That sounds sane to me, then you don't need the cb at all, do you? Can
> > just send it to the master dev with skb->do_not_encrypt set, right?
>=20
> Right.

Ok. How is that supposed to work with crypto? Do each two peers
negotiate a key and forwarding just doesn't change anything so crypto is
effectively end-to-end?

> > In fact, looking at the code, there seems to be a bug with promisc, are
> > you sure it's allowed to netif_rx/dev_queue_xmit the same frame?
>=20
> I see, not doing a copy on that case. Yeah, that needs to be fixed, I'll
> take care of it.

Thanks.

johannes

--=-miDVo34IvkqnGLtsMlgb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjwf7AAoJEKVg1VMiehFYY/sQAK0IwO2ZbxciufDVSFZnMdWm
b8h7WcBtdPycF14iPuwEVw2kibhJge6olUd0MPA2sy+bfR88cTeyi7UfYnlb5z7Q
E2oTUEHPJVi83HRGITJyd5RygODH4xtO43movdx1/mzhJuSCPMXil7zOC3GMlC3S
6YmQXK2Kv7BQ9J9sLCaDPnyy5Jfql9BtoVZz2MCeluQc1FCWBk7rD6WtQG4parA0
2idgDuAv1bwVumw8IiQr4DaL1jDf64wl7u4HSNC9OuCx405DY9u7fJ5UbzX4gYE/
zlbllZIbnKQinLkIM4Bu4MQ47ljaSc/PiTNSzpeJPHRs3GrjxBlbaN0vN9IGyHc6
3uxhCs8awQlobzyaCitG0Qp4/V8GOp3NA6/icKP2O1EfAVH3t0/NWNWN49gM75OB
BQWdw8h2yvh7OKLx40cHAMkOrtayY+S15sJWJ47TZkEywEx93CZf1e9/a3WsK1oD
YxEJ5wtGIKG5qvn0jGTBd+twdLHk1fJ1V9/NW2+yIlp7rbzywoy1iJtttI1yj5ym
UQf/UXXQhGTXN589n2dGGNJqWgwfWTQxA0t1/gOzEhfnscfdSyMfXqm0HYn2npfM
gSvV6qxB28xCgqv1u+vvvR0oECV1blxsNwqL6T6iIgDJRbZc/My8JI6Phwoa68QY
y3V5Sq54UsQKWlvsE+RO
=9PEu
-----END PGP SIGNATURE-----

--=-miDVo34IvkqnGLtsMlgb--

