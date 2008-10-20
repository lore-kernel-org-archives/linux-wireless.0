Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYJTSZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 14:25:36 -0400
Subject: Re: [PATCH v2] Add nl80211 commands to get and set o11s mesh
	networking parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: colin@cozybit.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48fcc3c2.38652c0a.297d.533e@mx.google.com> (sfid-20081020_194546_775680_98F2849E)
References: <48fcc3c2.38652c0a.297d.533e@mx.google.com>
	 (sfid-20081020_194546_775680_98F2849E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GXajbtD2WhpHL4odHa/Y"
Date: Mon, 20 Oct 2008 20:25:30 +0200
Message-Id: <1224527130.27899.60.camel@johannes.berg> (sfid-20081020_202539_963556_A02E9B49)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GXajbtD2WhpHL4odHa/Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 10:40 -0700, colin@cozybit.com wrote:
> The two new commands are NL80211_CMD_GET_MESH_PARAMS and
> NL80211_CMD_SET_MESH_PARAMS. There is a new attribute enum,
> NL80211_ATTR_MESH_PARAMS, which enumerates the various mesh configuration
> parameters.
>=20
> Moved struct mesh_config from mac80211/ieee80211_i.h to net/cfg80211.h.
> nl80211_get_mesh_params and nl80211_set_mesh_params unpack the netlink me=
ssages
> and ask the driver to get or set the configuration.  This is done via two=
 new
> function stubs, get_mesh_params and set_mesh_params, in struct cfg80211_o=
ps.

> +	/* Set the mask */
> +	mask =3D 0;
> +	for (i =3D 0; i < NL80211_MESHCONF_ATTR_MAX; ++i)
> +		if (tb[i+1])
> +			mask |=3D (1 << i);

Can you move that into the macro so it's set whenever you parse any of
the values? I think you probably missed that in my earlier mail? Or was
there a reason not to?

> +	/* Fill in the params struct */
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshRetryTimeout,
> +			NL80211_MESHCONF_RETRY_TIMEOUT, nla_get_u16);


> +		.cmd =3D NL80211_CMD_GET_MESH_PARAMS,
> +		.doit =3D nl80211_get_mesh_params,
> +		.policy =3D nl80211_policy,
> +		.flags =3D GENL_ADMIN_PERM,

Does this really need admin permission for getting the values?

johannes

--=-GXajbtD2WhpHL4odHa/Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/M0UAAoJEKVg1VMiehFYHPYQAIFd6aTAWpQL7rVdYnB9mvXb
xukbHx0sE14myQlGCtP4tw//sG+BiYeNdA/LEXRjndaNyc453DLxVuXXWd/jtFmW
oHpOyYlc1rFwTf/jA/jE4Aj6SK8owTNrW6KbllRsZx9oXkwz0MRWKnu45vhCq0sG
FsxJmCMMqvXk01wJPG5X7voAUGQW+Gf+ipMcWoBY9filtkBA8eN03wxt/Ve6xYz5
0Km+GKj/9+MzVP26uSWvRLgwT7D6yYyvIaKEnOhYm++NrV65d1kKUyNeCwbjnAxb
LhN7T1shgm5i2lmjVmneI5cAfnXjllHVmndCtPtD8B9PG65TXhHeGrVIJJsfEOug
a8s+O9X6DAc+yBf9C6s/f5yvL2I52Q6ly5gPEXGODsTj0aXv2neFHkPgB5WFjDlQ
eLmliaEntA697fUI2bBRO2DbLZ7hnDrHlHMsT2GGCFNf7W6ZXhM78gqL/JZg84WL
9iNoWxiDjhBRwQjadrEwjxkVH2w81rw0p42WRm4RMBBX8WynAhQVqElo2D9BpUvz
xWqwrSLR6jaxQvhQ2hEfsgc9nAmCMbI0Rz5Gzsl2Hp4IKUVDw/b+17/3x1bEixob
PLHAj93FJ9so5xRu3DyCAdRQ4SP+Bet2tqALMX4b5c5Jy3N9fd3yovl/Bpe1+wr5
rNA9dN9dJ1WclCQpfrmz
=cpzs
-----END PGP SIGNATURE-----

--=-GXajbtD2WhpHL4odHa/Y--

