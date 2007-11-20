Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXKTQaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 11:30:46 -0500
Subject: Re: [PATCH] mac80211: free ifsta->extra_ie in ieee80211_stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1195575922.3389.20.camel@localhost.localdomain>
References: <11955417361539-git-send-email-yi.zhu@intel.com>
	 <1195565876.10920.29.camel@johannes.berg>
	 <1195575922.3389.20.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dh3D18WLQF4SEVAviZ/8"
Date: Tue, 20 Nov 2007 17:31:48 +0100
Message-Id: <1195576308.10920.56.camel@johannes.berg> (sfid-20071120_163048_272680_DD19A9A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dh3D18WLQF4SEVAviZ/8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Yes. But if you do that, the interface won't be down either. Maybe this
> > should also be done when removing keys?
>=20
> That seems better to me; although couldn't it also be cleared when
> setting static WEP keys?  Dynamic WEP shouldn't care about the IE bits
> either, so any time a WEP key is set and you're _not_ doing WPA the IE
> could get cleared.

Yeah, this is a bit icky. Also, we need to reset the state of the "use
key management" variable.

> Though on the other hand, the interface isn't going to work much longer
> after wpa_supplicant goes away anyway, depending on how long the
> group/multicast rekey interval is.

Actually, we're talking about getting it to work on another AP anyway.

johannes

--=-dh3D18WLQF4SEVAviZ/8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0ML86Vg1VMiehFYAQLLyRAAkXlstZxpLhVNl3HCny89ASukNhXJscrs
ozaduEX8C8VqiMTICpIzPWMCNmHTEM25QeCKUHNPR+0JCmNj1EIL8eYHmokQShSb
ZUx7Y+SWrigjktZz0CLnMKr7MAsS979DOT9CP//M2j/2PSDTuOGI3xW10hJfU/rx
uVwsjYWVJZcb6SuHX63F0KLSoaYvDzA6dLqEN99aGq9OFlII6zYSDQ/ZWTW3yfGi
4tALRNlYiSenxQwczXXqSepCN253H1KQw1DFaq5u3GS1KieIcr2PCdKoMuKQpToA
YHrSX5qj5jgsAi9jYpFKFL7HzVqnIwgrNRMV/zqEp0aeaQdILBDqjlF4aLWUqE6X
eWYEM0t+v6arsGAvHzlL35wOkWu2b/p9Gk6ygkpYOkcuspLmy273zcYqarta4VEf
ldV3iqEJAUERayPmGLZUUm8TARLBgvlItrDZ8Z3m8MD0NLj33UNA9K7VSGw5PXAm
2uHnlE9QSr97DT9Sm3H2wuShOFRxgMtq7kRYkh+qTBLIhE7YeAHqW8zAN54ZO4+t
dvuSCMlQoxW+ljKW0R2uDec2jSYzIEFwvOHaQwIaRy9+tbY6SqrnFA7R6ue/P297
TbFU2Fh+e7YrOW2tpN1Isbw7b3bZRFqVzJKOIXPDrXQyoeQLZgamNQDOMC0lqkdE
lNwZuLf+284=
=EQkp
-----END PGP SIGNATURE-----

--=-dh3D18WLQF4SEVAviZ/8--

