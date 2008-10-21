Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbYJUV0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 17:26:21 -0400
Subject: Re: [PATCH v3] Add nl80211 commands to get and set o11s mesh
	networking parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: colin@cozybit.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48fe291a.0236640a.3ca8.6216@mx.google.com> (sfid-20081021_211030_914065_117849BC)
References: <48fe291a.0236640a.3ca8.6216@mx.google.com>
	 (sfid-20081021_211030_914065_117849BC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mCbjhOM4RDs7kfj/+uuB"
Date: Tue, 21 Oct 2008 23:26:13 +0200
Message-Id: <1224624373.28639.11.camel@johannes.berg> (sfid-20081021_232627_594718_C36DCD6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mCbjhOM4RDs7kfj/+uuB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 12:03 -0700, colin@cozybit.com wrote:
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

Looks good to me, thanks.

> Signed-off-by: Colin McCabe <colin@cozybit.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/linux/nl80211.h    |   86 ++++++++++++++++++++
>  include/net/cfg80211.h     |   32 +++++++-
>  net/mac80211/cfg.c         |   68 ++++++++++++++++
>  net/mac80211/ieee80211_i.h |   21 +-----
>  net/wireless/nl80211.c     |  191 ++++++++++++++++++++++++++++++++++++++=
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
> + *
> + * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in T=
Us)
> + * that it takes for an HWMP information element to propagate across the=
 mesh
> + *
> + * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attri=
bute
> + *
> + * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
> + */
> +enum nl80211_meshconf_params {
> +	__NL80211_MESHCONF_INVALID,
> +	NL80211_MESHCONF_RETRY_TIMEOUT,
> +	NL80211_MESHCONF_CONFIRM_TIMEOUT,
> +	NL80211_MESHCONF_HOLDING_TIMEOUT,
> +	NL80211_MESHCONF_MAX_PEER_LINKS,
> +	NL80211_MESHCONF_MAX_RETRIES,
> +	NL80211_MESHCONF_TTL,
> +	NL80211_MESHCONF_AUTO_OPEN_PLINKS,
> +	NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
> +	NL80211_MESHCONF_PATH_REFRESH_TIME,
> +	NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
> +	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
> +	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
> +	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
> +
> +	/* keep last */
> +	__NL80211_MESHCONF_ATTR_AFTER_LAST,
> +	NL80211_MESHCONF_ATTR_MAX =3D __NL80211_MESHCONF_ATTR_AFTER_LAST - 1
> +};
> +
>  #endif /* __LINUX_NL80211_H */
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 0e85ec3..03e1e88 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -347,6 +347,25 @@ struct ieee80211_regdomain {
>  	.flags =3D reg_flags, \
>  	}
> =20
> +struct mesh_config {
> +	/* Timeouts in ms */
> +	/* Mesh plink management parameters */
> +	u16 dot11MeshRetryTimeout;
> +	u16 dot11MeshConfirmTimeout;
> +	u16 dot11MeshHoldingTimeout;
> +	u16 dot11MeshMaxPeerLinks;
> +	u8  dot11MeshMaxRetries;
> +	u8  dot11MeshTTL;
> +	bool auto_open_plinks;
> +	/* HWMP parameters */
> +	u8  dot11MeshHWMPmaxPREQretries;
> +	u32 path_refresh_time;
> +	u16 min_discovery_timeout;
> +	u32 dot11MeshHWMPactivePathTimeout;
> +	u16 dot11MeshHWMPpreqMinInterval;
> +	u16 dot11MeshHWMPnetDiameterTraversalTime;
> +};
> +
>  /* from net/wireless.h */
>  struct wiphy;
> =20
> @@ -397,6 +416,12 @@ struct wiphy;
>   *
>   * @change_station: Modify a given station.
>   *
> + * @get_mesh_params: Put the current mesh parameters into *params
> + *
> + * @set_mesh_params: Set mesh parameters.
> + *	The mask is a bitfield which tells us which parameters to
> + *	set, and which to leave alone.
> + *
>   * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
>   *
>   * @change_bss: Modify parameters for a given BSS.
> @@ -452,7 +477,12 @@ struct cfg80211_ops {
>  	int	(*dump_mpath)(struct wiphy *wiphy, struct net_device *dev,
>  			       int idx, u8 *dst, u8 *next_hop,
>  			       struct mpath_info *pinfo);
> -
> +	int	(*get_mesh_params)(struct wiphy *wiphy,
> +				struct net_device *dev,
> +				struct mesh_config *conf);
> +	int	(*set_mesh_params)(struct wiphy *wiphy,
> +				struct net_device *dev,
> +				const struct mesh_config *nconf, u32 mask);
>  	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
>  			      struct bss_parameters *params);
>  };
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 8ea3090..f681608 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -949,6 +949,72 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy,=
 struct net_device *dev,
