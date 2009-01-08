Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbZAHM66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 07:58:58 -0500
Subject: Re: [PATCH 3/6] cfg80211: allow multiple driver regulatory_hints()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231379017-28363-4-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+0AOgOQHGkMNMu2xoVfv"
Date: Thu, 08 Jan 2009 13:59:54 +0100
Message-Id: <1231419594.3685.4.camel@johannes> (sfid-20090108_135903_706412_64DF5E82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+0AOgOQHGkMNMu2xoVfv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 17:43 -0800, Luis R. Rodriguez wrote:
> We add support for multiple drivers to provide a regulatory_hint()
> on a system by adding a wiphy specific regulatory domain cache.
> This allows drivers to keep around cache their own regulatory domain
> structure queried from CRDA.
>=20
> We handle conflicts by intersecting multiple regulatory domains,
> each driver will stick to its own regulatory domain though unless
> a country IE has been received and processed.
>=20
> If the user already requested a regulatory domain and a driver
> requests the same regulatory domain then simply copy to the
> driver's regd the same regulatory domain and do not call
> CRDA, do not collect $200.

Could be an intersection already then? Not sure right now, but seems ok
to me either way, and if not we can fix it when we find a problem.

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/net/wireless.h |    6 +++
>  net/wireless/reg.c     |  109 ++++++++++++++++++++++++++++++++++++++++++=
------
>  2 files changed, 102 insertions(+), 13 deletions(-)
>=20
> diff --git a/include/net/wireless.h b/include/net/wireless.h
> index aedefa5..f57f12f 100644
> --- a/include/net/wireless.h
> +++ b/include/net/wireless.h
> @@ -187,6 +187,10 @@ struct ieee80211_supported_band {
>   * 	we will disregard the first regulatory hint (when the
>   * 	initiator is %REGDOM_SET_BY_CORE).
>   * @reg_notifier: the driver's regulatory notification callback
> + * @regd: the driver's regulatory domain, if one was requested via
> + * 	the regulatory_hint() API. This can be used by the driver
> + *	on the reg_notifier() if it chooses to ignore future
> + *	regulatory domain changes caused by other drivers.
>   */
>  struct wiphy {
>  	/* assign these fields before you register the wiphy */
> @@ -213,6 +217,8 @@ struct wiphy {
> =20
>  	/* fields below are read-only, assigned by cfg80211 */
> =20
> +	const struct ieee80211_regdomain *regd;
> +
>  	/* the item in /sys/class/ieee80211/ points to this,
>  	 * you need use set_wiphy_dev() (see below) */
>  	struct device dev;
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 87b3011..10a3b11 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -742,29 +742,42 @@ static u32 map_regdom_flags(u32 rd_flags)
> =20
>  /**
>   * freq_reg_info - get regulatory information for the given frequency
> + * @wiphy: the wiphy for which we want to process this rule for
>   * @center_freq: Frequency in KHz for which we want regulatory informati=
on for
>   * @bandwidth: the bandwidth requirement you have in KHz, if you do not =
have one
>   * 	you can set this to 0. If this frequency is allowed we then set
>   * 	this value to the maximum allowed bandwidth.
>   * @reg_rule: the regulatory rule which we have for this frequency
>   *
> - * Use this function to get the regulatory rule for a specific frequency=
.
> + * Use this function to get the regulatory rule for a specific frequency=
 on
> + * a given wireless device. If the device has a specific regulatory doma=
in
> + * it wants to follow we respect that unless a country IE has been recei=
ved
> + * and processed already.
>   */
> -static int freq_reg_info(u32 center_freq, u32 *bandwidth,
> +static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *band=
width,
>  			 const struct ieee80211_reg_rule **reg_rule)
>  {
>  	int i;
> +	const struct ieee80211_regdomain *regd;
>  	u32 max_bandwidth =3D 0;
> =20
> -	if (!cfg80211_regdomain)
> +	regd =3D cfg80211_regdomain;
> +
> +	/* Follow the driver's regulatory domain, if present, unless a country
> +	 * IE has been processed */
> +	if (last_request->initiator !=3D REGDOM_SET_BY_COUNTRY_IE &&
> +	    wiphy->regd)
> +		regd =3D wiphy->regd;
> +
> +	if (!regd)
>  		return -EINVAL;
> =20
> -	for (i =3D 0; i < cfg80211_regdomain->n_reg_rules; i++) {
> +	for (i =3D 0; i < regd->n_reg_rules; i++) {
>  		const struct ieee80211_reg_rule *rr;
>  		const struct ieee80211_freq_range *fr =3D NULL;
>  		const struct ieee80211_power_rule *pr =3D NULL;
> =20
> -		rr =3D &cfg80211_regdomain->reg_rules[i];
> +		rr =3D &regd->reg_rules[i];
>  		fr =3D &rr->freq_range;
>  		pr =3D &rr->power_rule;
>  		max_bandwidth =3D freq_max_bandwidth(fr, center_freq);
> @@ -795,7 +808,7 @@ static void handle_channel(struct wiphy *wiphy, enum =
ieee80211_band band,
> =20
>  	flags =3D chan->orig_flags;
> =20
> -	r =3D freq_reg_info(MHZ_TO_KHZ(chan->center_freq),
> +	r =3D freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq),
>  		&max_bandwidth, &reg_rule);
> =20
>  	if (r) {
> @@ -859,6 +872,30 @@ void wiphy_update_regulatory(struct wiphy *wiphy, en=
um reg_set_by setby)
>  		wiphy->reg_notifier(wiphy, setby);
>  }
> =20
> +static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
> +			 const struct ieee80211_regdomain *src_regd)
> +{
> +	struct ieee80211_regdomain *regd;
> +	int size_of_regd =3D 0;
> +	unsigned int i;
> +
> +	size_of_regd =3D sizeof(struct ieee80211_regdomain) +
> +	  ((src_regd->n_reg_rules + 1) * sizeof(struct ieee80211_reg_rule));
> +
> +	regd =3D kzalloc(size_of_regd, GFP_KERNEL);
> +	if (!regd)
> +		return -ENOMEM;
> +
> +	memcpy(regd, src_regd, sizeof(struct ieee80211_regdomain));
> +
> +	for (i =3D 0; i < src_regd->n_reg_rules; i++)
> +		memcpy(&regd->reg_rules[i], &src_regd->reg_rules[i],
> +			sizeof(struct ieee80211_reg_rule));
> +
> +	*dst_regd =3D regd;
> +	return 0;
> +}
> +
>  /* Return value which can be used by ignore_request() to indicate
>   * it has been determined we should intersect two regulatory domains */
>  #define REG_INTERSECT	1
> @@ -906,9 +943,9 @@ static int ignore_request(struct wiphy *wiphy, enum r=
eg_set_by set_by,
>  		}
>  		return REG_INTERSECT;
>  	case REGDOM_SET_BY_DRIVER:
> -		if (last_request->initiator =3D=3D REGDOM_SET_BY_DRIVER)
> -			return -EALREADY;
> -		return 0;
> +		if (last_request->initiator =3D=3D REGDOM_SET_BY_CORE)
> +			return 0;
> +		return REG_INTERSECT;
>  	case REGDOM_SET_BY_USER:
>  		if (last_request->initiator =3D=3D REGDOM_SET_BY_COUNTRY_IE)
>  			return REG_INTERSECT;
> @@ -935,11 +972,28 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg=
_set_by set_by,
> =20
>  	r =3D ignore_request(wiphy, set_by, alpha2);
> =20
> -	if (r =3D=3D REG_INTERSECT)
> +	if (r =3D=3D REG_INTERSECT) {
> +		if (set_by =3D=3D REGDOM_SET_BY_DRIVER) {
> +			r =3D reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
> +			if (r)
> +				return r;
> +		}
>  		intersect =3D true;
> -	else if (r)
> +	} else if (r) {
> +		/* If the regulatory domain being requested by the
> +		 * driver has already been set just copy it to the
> +		 * wiphy */
> +		if (r =3D=3D -EALREADY && set_by =3D=3D REGDOM_SET_BY_DRIVER) {
> +			r =3D reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
> +			if (r)
> +				return r;
> +			r =3D -EALREADY;
> +			goto new_request;
> +		}
>  		return r;
> +	}
> =20
> +new_request:
>  	request =3D kzalloc(sizeof(struct regulatory_request),
>  			  GFP_KERNEL);
>  	if (!request)
> @@ -955,6 +1009,11 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg=
_set_by set_by,
> =20
>  	kfree(last_request);
>  	last_request =3D request;
> +
> +	/* When r =3D=3D REG_INTERSECT we do need to call CRDA */
> +	if (r < 0)
> +		return r;
> +
>  	/*
>  	 * Note: When CONFIG_WIRELESS_OLD_REGULATORY is enabled
>  	 * AND if CRDA is NOT present nothing will happen, if someone
> @@ -1248,6 +1307,23 @@ static int __set_regdom(const struct ieee80211_reg=
domain *rd)
>  	}
> =20
>  	if (!last_request->intersect) {
> +		int r;
> +
> +		if (last_request->initiator !=3D REGDOM_SET_BY_DRIVER) {
> +			reset_regdomains();
> +			cfg80211_regdomain =3D rd;
> +			return 0;
> +		}
> +
> +		/* For a driver hint, lets copy the regulatory domain the
> +		 * driver wanted to the wiphy to deal with conflicts */
> +
> +		BUG_ON(last_request->wiphy->regd);
> +
> +		r =3D reg_copy_regd(&last_request->wiphy->regd, rd);
> +		if (r)
> +			return r;
> +
>  		reset_regdomains();
>  		cfg80211_regdomain =3D rd;
>  		return 0;
> @@ -1261,8 +1337,14 @@ static int __set_regdom(const struct ieee80211_reg=
domain *rd)
>  		if (!intersected_rd)
>  			return -EINVAL;
> =20
> -		/* We can trash what CRDA provided now */
> -		kfree(rd);
> +		/* We can trash what CRDA provided now.
> +		 * However if a driver requested this specific regulatory
> +		 * domain we keep it for its private use */
> +		if (last_request->initiator =3D=3D REGDOM_SET_BY_DRIVER)
> +			last_request->wiphy->regd =3D rd;
> +		else
> +			kfree(rd);
> +
>  		rd =3D NULL;
> =20
>  		reset_regdomains();
> @@ -1346,6 +1428,7 @@ int set_regdom(const struct ieee80211_regdomain *rd=
)
>  /* Caller must hold cfg80211_drv_mutex */
>  void reg_device_remove(struct wiphy *wiphy)
>  {
> +	kfree(wiphy->regd);
>  	if (!last_request || !last_request->wiphy)
>  		return;
>  	if (last_request->wiphy !=3D wiphy)

--=-+0AOgOQHGkMNMu2xoVfv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZfjHAAoJEKVg1VMiehFYsecQAIVhDEIbwRVmIArzyzlmoqNO
i24jAQ6NpgG5KuXwswpTbwNcdA00Jcrm1u8twHeYHismTtjNYOg/v9Ym5KXCdtP1
cRy+cUe49YaRQmk9tvlCEnIX1o+dF6WMRY0OFLuUMHoWN+QVFkpKXKxc7UVuZiDG
ocfmWCFBvHk8Dzip3ogzzwaokE3snhVVUT8Sqiv4Hmz00EvQyxoH6gt0CoC6olSW
8Sj/a8qWRe8mXu4h4eEMJLBVt1j+KGk7hXtmDQhxm1q7Yx2cw7vtNgMp28uWMW/M
l3+cTnIip6saEtFD2k2y6x9qCs8rsXx6DwrAKp/+9fktfqmbZjAXy+fjS7rjpKAP
xQGDDOugWvsbs7DgY19MV5c63bB3MS1nYcC6uf4Er/dEoYrtsG/vF6YkosyqQ2J7
EzefBTaAAw60PNQlVEc8aYPR/q/FHUGW1bmFTASHZnPKnP8B1ROWTkEg+Oa88ohQ
7wozaso/tToY2b3cx07c6uzv0TqLtCcJrZSgw9y30mqyir0WeuCzbGSWkH3CdQkC
xkprAMdZV2008uOtloDa7iSVEdgD6LY720lh9qLhgkEMhCS33WXbUQvbcbGVlXLd
qEdwoYjrJlV/KMP0Z6cU74Vahwvcq3g8X2S2qxOxTT6y5nn/lUdpWaeK4O8lKPd4
dWWofuB2Zkb2u990z1AF
=pXNw
-----END PGP SIGNATURE-----

--=-+0AOgOQHGkMNMu2xoVfv--

