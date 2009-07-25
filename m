Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZGYIyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 04:54:54 -0400
Subject: Re: [PATCH] mac80211: fix oops in
 ieee80211_scan_state_set_channel()
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
In-Reply-To: <20090725051801.2965.76768.stgit@ct.roinet.com>
References: <20090725051801.2965.76768.stgit@ct.roinet.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1Yc9mfkmNZ4R43oJtKxG"
Date: Sat, 25 Jul 2009 10:54:55 +0200
Message-Id: <1248512095.32151.50.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1Yc9mfkmNZ4R43oJtKxG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-25 at 01:18 -0400, Pavel Roskin wrote:
> Move check for the final value of local->scan_channel_idx from
> ieee80211_scan_state_decision() to ieee80211_scan_state_set_channel().
>=20
> Stop the state machine in ieee80211_scan_work() by checking
> local->scanning.  Don't return a value from
> ieee80211_scan_state_decision().

Helmut, can you please take a look at this? I'm not entirely sure what's
going on.

johannes

> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  net/mac80211/scan.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index b376775..8b5a4a3 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -470,18 +470,12 @@ static int __ieee80211_start_scan(struct ieee80211_=
sub_if_data *sdata,
>  	return rc;
>  }
> =20
> -static int ieee80211_scan_state_decision(struct ieee80211_local *local,
> -					 unsigned long *next_delay)
> +static void ieee80211_scan_state_decision(struct ieee80211_local *local,
> +					  unsigned long *next_delay)
>  {
>  	bool associated =3D false;
>  	struct ieee80211_sub_if_data *sdata;
> =20
> -	/* if no more bands/channels left, complete scan and advance to the idl=
e state */
> -	if (local->scan_channel_idx >=3D local->scan_req->n_channels) {
> -		ieee80211_scan_completed(&local->hw, false);
> -		return 1;
> -	}
> -
>  	/* check if at least one STA interface is associated */
>  	mutex_lock(&local->iflist_mtx);
>  	list_for_each_entry(sdata, &local->interfaces, list) {
> @@ -517,7 +511,6 @@ static int ieee80211_scan_state_decision(struct ieee8=
0211_local *local,
>  	}
> =20
>  	*next_delay =3D 0;
> -	return 0;
>  }
> =20
>  static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_loc=
al *local,
> @@ -587,6 +580,12 @@ static void ieee80211_scan_state_set_channel(struct =
ieee80211_local *local,
>  	struct ieee80211_channel *chan;
>  	struct ieee80211_sub_if_data *sdata =3D local->scan_sdata;
> =20
> +	/* if no more bands/channels left, complete scan and advance to the idl=
e state */
> +	if (local->scan_channel_idx >=3D local->scan_req->n_channels) {
> +		ieee80211_scan_completed(&local->hw, false);
> +		return;
> +	}
> +
>  	skip =3D 0;
>  	chan =3D local->scan_req->channels[local->scan_channel_idx];
> =20
> @@ -695,8 +694,7 @@ void ieee80211_scan_work(struct work_struct *work)
>  	do {
>  		switch (local->next_scan_state) {
>  		case SCAN_DECISION:
> -			if (ieee80211_scan_state_decision(local, &next_delay))
> -				return;
> +			ieee80211_scan_state_decision(local, &next_delay);
>  			break;
>  		case SCAN_SET_CHANNEL:
>  			ieee80211_scan_state_set_channel(local, &next_delay);
> @@ -711,6 +709,8 @@ void ieee80211_scan_work(struct work_struct *work)
>  			ieee80211_scan_state_enter_oper_channel(local, &next_delay);
>  			break;
>  		}
> +		if (!local->scanning)
> +			return;
>  	} while (next_delay =3D=3D 0);
> =20
>  	queue_delayed_work(local->hw.workqueue, &local->scan_work,
>=20

--=-1Yc9mfkmNZ4R43oJtKxG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKashcAAoJEODzc/N7+QmaeEUP/2HrhZM4mnle4G32Xm1Jxa3T
f/P98DqnE/msYjm6I03uolWJEx+Qx46f+Iqj3MQiHR9HLe9Nhu5KvUjcUtrNGjEY
Ym9+vQgYAvCdRWw1dJkOB0uc4LoQ/aECAIkhuhytbaMDNGa0ByrLD+WYp0++3uYX
VxYM6FeJwHGUacLYYCdwhCjvouj/oVHFrzJZIjGQ6SnfclEeeAYqYRXfDTz3vCpb
eDTDreyk2M5CG9JZmFLPHGUb6cAkAYpm5AHm7+EPPEG+Hk+FaVFZPSpYW3t6yuUa
kZtC6UGO9Mwtvmm76wHtLeQQTEM5hJSmOtIDtZbm0T1CVggulU+9HI4vfjK4o0EA
gnrbP9zDWrVU1+Ystpfv34padYUbfv7xDSWUowEzbkXDLlK5o6eHColls4s9xi/U
SBWR79UHaCVb/RJd/yfAsOG+6QOofDL6yBV2kI7gymaocBICTYq9ph6tQd86Uxxk
0CXL6q+8x+Ci75NrkJ9GLxmuhOSRvcdaYMpiuVGbelQsIf/A1meLyPd84DQ5jAe5
Vv0H6mS/zolaOw+j2vRX8QydjztVxusboyQq4KEjzkQ1O2sNX95OoBRCkGrmNEbL
f3r2skjqUycqyhDXT7XxXJlXN48khWXM1k/PTs/p0R02hQyufMMWdEmV/ekgughg
ZTHDajF3WF93yPjBq+CE
=vOlt
-----END PGP SIGNATURE-----

--=-1Yc9mfkmNZ4R43oJtKxG--

