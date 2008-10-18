Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYJRQFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 12:05:12 -0400
Subject: Re: [PATCH] Add nl80211 commands to get and set o11s mesh
	networking parameters.
From: Johannes Berg <johannes@sipsolutions.net>
To: colin@cozybit.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
In-Reply-To: <48f7dedf.16098e0a.7692.537e@mx.google.com> (sfid-20081017_024005_718221_828C0FCD)
References: <48f7dedf.16098e0a.7692.537e@mx.google.com>
	 (sfid-20081017_024005_718221_828C0FCD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GN7HrtiNZm2ZtHUiiMPT"
Date: Sat, 18 Oct 2008 16:53:57 +0200
Message-Id: <1224341637.6324.29.camel@johannes.berg> (sfid-20081018_180520_037037_82E2F085)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GN7HrtiNZm2ZtHUiiMPT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-16 at 17:05 -0700, colin@cozybit.com wrote:
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
>=20
> Signed-off-by: Colin McCabe <colin@cozybit.com>
> ---
>  include/linux/nl80211.h    |   86 ++++++++++++++++++++
>  include/net/cfg80211.h     |   32 +++++++-
>  net/mac80211/cfg.c         |   72 +++++++++++++++++
>  net/mac80211/ieee80211_i.h |   21 +-----
>  net/wireless/nl80211.c     |  187 ++++++++++++++++++++++++++++++++++++++=
++++++
>  5 files changed, 377 insertions(+), 21 deletions(-)
>=20
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 9bad654..40d7b27 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -106,6 +106,12 @@
>   * 	to the the specified ISO/IEC 3166-1 alpha2 country code. The core wi=
ll
>   * 	store this as a valid request and then query userspace for it.
>   *
> + * @NL80211_CMD_GET_MESH_PARAMS: Get mesh networking properties for the
> + *	interface identified by %NL80211_ATTR_IFINDEX
> + *
> + * @NL80211_CMD_SET_MESH_PARAMS: Set mesh networking properties for the
> + *      interface identified by %NL80211_ATTR_IFINDEX
> + *
>   * @NL80211_CMD_MAX: highest used command number
>   * @__NL80211_CMD_AFTER_LAST: internal use
>   */
> @@ -148,6 +154,9 @@ enum nl80211_commands {
>  	NL80211_CMD_SET_REG,
>  	NL80211_CMD_REQ_SET_REG,
> =20
> +	NL80211_CMD_GET_MESH_PARAMS,
> +	NL80211_CMD_SET_MESH_PARAMS,
> +
>  	/* add new commands above here */
> =20
>  	/* used to define NL80211_CMD_MAX below */
> @@ -296,6 +305,8 @@ enum nl80211_attrs {
>  	NL80211_ATTR_REG_ALPHA2,
>  	NL80211_ATTR_REG_RULES,
> =20
> +	NL80211_ATTR_MESH_PARAMS,
> +
>  	/* add attributes here, update the policy in nl80211.c */
> =20
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -594,4 +605,79 @@ enum nl80211_mntr_flags {
>  	NL80211_MNTR_FLAG_MAX =3D __NL80211_MNTR_FLAG_AFTER_LAST - 1
>  };
> =20
> +/**
> + * enum nl80211_meshconf_params - mesh configuration parameters
> + *
> + * Mesh configuration parameters
> + *
> + * @__NL80211_MESHCONF_INVALID: internal use
> + *
> + * @NL80211_MESHCONF_RETRY_TIMEOUT: specifies the initial retry timeout =
in
> + * millisecond units, used by the Peer Link Open message
> + *
> + * @NL80211_MESHCONF_CONFIRM_TIMEOUT: specifies the inital confirm timeo=
ut, in
> + * millisecond units, used by the peer link management to close a peer l=
ink
> + *
> + * @NL80211_MESHCONF_HOLDING_TIMEOUT: specifies the holding timeout, in
> + * millisecond units
> + *
> + * @NL80211_MESHCONF_MAX_PEER_LINKS: maximum number of peer links allowe=
d
> + * on this mesh interface
> + *
> + * @NL80211_MESHCONF_MAX_RETRIES: specifies the maximum number of peer l=
ink
> + * open retries that can be sent to establish a new peer link instance i=
n a
> + * mesh
> + *
> + * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a sour=
ce mesh
> + * point.
> + *
> + * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
> + * open peer links when we detect compatible mesh peers.
> + *
> + * @NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES: the number of action frames
> + * containing a PREQ that an MP can send to a particular destination (pa=
th
> + * target)
> + *
> + * @NL80211_MESHCONF_PATH_REFRESH_TIME: how frequently to refresh mesh p=
aths
> + * (in milliseconds)
> + *
> + * @NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT: minimum length of time to wa=
it
> + * until giving up on a path discovery (in milliseconds)
> + *
> + * @NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT: The time (in TUs) for whi=
ch mesh
> + * points receiving a PREQ shall consider the forwarding information fro=
m the
> + * root to be valid. (TU =3D time unit)
> + *
> + * @NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL: The minimum interval of tim=
e (in
> + * TUs) during which an MP can send only one action frame containing a P=
REQ
> + * reference element

Why are some in TU and some in ms? Are there any restrictions between
these?

> + * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in T=
Us)
> + * that it takes for an HWMP information element to propagate across the=
 mesh

How does userspace know this one?

> +static int ieee80211_get_mesh_params(struct wiphy *wiphy,
> +				struct net_device *dev,
> +				struct mesh_config *conf)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +
> +	if (sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> +		return -ENOTSUPP;
> +	memcpy(conf, &(sdata->u.mesh.mshcfg), sizeof(struct mesh_config));
> +	return 0;
> +}
> +
> +static inline bool _chg_mesh_attr(enum nl80211_attrs attr, u32 mask)
> +{
> +	/* This makes sure that there aren't more than 32 mesh config
> +	 * parameters (otherwise our bitfield scheme would not work.) */
> +	BUILD_BUG_ON(NL80211_MESHCONF_ATTR_MAX > 32);

That BUILD_BUG_ON should be somewhere in cfg80211/nl80211 (core code)
rather than mac80211 I think.

The attr parameter looks weird, are you sure it should be that enum and
not the mesh config one?

> +	return (mask >> (attr-1)) & 0x1;

I think

	return mask & (1<<(attr-1));

would be easier to understand.

> +#define FILL_IN_MESH_PARAM_IF_SET(table, cfg, param, attr_num, nla_fn) \
> +do {\
> +	if (table[attr_num]) {\
> +		cfg.param =3D nla_fn(table[attr_num]); \
> +	} \
> +} while (0);\


> +	/* Set the mask */
> +	mask =3D 0;
> +	for (i =3D 0; i < NL80211_MESHCONF_ATTR_MAX; ++i)
> +		if (tb[i+1])
> +			mask |=3D (1 << i);

I think it'd make more sense to set the mask in the macro too. That'd
make it less error-prone when adding attributes (if that will ever
happen).

For good measure, you could #undef the macro again at the end of the
function. Maybe even declare it within the function, but I don't care
much.

But this is all fairly minor stuff, looks good to me, thanks for doing
this. Do you have a corresponding patch for iw?

johannes

--=-GN7HrtiNZm2ZtHUiiMPT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI+fiBAAoJEKVg1VMiehFYS34QAKoG9GLCSFcBvFBNp/ClepBR
E8Fjhr7sAzq0bYou+3sbNTV09vo9YnY8IUjieKB6BGshu8Nr2tmhHcg/3Z09aT7n
ua9EP+6BN6Yjjw6HlbgA+/V3Z418Q1UwG64ALjDS18QzuW2LbzOQQe4JNpzaAqkh
8M6OsM98qYmGTXXWHEw5xmfVCM6rSPf2H9ErqJbeTMg0AKCXbN+Yn1r11ry4GCmG
XfqRoj88xkcsBg12Kjyu3OozvoPGlkg9JnPI/C8HRmIbz9g36ISoxozFjUZ1OX7W
kPUTn2nUeQgCH1L8Sw8+ujugA40G1QVJuod/CwP5dUpKh703gWAy+UPFoRPZ1E4t
TcnA5Ez9+eAPPfqmXTkbsR+ndZmlP5uxspKU+QqSwenlrilGyqDNbKxJ5XuMy7dz
wsTt7ylT2ZHZzeAsOFmZ7vb3n18uethfhXOQgcPzT705TuwAV+GScvKjMPv/3LnM
7K/pAPf3e0bQ5bl8DP7ZUYkaUeZZnZK6KXUJha3Ns7ZFf13RsyNWsP0opTfFeltY
wXTo9NbVpSHVRk+ZNv/I63KuCnVJXYMJOm3iWiyA/b5jMrE5elZf0MVgr+mo39HQ
VdF+4c7AZwtK4eRhgCRSNywHE3TaAbNNyj4/o7Ax3UQkrJxFwUE9/iaJWyrBSAol
YbtY2tWGh+g1KaU1tjiK
=L579
-----END PGP SIGNATURE-----

--=-GN7HrtiNZm2ZtHUiiMPT--

