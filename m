Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYABIw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 03:52:28 -0500
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20080102084532.GA17960@infradead.org>
References: <1198253375.16241.76.camel@johannes.berg>
	 <20071230231120.GB16557@uranus.ravnborg.org>
	 <20071231074536.GA26874@infradead.org>
	 <1199263275.4172.60.camel@johannes.berg>
	 <20080102084532.GA17960@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x7oOuyTc/pH/WBEnUCD9"
Date: Wed, 02 Jan 2008 09:52:14 +0100
Message-Id: <1199263934.4172.69.camel@johannes.berg> (sfid-20080102_085230_916053_EB7C9A9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x7oOuyTc/pH/WBEnUCD9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Building an algorithm optionally into mac80211 seems rather odd.  In
> case mac80211 the algorithms should be their own modules and you should
> use request_module to make sure at least one is loaded.

We actually do that but people still manage to mess it up because they
don't install the modules properly or whatever.

> Or if you
> really want to make sure one is alway avaiabable always build the
> simplest one directly and unconditionally into mac80211.ko.

That'd be an alternative too, I think we have something like that now. I
don't really like it that much though because for 99% of people it's
just dead code. Anyway, I'll look into Sam's mail and do a new patch
depending on that.

johannes

--=-x7oOuyTc/pH/WBEnUCD9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3tQvaVg1VMiehFYAQL3Yg/+KnXTtJZVia+X2jHcBkDoKPxbQdM5b7Wr
SpfwKI7hlAw3AnFU+bxakNwwpHYMFzP0rOe55c4/ZLZPnueqlPS/gufX7dYpUBVn
D0e1O1H0OzVVZLTBnsBDK4rvljBiHq9BhaCK1v6yG1D7T2gGaWulDuQihhT6kNdn
tQoNsZw+pIKN3+FBXHJhxFTW6Epth3rWbHCMKyTiKbD3GhsfQt3SRY0BYOh+HHwW
4x3zRdbBHtY/j2oJepkAHZTA2cZaSvckH2nuXk9tyB9b6V0QvKLWeywqEMtPMNSm
eM55UXE1INl0KoNSbq75quAbrKe/rUmABiYsTZdz3Af/BN7R59zvEEDWc0c76tCH
rM0Fv9Q29Cp2FxS7Udop0hHEcDwcmFoGQOfOpJ0MGJRvTHhg7rzGp4aUnfVH74Pj
uPvBkb+3zNpbInPxP1HrZ9vQCIyouqvURLhO+3DCgEdrvXgvzTv3Q0claS+WnHeD
P+iSE9eTAO5NSh0KpNtCch4QOToW+9QM8SlNk4U/QxL7InsoHlP6ohMq91Q+UgwN
JGOGnFPZEVz568790sELkuBkwPEi2t3mptmNEi8H7dUF0dtt4VL6xFbtsNIzIx2w
w0o05WBqQF9/WkWkk4G5EY7EyBnwFCBYjzVhjOqJRJDxYvmdi7CnyelJDI2qlWTJ
33lSiUC14KE=
=AFrp
-----END PGP SIGNATURE-----

--=-x7oOuyTc/pH/WBEnUCD9--