>  	rcu_read_unlock();
>  	return 0;
>  }
> +
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
> +static inline bool _chg_mesh_attr(enum nl80211_meshconf_params parm, u32=
 mask)
> +{
> +	return (mask >> (parm-1)) & 0x1;
> +}
> +
> +static int ieee80211_set_mesh_params(struct wiphy *wiphy,
> +				struct net_device *dev,
> +				const struct mesh_config *nconf, u32 mask)
> +{
> +	struct mesh_config *conf;
> +	struct ieee80211_sub_if_data *sdata;
> +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +
> +	if (sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> +		return -ENOTSUPP;
> +
> +	/* Set the config options which we are interested in setting */
> +	conf =3D &(sdata->u.mesh.mshcfg);
> +	if (_chg_mesh_attr(NL80211_MESHCONF_RETRY_TIMEOUT, mask))
> +		conf->dot11MeshRetryTimeout =3D nconf->dot11MeshRetryTimeout;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_CONFIRM_TIMEOUT, mask))
> +		conf->dot11MeshConfirmTimeout =3D nconf->dot11MeshConfirmTimeout;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_HOLDING_TIMEOUT, mask))
> +		conf->dot11MeshHoldingTimeout =3D nconf->dot11MeshHoldingTimeout;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_MAX_PEER_LINKS, mask))
> +		conf->dot11MeshMaxPeerLinks =3D nconf->dot11MeshMaxPeerLinks;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_MAX_RETRIES, mask))
> +		conf->dot11MeshMaxRetries =3D nconf->dot11MeshMaxRetries;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_TTL, mask))
> +		conf->dot11MeshTTL =3D nconf->dot11MeshTTL;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask))
> +		conf->auto_open_plinks =3D nconf->auto_open_plinks;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES, mask))
> +		conf->dot11MeshHWMPmaxPREQretries =3D
> +			nconf->dot11MeshHWMPmaxPREQretries;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_PATH_REFRESH_TIME, mask))
> +		conf->path_refresh_time =3D nconf->path_refresh_time;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT, mask))
> +		conf->min_discovery_timeout =3D nconf->min_discovery_timeout;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT, mask))
> +		conf->dot11MeshHWMPactivePathTimeout =3D
> +			nconf->dot11MeshHWMPactivePathTimeout;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL, mask))
> +		conf->dot11MeshHWMPpreqMinInterval =3D
> +			nconf->dot11MeshHWMPpreqMinInterval;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
> +			   mask))
> +		conf->dot11MeshHWMPnetDiameterTraversalTime =3D
> +			nconf->dot11MeshHWMPnetDiameterTraversalTime;
> +	return 0;
> +}
> +
>  #endif
> =20
>  static int ieee80211_change_bss(struct wiphy *wiphy,
> @@ -1005,6 +1071,8 @@ struct cfg80211_ops mac80211_config_ops =3D {
>  	.change_mpath =3D ieee80211_change_mpath,
>  	.get_mpath =3D ieee80211_get_mpath,
>  	.dump_mpath =3D ieee80211_dump_mpath,
> +	.set_mesh_params =3D ieee80211_set_mesh_params,
> +	.get_mesh_params =3D ieee80211_get_mesh_params,
>  #endif
>  	.change_bss =3D ieee80211_change_bss,
>  };
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 8198447..7a4a3c4 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -23,6 +23,7 @@
>  #include <linux/types.h>
>  #include <linux/spinlock.h>
>  #include <linux/etherdevice.h>
> +#include <net/cfg80211.h>
>  #include <net/wireless.h>
>  #include <net/iw_handler.h>
>  #include <net/mac80211.h>
> @@ -255,26 +256,6 @@ struct mesh_preq_queue {
>  	u8 flags;
>  };
> =20
> -struct mesh_config {
> -	/* Timeouts in ms */
> -	/* Mesh plink management parameters */
> -	u16 dot11MeshRetryTimeout;
> -	u16 dot11MeshConfirmTimeout;
> -	u16 dot11MeshHoldingTimeout;
> -	u16 dot11MeshMaxPeerLinks;
> -	u8  dot11MeshMaxRetries;
> -	u8  dot11MeshTTL;
> -	bool auto_open_plinks;
> -	/* HWMP parameters */
> -	u8  dot11MeshHWMPmaxPREQretries;
> -	u32 path_refresh_time;
> -	u16 min_discovery_timeout;
> -	u32 dot11MeshHWMPactivePathTimeout;
> -	u16 dot11MeshHWMPpreqMinInterval;
> -	u16 dot11MeshHWMPnetDiameterTraversalTime;
> -};
> -
> -
>  /* flags used in struct ieee80211_if_sta.flags */
>  #define IEEE80211_STA_SSID_SET		BIT(0)
>  #define IEEE80211_STA_BSSID_SET		BIT(1)
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 572793c..6272d94 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -96,6 +96,8 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MA=
X+1] __read_mostly =3D {
>  	[NL80211_ATTR_BSS_SHORT_PREAMBLE] =3D { .type =3D NLA_U8 },
>  	[NL80211_ATTR_BSS_SHORT_SLOT_TIME] =3D { .type =3D NLA_U8 },
> =20
> +	[NL80211_ATTR_MESH_PARAMS] =3D { .type =3D NLA_NESTED },
> +
>  	[NL80211_ATTR_HT_CAPABILITY] =3D { .type =3D NLA_BINARY,
>  					 .len =3D NL80211_HT_CAPABILITY_LEN },
>  };
> @@ -1685,6 +1687,183 @@ static int nl80211_req_set_reg(struct sk_buff *sk=
b, struct genl_info *info)
>  	return r;
>  }
> =20
> +static int nl80211_get_mesh_params(struct sk_buff *skb,
> +	struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *drv;
> +	struct mesh_config cur_params;
> +	int err;
> +	struct net_device *dev;
> +	void *hdr;
> +	struct nlattr *pinfoattr;
> +	struct sk_buff *msg;
> +
> +	/* Look up our device */
> +	err =3D get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
> +	if (err)
> +		return err;
> +
> +	/* Get the mesh params */
> +	rtnl_lock();
> +	err =3D drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
> +	rtnl_unlock();
> +	if (err)
> +		goto out;
> +
> +	/* Draw up a netlink message to send back */
> +	msg =3D nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (!msg) {
> +		err =3D -ENOBUFS;
> +		goto out;
> +	}
> +	hdr =3D nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
> +			     NL80211_CMD_GET_MESH_PARAMS);
> +	if (!hdr)
> +		goto nla_put_failure;
> +	pinfoattr =3D nla_nest_start(msg, NL80211_ATTR_MESH_PARAMS);
> +	if (!pinfoattr)
> +		goto nla_put_failure;
> +	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
> +	NLA_PUT_U16(msg, NL80211_MESHCONF_RETRY_TIMEOUT,
> +			cur_params.dot11MeshRetryTimeout);
> +	NLA_PUT_U16(msg, NL80211_MESHCONF_CONFIRM_TIMEOUT,
> +			cur_params.dot11MeshConfirmTimeout);
> +	NLA_PUT_U16(msg, NL80211_MESHCONF_HOLDING_TIMEOUT,
> +			cur_params.dot11MeshHoldingTimeout);
> +	NLA_PUT_U16(msg, NL80211_MESHCONF_MAX_PEER_LINKS,
> +			cur_params.dot11MeshMaxPeerLinks);
> +	NLA_PUT_U8(msg, NL80211_MESHCONF_MAX_RETRIES,
> +			cur_params.dot11MeshMaxRetries);
> +	NLA_PUT_U8(msg, NL80211_MESHCONF_TTL,
> +			cur_params.dot11MeshTTL);
> +	NLA_PUT_U8(msg, NL80211_MESHCONF_AUTO_OPEN_PLINKS,
> +			cur_params.auto_open_plinks);
> +	NLA_PUT_U8(msg, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
> +			cur_params.dot11MeshHWMPmaxPREQretries);
> +	NLA_PUT_U32(msg, NL80211_MESHCONF_PATH_REFRESH_TIME,
> +			cur_params.path_refresh_time);
> +	NLA_PUT_U16(msg, NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
> +			cur_params.min_discovery_timeout);
> +	NLA_PUT_U32(msg, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
> +			cur_params.dot11MeshHWMPactivePathTimeout);
> +	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
> +			cur_params.dot11MeshHWMPpreqMinInterval);
> +	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
> +			cur_params.dot11MeshHWMPnetDiameterTraversalTime);
> +	nla_nest_end(msg, pinfoattr);
> +	genlmsg_end(msg, hdr);
> +	err =3D genlmsg_unicast(msg, info->snd_pid);
> +	goto out;
> +
> +nla_put_failure:
> +	genlmsg_cancel(msg, hdr);
> +	err =3D -EMSGSIZE;
> +out:
> +	/* Cleanup */
> +	cfg80211_put_dev(drv);
> +	dev_put(dev);
> +	return err;
> +}
> +
> +#define FILL_IN_MESH_PARAM_IF_SET(table, cfg, param, mask, attr_num, nla=
_fn) \
> +do {\
> +	if (table[attr_num]) {\
> +		cfg.param =3D nla_fn(table[attr_num]); \
> +		mask |=3D (1 << (attr_num - 1)); \
> +	} \
> +} while (0);\
> +
> +static struct nla_policy
> +nl80211_meshconf_params_policy[NL80211_MESHCONF_ATTR_MAX+1] __read_mostl=
y =3D {
> +	[NL80211_MESHCONF_RETRY_TIMEOUT] =3D { .type =3D NLA_U16 },
> +	[NL80211_MESHCONF_CONFIRM_TIMEOUT] =3D { .type =3D NLA_U16 },
> +	[NL80211_MESHCONF_HOLDING_TIMEOUT] =3D { .type =3D NLA_U16 },
> +	[NL80211_MESHCONF_MAX_PEER_LINKS] =3D { .type =3D NLA_U16 },
> +	[NL80211_MESHCONF_MAX_RETRIES] =3D { .type =3D NLA_U8 },
> +	[NL80211_MESHCONF_TTL] =3D { .type =3D NLA_U8 },
> +	[NL80211_MESHCONF_AUTO_OPEN_PLINKS] =3D { .type =3D NLA_U8 },
> +
> +	[NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES] =3D { .type =3D NLA_U8 },
> +	[NL80211_MESHCONF_PATH_REFRESH_TIME] =3D { .type =3D NLA_U32 },
> +	[NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT] =3D { .type =3D NLA_U16 },
> +	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT] =3D { .type =3D NLA_U32 },
> +	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] =3D { .type =3D NLA_U16 },
> +	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] =3D { .type =3D NLA_U16 },
> +};
> +
> +static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info=
 *info)
