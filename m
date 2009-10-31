Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZJaKom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 06:44:42 -0400
Subject: Re: [PATCH 1/2] Allow scanning while in authenticated only state
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
In-Reply-To: <1256985196.3089.34.camel@maxim-laptop>
References: <1256939391.31271.11.camel@maxim-laptop>
	 <1256939549.31271.14.camel@maxim-laptop>
	 <1256967782.3555.69.camel@johannes.local>
	 <1256982381.3089.10.camel@maxim-laptop>
	 <1256983366.3555.119.camel@johannes.local>
	 <1256985196.3089.34.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LOkrQhal0AqHijP5Q1ZC"
Date: Sat, 31 Oct 2009 11:44:43 +0100
Message-ID: <1256985883.3555.124.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LOkrQhal0AqHijP5Q1ZC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 12:33 +0200, Maxim Levitsky wrote:

> > Now, especially since you say that this still runs into problems while
> > connecting to a new AP, I think that wpa_supplicant should
> > deauthenticate from the old AP. After all, it wants to eventually
> > control FT and anything we do in the kernel will come back and interfer=
e
> > with that.
> Exactly, at least for now.
>=20
> How about putting this in wpa_supplicant, and end all trouble with this
> for once?
>=20
> This is a workaround/hack, but at least it works....

I'm all for fixing the problem in wpa_supplicant, and it should be
plenty clear that I believe that except for the little auth-while-auth
thing, the bug _is_ in wpa_supplicant.

However, it's not my decision. I'll fix the auth-while-auth eventually,
but I believe it is not really the problem in your case.

johannes

> commit e57bfd6e760c32177ab74c462839dd20a92343b8
> Author: Maxim Levitsky <maximlevitsky@gmail.com>
> Date:   Sat Oct 31 12:05:35 2009 +0200
>=20
>     driver_nl80211: send deauth on disassoc
>=20
> diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
> index b3861f5..dfed87d 100644
> --- a/src/drivers/driver_nl80211.c
> +++ b/src/drivers/driver_nl80211.c
> @@ -2046,12 +2046,18 @@ static int wpa_driver_nl80211_deauthenticate(void=
 *priv, const u8 *addr,
>  static int wpa_driver_nl80211_disassociate(void *priv, const u8 *addr,
>                                            int reason_code)
>  {
> +       int err;
>         struct wpa_driver_nl80211_data *drv =3D priv;
>         if (!(drv->capa.flags & WPA_DRIVER_FLAGS_SME))
>                 return wpa_driver_nl80211_disconnect(drv, addr, reason_co=
de);
>         wpa_printf(MSG_DEBUG, "%s", __func__);
>         drv->associated =3D 0;
> -       return wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DISASSOCIAT=
E,
> +
> +       err =3D wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DISASSOCIA=
TE,
> +                                      reason_code);
> +       if (err)
> +               return err;
> +       return wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DEAUTHENTIC=
ATE,
>                                        reason_code);
>  }
> =20
>=20
>=20
>=20


--=-LOkrQhal0AqHijP5Q1ZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7BUXAAoJEODzc/N7+QmaN+EP/0koOGCWdbg7ZY0PfBgwUYHG
B9kGQN19NdJi1Wj/c3Q+wVxNOOeQcD+Cbo84j/R1d+cp91BnOWju4vVW21gVXWiH
NjlC5FQdQ6iWh0vc6s7HxzeqMQCvd5vYvYCdx9RXaRN+vTf1eUZljM845VVa8js7
zk5nbtdtprj5TG3CUTt72SLH//ImxAp7OgXcqSTrhdq5A8nzL+x0xQCwPxYjXw9n
Pm+rwJhF0Z1IZfIfh7/jY8D11LmsRmyV8svNwuOHgndVUBSSYxEbrfhV1w6CoM/w
ladoYNmBFrGpPstqzn2/z3++BtQsqxwXH7BU2c9yNI4gai6vt3MuOJXse6ItFXsD
890jIhLOyX0rtI1TMRTGlRIxU8Hq7/0ukb6MzgOpLG7DGpWQd9yRtgnxTWttiM4x
VIu2wyy/hPKrLuh9fqq+POmkmOR3RDx6Nh3rNzrXWMPjnV8VChzWdBTh1ydCuSAA
RqHYs8Ywdb5J/5b8j6p/gBK/ho1VPXHXdVyYoYu+uUTaXcUt6P+8mu4ihnJh0D4C
nhxoj3QG6clLD3mH38Wdlby0kw6F0NP2tBr6CejwmoBfxDXKPFT1AwKmTc2imKZD
Gb7kMCKfKPmy1aT3C9NMDTAcxDJ0s5e7bENidxXn0T6+RF3LoMLkgoKS2aQZuYwM
tnHeorepzL+iR3aowR8x
=Z0J6
-----END PGP SIGNATURE-----

--=-LOkrQhal0AqHijP5Q1ZC--

