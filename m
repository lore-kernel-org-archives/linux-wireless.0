Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbZCQHrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 03:47:08 -0400
Subject: Re: [PATCH v3] mac80211: Tear down aggregation sessions for
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	me@bobcopeland.com
In-Reply-To: <18879.5862.135522.858638@gargle.gargle.HOWL>
References: <18879.5862.135522.858638@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TXHEhr9PDmos0or39kKK"
Date: Tue, 17 Mar 2009 08:46:59 +0100
Message-Id: <1237276019.18086.7.camel@johannes.local> (sfid-20090317_084712_286449_B64B21D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TXHEhr9PDmos0or39kKK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-17 at 08:50 +0530, Sujith wrote:
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
> ---
> v2:
> ---
> * Deny ADDBA requests if suspend is in progress.
>=20
> v3:
> ---
> * Use RCU protection when shutting down BA sessions for STAs.

Thanks for your patience :)

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>  net/mac80211/agg-rx.c   |    8 ++++++++
>  net/mac80211/agg-tx.c   |    9 +++++++++
>  net/mac80211/pm.c       |   25 +++++++++++++++++++++++++
>  net/mac80211/sta_info.h |    3 +++
>  4 files changed, 45 insertions(+), 0 deletions(-)
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
> index f845601..0273023 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -21,6 +21,19 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
>  	list_for_each_entry(sdata, &local->interfaces, list)
>  		ieee80211_disable_keys(sdata);
> =20
> +	/* Tear down aggregation sessions */
> +
> +	rcu_read_lock();
> +
> +	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
> +		list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +			set_sta_flags(sta, WLAN_STA_SUSPEND);
> +			ieee80211_sta_tear_down_BA_sessions(sta);
> +		}
> +	}
> +
> +	rcu_read_unlock();
> +
>  	/* remove STAs */
>  	if (local->ops->sta_notify) {
>  		spin_lock_irqsave(&local->sta_lock, flags);
> @@ -102,6 +115,18 @@ int __ieee80211_resume(struct ieee80211_hw *hw)
>  		spin_unlock_irqrestore(&local->sta_lock, flags);
>  	}
> =20
> +	/* Clear Suspend state so that ADDBA requests can be processed */
> +
> +	rcu_read_lock();
> +
> +	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
> +		list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +			clear_sta_flags(sta, WLAN_STA_SUSPEND);
> +		}
> +	}
> +
> +	rcu_read_unlock();
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

--=-TXHEhr9PDmos0or39kKK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJv1VxAAoJEKVg1VMiehFYu18P/jNmJWiUsOPZO9QEL7HBMhf8
t/LNhjzZYQ9JXyfOrdR2YAEMF/6ea3XIDCF0OpPMOdcelc5mOLz9nhzE2Qh9LQVt
hA4mi+R4J4NtL6LL3C88Bl68HjuAXsCo/sFXMGtDwbs8GkQs8/lRLfE0svRp83FJ
GqSfuxbFDClDzd9VSQj3gpW8gcV3dp72hucoJfyaaRmVuYBDfqlC7l5pwtFYkedX
apBs4JZ1G13UlTBBB1BkXYjZ+yDRRdoZN2BHN+u7jEwtJyvjeouzvQQBKYUzGFhK
Q6zs7T4gyu/RB0+S2PcRkvYGh3/vx9ItVAbooMwO+6zNmVrjPAFX7CTRavQtJFx3
lxqbEh0e1dgW3XO/xUvUxQiRwStSzvSf1bB09SkfhrDN/g8cPZiDACsCqVBFyL8c
KFXcuYjOA+ipE67HIVj/oDKad8+hccxt+PpZAl1hr3SoUdFDFxf/8uaoyHZ96BYO
7e+42tDVz4uQZCMbY7rvOYhk2VtOzah17JMzDLll3a1syWOSHVQ2MaJI84P8iEP8
e3BowAGEF0RDG2FygJqnmMF5Ysa3ZvFiXslMCCj8qmlupcjIe/Fu3la1RFiCe77Q
XF7QlRJ9UqSzVa/Nro75HhmsOyatJlBYr2R7XTgFWNHNqKMLP3Iy+yixhX3Vd+Q/
FNZdCRkkdsTzUkXatUMG
=00G1
-----END PGP SIGNATURE-----

--=-TXHEhr9PDmos0or39kKK--

