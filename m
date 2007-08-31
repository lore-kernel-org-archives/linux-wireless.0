Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbXHaKKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 06:10:55 -0400
Subject: Re: [PATCH] mac80211: don't send invalid QoS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <87wsvcksbl.fsf@nokia.com>
References: <1188483732.3978.13.camel@johannes.berg>
	 <87wsvcksbl.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-chyXHJ92FJNsxvafYnA5"
Date: Fri, 31 Aug 2007 12:12:01 +0200
Message-Id: <1188555121.7585.21.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-chyXHJ92FJNsxvafYnA5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-31 at 11:43 +0300, Kalle Valo wrote:

> Now b43 won't send any unicast frames to N800 according to a wireless
> sniffer (and packet loss is 100%, obviously). Broadcast frames are
> sent and N800 replies to ARP requests just fine.
>=20
> I was a bit surprised by the result, so I double checked my tests.
> After reverting this patch unicast frames were sent again, just that
> QoS frames were broken as expected. So this patch definetely broke
> unicast QoS send.

Huh, ok, I'll take another look.

> Tested with wireless-dev#anything commit 60faa0c2 and N800 had PSM
> disabled. I didn't have time to test with QoS disabled, sorry. But I
> can test that later, if you want.

I don't think it matters much. You should rather look into why the N800
is accepting those bogus frames :)

johannes

--=-chyXHJ92FJNsxvafYnA5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1+lx/ETPhpq3jKURAnuiAJ9VXUKBDu1T12aQyyeNyYLHcsxwqgCeJIdU
J7GIPtjU90MYhKUhsPKxesM=
=Lh2U
-----END PGP SIGNATURE-----

--=-chyXHJ92FJNsxvafYnA5--

