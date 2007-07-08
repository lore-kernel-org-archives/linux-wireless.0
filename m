Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957AbXGHVXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 17:23:52 -0400
Subject: Re: Arrested Development
From: Johannes Berg <johannes@sipsolutions.net>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: Andy Green <andy@warmcat.com>, Jon Smirl <jonsmirl@gmail.com>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20070708203717.GA15957@deine-taler.de>
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org>
	 <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de>
	 <46910F3F.8010201@warmcat.com>
	 <9e4733910707081142t43a85fb1y383ee8e1835c2842@mail.gmail.com>
	 <469130E8.1010608@warmcat.com>
	 <9e4733910707081204l490e99fcm6b8780f36ef8b9a8@mail.gmail.com>
	 <46913846.9000007@warmcat.com>  <20070708203717.GA15957@deine-taler.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7dSNt8jxyMBjh0VwQpJO"
Date: Sun, 08 Jul 2007 23:23:34 +0200
Message-Id: <1183929814.3771.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7dSNt8jxyMBjh0VwQpJO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-07-08 at 22:37 +0200, Ulrich Kunitz wrote:

> I just wrote a patch, which forwards now all the received packets
> on ZD1211. Right now no FCS checks are done, so you will see
> suspicous packets with strange packets in Wireshark. However you
> can see now also packets going to other devices.

This isn't going to work properly when you add a sta interface and then
a monitor interface, which afaict the driver doesn't prevent in
zd_mac_open. Basically, it has the phy always follow the last-added
virtual interface which doesn't seem right. Also, I might be missing
something, but it shouldn't allow multiple sta interfaces, afaict it
does now.

johannes

--=-7dSNt8jxyMBjh0VwQpJO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGkVXV/ETPhpq3jKURAgVoAJ9ML2yVA11hIof09Tq3pJDa1cUf5QCfdEfW
4ENolCw9dGCEI/ISteRl6qc=
=Nulv
-----END PGP SIGNATURE-----

--=-7dSNt8jxyMBjh0VwQpJO--

