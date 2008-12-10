Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbYLJVBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 16:01:40 -0500
Subject: Re: [PATCH 1/2] Add signal strength and bandwith to nl80211station
	info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812102158.56201.hrogge@googlemail.com> (sfid-20081210_215930_671276_D8205A8B)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812101840.32146.hrogge@googlemail.com>
	 <1228941937.15837.71.camel@johannes.berg>
	 <200812102158.56201.hrogge@googlemail.com>
	 (sfid-20081210_215930_671276_D8205A8B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J8hoxpjOcGEeH4CIj3nP"
Date: Wed, 10 Dec 2008 22:01:03 +0100
Message-Id: <1228942863.15837.73.camel@johannes.berg> (sfid-20081210_220158_131513_9792FBC1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J8hoxpjOcGEeH4CIj3nP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 21:58 +0100, Henning Rogge wrote:
> On Wednesday 10 December 2008 21:45:37 Johannes Berg wrote:
> > On Wed, 2008-12-10 at 18:40 +0100, Henning Rogge wrote:
> > Can you do what I asked for instead and not include the attribute when
> > it has a bogus value?
> I agree, that was a stupid thing...

Now merge it all into one patch, and I think we're good :)

> Henning
> -------------------------------
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 56450b4..cc93e7a 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -431,14 +431,14 @@ enum nl80211_sta_flags {
>   * when getting information about the bitrate of a station.
>   *
>   * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
> - * @NL80211_RATE_INFO_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)
> + * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
>   * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
>   * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
>   * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
>   */
>  enum nl80211_rate_info {
>  	__NL80211_RATE_INFO_INVALID,
> -	NL80211_RATE_INFO_LEGACY,
> +	NL80211_RATE_INFO_BITRATE,
>  	NL80211_RATE_INFO_MCS,
>  	NL80211_RATE_INFO_40_MHZ_WIDTH,
>  	NL80211_RATE_INFO_SHORT_GI,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 3f13928..4797b47 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1079,12 +1079,46 @@ static int parse_station_flags(struct nlattr *nla=
, u32=20
> *staflags)
>  	return 0;
>  }
> =20
> +static u16 nl80211_calculate_bitrate(struct rate_info *rate)
> +{
> +	int modulation, streams, bitrate;
> +
> +	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
> +		return rate->legacy;
> +
> +	/* the formula below does only work for MCS values smaller than 32 */
> +	if (rate->mcs >=3D 32)
> +		return 0;
> +
> +	modulation =3D rate->mcs & 7;
> +	streams =3D (rate->mcs >> 3) + 1;
> +
> +	bitrate =3D (rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) ?
> +			13500000 : 6500000;
> +
> +	if (modulation < 4)
> +		bitrate *=3D (modulation + 1);
> +	else if (modulation =3D=3D 4)
> +		bitrate *=3D (modulation + 2);
> +	else
> +		bitrate *=3D (modulation + 3);
> +
> +	bitrate *=3D streams;
> +
> +	if (rate->flags & RATE_INFO_FLAGS_SHORT_GI)
> +		bitrate =3D (bitrate / 9) * 10;
> +
> +	/* do NOT round down here */
> +	return (bitrate + 50000) / 100000;
> +}
> +
>  static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
>  				int flags, struct net_device *dev,
>  				u8 *mac_addr, struct station_info *sinfo)
>  {
>  	void *hdr;
>  	struct nlattr *sinfoattr, *txrate;
> +	u16 bitrate;
> =20
>  	hdr =3D nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
>  	if (!hdr)
> @@ -1122,11 +1156,12 @@ static int nl80211_send_station(struct sk_buff *m=
sg,=20
> u32 pid, u32 seq,
>  		if (!txrate)
>  			goto nla_put_failure;
> =20
> +		/* nl80211_calculate_bitrate will return 0 for mcs >=3D 32 */
> +		bitrate =3D nl80211_calculate_bitrate(&sinfo->txrate);
> +		if (bitrate > 0)
> +			NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE, bitrate);
> =20
> -		if (!(sinfo->txrate.flags & RATE_INFO_FLAGS_MCS))
> -			NLA_PUT_U16(msg, NL80211_RATE_INFO_LEGACY,
> -				    sinfo->txrate.legacy);
> -		else
> +		if (sinfo->txrate.flags & RATE_INFO_FLAGS_MCS)
>  			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
>  				    sinfo->txrate.mcs);
>  		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
>=20

--=-J8hoxpjOcGEeH4CIj3nP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQC4MAAoJEKVg1VMiehFYsvcQAKjZZfAHOdn0o9O4toyi1Lzr
PjDTq0JX9+XDKxSeuF6dqmTp+LujCCLY6PT8vqI/XwAEHtEa+WxF/sfs889ZUlg3
MgGLlKhHlQ136QDkp0FALuA/wSBbNykny29PS2XqaDHnn+feq0C3jGndcCSOVag1
V+ki+HsPeONl/WHbk5+2YEcWyD1U8wzor3fa0cRm05Xt3PgcQ8o8cPGf9K6uFojU
nbp4D5Ls41F1Wj2wTyC/oc7Cv/KJwBg3hjv4/yHNakmk6XP4zMlX9f0CDHiY/m/K
P7zyq0GihA0qxEe0shKP9ueWIz0YM+O4zkM6HWIJ1wGC/560wfOm5Y8Ut9lfQw/T
WsdWJSsJo1h9qTBH/no874s9USqOjYf+PQQKwCSRxmmHR59urA9x93IkqajBCOLM
oBYZbzRRr+hOr8FWVPQsPU0QxVK1SBGNjWn3jJOKV8BTGq/i9xyD2ODxgvTKFo+6
jDFuASTOKPbPq48N6EctNOGzZvJvYW+N0bH+R6KgiZKH2eyvywLMt/DrqN8Nkv0c
IyK/fa6IznBPqbsx7w7hzXLy60X0S2dZ+N+BhWraBcKSfAO1vsnp2uS6I+zKU3sD
gXsPv6rvMGwu6BnZ9JGI8salgdKidhN69Ul6f3En8Ys/ikN+ChG5EwdnjX1sU5QN
+RlxzjOdseU4DoHw1o7d
=71LT
-----END PGP SIGNATURE-----

--=-J8hoxpjOcGEeH4CIj3nP--

