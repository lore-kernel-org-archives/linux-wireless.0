Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40078 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYIVO7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 10:59:53 -0400
Subject: Re: [PATCH 1/1] mac80211: fix led behavior in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1222092610-25374-1-git-send-email-tomas.winkler@intel.com>
References: <1222092610-25374-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TPAIKcN/5SnnQ90iVLLu"
Date: Mon, 22 Sep 2008 16:59:03 +0200
Message-Id: <1222095543.3023.83.camel@johannes.berg> (sfid-20080922_165956_878713_F8DAEEE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TPAIKcN/5SnnQ90iVLLu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-22 at 17:10 +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch fixes the led behavior in IBSS. After we joined an IBSS cell w=
e
> need to inform the led that we got associated. Although there is no 802.1=
1
> association in IBSS mode, the semantic of "There is a link" is relevant.
> This allows the led to blink in IBSS mode (at least this solves a bug for
> iwlwifi).

Doesn't it also have to be turned off again at some point? Or is that
done? Other than that looks fine to me.

> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/mlme.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 2e55208..2bae226 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1483,6 +1483,8 @@ static int ieee80211_sta_join_ibss(struct ieee80211=
_sub_if_data *sdata,
>  	ifsta->state =3D IEEE80211_STA_MLME_IBSS_JOINED;
>  	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
> =20
> +	ieee80211_led_assoc(local, true);
> +
>  	memset(&wrqu, 0, sizeof(wrqu));
>  	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
>  	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);

--=-TPAIKcN/5SnnQ90iVLLu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI17KzAAoJEKVg1VMiehFYusIP/0Pws6Q0ba0WA/MM7Qwb9yFF
i1k0IPf50S9txEg/VLqdow0tYGOrIicbxHcLKIwwXsw9YTTnpfWtBbYb+jLULCXs
j78ZEJOECvqhdd7Y6mhv6o+sy1gsLoD6/iwQ/ULQmEEkwUvVZbTPkveUlzlhf1mR
lOl5anE9WP95r+jpw+vhNyU019D9cwtNyQboeM6YT0AKzfo2Y/p4enrWdEa2Tneh
k1MMcGe3NlGH1wI/RsiZ4VQQ2i01NHBoP+A9s8NCkcz3yXvvZYA2RL9jEMKEbWaS
VZuYOlto9akIRwCP8nGjx4H6pe/szwbhP660VIh/M+lQ09Gg40OXQwNMki+Q6gbE
RbHrYRH8DLk2uDra97M3uTbrbMLhRXaosirsH34awUUtQOgE7GUrYpiVwiX2cN1i
OmHWSYyZsdeUvTobZTgvvj9h155pcZfZmaPkDVYZXoq6zUSigK4WKC+/tf0fhrZO
KTYv6tiGfiEq/aSDVrDRFKFIkVb7V8fRwu5uXACD9gv8G3H/sn0cGHmftXzZii5L
VKhWTzQh22V71FYySlif/t2NOyeajhkjIibYjwdiguS7zRID9G++ziNmYtnbSnwK
LXDeRJjFjQMseX1X8rIP1hJTJAfNxiqthknzmScCKDHcOHo1rA68v88XXpm+QNh5
G/44sQ0jZoC007CyuBkJ
=1QJ5
-----END PGP SIGNATURE-----

--=-TPAIKcN/5SnnQ90iVLLu--

