Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50320 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbZCMMPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 08:15:45 -0400
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <200903131310.44757.helmut.schaa@gmail.com> (sfid-20090313_131127_797518_A5C6CFBB)
References: <1236939917.5235.7.camel@johannes.local>
	 <1236941339.5235.14.camel@johannes.local>
	 <1236941444.5235.16.camel@johannes.local>
	 <200903131310.44757.helmut.schaa@gmail.com>
	 (sfid-20090313_131127_797518_A5C6CFBB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x5Lr0z2YenZLiw8rJEwr"
Date: Fri, 13 Mar 2009 13:15:09 +0100
Message-Id: <1236946509.5235.37.camel@johannes.local> (sfid-20090313_131548_491767_27AA84D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x5Lr0z2YenZLiw8rJEwr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-13 at 13:10 +0100, Helmut Schaa wrote:

> > So does iwlwifi.
>=20
> Mine does not. I got:
>=20
> mac80211-phy2: failed to set key (0, XX:XX:XX:XX:XX:XX) to hardware (-22)
>=20
> iwconfig still shows signal strength etc. but no packets are transmitted
> anymore.

Ah, I had an open AP.

This is due to iwlwifi still not being fixed to use the sta_notify
callback rather than the rate control algorithm to add stations to the
internal map.

johannes

--=-x5Lr0z2YenZLiw8rJEwr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJuk5KAAoJEKVg1VMiehFYGVgP+gPKrS9CEXdxDSZXRyWji06j
vpEtSOQOkDy7/ylOhQgwHe0X2wz5k+5DLzXz6f1gnq8amoM46XECG8YFMvSRUO5j
93cHCF/j1jzQzkbB82F2O/c8WglWY6LxEPsnb/G8Dzs9iRN8DxOZRC43SG1uCian
YGdvK7k1KTOUFwNIOV0n25a1nXIFn/QKx1L/J8S/ViY3+B+Zilwhu8/QZA8Pd/e+
nUzq/fTGsEUxOuiFfiMPGfTDy0lADyjIMCp43/Zl9WG7tfF4dLsHGvaeVENkLZxq
qvHF5mu3UrbBMab2WAPmFiQacxg8dhhF41Z0WeOhFZhrGWq2+F/9eo1Kqb0Re4K5
R5hJYw6AkpKK0sXXa+YNPRrFGRhC4KcVnsD/aEvKHunkwVH2ymQrZe+evTHmSGVh
SAHjnOyJIOs6K1W+oSSVKUk79Km4VtLh0yLQACN3h2Ax/K3wDosczeoZhN3Y3qpa
BY+NJh4q1ZTDM9HeNdiK21Tb0ZTusozeMRMLrUl5xXdNayXcjhnQZmgsNCARtnO4
Gtzp1wrlVHgt51oodZJ9gExB/CyliMpctzz3I1/VCy8YqalBAUfIZwlXfrnKY/6Y
TzRgpc5N+8xSa4VS7SdzgCHG6BGJIuPGl0DJanLdeGC31eIZf34FQ4wU0w7M1NlJ
Q04uPffAc2cBJA0nMBu4
=uDwT
-----END PGP SIGNATURE-----

--=-x5Lr0z2YenZLiw8rJEwr--

