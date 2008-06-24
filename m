Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYFXKt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:49:58 -0400
Subject: Re: [PATCH 2/4] mac80211: update the authentication method
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/a8na0Ak4y6VSaQ0RsDu"
Date: Tue, 24 Jun 2008 12:49:19 +0200
Message-Id: <1214304559.8967.281.camel@johannes.berg> (sfid-20080624_125017_315239_5CC5E199)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/a8na0Ak4y6VSaQ0RsDu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-24 at 13:37 +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch updates the authentication method upon giwencode ioctl.

Out of curiosity, are you using this?? Or are you just trying to
increase WEXT coverage for some reason? Anyway, it seems like it should
be there.

> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/wext.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 53f8767..308b953 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -952,6 +952,19 @@ static int ieee80211_ioctl_giwencode(struct net_devi=
ce *dev,
>  	erq->length =3D sdata->keys[idx]->conf.keylen;
>  	erq->flags |=3D IW_ENCODE_ENABLED;
> =20
> +	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA) {
> +		struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +		switch (ifsta->auth_alg) {
> +		case WLAN_AUTH_OPEN:
> +		case WLAN_AUTH_LEAP:
> +			erq->flags |=3D IW_ENCODE_OPEN;
> +			break;
> +		case WLAN_AUTH_SHARED_KEY:
> +			erq->flags |=3D IW_ENCODE_RESTRICTED;
> +			break;
> +		}
> +	}
> +
>  	return 0;
>  }
> =20

--=-/a8na0Ak4y6VSaQ0RsDu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYNErAAoJEKVg1VMiehFYn5kQAJ/56ihCEcMvt1U3jI4+4Br5
areWRH7oL1S+mNt+NHk+aggV97zxasK5fsTqALTEsRVXZJGiXVH9BpkHrNY3ERyX
8lWfzYrdVLLrSfcjYNSVtOsXZTqQW/a4tswtG9ui+cxgeIHrcIAHv+yol3dgm4y0
e1yV3zFCeY9Rib9+zLDQuB+h7n7SAQX5kDNcDHDgS644MjDtJIwuYFhO++ExG0bj
OPRYdpI5NNvq2GGZBWmDBkkOm+ob48b8H1Kae0JSa660p5FWjUj4iNqW21RPEohM
76Kmdce14DylP5mJ5gzwxY321gA+s46/6Hd8p3/qKGQ6re7PPtaOxZ2Y9XV5TFQT
LnzdsKK/k3Nwz5gBvoR7pRQAOJvK2jmYvlO8W8KzC2uE93Ls0KqjPSua4WjR9xyf
H+S1uywd9tq+Xq0/4p3h6UvPEo/cMS6SMMp1dU43N10d3Lng4JbQCGcPdeQBYqlh
qHQp3Dw1uYgi3f4hIYlIoH3effzI/nTBttak8WE3ozI2jpjFDtA9WPj7/anP+3Ec
AhIeZC8LABHL08p7xoACrSpS/PqVip22M+3WVemh7JgHwZbI7yaK+sBUq/lc26GV
1xdOvGBEN/8HZWGxnOa1wQyzl9n9NzS/m5yxi293wbFaEPO3QHUoc0bQDGM0uMGi
liGJZ/YRjrlCpEpgYamn
=41GB
-----END PGP SIGNATURE-----

--=-/a8na0Ak4y6VSaQ0RsDu--

