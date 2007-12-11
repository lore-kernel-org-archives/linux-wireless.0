Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759708AbXLLRIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 12:08:45 -0500
Subject: Re: [PATCH] mac80211: don't use interface indizes
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>, Daniel Drake <dsd@gentoo.org>,
	Yanbo Li <dreamfly281@gmail.com>
In-Reply-To: <1196849900.4121.4.camel@johannes.berg> (sfid-20071205_101838_959371_6E84D3F8)
References: <1196782831.10274.12.camel@johannes.berg>
	 <200712050057.19819.flamingice@sourmilk.net>
	 <1196849900.4121.4.camel@johannes.berg>
	 (sfid-20071205_101838_959371_6E84D3F8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C6+QcLilRmcX51SgqYBm"
Date: Tue, 11 Dec 2007 19:44:57 +0100
Message-Id: <1197398697.2214.5.camel@johannes.berg> (sfid-20071212_170910_494659_654E745C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C6+QcLilRmcX51SgqYBm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Leaving it to the driver to allocate the private space isn't too great =
either.=20
> > Something like a char subif_priv[] at the end of ieee80211_sub_if_data =
and a=20
> > way to specify the length of the private area will be more useful to dr=
ivers=20
> > which wish to use the per-subif private space by avoiding extra allocat=
ion=20
> > and allocation failure handling and also for drivers which don't, by=20
> > eliminating the overhead of storing an unused pointer. It is also more=20
> > consistent with the other apis that allocate ieee80211_hw and net_devic=
e.
>=20
> Most drivers won't ever need private space, so leaving it to them to
> allocate is more efficient.

Uh, wait, thinko. New patch coming up.

johannes

--=-C6+QcLilRmcX51SgqYBm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR17aqKVg1VMiehFYAQIkJxAAj6ky0Se4UOlkESPPqMYel98q2SJsyX8R
SONY1HL7UYM+RauRi31xhlK2V2zLB/zWg6WvkMfoShUG8pn536ehqNksujos+gd5
i0Rf5rSBxw6MrCrOgwSN0MNkC7vvA/bXVck0GIaagxbSh6ZjWAVxgkWTRNUlmW5a
JAAZpZ83Sgfq3BwvX8uoHr9kQSzv1U1wP7Tl5GaMeYLycfF5lMrKL6lNsqQuQYGG
yxP6xoz5JOeqwdSv5sK/wO/84cf5Z5vqV79Ph23zqzUUleO+sNaziI76ed+mlXIc
UC6uAmOapY/sCKZkhYfN76iozhoSIJJkklsFp74yFLjd2jPaoNWfUPYS5U2wrdIb
BVgK3tcIRnIEhpuZ/M4FE7wsXsNG3lRnTFfLyUEN/RNyJuQzAQKTNX/4irc+5txp
2tGArax5sxHXnilqFUD9BFKRHzMsDdzE/6cctqCdthwqMCBGl9P3zUZBHrGT3cQt
cpNJSsD/MM18VDXQUgJG5BbKl8dg1/eZm5IyTG3OpFQ2LxP9cdhREO55sr5ncnSu
ZKK1FemIqG3qbNi1WXmQeO8vLBf2ccM01j79knOR+0oAuiieDrvcSlYgUwrBCO6L
S+bF8KpJyQLOwpxJyeQ76KkkOGNJYN12ZuCKRfcuQahYb+SNEvvrWW2KXgO70DVI
qEsRnxFyBEk=
=mhkI
-----END PGP SIGNATURE-----

--=-C6+QcLilRmcX51SgqYBm--

