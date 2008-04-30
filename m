Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYD3ONO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:13:14 -0400
Subject: Re: [PATCH 2/2] mac80211: make rx radiotap header more flexible
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <200804292010.21367.bruno@thinktube.com>
References: <20080407042541.9026.59360.stgit@localhost>
	 <20080407042549.9026.81997.stgit@localhost>
	 <1209243111.10943.61.camel@johannes.berg>
	 <200804292010.21367.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XvV247FRuTdvTwc1g289"
Date: Wed, 30 Apr 2008 16:12:52 +0200
Message-Id: <1209564773.18659.14.camel@johannes.berg> (sfid-20080430_161307_067246_5BCA3FE6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XvV247FRuTdvTwc1g289
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Radiotap explicitly allows you to have a longer length than you need so
> > maybe we should just make sure to align things?
>=20
> are you talking about the alignment of the radiotap header itself? no, i =
just=20
> took care about the alignment requirements of the radiotap fields, relati=
ve=20
> to the start of radiotap. but it would be easy to add some additional len=
gth=20
> in ieee80211_rx_radiotap_len() and just leave that empty at the end.
>=20
> i think i don't understand all alignment requirements though...

Well all those stores there are usual 32/16-bit stores which will fault
on some architectures. See Documentation/unaligned-access.txt. Adding
some padding to make the radiotap header start at a mod8 boundary would
help.

johannes

--=-XvV247FRuTdvTwc1g289
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBh+Y6Vg1VMiehFYAQIjaBAAxGylnaNDCMVQSl2eVCOMtUBH80IJ8jAe
+K7LuS2cZLXacS9KHu5SSrzjmYXMNvn5sd+gF3+z3gdwdN5xnIq/YmqpfQ5/uW2A
xnzn9Bp78nPv8/XQxrD5cc9b0D1ARyQpHWhlBaSPHGJElJT2F55KmpFcPqkvkkA0
j21elaYJ0iB+1fjhAerH76xCQ5Uv8Yr0Z79UTvlfly5HFk/2A12tm5aiSg2asiNC
Vg/jQu7FA5XpfD8TqjIYKKAJClnaN6vvN4rqZKVG1qCUGEj1LHFNkDTaw7DFXubE
HujwDOvZMOEs0xRaeVVrlbU6Hih4icxoBARUckyJM7z3H2WpOAUj63ApVLRha3Vf
yW0YIzdlSYgbaqRPojRufvIQORzdQUiJYcPugFYG5iSubaAJMfXV3zndU9dzDCaj
gU+AHkTZWfZxOgoXkP9zOjZVpFTB8lfOC3/FVBdtyBtsyqLVBbqfTH+SGWtdKGJm
UNPJHc7Hxs5LOWKNYtGoHb5kqN2UmK+L5G6I24M0HRaVXwbAfjFAm/evJGEBjaUY
KRtHOgkru4bb+fSqlS+8xYLI+6CfgUUkVSUc0jLqxvf8PYU3iJTCNHKW2M9e768a
6Tb81a+qAm0Iv8Zj3+fncCupH6d33e6LKjsG4OEAIDFGZikDetL+sqYrnP1XOQMu
po9IpE3xMFI=
=nVMy
-----END PGP SIGNATURE-----

--=-XvV247FRuTdvTwc1g289--

