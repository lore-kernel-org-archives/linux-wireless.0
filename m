Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYIUMLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 08:11:16 -0400
Subject: Re: [RFC V2] mac80211: mesh portal functionality support
From: Johannes Berg <johannes@sipsolutions.net>
To: YanBo <dreamfly281@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Javier Cardona <javier@cozybit.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1197ff4c0809210450u556538actc6f37390d3079fbc@mail.gmail.com> (sfid-20080921_135057_878688_51244EC5)
References: <1197ff4c0809170200l701ce25bg6035734a394f8c83@mail.gmail.com>
	 <1197ff4c0809210450u556538actc6f37390d3079fbc@mail.gmail.com>
	 (sfid-20080921_135057_878688_51244EC5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Tdz5CAWl7VePO/pWcrkz"
Date: Sun, 21 Sep 2008 14:11:11 +0200
Message-Id: <1221999071.3023.21.camel@johannes.berg> (sfid-20080921_141119_837589_98143D2F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Tdz5CAWl7VePO/pWcrkz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-21 at 19:50 +0800, YanBo wrote:

> @@ -226,6 +227,8 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
>  void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
>  struct mesh_path *mesh_path_lookup(u8 *dst,
>  		struct ieee80211_sub_if_data *sdata);
> +struct mesh_path *mpp_path_lookup(u8 *dst, struct
> ieee80211_sub_if_data *sdata);

there's a line-wrap here for some reason


>  static struct mesh_table *mesh_paths;
> +static struct mesh_table *mpp_paths; /* Store pathes for MPP&MAP */

Can you add a note why we need a separate hash table at all?

> @@ -475,11 +589,19 @@ static int mesh_path_node_copy(struct hlist_node
> *p, struct mesh_table *newtbl)
>  int mesh_pathtbl_init(void)
>  {
>  	mesh_paths =3D mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
> +	if (!mesh_paths)
> +		return -ENOMEM;
>  	mesh_paths->free_node =3D &mesh_path_node_free;
>  	mesh_paths->copy_node =3D &mesh_path_node_copy;
>  	mesh_paths->mean_chain_len =3D MEAN_CHAIN_LEN;
> -	if (!mesh_paths)
> -		return -ENOMEM;
> +
> +	mpp_paths =3D mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
> +	if (!mpp_paths)
> + 		return -ENOMEM;

This leaks 'mesh_paths'.

> +	if (mesh_hdr->flags =3D=3D 2){

that should use the constant you introduced

johannes

--=-Tdz5CAWl7VePO/pWcrkz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI1jnaAAoJEKVg1VMiehFYmtAP+wYYWQ+FNRAOTuiIPcPG6zQx
d9NY/feqCzE9Eipu4/IIKRt5mmqI6jgL1t5zpszCiA2xQJcfkVWQoEG2TgDchSJJ
RpopnksUF5dMTTx2RRndz5m37+TWDyvI6RTmof9Tr969eVza2EqSaA5Dqr0l7xzX
+fJK4bOSI2dI8BapJvtq+HmY480LJj2C5bIk/1rqXDudDlLzc0BVHigrPE+pDbWF
wZSwMnjS5n28r5x1OFDO7MyY2gzPKXzwhoSIlrxWxfBT8xYKkt2BOA+SQ8IKQF23
4fn0jPHJjRO9MQbY9Xz/5nOQbbpfJNjx5TiOJMBqMMVfDSMmUpEjzdJ+ogJz7CDa
kdxARDkPFiICQCA3cxiZxn8fLhdIVaondMCXbm08KXiJlCeSZ3Bqps6Vx8qDBafr
cNrI64Sa2dZx0QYIiwy+bEbvbd978k0nIeZusfCiz08tODpTT9OPQlTI/NFyBGV9
P3AQ9ntM4DfOes5aEHiuvBuWojt4sPAJNQPj15FA4fB97I+FGCr8o+/SloTvM7w0
Tiiwc3V6d+3iHcsIOMe1PERb/YCQ/B2qqM4CnFnPBL/JhlqbHFGaqaJH3fkP+mXZ
m1vb0y6SAZf2pXM99yaAcmXahQ1YpfGFeoaeVqyN4jwsszj+g1zp7FPoCx8bKm+K
G1Fdc+NxP+R0e/WJuux7
=2HpZ
-----END PGP SIGNATURE-----

--=-Tdz5CAWl7VePO/pWcrkz--

