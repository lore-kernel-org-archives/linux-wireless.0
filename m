Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYE1Qnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 12:43:42 -0400
Subject: Re: [PATCH] mac80211: fix alignment issue with compare_ether_addr()
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	ron.rindjunsky@intel.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@Atheros.com
In-Reply-To: <20080528151651.GA13461@tuxdriver.com> (sfid-20080528_175821_349548_128405FB)
References: <20080528145048.GB5244@senthil-lnx.users.atheros.com>
	 <20080528151651.GA13461@tuxdriver.com>
	 (sfid-20080528_175821_349548_128405FB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ROFUe35lH+9TCAq3UNex"
Date: Wed, 28 May 2008 18:42:35 +0200
Message-Id: <1211992955.21624.41.camel@johannes.berg> (sfid-20080528_184345_563633_E0CEDCB7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ROFUe35lH+9TCAq3UNex
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -	u8 src[ETH_ALEN];
> +	u8 src[ETH_ALEN] __attribute__ ((aligned(2)));

> It seems to compile w/o errors on i686, and it seems more clear to me.
> Will that not work?

I think it should be __aligned(2) anyway :)

Other than that, yeah, we definitely want this patch. And the previous
one too, thanks.

johannes

--=-ROFUe35lH+9TCAq3UNex
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD2LeqVg1VMiehFYAQKSKBAAhGWNswhDCtlaRaNxP2736J29+N6PSpRR
zTRM+cgOL4o3A5M2tbvWX6pLIqbibCZ+n+XFOXadL+aC3Y2VJ1szg0XG39eooqtA
wocRcqJrI8B8YWSxoCbJzo5M8A97xJ88fCSrbicKJ6/zE+FX398HpykgR201KF7G
scf5jFR1nDceJY+g+AyjzVsaIyH9C1YuZ0K6JGsPnJWOW//LQoFzg2IhZGP/670B
zMub1rw0+s+I8uyuNR2zL/K3oICXopezx4VYnu+ApaLMmhrQGwVmwWpvNhF4svN2
V+fWu65sVSWVm0c7vbwW25RDLo5VANeUhdCHdmMV1Xo6TKAqQlQfUW7vEBBWn6+/
T65zC+KWo69skJDDsG3Jt2LYsNXOrm+1vLRMEr1sBRRB4qR+nb0TYYEH95j+T1zU
NNNmWYk87C7939MJ2cbKcTAZzYr4B8kYMfqjIizNsexH/mpLJ6IRe+z4TgFB//VV
hGYse4NCbQhGnwnPA2CZn6Xztu0LhYtj1u71ONd5YjsVztl4VsIsTCy2oGIFpk6N
WejhGmYUjiwRbYSG4nDhZrONcLp9qBcU5eQMisg0hQ6s4Uv2fdY0kDA9QA3uj5iw
jTYz30zhMBqe8tZu7le1aGFKVEok6AFzNvXn5id9OTrkLuxAD8T8WgII+cix3nGu
hnSh1OuCYig=
=HBY/
-----END PGP SIGNATURE-----

--=-ROFUe35lH+9TCAq3UNex--

