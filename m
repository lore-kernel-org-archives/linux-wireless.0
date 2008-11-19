Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYKSLz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 06:55:57 -0500
Subject: Re: [PATCH] mac80211: Look out for some other AP when disassoc is
	received.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081120000322.GA2828@myhost.users.atheros.com> (sfid-20081119_113000_488824_99355D56)
References: <20081120000322.GA2828@myhost.users.atheros.com>
	 (sfid-20081119_113000_488824_99355D56)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pC1yW8aMIMsOoA5fOc++"
Date: Wed, 19 Nov 2008 12:55:16 +0100
Message-Id: <1227095716.26243.20.camel@johannes.berg> (sfid-20081119_125603_084104_B4627145)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pC1yW8aMIMsOoA5fOc++
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 16:03 -0800, Vivek Natarajan wrote:
> When a disassoc packet is received with a reason code of 'AP leaving the =
BSS',
> mac80211 should start looking for some other AP instead of trying to
> associate with the same AP.

Umm, it doesn't try to associated with the same AP. And the patch you're
doing is kinda pointless, the reason codes are very often simply wrong
or "due to some local policy decision". Also, the reason code that's
being passed is the one we send ourselves, not the one we received.

> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  net/mac80211/mlme.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 6d5ed9c..8d0f995 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -855,7 +855,7 @@ static void ieee80211_set_disassoc(struct ieee80211_s=
ub_if_data *sdata,
> =20
>  	ieee80211_sta_send_apinfo(sdata, ifsta);
> =20
> -	if (self_disconnected)
> +	if (self_disconnected || reason =3D=3D WLAN_REASON_DISASSOC_STA_HAS_LEF=
T)
>  		ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
> =20
>  	sta_info_unlink(&sta);
> @@ -1174,7 +1174,7 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee8=
0211_sub_if_data *sdata,
>  				      IEEE80211_RETRY_AUTH_INTERVAL);
>  	}
> =20
> -	ieee80211_set_disassoc(sdata, ifsta, false, false, 0);
> +	ieee80211_set_disassoc(sdata, ifsta, false, false, reason_code);
>  }
> =20
>=20

--=-pC1yW8aMIMsOoA5fOc++
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJI/6hAAoJEKVg1VMiehFYu4oQAMWgsuw8cqkDLXY1evdLktaP
quuuBiKDry48p2Oy8HT8OyIm/CitkTYuSXJGHjmzbK1NHFW+pyknKUsg+ZitJ+RT
MWSyqM2twNkI0u/3+69ZiGPo4KijWQNC1isKjxn+k/wO8DdG39WHJ3xC29j5nJvG
U9aTJdXwIuVB/lUVKa+4pI4QtmtCdSeUTOvky1zBaf90EJdKXM01ai49kRQa72fm
y5xGffYQA/Ef5OzD2lxh/gDvV9inPTDMqlhfPICSCPkGL/eU2a95Cr1IJJU34TZw
AOdTi/lDi49xtL2dDoEwYCwuab6ydhmZoqRR0zb3qrAnyI6KlBFsGD0cT4pQM4l+
jDPnN+vKT+AOAiFRT+pthiMfBPLPX/gaejf03LLe8vCzSbENy+fhMB/HpEnk8NGh
OURY1xmDvo9lqXyv1QBrqbxxJwTEnA8co3osa6xO/yPpbY4zBhDEzt0SpmeBw2p4
kkCkTn+Rk0y4nfO9z05Brtn6IT9v3jT0Iwr2bRn8BT975AUnJvD1N53Mtcrfz7BA
w2hbZrZ0nXgvmDbx+ZGxGsnzLmVSjrC21FalZHXiOcbFOSEQcVhQLwHXPmPktXuz
v2oX+etkwZBexsiYoWKn9Co9PtjqgxI9BgfwvkQYxlfN4aGcxgX3JeRq1SCh4TsQ
chfCokuyxTZoe34/0jMH
=H/uY
-----END PGP SIGNATURE-----

--=-pC1yW8aMIMsOoA5fOc++--

