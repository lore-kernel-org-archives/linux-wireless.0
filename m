Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbYCTPgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 11:36:41 -0400
Subject: Re: [PATCH] mac80211: prevent tuning during scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <1206026069-6841-1-git-send-email-reinette.chatre@intel.com>
References: <1206026069-6841-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MsRyFToFleBEM0/fjoHt"
Date: Thu, 20 Mar 2008 16:36:23 +0100
Message-Id: <1206027383.16475.146.camel@johannes.berg> (sfid-20080320_153643_559547_0DD5B625)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MsRyFToFleBEM0/fjoHt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-03-20 at 08:14 -0700, Reinette Chatre wrote:
> From: Mohamed Abbas <mohamed.abbas@intel.com>
>=20
> Postpone calling ieee80211_hw_config if hardware scanning is active.
> This is similar to solution for software scanning where channel setting
> is delayed until scan complete.
>=20
> Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Fine with me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> Resend of patch "iwlwifi: prevent tuning during scanning" with
> corrected title.
>=20
>  net/mac80211/ieee80211_ioctl.c |    2 +-
>  net/mac80211/ieee80211_sta.c   |    3 +++
>  2 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioct=
l.c
> index 1d91575..83b79c9 100644
> --- a/net/mac80211/ieee80211_ioctl.c
> +++ b/net/mac80211/ieee80211_ioctl.c
> @@ -308,7 +308,7 @@ int ieee80211_set_freq(struct ieee80211_local *local,=
 int freqMHz)
>  	}
> =20
>  	if (set) {
> -		if (local->sta_sw_scanning)
> +		if (local->sta_sw_scanning || local->sta_hw_scanning)
>  			ret =3D 0;
>  		else
>  			ret =3D ieee80211_hw_config(local);
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 4255ec4..1e9650e 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -3609,6 +3609,9 @@ void ieee80211_scan_completed(struct ieee80211_hw *=
hw)
> =20
>  	if (local->sta_hw_scanning) {
>  		local->sta_hw_scanning =3D 0;
> +		if (ieee80211_hw_config(local))
> +			printk(KERN_DEBUG "%s: failed to restore operational "
> +			       "channel after scan\n", dev->name);
>  		/* Restart STA timer for HW scan case */
>  		rcu_read_lock();
>  		list_for_each_entry_rcu(sdata, &local->interfaces, list)

--=-MsRyFToFleBEM0/fjoHt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+KEdqVg1VMiehFYAQKAthAAtfiKUZ/+/VHWUMfI41JcFcY09kuZhdqX
Uxxk5aM3ibilg0vOW0EB2IuNbU6X1hd7d1hz/5F7VLfp4y+2b8L1fjs6VCaVsJ6l
txbi+Ss3Oqr86xd9ZIrvOoknirhRR/+63gg0aD6AhaJ4v2TDjg8Adf2db8IUDvSj
7FZ40S5NA0hFKqSiYosj94gn78/pv8AyOyFTUIfGArEK9s9NYdVHIe2zL3+DT3pm
IJSjL9QokWmSfKdUJXqmDNlcilhaIPHxEuUTbvSGmVRVVVV/tQ8J/kUCOJGgH160
IgL9QLdZYPdUQFRps00YBwCEMhAuhV9DljdiuwcFeVSWmONeFVlTDMkyZJ1ofJJN
7M+jT8GYaIPLlrIeF095zr5scofFHkTCIDltxziixVHKEHJb9tmWmK52LCZXy6sh
j+SGT9BmH+VO+iWehjkPajfS3psoiZUwjvh0dQTwumKhN2e7HJk0hjCHZq/PuojF
Tx5VYQMXJZVwVHfehcmiYUbyrZV/o9qtnoNQ7Fth7CcSkBQtkMGfXcbmvGILPza6
oq87WRlMtr/M1E+mJgB6Xoi8TBaj/v+Fks11hhvRlZJbPbplzuGvIcO+nsfVzuLE
Tp3BsRwbgU0GkqWNr7LbAcVGxjp5qHt124Z3Mf0cvU2oIxnqCsjjeSJiQuAq7tmo
pX57axpftoY=
=/eld
-----END PGP SIGNATURE-----

--=-MsRyFToFleBEM0/fjoHt--

