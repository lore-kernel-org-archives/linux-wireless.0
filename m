Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZAFNE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 08:04:56 -0500
Subject: Re: [PATCH] mac80211: Add 802.11h CSA support
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18786.55021.734826.472061@gargle.gargle.HOWL>
References: <18786.55021.734826.472061@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OZtmPPRr1t7cVpX2X1pj"
Date: Tue, 06 Jan 2009 14:05:46 +0100
Message-Id: <1231247146.3503.9.camel@johannes> (sfid-20090106_140500_467917_1AF865D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OZtmPPRr1t7cVpX2X1pj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-06 at 09:28 +0530, Sujith wrote:
> Move to the advertised channel on reception of
> a CSA element. This is needed for 802.11h compliance.
>=20
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Looks good to me now, sorry about the ping pong.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> v2
> --
> * Add a new variable to hold the CSA channel=20
> * Use msecs_to_jiffies for calculating expiration time
> * Add a check to drop beacons in case of a frequency mismatch
>=20
> v3
> --
> * Add a BSSID check when handling CSA action frame
>=20
>  net/mac80211/ieee80211_i.h |   11 ++++++-
>  net/mac80211/iface.c       |    2 +
>  net/mac80211/mlme.c        |   13 +++++++
>  net/mac80211/rx.c          |   20 +++++++++++
>  net/mac80211/spectmgmt.c   |   77 ++++++++++++++++++++++++++++++++++++++=
++++++
>  5 files changed, 122 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 117718b..d2a007a 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -259,6 +259,7 @@ struct mesh_preq_queue {
>  #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
>  #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
>  #define IEEE80211_STA_TKIP_WEP_USED	BIT(14)
> +#define IEEE80211_STA_CSA_RECEIVED	BIT(15)
>  /* flags for MLME request */
>  #define IEEE80211_STA_REQ_SCAN 0
>  #define IEEE80211_STA_REQ_DIRECT_PROBE 1
> @@ -283,7 +284,9 @@ enum ieee80211_sta_mlme_state {
> =20
>  struct ieee80211_if_sta {
>  	struct timer_list timer;
> +	struct timer_list chswitch_timer;
>  	struct work_struct work;
> +	struct work_struct chswitch_work;
>  	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
>  	u8 ssid[IEEE80211_MAX_SSID_LEN];
>  	enum ieee80211_sta_mlme_state state;
> @@ -542,6 +545,7 @@ enum {
>  enum queue_stop_reason {
>  	IEEE80211_QUEUE_STOP_REASON_DRIVER,
>  	IEEE80211_QUEUE_STOP_REASON_PS,
> +	IEEE80211_QUEUE_STOP_REASON_CSA
>  };
> =20
>  /* maximum number of hardware queues we support. */
> @@ -631,7 +635,7 @@ struct ieee80211_local {
>  	unsigned long last_scan_completed;
>  	struct delayed_work scan_work;
>  	struct ieee80211_sub_if_data *scan_sdata;
> -	struct ieee80211_channel *oper_channel, *scan_channel;
> +	struct ieee80211_channel *oper_channel, *scan_channel, *csa_channel;
>  	enum nl80211_channel_type oper_channel_type;
>  	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
>  	size_t scan_ssid_len;
> @@ -964,6 +968,11 @@ void ieee80211_process_addba_request(struct ieee8021=
1_local *local,
>  void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sda=
ta,
>  				       struct ieee80211_mgmt *mgmt,
>  				       size_t len);
> +void ieee80211_chswitch_timer(unsigned long data);
> +void ieee80211_chswitch_work(struct work_struct *work);
> +void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
> +				  struct ieee80211_channel_sw_ie *sw_elem,
> +				  struct ieee80211_bss *bss);
> =20
>  /* utility functions/constants */
>  extern void *mac80211_wiphy_privid; /* for wiphy privid */
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 2c7a87d..f927641 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -443,6 +443,7 @@ static int ieee80211_stop(struct net_device *dev)
>  						WLAN_REASON_DEAUTH_LEAVING);
> =20
>  		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
> +		del_timer_sync(&sdata->u.sta.chswitch_timer);
>  		del_timer_sync(&sdata->u.sta.timer);
>  		/*
>  		 * If the timer fired while we waited for it, it will have
> @@ -452,6 +453,7 @@ static int ieee80211_stop(struct net_device *dev)
>  		 * it no longer is.
>  		 */
>  		cancel_work_sync(&sdata->u.sta.work);
> +		cancel_work_sync(&sdata->u.sta.chswitch_work);
>  		/*
>  		 * When we get here, the interface is marked down.
>  		 * Call synchronize_rcu() to wait for the RX path
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index e317c6d..4d25cf9 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1645,6 +1645,13 @@ static void ieee80211_rx_bss_info(struct ieee80211=
_sub_if_data *sdata,
>  	if (!bss)
>  		return;
> =20
> +	if (elems->ch_switch_elem && (elems->ch_switch_elem_len =3D=3D 3) &&
> +	    (memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) =3D=3D 0)) {
> +		struct ieee80211_channel_sw_ie *sw_elem =3D
> +			(struct ieee80211_channel_sw_ie *)elems->ch_switch_elem;
> +		ieee80211_process_chanswitch(sdata, sw_elem, bss);
> +	}
> +
>  	/* was just updated in ieee80211_bss_info_update */
>  	beacon_timestamp =3D bss->timestamp;
> =20
> @@ -1781,6 +1788,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee802=
11_sub_if_data *sdata,
>  	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) !=3D 0)
>  		return;
> =20
> +	if (rx_status->freq !=3D local->hw.conf.channel->center_freq)
> +		return;
> +
>  	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
>  				 elems.wmm_param_len);
> =20
> @@ -2447,8 +2457,11 @@ void ieee80211_sta_setup_sdata(struct ieee80211_su=
b_if_data *sdata)
> =20
>  	ifsta =3D &sdata->u.sta;
>  	INIT_WORK(&ifsta->work, ieee80211_sta_work);
> +	INIT_WORK(&ifsta->chswitch_work, ieee80211_chswitch_work);
>  	setup_timer(&ifsta->timer, ieee80211_sta_timer,
>  		    (unsigned long) sdata);
> +	setup_timer(&ifsta->chswitch_timer, ieee80211_chswitch_timer,
> +		    (unsigned long) sdata);
>  	skb_queue_head_init(&ifsta->skb_queue);
> =20
>  	ifsta->capab =3D WLAN_CAPABILITY_ESS;
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 384cb3b..4b7bc3d 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1564,7 +1564,9 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>  {
>  	struct ieee80211_local *local =3D rx->local;
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(rx->dev=
);
> +	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
>  	struct ieee80211_mgmt *mgmt =3D (struct ieee80211_mgmt *) rx->skb->data=
;
> +	struct ieee80211_bss *bss;
>  	int len =3D rx->skb->len;
> =20
>  	if (!ieee80211_is_action(mgmt->frame_control))
> @@ -1613,6 +1615,24 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx=
)
>  				return RX_DROP_MONITOR;
>  			ieee80211_process_measurement_req(sdata, mgmt, len);
>  			break;
> +		case WLAN_ACTION_SPCT_CHL_SWITCH:
> +			if (len < (IEEE80211_MIN_ACTION_SIZE +
> +				   sizeof(mgmt->u.action.u.chan_switch)))
> +				return RX_DROP_MONITOR;
> +
> +			if (memcmp(mgmt->bssid, ifsta->bssid, ETH_ALEN) !=3D 0)
> +				return RX_DROP_MONITOR;
> +
> +			bss =3D ieee80211_rx_bss_get(local, ifsta->bssid,
> +					   local->hw.conf.channel->center_freq,
> +					   ifsta->ssid, ifsta->ssid_len);
> +			if (!bss)
> +				return RX_DROP_MONITOR;
> +
> +			ieee80211_process_chanswitch(sdata,
> +				     &mgmt->u.action.u.chan_switch.sw_elem, bss);
> +			ieee80211_rx_bss_put(local, bss);
> +			break;
>  		}
>  		break;
>  	default:
> diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
> index f72bad6..22ad480 100644
> --- a/net/mac80211/spectmgmt.c
> +++ b/net/mac80211/spectmgmt.c
> @@ -84,3 +84,80 @@ void ieee80211_process_measurement_req(struct ieee8021=
1_sub_if_data *sdata,
>  			mgmt->sa, mgmt->bssid,
>  			mgmt->u.action.u.measurement.dialog_token);
>  }
> +
> +void ieee80211_chswitch_work(struct work_struct *work)
> +{
> +	struct ieee80211_sub_if_data *sdata =3D
> +		container_of(work, struct ieee80211_sub_if_data, u.sta.chswitch_work);
> +	struct ieee80211_bss *bss;
> +	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +
> +	if (!netif_running(sdata->dev))
> +		return;
> +
> +	bss =3D ieee80211_rx_bss_get(sdata->local, ifsta->bssid,
> +				   sdata->local->hw.conf.channel->center_freq,
> +				   ifsta->ssid, ifsta->ssid_len);
> +	if (!bss)
> +		goto exit;
> +
> +	sdata->local->oper_channel =3D sdata->local->csa_channel;
> +	if (!ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL))
> +		bss->freq =3D sdata->local->oper_channel->center_freq;
> +
> +	ieee80211_rx_bss_put(sdata->local, bss);
> +exit:
> +	ifsta->flags &=3D ~IEEE80211_STA_CSA_RECEIVED;
> +	ieee80211_wake_queues_by_reason(&sdata->local->hw,
> +					IEEE80211_QUEUE_STOP_REASON_CSA);
> +}
> +
> +void ieee80211_chswitch_timer(unsigned long data)
> +{
> +	struct ieee80211_sub_if_data *sdata =3D
> +		(struct ieee80211_sub_if_data *) data;
> +	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +
> +	queue_work(sdata->local->hw.workqueue, &ifsta->chswitch_work);
> +}
> +
> +void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
> +				  struct ieee80211_channel_sw_ie *sw_elem,
> +				  struct ieee80211_bss *bss)
> +{
> +	struct ieee80211_channel *new_ch;
> +	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +	int new_freq =3D ieee80211_channel_to_frequency(sw_elem->new_ch_num);
> +
> +	/* FIXME: Handle ADHOC later */
> +	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> +		return;
> +
> +	if (ifsta->state !=3D IEEE80211_STA_MLME_ASSOCIATED)
> +		return;
> +
> +	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
> +		return;
> +
> +	/* Disregard subsequent beacons if we are already running a timer
> +	   processing a CSA */
> +
> +	if (ifsta->flags & IEEE80211_STA_CSA_RECEIVED)
> +		return;
> +
> +	new_ch =3D ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
> +	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED)
> +		return;
> +
> +	sdata->local->csa_channel =3D new_ch;
> +
> +	if (sw_elem->count <=3D 1) {
> +		queue_work(sdata->local->hw.workqueue, &ifsta->chswitch_work);
> +	} else {
> +		ieee80211_stop_queues_by_reason(&sdata->local->hw,
> +						IEEE80211_QUEUE_STOP_REASON_CSA);
> +		ifsta->flags |=3D IEEE80211_STA_CSA_RECEIVED;
> +		mod_timer(&ifsta->chswitch_timer,
> +			  jiffies + msecs_to_jiffies(sw_elem->count * bss->beacon_int));
> +	}
> +}

