Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZHRH2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 03:28:31 -0400
Subject: Re: [PATCH 09/29] mwl8k: remove usage of deprecated radio_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090818035220.GN18639@mail.wantstofly.org>
References: <20090818035220.GN18639@mail.wantstofly.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eqCR2/PXPQg/4lSdQFyL"
Date: Tue, 18 Aug 2009 09:28:29 +0200
Message-Id: <1250580509.30538.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eqCR2/PXPQg/4lSdQFyL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-18 at 05:52 +0200, Lennert Buytenhek wrote:
> Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
> ---
>  drivers/net/wireless/mwl8k.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index 9f54204..3a201a2 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -2935,7 +2935,7 @@ static int mwl8k_config_wt(struct work_struct *wt)
>  	struct mwl8k_priv *priv =3D hw->priv;
>  	int rc =3D 0;
> =20
> -	if (!conf->radio_enabled) {
> +	if (conf->flags & IEEE80211_CONF_IDLE) {
>  		mwl8k_cmd_802_11_radio_disable(hw);
>  		priv->current_channel =3D NULL;
>  		rc =3D 0;

So I think the return; a little below needs to be removed to allow doing
other things while the radio is off? I'm not sure which actually happen
but I never audited the code to make sure nothing happens.

johannes

--=-eqCR2/PXPQg/4lSdQFyL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKilgaAAoJEODzc/N7+Qma3bkQAMCVVANoNXBRoYNnSm8CZ5Wa
shXCMogRTlUIWCUIr7DrIPq8cZltyCAYgSdSSgh4Bgp0YZ7rZOY6Ahie+8zTtSxa
OqpELedARxaKFsocAWcf7N+Oxh3jZi+9qu3nlbMwKbqpw9fppIaKKW5hNtuwG1z0
dpztjGleasJiImLJriToqKLU7Hsg+lHSK1N4ofVODD3IyncHtKlA28HumFuHxl+C
pxH3eh2uYI1Pqz0h6zFLjDaanSm8aNJ3aI4pg1g5Eojepmuwmr1N/cks/qrMV3c5
qnP3RGYsxmdWTIu0gLKGMwLZcWKDISmny6ZOtJsTebCFWNfKVVv6EqUOJvs4DzcG
tDmT+trCVI7Kg8CD0ytNoQ8OIRL61vj47XMTgRgNOC237v8umvzK6JsN1OMWPPb1
/o6Az324gNIKPDVPLWgjsThxaXp5ZxyCJUVlnyszGuCT0nNcC6Y8KAbrgBqMNTAm
aeiiTxGBVEHymA7VF03YnsbDgvDpCDE5Wj20olZlGBGNOb5X6xAtDvkUYSkfyqC0
1ugZvoGoGCz4MGvU9AI047uT6E8XDMuEdwXPWC9syzZA9Pi/5oKIWy5vvOPuMG4f
yaLuBlK/ePXPT+RwvIo5LpmnSeSF6wfPk2IgMH6ynKdXuLnZyy7QPVmLfJdu+F4z
MGlIXNWJfY5TZ2WZoHzY
=Kd4O
-----END PGP SIGNATURE-----

--=-eqCR2/PXPQg/4lSdQFyL--

