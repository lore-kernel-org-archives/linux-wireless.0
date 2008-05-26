Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYEZOUg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 10:20:36 -0400
Subject: Re: [PATCH 1/1] mac80211: fix deadlock in sta->lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1211810958-23095-1-git-send-email-tomas.winkler@intel.com>
References: <1211810958-23095-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K+jNlYInN+ktedOz8VN1"
Date: Mon, 26 May 2008 16:19:14 +0200
Message-Id: <1211811554.4843.4.camel@johannes.berg> (sfid-20080526_162040_334903_7C0A37FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K+jNlYInN+ktedOz8VN1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-26 at 17:09 +0300, Tomas Winkler wrote:
> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>=20
> This patch fixes a deadlock of sta->lock use, occuring while changing
> tx aggregation states, as dev_queue_xmit end up in new function
> test_and_clear_sta_flags that uses that lock thus leading to deadlock

Oh, good catch, thanks. Reminds me to debug the other deadlock I saw
(not mac80211 related though)

> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/main.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index b0fddb7..5a9030c 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -662,6 +662,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw=
 *hw, u8 *ra, u16 tid)
>  		goto start_ba_err;
>  	}
> =20
> +	spin_unlock_bh(&sta->lock);
> +
>  	/* Will put all the packets in the new SW queue */
>  	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
>  	spin_unlock_bh(&local->mdev->queue_lock);
> @@ -688,9 +690,9 @@ start_ba_err:
>  	kfree(sta->ampdu_mlme.tid_tx[tid]);
>  	sta->ampdu_mlme.tid_tx[tid] =3D NULL;
>  	spin_unlock_bh(&local->mdev->queue_lock);
> +	spin_unlock_bh(&sta->lock);
>  	ret =3D -EBUSY;
>  start_ba_exit:
> -	spin_unlock_bh(&sta->lock);
>  	rcu_read_unlock();
>  	return ret;
>  }
> @@ -829,10 +831,11 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *h=
w, u8 *ra, u8 tid)
>  	}
>  	state =3D &sta->ampdu_mlme.tid_state_tx[tid];
> =20
> -	spin_lock_bh(&sta->lock);
> +	/* no need to use sta->lock in this state check, as
> +	 * ieee80211_stop_tx_ba_session will let only
> +	 * one stop call to pass through per sta/tid */
>  	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) =3D=3D 0) {
>  		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
> -		spin_unlock_bh(&sta->lock);
>  		rcu_read_unlock();
>  		return;
>  	}
> @@ -855,6 +858,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw,=
 u8 *ra, u8 tid)
>  	 * ieee80211_wake_queue is not used here as this queue is not
>  	 * necessarily stopped */
>  	netif_schedule(local->mdev);
> +	spin_lock_bh(&sta->lock);
>  	*state =3D HT_AGG_STATE_IDLE;
>  	sta->ampdu_mlme.addba_req_num[tid] =3D 0;
>  	kfree(sta->ampdu_mlme.tid_tx[tid]);

--=-K+jNlYInN+ktedOz8VN1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDrG4aVg1VMiehFYAQJbSw/9FS3ibzpYwh/r0DZNm8OeE+es03+Z1kj3
5KCBXCiaKKI5IUgyFsoX99GIKzvBaFTL7wRtuq4nNf7B3TSb+z0KLfLmhO4OOj2N
meZUVNqXxUYyYbNJXqToVtueHmVib7KYoJ0RZD34XQd3F1iMoCSOinDElRFe+uo0
zTiK92dtt6zjsnFsxIA7GmQMn1KR9xjnG94YJo354XD/pL2LcmvuDyWBPASQsfbM
Gae1UNNZyHA+95qUyszbN3mU6sXZp6CVcZ5oeXfTHEnJSXcqxSg5qGQyEkcaXS1P
BkepL94BSMJ0E9aJftcfUYR95gZzLxhUohs/a+5U4Cllhsj8qXhB+dgGKPB2Mrn0
uDJvHyEMKFrBHa0nQTdTxftAX+rzoPPkLH7/P67YuUP/OVffRV51ZrWSdZSw9KyZ
3+UYP82p1hVQQ4cGGh4m56EAlMgI418aOydYgYGOP0jzrskwIiI0Z/UXZmGeUj78
2ibQpEJaRJMVn5X4AIpFgg1q0V0Bt/2CbFYWthM194/OcFK9gXgRmB8kauh8LI94
szrcvcZ7zfsGd8BveaNabgBN96gufXZlMnqTmdIfv6qFOJGgrRs7rx1sNucXPMUV
6uh8dKivqJ+5LaX8jeyNLKM4G7uEZDgTCdyschrstRf+nNRYX+xh2cS82QdE8mEz
bSCooCV5MPk=
=3mDB
-----END PGP SIGNATURE-----

--=-K+jNlYInN+ktedOz8VN1--

