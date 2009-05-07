Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZEGGB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 02:01:26 -0400
Subject: Re: [ath5k-devel] ath5k: scanning while transmitting causes oops
 on 802.11a capable card
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <1241645395.3293.3.camel@mj>
References: <1241626486.30590.13.camel@mj>
	 <b6c5339f0905060936u37f3994cx97cc2344224777a5@mail.gmail.com>
	 <20090506172513.GB30070@tuxdriver.com>  <1241640751.3289.2.camel@mj>
	 <1241641605.4029.10.camel@johannes.local>  <1241645395.3293.3.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XCvCvoncxNCLHoGdrHpz"
Date: Thu, 07 May 2009 08:01:14 +0200
Message-Id: <1241676074.27208.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XCvCvoncxNCLHoGdrHpz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-06 at 17:29 -0400, Pavel Roskin wrote:
> On Wed, 2009-05-06 at 22:26 +0200, Johannes Berg wrote:
>=20
> > Huh? That's confusing. Also, you say you get a BUG but point out a
> > WARN_ON_ONCE, was that an oversight or does something crash there?
>=20
> Sorry, I meant WARN_ON_ONCE.

Ok, no worries, just got confused for a second what you meant.

> > OTOH, I can see one thing happening -- it would access scan_channel.
> > Patch should fix that, does it help?
>=20
> Yes, that does the trick!  Several scans with iw and iwlist while flood
> pinging the AP don't cause any kernel messages.  Thank you!

Ok, thanks for testing. I'll figure out the real problem and fix it.

johannes

--=-XCvCvoncxNCLHoGdrHpz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKAnkcAAoJEODzc/N7+QmalsQQAKramKi8wZWyVvSRMmUyUCxC
dFCHsl1B06CEpI828U8xDX7wLHdJW1zw9dniV4hD8iaNzo/YQNbFivbZUXNLMQ/K
LPtxXK8CjevPeT84iuKc+VBi5610DtMXuRe9Rc3nFxxk5u1A40AuaBM03AX66fFK
o9kz0ebzS20LTLrsBtqFhgLt1d9Vy0SbCnIz4n0lGpZyH7AI1T39xGUt2GsQ6axY
gJnFO35CVG+QlFg2Osp6aXcj3n5OS1UOM8gaP3L3HWivMI6N0D7HWMJzvvnEw+ec
w/8Jb1o9mwUzf9rFeCHcr6Z9zj4QJV9p8dRWWvHMBfhBb3hZmYtOTcrH7ifEzeiT
DoTtN9S/lCyo03kqru11beEzMKqHkSTQ/9i9BeuK3Ntgni1lU0ZxvNqxeNlN8Rsz
9Z4ZDLQd4vgAsAK46SDDoBNhUhPj984iU0k0z6ruEQyTSbT7hpF1m8DHjx1gPwCc
MY0FD2U2K7vmdYKz2bpVuxvd6Hj+xXUMLQT/HUFx6xZ1HmSLwcBaH5g2AJ2hg/0e
L1kBI03jm1PkopFZ7PyyaSvZbNBrlUleymhFZuAkYMEwrp2/uA1jYveijmvPLlUM
a1QG2aUTORdap0De2IMoF8cq4PC3UtoEaM4s60Gyg0UK90WVnimmRDzhzcPM15cQ
0jRvfdjg4ckSQ670Zxmx
=vFHV
-----END PGP SIGNATURE-----

--=-XCvCvoncxNCLHoGdrHpz--

