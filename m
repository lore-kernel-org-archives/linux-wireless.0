Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbZC1R3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 13:29:00 -0400
Subject: Re: [PATCH 5/8] mac80211: unify and fix TX aggregation start
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890903272001h3e2fb2f0yf6a150f5e22d7039@mail.gmail.com> (sfid-20090328_040126_100483_B33FDA3B)
References: <20090323162834.154525349@sipsolutions.net>
	 <20090323163052.823346545@sipsolutions.net>
	 <20090328022659.GD5543@bombadil.infradead.org>
	 <43e72e890903272001h3e2fb2f0yf6a150f5e22d7039@mail.gmail.com>
	 (sfid-20090328_040126_100483_B33FDA3B)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+pi5kcwRcjOqpuavxFq1"
Date: Sat, 28 Mar 2009 18:28:48 +0100
Message-Id: <1238261328.4217.0.camel@johannes.local> (sfid-20090328_182907_905468_66DBE8FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+pi5kcwRcjOqpuavxFq1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 20:01 -0700, Luis R. Rodriguez wrote:

> >> Unfortunately, 1) and 3) are only done if the driver is first to
> >> reply to the aggregation request, it is, however, possible that the
> >> remote station replies before the driver! Thus, unify the code for
> >> this and call the new function ieee80211_agg_tx_operational in both
> >> places where TX aggregation can become operational.
> >>
> >> Additionally, rename the driver notification from
> >> IEEE80211_AMPDU_TX_RESUME to IEEE80211_AMPDU_TX_OPERATIONAL.
> >>
> >> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> >
> > Nice catch man!
> >
> > Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>=20
> Hm, maybe also a backported version could go to stable? Perhaps we can
> trigger a panic on a UP box?

No need -- ath9k always replies _instantly_, and iwlwifi doesn't support
aggregation in stable.

johannes

--=-+pi5kcwRcjOqpuavxFq1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzl5OAAoJEKVg1VMiehFYeG0P/iCz5toRoVx5HI/QMuv4DkgJ
RMLwZYgMSynYkIU5cWN9xr4O92aaUxZ1+VuhrFxFEL9wXdNLXZUzYjzZkiTGCOO6
/OCNfULUWETmCxcxFiSYGlBWbn3I0GC0TonN+anJExOToFy2d/0Ux97+5rgbqvNt
+SjFQLw93x4eJFhNi3G8EHo7LVFzslA82obCp1tTf3K9k2Scq5uj3eVxhMp3Belw
6jbKTJW7drRGTcezAb6wDb6u+VsPc4hGje5KDrN1tpvtHA2mN5c2pilD5hztcZpM
Z4llsR/Lxm/DPlrLu/2a/Z6aHSfzk083OJ4mIJEh0LSNILsPL79ZV93pdVe5VKsr
M1mZDhVg+846fx4MdvRZveNEnB6rhLGm/l5/SjH8I5y547hnniB0n0iKuUsGv6K/
e6NWUHqVM8iJbqZd5aYG9IzFrO8e3yefdkPiXH/1hIU+LC3OOyiAJs0HDfFrxMVr
TB+9hzsPomV74cgvIvNjHA+HNAHSGJkLKFOHjmKjL7exkm0MOiGxsA2o7lfA5x7L
/SFI3Z03xy262mpa5plf9mBP299mG2zBAYLvZtdNKb0EXWNwG9Cpk+aWS52rALvx
dGevYsTgEoet5z6K4UjbUhiXmTckWLwm+MipKCMTqCFprUu3RE+skiM4/7KcXOiW
/73fHqDXluMehmg7NlCs
=Uyow
-----END PGP SIGNATURE-----

--=-+pi5kcwRcjOqpuavxFq1--

