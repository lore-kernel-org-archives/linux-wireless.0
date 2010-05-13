Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from setoy.chost.de ([217.160.209.225]:53472 "EHLO smtp.chost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab0EMJ1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:27:09 -0400
Date: Thu, 13 May 2010 11:20:14 +0200
From: Sascha Silbe <sascha-ml-linux-kernel-libertas-dev@silbe.org>
To: Kiran Divekar <dkiran@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Subject: Re: [PATCH v2] Libertas: Added callback functions to support SDIO
	suspend/resume.
Message-ID: <20100513092013.GA22652@twin.sascha.silbe.org>
Reply-To: Sascha Silbe <sascha-ml-reply-to-2010-2@silbe.org>
References: <25B60CDC2F704E4E9D88FFD52780CB4C04D61E8CF1@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C04D61E8CF1@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 12, 2010 at 10:07:55PM -0700, Kiran Divekar wrote:

> In suspend() host sleep is activated using already configured
> host sleep parameters through wol command, and in resume() host
> sleep is cancelled. Earlier priv->fw_ready flag used to reset and
> set in suspend and resume handler respectively. Since after suspend
> only host goes into sleep state and firmware is always ready, those
> changes in flag state are removed.

This patch looks a lot like the one that broke suspend on XO-1. I see=20
you've made changes that affect this, but it doesn't seem to be actually=20
fixed; see my comment on if_usb_suspend() below.


> diff --git a/drivers/net/wireless/libertas/if_sdio.c=20
> b/drivers/net/wireless/libertas/if_sdio.c
> index 64dd345..6b1048b 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c

[if_sdio_suspend()]
> +	if (card->priv->wol_criteria =3D=3D 0xffffffff) {
For consistency, the literal value should be replaced with=20
EHS_REMOVE_WAKEUP.

> +		lbs_pr_info("Suspend without wake params -- "
> +						"powering down card.");
So with "ethtool eth0 d" an SDIO-connected libertas chip will get=20
powered down during suspend? OK.


> diff --git a/drivers/net/wireless/libertas/if_usb.c=20
> b/drivers/net/wireless/libertas/if_usb.c
> index fcea574..e7a483c 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c

[if_usb_suspend()]
> +	if (priv->wol_criteria =3D=3D 0xffffffff) {
Again, s/0xffffffff/EHS_REMOVE_WAKEUP/.

> +		lbs_pr_info("Suspend attempt without "
> +						"configuring wake params!\n");
> +		return -ENOSYS;
> +	}
AFAICT this would cause a USB-connected libertas chip with WOL disabled=20
("ethtool eth0 d") to prevent suspend, instead of just powering down=20
like an SDIO-connected chip. So instead of failing during=20
lbs_host_sleep_cfg() because the 8388 doesn't support EHS_REMOVE_WAKEUP,=20
you just bail out earlier, still breaking suspend.


> diff --git a/drivers/net/wireless/libertas/main.c=20
> b/drivers/net/wireless/libertas/main.c
> index d35ebca..dcbff80 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c

[lbs_resume()]
> +	priv->wol_criteria |=3D EHS_REMOVE_WAKEUP;
This resets an ethtool-set WOL policy on each resume, requiring user=20
space to call ethtool before every suspend (not just once during=20
startup). I still don't understand why we do that (I'd expect anything=20
set by user space to be active until re-set by user space), but I've=20
been told it has been this way before (i.e. your patch doesn't change=20
the behaviour).


CU Sascha

--=20
http://sascha.silbe.org/
http://www.infra-silbe.de/
--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCgAGBQJL68RNAAoJELpz82VMF3DaCikH/Au5rRSogmiOYjlLJtzlQdIy
ElhvNNSqUCgQtmw72HS/nqRJFxV52VxEXq9j0JtH5nX8h5VuV6RMKs7Y1lsM5t9k
Ywr83aT3PXeUvvk2l0xD8X7wL/Vll+I2boWYls+Bom1ITZyuRBsFkkloXRDmbab/
uatX40NIKDNlGNoEGOe1zlGidfeOIOkloJro7KdG9HVI3l7oxOVS61EmTStZPvTN
gBCmyDk7sO7gw7kZ8tkh+55JtB/uAZZk8rlELbN0u9ViCfK3c1H5hG32SQgZmr1r
hQPwe64eFBrl8AJecF8DTmFkxNpwazcPMWY3RN0kcDoRwkzR/u7lECfvt7CTzBI=
=3faf
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
