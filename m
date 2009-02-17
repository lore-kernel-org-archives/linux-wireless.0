Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZBQLdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 06:33:38 -0500
Subject: Re: [PATCH] nl80211: Provide access to STA TX/RX packet counters
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090217112457.GA22926@jm.kir.nu>
References: <20090217112457.GA22926@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-65vr3ztkHnTWD7MnSgIy"
Date: Tue, 17 Feb 2009 12:33:32 +0100
Message-Id: <1234870412.21343.4.camel@johannes.local> (sfid-20090217_123342_251031_C9CC1B35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-65vr3ztkHnTWD7MnSgIy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-17 at 13:24 +0200, Jouni Malinen wrote:
> The TX/RX packet counters are needed to fill in RADIUS Accounting
> attributes Acct-Output-Packets and Acct-Input-Packets. We already
> collect the needed information, but only the TX/RX bytes were
> previously exposed through nl80211. Allow applications to fetch the
> packet counters, too, to provide more complete support for accounting.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/linux/nl80211.h |    5 +++++
>  include/net/cfg80211.h  |    8 ++++++++
>  net/mac80211/cfg.c      |    4 ++++
>  net/wireless/nl80211.c  |    6 ++++++
>  4 files changed, 23 insertions(+)
>=20
> --- uml.orig/include/linux/nl80211.h	2009-02-17 13:09:52.000000000 +0200
> +++ uml/include/linux/nl80211.h	2009-02-17 13:11:11.000000000 +0200
> @@ -526,6 +526,9 @@ enum nl80211_rate_info {
>   * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, =
dBm)
>   * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribu=
te
>   * 	containing info as possible, see &enum nl80211_sta_info_txrate.
> + * @NL80211_STA_INFO_RX_PACKETS: total received packet (u32, from this s=
tation)
> + * @NL80211_STA_INFO_TX_PACKETS: total transmitted packets (u32, to this
> + *	station)
>   */
>  enum nl80211_sta_info {
>  	__NL80211_STA_INFO_INVALID,
> @@ -537,6 +540,8 @@ enum nl80211_sta_info {
>  	NL80211_STA_INFO_PLINK_STATE,
>  	NL80211_STA_INFO_SIGNAL,
>  	NL80211_STA_INFO_TX_BITRATE,
> +	NL80211_STA_INFO_RX_PACKETS,
> +	NL80211_STA_INFO_TX_PACKETS,
> =20
>  	/* keep last */
>  	__NL80211_STA_INFO_AFTER_LAST,
> --- uml.orig/include/net/cfg80211.h	2009-02-17 13:11:25.000000000 +0200
> +++ uml/include/net/cfg80211.h	2009-02-17 13:12:37.000000000 +0200
> @@ -178,6 +178,8 @@ struct station_parameters {
>   * @STATION_INFO_SIGNAL: @signal filled
>   * @STATION_INFO_TX_BITRATE: @tx_bitrate fields are filled
>   *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
> + * @STATION_INFO_RX_PACKETS: @rx_packets filled
> + * @STATION_INFO_TX_PACKETS: @tx_packets filled
>   */
>  enum station_info_flags {
>  	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
> @@ -188,6 +190,8 @@ enum station_info_flags {
>  	STATION_INFO_PLINK_STATE	=3D 1<<5,
>  	STATION_INFO_SIGNAL		=3D 1<<6,
>  	STATION_INFO_TX_BITRATE		=3D 1<<7,
> +	STATION_INFO_RX_PACKETS		=3D 1<<8,
> +	STATION_INFO_TX_PACKETS		=3D 1<<9,
>  };
> =20
>  /**
> @@ -235,6 +239,8 @@ struct rate_info {
>   * @plink_state: mesh peer link state
>   * @signal: signal strength of last received packet in dBm
>   * @txrate: current unicast bitrate to this station
> + * @rx_packets: packets received from this station
> + * @tx_packets: packets transmitted to this station
>   */
>  struct station_info {
>  	u32 filled;
> @@ -246,6 +252,8 @@ struct station_info {
>  	u8 plink_state;
>  	s8 signal;
>  	struct rate_info txrate;
> +	u32 rx_packets;
> +	u32 tx_packets;
>  };
> =20
>  /**
> --- uml.orig/net/mac80211/cfg.c	2009-02-17 13:13:59.000000000 +0200
> +++ uml/net/mac80211/cfg.c	2009-02-17 13:14:40.000000000 +0200
> @@ -341,11 +341,15 @@ static void sta_set_sinfo(struct sta_inf
>  	sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
>  			STATION_INFO_RX_BYTES |
>  			STATION_INFO_TX_BYTES |
> +			STATION_INFO_RX_PACKETS |
> +			STATION_INFO_TX_PACKETS |
>  			STATION_INFO_TX_BITRATE;
> =20
>  	sinfo->inactive_time =3D jiffies_to_msecs(jiffies - sta->last_rx);
>  	sinfo->rx_bytes =3D sta->rx_bytes;
>  	sinfo->tx_bytes =3D sta->tx_bytes;
> +	sinfo->rx_packets =3D sta->rx_packets;
> +	sinfo->tx_packets =3D sta->tx_packets;
> =20
>  	if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
>  		sinfo->filled |=3D STATION_INFO_SIGNAL;
> --- uml.orig/net/wireless/nl80211.c	2009-02-17 13:12:55.000000000 +0200
> +++ uml/net/wireless/nl80211.c	2009-02-17 13:13:54.000000000 +0200
> @@ -1206,6 +1206,12 @@ static int nl80211_send_station(struct s
> =20
>  		nla_nest_end(msg, txrate);
>  	}
> +	if (sinfo->filled & STATION_INFO_RX_PACKETS)
> +		NLA_PUT_U32(msg, NL80211_STA_INFO_RX_PACKETS,
> +			    sinfo->rx_packets);
> +	if (sinfo->filled & STATION_INFO_TX_PACKETS)
> +		NLA_PUT_U32(msg, NL80211_STA_INFO_TX_PACKETS,
> +			    sinfo->tx_packets);
>  	nla_nest_end(msg, sinfoattr);
> =20
>  	return genlmsg_end(msg, hdr);
>=20

--=-65vr3ztkHnTWD7MnSgIy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmqCJAAoJEKVg1VMiehFYUREP/1EGMmp4u4D/rXSJ7jyDDIl3
WXqsNleTrhCa5mJ8yiPtBTM/c4A1QCLM/WjTJZn6Qxqq/BXdyOg4toKQjrgSpNFJ
hQw5lA8c8qkd0gL2nN3KQiLyOiToeDmyedmZl5r2R4MLbS1nhNIjsDQg7otlylfG
J83BzG2VOyUBSFzrthnvPpewNKBMMPMEYnZURVd3RHT7VK/ftnTv3qkPT6rijrVk
axou9jLhZUZvo/P8zT2B2ou9Z5+0PpA3RVe8+E1660AW6EsYd9EJlDpK4dvfDQ2d
7xV+AogCUlWWwugpQMU2QVLjTJE0JQug9oCN2G2fb74i70l97rXr9vrGmWa0dS3k
/IDPTi9Ypa3DguDug6vFhFspbI7G5VCbzrtHa5soIFQS3e1d+WP/WrIT8d4NRcvR
qU1sKMbXvHLu6pNdZYHKYfTs20dZDTQ/eoWfEfDFoNeb006O4UVIwGJR3Kw2aluq
8HITi083hBb40JTZ2Vu9UmiK1cvKr5yziUEso3rB/fdiwzBy8DMtU0EjYDCRNZ5Y
lqJgSqH4qeFLci329Xb9xTAnhkMcx35ZyAqOhWbyjbhHfScJOlnXMLJBaITQ2jRJ
MrXV7b3f1xI2WrBw2JKsn9Rr2TViWqv3q6ayXeqSCxqetytCoiWS9+MWsutUWc2a
vOc+pKn2AcqU+EpP3TZ3
=Vu0O
-----END PGP SIGNATURE-----

--=-65vr3ztkHnTWD7MnSgIy--

