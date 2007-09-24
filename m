Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763544AbXIXTZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 15:25:40 -0400
Subject: Re: zd1211 config operation problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>, Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200709241520.50411.flamingice@sourmilk.net>
References: <200709231648.17107.mb@bu3sch.de>
	 <200709241841.50232.mb@bu3sch.de>
	 <1190654401.18521.272.camel@johannes.berg>
	 <200709241520.50411.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-31nq9l+h5jFly9kMnz9U"
Date: Mon, 24 Sep 2007 21:26:55 +0200
Message-Id: <1190662015.18521.280.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-31nq9l+h5jFly9kMnz9U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-24 at 15:20 -0400, Michael Wu wrote:
> On Monday 24 September 2007 13:20, Johannes Berg wrote:
> > On Mon, 2007-09-24 at 18:41 +0200, Michael Buesch wrote:
> > > -	if (local->ops->config)
> > > +	if (local->open_count)
> > >  		ret =3D local->ops->config(local_to_hw(local), &local->hw.conf);
> > Isn't this racy?
> >
> Shouldn't be. Some callers are holding rtnl (ieee80211_open,=20
> ieee80211_ioctl*). Other callers (in ieee80211_sta.c) cannot run if the=20
> device is down.

Good point. I guess the patch is fine then.

johannes

--=-31nq9l+h5jFly9kMnz9U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD4DBQBG+A9//ETPhpq3jKURAhyVAJ4nwIMpeuVDXOaBqeyJ5VOu1NIcpQCYx35U
PWCHiuYdhahHdZMUgTCsQg==
=YAyG
-----END PGP SIGNATURE-----

--=-31nq9l+h5jFly9kMnz9U--

