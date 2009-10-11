Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbZJKQDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 12:03:33 -0400
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: John Linville <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	Dave Young <hidave.darkstar@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <873a5pq5vc.fsf@purkki.valot.fi>
References: <1255256361.4095.56.camel@johannes.local>
	 <873a5pq5vc.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eANj4AKt4StwpsqZvQpm"
Date: Sun, 11 Oct 2009 18:02:51 +0200
Message-Id: <1255276971.4095.241.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eANj4AKt4StwpsqZvQpm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-10-11 at 18:59 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > Due to the way it interacts with the networking
> > stack and other parts of mac80211, ieee80211_rx()
> > must be called with disabled softirqs.
>=20
> [...]
>=20
> > +	local_bh_disable();
> >  	ieee80211_rx(dev->wl->hw, skb);
> > +	local_bh_enable();
>=20
> This is a bit awkward from drivers' point of view, we have to add the
> same code to all mac80211 drivers using either SPI or SDIO buses.
>=20
> What about adding a new inline function ieee80211_rx_ni() which would
> disable bottom halves like above and call ieee80211_rx()? IMHO that's
> easier for the driver developers to understand and also easier to
> document ("use this function when calling from process context"). If
> this is acceptable, I can create a patch.

I really don't see the point, since it's just three lines of code, but I
wouldn't mind all that much either.

johannes

--=-eANj4AKt4StwpsqZvQpm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK0gGnAAoJEODzc/N7+QmaQykP/iwoAgB/PAlE/ikVUEW1mMbM
kfUmGA267dHanF9rwoHyT7S75lDekWNZsoLS/qfggXSxHkqvwTkylBBUERqa+fsm
vnrnT5qiyvwnNxbiLtavZb3MP5uErZFMsAvB+yac2tq0jL39Up1T3DR6nQ6a8Grz
FQ8+wpKKYxxFGoISbhL0hx1wZLZ8jN18F/nXT4K0nOtKMlpA42LSGhoKj/Sp+hW8
4v4LLmyBlAm8Fxu7dX874M5c+NU/3qzOvC3t2N4xPbAia26KNyuEkdP1Hk+rF8S2
578R9PRLfcGV8b5x7uzalCaOe+YTtAFokLOco5wjJmTlpRdnziwIMg3oefVj5F7a
nkvxJyoGeeQjBRwnBdLi8eMDe6OwYcsb2d5SRP+kuHXzJgNxPF71d+oiQNxgg7Ow
RkU799570YAR+D+y6cGLcbP8Vfr6W+pjXBI0oTUyOTunp8Rolv3ysn+E0hBv3t51
DAUPAQRSmSvcyhIjZnKftft8CYQxKFcNKjkgP7eQVs7qv2dR4dyb8p1/7MiMI2vK
JtvIRaHebVPIQMiyGSevGHAK2cV/fqC7SxquplBarBgfSZFIOJ+WLbTkljV0YaiJ
4BYnfTosuaKiboQok0ig9knfJBEhPj6ft451sTc9su1SI7m8AXrmACqy4CELMug5
fOMdbV0TZ/54wTgAQ2y8
=0hzo
-----END PGP SIGNATURE-----

--=-eANj4AKt4StwpsqZvQpm--

