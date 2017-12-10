Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32926 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdLJIgN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Dec 2017 03:36:13 -0500
Date: Sun, 10 Dec 2017 09:36:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: fix locking in
 ieee80211_sta_tear_down_BA_sessions
Message-ID: <20171210083611.GA3742@amd> (sfid-20171210_093616_354410_36D2BAE7)
References: <20171209201338.24931-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
In-Reply-To: <20171209201338.24931-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2017-12-09 21:13:38, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> Due to overlap between
> commit 1281103770e9 ("mac80211: Simplify locking in ieee80211_sta_tear_do=
wn_BA_sessions()")
> and the way that Luca modified
> commit 72e2c3438ba3 ("mac80211: tear down RX aggregations first")
> when sending it upstream from Intel's internal tree, we get
> the following warning:
>=20
> WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ieee80211_stop_=
tx_ba_session+0x158/0x1f0
>=20
> since there's no appropriate locking around the call to
> ___ieee80211_stop_tx_ba_session; Sara's original just had
> a call to the locked __ieee80211_stop_tx_ba_session (one
> less underscore) but it looks like Luca modified both of
> the calls when fixing it up for upstream, leading to the
> problem at hand.
>=20
> Move the locking appropriately to fix this problem.
>=20
> Reported-by: Kalle Valo <kvalo@codeaurora.org>
> Reported-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Tested-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlos8fsACgkQMOfwapXb+vJJoQCgsxVyl2+Qvt4DavUFgUzfz+bg
3dkAoKxrSczT4I9yFu+WqVt+ki+lLQEf
=1zEa
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
