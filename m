Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60827 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbYDUL5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 07:57:43 -0400
Subject: b43 speed problem over 2.6.24 (was: One more log file from when
	the network was unusable)
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <a44ae5cd0804210400o1ed662aeqb00b9ba5abc61126@mail.gmail.com> (sfid-20080421_120103_595792_DF590691)
References: <a44ae5cd0804161701k1014f3dkebaa1d35f1a8e20a@mail.gmail.com>
	 <a44ae5cd0804181409o3d82c54dl6130d36aa7e5df19@mail.gmail.com>
	 <1208553678.4848.50.camel@johannes.berg>
	 <a44ae5cd0804181446g596daa2yd1be5b1ac7e5e472@mail.gmail.com>
	 <1208555536.4848.54.camel@johannes.berg>
	 <a44ae5cd0804190801n66035332ubedbae99a7b635ce@mail.gmail.com>
	 <a44ae5cd0804190811g10335c22mf10b9ddb2ab568ec@mail.gmail.com>
	 <a44ae5cd0804190814i434dc92bwba3bb33737fbec1f@mail.gmail.com>
	 <a44ae5cd0804191905qb281d7ehf839f80cd753a82@mail.gmail.com>
	 <1208766258.26186.35.camel@johannes.berg>
	 <a44ae5cd0804210400o1ed662aeqb00b9ba5abc61126@mail.gmail.com>
	 (sfid-20080421_120103_595792_DF590691)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i76Of4HLqXU2Bk1ouu/o"
Date: Mon, 21 Apr 2008 13:57:02 +0200
Message-Id: <1208779022.26186.91.camel@johannes.berg> (sfid-20080421_125759_746094_9AF236A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i76Of4HLqXU2Bk1ouu/o
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Miles described a b43 speed problem in the thread

	=EF=BB=BF2.6.25-rc9 -- bcm4306 performance is in the toilet

(over 2.6.24) and not being able to see anything from his logs/packet
captures/... I asked him to bisect. This resulted in

commit 61bca6eb85c863603d6054530e2f65c3b9aba85b
Author: Stefano Brivio <stefano.brivio@polimi.it>
Date:   Tue Nov 6 22:49:05 2007 +0100

    b43: rewrite A PHY initialization

which is a huge commit and hence a bit of a problem. Does anyone have
suggestions how to proceed?

I have very similar hardware, maybe this card is affected by the
boardflags problems we found recently? Miles, can you give us
 * lspci -vn -s =EF=BB=BF01:06.0
 * the kernel init messages when ssb is built with debugging

johannes

--=-i76Of4HLqXU2Bk1ouu/o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAyBDaVg1VMiehFYAQIboRAAjxyXW8lJPkpOizk2RkRnsNJhXMLlv5t9
4cUUPiBksp30vZm+ioqbHgv+l2uGv+zjA+Jt2qIJ+mLn1v+Sv+KwHx4ZIIBWW5ko
RPeLkibSTQWYNrSUKtTYKAfWUNHx8cEqYdhslI2Z0NSTtZdA2ssigLrd75acyni/
VOtLBeR53ZlX4XdCW7puB7+FNyeuyfvelsDr6qnd654X51lsPFWchVW2IZIQge4H
ReRYe857+NDKv0LSdazmuPTdejLXdO8V57ZYsfqlD0uAVBVNNlMnBxI/dr/wEM/J
l8nAFlYRMI2YnhrJ0rknSJSBc/yuK06fhi9CFTiltymwVr+G8gpjPfLCUZiu4iVP
AvSar8x2xtiCzl+GXA4lRn0Y6OHJS4zsb9WkyFtOqt2zBvci7QWAsZPbaLXcN+Xz
q7xoe8omI+o6pZikqb4opqw1VQxA0J9/7DON/mHFX6MTUdNdYrw0FYO+byKKsJhP
BWb+telO6NHGbGeR9MWd/eVyIQQsywN0+xlrrgKMaRp+kbIj0nnrst2/pZzv2kxQ
4QQgWhUN/E4eSz2+EnPSjSWW+quvmmI70q3tCrSD20zUkVvNtZ13qnqI/9N6jIU5
175lxmMgRq0zVwXVW226lfi78dSARoD16ccYGRXQWWPK1nPenhgIi8Zl7Fb32FZa
mTSSVTB8stw=
=Ypox
-----END PGP SIGNATURE-----

--=-i76Of4HLqXU2Bk1ouu/o--

