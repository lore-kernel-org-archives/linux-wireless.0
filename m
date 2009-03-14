Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbZCNQJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 12:09:22 -0400
Subject: Re: [PATCH] mac80211: don't drop null frames during software scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1237046839.5235.86.camel@johannes.local> (sfid-20090314_170734_362051_D492D2DA)
References: <20090314144405.670.16447.stgit@tikku>
	 <1237043931.5235.67.camel@johannes.local>  <49BBCE18.4090606@nokia.com>
	 <1237046839.5235.86.camel@johannes.local>
	 (sfid-20090314_170734_362051_D492D2DA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Wnja/f9oqk1VehQnb+Ri"
Date: Sat, 14 Mar 2009 17:09:17 +0100
Message-Id: <1237046957.5235.88.camel@johannes.local> (sfid-20090314_170924_135699_F3F76A37)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wnja/f9oqk1VehQnb+Ri
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 17:07 +0100, Johannes Berg wrote:
> On Sat, 2009-03-14 at 17:32 +0200, Kalle Valo wrote:
> > Johannes Berg wrote:
> > > On Sat, 2009-03-14 at 16:44 +0200, Kalle Valo wrote:
> > >> ieee80211_tx_h_check_assoc() was dropping everything else than probe
> > >> requests during software scan. So the null frame with the power save
> > >> bit was dropped and AP never received it. This meant that AP never
> > >> buffered any frames for the station during software scan.
> > >>
> > >> Fix this by allowing to transmit both probe request and null frames
> > >> during software scan. Tested with stlc45xx.
> > >=20
> > > Would it make sense to reorder the scan code instead?
> >=20
> > Perhaps. I chose this path only because it was simple to implement :)=20
> > I'll take a look at the scan code in more detail and fix it there.
>=20
> You're kinda right too, we want to disable the queues first, then set
> sw_scanning/notify the driver, and then send the nullfunc, I think. So
> it's either this patch, or iterating the interface list twice.

Similarly for the beacon disable part, that _needs_ to be done after
sw_scanning=3Dtrue otherwise it won't actually work...

I think I prefer your patch over that complexity, but would like to have
a good comment explaining it, and possibly one in
scan.c:ieee80211_start_scan that points to that code.

johannes

--=-Wnja/f9oqk1VehQnb+Ri
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu9aqAAoJEKVg1VMiehFYy00P/Aq6lsQMNwgssoXXulh16sJl
i2UjoO4nnZbSlMSOR7mpTagHlUE1Vj+hHu/TkoNupO5ZNeCY0Fcp4BAlWh7tn+ey
AaQKm6szTSbsaf1ThsOjII1mKjVoM0bJRG+LWueeKUlUaiaoU7TdP0khLH6bxkt/
XJ1HBc/ePAGeKqktfoR8A4TXs7gaV3A20H29ARPuVW9nWQyLVLR6ss5nIKrpcsaQ
7wUeVbt3JAh/POpm6an25UaEG0ys/u0llYAxMrGUMy2XKg9IMqENtJ7ElsXJP8Nj
qGDK+0S2H7BbyRikE9j0vYKIzvzb7FxRVGDF5wBOhp7lEM9SgnOXxSs8EjinvoxH
HO88ReFuEwhRzrezU9c3JoDH2mc9Q8a3cu6cN8FksZ3JCLVAkBjeFf3S08Ns018T
dZIKRQz7xO3Mdrytx/jSotlkoA9Kou9uEphXWbjIziwB3aauWXMM+5ZUe3xuR/HR
Tjm/kEZLrnhLKiVrvAZRqdczUMWFxJAZ3jXOgR4jcIaQQdC0yvl4WhH3WG2xhZkt
DVtk9A9X3kGmOUay5fRfYXeKW9I8+p22pGENVKhWK2/zh4asyEpDG1sNIBnSvhRJ
sji79evNog/+ZnjZNw63kKSicNbuKAwrulZezNtcxcEpsbCifJnKprcx6ueCi7Ns
VDf5h1ZVsTnhAqVwfffq
=VyAZ
-----END PGP SIGNATURE-----

--=-Wnja/f9oqk1VehQnb+Ri--

