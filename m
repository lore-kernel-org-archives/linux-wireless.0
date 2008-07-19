Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYGSRm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 13:42:29 -0400
Subject: Re: mac80211 deadlock detection triggering with rt61pci
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200807191647.13517.IvDoorn@gmail.com> (sfid-20080719_163233_686652_A73747AF)
References: <1216197369.3422.5.camel@johannes.berg>
	 <200807182120.47252.IvDoorn@gmail.com>
	 <200807191647.13517.IvDoorn@gmail.com>
	 (sfid-20080719_163233_686652_A73747AF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QdRSIYQXEE0cBodtpR3I"
Date: Sat, 19 Jul 2008 19:42:22 +0200
Message-Id: <1216489342.29432.5.camel@johannes.berg> (sfid-20080719_194253_064149_145BEE8D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QdRSIYQXEE0cBodtpR3I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-07-19 at 16:47 +0200, Ivo van Doorn wrote:
> On Friday 18 July 2008, Ivo van Doorn wrote:

> It might be me, but looking at those traces, aren't they triggered by:
>=20
> static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb)
> {
> ...
> 		if (WARN_ON(queue >=3D ieee80211_num_regular_queues(&local->hw)))
> 			goto drop;
> ...
> }
>=20
> Which would suggest that when MAC80211_QOS is disabled, the skb_queue_map=
ping
> still returns something higher then 1.

Oh, interesting, could be, I'll check it out.

johannes

--=-QdRSIYQXEE0cBodtpR3I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIgid6AAoJEKVg1VMiehFYEAwP/jX0uCFq7IpUzu8DPPLW0+Fh
kZ1LQGT/T+6/MW4Psp6Rx5N3svEi5YPA4UaBvUoVntlwL2MZvWHBbYRq/Q49qerm
mXShOCs2z3+/QYXs71VJwigipgmpg52ltmD5biuEFZerBhAucQrTiY6Lt+PcYzMf
cqBiuwEst/Spt6Nmz8ufJgXEKQE9S6tWqbrD/63EPX/7WP0RxPCW9ozftxlPOzoW
Kch9j+jlSYTq1y0PJJYET4Y8paHDi9Ht+P529c6PSj6E3sfYZl1glj9MEJWixdZn
2qD4jExsrPfcryzXJL5nE5bLofVLC3NSjSYjmTro26hsok+Rn5UTAzepYNBvC0i1
9Ith36TQ+O5Z7MTkE+e00koCKvzaQFq7xap5SziBVSecJQcMGqOvRl7tc0wE6x0/
bugkxrnGrk09SfugeyXir3wgHmXpj67CacLEMY9+Nua0vuhSNk2GDa5qGQmtXObj
vFl9DGHsC3HFyU/FlPtLhFBSJaMDzGZSVePicYVsVBFqYbLQDdUunWawtFP6TZL5
W8xdvsIBNvKelQQxoLMrfQKDK/vmRBk5ETFp1SXMm9/U/XgGTtMQiAQehnUy/3WE
jTpSIsqL2IaEmBJ+OGtEbaTRPKFKhjp7FohFFgG/JtT5Xu/ab/VT4uLN1p9A8+8A
EeXfa2u9k1bPews7YCIZ
=zvlD
-----END PGP SIGNATURE-----

--=-QdRSIYQXEE0cBodtpR3I--

