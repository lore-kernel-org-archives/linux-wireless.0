Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbZH1Hqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 03:46:32 -0400
Subject: Re: [PATCH 1/2] cfg80211: initialize rate control after station
 inserted
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ELyXjFVUN5XRHy2Vxwsb"
Date: Fri, 28 Aug 2009 09:45:57 +0200
Message-Id: <1251445557.4189.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ELyXjFVUN5XRHy2Vxwsb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks. I'll comment on both patches together. Can you please also tell
us what the problem is this is solving? I'm a bit lost.

I think both of these patches should just rolled into one since this is
also a mac80211 patch -- even if it's for the bit that interacts with
cfg80211.

However, I don't think I actually understand the changes.

>  	sta_apply_parameters(local, sta, params);
> =20
> -	rate_control_rate_init(sta);
> -
>  	layer2_update =3D sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN ||
>  		sdata->vif.type =3D=3D NL80211_IFTYPE_AP;
> =20
> @@ -742,13 +740,17 @@ static int ieee80211_add_station(struct wiphy *wiph=
y, struct net_device *dev,
>  		if (err =3D=3D -EEXIST && layer2_update) {
>  			/* Need to update layer 2 devices on reassociation */
>  			sta =3D sta_info_get(local, mac);
> -			if (sta)
> +			if (sta) {
> +				rate_control_rate_init(sta);
>  				ieee80211_send_layer2_update(sta);
> +			}
>  		}

Why is this necessary? It should already have been called for this
station earlier?

>  		rcu_read_unlock();
>  		return err;
>  	}
> =20
> +	rate_control_rate_init(sta);
> +

Also, I don't see anything between the old place that it was called and
the new place you're moving it to that could possibly change the station
parameters?

Same in ibss.c (not quoting it here) where you're only moving it to
after sta_info_insert() -- all that seems to do is add race conditions,
allowing other code to find not-yet-initialised stations.

So the only place I could see a change being necessary would be mlme.c,
but then only moving rate_control_rate_init() to after the flags
settings, not to after the insert.

Am I missing something?

johannes

--=-ELyXjFVUN5XRHy2Vxwsb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKl4sxAAoJEODzc/N7+QmazWkP/3dy5CpCTh0VjkNolX1aKfYi
lZwA5v0RK5JwN3owcVONnl33LYOF95LqOHi85d+KPtEmciV7tdtcu+drRlAND7ta
GZx/Wj94tfcvvGNifVpuBSxmWeZBljOwWGh13TV5O0MeBrIx2vX3KC0MvY67eSPT
LlkvrJx7cim2R1mtujii4l34jHbg7ETDuAqbElTbZeEp92yvPouTZU1yft1avL57
yuZbYpLLedbCf/3lA0K31OjPd3rEIraaVYm3kYQDq36OnXHXakcEp5gTWNfBSm/8
Fller4oyJubpKVRYg1rQZ1xtRUFlsfVta5Rp1AEADnWRi+mfMirl77fWSsrRHnvR
FPSWqWwQQN85wt1+CbKzFX40nWvs2pgu4qIqjMgTdsZbRczRUlbWiPMGkMOxBoow
NyT4i3NJ3bx/slQ5vvBchEUOvnzDPsjs4HTn26ltw6D913lyioV3ca+Vr7WmNoJe
5+w46Ms0maPLF59d/LA0dLLNKLHw4rUIaLd9A1A6tA+lMBSWLvl9vWn9D2zP5SRM
OC41TUVwJ5h/qKuQRJILQ+dn3yTao4Xy3jL6qVxqRnq95ekjSnLDzkA+zU87bjNU
k9D0fI8hMwNkEobcBeXr9YOBA20nfDjGKSJPf7HxszZQf7WE3JU53qeoQ8MmnvOC
HfYdttIbUaOl5uP9KtTD
=GoKM
-----END PGP SIGNATURE-----

--=-ELyXjFVUN5XRHy2Vxwsb--

