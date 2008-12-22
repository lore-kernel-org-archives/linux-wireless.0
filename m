Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbYLVTHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 14:07:01 -0500
Subject: Re: [PATCH v2 12/18] mac80211: no need for ht.enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <1229970039-10561-13-git-send-email-lrodriguez@atheros.com>
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-3-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-4-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-5-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-6-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-7-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-8-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-9-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-10-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-11-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-12-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-13-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-07uIfv7JzY0f+1LSUNkQ"
Date: Mon, 22 Dec 2008 20:06:56 +0100
Message-Id: <1229972816.4406.16.camel@johannes> (sfid-20081222_200706_554448_7854C1AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-07uIfv7JzY0f+1LSUNkQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 10:20 -0800, Luis Rodriguez wrote:
> We can simply use conf_is_ht() check where needed.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/net/mac80211.h |    1 -
>  net/mac80211/ht.c      |    3 +--
>  net/mac80211/main.c    |   10 ----------
>  net/mac80211/mlme.c    |    1 -
>  4 files changed, 1 insertions(+), 14 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index ee2b75e..b51caab 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -509,7 +509,6 @@ static inline int __deprecated __IEEE80211_CONF_SHORT=
_SLOT_TIME(void)
>  #define IEEE80211_CONF_SHORT_SLOT_TIME (__IEEE80211_CONF_SHORT_SLOT_TIME=
())
>=20
>  struct ieee80211_ht_conf {
> -       bool enabled;
>         enum nl80211_channel_type channel_type;
>  };
>=20
> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> index 55bfe48..6314289 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -130,11 +130,10 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_dat=
a *sdata,
>                 }
>         }
>=20
> -       ht_changed =3D local->hw.conf.ht.enabled !=3D enable_ht ||
> +       ht_changed =3D conf_is_ht(&local->hw.conf) !=3D enable_ht ||
>                      channel_type !=3D local->hw.conf.ht.channel_type;
>=20
>         local->oper_channel_type =3D channel_type;
> -       local->hw.conf.ht.enabled =3D enable_ht;
>=20
>         if (ht_changed)
>                 ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 24b1436..a6cb480 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -211,16 +211,6 @@ int ieee80211_hw_config(struct ieee80211_local *loca=
l, u32 changed)
>             channel_type !=3D local->hw.conf.ht.channel_type) {
>                 local->hw.conf.channel =3D chan;
>                 local->hw.conf.ht.channel_type =3D channel_type;
> -               switch (channel_type) {
> -               case NL80211_CHAN_NO_HT:
> -                       local->hw.conf.ht.enabled =3D false;
> -                       break;
> -               case NL80211_CHAN_HT20:
> -               case NL80211_CHAN_HT40MINUS:
> -               case NL80211_CHAN_HT40PLUS:
> -                       local->hw.conf.ht.enabled =3D true;
> -                       break;
> -               }
>                 changed |=3D IEEE80211_CONF_CHANGE_CHANNEL;
>         }
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c75d0ea..6558209 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -874,7 +874,6 @@ static void ieee80211_set_disassoc(struct ieee80211_s=
ub_if_data *sdata,
>=20
>         rcu_read_unlock();
>=20
> -       local->hw.conf.ht.enabled =3D false;
>         local->oper_channel_type =3D NL80211_CHAN_NO_HT;
>         config_changed |=3D IEEE80211_CONF_CHANGE_HT;
>=20
> --
> 1.6.1.rc3.51.g5832d
>=20
>=20

--=-07uIfv7JzY0f+1LSUNkQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJT+VNAAoJEKVg1VMiehFYyIwP/jpR5pZXI/BAeKDhOCxIZfFc
xt/0eMuJ1TQejqlBOo0du1Yv3B2n/L7uNFmW1MhPOE3PiQ/YNtBbPhjbltOQ222L
kEvhaBAsPsxlK+9xMpWZY18SfmuMnLT6FPyP5CZZ0QFeovq/dXuFAPuYK9UULk+z
ojYju9DA7vucqDpkW+bmqToQlVZEA6CocdftJ+NZBurOrzrGs4AMScybajvyRCLI
0pELpLhzEIVxe+d1i1ZlRT+JfjM/Ok6ShYA60MPOH9nSK6TwJYXf4To6zYUSCURH
CgGhqcvaGQiOrOakm4jL8ZVoQtoUOQeY5ytadcCEgMo6h6Ja+0SOhzOfkR8Wn8ON
62+KZ32GaC5xjW7YnFR32Wz+gFEJw8p0ND9U5Jn/PSzzL9yvbyVvNdJXn7BP+oHK
rY8ymmLmMadzvReorhPnfJXJV/wnFkFLk2tkcadN+NQ8Jx3mwQpKzrb23IE8Hl7D
h/dip573TsLIJYQpRnhIK0vwBO6a5lWavcHoFk+GL6BV6qFZ0t6/b16pMKX5xVUb
+YBG31M9PnOI9x78L1JfJjQVqCaCWyCI2aM8zxYkLJAHiNCmOgbKMhmTPjsygUda
zi4d2M7Jr4xPHXmZ6x7trCJM7C/glU45DdwtLLRSBtazqB93HoD4HSt/7NAO3UgE
K42QSUG56yx27/J5QQc6
=yYW6
-----END PGP SIGNATURE-----

--=-07uIfv7JzY0f+1LSUNkQ--

