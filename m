Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbXIJLDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 07:03:40 -0400
Subject: Re: Kernel panic with rt2500pci built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Rob Hussey <robjhussey@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1189420297.4506.26.camel@johannes.berg>
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <1189244217.4506.16.camel@johannes.berg>
	 <6b8cef970709080857s69c055f2s1bc1ce6bd0ad4dfd@mail.gmail.com>
	 <200709081816.10143.IvDoorn@gmail.com>
	 <6b8cef970709080939v42e88426n40b68a3aa85a951f@mail.gmail.com>
	 <1189420297.4506.26.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0Hw/B1ykU+fs4d66DWA1"
Date: Mon, 10 Sep 2007 13:05:11 +0200
Message-Id: <1189422311.4506.52.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0Hw/B1ykU+fs4d66DWA1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 12:31 +0200, Johannes Berg wrote:

> Ok, then the change I proposed to you definitely fixed the bug, but this
> is an unrelated one. I'll have to look why it fails to init the rate
> control when that's built in.

Ah, I see, same bug.

mac80211 initialises with module_init(ieee80211_init); and the rate
control algorithms do the same, this means they haven't been initialised
yet when your device is registered.

Can you change all module_init() in net/mac80211/ to subsys_initcall()
as well?

johannes

--=-0Hw/B1ykU+fs4d66DWA1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5STn/ETPhpq3jKURAqHgAJ9amXJi+yCP1hpGthkXYfsei0GN6wCePajc
rzLQlyWLSqlS824tcn6L/Lw=
=+qLW
-----END PGP SIGNATURE-----

--=-0Hw/B1ykU+fs4d66DWA1--