> +{
> +	int err;
> +	u32 mask;
> +	struct cfg80211_registered_device *drv;
> +	struct net_device *dev;
> +	struct mesh_config cfg;
> +	struct nlattr *tb[NL80211_MESHCONF_ATTR_MAX + 1];
> +	struct nlattr *parent_attr;
> +
> +	parent_attr =3D info->attrs[NL80211_ATTR_MESH_PARAMS];
> +	if (!parent_attr)
> +		return -EINVAL;
> +	if (nla_parse_nested(tb, NL80211_MESHCONF_ATTR_MAX,
> +			parent_attr, nl80211_meshconf_params_policy))
> +		return -EINVAL;
> +
> +	err =3D get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
> +	if (err)
> +		return err;
> +
> +	/* This makes sure that there aren't more than 32 mesh config
> +	 * parameters (otherwise our bitfield scheme would not work.) */
> +	BUILD_BUG_ON(NL80211_MESHCONF_ATTR_MAX > 32);
> +
> +	/* Fill in the params struct */
> +	mask =3D 0;
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshRetryTimeout,
> +			mask, NL80211_MESHCONF_RETRY_TIMEOUT, nla_get_u16);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshConfirmTimeout,
> +			mask, NL80211_MESHCONF_CONFIRM_TIMEOUT, nla_get_u16);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHoldingTimeout,
> +			mask, NL80211_MESHCONF_HOLDING_TIMEOUT, nla_get_u16);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxPeerLinks,
> +			mask, NL80211_MESHCONF_MAX_PEER_LINKS, nla_get_u16);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxRetries,
> +			mask, NL80211_MESHCONF_MAX_RETRIES, nla_get_u8);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshTTL,
> +			mask, NL80211_MESHCONF_TTL, nla_get_u8);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, auto_open_plinks,
> +			mask, NL80211_MESHCONF_AUTO_OPEN_PLINKS, nla_get_u8);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPmaxPREQretries,
> +			mask, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
> +			nla_get_u8);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, path_refresh_time,
> +			mask, NL80211_MESHCONF_PATH_REFRESH_TIME, nla_get_u32);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, min_discovery_timeout,
> +			mask, NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
> +			nla_get_u16);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathTimeout,
> +			mask, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
> +			nla_get_u32);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPpreqMinInterval,
> +			mask, NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
> +			nla_get_u16);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
> +			dot11MeshHWMPnetDiameterTraversalTime,
> +			mask, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
> +			nla_get_u16);
> +
> +	/* Apply changes */
> +	rtnl_lock();
> +	err =3D drv->ops->set_mesh_params(&drv->wiphy, dev, &cfg, mask);
> +	rtnl_unlock();
> +
> +	/* cleanup */
> +	cfg80211_put_dev(drv);
> +	dev_put(dev);
> +	return err;
> +}
> +
> +#undef FILL_IN_MESH_PARAM_IF_SET
> +
>  static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct nlattr *tb[NL80211_REG_RULE_ATTR_MAX + 1];
> @@ -1902,6 +2081,18 @@ static struct genl_ops nl80211_ops[] =3D {
>  		.policy =3D nl80211_policy,
>  		.flags =3D GENL_ADMIN_PERM,
>  	},
> +	{
> +		.cmd =3D NL80211_CMD_GET_MESH_PARAMS,
> +		.doit =3D nl80211_get_mesh_params,
> +		.policy =3D nl80211_policy,
> +		/* can be retrieved by unprivileged users */
> +	},
> +	{
> +		.cmd =3D NL80211_CMD_SET_MESH_PARAMS,
> +		.doit =3D nl80211_set_mesh_params,
> +		.policy =3D nl80211_policy,
> +		.flags =3D GENL_ADMIN_PERM,
> +	},
>  };
> =20
>  /* multicast groups */

