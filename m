Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYL3Keo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 05:34:44 -0500
Subject: Re: [RFC v2] mac80211: Add 802.11h CSA support
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org, jouni.malinen@atheros.com
In-Reply-To: <18777.63336.140527.717269@localhost.localdomain> (sfid-20081230_112914_631451_C0C144BB)
References: <18777.63336.140527.717269@localhost.localdomain>
	 (sfid-20081230_112914_631451_C0C144BB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MvcsJRUZ68btK6cdTfRA"
Date: Tue, 30 Dec 2008 11:35:05 +0100
Message-Id: <1230633305.3850.2.camel@johannes> (sfid-20081230_113448_470235_52E83E9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MvcsJRUZ68btK6cdTfRA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-30 at 15:56 +0530, Sujith wrote:
> Move to the advertised channel on reception of
> a CSA element. This is needed for 802.11h compliance.

Looks good, two small things:

> @@ -1645,6 +1645,12 @@ static void ieee80211_rx_bss_info(struct ieee80211=
_sub_if_data *sdata,
>  	if (!bss)
>  		return;
> =20
> +	if (elems->ch_switch_elem && (elems->ch_switch_elem_len =3D=3D 3)) {
> +		struct ieee80211_channel_sw_ie *sw_elem =3D
> +			(struct ieee80211_channel_sw_ie *)elems->ch_switch_elem;
> +		ieee80211_process_chanswitch(sdata, sw_elem);
> +	}
> +
>  	/* was just updated in ieee80211_bss_info_update */
>  	beacon_timestamp =3D bss->timestamp;

We already have a bss pointer here, would it be better to pass that in,
avoid the bss lookup, and do the bss lookup manually in the action frame
case, to avoid a double lookup here?

> +void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
> +				  struct ieee80211_channel_sw_ie *sw_elem)
> +{
> +	struct ieee80211_bss *bss;
> +	struct ieee80211_channel *new_ch;
> +	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +	int ret, exp;
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
> +	bss =3D ieee80211_rx_bss_get(sdata->local, ifsta->bssid,
> +				   sdata->local->hw.conf.channel->center_freq,
> +				   ifsta->ssid, ifsta->ssid_len);
> +	if (!bss)
> +		return;
> +
> +	sdata->local->oper_channel =3D new_ch;
> +
> +	if (sw_elem->count <=3D 1) {
> +		ret =3D ieee80211_hw_config(sdata->local,
> +					  IEEE80211_CONF_CHANGE_CHANNEL);

Didn't you want to put this into the workqueue?

johannes

--=-MvcsJRUZ68btK6cdTfRA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWflVAAoJEKVg1VMiehFYVxkP/2zBHe1O3Aj8JAB84KLy6arj
2jm24QZA857odKxLeMLkJtapraVY/uoUJwRSRXVPlS3LFwENDUjVPqSDxdYJBpcu
pZFXTTug5ujoC7IO7s3PQNXKFD7Or7/Z5x7dVwqHg/bTi3PvaMRiXiw+Zrqfrm8W
91hUZ+mESjXQrWlpMvLuzef+7YzeksWLNabPZY6QGD71zVUJbnaYy0gQ4OESod4O
UfBSmoNhd2dEVcWIAayEyPXXq+LpWRUl7Q3w0EmSZRzSb4k2uYgUFr2jcp3P0Tho
tDDB4MTdffNjMvrUfnnKu2vCU8Rxku27gJepQpVw8cPijUI2jVDuDpyorBjsHG4+
TuoGZF+XlScdiopCRfQurr0TbzwjComRmrcb3ix6xNoFs3WY13Uf7bKMNz+uJNnG
WlrAwNwR/2jHdXCZBr4Pp9uoR9bUrg/dCeHmd3mlpvldyTPiob0IdwUEfc8258xd
2TGda0Mzq7ljhfhqtRNQiXG0M0ZqXobSead85HoAXm3G5l7O5TxmLKEPPiKjEQA3
b3B4z5Hzn/2L/uT2QmwzZg95w1dzSKRoMxMLCMJx4HU3QMzoYkuseYKIBb+n/WAk
yGJJ/D6GpzwbYDlqWo8QEvNnlkqLKARf+YTZWL/1QvQjOCUXy90Ez4/vcDFxB6oF
UI9xBrF3xFg1Fr04fkQS
=WFv+
-----END PGP SIGNATURE-----

--=-MvcsJRUZ68btK6cdTfRA--

