Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbZGOLqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 07:46:04 -0400
Subject: Re: [PATCH 3/5] cfg80211: add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <1247617320-20163-4-git-send-email-lrodriguez@atheros.com>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
	 <1247617320-20163-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Lj6/m/h45ONTeX6yoUWj"
Date: Wed, 15 Jul 2009 13:45:22 +0200
Message-Id: <1247658322.2302.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Lj6/m/h45ONTeX6yoUWj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-14 at 20:21 -0400, Luis R. Rodriguez wrote:

> +	/* Draw up a netlink message to send back */
> +	msg =3D nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (!msg) {

Need to use DEFAULT_SIZE or something.

> +	if (!(wiphy->wow_triggers_supported & triggers_requested)) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;

This seems wrong, should be "requested & supported !=3D requested", I
think.

> @@ -4253,6 +4359,16 @@ static struct genl_ops nl80211_ops[] =3D {
>  	{
>  		.cmd =3D NL80211_CMD_DISCONNECT,
>  		.doit =3D nl80211_disconnect,
> +	},
> +	{
> +		.cmd =3D NL80211_CMD_GET_WOW,
> +		.doit =3D nl80211_get_wow,
> +		.policy =3D nl80211_policy,
> +		/* can be retrieved by unprivileged users */
> +	},
> +	{
> +		.cmd =3D NL80211_CMD_SET_WOW,
> +		.doit =3D nl80211_set_wow,
>  		.policy =3D nl80211_policy,
>  		.flags =3D GENL_ADMIN_PERM,
>  	},

This messes up the disconnect command.

johannes

--=-Lj6/m/h45ONTeX6yoUWj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXcFPAAoJEODzc/N7+Qma98EP/RdxRYI+x+ro8DsLjfJb7K4z
zuma/Rt1OJS9rAg2BlLw/GStI276JlDHjVmHwkFDo+Y02tkpK9Jbdc2/uMMpoRj+
Q1aArSpsZ4GcaVho2wR2SDE/ei8G7SIbuTWAoXVy5TJLHVv+ri/cl6++fYVSIXvY
ahcMlGKkepRMAbxADUC8YuQL87W0oV3Rhe1tp7KGtbZjOyqfpTu5kka8wj+uflNd
uFZClA1zNImmKV6+8Eabr4vEnw68ibuzNi7o51wQNRzyk4HtivBMX4qIqu+ULX5+
v2TH/HtGwrUQ22EwAPfgdn348MS13LPZf0fgpwXLhqDprzZ/LiC2A2a1G0xngTL+
WhIEP00B6mAIhBPWHxUqpAUVeahACS6zBekYOur8uOp9cXi8vVHhV34w2Wv7l3ju
bZAXyTH3qMfMc/d6yu95aP89OfvCls8kmb5yLUf/pnrAW7WNxd82elKBSlH5CapJ
ZAvIwQA5sz1cmbrW/0jKNh/AOUPGRVxYLdECCKAcUkX4KL1QYjtJYhMxuzy4io3Z
jR6/8RcGNTAQxW1siv/ZnK84KJdtN245Fb6lTqAWQiFmdkBG8FnkzpwMyzjMH/vT
5olUUSvsl8sbIr7UK5Fw8FtDtr/FacyRTdCuMXQY8WYDSAdrcOM4qFfazvbtDQUM
YmXqsZ3wjolMMdqkTyQp
=EQzT
-----END PGP SIGNATURE-----

--=-Lj6/m/h45ONTeX6yoUWj--

