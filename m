Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYEAKI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 06:08:56 -0400
Subject: Re: mac80211 truesize bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080501.025635.216053297.davem@davemloft.net>
References: <1209634349.4008.15.camel@johannes.berg>
	 <20080501.024320.212547875.davem@davemloft.net>
	 <1209635299.4008.21.camel@johannes.berg>
	 <20080501.025635.216053297.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Gej+GrGS9KGof12ONDxi"
Date: Thu, 01 May 2008 12:08:14 +0200
Message-Id: <1209636494.4008.24.camel@johannes.berg> (sfid-20080501_120843_142937_6FD636A8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Gej+GrGS9KGof12ONDxi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Hmm. The disconnect between truesize and skb->len+sizeof(*skb) was
> > usually 17 or 19 bytes and sizeof(*rthdr) is only 11. On the other hand=
,
> > I don't see where the other bytes should be coming from. I'll give this
> > a try, thanks.

Even when I explicitly set truesize (rather than adjusting it as you
did) I still get a disconnect.

> Grrr, I bet it's coming from a combination of the
> skb_set_mac_header(skb, 0); call done by mac80211 and the skb_push()
> calls in net/packet/af_packet.c
>=20
> davem@sunset:~/src/GIT/net-2.6$ egrep skb_push net/packet/af_packet.c
> 	skb_push(skb, skb->data - skb_mac_header(skb));
> 			skb_push(skb, skb->data - skb_mac_header(skb));
> 			skb_push(skb, skb->data - skb_mac_header(skb));

But mac80211 does set_mac_header(0) so this should just push zero bytes,
no?

johannes

--=-Gej+GrGS9KGof12ONDxi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBmWjKVg1VMiehFYAQI52hAAt1JyTFvrj/j0CG8e5T5Ck8SKjDCN5BvP
iGgPgYteZw0WH4j0TX1zxLts/aqA3CbQWO6F6m7lyiMon9onWrlp2loJTtb0KtkN
Yh3vpgH1p6Dkn9dF9MzfGamoTumFwJzYyZywAWcwEyj/jDZcf5u7pbO18VHFNdNp
30Z/8wY98mUMvyKUB4Tctub3/b6Wz+XgTcNoZruz/w2JI2Trh9Sv0d5yjCLDUBQt
WpLis10y5lQV+ounA8wicW+S/rZ0hDNu3z2TBzFBAv+URD3pDXP1e3OcTXdlDidd
/N12b+GfjrqhOhiSW/3ANPlfeLwGjYKhGKKOn7Z1hjMsm/XL5RXfebjnpOWLKO9m
9ebAqbF0VyFI9PL47XcAfTSnx+gNgzq7BWk7P+0XGnn+mvXg7TS/KfaUYAbDtqHe
v2j4iqZReK0WSLQBjEwF+HNqmpnb4POGVcl0BsCmZMYlcV/T6X1Xv+Dk1GJxYquR
CZjOhVDWtGtHXwWu7rR766C26Jt6vNFGChLO+tzzw5iWFYsa2vLzU3dhwUthedhx
zHTfgnKiUEm66pqJeEYE8n8erA7W/dBWFpLDahx2uFE6uGON6xnI/wzRT73pKxVz
Vq9rpAEGBXpmGGIYhXPW/UhZUpoJ+l7xlwH0ZN2LAWGrhBvrkjYJSZ/tLX0cysqw
xLd5lDxipv0=
=1jop
-----END PGP SIGNATURE-----

--=-Gej+GrGS9KGof12ONDxi--

