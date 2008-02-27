Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYB0LXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 06:23:46 -0500
Subject: Re: [PATCH 06/10] mac80211: RCU-ify STA info structure access
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1204054013.6947.18.camel@localhost> (sfid-20080226_192522_572761_6E5854EC)
References: <20080225152740.360393000@sipsolutions.net>
	 <20080225153007.340533000@sipsolutions.net>
	 <1203985337.6929.120.camel@localhost>
	 (sfid-20080226_002043_615849_4CE09F20)  <1204014238.13162.201.camel@johannes.berg>
	 <1204054013.6947.18.camel@localhost> (sfid-20080226_192522_572761_6E5854EC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PvbjxJtrERRRq1C+Hh5q"
Date: Wed, 27 Feb 2008 12:23:37 +0100
Message-Id: <1204111417.3729.52.camel@johannes.berg> (sfid-20080227_112349_466110_489627D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PvbjxJtrERRRq1C+Hh5q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-02-26 at 11:26 -0800, Luis Carlos Cobo wrote:
> On Tue, 2008-02-26 at 09:23 +0100, Johannes Berg wrote:
> > I put a del_timer() into sta_info_unlink() and a del_timer_sync() into
> > sta_info_destroy(). That should be enough afaict.
>=20
> That is for the plink_timer in struct sta_info, if I understand
> correctly. I am talking about the per mesh-path timer (the one in struct
> mesh_path).=20

Oh. Good point, I missed that one. I suppose that
mesh_path_node_reclaim() always runs in a context suitable for doing
del_timer_sync() so it should be fine to just do that there, right? I
can look into it or leave it to you, just let me know so we don't both
do it.

johannes

--=-PvbjxJtrERRRq1C+Hh5q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8VIOKVg1VMiehFYAQK4ZA/6Al2+MbNwBxAZMXZ7J83DOEDGv0axKItz
mUbVY9fp4mxDClO/WafvQWAlT0u75fWxO7g3qg1SqbWf9fSEZFKleWOzQ8pZtmYO
LzXN1RKiK12Yh/OCkTZIZcDVnSfKXBtzSdpJvt+QZoPgF4Ez5h+V9WQ1k5e3ZYP/
j3k7irWLqP6SNa1tUveewEf5zhLiEYrYfYCl2S2qHJ6FckfQs0JXBZVtBaM7rpwY
y0lk9p865TmhssbiQojqHv0C3juJqeaxyyjbkSIh8kFvRH2zJFHJ2QIJTG4nEkrr
g4LqUwuhrL95cVdflLrO1nRbDRFnkDbfrpAPCx20WlNAc+3hfEY0nfQ1NS+k0Oo5
bnKk9iNrgN5t/J/EW1K2bj3DbiWbVzEP1V0qpZ2jrGPw5jh7ADYq/iyLhGBxCwAT
TWmljnhuqoCMm0pC9weBh5uw/z4CTRiUpG+GJcsDwOBIR7aPYZXxSoRPhkTquwUo
pMUHad4V7MYmCWWZtK3R0AVmu3UU+7aHbrpbPoxQU3Vn3BA8ZeEcPRtIJfEWcObJ
yLyAwBxSpIpoitljVUNMW2PiwDCuzES2HdrK+M9BVD/SKB1NJ6LXHK15ptWAYDbA
iK60DLgjhavpT131fKI5ExIwraxKC7jWzmrDuEpnNDtyX7WvHhr4IJU5a78IE+u7
cM9IHDkp3f4=
=P3DK
-----END PGP SIGNATURE-----

--=-PvbjxJtrERRRq1C+Hh5q--

