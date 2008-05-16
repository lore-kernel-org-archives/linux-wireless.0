Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbYEPXKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 19:10:10 -0400
Subject: Re: NULL pointer in mac80211:ieee80211_associate
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Helmut Schaa <hschaa@suse.de>
In-Reply-To: <482E1344.7080808@lwfinger.net> (sfid-20080517_010547_496161_3AD36B80)
References: <482DFC63.7050908@lwfinger.net>
	 <1210974434.6381.60.camel@johannes.berg>  <482E1344.7080808@lwfinger.net>
	 (sfid-20080517_010547_496161_3AD36B80)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FyP0TeZbOrO/SXU3f+Ei"
Date: Sat, 17 May 2008 01:09:57 +0200
Message-Id: <1210979397.3827.4.camel@johannes.berg> (sfid-20080517_011013_629502_6C2B606D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FyP0TeZbOrO/SXU3f+Ei
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Can you try to find out what code this corresponds to?
>=20
>  From objdump with line numbers, it occurs at "for (i =3D 0; i <=20
> bss->supp_rates_len; i++) {" in ieee80211_compatible_rates, which I think=
 is=20
> entered from ieee80211_send_assoc. It seems that bss is NULL. For testing=
, I=20
> have placed a WARN_ON(!bss) statement just before the for loop.

That looks plausible. Helmut, any ideas how to avoid this? Skip the
compatible rates test completely and use all rates in this situation?

johannes

--=-FyP0TeZbOrO/SXU3f+Ei
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC4UQ6Vg1VMiehFYAQJlDg//YNXg8FBqhiFvvMrbg79ufd13E3wceTGv
0uRgoGNLr5Zgssalr5zL1S/EA92QVviKzuZ+SbGxWYjxV8opKUONttrxW5AcKW/A
IUjKjL5HJ0Gvtj53vefUOLkxaMOU0bJeUpPCpmgUc2Oek5vL3zGQIdHh03yu+hgv
Mx3bMR17UMZYxTwMzIgwr4uDstVrJycGPB4/jFKnr/5eCyTr61RcXUA/YJcKl+Ic
SOKkeIA9G3OHTVPuFc3wkoGhxR1GOFnuzccHJbZCTVfofpLdBa6Fxv0LdXVt09oh
PS9TuYWqfKtCi8WYd44v7alvhhxiEQT6UAp0MbKqDEwSRokh+YqV1SNLIjOIECDO
oxty/eP85NVCzV0tD6QhTZO4a9B0gz5+SR7aol52A/IAS4OU4rVFw7VIGHj6U+/v
0rBLDuX9NaqceKJHX0CpbaMfGIubxhVwk+Kk8gsA2VneFzMKf7izCJvR7M5w95nM
jU8DEwqlJSw3Ri+hpCOqZGFzC/G8ZLUKLUp2pP0PI640kGmfg9Q96V+nS1O1roMg
n9GmAYRBtaFKLasgT6EDEBeSpegSm45KfTnJ1hpE6Jwx3cFpzQJ9Hm2L3j50NO6n
ZraZ6cOTPoWIeuVLt/EJu2sX6+78PxO79tsWa8c4/hGFaryL+yL2RCSisUFv1VLp
VeeMUDYu1KA=
=Jctf
-----END PGP SIGNATURE-----

--=-FyP0TeZbOrO/SXU3f+Ei--