--=-mCbjhOM4RDs7kfj/+uuB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/kjyAAoJEKVg1VMiehFYrVwQAJIrWogA4osewWCpFDfqf4sC
0SYTcEINhrTM+5xUBqkzJKT5bLX7i9Qbr60sSTjYW0xGIdPCUaTQsvdyrjTCD7jb
n9Tg0QDEwqfk5qL2Oy5dSoUsktQDW1ZDn8TYsD0LoQ0VmcHPpuBMVzlz3UnunHLQ
dDY2b6W9Jo9aaQ4uCps/G1F19i/EmuGGrGPe3fDjSfSfYsnEb5yJwaPSIHloMnBZ
mYqQnzc8O543WqVIGLerKcAmPHYZPGTm5ZtlrpCdiLU8EAFEmViv4AlLExw+aAiA
dWX8mjKnvJigjKz7mP6fD++bBHlTWQ6wVbi8UCkRDzTpo3mz49PHvqquFsKtmaxw
7xZm2tWrtdz3b7dRZTx416bdZ9GvImIKLk3+13ocy41qXwl6D4ijzEeJNdxCf2QG
a4rzii/mZzf9kWZO6oYYy43GQqI4ftd+1Dipm0H0nKm/WwZ4SPbKJE7gRx5k4Bn6
VptKYI10zHGUEun4rSR1yf4M7ZUt/4P4vnc+gbWNor7LGXpvXIJBWocEuH4N4ywM
qRvDCnalE83adCxKXtPBpPShTkmFLA1hvemukTOSWM4QsZ6lhzHcfuTv2d5I9PTg
aGjVxedzB6Ew/Md1PsN/iXIdbrcFHh4O4KNfvTX5C90w/ndGTI+0IaV3PDxI79zZ
N/U2TWC0gmoQjQS1x0R2
=WX3W
-----END PGP SIGNATURE-----

--=-mCbjhOM4RDs7kfj/+uuB--

