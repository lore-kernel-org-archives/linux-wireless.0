Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50417 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbZKXROZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:14:25 -0500
Subject: Re: [PATCH v2 1/2] mac80211: supp_rates initialization and rate
 control notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1259082327.2573.18.camel@awozniak-laptop>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>
	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>
	 <4B0B2F67.3030605@irobot.com>  <1259082327.2573.18.camel@awozniak-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XgOmu8UNxh5qOOGYd/Lx"
Date: Tue, 24 Nov 2009 18:13:56 +0100
Message-ID: <1259082836.3491.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XgOmu8UNxh5qOOGYd/Lx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-24 at 09:05 -0800, Adam Wozniak wrote:
> Previously, not all code paths set supp_rates, and a rate change did not =
reinitialize the rate control layer.
> This patch fixes those issues.  (Hopefully not whitespace damaged this ti=
me)

All my other comments still stand.

johannes

> Signed-off-by: Adam Wozniak <awozniak@irobot.com>
> ---
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 10d1385..474f66d 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -246,9 +246,13 @@ static void ieee80211_rx_bss_info(struct
> ieee80211_sub_if_data *sdata,
>  	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
>  		return;
> =20
> +	supp_rates =3D ieee80211_sta_get_rates(local, elems, band);
> +
> +	/* make sure mandatory rates are always added */
> +	supp_rates |=3D ieee80211_mandatory_rates(local, band);
> +
>  	if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC && elems->supp_rates &&
>  	    memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) =3D=3D 0) {
> -		supp_rates =3D ieee80211_sta_get_rates(local, elems, band);
> =20
>  		rcu_read_lock();
> =20
> @@ -257,12 +261,10 @@ static void ieee80211_rx_bss_info(struct
> ieee80211_sub_if_data *sdata,
>  			u32 prev_rates;
> =20
>  			prev_rates =3D sta->sta.supp_rates[band];
> -			/* make sure mandatory rates are always added */
> -			sta->sta.supp_rates[band] =3D supp_rates |
> -				ieee80211_mandatory_rates(local, band);
> +			sta->sta.supp_rates[band] =3D supp_rates;
> =20
> +			if (sta->sta.supp_rates[band] !=3D prev_rates) {
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
> -			if (sta->sta.supp_rates[band] !=3D prev_rates)
>  				printk(KERN_DEBUG "%s: updated supp_rates set "
>  				    "for %pM based on beacon info (0x%llx | "
>  				    "0x%llx -> 0x%llx)\n",
> @@ -272,6 +274,8 @@ static void ieee80211_rx_bss_info(struct
> ieee80211_sub_if_data *sdata,
>  				    (unsigned long long) supp_rates,
>  				    (unsigned long long) sta->sta.supp_rates[band]);
>  #endif
> +				rate_control_rate_init(sta);
> +			}
>  		} else
>  			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
> =20
> @@ -415,6 +419,15 @@ struct sta_info *ieee80211_ibss_add_sta(struct
> ieee80211_sub_if_data *sdata,
>  	sta->sta.supp_rates[band] =3D supp_rates |
>  			ieee80211_mandatory_rates(local, band);
> =20
> +#ifdef CONFIG_MAC80211_IBSS_DEBUG
> +	printk(KERN_DEBUG "%s: initialized supp_rates set "
> +		"for %pM (0x%llx) (band %d)\n",
> +		sdata->dev->name,
> +		sta->sta.addr,
> +		(unsigned long long) sta->sta.supp_rates[band],
> +		band);
> +#endif
> +
>  	rate_control_rate_init(sta);
> =20
>  	if (sta_info_insert(sta))
>=20
>=20


--=-XgOmu8UNxh5qOOGYd/Lx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDBRRAAoJEODzc/N7+Qma1rAP/jQCWCKp6Q+ffAKwgyDjwQqX
TWy0mafdAvmEY3tG//8naLkihJFc5azpxn6I2gY7+xWzLXdgWXwU9Szg5UbdR1dl
t3VnaNudhK0VZwXm/x9RVrgWdcxlsABwt55oQIyoWwtdmvpi+Roc1RsmoGYZuqBX
K0ydEYFHuzJtvo49RRAps/YGtFEdgvSrDduyYptWUTU6WhPbxOzdjqiLBX6KEsJA
zlfxFqymGd55dSp+mO6QKB6DIb66VWwNi7Cvyl9D26NHOTfiwSHaKpf64h/0FTX/
R+4RsEKZD+PC0PivuE6cEs1J9sPFi+0M5frGEqD2lRpVn62kKXi2JuTOoZPIcwhl
NQta41rYttafQghfe+hS8PwqjADk38x1Kctn8J/fNxGcaBw1R7AJRziPSeeqSKW1
lsa4xZ8apxdAZwPXnSq6RzS+aVC2Yf+ltln/qHVkgZevUtR1MabkP6BP5Pi0W5kK
MvberN3xg23L/lKn46g57SLOPSBp+L1rJzj/zQ3f9P17fmoyQauITyuC7gcTAixC
rRqTPWDEU48s0NvhBCxw1jexUam3IX3z3/3wZGmLwXI1J1SNW4m+kRRSMWnbdHVh
ZMpLcqwnoZtOZHlbHk8GSUeJootfaS/hzKPZBqZda5X3dRAZtCK45miOo4Aees2a
vMKVlxdhZ9if+L0hAOoO
=2f+h
-----END PGP SIGNATURE-----

--=-XgOmu8UNxh5qOOGYd/Lx--

