Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZCPKLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 06:11:54 -0400
Subject: Re: [PATCH v2] mac80211: Tear down aggregation sessions for
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com, me@bobcopeland.com
In-Reply-To: <18878.8417.960342.116534@gargle.gargle.HOWL>
References: <18878.8417.960342.116534@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cDNp2Bh0QoeNt9dMRUxu"
Date: Mon, 16 Mar 2009 11:11:46 +0100
Message-Id: <1237198307.27769.8.camel@johannes.local> (sfid-20090316_111156_514674_A86DE384)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cDNp2Bh0QoeNt9dMRUxu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-16 at 15:20 +0530, Sujith wrote:
> When the driver has been notified with a STA_REMOVE, it tears down
> the internal ADDBA state. On resume, trying to initiate aggregation would
> fail because mac80211 has not cleared the operational state for that <TID=
,STA>.
> This can be fixed by tearing down the existing sessions on a suspend.
>=20
> Also, the driver can initiate a new BA session when suspend is in progres=
s.
> This is fixed by marking the station as being in suspend state and
> denying ADDBA requests for such STAs.
>=20
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Looks good to me, thanks. Should we really set a per-station flag
though? It seems a "local->suspended" would be sufficient and much
cheaper?

johannes

> ---
> v2:
> --
> * Deny ADDBA requests if suspend is in progress.
>=20
>  net/mac80211/agg-rx.c   |    8 ++++++++
>  net/mac80211/agg-tx.c   |    9 +++++++++
>  net/mac80211/pm.c       |   15 +++++++++++++++
>  net/mac80211/sta_info.h |    3 +++
>  4 files changed, 35 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index a95affc..07656d8 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -197,6 +197,14 @@ void ieee80211_process_addba_request(struct ieee8021=
1_local *local,
> =20
>  	status =3D WLAN_STATUS_REQUEST_DECLINED;
> =20
> +	if (test_sta_flags(sta, WLAN_STA_SUSPEND)) {
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +		printk(KERN_DEBUG "Suspend in progress. "
> +		       "Denying ADDBA request\n");
> +#endif
> +		goto end_no_lock;
> +	}
> +
>  	/* sanity check for incoming parameters:
>  	 * check if configuration can support the BA policy
>  	 * and if buffer size does not exceeds max value */
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 1df116d..e5776ef 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -257,6 +257,15 @@ int ieee80211_start_tx_ba_session(struct ieee80211_h=
w *hw, u8 *ra, u16 tid)
>  		goto unlock;
>  	}
> =20
> +	if (test_sta_flags(sta, WLAN_STA_SUSPEND)) {
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +		printk(KERN_DEBUG "Suspend in progress. "
> +		       "Denying BA session request\n");
> +#endif
> +		ret =3D -EINVAL;
> +		goto unlock;
> +	}
> +
>  	spin_lock_bh(&sta->lock);
> =20
>  	sdata =3D sta->sdata;
> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> index f845601..07929fb 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -21,6 +21,14 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
>  	list_for_each_entry(sdata, &local->interfaces, list)
>  		ieee80211_disable_keys(sdata);
> =20
> +	/* Tear down aggregation sessions */
> +	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
> +		list_for_each_entry(sta, &local->sta_list, list) {
> +			set_sta_flags(sta, WLAN_STA_SUSPEND);
> +			ieee80211_sta_tear_down_BA_sessions(sta);
> +		}
> +	}
> +
>  	/* remove STAs */
>  	if (local->ops->sta_notify) {
>  		spin_lock_irqsave(&local->sta_lock, flags);
> @@ -102,6 +110,13 @@ int __ieee80211_resume(struct ieee80211_hw *hw)
>  		spin_unlock_irqrestore(&local->sta_lock, flags);
>  	}
> =20
> +	/* Clear Suspend state so that ADDBA requests can be processed */
> +	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
> +		list_for_each_entry(sta, &local->sta_list, list) {
> +			clear_sta_flags(sta, WLAN_STA_SUSPEND);
> +		}
> +	}
> +
>  	/* add back keys */
>  	list_for_each_entry(sdata, &local->interfaces, list)
>  		if (netif_running(sdata->dev))
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 1f45573..5b223b2 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -35,6 +35,8 @@
>   *	IEEE80211_TX_CTL_CLEAR_PS_FILT control flag) when the next
>   *	frame to this station is transmitted.
>   * @WLAN_STA_MFP: Management frame protection is used with this STA.
> + * @WLAN_STA_SUSPEND: Set/cleared during a suspend/resume cycle.
> + *	Used to deny ADDBA requests (both TX and RX).
>   */
>  enum ieee80211_sta_info_flags {
>  	WLAN_STA_AUTH		=3D 1<<0,
> @@ -48,6 +50,7 @@ enum ieee80211_sta_info_flags {
>  	WLAN_STA_PSPOLL		=3D 1<<8,
>  	WLAN_STA_CLEAR_PS_FILT	=3D 1<<9,
>  	WLAN_STA_MFP		=3D 1<<10,
> +	WLAN_STA_SUSPEND	=3D 1<<11
>  };
> =20
>  #define STA_TID_NUM 16

--=-cDNp2Bh0QoeNt9dMRUxu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJviXgAAoJEKVg1VMiehFYFzcP/1o+BUa3NKIStmU+9QCCa2vi
aZtb5Xd6Z3YjJG3obnhsZhNjbqhM9CKVVyDqty8AIfJWpM5o55uHQiXqhllzy1ct
oC2fgBWjXwCpl/23MRMSwfBrTFAtd0r47gnMIJu2UK7dXXi7EkSdNF78k9XJgO+n
uALXV+aIOhGZ23+fIQ6yM2OKnBtcENPUDtxZUF++XUk9BGL3t/1FPZxk/6u4yI/G
wCGkzqipf5wTm/3Vgeky9hFU9U7WNJwZe8kw2g8xX887M5Ghox4VzB2YhRZKWuqG
2kL4YqtbDBMkPae0RkToJiRe1YI029RvdTVe1pkE4nEua5kncZhTWqMr/NbFhdRe
5pb0H/W/CpO1RP2v8kz8CVxgkut64sZ9SuVpldM5cNg8z1zRn0LI3Svbz1Fb+Z+q
X9h1p1sEf0nhg7SWl72UPyffh7YeAUUyMkZzywaYKgmv0O9eHK0tXj6tVqpO4/BF
i6DEzTcwMT4j0/NHN532cNj+cikorJ4O/39s7Maal+jdLZolsNvQx5L61T4JgrSe
KKVGqokjmkdPwZwSHjzsCDJbNpRz/fO1et3ou+jUX1dOF5m60eleiudPY/vKLgZl
PfrjJFjuhiGBs0EfZywehapaDs5ZAqKckHN2gTqlx9J5qFT4jFFSnBIZVHuY83p5
AOvZ4F+V+4S1LejiYXux
=cVP1
-----END PGP SIGNATURE-----

--=-cDNp2Bh0QoeNt9dMRUxu--

