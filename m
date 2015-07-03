Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59563 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbbGCEHg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 00:07:36 -0400
Message-ID: <55960A81.1040200@rempel-privat.de> (sfid-20150703_060742_398191_C38BC074)
Date: Fri, 03 Jul 2015 06:07:29 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k_htc: introduce support for different fw versions
References: <CAGRGNgUWJ-LDgdxe1TJw2YOroMKaYDj3ehUu7j_zoqX17BxbjQ@mail.gmail.com> <1434394689-18781-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1434394689-18781-1-git-send-email-linux@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WIMikGv34wSPwsJcNrnblgqx7oJeCFLrI"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WIMikGv34wSPwsJcNrnblgqx7oJeCFLrI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Any updates here?

Am 15.06.2015 um 20:58 schrieb Oleksij Rempel:
> Current kernel support only one fw name with theoretically only one
> fw version. By replacing fw with other version we will break compatibil=
ity
> with older kernels.
>=20
> To avoid this kind of regression this patch will reuse fw version model=

> from iwlwifi driver.
>=20
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c      | 106 ++++++++++++++++++=
++------
>  drivers/net/wireless/ath/ath9k/hif_usb.h      |  21 ++++-
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |   4 +
>  3 files changed, 105 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wir=
eless/ath/ath9k/hif_usb.c
> index 10c02f5..165dd20 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -17,12 +17,8 @@
>  #include <asm/unaligned.h>
>  #include "htc.h"
> =20
> -/* identify firmware images */
> -#define FIRMWARE_AR7010_1_1     "htc_7010.fw"
> -#define FIRMWARE_AR9271         "htc_9271.fw"
> -
> -MODULE_FIRMWARE(FIRMWARE_AR7010_1_1);
> -MODULE_FIRMWARE(FIRMWARE_AR9271);
> +MODULE_FIRMWARE(HTC_7010_MODULE_FW);
> +MODULE_FIRMWARE(HTC_9271_MODULE_FW);
> =20
>  static struct usb_device_id ath9k_hif_usb_ids[] =3D {
>  	{ USB_DEVICE(0x0cf3, 0x9271) }, /* Atheros */
> @@ -1080,12 +1076,88 @@ static void ath9k_hif_usb_firmware_fail(struct =
hif_device_usb *hif_dev)
>  		device_unlock(parent);
>  }
> =20
> +static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void =
*context);
> +
> +/* taken from iwlwifi */
> +static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
> +				      bool first)
> +{
> +	char index[8], *chip;
> +	int ret;
> +
> +	if (first) {
> +		if (htc_use_dev_fw) {
> +			hif_dev->fw_minor_index =3D FIRMWARE_MINOR_IDX_MAX + 1;
> +			sprintf(index, "%s", "dev");
> +		} else {
> +			hif_dev->fw_minor_index =3D FIRMWARE_MINOR_IDX_MAX;
> +			sprintf(index, "%d", hif_dev->fw_minor_index);
> +		}
> +	} else {
> +		hif_dev->fw_minor_index--;
> +		sprintf(index, "%d", hif_dev->fw_minor_index);
> +	}
> +
> +	/* test for FW 1.3 */
> +	if (MAJOR_VERSION_REQ =3D=3D 1 && hif_dev->fw_minor_index =3D=3D 3) {=

> +		const char *filename;
> +
> +		if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
> +			filename =3D FIRMWARE_AR7010_1_1;
> +		else
> +			filename =3D FIRMWARE_AR9271;
> +
> +		/* expected fw locations:
> +		 * - htc_9271.fw   (stable version 1.3, depricated)
> +		 */
> +		snprintf(hif_dev->fw_name, sizeof(hif_dev->fw_name),
> +			 "%s", filename);
> +
> +	} else if (hif_dev->fw_minor_index < FIRMWARE_MINOR_IDX_MIN) {
> +		dev_err(&hif_dev->udev->dev, "no suitable firmware found!\n");
> +
> +		return -ENOENT;
> +	} else {
> +		if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
> +			chip =3D "7010";
> +		else
> +			chip =3D "9271";
> +
> +		/* expected fw locations:
> +		 * - ath9k_htc/htc_9271-1.dev.0.fw (development version)
> +		 * - ath9k_htc/htc_9271-1.4.0.fw   (stable version)
> +		 */
> +		snprintf(hif_dev->fw_name, sizeof(hif_dev->fw_name),
> +			 "%s/htc_%s-%d.%s.0.fw", HTC_FW_PATH,
> +			 chip, MAJOR_VERSION_REQ, index);
> +	}
> +
> +	ret =3D request_firmware_nowait(THIS_MODULE, true, hif_dev->fw_name,
> +				      &hif_dev->udev->dev, GFP_KERNEL,
> +				      hif_dev, ath9k_hif_usb_firmware_cb);
> +	if (ret) {
> +		dev_err(&hif_dev->udev->dev,
> +			"ath9k_htc: Async request for firmware %s failed\n",
> +			hif_dev->fw_name);
> +		return ret;
> +	}
> +
> +	dev_info(&hif_dev->udev->dev, "ath9k_htc: Firmware %s requested\n",
> +		 hif_dev->fw_name);
> +
> +	return ret;
> +}
> +
>  static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void =
*context)
>  {
>  	struct hif_device_usb *hif_dev =3D context;
>  	int ret;
> =20
>  	if (!fw) {
> +		ret =3D ath9k_hif_request_firmware(hif_dev, false);
> +		if (!ret)
> +			return;
> +
>  		dev_err(&hif_dev->udev->dev,
>  			"ath9k_htc: Failed to get firmware %s\n",
>  			hif_dev->fw_name);
> @@ -1215,27 +1287,11 @@ static int ath9k_hif_usb_probe(struct usb_inter=
face *interface,
> =20
>  	init_completion(&hif_dev->fw_done);
> =20
> -	/* Find out which firmware to load */
> -
> -	if (IS_AR7010_DEVICE(id->driver_info))
> -		hif_dev->fw_name =3D FIRMWARE_AR7010_1_1;
> -	else
> -		hif_dev->fw_name =3D FIRMWARE_AR9271;
> -
> -	ret =3D request_firmware_nowait(THIS_MODULE, true, hif_dev->fw_name,
> -				      &hif_dev->udev->dev, GFP_KERNEL,
> -				      hif_dev, ath9k_hif_usb_firmware_cb);
> -	if (ret) {
> -		dev_err(&hif_dev->udev->dev,
> -			"ath9k_htc: Async request for firmware %s failed\n",
> -			hif_dev->fw_name);
> +	ret =3D ath9k_hif_request_firmware(hif_dev, true);
> +	if (ret)
>  		goto err_fw_req;
> -	}
> =20
> -	dev_info(&hif_dev->udev->dev, "ath9k_htc: Firmware %s requested\n",
> -		 hif_dev->fw_name);
> -
> -	return 0;
> +	return ret;
> =20
>  err_fw_req:
>  	usb_set_intfdata(interface, NULL);
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wir=
eless/ath/ath9k/hif_usb.h
> index 51496e7..7c2ef7e 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.h
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
> @@ -17,8 +17,26 @@
>  #ifndef HTC_USB_H
>  #define HTC_USB_H
> =20
> +/* old firmware images */
> +#define FIRMWARE_AR7010_1_1     "htc_7010.fw"
> +#define FIRMWARE_AR9271         "htc_9271.fw"
> +
> +/* supported Major FW version */
>  #define MAJOR_VERSION_REQ 1
>  #define MINOR_VERSION_REQ 3
> +/* minimal and maximal supported Minor FW version. */
> +#define FIRMWARE_MINOR_IDX_MAX  4
> +#define FIRMWARE_MINOR_IDX_MIN  3
> +#define HTC_FW_PATH	"ath9k_htc"
> +
> +#define HTC_9271_MODULE_FW  HTC_FW_PATH "/htc_9271-" \
> +			__stringify(MAJOR_VERSION_REQ) \
> +			"." __stringify(FIRMWARE_MINOR_IDX_MAX) ".0.fw"
> +#define HTC_7010_MODULE_FW  HTC_FW_PATH "/htc_7010-" \
> +			__stringify(MAJOR_VERSION_REQ) \
> +			"." __stringify(FIRMWARE_MINOR_IDX_MAX) ".0.fw"
> +
> +extern int htc_use_dev_fw;
> =20
>  #define IS_AR7010_DEVICE(_v) (((_v) =3D=3D AR9280_USB) || ((_v) =3D=3D=
 AR9287_USB))
> =20
> @@ -101,7 +119,8 @@ struct hif_device_usb {
>  	struct usb_anchor reg_in_submitted;
>  	struct usb_anchor mgmt_submitted;
>  	struct sk_buff *remain_skb;
> -	const char *fw_name;
> +	char fw_name[32];
> +	int fw_minor_index;
>  	int rx_remain_len;
>  	int rx_pkt_len;
>  	int rx_transfer_len;
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/ne=
t/wireless/ath/ath9k/htc_drv_init.c
> index 7468562..57ca9b6 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -38,6 +38,10 @@ static int ath9k_ps_enable;
>  module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>  MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
> =20
> +int htc_use_dev_fw =3D 0;
> +module_param_named(use_dev_fw, htc_use_dev_fw, int, 0444);
> +MODULE_PARM_DESC(use_dev_fw, "Use development FW version");
> +
>  #ifdef CONFIG_MAC80211_LEDS
>  int ath9k_htc_led_blink =3D 1;
>  module_param_named(blink, ath9k_htc_led_blink, int, 0444);
>=20


--=20
Regards,
Oleksij


--WIMikGv34wSPwsJcNrnblgqx7oJeCFLrI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlWWCoIACgkQHwImuRkmbWlEnQEAiVF4RsbYlXjCF5IIbQb66Yo0
f+kbUP9ccVhReQ0UtVsA/inZdflWkOkMxoMkZN7bf0VFF/nKR7sO+JMSVecNgJ/c
=Ag53
-----END PGP SIGNATURE-----

--WIMikGv34wSPwsJcNrnblgqx7oJeCFLrI--
