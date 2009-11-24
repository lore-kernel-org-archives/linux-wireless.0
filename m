Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZKXBRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 20:17:18 -0500
Subject: Re: [PATCH 1/2] mac80211: supp_rates initialization and rate
 control notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <4B0B2F67.3030605@irobot.com>
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
	 <4B0B2F67.3030605@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EHfY714nfSfnYydShCj3"
Date: Tue, 24 Nov 2009 02:16:51 +0100
Message-ID: <1259025411.7094.212.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EHfY714nfSfnYydShCj3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 16:57 -0800, Adam Wozniak wrote:
> Previously, not all code paths set supp_rates, and a rate change did not=20
> reinitialize the rate control layer.
> This patch fixes those issues.
>=20
> Signed-off-by: Adam Wozniak <awozniak@irobot.com>
> ---
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 10d1385..474f66d 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -246,9 +246,13 @@ static void ieee80211_rx_bss_info(struct=20
> ieee80211_sub_if_data *sdata,
>      if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
>          return;
> =20
> +    supp_rates =3D ieee80211_sta_get_rates(local, elems, band);
> +
> +    /* make sure mandatory rates are always added */
> +    supp_rates |=3D ieee80211_mandatory_rates(local, band);
> +
>      if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC && elems->supp_rates=
 &&
>          memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) =3D=3D 0) {
> -        supp_rates =3D ieee80211_sta_get_rates(local, elems, band);

This change is pointless -- if we don't get into this if() we don't care
about the value of supp_rates.
=20
> @@ -257,12 +261,10 @@ static void ieee80211_rx_bss_info(struct=20
> ieee80211_sub_if_data *sdata,
>              u32 prev_rates;
> =20
>              prev_rates =3D sta->sta.supp_rates[band];
> -            /* make sure mandatory rates are always added */
> -            sta->sta.supp_rates[band] =3D supp_rates |
> -                ieee80211_mandatory_rates(local, band);
> +            sta->sta.supp_rates[band] =3D supp_rates;

That's just as pointless, it doesn't matter whether you add the
mandatory rates here or earlier.

> +            if (sta->sta.supp_rates[band] !=3D prev_rates) {
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
> -            if (sta->sta.supp_rates[band] !=3D prev_rates)
>                  printk(KERN_DEBUG "%s: updated supp_rates set "
>                      "for %pM based on beacon info (0x%llx | "
>                      "0x%llx -> 0x%llx)\n",
> @@ -272,6 +274,8 @@ static void ieee80211_rx_bss_info(struct=20
> ieee80211_sub_if_data *sdata,
>                      (unsigned long long) supp_rates,
>                      (unsigned long long) sta->sta.supp_rates[band]);
>  #endif
> +                rate_control_rate_init(sta);
> +            }
>          } else
>              ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,=20
> supp_rates);

And that's not really right -- I don't think we should be calling
_init() over and over again. This could be a call to
rate_control_rate_update() with a certain flag instead.

johannes

--=-EHfY714nfSfnYydShCj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCzP/AAoJEODzc/N7+QmaTqMP/1a66ucSjLOE2ppElI4Ag6At
e3So9+F1GAzu8rtRi46pEDJuQ9slND25Ygb/+y3PFh6wFkIKTCNTyR4ZSZGuwDzO
sH08g/V+4WT5gRJnPdUoYtiYMwaPd7eVlAShiO0rjt9z3I86PyyIGaY+DD6yqhNR
/zuK3R89Q+c8s0Za5jzyl3ahKIsxljeRNlMldaLyhe8d0qo5ixflrSdW8a+DrPLe
8fPiPr2KCY+Es09+BFvmGUAaq2DHBoBGAz6nYYtd+uAu2CF8XvuuoNwFqpeQWwq9
UabPvpzUW/8hQBCDDPsmKzGQ0cKl7PtmPSnxsXsn7fOrDMZPst7cTHMN64Z68uHr
zXuPUhIo/Lh+8NIQW9BP94gakeeAS0iW75JqvsqfHTqsGO10PHpgUhrnmayBexc5
tXROh+GEYosBiFwpsmKrrTI2Ikw+akY82W+LEQTchlr2t4Ip9XBjx0upmAw43alz
OewmvHCsAr62euGrElf701E9cR/C4paVNGCA2NdbUBNKoK6KUmuBF00U5/iFSXSE
nL6tWkSDcuhecto6+OZ1mx0UqiCbts+ywP3pM7xLoxlby56qyKTW+ijuFd6xjm9C
wBqp7DETgU8nIyxQCeHUdnk86Kyl2YRdV3T7Fbj2jJ+XLklbvG4LW3uJZSgWsq6e
2AVVQuLUjpO9IlljuO9g
=vfr+
-----END PGP SIGNATURE-----

--=-EHfY714nfSfnYydShCj3--

