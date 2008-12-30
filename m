Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYL3KjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 05:39:02 -0500
Subject: Re: mac80211 (ath9k, ath5k, etc.) set BSSID Patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: berlin@berlin.freifunk.net, linux-wireless@vger.kernel.org,
	openwrt-devel@lists.openwrt.org, Vladimir Koutny <vlado@ksp.sk>
In-Reply-To: <20081230025651.6500@gmx.net> (sfid-20081230_035657_768921_742B8565)
References: <20081230025651.6500@gmx.net>
	 (sfid-20081230_035657_768921_742B8565)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fkQcS7h3vSY3E7wwl93Z"
Date: Tue, 30 Dec 2008 11:39:25 +0100
Message-Id: <1230633565.3850.7.camel@johannes> (sfid-20081230_113908_745221_E83EC17E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fkQcS7h3vSY3E7wwl93Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Alina,

>  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
>                 if (beacon_timestamp > rx_timestamp) {
> +                       if (memcmp(sdata->u.sta.bssid, mgmt->bssid, ETH_A=
LEN) !=3D 0) {
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
> -                       printk(KERN_DEBUG "%s: beacon TSF higher than "
> -                              "local TSF - IBSS merge with BSSID %s\n",
> -                              sdata->dev->name, print_mac(mac, mgmt->bss=
id));
> +                               printk(KERN_DEBUG "%s: beacon TSF higher =
than "
> +                                      "local TSF - IBSS merge with BSSID=
 %s\n",
> +                                      sdata->dev->name, print_mac(mac, m=
gmt->bssid));
>  #endif
> -                       ieee80211_sta_join_ibss(sdata, &sdata->u.sta, bss=
);
> -                       ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->=
sa, supp_rates);
> +                               ieee80211_sta_join_ibss(sdata, &sdata->u.=
sta, bss);
> +                               ieee80211_ibss_add_sta(sdata, mgmt->bssid=
, mgmt->sa, supp_rates);
> +                       }
>                 }

Can you move the memcmp() into the other condition to avoid indenting
twice please? Also, it seems there needs to be a STA_BSSID_SET exclusion
somewhere above to avoid doing merges?

> @@ -2576,11 +2582,14 @@
>  {
>         struct ieee80211_if_sta *ifsta;
>         int res;
> +       int valid;

please use a bool for that
=20
>         ifsta =3D &sdata->u.sta;
> +       valid =3D is_valid_ether_addr(bssid);
> =20
>         if (memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0) {
> -               memcpy(ifsta->bssid, bssid, ETH_ALEN);
> +               if(valid) memcpy(ifsta->bssid, bssid, ETH_ALEN);
> +               else memset(ifsta->bssid, 0, ETH_ALEN);
>                 res =3D 0;

and indent these properly

I won't comment on the actual code right now, the IBSS code is pretty
much unknown to me and I don't use it.

johannes

--=-fkQcS7h3vSY3E7wwl93Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWfpaAAoJEKVg1VMiehFYmDUP/iN2ItsE4vPpUwTucpMfSB3Q
hK0qbsr20PKdfOVonBefT5Sodmt1JCJsBmonUGD+Iz22AN6rC10V+zvvlGFqxXzy
67xiSSoAevpINSIrH1iBDl89qw5ajeh6BR6GodMTPhjmz+bIDVL973oYnwT0hgkq
5fMLHlwoyGb5TewUnh8GbYGdaQdVw7eZ1LbLDEbQ8FLNO3vrWEkaOACnIkrRF1WU
VEoziJuE0sowJLTEWVTdrOfUh9pL50wBx3ntEsHNkZbjORibtZPFHGJhj1B4RoeZ
YELqpfIWbxpmHRAqDqZTJhueUXTps1Pztz5A9mfyqlZTNTcGP0hIUdhBsGXGm1hN
asHUl52niWGDfytsvcxslIayLy8octUVlivBG5i16ehyiiyZUrAWcBZJhO2QE/uZ
coHzHsBN9QC2/wul7+ZmdRxHOnvJsqhrf57TOhvgLN6j+esb3rFpTemxfjzi4lLJ
AfAt/VcOff2pbqNV01dlvIfXJ2GlmNOqtWy8cn1nhwsgaYSw5Y3v4Ml852QCoC7e
iVVBLMK2XXNmvvzZpiSJ+DDYlaRYUYCz/DgCD6kE3Hrjmq4RHKGOmk4NrFeN3qZB
zfDbgOhyygz3tedfWegOuD1i0KSEyQ6RK5bAS2sWD7Yhm9TEIcwKOPGNVywOhUv7
rGw50ws9nXKsFAr7jlai
=avUX
-----END PGP SIGNATURE-----

--=-fkQcS7h3vSY3E7wwl93Z--

