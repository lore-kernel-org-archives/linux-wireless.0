Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbYBGKfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:35:40 -0500
Subject: Re: [PATCH 02/13] o11s: (nl80211/cfg80211) support for mesh
	interfaces and set_mesh_cfg command
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a7825f.03b48c0a.7362.5cd9@mx.google.com> (sfid-20080204_212410_095702_D5CB4C0C)
References: <47a7825f.03b48c0a.7362.5cd9@mx.google.com>
	 (sfid-20080204_212410_095702_D5CB4C0C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hvpL9hdoOVzjd9zBSP4g"
Date: Thu, 07 Feb 2008 01:18:09 +0100
Message-Id: <1202343489.9965.47.camel@johannes.berg> (sfid-20080207_103557_777809_EC537563)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hvpL9hdoOVzjd9zBSP4g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

=20
> +/*
> + * struct mesh_params - describes mesh parameters

Here, and various other places too, you need "/**" rather than just "/*"
for kernel-doc to be able to pick it up.

>   * @add_key: add a key with the given parameters. @mac_addr will be %NUL=
L
>   *	when adding a group key.
> + * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
>   *
>   * @get_key: get information about the key with the given parameters.
>   *	@mac_addr will be %NULL when requesting information for a group

Please keep the key operations grouped.

> @@ -82,6 +82,8 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MA=
X+1] __read_mostly =3D {
>  	[NL80211_ATTR_STA_SUPPORTED_RATES] =3D { .type =3D NLA_BINARY,
>  					       .len =3D NL80211_MAX_SUPP_RATES },
>  	[NL80211_ATTR_STA_VLAN] =3D { .type =3D NLA_U32 },
> +	[NL80211_ATTR_MESH_ID] =3D { .type =3D NLA_NUL_STRING,
> +				.len =3D IEEE80211_MAX_MESH_ID_LEN },

That should be NLA_BINARY since it's not a NULL-terminated string but
rather an arbitrary up-to-MESH_ID_LEN-long byte value, no?
=20
> +	params.mesh_id =3D nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
> +	/* Cut null character */
> +	params.mesh_id_len =3D nla_len(info->attrs[NL80211_ATTR_MESH_ID]) - 1 ;

Then you can save that -1 and the comment :)

FWIW, I'm not entirely happy with this interface. I tried to keep
ADD/DEL/GET/SET groups of commands to create/delete/get/set
object/object properties. This breaks that, but I guess it's just a
single value that is set. That's why I initially suggested to make it
part of the SET_INTERFACE command since it seems to me that this
identifies the mesh you'll be using.

However, maybe I don't understand the mesh ID well enough yet, can you
maybe explain in a few sentences where it is used and what for?

johannes

--=-hvpL9hdoOVzjd9zBSP4g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pOQKVg1VMiehFYAQIhDhAApxO9KxUKBee/jLi9GYtM8e/G1T9iOmBL
sG8+2SVbi1MiG1tHKrHGg2RfE5WwA2FX1f+VA0z833mp1D+8ZGjWcMsLy0/ONip4
L7uLyUpxRrFJN3lci3boXSA9DmgkyVGfyPR3X1zVg7xViykFwXeq5hhPVZoj12cV
IdOC2pzmbGpsRm5y8VbjKO9D0xXzES2fP5KVZ2WjgOaLu8sbH+BtMeMlqExrIOWq
U2GZ3qSMl6xGfVsjPbteLc857RJcCxSpxw6Fea+b3piUb/AqecZmOZdPeQxB9iEV
BwqlaGZxcji4JcU0N2ISnuCPCxXt8AbQmYGiErJtiJSro7sjKVqEh+h9ej+tFWTh
pht+oX4JKEbnJOBaSqvDw0OlObvUkd1BUxOKwc/F/gWHuFIkfmugJ8/7zz5+9n/e
JRXyAu9pnTpwd8ajQARpb4eKFfvTndb1RIwl0J6swnOtka6lAFgHf7xKYbqhFHBb
X3fek/Q7A7tzZGzKBboZVgcmIRCqMvfbFwNa2pNK9vYTKkm4UPONvDUiRlMzTSYx
d9uYl5xCUMUyUEK+bH2L+2WSUN0IxG9oIGy7EndPU4TxXsM6VVhuVlTq1txd02NR
sZ+z/PQAb1xo/ERfHYdQC1O9X5E4CeaUa3dPdHTRTrjymEIcUhN1EfUd7ti5Ij9n
Olwzzvkebd8=
=bK4g
-----END PGP SIGNATURE-----

--=-hvpL9hdoOVzjd9zBSP4g--

