Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbZHEFT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:19:57 -0400
Subject: Re: [PATCH] wireless: display wext SSID when connected by cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1249437950-8059-1-git-send-email-yi.zhu@intel.com>
References: <1249437950-8059-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Q2cjAIQXr9XiKOeacFJE"
Date: Wed, 05 Aug 2009 07:19:50 +0200
Message-Id: <1249449590.4168.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q2cjAIQXr9XiKOeacFJE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-05 at 10:05 +0800, Zhu Yi wrote:
> cfg80211 displays correct link info when connected by wext. But if
> the connection is setup by cfg80211, wext cannot display the SSID.
> This patch fixed this issue.
>=20
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
> diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
> index 7bacbd1..48c165b 100644
> --- a/net/wireless/wext-sme.c
> +++ b/net/wireless/wext-sme.c
> @@ -210,6 +210,10 @@ int cfg80211_mgd_wext_giwessid(struct net_device *de=
v,
>  		data->flags =3D 1;
>  		data->length =3D wdev->wext.connect.ssid_len;
>  		memcpy(ssid, wdev->wext.connect.ssid, data->length);
> +	} else if (wdev->ssid && wdev->ssid_len) {
> +		data->flags =3D 1;
> +		data->length =3D wdev->ssid_len;
> +		memcpy(ssid, wdev->ssid, data->length);

Hmm. I suspect using wdev->current_bss would be less prone to breakage,
since we've had some trouble with wdev->ssid already, and current_bss
has to be present all the time for various nl80211 too. I guess
ultimately it doesn't matter that much since somebody will see the
problem.

johannes

--=-Q2cjAIQXr9XiKOeacFJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeRZwAAoJEODzc/N7+QmaJb4QAIGpMyEWtg4Uk3h8kFmfblM+
MWoNDz+RSZ6eqJKnFgdEdl41Mi+8uckbCZIK+dBnfo/jH8Kevroktgx5znJwT2lt
t1QhKihnnKRvhsRD1TVEurhL+CXLEg44KwEfgyrR7ukmSqAAtvFtz93cA45sBcIT
ZGJ9J0+G2+SRaQZ48cjEFFPffk2zIMOFEMl933M9vfqQXoaenCwcjP0sGU1QtKGP
lkwYmol9KB8sGzt9qny/DcCA2ikz5De12MePcm6pBWSEGBhi2thaf7z2E3sh+2cP
cMnfn2HqLwBFg9WEQGF1o1ARUC2Vu5XmHdPZGFtrKeOc+1Eq8gVv8uN36mWS7A8Z
S5uD6EoB7/BrpjLD7vhao96RfOPNlKO1w3EgTSn2uqZxNd5QUjL+ihtMQdUD+CLU
AsGLLSHUL4y9gWXyZXmjHSNw7RBC4wKq+7ssB9v3cp82M8QZ5OAJCfGVObY1Neyw
WJnFuAY9Bnj9ydCHsmQn9UQGyz6QocZL9mOp6+0aeWlvwJ9kAXnS2Yx+ue9dzqG3
4qNNhhi20b9SRcB1WUwc/F4Qy1xLgDt5NQmGo2IbvMARI0MQeNrAW2zwxLMcwXTC
P5RA032RhWaSO/ACt2zm02QJ8TUg9zs/3UvRm/Fcf3xTW92eqs8esRgF7pmZ0jFD
RHNdEIj32O8yga0E5OvY
=F75s
-----END PGP SIGNATURE-----

--=-Q2cjAIQXr9XiKOeacFJE--

