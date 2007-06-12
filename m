Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXFLJPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 05:15:31 -0400
Subject: Re: [PATCH] cfg80211: use nl80211_* enums
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070611221224.GA10598@charon.n2.diac24.net>
References: <20070611221224.GA10598@charon.n2.diac24.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kvXrN92KwZxwjcjPBQwV"
Date: Tue, 12 Jun 2007 11:08:05 +0200
Message-Id: <1181639285.29767.52.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kvXrN92KwZxwjcjPBQwV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-06-12 at 00:12 +0200, David Lamparter wrote:
> Use enum nl80211_phymode and nl80211_iftype where appropriate. Update
> mac80211 and nl80211 to match.
>=20
> Signed-off-by: David Lamparter <equinox@diac24.net>

Looks good to me.
Acked-by: Johannes Berg <johannes@sipsolutions.net>

There's one place in your new code where you used -1 to indicate an
invalid setting, you should probably change that then.

> ---
>  include/net/cfg80211.h       |    9 +++++----
>  net/mac80211/ieee80211_cfg.c |    2 +-
>  net/wireless/nl80211.c       |    4 ++--
>  3 files changed, 8 insertions(+), 7 deletions(-)
>=20
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 813706a..1398c21 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3,6 +3,7 @@
> =20
>  #include <linux/netlink.h>
>  #include <linux/skbuff.h>
> +#include <linux/nl80211.h>
>  #include <net/genetlink.h>
> =20
>  /*
> @@ -18,7 +19,7 @@
>   * @active: scan actively or passively on this channel
>   */
>  struct scan_channel {
> -	int phymode;
> +	enum nl80211_phymode phymode;
>  	u32 channel;
>  	int active;
>  };
> @@ -36,7 +37,7 @@ struct scan_channel {
>  struct scan_params {
>  	int n_channels;
>  	int active;
> -	int phymode;
> +	enum nl80211_phymode phymode;
>  	struct scan_channel *channels;
>  };
> =20
> @@ -116,10 +117,10 @@ struct wiphy;
>   */
>  struct cfg80211_ops {
>  	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
> -				    unsigned int type);
> +				    enum nl80211_iftype type);
>  	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
>  	int	(*change_virtual_intf)(struct wiphy *wiphy, int ifindex,
> -				       unsigned int type);
> +				       enum nl80211_iftype type);
> =20
>  	int	(*associate)(struct wiphy *wiphy, struct net_device *dev,
>  			     struct association_params *params);
> diff --git a/net/mac80211/ieee80211_cfg.c b/net/mac80211/ieee80211_cfg.c
> index 0069826..8f85bc2 100644
> --- a/net/mac80211/ieee80211_cfg.c
> +++ b/net/mac80211/ieee80211_cfg.c
> @@ -13,7 +13,7 @@
>  #include "ieee80211_cfg.h"
> =20
>  static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
> -			       unsigned int type)
> +			       enum nl80211_iftype type)
>  {
>  	struct ieee80211_local *local =3D wiphy_priv(wiphy);
>  	int itype;
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index d6a44a3..ffbe628 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -293,7 +293,7 @@ static int nl80211_add_virt_intf(struct sk_buff *skb,=
 struct genl_info *info)
>  {
>  	struct cfg80211_registered_device *drv;
>  	int err;
> -	unsigned int type =3D NL80211_IFTYPE_UNSPECIFIED;
> +	enum nl80211_iftype type =3D NL80211_IFTYPE_UNSPECIFIED;
> =20
>  	if (!info->attrs[NL80211_ATTR_IFNAME])
>  		return -EINVAL;
> @@ -353,7 +353,7 @@ static int nl80211_change_virt_intf(struct sk_buff *s=
kb, struct genl_info *info)
>  {
>  	struct cfg80211_registered_device *drv;
>  	int err, ifindex;
> -	unsigned int type;
> +	enum nl80211_iftype type;
>  	struct net_device *dev;
> =20
>  	if (info->attrs[NL80211_ATTR_IFTYPE]) {

--=-kvXrN92KwZxwjcjPBQwV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbmJ1/ETPhpq3jKURAvx8AJ9sSm702rG4wtul+MaSTui7WF9SvACdGnNa
LCvAAT76Xr8rbpgrqsO6Sco=
=b76f
-----END PGP SIGNATURE-----

--=-kvXrN92KwZxwjcjPBQwV--

