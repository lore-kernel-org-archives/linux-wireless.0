Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZCSTAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 15:00:03 -0400
Subject: Re: [PATCH 4/4] nl80211: Add MLME primitives to support external
 SME
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <20090319114808.301521477@atheros.com>
References: <20090319113918.555693846@atheros.com>
	 <20090319114808.301521477@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1c7nCEszFSSuEuVqLDgq"
Date: Thu, 19 Mar 2009 19:59:57 +0100
Message-Id: <1237489197.5100.112.camel@johannes.local> (sfid-20090319_200007_692205_1C21AAC0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1c7nCEszFSSuEuVqLDgq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-19 at 13:39 +0200, Jouni Malinen wrote:

> +	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
> +		req.chan =3D ieee80211_get_channel(
> +			wiphy,
> +			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
> +		if (!req.chan) {
> +			err =3D -EINVAL;
> +			goto out;
> +		}
> +	}

Validate the channel is permitted?

> +	if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
> +		req.auth_type =3D
> +			nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
> +	}

We should validate the auth type is one of the four valid ones, I think.

> +	if (nla_len(info->attrs[NL80211_ATTR_SSID]) > IEEE80211_MAX_SSID_LEN) {
> +		err =3D -EINVAL;
> +		goto out;
> +	}

That seems unnecessary since your netlink policy restricts it already.

> +	if (info->attrs[NL80211_ATTR_REASON_CODE])
> +		req.reason_code =3D
> +			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);

Should probably require non-zero? Same in disassoc, I guess.

Since disassoc and deauth are really almost the same, maybe use one
function and multiplex like nl80211_addset_beacon?


> +static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
> +			  struct cfg80211_auth_request *req)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +
> +	if (!netif_running(dev))
> +		return -ENETDOWN;

Should probably be in cfg80211 directly, I think, to enforce this across
drivers.

> +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +
> +	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> +		return -EOPNOTSUPP;

That too.

> +	switch (req->auth_type) {
> +	case NL80211_AUTHTYPE_OPEN_SYSTEM:
> +		sdata->u.mgd.auth_algs =3D IEEE80211_AUTH_ALG_OPEN;
> +		break;
> +	case NL80211_AUTHTYPE_SHARED_KEY:
> +		sdata->u.mgd.auth_algs =3D IEEE80211_AUTH_ALG_SHARED_KEY;
> +		break;
> +	case NL80211_AUTHTYPE_FT:
> +		sdata->u.mgd.auth_algs =3D IEEE80211_AUTH_ALG_FT;
> +		break;
> +	case NL80211_AUTHTYPE_NETWORK_EAP:
> +		sdata->u.mgd.auth_algs =3D IEEE80211_AUTH_ALG_LEAP;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;

and I already said the "default" part here should be too (though it
should stick around here if we ever add new mechanisms)

Similarly in assoc, of course.

otherwise looks good.

johannes

--=-1c7nCEszFSSuEuVqLDgq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwpYqAAoJEKVg1VMiehFYqwkQALhJ3G7UtXZ8etZe+jq8Oy0Z
o9yP4XjX/iUPyM4C2MtwzqNc492cPyglD95CfHq8KHJWfsR23xb+ZNa4Kgv24AA9
MhnQscgDEAWg356hgP9PIAztGlnGx5LENht2CEy08sbVvuKxf30PezG/JTnH+HX2
l07DXnSVP9j2wpMQzeeJXAuK2Sn9dxzUMRM32tYiZhY4Q+sx8eHUGARd4LYBvlQU
B1IKZcaE4EEEK6Ifr0uZKBgfcyvB7EzguglmYkWvDVD3Tz3zaIPIy50c13dNTt/j
E1teoAqdVEQ/zQ8Hl0+Gu8KUDkVimJ1eFkuZaGArIoBLwkJ4sTltdra43UNYbFaP
8MHDD74iHmjCyvzbZ7qf8bNvy4W0VWnaPBexQiEguDxkqUHbLr+kmc01GeaMc5AT
h8QoeVdddbD9zQcGc8Dse/GRUYcyZdF4RwFQ7odZ4cEbk4Jfb/ueBhofIf4i+LBR
kCpOTSMHi+bgQn9NRhQGgac+zU85P0CweegTuGL9t/SToHuDCS52XU1rODOFPO8O
/vqrWEqegGrC3WJs258Kt7YgCAQdh3wjW284srMisMrRJvVPqq0fzn5himHI3UyW
PNat40hZwNRQaE77fUWhLoN8hZVDr7OFlrjD1PT4hE4JnZxMviWRvZJZcJwWS51x
R876PAfatPNxEH3VxCAD
=vNvb
-----END PGP SIGNATURE-----

--=-1c7nCEszFSSuEuVqLDgq--

