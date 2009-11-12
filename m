Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbZKLTbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 14:31:43 -0500
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
 injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <technoboy85@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	 <40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	 <20091112154440.GD19349@tux>
	 <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	 <40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YI8CXO0j6ZZJJxNqkPK7"
Date: Thu, 12 Nov 2009 20:31:44 +0100
Message-ID: <1258054304.3899.36.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YI8CXO0j6ZZJJxNqkPK7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-12 at 20:18 +0100, Matteo Croce wrote:

> # echo scan >/sys/kernel/debug/kmemleak ; cat
> /sys/kernel/debug/kmemleak
> kmemleak: 197 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> unreferenced object 0xc5cfea80 (size 192):
>   comm "softirq", pid 0, jiffies 14191
>   backtrace:
>     [<ffffffff>] 0xffffffff

that's kinda useless, can you run

for slab in /sys/kernel/slab/* ; do echo $(cat $slab/objects) in $slab ; do=
ne|sort -n

and tell us which one increases most?

johannes

--=-YI8CXO0j6ZZJJxNqkPK7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/GKcAAoJEODzc/N7+QmaC/kP/jOh6/zj4X0YfmS4wuxOkzQd
CzkwVtbdH2zOm3jYu6FhkPxmzy21CCJyDHS7pHs5sPOPjB/IFKSh/tHhdvcjg2f4
phSsHAJarrNHSqApUnDLu4OMjAtSF0zBULqeEkbyYya8QwyijcxuV84Lf+b3MSv6
9I5ixkwHRoi94RbQBi730NyIBbvHn74LNebGSCqJsKNTmdRF5ZiCFYMapRAA38oD
LqR3XN/BVCpGla+WGTko5vptaQ1er+l5ejCaFj2Tm0LljD8m535zpp30STgHxtOx
SkSGUkFTJNVsYqzopGXlEYz47lZikS+hpGD7XXld8+8BgFs/Q+5O5pBz1agryZ1I
Mx1WGQBCu+VfTBcAJnjGovVEN1wak7CoYocZq6wUh10335OqRdnjNbih8SrPhBdd
eKpnEIe6rWhROI3jN1uOUh4O1Vc6/d3ocMOEDCr42Zj10ASGtdeSJNAF4CtDMHHO
WWYuABUD4ykJgjRA+KIFkCWEMu3bqH1DWcXZt7j9xtl3hmBtriDnmM/cE48669gT
9OG7hBI2oEl85JB1Hs70LZpSOyCDKXy2UqmmFmwm5FGwZ5S0PQb2/0SnlhwU/aI9
WkpvyV1b1fHNBbVxvGpVjjOv6z8uQ5X6lC7r1U4G2MKtULwSVQHZvrylNkZmvn84
hbXuJwXkHWIcbN5b07dU
=wOlR
-----END PGP SIGNATURE-----

--=-YI8CXO0j6ZZJJxNqkPK7--

