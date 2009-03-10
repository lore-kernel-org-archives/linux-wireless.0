Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZCJHNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 03:13:41 -0400
Subject: Re: Userspace (wpa_supplicant) not notified on interface down with
	2.6.29/wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200903091850.01604.herton@mandriva.com.br>
References: <200903091850.01604.herton@mandriva.com.br>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2Rm8FAHxFEWRVb1Xl7Hm"
Date: Tue, 10 Mar 2009 08:13:34 +0100
Message-Id: <1236669214.9658.28.camel@johannes.local> (sfid-20090310_081345_928159_30989034)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2Rm8FAHxFEWRVb1Xl7Hm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-09 at 18:50 -0300, Herton Ronaldo Krzesinski wrote:
> I have the problem when using 2.6.29 and judging by the code the situatio=
n
> stays the same with wireless-testing, even after the fix "mac80211: deaut=
h when
> interface is marked down" (the fix doesn't work with kernel 2.6.28 or lat=
er, as
> I'll explain).
>=20
> The problem is, with latest kernels wpa_supplicant isn't still notified w=
hen
> interface goes down, even after commit "mac80211: deauth when interface i=
s
> marked down" (e327b847 on Linus tree). There isn't a problem with this co=
mmit,
> but because of other code changes it doesn't work on latest kernels (but =
works
> if I apply same/similar change on 2.6.27 for example).
>=20
> The issue is as follows: after commit "mac80211: restructure disassoc/dea=
uth
> flows" in 2.6.28, the call to ieee80211_sta_deauthenticate added by commi=
t
> e327b847 will not work: because we do sta_info_flush(local, sdata); insid=
e
> ieee80211_stop (iface.c), all stations in interface are cleared, so when =
calling
>  ieee80211_sta_deauthenticate->ieee80211_set_disassoc (mlme.c), inside
> ieee80211_set_disassoc we have this in the beginning:
>=20
>         sta =3D sta_info_get(local, ifsta->bssid);
>         if (!sta) {
>=20
> the !sta check triggers, so the function returns early and
> ieee80211_sta_send_apinfo(sdata, ifsta); later isn't called, so wpa_suppl=
icant
> isn't notified with SIOCGIWAP

Interesting problem.

> One possible fix is moving sta_info_flush, to avoid !sta, and seems good,=
 like
> the following:
>=20
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 2acc416..0929581 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -370,25 +370,6 @@ static int ieee80211_stop(struct net_device *dev)
>  	rcu_read_unlock();
> =20
>  	/*
> -	 * Remove all stations associated with this interface.
> -	 *
> -	 * This must be done before calling ops->remove_interface()
> -	 * because otherwise we can later invoke ops->sta_notify()
> -	 * whenever the STAs are removed, and that invalidates driver
> -	 * assumptions about always getting a vif pointer that is valid
> -	 * (because if we remove a STA after ops->remove_interface()
> -	 * the driver will have removed the vif info already!)
> -	 *
> -	 * We could relax this and only unlink the stations from the
> -	 * hash table and list but keep them on a per-sdata list that
> -	 * will be inserted back again when the interface is brought
> -	 * up again, but I don't currently see a use case for that,
> -	 * except with WDS which gets a STA entry created when it is
> -	 * brought up.
> -	 */
> -	sta_info_flush(local, sdata);
> -
> -	/*
>  	 * Don't count this interface for promisc/allmulti while it
>  	 * is down. dev_mc_unsync() will invoke set_multicast_list
>  	 * on the master interface which will sync these down to the
> @@ -539,6 +520,26 @@ static int ieee80211_stop(struct net_device *dev)
>  		conf.mac_addr =3D dev->dev_addr;
>  		/* disable all keys for as long as this netdev is down */
>  		ieee80211_disable_keys(sdata);
> +
> +		/*
> +		 * Remove all stations associated with this interface.
> +		 *
> +		 * This must be done before calling ops->remove_interface()
> +		 * because otherwise we can later invoke ops->sta_notify()
> +		 * whenever the STAs are removed, and that invalidates driver
> +		 * assumptions about always getting a vif pointer that is valid
> +		 * (because if we remove a STA after ops->remove_interface()
> +		 * the driver will have removed the vif info already!)
> +		 *
> +		 * We could relax this and only unlink the stations from the
> +		 * hash table and list but keep them on a per-sdata list that
> +		 * will be inserted back again when the interface is brought
> +		 * up again, but I don't currently see a use case for that,
> +		 * except with WDS which gets a STA entry created when it is
> +		 * brought up.
> +		 */
> +		sta_info_flush(local, sdata);
> +
>  		local->ops->remove_interface(local_to_hw(local), &conf);
>  	}
> =20
> My question is, is the patch above safe? that is, do we need to always
> call sta_info_flush on interface down like currently, or just for the cas=
e we
> call remove_interface, like the comment states? if the latter, patch abov=
e
> is good, and solves the wpa_supplicant/userspace issue.

The comment states it must be before remove_interface, not that it
doesn't need to be called unless that is called, and this code moving is
incorrect for AP_VLAN devices.

You could move the disassoc part out of the switch to before this.

johannes

--=-2Rm8FAHxFEWRVb1Xl7Hm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJthMbAAoJEKVg1VMiehFYqJIP/R9DwOA2VZYM6i6QWqQnHICX
nLwUZgALJ25pqhnm9fky8lN1BGbfsDeMOeDZuSg7UiVlr+j2uoNrxQ1FEa5honvp
m+3GeeQ74aRUplHvCwCPXDihxlHL/O/By73aJSrf2HE4m24O6ZBLIATsnCfaExZi
RYYmn4+3IhzOeQWkm/BZN4Xj/lr6z9Ky89EQcSPuOBXeqde/oYgyAuavFyz5dGL+
R+4b5RgFiFWt4cPD5pLG/kHcma243AGSJmhghHfWK3Tztm3J3dx9Y8zXc+2gSlgA
QzdwrVrlfxImxOgbSbQPI7GFDQeBRKptoFZupRHqhoqpOSsP1br3VUGKwlXsUjjd
HBgax7/YKKoB13Kh+NwyW33m2jMV7plvnfAZVU2cAB8mxCprdmbVEeFB6wjD/QhM
NRTNOL+AS4DEB+cimUWtYbjECivmXOyySZLCJco4UaQXLGi9sLciU0jDzt7D0yPc
p4P/1JdLgVnbJJ+U1qeO2G9rOILYa4mufAhuk9AyDxdoLRu1zd8M2C6k15yxwsGp
A2uSpBL54byfewEmKAznTZ43UDWEU8aGY/vzJHgXsHzbODRsUyPJzwqZGUbzhIqX
3M3q0SaiUtXUwjpDVPxOg7pt0pYL/dep5C1287400xxzv+qcv/lG/wnqt602P8Ls
09h6dgK2pYjggfVUmsgA
=Kk7a
-----END PGP SIGNATURE-----

--=-2Rm8FAHxFEWRVb1Xl7Hm--

