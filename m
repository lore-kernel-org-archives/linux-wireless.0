Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZFIOCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 10:02:31 -0400
Subject: Re: [PATCH] mac80211: Fix the way ADDBA request count being
 modified
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1244536906-22335-1-git-send-email-vasanth@atheros.com>
References: <1244536906-22335-1-git-send-email-vasanth@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/H4diQiVXAxtyHAuXnzI"
Date: Tue, 09 Jun 2009 16:01:58 +0200
Message-Id: <1244556118.4672.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/H4diQiVXAxtyHAuXnzI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-09 at 14:11 +0530, Vasanthakumar Thiagarajan wrote:
> addba_req_num[tid] is supposed to have the count of consecutive
> addba request attempts on 'tid' which failed. This count is checked
> against a retry threshold (3 times) before starting the addba negotiation=
.
> This patch fixes the way this addba count is incremented/reset and thereb=
y
> avoids indefinite addba attempts.

I've never actually seen this hit in practise, so I'll trust you on
it :)

johannes

> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  net/mac80211/agg-tx.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 43d00ff..9e5762a 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -132,6 +132,9 @@ static int ___ieee80211_stop_tx_ba_session(struct sta=
_info *sta, u16 tid,
> =20
>  	state =3D &sta->ampdu_mlme.tid_state_tx[tid];
> =20
> +	if (*state =3D=3D HT_AGG_STATE_OPERATIONAL)
> +		sta->ampdu_mlme.addba_req_num[tid] =3D 0;
> +
>  	*state =3D HT_AGG_STATE_REQ_STOP_BA_MSK |
>  		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
> =20
> @@ -337,6 +340,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw=
 *hw, u8 *ra, u16 tid)
>  			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
>  			 sta->ampdu_mlme.tid_tx[tid]->ssn,
>  			 0x40, 5000);
> +	sta->ampdu_mlme.addba_req_num[tid]++;
>  	/* activate the timer for the recipient's addBA response */
>  	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.expires =3D
>  				jiffies + ADDBA_RESP_INTERVAL;
> @@ -606,7 +610,6 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw,=
 u8 *ra, u8 tid)
> =20
>  	*state =3D HT_AGG_STATE_IDLE;
>  	/* from now on packets are no longer put onto sta->pending */
> -	sta->ampdu_mlme.addba_req_num[tid] =3D 0;
>  	kfree(sta->ampdu_mlme.tid_tx[tid]);
>  	sta->ampdu_mlme.tid_tx[tid] =3D NULL;
> =20
> @@ -689,7 +692,6 @@ void ieee80211_process_addba_resp(struct ieee80211_lo=
cal *local,
> =20
>  		sta->ampdu_mlme.addba_req_num[tid] =3D 0;
>  	} else {
> -		sta->ampdu_mlme.addba_req_num[tid]++;
>  		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
>  	}
>  	spin_unlock_bh(&sta->lock);

--=-/H4diQiVXAxtyHAuXnzI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLmtTAAoJEODzc/N7+QmaQKsP/iOZr+gLnsSPdlWel+ZvbpUn
Kw0zLirfbWBmTr9+W/j8B5DPVx18d6wxr0FcngqidjPJJ2X0XNKWZGK0BEgZcoEJ
Fkw3QJ1onY+uu2EvpA6rGZkFXmr2EQVqvJO3b0n9NpUBKVm38o/ZgpplJoQgBKM+
JYEk+IBnJk4dLg5suRsxVOsMyeHsTiKjaxrNHLLNW70yFR5RO2nGJ3odNuxTkB93
SydU6u6/SIBxjtpDWbCO1Nv/QWJWO56gKu8nudE+W/QcSQvx2XyHT91C6Oj+fpEO
Fm8AOadQ6gFxumIcICYgU0KY0NBkaKkXLtefIkqsuGIkAQ7qNmmzE6wpw6LAB9pw
FvzWzwKVoYc8R4SSmmQ4lwdSfG2oOGsKFwa0wPvOWL3r9c7aOVOsVI8lLEKASJz6
iYgPxh0bdePuenR0Hh58RNwWTPBPUwtCo5k67qs/r3kgh/aJHT1ZmGiYywCZ/3X9
lLAQ+vMzDhedjRYEU9nNzmaNATewus3Z/nnRrA0HB4pnl1gUiZqLGElYoWSANfJB
oCf88xRG/YY3d7e9ZHYDxGLmEh+ervbNg0jUC++OuzYjOI/YhVasigIRtc5JBbn7
UGH1bvA2znkFaWxM7yYzS8gnUUMRaD0O8jEI01qZU1ozBqHmeCJSyfVC95M05f9J
sI7pprvudvJPnbhn7YYv
=Pj4h
-----END PGP SIGNATURE-----

--=-/H4diQiVXAxtyHAuXnzI--

