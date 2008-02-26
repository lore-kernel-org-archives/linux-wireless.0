Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYBZIYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 03:24:09 -0500
Subject: Re: [PATCH 06/10] mac80211: RCU-ify STA info structure access
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1203985337.6929.120.camel@localhost> (sfid-20080226_002043_615849_4CE09F20)
References: <20080225152740.360393000@sipsolutions.net>
	 <20080225153007.340533000@sipsolutions.net>
	 <1203985337.6929.120.camel@localhost>
	 (sfid-20080226_002043_615849_4CE09F20)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Eeosmt6JT9VX8PtRl4NR"
Date: Tue, 26 Feb 2008 09:23:58 +0100
Message-Id: <1204014238.13162.201.camel@johannes.berg> (sfid-20080226_082413_168440_22BA2967)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Eeosmt6JT9VX8PtRl4NR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > @@ -303,8 +300,8 @@ static void mesh_path_node_reclaim(struc
> >  	struct mpath_node *node =3D container_of(rp, struct mpath_node, rcu);
> >  	struct ieee80211_sub_if_data *sdata =3D
> >  		IEEE80211_DEV_TO_SUB_IF(node->mpath->dev);
> > -	if (node->mpath->next_hop)
> > -		sta_info_put(node->mpath->next_hop);
> > +
> > +	rcu_assign_pointer(node->mpath->next_hop, NULL);
>=20
> Is that necessary? If we are here nobody else should have access to this
> path and we should just free it, right?

Yeah I think you're right and we can just free it since access is gone
already.

> Also since now we can force deletion, the mesh path timer might be
> running and we need a del_timer_sync() somewhere. After adding that, we
> may as well always force the path deletion.

I put a del_timer() into sta_info_unlink() and a del_timer_sync() into
sta_info_destroy(). That should be enough afaict.

johannes

--=-Eeosmt6JT9VX8PtRl4NR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8PMnaVg1VMiehFYAQK84BAAvYE94Sz66ZpxC0urPvpb0Hvls0FbwPqq
EBS85OrMMqGlfubMS1SzoylqdWohCibw0jLTK2F4EHo0hlPOU6TuHEzv0L4JZjcy
VlLufQmi+/k7iGa6RHERJGjULmhwXLhy0FXa+tsjvfJ5VSJj4uU0VQ+ap5u1EWx7
uCzAgUi35Jvc/OpIjCIPqNC+FJRYTMoPGkAP4Am2s/MlB5ihrnZF+c0zjXV7yMpW
rBzkrNpWNoITLO8WMvSXi+8epEh5r7D1yvjeQpgPoGqF17OX0lBEQytRfj630dQ9
jqkG15uKOnMnwW4o48fCBffxJBJswRNaD5H8Vnfys26e9fRmKZ32NKxQqD/MKxNr
pdPyAA0HCGV/+hqM4/NdgcyCkzsyBmCH9ucTxQoh96H3LIExPMXZlVmKHTXVNpq6
kC9JCJD7gN17UjmjwpJUbvsb9AG7Z1teQWdAp9T6qjNIJbxKZHOuAjbt9rarvSf/
daogqfDkQke24/mJlYvYP1iPp0oZZ6o3Vzik/pPr0q1rTEckPg0QcwVZHd5lyMCI
VxTJbKO26dXIab1UDJBWR4tcfJu7Cqjix6DVHA/SQLEkRI5NYqJ8saKcZm0wLTII
+KVRjxCPBzgtXDEb1I5ML3keHsXdHdL3evTNib1HYs2B7Y8pes3Rjwnqc/A38Mb8
7VP3ZYnWHLo=
=BZWh
-----END PGP SIGNATURE-----

--=-Eeosmt6JT9VX8PtRl4NR--