--=-OZtmPPRr1t7cVpX2X1pj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJY1cnAAoJEKVg1VMiehFYY5UP/27ow3ZAoY4oC2FPbWz86bcW
9xSifG6rfyYMgZ/aS2jrTD1coMKlHFH2NUoOP5UO32ialtfJ/S9pDU6yQm8vNBsb
fxOikUtEYCJLpiNvdO4SCcYyVzC4cUV9WIKvqBhz2xK8j/tLLwjZJpz18N0RaMSE
L+ekU4uV5apTzX9T0qBUM23ORJgTt1CZmZPv1hn41NVOm6RRsZJlvaX7qfcdOhxv
Dv+xcYFWBN/wgSpOlkQ6DJBs1n+t4JMi5HXoiVWpSEAMGR96o/iiZcgvdaXeKCJ5
dglfUHvYvWBgJv5gBXcWMAOucWmhDZsLBEWu6xRiyhdaVQfy2SP2p+/iHdzUK5AB
RKGFb9jqMm99bwLXgSQpu+SZdPMJ5jqxOxKdT4zoWctqpET7i8GhxE4UDtKlxuCg
1PFxJ5gOVjiKm1/U8zZSs0RfwxtJ8yWperKV6K77xFaYcSOpd20hMXWRjsGgWggY
fl9OyJNxsD9pfhEL1Q2XlsXmui72uCOEKojfYoZR08oI/PrrklMLMtUG+pMmafL5
uQEkigqxryIYo4/8KxxGVDWpSrJ9vAsLNsYoJuY/vUPAtHseEFEdzGJnByRRth0o
e5V2G0e6sor+Pu9QSBglIFHHGEx1Uo18ByRdFWsPMTWny7vu+uzL81WN7wPDVpA6
g47Wlvez4MmjAFeKQNBw
=sBEB
-----END PGP SIGNATURE-----

--=-OZtmPPRr1t7cVpX2X1pj--

