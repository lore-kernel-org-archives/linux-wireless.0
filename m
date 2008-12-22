Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYLVTGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 14:06:23 -0500
Subject: Re: [PATCH v2 01/18] mac80211: add HT conf helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wwAX69n/yoTISrTHZSCo"
Date: Mon, 22 Dec 2008 20:06:21 +0100
Message-Id: <1229972781.4406.12.camel@johannes> (sfid-20081222_200627_826167_FE8B616B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wwAX69n/yoTISrTHZSCo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 10:20 -0800, Luis Rodriguez wrote:
> In HT capable drivers you often need to check if you
> are currently using HT20 or HT40. This adds a few small
> helpers to let drivers figure that out.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  include/net/mac80211.h |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index b3bd00a..ee2b75e 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1963,4 +1963,34 @@ rate_lowest_index(struct ieee80211_supported_band =
*sband,
>  int ieee80211_rate_control_register(struct rate_control_ops *ops);
>  void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
>=20
> +static inline bool
> +conf_is_ht20(struct ieee80211_conf *conf)
> +{
> +       return conf->ht.channel_type =3D=3D NL80211_CHAN_HT20;
> +}
> +
> +static inline bool
> +conf_is_ht40_minus(struct ieee80211_conf *conf)
> +{
> +       return conf->ht.channel_type =3D=3D NL80211_CHAN_HT40MINUS;
> +}
> +
> +static inline bool
> +conf_is_ht40_plus(struct ieee80211_conf *conf)
> +{
> +       return conf->ht.channel_type =3D=3D NL80211_CHAN_HT40PLUS;
> +}
> +
> +static inline bool
> +conf_is_ht40(struct ieee80211_conf *conf)
> +{
> +       return conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf);
> +}
> +
> +static inline bool
> +conf_is_ht(struct ieee80211_conf *conf)
> +{
> +       return conf->ht.channel_type !=3D NL80211_CHAN_NO_HT;
> +}
> +
>  #endif /* MAC80211_H */
> --
> 1.6.1.rc3.51.g5832d
>=20
>=20

--=-wwAX69n/yoTISrTHZSCo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJT+UpAAoJEKVg1VMiehFY2H0P/2eNsM9kB7wWlglZx8cglFEk
vtgul50O/XxIY698zdVIQ/CXGGWfMHlYZ8Nc8mDo5b38EhsCH9z1BBlvqHjtcYJw
w/Ty9C5nBD9hr9nZzIKpEb8UqwUl8K1Qz5RuEs0zajGiJiwqu9o5r+fTg1eRRIuY
Azjpc8jNFu7roiBEoRK7tKdF/JNeE80fTpoNDH/cDdgaB6lX8MTjBZeFu9rTs2lw
NS5uk4nt7T8OdiBA5wIuTPU1WWnTB9yD6i3pzVfkR74nOc/pWtwAmmkJa2wFJcTm
0upGdBMf3G7Zx4zDvhASCe25GfcIAD4gtceN3PJc1kb+1V0nyqYwYqIGsHAXiLj/
UwO1xdPo4+D23U1/63I5Q8SwYwsG2ge/ZTC0usFbqoYykqU0wmsAjkV/TilMJLWn
lMa40swi4Kn0UR97iYpPWeoIfPe0IwIoh19wX2xPNnQ9sBjAqCv/2zkvJ/X6knpO
/UbGkv4ImglwvcEsIDW+mI6EV0nMhblDvijA0uIFyHxgQuVGBqEY+ZDjhJFR3iL/
g/5b5VdjI84kZdM2hDypXC2qR3wBW3UE9QJbP4+5Miet+XpmK0fzZ6dOBwuUeBfp
4C0XRP7SAduc4SIUweJ+7xEfEJNCO9GrWq61vMQDv1cBvMpckjK12RAgt47Kf1Ji
xAgqWbZT5p7akvcQkCMd
=9qe2
-----END PGP SIGNATURE-----

--=-wwAX69n/yoTISrTHZSCo--

