Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbYEFJgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 05:36:52 -0400
Subject: Re: [Rt2400-devel] rt2500usb current git BUG
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Luis Correia <luis.f.correia@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a32f33a40805060206l1af71db0tced88dd3d3d08c30@mail.gmail.com> (sfid-20080506_110602_337149_389629AF)
References: <efe7343f0804291454p40914cadpf06846270d080e2@mail.gmail.com>
	 <a32f33a40805060206l1af71db0tced88dd3d3d08c30@mail.gmail.com>
	 (sfid-20080506_110602_337149_389629AF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mIt/HDS+mAfQFWerwjnN"
Date: Tue, 06 May 2008 11:36:11 +0200
Message-Id: <1210066571.8012.73.camel@johannes.berg> (sfid-20080506_113607_944214_EAC27E8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mIt/HDS+mAfQFWerwjnN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The real problem is with beaconing, the only way we could get around
> this issue is
> creating a local skb in which we store the beacons given to us, and
> after all iterations
> are over, write the beacons one by one to the hardware.
> Obviously this results in race conditions where the beacon might be
> written to the
> hardware while the interface is being removed... Which would mean we
> could end up
> having to cripple rt2x00 again and remove all support for virtual
> interfaces... :S
>=20
> Johannes, do you have any suggestions?

Well you could
 (a) keep your own BSS interfaces list but you might need a mutex and
     two work structs to make it flawless
 (b) provide, in mac80211, an iterator that takes the RTNL instead of
     RCU, I think that should work

johannes

--=-mIt/HDS+mAfQFWerwjnN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCAmiaVg1VMiehFYAQIZKg//TrkThtE/F5Tzkyb26mWtN8ZOLn8mdo8g
tjoV2Aw7vp96SqsGnw2qPkctmoy4jpT4y6e/ke08gioGC3uR/zk4X1y1oH9BAm43
VbDqdho1u0Fden1KJxNAcJ4qaewk2prEArO35UxOQYH5Lm9Q4WP6nasQavQq1fJ5
feOsnoKRcEv5e0Tf2FxYjDMRQSlQJpCjf8YFvrg9qHTjEDG3QsrDKvwpbYVPvF/5
8SFM0ZGrmjqzklLhbgZYgkIk3Ct2+yVST3hFHVDFz6Jkrht/uFF333/kWx7mlW/v
X5Lbu6NcW6FoaqyW5KGBr3tYVq4K2/uiA5L2WW16jCnuSK5wfK9T+IEMbqPR5DfO
UPbOkV1akzT6+mxz5M2HoggNukZM+Kd6f4uogFO+q2WxuIA+kMJGNOS9lCH7wgKx
DeJW/cJ/sq36IcMJRAOyi7dYZCx9ONCsiMcQZR/fjM/x3nvO8SarK8shrSe5+fkN
+BEwvelxIPf42e6F+HdMi9e0iztNcDMqbFenLrD0B7AhtB/iNM6K1de0yBdDfXDE
fjDjlbo702Uwgkv40v6aqXZpB8IpTAliVI2lZ3ynT89HODGPWtQjQDfgr22z3/O6
TLbkDSP59xb+0hpXHvwkCezmEDWL6//aIPqsyfWBTnAiffWXhX8b2eWahpmosNPa
4O4W1SR4nGk=
=Yru5
-----END PGP SIGNATURE-----

--=-mIt/HDS+mAfQFWerwjnN--

