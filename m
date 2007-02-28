Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXB1Ptk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 10:49:40 -0500
Subject: Re: [PATCH 14/28] rt2x00: Create rt2x00lib module
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281643.13490.IvDoorn@gmail.com>
References: <200702281507.13004.IvDoorn@gmail.com>
	 <200702281634.47330.IvDoorn@gmail.com>
	 <1172677140.5015.22.camel@johannes.berg>
	 <200702281643.13490.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-36vJs1dGV48mEFFbfIsR"
Date: Wed, 28 Feb 2007 16:49:14 +0100
Message-Id: <1172677754.5015.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-36vJs1dGV48mEFFbfIsR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 16:43 +0100, Ivo van Doorn wrote:

> Nothing depended on RT2X00_LIB, I only had the drivers select RT2X00_LIB.
> So something has changed or I am missing something. ;)

No, I found what's up.

You need to change it to

config RT2X00_LIB
        tristate
        depends on RT2X00

(note that it has no human-readable name)

Btw. It appears that you can build debugfs support as a module while
drivers are built in. Not good.

johannes

--=-36vJs1dGV48mEFFbfIsR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5aR6/ETPhpq3jKURAhLWAJ9wmz39cwvcpOJd8YgRaRAVVyhMDgCeL6zJ
icDleEzLPslk+UDMkl8EtRY=
=+1sk
-----END PGP SIGNATURE-----

--=-36vJs1dGV48mEFFbfIsR--

