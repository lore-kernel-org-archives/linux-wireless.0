Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60923 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbYFJTBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 15:01:32 -0400
Subject: Re: [PATCH RFC] mac80211_hwsim
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080610183722.GA7377@jm.kir.nu>
References: <20080610105058.GA6961@jm.kir.nu>
	 <1213096575.3668.6.camel@johannes.berg>
	 <20080610123007.GB1571@tuxdriver.com>
	 <1213103469.3668.13.camel@johannes.berg>
	 <20080610152418.GD13267@tuxdriver.com>  <20080610183722.GA7377@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K1rXZ2lUIYsPjZjZILIP"
Date: Tue, 10 Jun 2008 21:00:44 +0200
Message-Id: <1213124444.3668.48.camel@johannes.berg> (sfid-20080610_210136_020164_55F5FC40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K1rXZ2lUIYsPjZjZILIP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Here's a completely untested (well, it compiles) patch against
> wireless-test. I'll try to do some testing tomorrow, but if someone is
> interested in taking a closer look at a version that is converted to use
> the new data structures for channel/rate configuration, here's a
> preliminary version. All comments are welcome.
>=20
> As far as functionality is concerned, this is supposed to match with the
> 2.6.25-based version I have in hostap.git, i.e., the only changes are to
> convert the newer version of mac80211 API. Since I'm frequently using
> the latest 2.6.x release kernel instead of wireless-test (and would
> assume I'm not the only one doing that), I'm thinking of maintaining two
> versions of the module. One would be in wireless-test and maintained
> just like any other in-tree driver. The other one is in my hostap.git
> repository and is maintained as an out-of-tree version that is based on
> the latest (or well, relatively close to the latest, i.e., whatever I
> happen to be using ;-) released kernel. Of course, once the in-tree
> version hits a released kernel, out-of-tree version can die.


Sounds good to me.

> PS.
>=20
> The URL in Kconfig is just a placeholder and I'll add the information in
> README and hostapd/wpa_supplicant example configuration files there
> before this gets submitted properly.

Should we add it to Documentation/networking/ instead? Don't care much,
but it might be easier to track version changes that way.

> +static const struct ieee80211_rate hwsim_rates[] =3D {
> +	{ .bitrate =3D 10 },
> +	{ .bitrate =3D 20, .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate =3D 55, .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate =3D 110, .flags =3D IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate =3D 60, .flags =3D IEEE80211_RATE_ERP_G },

You don't need to add the ERP flag manually, it'll be added based on the
rate automatically.

> +	if (is_multicast_ether_addr(hdr->addr1))
> +		ack =3D 1;

That seems a bit weird to me. mac80211 shouldn't request an ACK for
mcast, but why fake one?

> ... beacon ...
> +	if (vif->type !=3D IEEE80211_IF_TYPE_AP)
> +		return;

That could support mesh as well, in mesh-beacon-like-AP mode rather than
mesh-beacon-like-IBSS.

> +                   data->channel->band !=3D data2->channel->band ||
> +                   data->channel->center_freq !=3D data2->channel->cente=
r_freq)

The band check is useless since the frequency is in MHz, it's mostly to
know which band table to look up things in if necessary.

> +static void mac80211_hwsim_beacon(unsigned long arg)
> +{
> +	struct ieee80211_hw *hw =3D (struct ieee80211_hw *) arg;
> +	struct mac80211_hwsim_data *data =3D hw->priv;
> +
> +	if (!data->started || !data->radio_enabled)
> +		return;
> +
> +	ieee80211_iterate_active_interfaces(hw, mac80211_hwsim_beacon_tx, hw);

Cool, another user of this API :)

> +	data->rx_filter =3D 0;
> +	if (*total_flags & FIF_PROMISC_IN_BSS)
> +		data->rx_filter |=3D FIF_PROMISC_IN_BSS;
> +	if (*total_flags & FIF_ALLMULTI)
> +		data->rx_filter |=3D FIF_ALLMULTI;
> +
> +	*total_flags =3D data->rx_filter;

You don't actually seem to use these flags though. Should be added at
some point, I think.

> +		memcpy(data->channels, hwsim_channels, sizeof(hwsim_channels));
> +		memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
> +		data->band.channels =3D data->channels;
> +		data->band.n_channels =3D ARRAY_SIZE(hwsim_channels);
> +		data->band.bitrates =3D data->rates;
> +		data->band.n_bitrates =3D ARRAY_SIZE(hwsim_rates);

You shouldn't need to memcpy these, just point to the static
allocations.

> +		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =3D &data->band;

You can even allocate the band struct statically.

johannes

--=-K1rXZ2lUIYsPjZjZILIP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITs9YAAoJEKVg1VMiehFYsfMP/3FxbL3AieI9aBVrflg/dCa4
thBSlSYC/5HOFQHTKBfFTCEEbexjeno5BPL1fwrPiC+5XEvxwY3Mv6RHKEH5U+Hi
tPADuDWMtOEIl3/aOpYwvYbFVqoodJgqlhS6Q0VP9GeUZk8eAGXvdzxs2b7tgW+U
zVvQNYu27/oYG1JUrNOH+H5nFx/NivdpR5bQ+Yz8r5u/aP9vdKgY5pKYWVKdTh6o
ZVyFIpIHdPL6K3hpJt1PM0CDtxY8V8+rIA2Ka15TRQiozzVr76HACIpNA3/9A0Va
JcT3ql9tyFnvSxVL7jxBaTmN8wlHbt077DricONJXdY98QaY99BUPsQEGu6DTFSN
3VOUFVpGzWsEZWwoqUKXEKcW0vWWGugnYfW2zlXM9tBnPdYCQkziNkGC7zKz90m+
Dw5Q/WvGClO2Vo/9m1jyiG2hEx3OVgxMbYbu1s7mSn6jSticnkErYCUMzgbZg6d7
Td+KtH7Qigt9wQsUj8rogJFOMMJzabIW3t8QiZfFvE4yOJ6N50qM++6U9m4LNZ6V
zVGYMHLoCmeLNqCa0l9IaB8aLxosk0FmlyfGv/y/4Pff31pZCexEDQQ6jYAG7ohQ
PDYBheBpZZ6BdGEffbSEqfrN82UpIttvwKqKsVEjWk6A0WFFJbyuWBi/ual85zck
BWakKdyoi5iCYZpTIxLp
=gNAj
-----END PGP SIGNATURE-----

--=-K1rXZ2lUIYsPjZjZILIP--

