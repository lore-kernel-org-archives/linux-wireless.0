Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbYFMOyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 10:54:15 -0400
Subject: Re: [PATCH] mac80211: eliminate IBSS warning in rate_lowest_index()
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <bruno@thinktube.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <48528944.2040907@work.ksp.sk>
References: <48528944.2040907@work.ksp.sk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qPRmeNXEuKfrUAbpP00m"
Date: Fri, 13 Jun 2008 16:54:06 +0200
Message-Id: <1213368846.3860.40.camel@johannes.berg> (sfid-20080613_165418_786431_368C3F2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qPRmeNXEuKfrUAbpP00m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-06-13 at 16:50 +0200, Vladimir Koutny wrote:
> In IBSS mode prior to join/creation of new IBSS it is possible that
> a frame from unknown station is received and an ibss_add_sta() is
> called. This will cause a warning in rate_lowest_index() since the
> list of supported rates of our station is not initialized yet.
>=20
> The fix is to add ibss stations with a rate we received that frame
> at; this single-element set will be extended later based on beacon
> data. Also there is no need to store stations from a foreign IBSS.

Looks sane to me, but I don't really test/understand the IBSS code.

>=20
> Signed-off-by: Vladimir Koutny <vlado@ksp.sk>
>=20
> ---
>=20
> diff -Naur compat-wireless-2008-06-12-base/net/mac80211/ieee80211_i.h com=
pat-wireless-2008-06-12/net/mac80211/ieee80211_i.h
> --- compat-wireless-2008-06-12-base/net/mac80211/ieee80211_i.h	2008-06-13=
 15:53:03.000000000 +0200
> +++ compat-wireless-2008-06-12/net/mac80211/ieee80211_i.h	2008-06-13 16:1=
7:11.000000000 +0200
> @@ -886,7 +886,7 @@
>  int ieee80211_sta_set_extra_ie(struct net_device *dev, char *ie, size_t =
len);
>  struct sta_info *ieee80211_ibss_add_sta(struct net_device *dev,
>  					struct sk_buff *skb, u8 *bssid,
> -					u8 *addr);
> +					u8 *addr, u64 supp_rates);
>  int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
>  int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
>  void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdat=
a,
> diff -Naur compat-wireless-2008-06-12-base/net/mac80211/mlme.c compat-wir=
eless-2008-06-12/net/mac80211/mlme.c
> --- compat-wireless-2008-06-12-base/net/mac80211/mlme.c	2008-06-13 15:52:=
54.000000000 +0200
> +++ compat-wireless-2008-06-12/net/mac80211/mlme.c	2008-06-13 16:18:24.00=
0000000 +0200
> @@ -2863,7 +2863,8 @@
>  				       dev->name, print_mac(mac, mgmt->bssid));
>  			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
>  			ieee80211_ibss_add_sta(dev, NULL,
> -					       mgmt->bssid, mgmt->sa);
> +					       mgmt->bssid, mgmt->sa,
> +					       BIT(rx_status->rate_idx));
>  		}
>  	}
>=20
> @@ -4307,12 +4308,13 @@
>=20
>  struct sta_info *ieee80211_ibss_add_sta(struct net_device *dev,
>  					struct sk_buff *skb, u8 *bssid,
> -					u8 *addr)
> +					u8 *addr, u64 supp_rates)
>  {
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
>  	struct sta_info *sta;
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	DECLARE_MAC_BUF(mac);
> +	int band =3D local->hw.conf.channel->band;
>=20
>  	/* TODO: Could consider removing the least recently used entry and
>  	 * allow new one to be added. */
> @@ -4324,6 +4326,9 @@
>  		return NULL;
>  	}
>=20
> +	if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid))
> +		return NULL;
> +
>  	printk(KERN_DEBUG "%s: Adding new IBSS station %s (dev=3D%s)\n",
>  	       wiphy_name(local->hw.wiphy), print_mac(mac, addr), dev->name);
>=20
> @@ -4333,8 +4338,10 @@
>=20
>  	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
>=20
> -	sta->supp_rates[local->hw.conf.channel->band] =3D
> -		sdata->u.sta.supp_rates_bits[local->hw.conf.channel->band];
> +	if (supp_rates)
> +		sta->supp_rates[band] =3D supp_rates;
> +	else
> +		sta->supp_rates[band] =3D sdata->u.sta.supp_rates_bits[band];
>=20
>  	rate_control_rate_init(sta, local);
>=20
> diff -Naur compat-wireless-2008-06-12-base/net/mac80211/rx.c compat-wirel=
ess-2008-06-12/net/mac80211/rx.c
> --- compat-wireless-2008-06-12-base/net/mac80211/rx.c	2008-06-13 15:50:11=
.000000000 +0200
> +++ compat-wireless-2008-06-12/net/mac80211/rx.c	2008-06-13 16:17:11.0000=
00000 +0200
> @@ -1846,8 +1846,13 @@
>  		if (!bssid)
>  			return 0;
>  		if ((rx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_MGMT &&
> -		    (rx->fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_BEACON)
> +		    (rx->fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_BEACON) {
> +			if (!rx->sta)
> +				rx->sta =3D ieee80211_ibss_add_sta(sdata->dev,
> +						rx->skb, bssid, hdr->addr2,
> +						BIT(rx->status->rate_idx));
>  			return 1;
> +		}
>  		else if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
>  			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
>  				return 0;
> @@ -1860,7 +1865,8 @@
>  			rx->flags &=3D ~IEEE80211_RX_RA_MATCH;
>  		} else if (!rx->sta)
>  			rx->sta =3D ieee80211_ibss_add_sta(sdata->dev, rx->skb,
> -							 bssid, hdr->addr2);
> +						bssid, hdr->addr2,
> +						BIT(rx->status->rate_idx));
>  		break;
>  	case IEEE80211_IF_TYPE_MESH_POINT:
>  		if (!multicast &&
>=20
>=20

--=-qPRmeNXEuKfrUAbpP00m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUooKAAoJEKVg1VMiehFYZiQP/3mDjJn8h51FQ86OAQn4mMNb
Ik18mwK40oySOfyw0TJSkKvIEtvpKAfCJPbLhbQHL0Ih2/5LPFVaAukzKiCvcuMq
KbYbsp4505/fSkpegzFXyMHCFR7Oxhr9VWDepTED7mS2Q/SsBq9TQKJnZuEp/DbP
lv/45Uz9OFn5BeLf2EdfZuu1qWaQBlyJbNRGPT4judtLSHzVe9FZdLF7+GsD2Ng4
w1CpvhEu4AP+gMTiELgPo+q4hUnRkX7CtwrF1lfLbOWkycOAFDra9f3+1DJvDZcX
3ZLrvz2YgxuyM2tPhvlg5xAOp5a2juIXkm4QVZpbxzS/APxMN9xUBmMnad4lrovR
tWIchJl27mbOsZTeQNAWfVihekpqxQrSTTBJp2ezOl6e1l1d82g6yzd0zCQCYksi
+btrzbHYQqLSJSw67DGKpI3UD+T1ZtmrgYXgCNGSpKbRWz9Blx5WdqfuzvdyedUW
gHAapkjPVQaLbYPf288DeG/v8Z5skPcproRWP0ndln/8KqHhK/ZYD36ScCX4wt4p
11iCp4d+DInd9T6kO8QffiaCchvv9koCZtCp/2X78kM3CwHwjELbtIEgMLmJEuSU
1Rcq8B4Hr6aA3QWaeOFktprh2w6B2fF4gDAJVSgW7jbDMZ3xm6wPc8ysT3WGvQK9
09RsL1LRCkgASjyQj0vQ
=5Fra
-----END PGP SIGNATURE-----

--=-qPRmeNXEuKfrUAbpP00m--

