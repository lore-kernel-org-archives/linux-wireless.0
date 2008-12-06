Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYLFOvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 09:51:35 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812061511.05473.hrogge@googlemail.com> (sfid-20081206_151109_960673_B582FE4D)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812050934.07182.rogge@fgan.de> <1228470310.3970.13.camel@johannes.berg>
	 <200812061511.05473.hrogge@googlemail.com>
	 (sfid-20081206_151109_960673_B582FE4D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OJJNru4sMqJTpXud1U1N"
Date: Sat, 06 Dec 2008 15:51:20 +0100
Message-Id: <1228575081.16752.8.camel@johannes.berg> (sfid-20081206_155142_029949_18E10365)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OJJNru4sMqJTpXud1U1N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-06 at 15:10 +0100, Henning Rogge wrote:
> Okay, here is v6 of my patch... feel free to rip it apart. ;)

Heh. Please inline patches, makes it much easier.

>  /**
> + * enum nl80211_sta_info_rate - station information about bitrate
> + *
> + * These attribute types are used with %NL80211_STA_INFO_TXRATE
> + * when getting information about the bitrate of a station.
> + *
> + * @__NL80211_STA_INFO_RATE_INVALID: attribute number 0 is reserved
> + * @NL80211_STA_INFO_RATE_TOTAL: total bitrate (u16, 100kbit/s)
> + * @NL80211_STA_INFO_RATE_MCS: mcs index for 802.11n (u8)
> + * @NL80211_STA_INFO_RATE_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
> + * @NL80211_STA_INFO_RATE_SHORT_GI: 400ns guard interval
> + */
> +enum nl80211_sta_info_rate {
> +       __NL80211_STA_INFO_RATE_INVALID,
> +       NL80211_STA_INFO_RATE_TOTAL,
> +       NL80211_STA_INFO_RATE_MCS,
> +       NL80211_STA_INFO_RATE_40_MHZ_WIDTH,
> +       NL80211_STA_INFO_RATE_SHORT_GI,
> +
> +       /* keep last */
> +       __NL80211_STA_INFO_RATE_AFTER_LAST,
> +       NL80211_STA_INFO_RATE_MAX =3D __NL80211_STA_INFO_RATE_AFTER_LAST =
- 1
> +};

I'd drop the _STA_ part from these and do RATE_INFO_... since we may end
up using these for other things potentially. Not sure we will, but who
knows. I could imagine using it to fix a transmit rate, for example, and
then it wouldn't necessarily be per station.

> + * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u=
8, dBm)

packet, or, more accurately, PPDU I guess

> + * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribu=
te
> + *  containing info as possible, see &enum nl80211_sta_info_txrate.

Please indent with a tab here

