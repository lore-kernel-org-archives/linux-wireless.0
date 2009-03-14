Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZCNQHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 12:07:23 -0400
Subject: Re: [PATCH] mac80211: don't drop null frames during software scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49BBCE18.4090606@nokia.com>
References: <20090314144405.670.16447.stgit@tikku>
	 <1237043931.5235.67.camel@johannes.local>  <49BBCE18.4090606@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ad1dnZ6UVArYxC7WKcLt"
Date: Sat, 14 Mar 2009 17:07:19 +0100
Message-Id: <1237046839.5235.86.camel@johannes.local> (sfid-20090314_170734_362051_D492D2DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ad1dnZ6UVArYxC7WKcLt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 17:32 +0200, Kalle Valo wrote:
> Johannes Berg wrote:
> > On Sat, 2009-03-14 at 16:44 +0200, Kalle Valo wrote:
> >> ieee80211_tx_h_check_assoc() was dropping everything else than probe
> >> requests during software scan. So the null frame with the power save
> >> bit was dropped and AP never received it. This meant that AP never
> >> buffered any frames for the station during software scan.
> >>
> >> Fix this by allowing to transmit both probe request and null frames
> >> during software scan. Tested with stlc45xx.
> >=20
> > Would it make sense to reorder the scan code instead?
>=20
> Perhaps. I chose this path only because it was simple to implement :)=20
> I'll take a look at the scan code in more detail and fix it there.

You're kinda right too, we want to disable the queues first, then set
sw_scanning/notify the driver, and then send the nullfunc, I think. So
it's either this patch, or iterating the interface list twice.

johannes

--=-ad1dnZ6UVArYxC7WKcLt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu9Y0AAoJEKVg1VMiehFY/YkP/jW2OSrZTHyp3B7SU7n4n7mQ
Vdw4a8AupyeRqL/QXhuM/grWIegS7/S3pdR921jV6kq2lc5kLv6BTY45JI7L5I/X
Mabe9inO+4Y2YYwqFxAefFZZQUWrWx3xUH78avIVvvkHoFEH+zmVQwv6pG4Qp2Et
AlANMIDOM62Orb2eNdZrSIW+X34IN+o2c4eyFDKoJUIqiJrdaJ+RI77usDgsQPfB
qJVCmsd2df0uuA/PlsUqixhv43nHKXXu+neKa2t8O7AXz8fm+tYsPTU0rOjBcdKl
G6rxNgD36PYM29H340sxa0wT0R1D0gIcRVHFmb7f18oZB90zI2uNoanwFq5ma22j
YlWBiaB2zlxjIorWZSLcpALqkkrz7u4PPwh0FKrg9xSJqzD+l/QsXQGdVCMV+C/v
es32wOjWqZcl5XOGX5OJf+/gkiPJXoJkZjgtDKSgEwTCZefS+DwErAZikCGYwaiT
WPsMx1vvGZq3WLJ5xft4J+/oKrSVxbWg27z/juFYpMm7zrSQGEKavoHLkVYDsPw9
coD1wyVsglgqZ6/zyrzcv5GuEkzUHQLF/zpYwJZpfgn73vSis6kVMN3ARwsoYt1C
RB143MpaGM6wf95/9bCFmkhsxYrLqVf92Ir6pFrOSqc17UtLvHUYvZBQMDu6IFUX
a6fPLdXR45TxoMn+5880
=qmb0
-----END PGP SIGNATURE-----

--=-ad1dnZ6UVArYxC7WKcLt--

