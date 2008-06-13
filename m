Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbYFMLcd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 07:32:33 -0400
Subject: Re: [PATCH] mac80211_hwsim: 802.11 radio simulator for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080611074230.GA4919@jm.kir.nu>
References: <20080611074230.GA4919@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sbSzCrR3jeQw6PT5emjI"
Date: Fri, 13 Jun 2008 13:21:14 +0200
Message-Id: <1213356074.3860.26.camel@johannes.berg> (sfid-20080613_133239_450019_18A1CBD8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sbSzCrR3jeQw6PT5emjI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

A few more minor comments:

> +mac80211_hwsim is a Linux kernel module that can be used to simulate
> +arbitrary number of IEEE 802.11 radios for mac80211 on a single
> +device.

To me, that makes it sound as though you needed an underlying wireless
device. Maybe that "on a single device" should just be removed?

> +mac80211_hwsim kernel module has a parameter 'radios' that can be used
> +to select how many radios are simulates (default 2). This allows
                                         ^ typo, simulated

> +This example shows how to use mac80211_hwsim to simulate two radios:
> +one to act as an access point and the other as a station that
> +associates with the AP. hostapd and wpa_supplicant are used to take
> +care of WPA2-PSK authentication. In addition, hostapd is also
> +processing access point side of association.
> +
> +Please note that the current Linux kernel does not enable AP mode, so a
> +simple patch is needed to enable AP mode selection:
> +http://johannes.sipsolutions.net/patches/kernel/all/LATEST/006-allow-ap-=
vlan-modes.patch

Ok, once this code is in I'll add a hunk to my patch there that removes
this note.

> +	hdr->hdr.it_present =3D __constant_cpu_to_le32(
> +	     (1 << IEEE80211_RADIOTAP_FLAGS) |
> +	     (1 << IEEE80211_RADIOTAP_RATE) |
> +	     (1 << IEEE80211_RADIOTAP_CHANNEL));

> +	skb->protocol =3D __constant_htons(ETH_P_802_2);

No need to use the __constant_ prefix, the regular macros are smart
enough to optimise out in that case; the __constant versions are only
needed when the compiler expression has to be constant, e.g. for

switch (..) {
case __constant_cpu_to_le32(7): ...
}

> +		if (memcmp(hdr->addr1, hwsim_radios[i]->wiphy->perm_addr,
> +			   ETH_ALEN) =3D=3D 0)
> +			ack =3D 1;

Since you never set "ack" anywhere else, you could just say
	ack =3D memcmp(...) =3D=3D 0;

and remove the =3D0 assignment earlier. Not that it matters, though.

> +static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
> +				     struct ieee80211_vif *vif)
> +{
> +	struct ieee80211_hw *hw =3D arg;
> +	struct mac80211_hwsim_data *data =3D hw->priv;
> +	struct sk_buff *skb;
> +	struct ieee80211_rx_status rx_status;
> +	int i;
> +	struct ieee80211_tx_info *info;
> +
> +	if (vif->type !=3D IEEE80211_IF_TYPE_AP)
> +		return;
> +
> +	skb =3D ieee80211_beacon_get(hw, vif);
> +	if (skb =3D=3D NULL)
> +		return;
> +	info =3D IEEE80211_SKB_CB(skb);
> +
> +	mac80211_hwsim_monitor_rx(hw, skb);
> +
> +	memset(&rx_status, 0, sizeof(rx_status));
> +	/* TODO: set mactime */
> +	rx_status.freq =3D data->channel->center_freq;
> +	rx_status.band =3D data->channel->band;
> +	rx_status.rate_idx =3D info->tx_rate_idx;
> +	/* TODO: simulate signal strength (and optional packet drop) */
> +
> +	/* Copy skb to all enabled radios that are on the current frequency */
> +	for (i =3D 0; i < hwsim_radio_count; i++) {
> +		struct mac80211_hwsim_data *data2;
> +		struct sk_buff *nskb;
> +
> +		if (hwsim_radios[i] =3D=3D NULL || hwsim_radios[i] =3D=3D hw)
> +			continue;
> +		data2 =3D hwsim_radios[i]->priv;
> +		if (!data2->started || !data2->radio_enabled ||
> +		    data->channel->center_freq !=3D data2->channel->center_freq)
> +			continue;
> +
> +		nskb =3D skb_copy(skb, GFP_ATOMIC);
> +		if (nskb =3D=3D NULL)
> +			continue;
> +
> +		ieee80211_rx_irqsafe(hwsim_radios[i], nskb, &rx_status);

Maybe there should be a helper function for all this? It seems mostly
duplicated.

> +	ieee80211_iterate_active_interfaces(hw, mac80211_hwsim_beacon_tx, hw);

Hmm. You could use the _atomic version to avoid taking the RTNL, it uses
RCU instead.

None of this is really all that important, so

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-sbSzCrR3jeQw6PT5emjI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUlglAAoJEKVg1VMiehFYhRwQALZSzaSy5AZ/VZPNdR5O7PmH
AxdVD2UIHib1PbKDuAR0P2oDfRHQCEXsckKcPT2mrLBFwFcr6AL4DmxSNvGNKNDG
/k2aXZwloDRu8OOgBcF3TV5/25ZMcDFnSvC0Usyd/RfHEJIK8byyIUqoeUzaYjqh
g8DgHVsi7ddyjQFjfEjOuviLhA5D2YUkrz01im7QPd5jtpQYbmrRJzKxkIZs2Zer
rBFxggRxzj0U2EVkyxClPqGPJBQAT3mOOnjXokp9WO81V/cGCYnWGM4ZKxyQ0C6T
Zhq20ZWikMMJQ3ccW9hfMPCfUE0MlMJ4OcSD26WaYzrWh+L9jqxKxEdDr78sDvLC
BgW8l0J1NqjK7TK+XXh11AZLfpj9jKW3OSYbv/S3Rueq526l1WFkdRlbIse34PiO
83KkexeVv3RKk4A9cVvMb8NWEsfbq8MO2cdzSjZKepsO+I+etLA5PMgLP/vuT1sS
u5wE1Y5j7PJtu+RVagCoX1eXDqzsF3KVHR/NLUm/hbboI4yhwmlBViNVxGdHIEK8
Pm6bNpRcwFEcXd152pFpaavH0OxiaQjr4lnuyjKYjZbuE1oQzHmGa3Qqpb6n0CMu
W245yisSqQVxw2LaIlypYV5UYPOcwN02R6HGRjfnAZG0YOHAwtoCFTFvP2t8O7rJ
iedljKx+tLIjeErJwteD
=EkXg
-----END PGP SIGNATURE-----

--=-sbSzCrR3jeQw6PT5emjI--

