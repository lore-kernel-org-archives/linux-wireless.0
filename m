Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZBIKjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 05:39:07 -0500
Subject: Re: [PATCH 2/3] mac80211: Modul. mesh path prot: Comm w/ Userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Sesser <flomaillist@cosetrain.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <897787d59c53459e0bff3a6829ac470f6ed2e84e.1234118418.git.flomaillist@cosetrain.com> (sfid-20090208_205238_013714_9C35AD85)
References: <498F36B7.40806@cosetrain.com>
	 <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
	 <897787d59c53459e0bff3a6829ac470f6ed2e84e.1234118418.git.flomaillist@cosetrain.com>
	 (sfid-20090208_205238_013714_9C35AD85)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KNZOY9jmSQcvk3e8gT/5"
Date: Mon, 09 Feb 2009 11:39:02 +0100
Message-Id: <1234175942.4175.218.camel@johannes.local> (sfid-20090209_113912_801722_6EBD48A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KNZOY9jmSQcvk3e8gT/5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-02-08 at 20:52 +0100, Florian Sesser wrote:
> Modularize mesh path selection protocol.

that's the subject, you also need to mentioned nl80211/cfg80211 since
that is the bulk of the change.

> This patch enables communication with userspace through the
> "iw" tool. The corresponding patch to IW will be posted on
> this list.

NACK to this description. 'iw' is but one implementation of an nl80211
userspace client.

> +++ b/include/net/cfg80211.h
> @@ -458,6 +458,10 @@ struct mesh_config {
>  	u32 dot11MeshHWMPactivePathTimeout;
>  	u16 dot11MeshHWMPpreqMinInterval;
>  	u16 dot11MeshHWMPnetDiameterTraversalTime;
> +	/* Mesh IDs */
> +	u32 mesh_path_selection_protocol_id;
> +	u32 mesh_path_selection_metric_id;
> +	u32 mesh_congestion_control_mode_id;

That's not a useful comment.
=20
> +	if (_chg_mesh_attr(NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID, mask))
> +		mesh_ids_set_pp(&sdata->u.mesh,
> +		nconf->mesh_path_selection_protocol_id);
> +	if (_chg_mesh_attr(NL80211_MESHCONF_PATH_SELECTION_METRIC_ID, mask))
> +		conf->mesh_path_selection_metric_id =3D
> +			nconf->mesh_path_selection_metric_id;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID, mask))
> +		conf->mesh_congestion_control_mode_id =3D
> +			nconf->mesh_congestion_control_mode_id;

Shouldn't this actually effect the change too?

> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, mesh_path_selection_protocol_id,
> +			mask, NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID,
> +			nla_get_u32);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, mesh_path_selection_metric_id,
> +			mask, NL80211_MESHCONF_PATH_SELECTION_METRIC_ID,
> +			nla_get_u32);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, mesh_congestion_control_mode_id,
> +			mask, NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID,
> +			nla_get_u32);

can that possibly be unset?

johannes

--=-KNZOY9jmSQcvk3e8gT/5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkAfDAAoJEKVg1VMiehFYYTkP/17EVT5Yd+1uUrlrMwDWBpog
T8HfH1XgvufWBCE8Jft/18iQ5HlfaDeRFolpV7wMcM2Z1/hJfDysKXZBtAFMwyGW
YGvIouZnwaR7cA4Bn7uwe88J4kjDrhA/LBPWuTWCvmM4WHYafhvpJfXKRulLC62J
v/nx+6YQ2/f94BPjaXSMf69FjQeJW9WPKcA3FD+w5pDrkuIjjt7Kr4UzDLkzWqPe
0r8tK5ouk6ugO1Yy8d6UQSKvVDuxVQupPlNWWScf+NFpc5p44NyO81CIQ/stwgsA
Ifb958CTZ9oVjDWKMVbxZEtatJizInkFRIVZSsM4jDI1I3fs8h1S2QsDC9pnFGwR
Mkp7ri8WBAjBliYwuQayG/FoqoOCK7EUtc1JXATV/U7U8N6Ikj92ZbaQ9HbovL+y
yD48BM6/haEGLaU+fL7lswslhdoOWl+7SzvH2nUod+LBnLxOGwDZ1MTkO2O2pZte
c9uUsC2pzDmnFyckDShNvu5ctyUllm0rmc3QXN+OMK9dFOhMu/cMOJxmD5nGFL/N
wupqSDXhiRdd3Ps8mtl0I/EoGFEWGaECfN8vfBGikEpbaXpXjfxmIvsO6jB5zA2i
7eVIfTxJNyair+qnBrIHV9NcNQIq6i9rRexat5WDv2h6xWnDyblDW30Lddlnn/Iv
U9dQw2l7xz3HWGmZ8/l6
=NHeH
-----END PGP SIGNATURE-----

--=-KNZOY9jmSQcvk3e8gT/5--

