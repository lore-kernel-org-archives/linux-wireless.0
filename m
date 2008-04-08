Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54107 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYDHOia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 10:38:30 -0400
Subject: Re: [PATCH] mac80211: BA session debug prints changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1207588616-30489-1-git-send-email-reinette.chatre@intel.com>
References: <1207588616-30489-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N3mJRkmoYj+ClFZpZrOF"
Date: Tue, 08 Apr 2008 16:30:22 +0200
Message-Id: <1207665022.14253.28.camel@johannes.berg> (sfid-20080408_153835_702145_BFA250CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-N3mJRkmoYj+ClFZpZrOF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-04-07 at 10:16 -0700, Reinette Chatre wrote:
> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>=20
> This patch contains next issues:
> 1 - prevents "stop BA session" multiple warnings
> 2 - adds debug print to stop Rx BA session flow
> 3 - adds EOL in one debug print
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Great, thanks.
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211.c     |   18 ++++++++----------
>  net/mac80211/ieee80211_sta.c |   10 ++++++++--
>  2 files changed, 16 insertions(+), 12 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 5d30dd4..b3cf69e 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -700,11 +700,6 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_hw=
 *hw,
>  	if (tid >=3D STA_TID_NUM)
>  		return -EINVAL;
> =20
> -#ifdef CONFIG_MAC80211_HT_DEBUG
> -	printk(KERN_DEBUG "Stop a BA session requested for %s tid %u\n",
> -				print_mac(mac, ra), tid);
> -#endif /* CONFIG_MAC80211_HT_DEBUG */
> -
>  	rcu_read_lock();
>  	sta =3D sta_info_get(local, ra);
>  	if (!sta) {
> @@ -717,14 +712,15 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_h=
w *hw,
>  	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
> =20
>  	if (*state !=3D HT_AGG_STATE_OPERATIONAL) {
> -#ifdef CONFIG_MAC80211_HT_DEBUG
> -		printk(KERN_DEBUG "Try to stop Tx aggregation on"
> -				" non active TID\n");
> -#endif /* CONFIG_MAC80211_HT_DEBUG */
>  		ret =3D -ENOENT;
>  		goto stop_BA_exit;
>  	}
> =20
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +	printk(KERN_DEBUG "Tx BA session stop requested for %s tid %u\n",
> +				print_mac(mac, ra), tid);
> +#endif /* CONFIG_MAC80211_HT_DEBUG */
> +
>  	ieee80211_stop_queue(hw, sta->tid_to_tx_q[tid]);
> =20
>  	*state =3D HT_AGG_STATE_REQ_STOP_BA_MSK |
> @@ -809,8 +805,10 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw=
, u8 *ra, u8 tid)
>  		return;
>  	}
> =20
> -	printk(KERN_DEBUG "Stop a BA session requested on DA %s tid %d\n",
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +	printk(KERN_DEBUG "Stopping Tx BA session for %s tid %d\n",
>  				print_mac(mac, ra), tid);
> +#endif /* CONFIG_MAC80211_HT_DEBUG */
> =20
>  	rcu_read_lock();
>  	sta =3D sta_info_get(local, ra);
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 833b225..5120e38 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -1281,7 +1281,7 @@ static void ieee80211_sta_process_addba_request(str=
uct net_device *dev,
>  		ret =3D local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
>  					       sta->addr, tid, &start_seq_num);
>  #ifdef CONFIG_MAC80211_HT_DEBUG
> -	printk(KERN_DEBUG "Rx A-MPDU on tid %d result %d", tid, ret);
> +	printk(KERN_DEBUG "Rx A-MPDU request on tid %d result %d\n", tid, ret);
>  #endif /* CONFIG_MAC80211_HT_DEBUG */
> =20
>  	if (ret) {
> @@ -1436,6 +1436,7 @@ void ieee80211_sta_stop_rx_ba_session(struct net_de=
vice *dev, u8 *ra, u16 tid,
>  	struct ieee80211_hw *hw =3D &local->hw;
>  	struct sta_info *sta;
>  	int ret, i;
> +	DECLARE_MAC_BUF(mac);
> =20
>  	rcu_read_lock();
> =20
> @@ -1456,12 +1457,17 @@ void ieee80211_sta_stop_rx_ba_session(struct net_=
device *dev, u8 *ra, u16 tid,
>  	sta->ampdu_mlme.tid_state_rx[tid] =3D
>  		HT_AGG_STATE_REQ_STOP_BA_MSK |
>  		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
> -		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
> +	spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
> =20
>  	/* stop HW Rx aggregation. ampdu_action existence
>  	 * already verified in session init so we add the BUG_ON */
>  	BUG_ON(!local->ops->ampdu_action);
> =20
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +	printk(KERN_DEBUG "Rx BA session stop requested for %s tid %u\n",
> +				print_mac(mac, ra), tid);
> +#endif /* CONFIG_MAC80211_HT_DEBUG */
> +
>  	ret =3D local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
>  					ra, tid, NULL);
>  	if (ret)

--=-N3mJRkmoYj+ClFZpZrOF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/uBfKVg1VMiehFYAQKpXw/+Kai7Qbh+dVIgHE8g2c2VXvSFKrtOmbRU
xYqCtnN3SSWT0glXo8rY/wiu6dTywLZ4YMn2TENeCbqgcs4cbfpVXdrRf4zz8PqL
5lzJ8dhLEIfSw/MAhiFC9/ikGgGaG77U1vQcSqwL8k8WSMz/XUP9qee3JB1VSnf6
sVBv5B5q2AHHDo6lZCRyGn0LXkC7qScyLsljUeOfxfly/BLjgJOt3QCmwwULLbk8
eEfG0hbw3p75R73gYjfxuw55+jp7hf3FQIhxzspB9UTpKXvEeRXIvLo5sh0yDjzj
Qlcz5VP16J/H+wTb7dGo//4WgCcyxrsaRnRhuiBeW2UeRKd6uqlHSVR4v48TtaEE
AX0kF3/i7tamhY36uq6b5wlrqC9a+6/DHId7bL00VzGeBoqc9E+7LymcbTKuzuQt
/uCkDRxlgR37uXfjblgbVRspnKT+mFZk0X5DFEEZnzvhesPqO8HRXUCUD0UJRtNk
Gz5GprRI+j+yG5PG8SfEhKnXss0gBmF3T+pjP1ABA0lUd59V5rxdqhgvAfTuCPh3
2+WtrQHIj2iZ6ohjiL/sZaFNO3UtE6dSRYe0UAsaulmJybFFs4i7y1bPsrgy5y2t
t3UzRyU9f54WbMRrfQUgDRG/l27hrpN9LDVKW2BfJle3burwemKkChV37iYq7Ux1
N5OaG3hMqvk=
=MM98
-----END PGP SIGNATURE-----

--=-N3mJRkmoYj+ClFZpZrOF--

