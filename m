Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbYLDU0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 15:26:35 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <rogge@fgan.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <hrogge@googlemail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812031131.34936.rogge@fgan.de>
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812022146.12363.hrogge@googlemail.com> <20081203014430.GH9351@tesla>
	 <200812031131.34936.rogge@fgan.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uQlaAIikE01dGi2U7DV9"
Date: Thu, 04 Dec 2008 21:26:27 +0100
Message-Id: <1228422387.5692.45.camel@johannes.berg> (sfid-20081204_212639_213539_2B1DBDC7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uQlaAIikE01dGi2U7DV9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-03 at 11:31 +0100, Henning Rogge wrote:

> Changes since v3:
> - added rx_bitrate to station info and sta_info
> - remember bitrate of last received unicast packet to this station

Please remove the RX bitrate for now, the drivers are not currently
reporting HT information appropriately.

> - decode 802.11n MCS index for nl80211
>   (maybe this should be ported to WEXT too ?)

I don't like all the tables in the kernel, please move those to
userspace. If we used more accurate values (these rates are fractional)
then we also don't need the values for the number of streams since those
are perfect multiples (1x, 2x, 3x, 4x for up to 4 streams).

> Changes since v4:
> - added tx_bitrate_flags adn tx_bitrate_mcs field to station info
> - added flags for 40Mhz and small guard interval to NL80211 station info
> - added mcs field to NL80211 station info
>=20
> The IEEE80211_TX_RC_40_MHZ_WIDTH flag in nl80211 should work for 802.11g=20
> "turbomodes"

I don't think we should ever go there. But that's just me maybe.

> + * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u=
8,=20
> dBm)
> + * @NL80211_STA_INFO_RX_BITRATE: bitrate of last received unicast packet
> + *  (u16, 100 kbit/s)
> + * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100 kbit/=
s)
> + * @NL80211_STA_INFO_TX_BITRATE_40_MHZ: dual channel transmission (flag)
> + * @NL80211_STA_INFO_TX_BITRATE_MCS: 802.11n MCS index of tx rate (u8)
> + * @NL80211_STA_INFO_TX_BITRATE_SHORT_GI: 802.11n with 400ns GI, 800ns
> + *  otherwise, should be ignored if TX_BITRATE_MCS is not set (flag)
>   */
>  enum nl80211_sta_info {
>  	__NL80211_STA_INFO_INVALID,
> @@ -413,6 +421,12 @@ enum nl80211_sta_info {
>  	NL80211_STA_INFO_LLID,
>  	NL80211_STA_INFO_PLID,
>  	NL80211_STA_INFO_PLINK_STATE,
> +	NL80211_STA_INFO_SIGNAL,
> +	NL80211_STA_INFO_RX_BITRATE,
> +	NL80211_STA_INFO_TX_BITRATE,
> +	NL80211_STA_INFO_TX_BITRATE_40_MHZ,
> +	NL80211_STA_INFO_TX_BITRATE_MCS,
> +	NL80211_STA_INFO_TX_BITRATE_SHORT_GI,

Just had another idea. Since we'll end up duplicating these for TX and
RX (ultimately we'll need RX_BITRATE_40_MHZ/MCS/SGI etc too) we should
actually do this differently:

 1) define NL80211_STA_INFO_RATE,
 2) define NL80211_RATE_INFO_BITRATE/40/MCS/SGI

and then nest the bitrate information into the STA_INFO_RATE, just like
station flags are nested etc. That way the RATE_INFO things could also
be used elsewhere.
=20
>   * Used by the driver to indicate which info in &struct station_info
>   * it has filled in during get_station() or dump_station().
> + * Signal strength is only available if driver supports dBm signal
> + * strength.

That comment is wrong here since cfg80211 drivers are expected to fill
this correctly. This comment is about _mac80211_ drivers and thus
inappropriate in cfg80211.h.

> + * @signal: signal strength of last received package in dBm

packet, or better yet PPDU

> + * @rx_bitrate: bitrate of last received unicast packet in 100 kbit/sec
> + * @tx_bitrate: current unicast bitrate to this station in 100 kbit/sec
> + * @tx_bitrate_flags: a binary field with a combination of flags
> + *  IEEE80211_TX_RC_MCS: bitrate_mcs field contains the 802.11n MCS numb=
er
> + *  IEEE80211_TX_RC_40_MHZ_WIDTH: 40 Mhz wide channel, 20 Mhz if not set
> + *  IEEE80211_TX_RC_SHORT_GI: 400ns guard interval, 800ns if not set

make those tx/rx independent too please, maybe even introduce a new
struct here so that it gets

station_info.tx_rate.flags and eventually .rx_rate.flags too

johannes

--=-uQlaAIikE01dGi2U7DV9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJODzvAAoJEKVg1VMiehFYoBkP/3lKWn+ynMHIWtzdL1Ge9K//
jO+FZdA9Hw9Yp1eq2yqnzHVhM6DEF21t5unVUWdeZLRmMHzfSMCE00ZK5OpKJ2AQ
/wNeHMB91+z4ab0QXCu12TWHFZPA9khpcKoLlNJ6L0Sj7Pweb7ZVi4tvaXfNriKJ
oI5yFOn4aHsCmTiqgxLci1qMITQcFVvP94GFLB9lMIaLu0s6l5IMw97OYtQr7lmN
N4AaDK41uJGJ+L+j1OqbbwifgDnWJdW8VvQ5Jscfariwg4Kd+w50+rSb1mgvSxzb
oV0L6+H9q08S7X4mn0v9dScXKXRMrrVM8WiQKCsV2JqaH3v9NYH0vSvRcFASJa/X
l2HFD7l79gZ+NTXdOHGD61Mzl4jF+Uejb7dphuTVit75/uCpZL5ei/FMNRDN41m9
vU9mYV2ui5hfI6yjuy4nuvXWkavGs/fmrkOJLGz3ep8TAuDOjGiAme08wsWiCZh6
K2khN6ZS86LZe77XBQVtwjeJ3rI+3HGvA7w14d9ddDCuhRvr1yD+aTYkO2FZYDxj
5JU30++BtHhag58ybEIwyXmDumMleSfxe3LIJxikdG8aCZsA052oLKaANpxTXpq4
ShBEHPdbVN67yefQ/RpXt26qFpz519YiED1XdKhFOX62Q2A8nQ3ajvUwx693ovnb
FVn+e1laAAqtaWIL/nR5
=MOEs
-----END PGP SIGNATURE-----

--=-uQlaAIikE01dGi2U7DV9--

