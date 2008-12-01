Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYLAL76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:59:58 -0500
Subject: Re: [PATCH ] mac80211: tx module cleanup.
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0812010356g1b11c68fkbbfce711313894d8@mail.gmail.com> (sfid-20081201_125657_074747_083C8F76)
References: <eb3ff54b0812010356g1b11c68fkbbfce711313894d8@mail.gmail.com>
	 (sfid-20081201_125657_074747_083C8F76)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gWgIemfChfvkqyDj5u1R"
Date: Mon, 01 Dec 2008 12:59:52 +0100
Message-Id: <1228132792.3478.23.camel@johannes.berg> (sfid-20081201_130002_121349_39625843)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gWgIemfChfvkqyDj5u1R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-01 at 13:56 +0200, Rami Rosen wrote:
> This patch removes unnecessary parameter in ieee80211_beacon_add_tim() an=
d
> removes unneeded definition and assignment for bdev (instance of net_devi=
ce) in
> ieee80211_beacon_get() and in ieee80211_get_buffered_bc()
> (all in tx.c).
>=20
> (this patch was prepared in wireless-testing tree).
>=20
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Looks fine to me

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
>=20
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 0855cac..3f55138 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1783,8 +1783,7 @@ void ieee80211_tx_pending(unsigned long data)
>=20
>  /* functions for drivers to get certain frames */
>=20
> -static void ieee80211_beacon_add_tim(struct ieee80211_local *local,
> -				     struct ieee80211_if_ap *bss,
> +static void ieee80211_beacon_add_tim(struct ieee80211_if_ap *bss,
>  				     struct sk_buff *skb,
>  				     struct beacon_data *beacon)
>  {
> @@ -1852,7 +1851,6 @@ struct sk_buff *ieee80211_beacon_get(struct
> ieee80211_hw *hw,
>  	struct ieee80211_local *local =3D hw_to_local(hw);
>  	struct sk_buff *skb =3D NULL;
>  	struct ieee80211_tx_info *info;
> -	struct net_device *bdev;
>  	struct ieee80211_sub_if_data *sdata =3D NULL;
>  	struct ieee80211_if_ap *ap =3D NULL;
>  	struct ieee80211_if_sta *ifsta =3D NULL;
> @@ -1865,7 +1863,6 @@ struct sk_buff *ieee80211_beacon_get(struct
> ieee80211_hw *hw,
>  	rcu_read_lock();
>=20
>  	sdata =3D vif_to_sdata(vif);
> -	bdev =3D sdata->dev;
>=20
>  	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP) {
>  		ap =3D &sdata->u.ap;
> @@ -1893,12 +1890,12 @@ struct sk_buff *ieee80211_beacon_get(struct
> ieee80211_hw *hw,
>  			 * of the tim bitmap in mac80211 and the driver.
>  			 */
>  			if (local->tim_in_locked_section) {
> -				ieee80211_beacon_add_tim(local, ap, skb, beacon);
> +				ieee80211_beacon_add_tim(ap, skb, beacon);
>  			} else {
>  				unsigned long flags;
>=20
>  				spin_lock_irqsave(&local->sta_lock, flags);
> -				ieee80211_beacon_add_tim(local, ap, skb, beacon);
> +				ieee80211_beacon_add_tim(ap, skb, beacon);
>  				spin_unlock_irqrestore(&local->sta_lock, flags);
>  			}
>=20
> @@ -2020,14 +2017,12 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw=
,
>  	struct sk_buff *skb =3D NULL;
>  	struct sta_info *sta;
>  	struct ieee80211_tx_data tx;
> -	struct net_device *bdev;
>  	struct ieee80211_sub_if_data *sdata;
>  	struct ieee80211_if_ap *bss =3D NULL;
>  	struct beacon_data *beacon;
>  	struct ieee80211_tx_info *info;
>=20
>  	sdata =3D vif_to_sdata(vif);
> -	bdev =3D sdata->dev;
>  	bss =3D &sdata->u.ap;
>=20
>  	if (!bss)
>=20

--=-gWgIemfChfvkqyDj5u1R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJM9G1AAoJEKVg1VMiehFYu80QALoXX2IIOyQIpZSXoq1Kan44
gzlvQMXK2sK3JGmBx6tZjX/gQcKegaB6JlaJNTBQh2CfIFtnIBI04PH2TodVBdlP
xQNN5gkwFjRfdh/AiIK8eotA3nLa8GqZu3+GXx/FFgG6CLnaYRIcfUdiIldPOnHx
ceDcLqipZwog0EXkCyRrPCfPROf6cP246H+/qcFDPfuVBzfrPCfYcLKCICmV1Lad
KLcbRJVTBNyEx49KVOxHvSPtIVJs+icEV+ygA2spM8VBlJPdBsUZ+PzLRdm1U2Pj
0Z+9LyYBbYZ+1yGEJAdBlkgoT9mOgMasy53PRUPfSJuL+7KnbyntgBycKh3pb2dx
rV9G4AwREXMUBm5D0ao95chtjw+nSa/Ck/YMfMN1jiqTTSBXK50MRFmrNZGvR/Zt
93xPZCoSt7+spDp2C3bubgvvhinUdn+ZiGTaTdc1Zc/MaloVEw0ounwZDwXdWAAd
eKmGta1qEERXWnRfBkhAuiPyERtySKeDjqh1H8gyNM+PK9mKn1v4C3yoXS3MS4f+
iBBi7Px7PFQ+nn6gGGQIlXXVHKTikDr6lYoJwPm1xYoZabp9+zNadT7Z+ZYd7YFW
bsFIuSeedMIdyiTuTbo3QHxKdNkHQoWVyRdq5PDTDl4XMX+sjKWCFHymyqTFezGo
hYaSY+1JjfQPtpCnPYlR
=OG6h
-----END PGP SIGNATURE-----

--=-gWgIemfChfvkqyDj5u1R--

