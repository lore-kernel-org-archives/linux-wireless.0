Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZEPMUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 08:20:31 -0400
Subject: Re: [RFC 1/3] cfg80211: mark ops as pointer to const
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
In-Reply-To: <1242476577-26320-2-git-send-email-kilroyd@googlemail.com>
References: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>
	 <1242476577-26320-2-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-P9Oj5+tN3xDU4xwsUVc9"
Date: Sat, 16 May 2009 14:20:26 +0200
Message-Id: <1242476426.10005.36.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P9Oj5+tN3xDU4xwsUVc9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-16 at 13:22 +0100, David Kilroy wrote:
> This allows drivers to mark their cfg80211_ops tables const.

Seems fine to me. Somehow I forgot to mark lots of things const in
cfg80211...

> Signed-off by: David Kilroy <kilroyd@googlemail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/net/cfg80211.h |    2 +-
>  net/wireless/core.c    |    2 +-
>  net/wireless/core.h    |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9e17a83..7702715 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1070,7 +1070,7 @@ static inline const char *wiphy_name(struct wiphy *=
wiphy)
>   * The returned pointer must be assigned to each netdev's
>   * ieee80211_ptr for proper operation.
>   */
> -struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv);
> +struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)=
;
> =20
>  /**
>   * wiphy_register - register a wiphy with cfg80211
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 47c20eb..98bfd4d 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -228,7 +228,7 @@ int cfg80211_dev_rename(struct cfg80211_registered_de=
vice *rdev,
> =20
>  /* exported functions */
> =20
> -struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
> +struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
>  {
>  	static int wiphy_counter;
> =20
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index f14b6c5..725c22e 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -15,7 +15,7 @@
>  #include "reg.h"
> =20
>  struct cfg80211_registered_device {
> -	struct cfg80211_ops *ops;
> +	const struct cfg80211_ops *ops;
>  	struct list_head list;
>  	/* we hold this mutex during any call so that
>  	 * we cannot do multiple calls at once, and also

--=-P9Oj5+tN3xDU4xwsUVc9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDq+EAAoJEODzc/N7+QmaYSYP/jZDeU2j05ZDhATihRKPLHV2
k5lQCvvrzOkbtZny+OkbHInJhJFVNoaurWGbbExHx8tyCYh22TlZSvrC5r7Zcrfu
F2Pd6nYz6d2S+amSHsyhEGUNOhn3zz484wUtPgfwYJPwmZV+GWCpAAL/8GqqZJ9b
oCKu2+JhdpaFmwdwUJ5AyXgSlG2CF6pRAdz+RaQv5mfDaRjRDsgpJQW5XXBFsaNh
m4DVBIgrcedcdE46/+g0NeMWEerRmfPjtPo0HZa8FHybbdKMW2OO+fBHqMYb9+Wb
ypcw7HxzZ/aiiS/6+fV8BmQFYFZf6UFjfg5q/wdAEo/rHfP+pDkOHxNO9/qcW+2W
12frfkijYwW2q+HESsgGNWu4qoQBqEvnRzSeC/WPWPt0Dcx1Kfm1vot0Ji2iS1NF
BCwsRpDLBhIUbRu2TbOmP6kxDC6QCnVSH7LEXIsBP1DRjm8EzvuQj5hGKqpKk2FB
5IGl4EI9bTIt/SOHEMzRq+jwMhAG7btVpgXtEKFWyaJec/wLm+7DR5efXGqA/epX
eLL9bkOTkRmwYQTNgPVYEKAVkzj9vU62C1p4/DXwTC0ZtrMev7JPkt4PecusuT1p
b/vrCnDGNsZAKTLdOiC/JaeTMoDPvIr5svAzS09wrCPyaAQu+MvwlRNkR3tx8o8n
5nIFM86ka6D/rdyi3Blt
=WYD6
-----END PGP SIGNATURE-----

--=-P9Oj5+tN3xDU4xwsUVc9--

