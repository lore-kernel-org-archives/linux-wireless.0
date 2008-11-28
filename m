Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYK1VSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 16:18:15 -0500
Subject: Re: [RFC] mac80211 & p54: add sta_notify_ps callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200811282143.01847.chunkeey@web.de>
References: <200811242124.16358.chunkeey@web.de>
	 <1227801591.3852.0.camel@johannes.berg>
	 <200811282109.35857.chunkeey@web.de>  <200811282143.01847.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hh6TYeiz800EnPopr1vV"
Date: Fri, 28 Nov 2008 22:18:10 +0100
Message-Id: <1227907090.3479.2.camel@johannes.berg> (sfid-20081128_221819_921112_C74D0393)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hh6TYeiz800EnPopr1vV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-28 at 21:43 +0100, Christian Lamparter wrote:
> On Friday 28 November 2008 21:09:35 Christian Lamparter wrote:
> > Ahh... I knew it!=20
> >=20
> > Alright, I looks like I have to change the mac80211 stack for this.
> > What I need is a callback form ap_sta_ps_end & (ap_sta_ps_start).
> >=20
> > It's because (p54_)set_tim - and therefore p54_sta_unlock as well - won=
't
> > be executed if the station changes its power state very quickly/or if n=
o package comes in
> > So we have no change to notify the firmware about the stations new powe=
r state
> > and then the firmware won't let us send anything to the station. =20
> >=20
> > here is my proposal for mac80211:
> > ---
> Updates:
> 	- integrate sta_notify_ps into sta_notify.
> 	- added trivial switch cases for mac80211_hwsim.c (or else gcc complains=
)

Looks fine to me.

> And BTW: can someone please check the spelling?

And that too.

