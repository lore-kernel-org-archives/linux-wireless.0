Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761989AbYDKVLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 17:11:39 -0400
Subject: Re: [PATCH RFC v2] mac80211: no BSS changes to driver from beacons
	processed during scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1207785375-13470-1-git-send-email-reinette.chatre@intel.com>
References: <1207785375-13470-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VEMdcci4N7xxXw9q38/T"
Date: Fri, 11 Apr 2008 23:11:21 +0200
Message-Id: <1207948281.13354.98.camel@johannes.berg> (sfid-20080411_221200_493160_5ED18AAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VEMdcci4N7xxXw9q38/T
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-04-09 at 16:56 -0700, Reinette Chatre wrote:
> There is no need to send BSS changes to driver from beacons processed
> during scanning. We are more interested in beacons from an AP with which
> we are associated - these will still be used to send updates to driver as
> the beacons are received without scanning.
>=20
> This change=C2=B7removes the requirement that bss_info_changed needs to b=
e atomic.
> The beacons received during scanning are processed from a tasklet, but if=
 we
> do not call bss_info_changed for these beacons there is no need for it to=
 be
> atomic. This function (bss_info_changed) is called either from workqueue =
or
> ioctl in all other instances.

Seems reasonable. Makes me itch to rewrite the scan code completely (as
I had already planned once) so that the mlme isn't full of it, we don't
do everything twice (master and regular device) and the context (tasklet
vs. workqueue) is clearer. Oh well, not right now.

> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Acked-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> This patch applies to the latest code after mac80211 filename changes.

Didn't think it would be much of a problem otherwise I wouldn't have
asked for it, was it?

>  include/net/mac80211.h |    3 +--
>  net/mac80211/mlme.c    |   16 +++++++++++-----
>  2 files changed, 12 insertions(+), 7 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 079e7bd..4a80d74 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1020,8 +1020,7 @@ enum ieee80211_ampdu_mlme_action {
>   *	level driver (e.g. assoc/disassoc status, erp parameters).
>   *	This function should not be used if no BSS has been set, unless
>   *	for association indication. The @changed parameter indicates which
> - *	of the bss parameters has changed when a call is made. This callback
> - *	has to be atomic.
> + *	of the bss parameters has changed when a call is made.
>   *
>   * @configure_filter: Configure the device's RX filter.
>   *	See the section "Frame filtering" for more information.
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 83e8b49..e3f2cb0 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2797,6 +2797,17 @@ static void ieee80211_rx_mgmt_beacon(struct net_de=
vice *dev,
> =20
>  	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
> =20
> +	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
> +		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
> +					 elems.wmm_param_len);
> +	}
> +
> +	/* Do not send changes to driver if we are scanning. This removes
> +	 * requirement that driver's bss_info_changed function needs to be
> +	 * atomic. */
> +	if (local->sta_sw_scanning || local->sta_hw_scanning)
> +		return;
> +
>  	if (elems.erp_info && elems.erp_info_len >=3D 1)
>  		changed |=3D ieee80211_handle_erp_ie(sdata, elems.erp_info[0]);
>  	else {
> @@ -2816,11 +2827,6 @@ static void ieee80211_rx_mgmt_beacon(struct net_de=
vice *dev,
>  					       &bss_info);
>  	}
> =20
> -	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
> -		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
> -					 elems.wmm_param_len);
> -	}
> -
>  	ieee80211_bss_info_change_notify(sdata, changed);
>  }
> =20

--=-VEMdcci4N7xxXw9q38/T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR//T+KVg1VMiehFYAQIOWw/6A67z0N2Kb2vN9MUzmL8c7zjv6YY3nDmO
ZirqytNnt7BaXkQxG/XKtkybe7926HZyhpL1h7RGtkYFbIvvVfWHCLuoyZTgi0g+
DXrvzHyqq4FvBAn+VDe8hg1SoKRURmuxIgDOfYh9tCGMiG1LH9lWwp+Tb8hSbZNd
yNeGVeoITxztNi12VPVv63/D3SGX8JCsRPYttK7HIIfaAs/QSC0kjv00lDViZDaQ
pKY8SronrGXoT0wa1k2b86sJL6qSW+gm8GinGM/DOMeA7q8bpuoPanlCk1SFoP/z
wj4FAhZyzRizBGwTfuKBXCjRmwvtV4AcW+FtsUeyajcWeswFZ9LVJbMU7nsGsQTy
EtzfgMdsHLNxjtZsQz67cAlZVJh3pl+1ZhJRWrlCFipjCVKgv5YjlSMrTlfgOcWx
yEqUCL2gQ917HjDItbz4jgtmAvCapbu/5YtMel6lGYX3gRCp5hSQRTSQ08x8z77T
t4l8PvqA95BMAIg75eolpq50PsNIUXsEqusyDrFN81/cdL00a2KHSrCptuTd8uet
R+V4uFvT3dukvoa5YgdesNZFB6jpQvlAKpabToihC9YGH+GdVb+Jq0FRJkvNqRyq
z47lB0UqXAvAJeND1gl4CjgMJN4TtPEYpEeU1LDitTUQ6h+yXt1c2Ka/9oSPdiEW
DRXsv0GiOlw=
=MG9q
-----END PGP SIGNATURE-----

--=-VEMdcci4N7xxXw9q38/T--

