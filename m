Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZGaQVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 12:21:12 -0400
Subject: Re: [PATCH 001/002] [MAC80211] Retry probe request few times
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1249056896.20593.3.camel@maxim-laptop>
References: <1249056817.20593.1.camel@maxim-laptop>
	 <1249056896.20593.3.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PDGrdPjeWTAUmgnJ+VFA"
Date: Fri, 31 Jul 2009 18:21:03 +0200
Message-Id: <1249057263.25587.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PDGrdPjeWTAUmgnJ+VFA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 19:14 +0300, Maxim Levitsky wrote:
> >From 0bf5749f2878f9245b8fb1b64456386374205225 Mon Sep 17 00:00:00 2001
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Date: Fri, 31 Jul 2009 18:54:12 +0300
> Subject: [PATCH] [MAC80211] Retry probe request few times
>=20
> Retry 5 times  (chosen arbitary ), before assuming
> that station is out of range.
>=20
> Fixes frequent disassociations while connected to weak,
> and sometimes even strong access points.

Looks good, thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Maxim Levitky <maximlevitsky@gmail.com>
> ---
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/mlme.c        |   42 ++++++++++++++++++++++++++++++--------=
----
>  2 files changed, 31 insertions(+), 12 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index aec6853..bca7b60 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -280,6 +280,7 @@ struct ieee80211_if_managed {
>  	struct work_struct beacon_loss_work;
> =20
>  	unsigned long probe_timeout;
> +	int probe_send_count;
> =20
>  	struct mutex mtx;
>  	struct ieee80211_bss *associated;
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index ee83125..1d8640a 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -31,6 +31,7 @@
>  #define IEEE80211_AUTH_MAX_TRIES 3
>  #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
>  #define IEEE80211_ASSOC_MAX_TRIES 3
> +#define IEEE80211_MAX_PROBE_TRIES 5
> =20
>  /*
>   * beacon loss detection timeout
> @@ -1156,11 +1157,24 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub=
_if_data *sdata,
>  		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
>  }
> =20
> +static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sd=
ata)
> +{
> +	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
> +	const u8 *ssid;
> +
> +	ssid =3D ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
> +	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
> +				 ssid + 2, ssid[1], NULL, 0);
> +
> +	ifmgd->probe_send_count++;
> +	ifmgd->probe_timeout =3D jiffies + IEEE80211_PROBE_WAIT;
> +	run_again(ifmgd, ifmgd->probe_timeout);
> +}
> +
>  static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
>  				   bool beacon)
>  {
>  	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
> -	const u8 *ssid;
>  	bool already =3D false;
> =20
>  	if (!netif_running(sdata->dev))
> @@ -1203,18 +1217,12 @@ static void ieee80211_mgd_probe_ap(struct ieee802=
11_sub_if_data *sdata,
>  	if (already)
>  		goto out;
> =20
> -	ifmgd->probe_timeout =3D jiffies + IEEE80211_PROBE_WAIT;
> -
>  	mutex_lock(&sdata->local->iflist_mtx);
>  	ieee80211_recalc_ps(sdata->local, -1);
>  	mutex_unlock(&sdata->local->iflist_mtx);
> =20
> -	ssid =3D ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
> -	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
> -				 ssid + 2, ssid[1], NULL, 0);
> -
> -	run_again(ifmgd, ifmgd->probe_timeout);
> -
> +	ifmgd->probe_send_count =3D 0;
> +	ieee80211_mgd_probe_ap_send(sdata);
>   out:
>  	mutex_unlock(&ifmgd->mtx);
>  }
> @@ -2072,17 +2080,27 @@ static void ieee80211_sta_work(struct work_struct=
 *work)
>  	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
>  			    IEEE80211_STA_CONNECTION_POLL) &&
>  	    ifmgd->associated) {
> +		u8 bssid[ETH_ALEN];
> +
> +		memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
>  		if (time_is_after_jiffies(ifmgd->probe_timeout))
>  			run_again(ifmgd, ifmgd->probe_timeout);
> -		else {
> -			u8 bssid[ETH_ALEN];
> +
> +		else if (ifmgd->probe_send_count < IEEE80211_MAX_PROBE_TRIES) {
> +#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> +			printk(KERN_DEBUG "No probe response from AP %pM"
> +				" after %dms, try %d\n", bssid,
> +				(1000 * IEEE80211_PROBE_WAIT)/HZ,
> +				ifmgd->probe_send_count);
> +#endif
> +			ieee80211_mgd_probe_ap_send(sdata);
> +		} else {
>  			/*
>  			 * We actually lost the connection ... or did we?
>  			 * Let's make sure!
>  			 */
>  			ifmgd->flags &=3D ~(IEEE80211_STA_CONNECTION_POLL |
>  					  IEEE80211_STA_BEACON_POLL);
> -			memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
>  			printk(KERN_DEBUG "No probe response from AP %pM"
>  				" after %dms, disconnecting.\n",
>  				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);


--=-PDGrdPjeWTAUmgnJ+VFA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcxnrAAoJEODzc/N7+QmaRUgP/RLxZ/iF9L5a4sA3HmDrQl6K
/IEX0iaiWOZg4Lr6J+scRsqXbS8xoJF6vYG4AdQf8AWV6A+NXTtHevs5BNR4meUE
/uU8o+zqEeeC9Pwwk99b52sczvt+a8T2/DkT1XovHNXqRHHIAeWpMH8ngSc819qz
GxlWnLKeB6tB5jYKtpvgLotRXKK8B5UzT9/Fn6mf0RujYdU3C+LdNfHZ9PFfSjn4
uK7mfyZUtdmnICtDSUEFxIEDfFmVtAOeWWca1a4wK7a0gKKC9yIkEU4fPZjOnCVi
wfCkS97f/1Su7lPVSszukUuoX2755sQZ+/8FY7w7tJ8Bcbi7GADPDCvROmPNxbiZ
aFjHwkehkGDMN/Suwt4W5J3FjMPT3t0iSoK6gBsETGI0/hoKKzdQjLNOCeFtn7SX
yD9PJ5XXKNT0N1Wx+ngUR6lpyHCsWK0dTmcoD3j8MaLhdref4S0G0weAfvilR7X2
74PFtxzazAIUumBPRvdpQobV/oykiMmutHkzw+2b1tQxcoXb5R3s3d0lHCYaEhg3
j4fDFylnKBO4u9MRv9l0LDrmAMXWgfyoVy6wAOv628Vh4O+EbnkAoMC4yr+7GGPL
G5VqRImDBR3NUziXttSEWF8nwu3XP27oSr+g9XdvWqX4Hl4pqN1IzLkxjkZQ1pyh
l2s7eNlG0KLr1ArAqzeA
=wGLz
-----END PGP SIGNATURE-----

--=-PDGrdPjeWTAUmgnJ+VFA--