> ---
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless=
/mac80211_hwsim.c
> index f43da1c..e2c50ed 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -524,6 +524,10 @@ static void mac80211_hwsim_sta_notify(struct ieee802=
11_hw *hw,
>  	case STA_NOTIFY_REMOVE:
>  		hwsim_clear_sta_magic(sta);
>  		break;
> +	case STA_NOTIFY_AWAKE:
> +	case STA_NOTIFY_SLEEP:
> +		/* TODO: make good use of these callbacks */
> +		break;
>  	}
>  }
> =20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 6a1d4ea..7bd8edc 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -768,14 +768,18 @@ struct ieee80211_sta {
>  /**
>   * enum sta_notify_cmd - sta notify command
>   *
> - * Used with the sta_notify() callback in &struct ieee80211_ops, this
> - * indicates addition and removal of a station to station table.
> + * Used with the sta_notify() callback in &struct ieee80211_ops.
> + * this command indicates addition and removal of a station to
> + * station table, or if a station made a power state transition.
>   *
>   * @STA_NOTIFY_ADD: a station was added to the station table
>   * @STA_NOTIFY_REMOVE: a station being removed from the station table
> + * @STA_NOTIFY_SLEEP: a station is now sleeping
> + * @STA_NOTIFY_AWAKE: a sleeping station woke up
>   */
>  enum sta_notify_cmd {
> -	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE
> +	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE,
> +	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
>  };
> =20
>  /**
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 5a1a60f..2d311a1 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -654,10 +654,14 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx=
)
>  static void ap_sta_ps_start(struct sta_info *sta)
>  {
>  	struct ieee80211_sub_if_data *sdata =3D sta->sdata;
> +	struct ieee80211_local *local =3D sdata->local;
>  	DECLARE_MAC_BUF(mac);
> =20
>  	atomic_inc(&sdata->bss->num_sta_ps);
>  	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
> +	if (local->ops->sta_notify)
> +		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
> +				       STA_NOTIFY_SLEEP, &sta->sta);
>  #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
>  	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
>  	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
> @@ -675,6 +679,9 @@ static int ap_sta_ps_end(struct sta_info *sta)
>  	atomic_dec(&sdata->bss->num_sta_ps);
> =20
>  	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
> +	if (local->ops->sta_notify)
> +		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
> +				       STA_NOTIFY_AWAKE, &sta->sta);
> =20
>  	if (!skb_queue_empty(&sta->ps_tx_buf))
>  		sta_info_clear_tim_bit(sta);
> ---
>=20
> p54 updates:
> 	- update to new api
> ---
> diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/=
p54/p54common.c
> --- a/drivers/net/wireless/p54/p54common.c	2008-11-28 20:18:53.000000000 =
+0100
> +++ b/drivers/net/wireless/p54/p54common.c	2008-11-28 21:37:45.000000000 =
+0100
> @@ -653,6 +653,10 @@ static void p54_rx_frame_sent(struct iee
>  		__skb_unlink(entry, &priv->tx_queue);
>  		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
> =20
> +		entry_hdr =3D (struct p54_hdr *) entry->data;
> +		entry_data =3D (struct p54_tx_data *) entry_hdr->data;
> +		priv->tx_stats[entry_data->hw_queue].len--;
> +
>  		if (unlikely(entry =3D=3D priv->cached_beacon)) {
>  			kfree_skb(entry);
>  			priv->cached_beacon =3D NULL;
> @@ -669,8 +673,6 @@ static void p54_rx_frame_sent(struct iee
>  		BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
>  				      status.ampdu_ack_len) !=3D 23);
> =20
> -		entry_hdr =3D (struct p54_hdr *) entry->data;
> -		entry_data =3D (struct p54_tx_data *) entry_hdr->data;
>  		if (entry_hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
>  			pad =3D entry_data->align[0];
> =20
> @@ -688,7 +690,6 @@ static void p54_rx_frame_sent(struct iee
>  			}
>  		}
> =20
> -		priv->tx_stats[entry_data->hw_queue].len--;
>  		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
>  		     (!payload->status))
>  			info->flags |=3D IEEE80211_TX_STAT_ACK;
> @@ -1005,6 +1006,26 @@ static int p54_sta_unlock(struct ieee802
>  	return 0;
>  }
> =20
> +static void p54_sta_notify(struct ieee80211_hw *dev, struct ieee80211_vi=
f *vif,
> +			      enum sta_notify_cmd notify_cmd,
> +			      struct ieee80211_sta *sta)
> +{
> +	switch (notify_cmd) {
> +	case STA_NOTIFY_ADD:
> +	case STA_NOTIFY_REMOVE:
> +	case STA_NOTIFY_AWAKE:
> +		/*
> +		 * Notify the firmware that we don't want or we don't
> +		 * need to buffer frames for this station anymore.
> +		 */
> +
> +		p54_sta_unlock(dev, sta->addr);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>  static int p54_tx_cancel(struct ieee80211_hw *dev, struct sk_buff *entry=
)
>  {
>  	struct p54_common *priv =3D dev->priv;
> @@ -1070,7 +1091,7 @@ static int p54_tx_fill(struct ieee80211_
>  		if (info->control.sta)
>  			*aid =3D info->control.sta->aid;
>  		else
> -			*flags =3D P54_HDR_FLAG_DATA_OUT_NOCANCEL;
> +			*flags |=3D P54_HDR_FLAG_DATA_OUT_NOCANCEL;
>  	}
>  	return ret;
>  }
> @@ -1083,7 +1104,7 @@ static int p54_tx(struct ieee80211_hw *d
>  	struct p54_hdr *hdr;
>  	struct p54_tx_data *txhdr;
>  	size_t padding, len, tim_len =3D 0;
> -	int i, j, ridx;
> +	int i, j, ridx, ret;
>  	u16 hdr_flags =3D 0, aid =3D 0;
>  	u8 rate, queue;
>  	u8 cts_rate =3D 0x20;
> @@ -1093,30 +1114,18 @@ static int p54_tx(struct ieee80211_hw *d
> =20
>  	queue =3D skb_get_queue_mapping(skb);
> =20
> -	if (p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid)) {
> -		current_queue =3D &priv->tx_stats[queue];
> -		if (unlikely(current_queue->len > current_queue->limit))
> -			return NETDEV_TX_BUSY;
> -		current_queue->len++;
> -		current_queue->count++;
> -		if (current_queue->len =3D=3D current_queue->limit)
> -			ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
> -	}
> +	ret =3D p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid)=
;
> +	current_queue =3D &priv->tx_stats[queue];
> +	if (unlikely((current_queue->len > current_queue->limit) && ret))
> +		return NETDEV_TX_BUSY;
> +	current_queue->len++;
> +	current_queue->count++;
> +	if ((current_queue->len =3D=3D current_queue->limit) && ret)
> +		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
> =20
>  	padding =3D (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))=
) & 3;
>  	len =3D skb->len;
> =20
> -	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) {
> -		if (info->control.sta)
> -			if (p54_sta_unlock(dev, info->control.sta->addr)) {
> -				if (current_queue) {
> -					current_queue->len--;
> -					current_queue->count--;
> -				}
> -				return NETDEV_TX_BUSY;
> -			}
> -	}
> -
>  	txhdr =3D (struct p54_tx_data *) skb_push(skb, sizeof(*txhdr) + padding=
);
>  	hdr =3D (struct p54_hdr *) skb_push(skb, sizeof(*hdr));
> =20
> @@ -1835,6 +1844,7 @@ static const struct ieee80211_ops p54_op
>  	.add_interface		=3D p54_add_interface,
>  	.remove_interface	=3D p54_remove_interface,
>  	.set_tim		=3D p54_set_tim,
> +	.sta_notify		=3D p54_sta_notify,
>  	.config			=3D p54_config,
>  	.config_interface	=3D p54_config_interface,
>  	.bss_info_changed	=3D p54_bss_info_changed,
> diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/=
p54/p54common.h
> --- a/drivers/net/wireless/p54/p54common.h	2008-11-28 20:18:53.000000000 =
+0100
> +++ b/drivers/net/wireless/p54/p54common.h	2008-11-28 20:27:59.000000000 =
+0100
> @@ -302,7 +302,7 @@ enum p54_frame_sent_status {
>  	P54_TX_OK =3D 0,
>  	P54_TX_FAILED,
>  	P54_TX_PSM,
> -	P54_TX_PSM_CANCELLED
> +	P54_TX_PSM_CANCELLED =3D 4
>  };
> =20
>  struct p54_frame_sent {
>=20

--=-Hh6TYeiz800EnPopr1vV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJMGAOAAoJEKVg1VMiehFYpNQP/1rNDr7jSYhseVI8iqnYMRgT
rTvLvOYxBmEO1o3R8YuRCikLfJwyKuhOYW101t3kE6fOgekFJQq+vQ0Z7x5lX4US
xu1yDNbdjVyhQ19TX9fm8qoJ560Kc/MaZ+qN2tOp70mctfDNxaVMIHSuR9wkv7UA
UuW93ii+EE/cTuJPCkgMHTDBt6T/Q1hesrWqrSKBQnwfxr4PyoAr4VPgcQipuWfg
vrYn1C1GT/Ti0Od2tK4UxWmLtW58sLrlN6d/BlK0CPVu3D6PlMH6Y6d3wIO1Noq4
NYJvQFan/CRI3BVwoPPl/9rGhzR8O8WN/km/FW3gvZFPZ1T8+9nps+yOUVNj2pho
jRICihAllLfUn8kJsrundDKDFwvqXvU0DTjZn3mAksPUQG/hOkl5xj1pD5UJ9pq9
9cAX4MHPVIOSJI95niuykIWN9LaObpmYC02EcEhr9CMAVOI4P/Qbpu5oZZGXWdvv
DoaX/6r5BYKIBxG1v7lpIn+RjwN+kG4GyERsRU053DEJTesFTvqsf2zaXkRD4TOR
cP5mIQ3/Apy9q5VMlmqZJgwOPRVRfBi/RxZ3RIUlTAHuLIMJQ+c2btCBiWgZ4BYF
xYwoPTWhyMPrxUySHyGcwGaT9btDx/jJinqCN6EMInIUHZQevOIhwhdh0WOYeZii
IsAT/F1QpdusRdZChgZI
=NF8n
-----END PGP SIGNATURE-----

--=-Hh6TYeiz800EnPopr1vV--

