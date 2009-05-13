Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbZEMJ64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 05:58:56 -0400
Subject: Re: [RFC v2 3/5] cfg80211: add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1242206461-30793-4-git-send-email-lrodriguez@atheros.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	 <1242206461-30793-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2uFOTe5+f3gub7ojMKxm"
Date: Wed, 13 May 2009 11:58:25 +0200
Message-Id: <1242208705.29288.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2uFOTe5+f3gub7ojMKxm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 05:20 -0400, Luis R. Rodriguez wrote:

>  /**
> + * struct cfg80211_wow - Wake on Wireless-LAN support info
> + *
> + * This structure defines the WoW triggers supported by the device
> + * and also what specific WoW triggers the user wants enabled. To use
> + * WoW you can use standard ethernet utilities as you would with
> + * Wake-on-LAN.
> + *
> + * @triggers_supported: supported bitmask of WoW triggers.
> + *	The flags for this bitmask are %NL80211_WOW_TRIGGER_*.
> + * @triggers_enabled: enabled triggers by the user. Default
> + *	is to disable all triggers. The flags for this bitmask
> + *	are %NL80211_WOW_TRIGGER_*.
> + */
> +struct cfg80211_wow {
> +	u32 triggers_supported;
> +	u32 triggers_enabled;
> +};
> +
> +/**
>   * struct cfg80211_ops - backend description for wireless configuration
>   *
>   * This struct is registered by fullmac card drivers and/or wireless sta=
cks
> @@ -849,6 +868,8 @@ enum wiphy_params_flags {
>   *	@changed bitfield (see &enum wiphy_params_flags) describes which valu=
es
>   *	have changed. The actual parameter values are available in
>   *	struct wiphy. If returning an error, no value should be changed.
> + *
> + * @set_wow: used to inform the device which WoW triggers should be enab=
led.
>   */
>  struct cfg80211_ops {
>  	int	(*suspend)(struct wiphy *wiphy);
> @@ -940,6 +961,7 @@ struct cfg80211_ops {
>  	int	(*leave_ibss)(struct wiphy *wiphy, struct net_device *dev);
> =20
>  	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
> +	int	(*set_wow)(struct wiphy *wiphy, u32 triggers);
>  };
> =20
>  /*
> @@ -965,6 +987,11 @@ struct cfg80211_ops {
>   * 	channels at a later time. This can be used for devices which do not
>   * 	have calibration information gauranteed for frequencies or settings
>   * 	outside of its regulatory domain.
> + * @wow: Wake-on-Wireless-LAN configuration struct. The driver should
> + *	set the capabilities before registering the wiphy. When we
> + *	get a request to enable certain WoW events we will inform
> + *	the driver through the set_wow() callback. If this is successfull
> + *	we then set the passed triggers as enabled on the wiphy'w wow struct.

I'm not sure that makes sense. Why keep track of both the enabled and
the possible triggers, _and_ have a set_wow callback? The latter might
make sense to verify some of the information, but I think we shouldn't
keep track of the enabled triggers here but rather do that in the driver
then.

Alternatively, how about we push the stuff I suggested for mac80211 all
the way through to cfg80211? The cfg80211 suspend() method could pass
through the wow parameters.

johannes

--=-2uFOTe5+f3gub7ojMKxm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCpm4AAoJEODzc/N7+QmaLs4P/0pRS3YXYX4flR6YULI9vwnB
KINazy2F4NHU+aEohJGKkZYo/YzRNWAgkIBV54Hi3bbBY17U5nCF+mfWloMeonoM
iPDridC7gphbwUzw3GTnqdJ1MYFGHx3dc64epm3mIlQsIaeUCboWuuyXJzRaKJAf
pFOeXCpUa2dLnkgtJkw2vJEf2SXLAw764SpUhpEUO6mlyHXdrpL3x3NSzVWvQIpL
iOX2mvSgf5R7CbyDPsI9KbCuZxaPZTjV/gk+YHR9pr14ZNS6jLYCkhlg4ZY5V09q
giHFKFMZEf+w0VUvomAHjrtPx+k0LShXp1ZPAdG2N9X0/HWzxHjP0BDGvVr6jX+G
k5UzLQVhC5Q7NNW0dQZmxWo6E/nRAfJT1NxBlDH3Y1Xy8KLtknI0oTQFqHsq7w9B
LposCgkxsem0HYkzr6TQygt5G3vEYijSbxgZzY9uq1RSh51Uq3Ov3Mkx5Uch9BzT
GZ4OlseAwtchIyZ58Qr6xr1LnOcEKjHTI5oMgOTVBPvVivKkLGsm9o02SsVA8Q26
LTPFwPCAsnXaOiXdJZQgC6HcKXlXCmo6GZgM4vlJ6C2LqqKKQImNm+0bTGIGuvrw
FacAi3LMiaZFpOCLamzelIC/lCI+oGoUSpnU1d9E/Rfhi/pyJtkJCBXVc3V2Y5XB
bOUxuQ8xDViJv4S3XU1y
=qEA/
-----END PGP SIGNATURE-----

--=-2uFOTe5+f3gub7ojMKxm--

