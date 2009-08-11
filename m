Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbZHKO5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 10:57:39 -0400
Subject: Re: [PATCH 2/2] usbnet: add rx queue pausing
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <20090811145208.20888.70513.stgit@fate.lan>
References: <20090811145203.20888.83008.stgit@fate.lan>
	 <20090811145208.20888.70513.stgit@fate.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-smVyAYZepQ2E79tgznI7"
Date: Tue, 11 Aug 2009 16:57:37 +0200
Message-Id: <1250002657.13529.63.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-smVyAYZepQ2E79tgznI7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-11 at 17:52 +0300, Jussi Kivilinna wrote:

> +	if (test_bit(EVENT_RX_PAUSED, &dev->flags)) {
> +		struct sk_buff *skb2;
> +
> +		skb2 =3D skb_clone(skb, GFP_ATOMIC);
> +		if (unlikely(!skb2))
> +			return;
> +
> +		skb_queue_tail(&dev->rxq_pause, skb2);
> +		kfree_skb(skb);

Why clone and then free the original?

johannes

--=-smVyAYZepQ2E79tgznI7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKgYbeAAoJEODzc/N7+QmaDbMP/3LDAwpLZdWHSDdvzy1EPO+T
1Nh72cvUbTZBEZZ1CSJz0cc35FWJtuipw/cmnrnkqYaCV0iIMUix5oG8WN6r5UVQ
/QqGlMGCemW2CXi/6+Uftubf9KuM3LNU5FlMoeCO4w12m7PV8r/mqGvUBNpR963e
vd30STFqca7MjhzWlkIt9cGV4cwK9fGll6KPKWzwTdVkmXnTtUd0wccZkS/SnEyr
4vD4xW3HXCu5p+N/fqpwkugSfAei6YN6q7T0qJqH/3mebd09bZ9cOqDJqcW6+KvT
WWBI1jAkHSS8FkgdZ9LSHdDy14KRZGLc2ksDaucjIKnc8szYJtwQVn9iK1RhCy4t
djMmR4Efp2tYUUuNHdVup5vAXMkmK+xKZoOSZoMiL1rNT9spvX91ZcT2Ur1JZIeA
IjsxF1HE+ATOW3N1nO8IinQxlcnFQUdbuar5soJw0rI/gBp4+d2zSvBGl5hOvRWZ
at95aCvXYZmfRRVBXYPuLp7RMzMyKUUml15LE/vqFpxA20vzrpp0KVhMpAsVR/hA
P2cvESeYfsNDJnPEELl/O2+0gxMv4lt6adD27TwXqrAD/Zi+TKR/drfcmh8wA9kZ
WEWWMQxaYI5+ARzs3GkJ7mScW7PDtbV7dJkaV457OyV5s6b6CNkDu18dVNrwOWTa
LBl9gpdKxL9boXI2WZdw
=Tdao
-----END PGP SIGNATURE-----

--=-smVyAYZepQ2E79tgznI7--