> + * @STATION_INFO_RX_BITRATE: @rx_bitrate filled
> + * @STATION_INFO_TX_BITRATE: @tx_bitrate fields are filled
> + *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
>   */
>  enum station_info_flags {
>         STATION_INFO_INACTIVE_TIME      =3D 1<<0,
> @@ -177,6 +181,25 @@ enum station_info_flags {
>         STATION_INFO_LLID               =3D 1<<3,
>         STATION_INFO_PLID               =3D 1<<4,
>         STATION_INFO_PLINK_STATE        =3D 1<<5,
> +       STATION_INFO_SIGNAL             =3D 1<<6,
> +       STATION_INFO_RX_BITRATE         =3D 1<<7,

RX bitrate?

> +/**
> + * enum station_info_rate_flags - station transmission rate flags
> + *
> + * Used by the driver to indicate the specific rate transmission
> + * type for 802.11n transmissions.
> + *
> + * @STATION_INFO_BITRATE_MCS: @tx_bitrate_mcs filled
> + * @STATION_INFO_BITRATE_40_MHZ_WIDTH: 40 Mhz width transmission
> + * @STATION_INFO_BITRATE_SHORT_GI: 400ns guard interval
> + */
> +enum station_info_rate_flags {
> +       STATION_INFO_BITRATE_MCS                =3D 1<<0,
> +       STATION_INFO_BITRATE_40_MHZ_WIDTH       =3D 1<<1,
> +       STATION_INFO_BITRATE_SHORT_GI           =3D 1<<2,
>  };

Same here as the first comment, this is rate specific, so I'd call these
BITRATE_* or something like that.
=20
>  /**
> @@ -191,6 +214,11 @@ enum station_info_flags {
>   * @llid: mesh local link id
>   * @plid: mesh peer link id
>   * @plink_state: mesh peer link state
> + * @signal: signal strength of last received package in dBm
> + * @txrate_total: current unicast bitrate to this station in 100 kbit/se=
c
> + * @txrate_flags: bitflag of flags from &enum station_info_bitrate_flags
> + * @txrate_mcs: MCS index of a 802.11n transmission, see
> + *  &enum station_info_bitrate_flags
>   */
>  struct station_info {
>         u32 filled;
> @@ -200,6 +228,10 @@ struct station_info {
>         u16 llid;
>         u16 plid;
>         u8 plink_state;
> +       u8 signal;
> +       u16 txrate_total;
> +       u8 txrate_flags;
> +       u8 txrate_mcs;

can you please move the rate parts into a new struct, so we can use
tx.flags, tx.mcs etc. and later just need to add a second instance of
the struct for rx
=20
> +static u16 sta_get_80211n_bitrate(struct ieee80211_tx_rate *rate)
> +{
> +       int modulation =3D rate->idx & 7;
> +       int streams =3D rate->idx >> 3;
> +
> +       int bitrate =3D (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ? 13=
500000 : 6500000;
> +
> +       if (modulation < 4)
> +               bitrate *=3D (modulation + 1);
> +       else if (modulation =3D=3D 4)
> +               bitrate *=3D (modulation + 2);
> +       else
> +               bitrate *=3D (modulation + 3);
> +
> +       bitrate *=3D streams;
> +
> +       if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
> +               bitrate =3D (bitrate * 10) / 9;
> +
> +       return (bitrate + 50000) / 100000; // do NOT just round down
> +}

Don't use // comments please, see Documentation/CodingStyle.

Also, if we really really need this information (I still don't see why
the kernel has to calculate it) then it should be in cfg80211 not
mac80211 so other drivers could potentially make use of it. Personally,
I'd just leave it out though.

>         sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
>                         STATION_INFO_RX_BYTES |
> -                       STATION_INFO_TX_BYTES;
> +                       STATION_INFO_TX_BYTES |
> +                       STATION_INFO_RX_BITRATE |
> +                       STATION_INFO_TX_BITRATE;

RX?

> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -727,8 +727,9 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *=
rx)
>         if (rx->sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
>                 u8 *bssid =3D ieee80211_get_bssid(hdr, rx->skb->len,
>                                                 NL80211_IFTYPE_ADHOC);
> -               if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =3D=
=3D 0)
> +               if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =3D=
=3D 0) {
>                         sta->last_rx =3D jiffies;
> +               }
>         } else
>         if (!is_multicast_ether_addr(hdr->addr1) ||
>             rx->sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {

That looks unintended

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 9caee60..197dc4d 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -16,6 +16,7 @@
>  #include <linux/netlink.h>
>  #include <net/genetlink.h>
>  #include <net/cfg80211.h>
> +#include <net/mac80211.h>

Ahem. Please observe the layering, cfg80211 and nl80211 are strictly
below mac80211.


I'd rename _TOTAL to _LEGACY and remove the calculation for MCS rates,
that way it's obviously clear what you're getting in userland.

johannes

--=-OJJNru4sMqJTpXud1U1N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOpFlAAoJEKVg1VMiehFYraUP/0JAb6EmEMGgP5LUYcVTRrlL
1fvDcFGxuif/qvUOq+PbcZuVn/GbfwJonwOgGZBBSweu1TQnyIpAfpnqH8N32DjL
HVvd9fh17lcmcfvKRvDGgC4oSP+u5+vuqEgai71kjtNhAY85OcPLj5cfDsOySNQv
Azxo/TK8QW5xIRHBbWzGts/BVF7164UqHgtV3Z7XrlaissphjvMCFucXsiCUosyJ
QOLtjVqEtoeSvgPhp8MQHr+SzO85e90iGb1zG7UgQVuUSO3VbkCgbc0Skr0tap1f
67/d8I5e3BXX8rFVw0+bykf8V5LnDF7RGqgS3+0gGUhLcWu1bI5SeTAud9+pY/ve
Z17lYz/xYkdgXJkxC7KjbGMwX0yrHvGl2L5jYC5N2mDKIHeTGEdm+NWyRZoZuxIS
bcUpvtjz4B0Mwy9fae19g0MePqWVilxND/3V3eP21NgZUn5vDdISlig/8lY8HLwo
KARtM+yAg+LDc8oqdErKmoDd371QRfBiMqM8L4j/vKYrCnlcfhzqMoZVlxkh3u1f
24cCpgXRO/k8TaqAs0Eh1lR0k28H6uuz1DNy8t4sEKAKp4h5qqf4cpAM2k54cdNq
S572O44aaHHDv04+xda2cRRkoJospwlUHgBpuwEecOi9lur64HH5XNLWhDdW1To/
6q+li9S1Hcsd+b6SU/vT
=U1WY
-----END PGP SIGNATURE-----

--=-OJJNru4sMqJTpXud1U1N--

