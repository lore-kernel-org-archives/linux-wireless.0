Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYFIS2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 14:28:47 -0400
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213035768.5974.46.camel@brick> (sfid-20080609_202251_410579_3BC5FA9B)
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)  <1212997265.698.55.camel@johannes.berg>
	 <1213029086.5974.21.camel@brick>
	 (sfid-20080609_183129_796413_B211C17A)  <1213032085.22220.1.camel@johannes.berg>
	 <1213033412.5974.28.camel@brick>
	 (sfid-20080609_194341_412413_70F0E00E)  <1213033579.22220.8.camel@johannes.berg>
	 <1213034059.5974.33.camel@brick>
	 (sfid-20080609_195423_018122_29F9C06D)  <1213034570.22220.18.camel@johannes.berg>
	 <1213035768.5974.46.camel@brick> (sfid-20080609_202251_410579_3BC5FA9B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PcHtuwgmwZjjbWMgU8KN"
Date: Mon, 09 Jun 2008 20:27:46 +0200
Message-Id: <1213036066.22220.20.camel@johannes.berg> (sfid-20080609_202849_916392_B2D775D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PcHtuwgmwZjjbWMgU8KN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> OK, just for clarity, could you spell out the helper names you'd like to
> see, and I'll adjust accordingly, at this point I think you would agree
> with:
>=20
> ieee80211_is_data
> =EF=BB=BFieee80211_is_ctl
> =EF=BB=BFieee80211_is_mgmt
>=20
> ieee80211_has_protected
> =EF=BB=BFieee80211_has_morefrags
> ieee80211_has_tods
> ieee80211_has_fromds
> ieee80211_has_a4
>=20
> And you'd like to see the following changes:
>=20
> ieee80211_data_has_qos -> ieee80211_is_data_qos (maybe dataqos)
> ieee80211_ctl_is_ack -> ieee80211_is_ack
> =EF=BB=BFieee80211_ctl_is_pspoll -> ieee80211_is_pspoll
> ieee80211_ctl_is_back_req -> ieee80211_is_back_req
> =EF=BB=BFieee80211_mgmt_is_beacon -> ieee80211_is_beacon
>=20
> I agree that does look nicer, and it just has to be clear that these
> explicity check the ftype as well.


> So choose a colour for the bikeshed and I'll get painting ;-)

Heh. Yeah those above seem fine to me. Arguably, "has_protected" sounds
a bit weird, but I'm not going to argue that, let's just do it.

johannes

--=-PcHtuwgmwZjjbWMgU8KN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITXYOAAoJEKVg1VMiehFYEd4P/2FinHmjZajT3zQY3c0EtpDZ
YWE0ZZhEMgfzOi/e4QCo+vc1C7/g7HmCjon45iiukLwCI6avgAKqaaR5Y3pXrWPl
ngdmUzt9zD2t6GdgOZKJA1WdoScsGBUUecFQPOWovtnnuEb95qtvTxSij/gLj/p4
AaeRB/W8+qz8MeP/TJi4ifRq1DDxvR/lVmei7mtVrh96vW8xyZF8OsGsY4SiNuZl
TB4Lv54NkO0o1hxa1wI09KRORpolLu6TfEXQ41BVoiEQz2lT7XXzXwldjB3HGZmw
nww4o2gIDFa/1CCrm1OMTVsNfLeRR5yxDyYsD/jEvbhhGQtVCY+JW8ioJ7ljrMvJ
oyZR0ezl48iSRWkx+/6s071drT3K9HDwUKoF2f0DDDTdiueIN8dxOe2fBMbmXnd6
ZA2j9vbfo6lEO5Gt8j6vXmQFF/kHPYU6a0OsOI/d2RSsHV+NauZqxkQ92ur9cnRH
bLuL0wXF/+4QRDgxh/QiwsIGh4OWjUpz2LA6mQWkSUQuvimBq547mkqI0WMogly/
ZIc59ku5LvgNyVKuOp7oD09AvgIMoXnQgqrkUC1q4waekp6Z1yBKQGoUUtvYDrtQ
iAvVxAQEEe8/CgB0lvTEbko2StUxN4HE0amwUiVK+mfyfal1MzwF7wzod1REzUcB
DKQe4nARhnDxPLFY5u7z
=YG27
-----END PGP SIGNATURE-----

--=-PcHtuwgmwZjjbWMgU8KN--

