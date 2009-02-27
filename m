Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbZB0VH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:07:29 -0500
Subject: Re: [PATCH] mac80211: Replacement for: Implement commit in
	wireless extensions
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090227184314.42290@gmx.net> (sfid-20090227_194348_299848_A96EDA18)
References: <20090227184314.42290@gmx.net>
	 (sfid-20090227_194348_299848_A96EDA18)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L2v3o1OoXCvpgRbZMNJK"
Date: Fri, 27 Feb 2009 22:05:25 +0100
Message-Id: <1235768725.7426.83.camel@johannes.local> (sfid-20090227_220731_770835_E1A77374)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L2v3o1OoXCvpgRbZMNJK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-27 at 19:43 +0100, Alina Friedrichsen wrote:
> This patch _not_ implements commit in wireless extensions, but solves som=
e dependencies needed by the other patches.
>=20
> The maybe usage of this ioctl must discussed after the complete joining p=
rocess (STA and *IBSS*) in nl80211 defined.
>=20
> I hope this is a compromise.
>=20
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index ecbc8e0..7f00c70 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -920,6 +920,7 @@ static inline int ieee80211_bssid_match(const u8 *rad=
dr, const u8 *addr)
> =20
>  int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
>  int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 changed=
);
> +void ieee80211_commit(struct ieee80211_sub_if_data *sdata);
>  void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
>  void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdat=
a,
>  				      u32 changed);
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index f38db4d..1b2d598 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -294,6 +294,20 @@ int ieee80211_hw_config(struct ieee80211_local *loca=
l, u32 changed)
>  	return ret;
>  }
> =20
> +void ieee80211_commit(struct ieee80211_sub_if_data *sdata)
> +{
> +	switch (sdata->vif.type) {
> +	case NL80211_IFTYPE_ADHOC:
> +		ieee80211_ibss_commit(sdata);
> +		break;
> +	case NL80211_IFTYPE_STATION:
> +		ieee80211_sta_commit(sdata);
> +		break;
> +	default:
> +		break;
> +	}

I don't really see a need for that, it's only called in what, two
places? And it makes things interdependent. At _least_ put it into a
more appropriate file like wext.c and open-code it in cfg.c

johannes

--=-L2v3o1OoXCvpgRbZMNJK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJqFWSAAoJEKVg1VMiehFYkx8P/32i17TK/kD/bZ43I6ufX37e
zSh2WqVuD4EHdTrja7/WsZIGY1vz+2G1vd9fLm5tMcUi1dG2zDjMOG8ssUlU0upq
8ulCdAzeYqq6IioBnAz+i2oQBkzDlHxFZksq7B9FEAy6bFAl1HguUzcMLHRS/KsR
1WMJOwIuE4ASBkcWiWYYe6kF65Y2Nkd0hrggexmz/qsQcPR8RRBmLN8msu20yVC5
zmpogse6eg5pONC6mporf04+KHUbuXcw/OC1v9o2TGSa85LSqhF2XxBlejhc1Hd8
XNCqgbBqQBFPjT05i5j6U7FHVQKnH/LinrPjLYO8+f9dkAgFhD+CWMjxapoK0R+U
e9sYAIK0/lflAJWjJZRcQ+qywvdBXc/rxOrmwDslYYoZ/2RXE3dbjNQl9MUKtl/L
e/58eVg1R9ydmy5520Y5gBwc5Zj9Lf6CuskRcTKhZufIiHjdkgijsUYqfBNe1spE
N/MAIc1C+jrkgRSa/TUD0oB0zhsa/GtZUDUIrEaSaJVT+9FmJ4oGOo9QvcSHfHiA
s36SEwGAGBvml8mlKAR5v3kDwTDmMlZSxjvcB1siGO6TfwEQvKlIA09AEMyux2ka
K3Lk2dw5AMdF7x+9B1q9yi0AHmZ2AhxgjYyeI1iLaUEFht8T/DWfaQcSbZ5etnSx
rwaVHGI/pbpts5pp/sWy
=kCps
-----END PGP SIGNATURE-----

--=-L2v3o1OoXCvpgRbZMNJK--

