Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332AbZCYLir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 07:38:47 -0400
Subject: Re: [PATCH] mac80211: Fix bug in getting rx status for frames
 pending in reorder buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090325111947.GB21025@vasanth-laptop>
References: <1237978407-5397-1-git-send-email-vasanth@atheros.com>
	 <1237978973.4320.154.camel@johannes.local>
	 <20090325111947.GB21025@vasanth-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tSiCpnEdzpM6nD+4qGt9"
Date: Wed, 25 Mar 2009 12:38:14 +0100
Message-Id: <1237981094.4320.158.camel@johannes.local> (sfid-20090325_123850_899724_30C9026E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tSiCpnEdzpM6nD+4qGt9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 16:49 +0530, Vasanthakumar Thiagarajan wrote:
> On Wed, Mar 25, 2009 at 04:32:53PM +0530, Johannes Berg wrote:
> > On Wed, 2009-03-25 at 16:23 +0530, Vasanthakumar Thiagarajan wrote:
> > > Currently rx status for frames which are completed from reorder buffe=
r
> > > is taken from it's cb area which is wrong, cb is not holding the rx s=
tatus.
> > > This results in dropping almost all frames from reorder buffer when s=
ecurity
> > > is enabled by doing double decryption (first in hw, second in sw beca=
use of wrong
> > > rx status). This patch copies rx status into cb area before the frame=
 is put
> > > into reorder buffer. After this patch, there is a significant improve=
ment in
> > > throughput with ath9k + WPA2(AES).
> >=20
> > Interesting. For ieee80211_rx_irqsafe() packets this is already in the
> > cb area.
>=20
> right. I will change the commit log.

No worries -- just pointing it out -- this is the reason it worked ok
with iwlwifi.

> This is while completing reorder buffer on reception of BAR.

ok... this code is a little convoluted, so I didn't see that at first,
thanks.

johannes

--=-tSiCpnEdzpM6nD+4qGt9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyhejAAoJEKVg1VMiehFYlHQQAKEaF92luHFYD50AFiUCSwT+
IvdM9mGs+oIUMxBeHaBY4fj2x4dCVKaqq34ISKjvsb3FvLB6zGfYdTWlLKfIM23A
OC2hMShxoS8qcLDkp4PgUyIOkW4SfhpbgCKCGMQhc1D4AAD+FrJnMMozFw/CV94D
4FvsUg0ikj0mdDPIqfQQx4AjmrOdUPWV+q3C3rXwCAS5OjlL3zfy7DkZ/zFWs4Z1
NPpfi3+wJ+puQAG1G7gZyAnTrnzWn03Q8jUczR348PadIuUEJEJ5/wTKVC/zCPuC
8KYtmUyBkdTmVQz1nIIJ7gadA+iRldZQcon8aFxNrdodE4aaxdCqAppKu6gDL1AC
wlz/XC85pdW7qKP20+rcYfPtYB9lTXJ2ijpsQlIuuy2JgfXSWyEOXJ6eIbzIEq3o
lWGGMdUiDXjt22GMTtx8PWi5+sp+eaPHNiVnG2sXTjj/yCfvQXno/2CAS8f55iw/
t7m6rT0BkA5BJnjeDtKJK7McQqJDluUPkKs0/trGqrJwUetaldC13FXMc/eIy3+R
tNTY7tF4C3uG5MzLU9CFKrxUzBUDahBfmOmv1hxeNTQBBEPUREmECdtz5fDjuneQ
9phXyHkqxBUs9LyPv+W2hW1zmjYLmcynF5Y8RRELrZN9MjGMdEPD4uj++AyBMotc
x14UBEamwKksbrll94jx
=cvlE
-----END PGP SIGNATURE-----

--=-tSiCpnEdzpM6nD+4qGt9--

