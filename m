Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbYKUOov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 09:44:51 -0500
Subject: Re: [PATCH] mac80211: Look out for some other AP when disassoc is
	received.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081122041306.GA4206@myhost.users.atheros.com> (sfid-20081121_153942_182132_3C8493BC)
References: <20081122041306.GA4206@myhost.users.atheros.com>
	 (sfid-20081121_153942_182132_3C8493BC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U80/psjGFTtrtxrc8cXn"
Date: Fri, 21 Nov 2008 15:44:40 +0100
Message-Id: <1227278680.3599.2.camel@johannes.berg> (sfid-20081121_154456_100306_F9D41401)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U80/psjGFTtrtxrc8cXn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-21 at 20:13 -0800, Vivek Natarajan wrote:
> When a disassoc packet is received with a reason code of
> 'AP leaving the BSS', mac80211 should start looking for some
> other AP instead of trying to associate with the same AP.

Can we edit this commit log message? mac80211 will not start looking for
another AP in DISABLED state. How about

When a disassoc packet is received from the AP with a reason code of
'leaving the BSS', mac80211 should go into DISABLED state just as it
would do if the AP suddenly went away for some reason, as that is what
will happen shortly after the AP leaves anyway.

(is that correct?)

Other than that,
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  net/mac80211/mlme.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 90ad5a4..ee15e75 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -808,6 +808,10 @@ static void ieee80211_authenticate(struct ieee80211_=
sub_if_data *sdata,
>  	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
>  }
> =20
> +/*
> + * The disassoc 'reason' argument can be either our own reason
> + * if self disconnected or a reason code from the AP.
> + */
>  static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>  				   struct ieee80211_if_sta *ifsta, bool deauth,
>  				   bool self_disconnected, u16 reason)
> @@ -854,7 +858,7 @@ static void ieee80211_set_disassoc(struct ieee80211_s=
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
> @@ -1175,7 +1179,7 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee8=
0211_sub_if_data *sdata,
>  				      IEEE80211_RETRY_AUTH_INTERVAL);
>  	}
> =20
> -	ieee80211_set_disassoc(sdata, ifsta, false, false, 0);
> +	ieee80211_set_disassoc(sdata, ifsta, false, false, reason_code);
>  }
> =20
>=20

--=-U80/psjGFTtrtxrc8cXn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJslUAAoJEKVg1VMiehFY+rsQAMFb/sVr7D5PiO1FlCP44LyK
w5/cOLxlyvrL9GwW0yS0zOesngKpEvFT+HzdUuoWJLYArUfOi0M2PFnCWKi4MDBT
VrAJ3gBvVkCons/c3DhczxQH4licCn/klS8ZIi96FAvIVAAs0/om9rSUXoJ8yioD
AGO+IldBs05TFRw0013qLGjxs/GkBek22R+VjsHkt4DunJqolv930NlW6VUiL6s9
Q23Pb4/1nHnJ+8o/oaqpGp1lmFQRif5bG0eb/yKEjL7X8/X2crynSngOeRK8cA54
qy0Klyy8VnzzBhCCRong4XzotPuOeqDVVpF4lHyfu+DDZ03S+Qzi6YtgkmgThQX5
Ln3mFXDg3QZP2Y8Bd6DlW3fzFZ2o+vhA+emrpXKl62lLhhAyXZQ4ShCeGndjN4k6
2NRRE2+cAZmYkCIU0q51N0p3CmkXe6wlgXH+qhP1E7IOmDj/KgErqS9odUZ3fqvu
UCuw8HbCOSPIvPa3CsKKVyCTE0rrRYaLwsMRqOfsV/7ZFEz0/c3rF/02VV/B2BjQ
QiXYzrcirxKyf+JgRQnwHuy8YdONziFP1Po8DHopbXWyquq4G+BfBcPEQgCZfqHr
fZoTMoUL/bFrItcinX2b6GMOovvdGRgYhadDj9yUCCuHrax3cIxrmIyISzZ6kLsj
HFQluDN5tWMUBz/Ajr0A
=bAj3
-----END PGP SIGNATURE-----

--=-U80/psjGFTtrtxrc8cXn--

