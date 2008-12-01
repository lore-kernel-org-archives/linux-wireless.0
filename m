Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23797 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYLARjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 12:39:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 09:39:49 -0800
Date: Mon, 1 Dec 2008 09:39:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Henning Rogge <rogge@fgan.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Henning Rogge <hrogge@googlemail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<nbd@openwrt.org>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Message-ID: <20081201173948.GD5992@tesla> (sfid-20081201_183953_775053_D7646FE4)
References: <200811252131.30161.hrogge@googlemail.com> <200811291150.16702.hrogge@googlemail.com> <1228130256.3478.5.camel@johannes.berg> <200812011422.30671.rogge@fgan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200812011422.30671.rogge@fgan.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 05:22:23AM -0800, Henning Rogge wrote:
> Am Monday 01 December 2008 12:17:36 schrieb Johannes Berg:
> > Even if you corrected the spelling to "bandwidth" you'd (a) be miss=
ing
> > documentation and (b) be using an entirely wrong term for what you'=
re
> > doing.
>=20
> Changes since v1:
> - removed noise and quality from station info in NL80211
> - added bandwith to station info in NL80211
> - changed name of patch file to nl80211ext_v2.patch
>=20
> Changes since v2:
> - added kernel comment lines for new fields/enums
> - changed name of "bandwith" field to tx_bitrate
>=20
> Henning Rogge
>=20
> *************************************************
> Diplom Informatiker Henning Rogge
> Forschungsgesellschaft f=FCr
> Angewandte Naturwissenschaften e. V. (FGAN)=20
> Neuenahrer Str. 20, 53343 Wachtberg, Germany
> Tel.: 0049 (0)228 9435-961
> Fax: 0049 (0)228 9435-685
> E-Mail: rogge@fgan.de
> Web: www.fgan.de
> ************************************************
> Sitz der Gesellschaft: Bonn
> Registergericht: Amtsgericht Bonn VR 2530
> Vorstand: Dr. rer. nat. Ralf Dornhaus (Vors.), Prof. Dr. Joachim Ende=
r=20
> (Stellv.)
>=20
> ---------------------------------------------------
>=20
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index e08c8bc..030feed 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -404,6 +404,8 @@ enum nl80211_sta_flags {
>   * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this=
 station)
>   * @__NL80211_STA_INFO_AFTER_LAST: internal
>   * @NL80211_STA_INFO_MAX: highest possible station info attribute
> + * @NL80211_STA_INFO_SIGNAL: signal strength of last received packag=
e (u8,=20
> dBm)
> + * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100 k=
bit/s)
>   */
>  enum nl80211_sta_info {
>  	__NL80211_STA_INFO_INVALID,
> @@ -413,6 +415,8 @@ enum nl80211_sta_info {
>  	NL80211_STA_INFO_LLID,
>  	NL80211_STA_INFO_PLID,
>  	NL80211_STA_INFO_PLINK_STATE,
> +	NL80211_STA_INFO_SIGNAL,
> +	NL80211_STA_INFO_TX_BITRATE,
> =20
>  	/* keep last */
>  	__NL80211_STA_INFO_AFTER_LAST,
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 1d57835..fd9964c 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -167,6 +167,8 @@ struct station_parameters {
>   * @STATION_INFO_LLID: @llid filled
>   * @STATION_INFO_PLID: @plid filled
>   * @STATION_INFO_PLINK_STATE: @plink_state filled
> + * @STATION_INFO_SIGNAL: @signal filled
> + * @STATION_INFO_TX_BITRATE: @tx_bitrate filled
>   */
>  enum station_info_flags {
>  	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
> @@ -175,6 +177,8 @@ enum station_info_flags {
>  	STATION_INFO_LLID		=3D 1<<3,
>  	STATION_INFO_PLID		=3D 1<<4,
>  	STATION_INFO_PLINK_STATE	=3D 1<<5,
> +	STATION_INFO_SIGNAL		=3D 1<<6,
> +	STATION_INFO_TX_BITRATE		=3D 1<<7,
>  };
> =20
>  /**
> @@ -189,6 +193,8 @@ enum station_info_flags {
>   * @llid: mesh local link id
>   * @plid: mesh peer link id
>   * @plink_state: mesh peer link state
> + * @signal: signal strength of last received package in dBm
> + * @tx_bitrate: current unicast tx rate in 100 kbit/sec
>   */
>  struct station_info {
>  	u32 filled;
> @@ -198,6 +204,8 @@ struct station_info {
>  	u16 llid;
>  	u16 plid;
>  	u8 plink_state;
> +	u8 signal;
> +	u16 tx_bitrate;
>  };
> =20
>  /**
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 16423f9..f6ed5b5 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -307,14 +307,24 @@ static int ieee80211_config_default_key(struct =
wiphy=20
> *wiphy,
>  static void sta_set_sinfo(struct sta_info *sta, struct station_info =
*sinfo)
>  {
>  	struct ieee80211_sub_if_data *sdata =3D sta->sdata;
> +  struct ieee80211_supported_band *sband;
> =20
>  	sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
>  			STATION_INFO_RX_BYTES |
> -			STATION_INFO_TX_BYTES;
> +			STATION_INFO_TX_BYTES |
> +			STATION_INFO_SIGNAL |
> +			STATION_INFO_TX_BITRATE;
> =20
>  	sinfo->inactive_time =3D jiffies_to_msecs(jiffies - sta->last_rx);
>  	sinfo->rx_bytes =3D sta->rx_bytes;
>  	sinfo->tx_bytes =3D sta->tx_bytes;
> +	sinfo->signal =3D sta->last_signal;
> +
> +	sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->=
band];
> +	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS))
> +	  sinfo->tx_bitrate =3D sband->bitrates[sta->last_tx_rate.idx].bitr=
ate;
> +	else
> +	  sinfo->tx_bitrate =3D 0;

It would be nice to get this figured out before adding it. We got rando=
m
complaints from users claiming 802.11n wasn't working before because
iwconfig didn't report a good rate. Users will trust it so I'd rather
see this go in with MCS rate figured out as part of the API to avoid
such reports. Would it be possible for you to work on that?

This might come in handy:

http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11=
n#MCSRates

What you need then is the guard interval, the MCS rate index and the
number of streams being used for communication.=20

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
