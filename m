Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx71.mail.ru ([194.67.23.4]:49855 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYJaRhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 13:37:10 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: David Kilroy <kilroyd@googlemail.com>
Subject: Re: [RFC PATCH 1/2] orinoco: Use PM notifier to cache firmware for use during resume
Date: Fri, 31 Oct 2008 20:36:59 +0300
Cc: linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	linux-pm@lists.linux-foundation.org
References: <1225415743-28209-1-git-send-email-kilroyd@googlemail.com> <1225415743-28209-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1225415743-28209-2-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2431754.5yS4ccXzLp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810312037.00936.arvidjaar@mail.ru> (sfid-20081031_183716_939341_E867654A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2431754.5yS4ccXzLp
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 31 October 2008, David Kilroy wrote:
> When preparing for either suspend or hibernation, load the necessary
> firmware from userspace.
>=20
> Upon error or resume, release the firmware.
>=20
> Works for both Agere and Symbol firmware.
>=20
> Signed-off by: David Kilroy <kilroyd@gmail.com>

This is on top of my old patch; was it ever accepted anywhere? I guess
it should be rediffed against clean tree.

> @@ -621,7 +620,7 @@ symbol_dl_image(struct orinoco_private *priv, const s=
truct fw_info *fw,
>  	ret =3D hermes_init(hw);
> =20
>  	/* hermes_reset() should return 0 with the secondary firmware */
> -	if (secondary && ret !=3D 0)
> +	if (secondary && (ret !=3D 0))

Extra parenthesis are redundant, are not they?

>  /********************************************************************/
> +/* Power management                                                 */
> +/********************************************************************/
> +
> +static int orinoco_pm_notifier(struct notifier_block *notifier,
> +			       unsigned long pm_event,
> +			       void *unused)

It probably should be conditional on CONFIG_PM somehow?=20

> diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoc=
o.h
> index 8c29538..5a9685a 100644
> --- a/drivers/net/wireless/orinoco.h
> +++ b/drivers/net/wireless/orinoco.h
> @@ -10,6 +10,7 @@
>  #define DRIVER_VERSION "0.15"
> =20
>  #include <linux/interrupt.h>
> +#include <linux/suspend.h>
>  #include <linux/netdevice.h>
>  #include <linux/wireless.h>
>  #include <net/iw_handler.h>
> @@ -167,8 +168,11 @@ struct orinoco_private {
>  	unsigned int tkip_cm_active:1;
>  	unsigned int key_mgmt:3;
> =20
> -	/* Cached in memory firmware to use in ->resume */
> -	const struct firmware *cached_fw;
> +	/* Cached in memory firmware to use during ->resume. */
> +	const struct firmware *cached_pri_fw;
> +	const struct firmware *cached_sta_fw;

I think name is badly chosen. It could be both STA and AP firmware;
I know that AP is not implemented currently, but it does not mean
it will never be and firmware is there if required.

I will test it once I sort out issue with booting 2.6.28. Right now
it stopped booting completely.

--nextPart2431754.5yS4ccXzLp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkLQjwACgkQR6LMutpd94yYugCfRBBflnopNMNf53ZppoAGIdYn
FmAAn3nYMVAjWM4yEFVjiATg0jq92hh9
=cR9f
-----END PGP SIGNATURE-----

--nextPart2431754.5yS4ccXzLp--
