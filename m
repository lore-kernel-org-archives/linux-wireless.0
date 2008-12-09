Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYLIQAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 11:00:33 -0500
Subject: Re: [PATCH] mac80211: integrate sta_notify_ps cmds into sta_notify
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <200812091628.06947.chunkeey@web.de>
References: <200812091628.06947.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eMVblWmtwTSyxODdCg2q"
Date: Tue, 09 Dec 2008 16:59:59 +0100
Message-Id: <1228838399.1029.12.camel@johannes.berg> (sfid-20081209_170036_297150_24654A57)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eMVblWmtwTSyxODdCg2q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 16:28 +0100, Christian Lamparter wrote:
> This patch replaces the newly introduced sta_notify_ps function,
> which can be used to notify the driver about every power state=20
> transition for all associated stations, by integrating its functionality
> back into the original sta_notify callback.
>=20
> Signed-off-by: Christian Lamparter <chunkeey@web.de>

Looks good to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> It turned out that sta_notify needs to be atomic as well. so
> we don't break locking requirement.
>=20
> Let me know, if you find any spelling errors in the documentation.
>=20
> and @ Johannes:
> make htmldocs -j3
>   DOCPROC Documentation/DocBook/mac80211.xml
>   HTML    Documentation/DocBook/mac80211.html
> [...]
> ---
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless=
/mac80211_hwsim.c
> index f43da1c..af6cd83 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -524,6 +524,10 @@ static void mac80211_hwsim_sta_notify(struct ieee802=
11_hw *hw,
>  	case STA_NOTIFY_REMOVE:
>  		hwsim_clear_sta_magic(sta);
>  		break;
> +	case STA_NOTIFY_SLEEP:
> +	case STA_NOTIFY_AWAKE:
> +		/* TODO: make good use of these flags */
> +		break;
>  	}
>  }
> =20
> diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/=
p54/p54common.c
> index 719bdab..1e1c06e 100644
> --- a/drivers/net/wireless/p54/p54common.c
> +++ b/drivers/net/wireless/p54/p54common.c
> @@ -1052,19 +1052,6 @@ static int p54_sta_unlock(struct ieee80211_hw *dev=
, u8 *addr)
>  	return 0;
>  }
> =20
> -static void p54_sta_notify_ps(struct ieee80211_hw *dev,
> -			      enum sta_notify_ps_cmd notify_cmd,
> -			      struct ieee80211_sta *sta)
> -{
> -	switch (notify_cmd) {
> -	case STA_NOTIFY_AWAKE:
> -		p54_sta_unlock(dev, sta->addr);
> -		break;
> -	default:
> -		break;
> -	}
> -}
> -
>  static void p54_sta_notify(struct ieee80211_hw *dev, struct ieee80211_vi=
f *vif,
>  			      enum sta_notify_cmd notify_cmd,
>  			      struct ieee80211_sta *sta)
> @@ -1079,6 +1066,10 @@ static void p54_sta_notify(struct ieee80211_hw *de=
v, struct ieee80211_vif *vif,
> =20
>  		p54_sta_unlock(dev, sta->addr);
>  		break;
> +	case STA_NOTIFY_AWAKE:
> +		/* update the firmware's filter table */
> +		p54_sta_unlock(dev, sta->addr);
> +		break;
>  	default:
>  		break;
>  	}
> @@ -2028,7 +2019,6 @@ static const struct ieee80211_ops p54_ops =3D {
>  	.add_interface		=3D p54_add_interface,
>  	.remove_interface	=3D p54_remove_interface,
>  	.set_tim		=3D p54_set_tim,
> -	.sta_notify_ps		=3D p54_sta_notify_ps,
>  	.sta_notify		=3D p54_sta_notify,
>  	.set_key		=3D p54_set_key,
>  	.config			=3D p54_config,
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 346f373..674f90d 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -773,25 +773,16 @@ struct ieee80211_sta {
>   * enum sta_notify_cmd - sta notify command
>   *
>   * Used with the sta_notify() callback in &struct ieee80211_ops, this
> - * indicates addition and removal of a station to station table.
> + * indicates addition and removal of a station to station table,
> + * or if a associated station made a power state transition.
>   *
>   * @STA_NOTIFY_ADD: a station was added to the station table
>   * @STA_NOTIFY_REMOVE: a station being removed from the station table
> - */
> -enum sta_notify_cmd {
> -	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE
> -};
> -
> -/**
> - * enum sta_notify_ps_cmd - sta power save notify command
> - *
> - * Used with the sta_notify_ps() callback in &struct ieee80211_ops to
> - * notify the driver if a station made a power state transition.
> - *
>   * @STA_NOTIFY_SLEEP: a station is now sleeping
>   * @STA_NOTIFY_AWAKE: a sleeping station woke up
>   */
> -enum sta_notify_ps_cmd {
> +enum sta_notify_cmd {
> +	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE,
>  	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
>  };
> =20
> @@ -1262,11 +1253,9 @@ enum ieee80211_ampdu_mlme_action {
>   *	the device does fragmentation by itself; if this method is assigned t=
hen
>   *	the stack will not do fragmentation.
>   *
> - * @sta_notify: Notifies low level driver about addition or removal of a=
n
> - *	associated station, AP, IBSS/WDS/mesh peer etc. Must be atomic.
> - *
> - * @sta_ps_notify: Notifies low level driver about the power state trans=
ition
> - *	of a associated station. Must be atomic.
> + * @sta_notify: Notifies low level driver about addition, removal or pow=
er
> + *	state transition of an associated station, AP,  IBSS/WDS/mesh peer et=
c.
> + *	Must be atomic.
>   *
>   * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
>   *	bursting) for a hardware TX queue.
> @@ -1334,8 +1323,6 @@ struct ieee80211_ops {
>  	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
>  	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  			enum sta_notify_cmd, struct ieee80211_sta *sta);
> -	void (*sta_notify_ps)(struct ieee80211_hw *hw,
> -			enum sta_notify_ps_cmd, struct ieee80211_sta *sta);
>  	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
>  		       const struct ieee80211_tx_queue_params *params);
>  	int (*get_tx_stats)(struct ieee80211_hw *hw,
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 59f356a..ffaaa2a 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -659,9 +659,9 @@ static void ap_sta_ps_start(struct sta_info *sta)
> =20
>  	atomic_inc(&sdata->bss->num_sta_ps);
>  	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
> -	if (local->ops->sta_notify_ps)
> -		local->ops->sta_notify_ps(local_to_hw(local), STA_NOTIFY_SLEEP,
> -					  &sta->sta);
> +	if (local->ops->sta_notify)
> +		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
> +					STA_NOTIFY_SLEEP, &sta->sta);
>  #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
>  	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
>  	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
> @@ -679,9 +679,9 @@ static int ap_sta_ps_end(struct sta_info *sta)
>  	atomic_dec(&sdata->bss->num_sta_ps);
> =20
>  	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
> -	if (local->ops->sta_notify_ps)
> -		local->ops->sta_notify_ps(local_to_hw(local), STA_NOTIFY_AWAKE,
> -					  &sta->sta);
> +	if (local->ops->sta_notify)
> +		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
> +					STA_NOTIFY_AWAKE, &sta->sta);
> =20
>  	if (!skb_queue_empty(&sta->ps_tx_buf))
>  		sta_info_clear_tim_bit(sta);
>=20

--=-eMVblWmtwTSyxODdCg2q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPpX7AAoJEKVg1VMiehFYCo4QAKu2IgUsFVV89Tl4tclieQUr
UJp2bFBvO3rVnpHkrS61dOFWWfiUrg6H8HoqEwDU8QCLkBxEUL3QCC9NjrpqxupN
gfh7oaK4lB4dpTSm+EmyW3FKB5kOgvf8M6DpznIYI9wITfcv88pN0Hm9P+yy7D3/
Wy8zQRQQMHk0D/1DmzOB2fxN/N0w/dB9Jjol7ia8qQ0BYjRPt07s0JSB+8/FwMCR
TcRnVQ57LE8B9dVYgNAW+9nK/wxHQkEaAXQGrQ0TqQ8/g2+w98ojXtCAAjhmtkWx
d/ml3zyuwXJJcpvgsDzh/5PksgntQkmQGnV+jAB2pUlYMafBkRRbnInIjs/m9X2o
t2/SCeUzPECWH15+sdWZ2V/QipqsVFxmFKLUeCA9DHInQus9BQyNfnWCyVDY+wO9
ZudH8TAHsiejZuvF+D2vnS5X1Hn0GPtNh0ak1xTb9+0FDhWM4L2Jcok0WeNjYzO0
oTxerEWLExoPj1tFFs7UzaTQC5LP8EQkcGhbn+v66xe2s0iVF/0oDQUtrE5n74HY
T0egagRqtOmQuNY4UiBVBzNFm2Thx0vHAD+LQT0pCI5nVmfd74UL/h1yfbHGWrdn
4BmN4P7nxNEbslYDRnttxKRtqfxavx2Q+QCAW1w0V6WIQzoHiBdH+ltdVZ4yddHh
x7pAOz42MG3IuosWOrZn
=UY6l
-----END PGP SIGNATURE-----

--=-eMVblWmtwTSyxODdCg2q--

