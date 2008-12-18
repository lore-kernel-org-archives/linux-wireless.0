Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49347 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYLRVXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:23:16 -0500
Subject: Re: [PATCH v5 2/3] mac80211: track master queue status
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081218211705.6842.84538.stgit@tikku> (sfid-20081218_221726_933579_333715AC)
References: <20081218211532.6842.88104.stgit@tikku>
	 <20081218211705.6842.84538.stgit@tikku>
	 (sfid-20081218_221726_933579_333715AC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RDYgt6jZ5tSArK94XF8Y"
Date: Thu, 18 Dec 2008 22:23:16 +0100
Message-Id: <1229635397.3601.47.camel@johannes.berg> (sfid-20081218_222324_524380_D3B78FE7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RDYgt6jZ5tSArK94XF8Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-18 at 23:17 +0200, Kalle Valo wrote:
> This is a preparation for the dynamic power save support. In future there=
 are
> two paths to stop the master queues and we need to track this properly to
> avoid starting queues incorrectly. Implement this by adding a status
> array for each queue.
>=20
> The original idea and design is from Johannes Berg, I just did
> the implementation based on his notes. All the bugs are mine, of course.
>=20
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>

Looks good, thanks

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/ieee80211_i.h |   12 ++++++
>  net/mac80211/main.c        |    2 +
>  net/mac80211/util.c        |   86 ++++++++++++++++++++++++++++++++++++++=
+++---
>  3 files changed, 93 insertions(+), 7 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 18b9160..a74d673 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -538,6 +538,10 @@ enum {
>  	IEEE80211_ADDBA_MSG	=3D 4,
>  };
> =20
> +enum queue_stop_reason {
> +	IEEE80211_QUEUE_STOP_REASON_DRIVER,
> +};
> +
>  /* maximum number of hardware queues we support. */
>  #define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES=
)
> =20
> @@ -554,7 +558,8 @@ struct ieee80211_local {
>  	const struct ieee80211_ops *ops;
> =20
>  	unsigned long queue_pool[BITS_TO_LONGS(QD_MAX_QUEUES)];
> -
> +	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES];
> +	spinlock_t queue_stop_reason_lock;
>  	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
>  	int open_count;
>  	int monitors, cooked_mntrs;
> @@ -972,6 +977,11 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data =
*sdata, int freq);
>  u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
>  			      enum ieee80211_band band);
> =20
> +void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
> +				     enum queue_stop_reason reason);
> +void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
> +				     enum queue_stop_reason reason);
> +
>  #ifdef CONFIG_MAC80211_NOINLINE
>  #define debug_noinline noinline
>  #else
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index a0371ca..7c6e90a 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -724,6 +724,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_d=
ata_len,
> =20
>  	spin_lock_init(&local->key_lock);
> =20
> +	spin_lock_init(&local->queue_stop_reason_lock);
> +
>  	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
> =20
>  	sta_info_init(local);
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 71a8391..fb89e1d 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -330,10 +330,20 @@ __le16 ieee80211_ctstoself_duration(struct ieee8021=
1_hw *hw,
>  }
>  EXPORT_SYMBOL(ieee80211_ctstoself_duration);
> =20
> -void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
> +static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
> +				   enum queue_stop_reason reason)
>  {
>  	struct ieee80211_local *local =3D hw_to_local(hw);
> =20
> +	/* we don't need to track ampdu queues */
> +	if (queue < ieee80211_num_regular_queues(hw)) {
> +		__clear_bit(reason, &local->queue_stop_reasons[queue]);
> +
> +		if (local->queue_stop_reasons[queue] !=3D 0)
> +			/* someone still has this queue stopped */
> +			return;
> +	}
> +
>  	if (test_bit(queue, local->queues_pending)) {
>  		set_bit(queue, local->queues_pending_run);
>  		tasklet_schedule(&local->tx_pending_tasklet);
> @@ -341,22 +351,74 @@ void ieee80211_wake_queue(struct ieee80211_hw *hw, =
int queue)
>  		netif_wake_subqueue(local->mdev, queue);
>  	}
>  }
> +
> +void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
> +				    enum queue_stop_reason reason)
> +{
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> +	__ieee80211_wake_queue(hw, queue, reason);
> +	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
> +}
> +
> +void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
> +{
> +	ieee80211_wake_queue_by_reason(hw, queue,
> +				       IEEE80211_QUEUE_STOP_REASON_DRIVER);
> +}
>  EXPORT_SYMBOL(ieee80211_wake_queue);
> =20
> -void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
> +static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
> +				   enum queue_stop_reason reason)
>  {
>  	struct ieee80211_local *local =3D hw_to_local(hw);
> =20
> +	/* we don't need to track ampdu queues */
> +	if (queue < ieee80211_num_regular_queues(hw))
> +		__set_bit(reason, &local->queue_stop_reasons[queue]);
> +
>  	netif_stop_subqueue(local->mdev, queue);
>  }
> +
> +void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
> +				    enum queue_stop_reason reason)
> +{
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> +	__ieee80211_stop_queue(hw, queue, reason);
> +	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
> +}
> +
> +void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
> +{
> +	ieee80211_stop_queue_by_reason(hw, queue,
> +				       IEEE80211_QUEUE_STOP_REASON_DRIVER);
> +}
>  EXPORT_SYMBOL(ieee80211_stop_queue);
> =20
> -void ieee80211_stop_queues(struct ieee80211_hw *hw)
> +void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
> +				    enum queue_stop_reason reason)
>  {
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	unsigned long flags;
>  	int i;
> =20
> +	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> +
>  	for (i =3D 0; i < ieee80211_num_queues(hw); i++)
> -		ieee80211_stop_queue(hw, i);
> +		__ieee80211_stop_queue(hw, i, reason);
> +
> +	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
> +}
> +
> +void ieee80211_stop_queues(struct ieee80211_hw *hw)
> +{
> +	ieee80211_stop_queues_by_reason(hw,
> +					IEEE80211_QUEUE_STOP_REASON_DRIVER);
>  }
>  EXPORT_SYMBOL(ieee80211_stop_queues);
> =20
> @@ -367,12 +429,24 @@ int ieee80211_queue_stopped(struct ieee80211_hw *hw=
, int queue)
>  }
>  EXPORT_SYMBOL(ieee80211_queue_stopped);
> =20
> -void ieee80211_wake_queues(struct ieee80211_hw *hw)
> +void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
> +				     enum queue_stop_reason reason)
>  {
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	unsigned long flags;
>  	int i;
> =20
> +	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> +
>  	for (i =3D 0; i < hw->queues + hw->ampdu_queues; i++)
> -		ieee80211_wake_queue(hw, i);
> +		__ieee80211_wake_queue(hw, i, reason);
> +
> +	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
> +}
> +
> +void ieee80211_wake_queues(struct ieee80211_hw *hw)
> +{
> +	ieee80211_wake_queues_by_reason(hw, IEEE80211_QUEUE_STOP_REASON_DRIVER)=
;
>  }
>  EXPORT_SYMBOL(ieee80211_wake_queues);
> =20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-RDYgt6jZ5tSArK94XF8Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJSr9BAAoJEKVg1VMiehFY6FgP/3uja+wDcYcO1e0ui9PJ7fvs
tKL6/vmy6alNkAbIhK4xGDuarvCBWaMt6VRsLuOiIdicX1a+BjBZR55DWMPe9jVo
x6M3M1cJUqCewCBoLimFVHBcxiLVYxmgixrRBAGTAhvF/pxCgWfWzy3Un6WWvRH8
L83KYPkVw8NqJcbXaD3UXBbyQeVZxlOhXdqwKmPd+1hB3ZBEIz2/TrbZv9EZbY9h
ZxkGMajZE4Eld3/gM65ouma+50E54wt0jCNXWpLhRxa0zFrf40sm1StWnYZH5hz0
n3qz58JJpyte5ONgOVYkmB4Zhis28SxjNZqzcoqcgP0SBs7ZLwLlKwy+T2MMqxsy
GMXB0uENugcPn9Sl2pjeU3d4UDXHLgkQfuXAM1H4/Neb1P3ibSXEXQqxPM4GK3Tl
I0ZpocrteorAe57ALc6924Va2wzz+Sf9iKIHVMTi7yaOoJ7GsA7dcwa170ZkM7kf
exJS0wEpZemQgKC06Hqs85qvl88eh9/Sbx8A39P9jxUyIgE76sfi4lPUpnL9Ljcr
4ht2saAmN0E77O4yhDYnS2ac1kD+Fz22YlqeXrt59VpfuMqa8wjDBzUEpn7D9Kcc
/7OKB1DKa573cjTJUuX/0EzmsXFbboOzet85k9l9KqpF/VDh1hXY8OLFiBZ/tLZx
Rt3eJZvqaz3GLylVxhGs
=O9W+
-----END PGP SIGNATURE-----

--=-RDYgt6jZ5tSArK94XF8Y--

