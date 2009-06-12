Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbZFLUtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:49:18 -0400
Subject: Re: [PATCH] cfg80211: pass netdev to change_virtual_intf
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <samuel@sortiz.org>
In-Reply-To: <4A280237.2040807@gmail.com>
References: <1244574283.18481.29.camel@johannes.local>
	 <4A280237.2040807@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2yxWlXsnXn0ahr7+WzTB"
Date: Fri, 12 Jun 2009 22:50:04 +0200
Message-Id: <1244839804.12675.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2yxWlXsnXn0ahr7+WzTB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-04 at 18:19 +0100, Dave wrote:
> Johannes Berg wrote:
> > If there was a reason I'm passing the ifidx I cannot
> > remember it any more and don't see one now, so let's
> > just pass the pointer itself.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> >  drivers/net/wireless/iwmc3200wifi/cfg80211.c |    9 ++-------
> >  include/net/cfg80211.h                       |    3 ++-
> >  net/mac80211/cfg.c                           |    9 ++-------
> >  net/wireless/nl80211.c                       |   12 +++++-------
> >  net/wireless/wext-compat.c                   |    2 +-
> >  5 files changed, 12 insertions(+), 23 deletions(-)
>=20
> rndis_wlan.c will need an update for this as well

Sorry! I totally missed that. Thanks for the patch, John can you roll
that in and properly credit Dave for it?

johannes

>=20
> Dave.
> ---
> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rnd=
is_wlan.c
> index c254fdf..230962e 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -420,7 +420,8 @@ struct rndis_wext_private {
>  /*
>   * cfg80211 ops
>   */
> -static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
> +static int rndis_change_virtual_intf(struct wiphy *wiphy,
> +                                       struct net_device *dev,
>                                         enum nl80211_iftype type, u32 *fl=
ags,
>                                         struct vif_params *params);
>=20
> @@ -1222,20 +1223,14 @@ static void set_multicast_list(struct usbnet *usb=
dev)
>  /*
>   * cfg80211 ops
>   */
> -static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
> +static int rndis_change_virtual_intf(struct wiphy *wiphy,
> +                                       struct net_device *dev,
>                                         enum nl80211_iftype type, u32 *fl=
ags,
>                                         struct vif_params *params)
>  {
> -       struct net_device *dev;
> -       struct usbnet *usbdev;
> +       struct usbnet *usbdev =3D netdev_priv(dev);
>         int mode;
>=20
> -       /* we're under RTNL */
> -       dev =3D __dev_get_by_index(&init_net, ifindex);
> -       if (!dev)
> -               return -ENODEV;
> -       usbdev =3D netdev_priv(dev);
> -
>         switch (type) {
>         case NL80211_IFTYPE_ADHOC:
>                 mode =3D ndis_80211_infra_adhoc;
>=20
>=20
>=20
>=20

--=-2yxWlXsnXn0ahr7+WzTB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMr94AAoJEODzc/N7+Qma7x0P/0F2CZ3baskbunpORRHlv2K5
eXIRdBWxEXfA1TeCzhhEpRcqVQ+VsDAfnhws0Z+ozHlKU4oengbdkeNiO3jONxep
XIMVstI/wW4peO9ZwRmZ8MwKzQDc83Q+kFwBKc3Jio9yheuJpPVUwnTHZRcq8Upu
wd4yboDEyWwsKjiYJk/kcrYAKq4vZTVNG67r3orHsrAkLsbMkVlY3CFyhfwecc4e
GtVHcBMJSrxvfAe+Vy4nN1SiDOTx0kiG5R+NflSeiUIp42OPqEwrKS4/9jjSznYD
S0IsHFQnJtaRiTCLsCBy9xxW+bZG4gh3VTJDjtPebXQEp6UAtd/0zDOZ76Ts4ACS
6xcMSrR8ZV7L/pnVXp0dTJPESyxHzCWq5xMc/KuN8uEtSlgUY3hR/BG9ubWHatz1
Z3DeXnu44qG+byud58Zhnh1A1HEQA7JxuwVFH84ZPe5pVQ9+ErLzRa8+CGwh/Bv5
+3h3WUi5KrsHoiRzfptEVVyak3Rg8alupHjGL+KPRVt2dVQ7TwMhOwZium1d/zio
9gzTa1VBQbNu61LxEttQ2RSpphmZaRwDgtnz7TyK6CCiTLdFCV5FNWkHaV/6EUQJ
1kLDJcwsYkYfhfCQsVuQZVVlQeBX/8eBtifWu4OTsm1shuatJbTIsWtoILMUdlUN
ATzUDrwhCU1QY+qpO9QH
=XTDZ
-----END PGP SIGNATURE-----

--=-2yxWlXsnXn0ahr7+WzTB--

