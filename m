Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196AbZA1Uio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 15:38:44 -0500
Subject: Re: [PATCH v3] cfg80211: add get reg command
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1233172331-15448-1-git-send-email-lrodriguez@atheros.com>
References: <1233172331-15448-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sCQfVlov1T4vHgMnwFDE"
Date: Wed, 28 Jan 2009 21:36:26 +0100
Message-Id: <1233174986.16048.20.camel@johannes.local> (sfid-20090128_213856_956275_E7D01FDF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sCQfVlov1T4vHgMnwFDE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 11:52 -0800, Luis R. Rodriguez wrote:
> This lets userspace request to get the currently set
> regulatory domain.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

looks good to me.
Acked-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>=20
> This v3 removes introduction of reg_get_current_rd() and simply
> accesses cfg80211_regdomain directly.
>=20
>  include/linux/nl80211.h |    4 ++
>  net/wireless/nl80211.c  |   81 +++++++++++++++++++++++++++++++++++++++++=
++++++
>  net/wireless/reg.c      |    2 +-
>  net/wireless/reg.h      |    2 +
>  4 files changed, 88 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 3357907..ef5c1d3 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -113,6 +113,8 @@
>   * @NL80211_CMD_SET_BSS: Set BSS attributes for BSS identified by
>   *	%NL80211_ATTR_IFINDEX.
>   *
> + * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently =
set
> + * 	regulatory domain.
>   * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this =
command
>   *	after being queried by the kernel. CRDA replies by sending a regulato=
ry
>   *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
> @@ -188,6 +190,8 @@ enum nl80211_commands {
> =20
>  	NL80211_CMD_SET_MGMT_EXTRA_IE,
> =20
> +	NL80211_CMD_GET_REG,
> +
>  	/* add new commands above here */
> =20
>  	/* used to define NL80211_CMD_MAX below */
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 3c6327d..e723580 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -2094,6 +2094,81 @@ static int nl80211_set_mesh_params(struct sk_buff =
*skb, struct genl_info *info)
> =20
>  #undef FILL_IN_MESH_PARAM_IF_SET
> =20
> +static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct sk_buff *msg;
> +	void *hdr =3D NULL;
> +	struct nlattr *nl_reg_rules;
> +	unsigned int i;
> +	int err =3D -EINVAL;
> +
> +	mutex_lock(&cfg80211_drv_mutex);
> +
> +	if (!cfg80211_regdomain)
> +		goto out;
> +
> +	msg =3D nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (!msg) {
> +		err =3D -ENOBUFS;
> +		goto out;
> +	}
> +
> +	hdr =3D nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
> +			     NL80211_CMD_GET_REG);
> +	if (!hdr)
> +		goto nla_put_failure;
> +
> +	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2,
> +		cfg80211_regdomain->alpha2);
> +
> +	nl_reg_rules =3D nla_nest_start(msg, NL80211_ATTR_REG_RULES);
> +	if (!nl_reg_rules)
> +		goto nla_put_failure;
> +
> +	for (i =3D 0; i < cfg80211_regdomain->n_reg_rules; i++) {
> +		struct nlattr *nl_reg_rule;
> +		const struct ieee80211_reg_rule *reg_rule;
> +		const struct ieee80211_freq_range *freq_range;
> +		const struct ieee80211_power_rule *power_rule;
> +
> +		reg_rule =3D &cfg80211_regdomain->reg_rules[i];
> +		freq_range =3D &reg_rule->freq_range;
> +		power_rule =3D &reg_rule->power_rule;
> +
> +		nl_reg_rule =3D nla_nest_start(msg, i);
> +		if (!nl_reg_rule)
> +			goto nla_put_failure;
> +
> +		NLA_PUT_U32(msg, NL80211_ATTR_REG_RULE_FLAGS,
> +			reg_rule->flags);
> +		NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_START,
> +			freq_range->start_freq_khz);
> +		NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_END,
> +			freq_range->end_freq_khz);
> +		NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_MAX_BW,
> +			freq_range->max_bandwidth_khz);
> +		NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,
> +			power_rule->max_antenna_gain);
> +		NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,
> +			power_rule->max_eirp);
> +
> +		nla_nest_end(msg, nl_reg_rule);
> +	}
> +
> +	nla_nest_end(msg, nl_reg_rules);
> +
> +	genlmsg_end(msg, hdr);
> +	err =3D genlmsg_unicast(msg, info->snd_pid);
> +	goto out;
> +
> +nla_put_failure:
> +	genlmsg_cancel(msg, hdr);
> +	err =3D -EMSGSIZE;
> +out:
> +	mutex_unlock(&cfg80211_drv_mutex);
> +	return err;
> +}
> +
>  static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct nlattr *tb[NL80211_REG_RULE_ATTR_MAX + 1];
> @@ -2334,6 +2409,12 @@ static struct genl_ops nl80211_ops[] =3D {
>  		.flags =3D GENL_ADMIN_PERM,
>  	},
>  	{
> +		.cmd =3D NL80211_CMD_GET_REG,
> +		.doit =3D nl80211_get_reg,
> +		.policy =3D nl80211_policy,
> +		/* can be retrieved by unprivileged users */
> +	},
> +	{
>  		.cmd =3D NL80211_CMD_SET_REG,
>  		.doit =3D nl80211_set_reg,
>  		.policy =3D nl80211_policy,
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index f643d39..2323644 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -57,7 +57,7 @@ static u32 supported_bandwidths[] =3D {
>  /* Central wireless core regulatory domains, we only need two,
>   * the current one and a world regulatory domain in case we have no
>   * information to give us an alpha2 */
> -static const struct ieee80211_regdomain *cfg80211_regdomain;
> +const struct ieee80211_regdomain *cfg80211_regdomain;
> =20
>  /* We use this as a place for the rd structure built from the
>   * last parsed country IE to rest until CRDA gets back to us with
> diff --git a/net/wireless/reg.h b/net/wireless/reg.h
> index eb1dd5b..fe8c83f 100644
> --- a/net/wireless/reg.h
> +++ b/net/wireless/reg.h
> @@ -1,6 +1,8 @@
>  #ifndef __NET_WIRELESS_REG_H
>  #define __NET_WIRELESS_REG_H
> =20
> +extern const struct ieee80211_regdomain *cfg80211_regdomain;
> +
>  bool is_world_regdom(const char *alpha2);
>  bool reg_is_valid_request(const char *alpha2);
> =20

--=-sCQfVlov1T4vHgMnwFDE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgMHHAAoJEKVg1VMiehFYJdMP/16he8+CYKUGzhktInnwGVYk
PUJEfpM7A9X2YQWI0ANoRSAroFpI6jaHLlcKonfZ1/nu3IOMOg3GLUaY0dAMIngH
cW3ynbGeuVWWrDwu9+OUudND9/Ga2jOo1AhWu57ZjhifVDj+//4Z3jOO2y0F4OZ3
fGwpw+t931jpYNW7pu1aAAXECaaOyh5ha9PD4GwWXLShiXkY2GwHsgp5K2eGtUZw
rIBqd9TqKhnR3RBSymwTFnPoWHlErh3wosCLq5Rcpzn0Qrk+hPpYUWTt7VCvbIQx
ceZxLyU41Qum5O2QHdswPL9JaaXEAIkKyNBduMqqEtUidLn/4ECORj+Y6yslE9lE
ejW9+xaOTFkdYfoKboqud5SqyGHmHOreDa23xGmdLnaPBMHePMQI24AQwWcOn/0h
sy5gJvtcRaBHr0u8tMTq+ZTanZr+S79GxaRipjbAeblsBRpg7Yue+L23sJGhns8B
77M9m2eErsfIJ6VeRNWv/wdq8sZykkeT+qfVC+DhUR7qyKmV1giRPI1UGp8vXm7b
l2a9ZDxzr4wHNfxq9QdlHd4r2WL/dcTDcBEgAaH2JW6yVD56naRKCKhpk0yL2uMH
OTMyt+5KVP1Rx4X0C+uJEVQxa0cNWapL/ZItUH0JDMYu+MHqPWOV0uCbXO/IDim7
tVllEIxPVF3SbLDm5rzD
=Nqvs
-----END PGP SIGNATURE-----

--=-sCQfVlov1T4vHgMnwFDE--

