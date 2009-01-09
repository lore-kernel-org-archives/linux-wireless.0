Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbZAIKGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 05:06:08 -0500
Subject: Re: drivers returning wrong results from their _tx op
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
In-Reply-To: <87hc4828xn.fsf@litku.valot.fi> (sfid-20090109_091429_663068_48C13A9D)
References: <1231193264.3697.41.camel@johannes>
	 <b6c5339f0901051424q12d8fc14o8f20b62cfacc4e6e@mail.gmail.com>
	 <1231246859.3503.0.camel@johannes> <20090109022347.GA5077@hash.localnet>
	 <87hc4828xn.fsf@litku.valot.fi> (sfid-20090109_091429_663068_48C13A9D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2t4Dz2+mvXX9WqpWzUZL"
Date: Fri, 09 Jan 2009 11:06:33 +0100
Message-Id: <1231495593.3703.1.camel@johannes> (sfid-20090109_110615_881921_3CEA39D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2t4Dz2+mvXX9WqpWzUZL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-09 at 10:13 +0200, Kalle Valo wrote:

> > @@ -1170,6 +1170,7 @@ enum ieee80211_ampdu_mlme_action {
> >   *	configuration in the TX control data. This handler should,
> >   *	preferably, never fail and stop queues appropriately, more
> >   *	importantly, however, it must never fail for A-MPDU-queues.
> > + *	Returns NETDEV_TX_OK, or NETDEV_TX_BUSY if it fails.
> >   *	Must be implemented and atomic.
>=20
> Based on discussion from netdev I have understood that NETDEV_TX_BUSY
> is not recommended, it's better to stop the queue already earlier,
> drop the frame or store the skb somewhere else temporarily. Johannes,
> have I understood this correctly?

Yes. Well, returning BUSY _should_ work, but I'd like to remove it and
the complicated retry logic from mac80211. Only adm8211 really needs it,
afaik, all other drivers can just drop the skb in error conditions,
adm8211 can only transmit one skb at a time so needs this for fragmented
frames which don't adhere to stopping the queue, unfortunately. This I
may change at some time.

johannes

--=-2t4Dz2+mvXX9WqpWzUZL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZyGmAAoJEKVg1VMiehFYTFAQAIZeRC5gHpETgK4LJVgOHtYO
oDgtJuwNSHNbRRjbAXbzLDsNRfJdWq2PFKPd3t0DQEJj+avaUhBcetkqaO1kz01Z
S1kHE2x6bs0cb6AWIFj6cm1k80v3VqnoX9bjgZpt4C4PYwQZa4NeRabP08me/MYl
AJD/gWJ8x8h4+JvkJKQHTJLpv5fVi+yzNg4R590Q227exOdhtsqYHztvhKgul+pv
o87pomu0GBy5H6gYbZII9gzsM3OiygZOif/J+HlyNrwdWk+uDCV89KSsqZxn1Q2i
0dJtF7osnwl0WxOGcyXcp411qjXaZ6UKFsMbzkfRhcFT+cfx3bOmkfwMv9HCQzXz
2wApS6qUT6O5Qrvm9PBDj69jFCqzam5QYhSTLwmTgU9ivnxVKRvoc8Ay63FgibrL
h1O+4GPW7vBvwYv6e1V7ib+TPoHuiCP0Hz9k9h2P4gAP1iDFLLpTSHg0v5wVIAr1
X5/TYgAef19bSEqPtV1pkaEqaEqGishgQfThsGQgrFDOnfB/xghriN8ANtHgN5At
EBK7YLGsIekyZ2gDSTWC06vfeV37bb4JliwwfcTMF0tqfWbpLLdLYJpfP3hhRV2+
amdA0V8YwGveU1BzGuAbCMXKpRREijVJHIIxaP2W6IaArzrZL6/0zRGKv//ae+7L
YWb1nkAczncrIK2aQMr6
=V5Vq
-----END PGP SIGNATURE-----

--=-2t4Dz2+mvXX9WqpWzUZL--

