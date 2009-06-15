Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763239AbZFOPor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:44:47 -0400
Subject: Re: [PATCH 01/12][2.6.31 and w-t] iwmc3200wifi: fix sdio
 initialisation race
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
In-Reply-To: <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
	 <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dGu0UmeCuYG6olSsDsqB"
Date: Mon, 15 Jun 2009 17:44:07 +0200
Message-Id: <1245080647.23912.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dGu0UmeCuYG6olSsDsqB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-15 at 17:39 +0200, Samuel Ortiz wrote:
> From: Samuel Ortiz <samuel.ortiz@intel.com>
>=20
> When modprobing this driver, the netdev interface is ready before the SDI=
O
> function is correctly set.
> This can lead to userspace calling ndo_open() before the SDIO bus is read=
y.
> We fix that by returning an error from ndo_open() when the
> IWM_STATUS_BUS_READY bit is not set yet.

Can't you wait for it to be set instead?

johannes

> Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> ---
>  drivers/net/wireless/iwmc3200wifi/iwm.h    |   11 ++++++-----
>  drivers/net/wireless/iwmc3200wifi/main.c   |    6 +++++-
>  drivers/net/wireless/iwmc3200wifi/netdev.c |   10 ++++++----
>  drivers/net/wireless/iwmc3200wifi/sdio.c   |    4 ++++
>  4 files changed, 21 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wirele=
ss/iwmc3200wifi/iwm.h
> index 635c16e..3cc4e91 100644
> --- a/drivers/net/wireless/iwmc3200wifi/iwm.h
> +++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
> @@ -180,11 +180,12 @@ struct iwm_key {
> =20
>  #define IWM_SCAN_ID_MAX 0xff
> =20
> -#define IWM_STATUS_READY		0
> -#define IWM_STATUS_SCANNING		1
> -#define IWM_STATUS_SCAN_ABORTING	2
> -#define IWM_STATUS_ASSOCIATING		3
> -#define IWM_STATUS_ASSOCIATED		4
> +#define IWM_STATUS_BUS_READY		0
> +#define IWM_STATUS_READY		1
> +#define IWM_STATUS_SCANNING		2
> +#define IWM_STATUS_SCAN_ABORTING	3
> +#define IWM_STATUS_ASSOCIATING		4
> +#define IWM_STATUS_ASSOCIATED		5
> =20
>  #define IWM_RADIO_RFKILL_OFF		0
>  #define IWM_RADIO_RFKILL_HW		1
> diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wirel=
ess/iwmc3200wifi/main.c
> index 6a2640f..09ed247 100644
> --- a/drivers/net/wireless/iwmc3200wifi/main.c
> +++ b/drivers/net/wireless/iwmc3200wifi/main.c
> @@ -227,11 +227,15 @@ int iwm_priv_init(struct iwm_priv *iwm)
>  void iwm_reset(struct iwm_priv *iwm)
>  {
>  	struct iwm_notif *notif, *next;
> +	unsigned long status =3D 0;
> =20
>  	if (test_bit(IWM_STATUS_READY, &iwm->status))
>  		iwm_target_reset(iwm);
> =20
> -	iwm->status =3D 0;
> +	if (test_bit(IWM_STATUS_BUS_READY, &iwm->status))
> +		set_bit(IWM_STATUS_BUS_READY, &status);
> +
> +	iwm->status =3D status;
>  	iwm->scan_id =3D 1;
> =20
>  	list_for_each_entry_safe(notif, next, &iwm->pending_notif, pending) {
> diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wir=
eless/iwmc3200wifi/netdev.c
> index 68e2c3b..5b7aa34 100644
> --- a/drivers/net/wireless/iwmc3200wifi/netdev.c
> +++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
> @@ -54,9 +54,10 @@
>  static int iwm_open(struct net_device *ndev)
>  {
>  	struct iwm_priv *iwm =3D ndev_to_iwm(ndev);
> -	int ret =3D 0;
> +	int ret =3D -ENODEV;
> =20
> -	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio))
> +	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio)
> +	    && test_bit(IWM_STATUS_BUS_READY, &iwm->status))
>  		ret =3D iwm_up(iwm);
> =20
>  	return ret;
> @@ -65,9 +66,10 @@ static int iwm_open(struct net_device *ndev)
>  static int iwm_stop(struct net_device *ndev)
>  {
>  	struct iwm_priv *iwm =3D ndev_to_iwm(ndev);
> -	int ret =3D 0;
> +	int ret =3D -ENODEV;
> =20
> -	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio))
> +	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio)
> +	    && test_bit(IWM_STATUS_BUS_READY, &iwm->status))
>  		ret =3D iwm_down(iwm);
> =20
>  	return ret;
> diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wirel=
ess/iwmc3200wifi/sdio.c
> index b54da67..97e7da3 100644
> --- a/drivers/net/wireless/iwmc3200wifi/sdio.c
> +++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
> @@ -454,6 +454,9 @@ static int iwm_sdio_probe(struct sdio_func *func,
> =20
>  	INIT_WORK(&hw->isr_worker, iwm_sdio_isr_worker);
> =20
> +	/* The SDIO bus is set and ready to be enabled */
> +	set_bit(IWM_STATUS_BUS_READY, &iwm->status);
> +
>  	dev_info(dev, "IWM SDIO probe\n");
> =20
>  	return 0;
> @@ -476,6 +479,7 @@ static void iwm_sdio_remove(struct sdio_func *func)
>  	destroy_workqueue(hw->isr_wq);
> =20
>  	sdio_set_drvdata(func, NULL);
> +	clear_bit(IWM_STATUS_BUS_READY, &iwm->status);
> =20
>  	dev_info(dev, "IWM SDIO remove\n");
> =20

--=-dGu0UmeCuYG6olSsDsqB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKNmxCAAoJEODzc/N7+QmaFwkP/1tIx1MGRJ/nIWyuNhj+aajr
Ef+9y237tvvBfgwJQDxPcf5eJIu/uv9fNLPnbq7RCDpIgOajYuYZOqQRfEqu4AIV
M532/CGFCd47kMrErjWvCdPbRYVfitY3b6OQEBxV7gc0JJAp9jcYCBGXqptYeNey
oheT/3BOs+QiM03avyaMvIxAD3dHziUnGYf4Epxbpf4aeMjdtvAhYW8CQdzWxlVW
mCRXObjh1srtW32aPBBA/qKJOV11h1hwr/hO053VWDWwY+lRc80DcgJ97lSOKEP4
6xpQpi7rflJDSyvcNBTbaqXTCA0CHExY2mDkQQ99e8q1D9EyCm62nw0wLJtP8ZSD
a4j8xPQrkhK7OAK8ypLCBAHxljDPbGnIco0nHqmbLpvEuTBeKJit8VxjBxwUoYHD
PvT93Zp+Rnak88Aiv4g7lvHWaXgfvsqTduabXaAND5Wr0qMFJoYulAqbt2wTISL4
Az3aevqQ3auCEdd9NNtuDabDSXKBmQeNwinTgb7O4KJ+oti1ZnnpE3wzNQanpT6n
dunpjMlwO6Nw5+gQ7g/bvG7kMOc3IzAohK6y3OQS3j3sm1sXEMHFk+L2znqyjuB0
69YwomasOvKdAgWfuAt4IjtFCdg5G42kUf1PCS1fr8QOw15b0dIHVCn90t1dOp6R
mwzYuKINm5O28kaPe6R/
=x0EJ
-----END PGP SIGNATURE-----

--=-dGu0UmeCuYG6olSsDsqB--

