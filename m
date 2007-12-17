Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbXLRMkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 07:40:09 -0500
Subject: Re: [PATCH 1/8] mac80211: A-MPDU Rx add low level driver API
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197914053.4885.62.camel@johannes.berg> (sfid-20071217_175431_750857_5E14C9E2)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <1197907078132-git-send-email-ron.rindjunsky@intel.com>
	 (sfid-20071217_161337_817126_CF0B10B6)  <1197914053.4885.62.camel@johannes.berg>
	 (sfid-20071217_175431_750857_5E14C9E2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VsqjiQpvhL+yqNgmUOHI"
Date: Mon, 17 Dec 2007 23:38:25 +0100
Message-Id: <1197931105.4885.99.camel@johannes.berg> (sfid-20071218_124019_666300_78520D05)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VsqjiQpvhL+yqNgmUOHI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > +enum ieee80211_ampdu_mlme_flags {
> > +	IEEE80211_AMPDU_RX_START =3D 1<<0,
> > +	IEEE80211_AMPDU_RX_STOP  =3D 1<<1,
> > +};
>=20
> Can both really happen at the same time? Or why are they flags rather
> than just an action code?

Ok, looking at the rest of the code, they do not happen together. But
thanks for splitting up the patches anyway, it does make things more
readable. Please just remove the numbers completely, rename it to enum
ieee80211_apmdu_mlme_action and use "enum ieee80211_ampdu_mlme_action
action" instead of "u8 action" in the apmdu_action callback.
=20
johannes

--=-VsqjiQpvhL+yqNgmUOHI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2b6YKVg1VMiehFYAQK94RAAn88gHNix6FrAccCRG/kdS5+/C29Zzjfi
FjvSlbvPOXpxFL85c8a6U6lE+prxz7LdO4gC/nR4kEAF7QeeRrvfmHWwqxRjsetL
GL/r4bJnUjhD3oXJ9oV7UjFd/5EOI7v19VU0FDe5ePznydlfOIoG6X+9/tsCgUSD
4OLI865gJRn/qVuiYtjHckJHJpGJP0dezp/yC7b4W158hUKtoMxULX1Qwl/QIm7Q
9LvvsYVV9BFnfNlGl2PBKTrN4RnrNxA8BspXgfIr69QSwmGKU/UyDkxWFaOb1EHL
0Tit/f8BD969CCO5oTFKcIAvd0jRTxkcQVk5chxcIm4GoIgthp3MhZLD4iosLj72
/PkXYqU6Nu5EZIOcKpH80ZvJkdgfxJZ/bwRyTrDewtSsuXIDXzrbIDtBcPiC4Aky
Tkh1Qc26A2aSEiC7G2Zv9BJ67/FiwaEecyQkppw1jFUPgSF133VREM7JWco56khY
set1oZiTJnLUi/m4UWW7ywId9ceGr8MmThnrVvs02tgulypu1AFcXWrqnJvm3/EH
xqn2LYKFuEHucCA/2cSeG6SvFJqRgayIX/QhNcxajZS/UL4BS4J8uKWHCy6JQJYg
JYHQCrr7W1wGhbYtkW9pCL//sqWqT+F7Z5c4pgziRIo2BjkVo334mADedCNTuSeX
DjoDvUsdNMU=
=g7AW
-----END PGP SIGNATURE-----

--=-VsqjiQpvhL+yqNgmUOHI--

