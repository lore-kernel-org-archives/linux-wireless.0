Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbZB0VHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:07:20 -0500
Subject: Re: [PATCH] mac80211: Notify the driver only when the beacon
	interval changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18855.27087.578785.199636@gargle.gargle.HOWL>
References: <18855.27087.578785.199636@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VT5GOqmq0v26QkVz78Ry"
Date: Fri, 27 Feb 2009 08:17:10 -0800
Message-Id: <1235751430.7426.0.camel@johannes.local> (sfid-20090227_220723_548035_769D93E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VT5GOqmq0v26QkVz78Ry
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-27 at 09:49 +0530, Sujith wrote:
> Currently, the driver is unconditionally notified of beacon
> interval. This is a problem in AP mode, because the driver has
> to know that the beacon interval has actualy changed to recalculate
> TBTT and reset the HW TSF. Fix this to make mac80211 notify the driver
> only when the beacon interval has been reconfigured to a new value.
>=20
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
> ( CC the list properly this time. )
>=20
>  net/mac80211/cfg.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index c43129e..58693e5 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -451,7 +451,8 @@ static int ieee80211_config_beacon(struct ieee80211_s=
ub_if_data *sdata,
>  	 * This is a kludge. beacon interval should really be part
>  	 * of the beacon information.
>  	 */
> -	if (params->interval) {
> +	if (params->interval && (sdata->local->hw.conf.beacon_int !=3D
> +				 params->interval)) {
>  		sdata->local->hw.conf.beacon_int =3D params->interval;
>  		err =3D ieee80211_hw_config(sdata->local,
>  					IEEE80211_CONF_CHANGE_BEACON_INTERVAL);

--=-VT5GOqmq0v26QkVz78Ry
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJqBIDAAoJEKVg1VMiehFYKJkP/RiAq6tLPOvMyMOSVqiFMP9r
mwz3MTjkZf5xdCG7N+dTNqeW8iKKWOgSI2thL+R47bfTCCpGnji+p+pnNzRUxOty
A+pa7ySvEpUU3HxN8sfKEUE2S8qwF/kGE272rpgExOfVCuUpoFcpbbcjNc/EObxP
LQjEHxnRLJ+A4wCBFbmrgSAI6K+DwwkAoVjCR14MsJzs4SqXRCOVfwbrC+B8NFph
xPTm/MMZFOhWrsElOssiTgYI4SiqN8VQy0KIw2ABBZijobWph8hHGDiDTFFgTAPV
lHLO45lbAz9rn1GYvly5jxMBjCKCegK5Om3lecEnF3bO4i6hz2h3aDFNz8FUC8M/
tAOB3N9E24CrpDABjd6cPFJM0ardP6p5d2xL8EBHkhHAWKk/H9jC4X8qBLIgllRc
wnwtjguT4PL1OKpAwHL5CzmlOEUFLOANfFoc8s25KF0qgr8/xz/i8Jq2Mgsomxgy
jARoQojCHNImbLjGbDwD8Y/H44Bc2Hbe1kJCSDTVKza0eYfy8PDzcIAdfQSMZfts
OMn6anQtv29YgVMW/cI0L6KcBoi41ZVYUkI/NBoDvsDaJtCXochP480INhPtv/KV
l4nQE3MEkZ5Zri6ZbB6idt/pefVAKC7En+LqEG6aSfRSxsEmF0s8T9+nhNI75xMf
6/YoSq+6RZGCPaSwOSL6
=u3ng
-----END PGP SIGNATURE-----

--=-VT5GOqmq0v26QkVz78Ry--

