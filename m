Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42691 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXKVNJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 08:09:19 -0500
Subject: Re: [PATCH 1/2] mac80211: hardware scan rework (V3)
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Ben Cahill <ben.m.cahill@intel.com>
In-Reply-To: <11957000022000-git-send-email-yi.zhu@intel.com> (sfid-20071122_025546_193726_74FCF3B9)
References: <11957000022000-git-send-email-yi.zhu@intel.com>
	 (sfid-20071122_025546_193726_74FCF3B9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I3diVkmTjuamCU5U+q+I"
Date: Thu, 22 Nov 2007 14:09:15 +0100
Message-Id: <1195736955.6323.99.camel@johannes.berg> (sfid-20071122_130924_134685_424C65E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I3diVkmTjuamCU5U+q+I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The scan code in mac80211 makes the software scan assumption in various
> places. For example, we stop the Tx queue during a software scan so that
> all the Tx packets will be queued by the stack. We also drop frames not
> related to scan in the software scan process. But these are not true for
> hardware scan.
>=20
> Some wireless hardwares (for example iwl3945/4965) has the ability to
> perform the whole scan process by hardware and/or firmware. The hardware
> scan is relative powerful in that it tries to maintain normal network
> traffic while doing a scan in the background. Some drivers (i.e iwlwifi)
> do provide a way to tune the hardware scan parameters (for example if the
> STA is associated, what's the max time could the STA leave from the
> associated channel, how long the scans get suspended after returning to
> the service channel, etc). But basically this is transparent to the
> stack. mac80211 should not stop Tx queues or drop Rx packets during a
> hardware scan.
>=20
> This patch resolves the above problem by spliting the current scan
> indicator local->sta_scanning into local->sta_sw_scanning and
> local->sta_hw_scanning. It then changes the scan related code to be aware
> of hardware scan or software scan in various places. With this patch,
> iwlwifi performs much better in the scan-while-associated condition and
> disable_hw_scan=3D1 should never be required.
>=20
> Cc: Mohamed Abbas <mohamed.abbas@intel.com>
> Cc: Ben Cahill <ben.m.cahill@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Looks good to me.
Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 59350b8..acbe717 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -351,11 +351,14 @@ static int ieee80211_stop(struct net_device *dev)
>  		synchronize_rcu();
>  		skb_queue_purge(&sdata->u.sta.skb_queue);
> =20
> -		if (!local->ops->hw_scan &&
> -		    local->scan_dev =3D=3D sdata->dev) {
> -			local->sta_scanning =3D 0;
> -			cancel_delayed_work(&local->scan_work);
> +		if (local->scan_dev =3D=3D sdata->dev) {
> +			if (!local->ops->hw_scan) {
> +				local->sta_sw_scanning =3D 0;
> +				cancel_delayed_work(&local->scan_work);
> +			} else
> +				local->sta_hw_scanning =3D 0;
>  		}
> +
>  		flush_workqueue(local->hw.workqueue);
>  		/* fall through */
>  	default:
> @@ -523,7 +526,7 @@ int ieee80211_hw_config(struct ieee80211_local *local=
)
>  	struct ieee80211_channel *chan;
>  	int ret =3D 0;
> =20
> -	if (local->sta_scanning) {
> +	if (local->sta_sw_scanning) {
>  		chan =3D local->scan_channel;
>  		mode =3D local->scan_hw_mode;
>  	} else {
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 72e1c93..35829b1 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -470,7 +470,8 @@ struct ieee80211_local {
> =20
>  	struct list_head interfaces;
> =20
> -	int sta_scanning;
> +	bool sta_sw_scanning;
> +	bool sta_hw_scanning;
>  	int scan_channel_idx;
>  	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
>  	unsigned long last_scan_completed;
> @@ -749,7 +750,8 @@ int ieee80211_sta_req_scan(struct net_device *dev, u8=
 *ssid, size_t ssid_len);
>  void ieee80211_sta_req_auth(struct net_device *dev,
>  			    struct ieee80211_if_sta *ifsta);
>  int ieee80211_sta_scan_results(struct net_device *dev, char *buf, size_t=
 len);
> -void ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
> +ieee80211_txrx_result ieee80211_sta_rx_scan(struct net_device *dev,
> +					    struct sk_buff *skb,
>  			   struct ieee80211_rx_status *rx_status);
>  void ieee80211_rx_bss_list_init(struct net_device *dev);
>  void ieee80211_rx_bss_list_deinit(struct net_device *dev);
> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioct=
l.c
> index 942b9cc..f2d84f3 100644
> --- a/net/mac80211/ieee80211_ioctl.c
> +++ b/net/mac80211/ieee80211_ioctl.c
> @@ -315,7 +315,7 @@ int ieee80211_set_channel(struct ieee80211_local *loc=
al, int channel, int freq)
>  	}
> =20
>  	if (set) {
> -		if (local->sta_scanning)
> +		if (local->sta_sw_scanning)
>  			ret =3D 0;
>  		else
>  			ret =3D ieee80211_hw_config(local);
> @@ -558,8 +558,10 @@ static int ieee80211_ioctl_giwscan(struct net_device=
 *dev,
>  {
>  	int res;
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> -	if (local->sta_scanning)
> +
> +	if (local->sta_sw_scanning || local->sta_hw_scanning)
>  		return -EAGAIN;
> +
>  	res =3D ieee80211_sta_scan_results(dev, extra, data->length);
>  	if (res >=3D 0) {
>  		data->length =3D res;
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 015b3f8..26f404a 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -1487,8 +1487,18 @@ static void ieee80211_rx_bss_info(struct net_devic=
e *dev,
>  		u32 supp_rates, prev_rates;
>  		int i, j;
> =20
> -		mode =3D local->sta_scanning ?
> +		mode =3D local->sta_sw_scanning ?
>  		       local->scan_hw_mode : local->oper_hw_mode;
> +
> +		if (local->sta_hw_scanning) {
> +			/* search for the correct mode matches the beacon */
> +			list_for_each_entry(mode, &local->modes_list, list)
> +				if (mode->mode =3D=3D rx_status->phymode)
> +					break;
> +
> +			if (mode =3D=3D NULL)
> +				mode =3D local->oper_hw_mode;
> +		}
>  		rates =3D mode->rates;
>  		num_rates =3D mode->num_rates;
> =20
> @@ -1871,31 +1881,39 @@ static void ieee80211_sta_rx_queued_mgmt(struct n=
et_device *dev,
>  }
> =20
>=20
> -void ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
> -			   struct ieee80211_rx_status *rx_status)
> +ieee80211_txrx_result
> +ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
> +		      struct ieee80211_rx_status *rx_status)
>  {
>  	struct ieee80211_mgmt *mgmt;
>  	u16 fc;
> =20
> -	if (skb->len < 24) {
> -		dev_kfree_skb(skb);
> -		return;
> -	}
> +	if (skb->len < 2)
> +		return TXRX_DROP;
> =20
>  	mgmt =3D (struct ieee80211_mgmt *) skb->data;
>  	fc =3D le16_to_cpu(mgmt->frame_control);
> =20
> +	if ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_CTL)
> +		return TXRX_CONTINUE;
> +
> +	if (skb->len < 24)
> +		return TXRX_DROP;
> +
>  	if ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_MGMT) {
>  		if ((fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_PROBE_RESP) {
>  			ieee80211_rx_mgmt_probe_resp(dev, mgmt,
>  						     skb->len, rx_status);
> +			dev_kfree_skb(skb);
> +			return TXRX_QUEUED;
>  		} else if ((fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_BEACON) =
{
>  			ieee80211_rx_mgmt_beacon(dev, mgmt, skb->len,
>  						 rx_status);
> +			dev_kfree_skb(skb);
> +			return TXRX_QUEUED;
>  		}
>  	}
> -
> -	dev_kfree_skb(skb);
> +	return TXRX_CONTINUE;
>  }
> =20
>=20
> @@ -1985,7 +2003,7 @@ void ieee80211_sta_work(struct work_struct *work)
>  	if (!netif_running(dev))
>  		return;
> =20
> -	if (local->sta_scanning)
> +	if (local->sta_sw_scanning || local->sta_hw_scanning)
>  		return;
> =20
>  	if (sdata->type !=3D IEEE80211_IF_TYPE_STA &&
> @@ -2643,9 +2661,15 @@ void ieee80211_scan_completed(struct ieee80211_hw =
*hw)
>  	union iwreq_data wrqu;
> =20
>  	local->last_scan_completed =3D jiffies;
> -	wmb();
> -	local->sta_scanning =3D 0;
> +	memset(&wrqu, 0, sizeof(wrqu));
> +	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
> =20
> +	if (local->sta_hw_scanning) {
> +		local->sta_hw_scanning =3D 0;
> +		goto done;
> +	}
> +
> +	local->sta_sw_scanning =3D 0;
>  	if (ieee80211_hw_config(local))
>  		printk(KERN_DEBUG "%s: failed to restore operational"
>  		       "channel after scan\n", dev->name);
> @@ -2661,9 +2685,6 @@ void ieee80211_scan_completed(struct ieee80211_hw *=
hw)
> =20
>  	netif_tx_unlock_bh(local->mdev);
> =20
> -	memset(&wrqu, 0, sizeof(wrqu));
> -	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
> -
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> =20
> @@ -2681,6 +2702,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *=
hw)
>  	}
>  	rcu_read_unlock();
> =20
> +done:
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	if (sdata->type =3D=3D IEEE80211_IF_TYPE_IBSS) {
>  		struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> @@ -2703,7 +2725,7 @@ void ieee80211_sta_scan_work(struct work_struct *wo=
rk)
>  	int skip;
>  	unsigned long next_delay =3D 0;
> =20
> -	if (!local->sta_scanning)
> +	if (!local->sta_sw_scanning)
>  		return;
> =20
>  	switch (local->scan_state) {
> @@ -2766,7 +2788,7 @@ void ieee80211_sta_scan_work(struct work_struct *wo=
rk)
>  		break;
>  	}
> =20
> -	if (local->sta_scanning)
> +	if (local->sta_sw_scanning)
>  		queue_delayed_work(local->hw.workqueue, &local->scan_work,
>  				   next_delay);
>  }
> @@ -2798,7 +2820,7 @@ static int ieee80211_sta_start_scan(struct net_devi=
ce *dev,
>  	  * ResultCode: SUCCESS, INVALID_PARAMETERS
>  	 */
> =20
> -	if (local->sta_scanning) {
> +	if (local->sta_sw_scanning || local->sta_hw_scanning) {
>  		if (local->scan_dev =3D=3D dev)
>  			return 0;
>  		return -EBUSY;
> @@ -2806,15 +2828,15 @@ static int ieee80211_sta_start_scan(struct net_de=
vice *dev,
> =20
>  	if (local->ops->hw_scan) {
>  		int rc =3D local->ops->hw_scan(local_to_hw(local),
> -					    ssid, ssid_len);
> +					     ssid, ssid_len);
>  		if (!rc) {
> -			local->sta_scanning =3D 1;
> +			local->sta_hw_scanning =3D 1;
>  			local->scan_dev =3D dev;
>  		}
>  		return rc;
>  	}
> =20
> -	local->sta_scanning =3D 1;
> +	local->sta_sw_scanning =3D 1;
> =20
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> @@ -2869,7 +2891,7 @@ int ieee80211_sta_req_scan(struct net_device *dev, =
u8 *ssid, size_t ssid_len)
>  	if (sdata->type !=3D IEEE80211_IF_TYPE_STA)
>  		return ieee80211_sta_start_scan(dev, ssid, ssid_len);
> =20
> -	if (local->sta_scanning) {
> +	if (local->sta_sw_scanning || local->sta_hw_scanning) {
>  		if (local->scan_dev =3D=3D dev)
>  			return 0;
>  		return -EBUSY;
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 428a9fc..596ff71 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -338,8 +338,14 @@ ieee80211_rx_h_passive_scan(struct ieee80211_txrx_da=
ta *rx)
>  	struct ieee80211_local *local =3D rx->local;
>  	struct sk_buff *skb =3D rx->skb;
> =20
> -	if (unlikely(local->sta_scanning !=3D 0)) {
> -		ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
> +	if (unlikely(local->sta_hw_scanning))
> +		return ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
> +
> +	if (unlikely(local->sta_sw_scanning)) {
> +		/* drop all the other packets during a software scan anyway */
> +		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status)
> +		    !=3D TXRX_QUEUED)
> +			dev_kfree_skb(skb);
>  		return TXRX_QUEUED;
>  	}
> =20
> @@ -1486,7 +1492,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct=
 sk_buff *skb,
>  		goto end;
>  	}
> =20
> -	if (unlikely(local->sta_scanning))
> +	if (unlikely(local->sta_sw_scanning || local->sta_hw_scanning))
>  		rx.flags |=3D IEEE80211_TXRXD_RXIN_SCAN;
> =20
>  	if (__ieee80211_invoke_rx_handlers(local, local->rx_pre_handlers, &rx,
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 1a53154..a6a657f 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -225,7 +225,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data=
 *tx)
>  	if (unlikely(tx->flags & IEEE80211_TXRXD_TX_INJECTED))
>  		return TXRX_CONTINUE;
> =20
> -	if (unlikely(tx->local->sta_scanning !=3D 0) &&
> +	if (unlikely(tx->local->sta_sw_scanning) &&
>  	    ((tx->fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_MGMT ||
>  	     (tx->fc & IEEE80211_FCTL_STYPE) !=3D IEEE80211_STYPE_PROBE_REQ))
>  		return TXRX_DROP;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-I3diVkmTjuamCU5U+q+I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0V/eaVg1VMiehFYAQL9ww/+NivMG4q+XfCx9VWgn418ihYxtpqFtyZP
OW55+dvioanW52BSHWqZRITUdv3u+J8bE0JNy34iW3meFUw/WT8f/+LsUH8UDMQd
TbKlItkWDrx48xNQX0j5Rg7WcOEpEFoXbaFp/pGm4vfWvnkAvQYkyt6Pj06DFUCX
lPG3c4atuG30wARWt3zhLKZYgzqtlQsuEbRkqCIrkCLgBSJhn6by6/NEvpHmrxLW
BUGfLO1CIrm4oPHbAVYIc/JE7qbWjs2EnOW00ApGiPqUyKGF56Ow4cXRItV54n94
91y7TJoKrGVlTZNdalY8gk097i/BWdgUWc5H3iW/70VoecemkLF1n4whygcuEo8F
Oj0+ioHLbAGBKLHTPkuzaesSUZXe4G6VVyW6OtA5I2rJv82VE54S9Dn6CUbTCqAa
wF/J/4myqI0kXbGHhy1NbFFlEsA7Aw79lLFDVdEgYTis4FzU/tiJwvDw9G/txQRX
wGTp3DHRiNIX/03rFB8QTJT02ZxBFpNgErx4DZbPQso6qB2uF3ZFFKgI2eurESpu
mq5xgLGQy+WciirbP4+m+oqMIRCbrHRXkLhs2uI1i69s1X6bK24iHDcI4fsyQh6F
Z3hByH/xtBKK8lIQzFdWaz3hQdrmgI+jwd4D5a+Vy9HGkbxVcsnvrQjg7CS1Oigt
XgLGORIP9JA=
=tZrr
-----END PGP SIGNATURE-----

--=-I3diVkmTjuamCU5U+q+I--

