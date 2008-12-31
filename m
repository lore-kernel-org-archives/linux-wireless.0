Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbYLaKTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 05:19:41 -0500
Subject: Re: [PATCH] mac80211: Add 802.11h CSA support
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18779.17630.122619.462997@gargle.gargle.HOWL>
References: <18779.17630.122619.462997@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X6uDGvzEmpUeYRblRQMU"
Date: Wed, 31 Dec 2008 11:20:12 +0100
Message-Id: <1230718812.4065.7.camel@johannes> (sfid-20081231_111945_338527_9CFBE1D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X6uDGvzEmpUeYRblRQMU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-31 at 15:39 +0530, Sujith wrote:
> Move to the advertised channel on reception of
> a CSA element. This is needed for 802.11h compliance.
>=20
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

One thing I've been wondering about though, should we have a hook into
the driver to actually stop transmit at a lower level, where possible?
For example Broadcom hardware we can actually set some value on the chip
and then let it reject all frames, drain its FIFOs, and then in the
driver we could schedule those frames again for afterwards.

One other small note:

> +	bss =3D ieee80211_rx_bss_get(sdata->local, ifsta->bssid,
> +				   sdata->local->hw.conf.channel->center_freq,
> +				   ifsta->ssid, ifsta->ssid_len);
> +	if (!bss)
> +		goto exit;
> +
> +	if (!ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL))
> +		bss->freq =3D sdata->local->oper_channel->center_freq;

This looks a little odd. (read on)


> +void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
> +				  struct ieee80211_channel_sw_ie *sw_elem,
> +				  struct ieee80211_bss *bss)
> +{
> +	struct ieee80211_channel *new_ch;
> +	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +	int new_freq =3D ieee80211_channel_to_frequency(sw_elem->new_ch_num);
> +	int exp;
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
> +	sdata->local->oper_channel =3D new_ch;

Here you're setting oper_channel, but is that really the right thing to
do? That means any hw config call that comes in between this and later
will already switch to that channel, and hw config can happen for
various other reasons, for instance PS mode stuff. I think we may need
to have a separate variable?

johannes

--=-X6uDGvzEmpUeYRblRQMU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJW0dZAAoJEKVg1VMiehFYxfsQAL4YFZKCuvRO8l8sZKqnaWGD
qZdzUX+e357yEF0oQ9/xqyCGKvaFr/58+VO2ShmEc+RU0OljmdjzIev1LyHspG3M
qG67XEmyN95BUYus+unPpL/qNMqh7BGQaOCbIuxiwEc0UXAS5Qbkd+xVLp9jH0WV
BAnCYwB7A+BXIe5OtY2GcKrPIlqLuIYe1/TZMcR+n/N8tVWoxvwpEEfHGe/VBiF5
qwcPDj2qj9wIKSnTebYYfHKkHHwUK8Xpe8RtD991mgMjXdKp/MvoMLgtwyzFnYdE
IiTLpfl0d0kYCAICflc3WPVYSbpRpOSn8ehgIn0F9onj7s86/xr+xb4XKb/GCRkt
wFF4O49Jziw/8qF57qK6YYzuMiRxhjGDpx46Fho3SKNIFExJthJ/XA2fSQBeEGqF
yTqeTNlz7d2joU80ljbUFdRY9DWAWyLulOPPq4fj1UdKpC/uo88FszbCE3KVMx+h
U79gG6mP/DJEaCMFj6rlM10dUgZfgMTWfcKAOKMWuQCbJJNwaDHizzGlD5Xz1XGI
Xgv2PRrpOeZs03RUdXXAO5FoKOR82w8EJ1Tq9bhdA5lbnKK2bbyKNRSnEEuUviUz
1F/Ze6FtzyDRagTzrcsUiE3VazKVil4kOTup8kRibDssL29j0zeYzlycPvY5QpoA
5lck7cedYmNDkuczTiH5
=4+BE
-----END PGP SIGNATURE-----

--=-X6uDGvzEmpUeYRblRQMU--

