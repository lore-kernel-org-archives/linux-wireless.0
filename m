Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbYHCSO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 14:14:28 -0400
Subject: Re: [PATCH 1/1] mac80211: filter probes in
	ieee80211_rx_mgmt_probe_resp
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217763121-9057-1-git-send-email-tomas.winkler@intel.com>
References: <1217763121-9057-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NL998EU53tLijWLUbKt9"
Date: Sun, 03 Aug 2008 20:14:19 +0200
Message-Id: <1217787259.4721.18.camel@johannes.berg> (sfid-20080803_201431_293341_3A562717)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NL998EU53tLijWLUbKt9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-08-03 at 14:32 +0300, Tomas Winkler wrote:
> This patch moves filtering statement from ieee80211_rx_bss_info
> which is called for both beacon and probe to ieee80211_rx_mgmt_probe_resp
> and save few cycles in beacon parsing.

Sounds alright to me, but maybe we should then document that
rx_bss_info() only expects data for the right BSSID?

> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/mlme.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 5358420..0800385 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2570,9 +2570,6 @@ static void ieee80211_rx_bss_info(struct net_device=
 *dev,
>  	DECLARE_MAC_BUF(mac);
>  	DECLARE_MAC_BUF(mac2);
> =20
> -	if (!beacon && memcmp(mgmt->da, dev->dev_addr, ETH_ALEN))
> -		return; /* ignore ProbeResp to foreign address */
> -
>  	beacon_timestamp =3D le64_to_cpu(mgmt->u.beacon.timestamp);
> =20
>  	if (ieee80211_vif_is_mesh(&sdata->vif) && elems->mesh_id &&
> @@ -2890,6 +2887,9 @@ static void ieee80211_rx_mgmt_probe_resp(struct net=
_device *dev,
>  	size_t baselen;
>  	struct ieee802_11_elems elems;
> =20
> +	if (memcmp(mgmt->da, dev->dev_addr, ETH_ALEN))
> +		return; /* ignore ProbeResp to foreign address */
> +
>  	baselen =3D (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
>  	if (baselen > len)
>  		return;

--=-NL998EU53tLijWLUbKt9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlfV4AAoJEKVg1VMiehFY4x8QAJ2Sc2s+8kvKgowjNCNQv54I
pCrxFoWa7fpbySs79SDGRMnJX7+9rOMgA+c5kkr8tCzmd91KaQZELIhbwkHcpSkN
8UyzyPLFL25YosAjOzximqj3fv3hFtzS0OFwc6cTD3z8gWKPWXKCiw54cLbxvQYw
FZ+7h+/rnclyDNLFgerzUH01u9SPsfZfFHjU0HaGVvQYYY5bk7PR8WxeWeujIZPc
3AVxjqeO5WX3rP21SFu5/FW4SDuNz7vX3zek5PEzK8cmzkDuD6FHRJCPIKVW3MGg
7Wu96wlwdhmCCbTsWmFDR9vZWSCpIHrUJnNatmMryON21LGdSwgfPlKpVvL3GWIG
cE8NuWzT9CMfaIBOukFp2BfSNkYFmnCy7/n86k60B03tVTTkiddoxkWOPv15ZBAS
j+gRM5+KyNvAJSu7zsHX8Ea+nWNEZpkECtAULJhH16mVzYnSJ8cO+cUGsw1E94Wd
QqzcOMFwXZ7L+G76aTblvRKgog+DFmv+Oa34h9FdCu3Qwn7jiY6QUvOuQEM1PJvc
Y85sPEQx/Qf+CatE52QGrNPgJH+bE7itmffEdNoz7fHjxckQH6028p7si1K3qLS+
rTtdWoMIOnUAlmQBjq5Qs5SOR0jkD893Ab07wAKELshfYV8HTH18igRW81i/8L0X
5N0B3EvcczEci53iSrFN
=Da6+
-----END PGP SIGNATURE-----

--=-NL998EU53tLijWLUbKt9--

