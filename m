Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54015 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932357AbcK1Pet (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 10:34:49 -0500
Subject: Re: [PATCH] ath9k_htc: don't use HZ for usb msg timeouts
To: Anthony Romano <anthony.romano@coreos.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
References: <20161128042757.8609-1-anthony.romano@coreos.com>
Cc: ath9k-devel@qca.qualcomm.com
From: Oleksij Rempel <fishor@gmx.net>
Message-ID: <a433d14f-d762-fc53-ba7a-da616ac670ca@gmx.net> (sfid-20161128_163452_297441_E68ACCC7)
Date: Mon, 28 Nov 2016 16:34:12 +0100
MIME-Version: 1.0
In-Reply-To: <20161128042757.8609-1-anthony.romano@coreos.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eM5331eh3RXhAmt7bTKdMxgcRjlcEr8Bg"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eM5331eh3RXhAmt7bTKdMxgcRjlcEr8Bg
Content-Type: multipart/mixed; boundary="p5DJlNFb5fsbv0OouQBMtH2HMEe8QtS9u";
 protected-headers="v1"
From: Oleksij Rempel <fishor@gmx.net>
To: Anthony Romano <anthony.romano@coreos.com>,
 linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: ath9k-devel@qca.qualcomm.com
Message-ID: <a433d14f-d762-fc53-ba7a-da616ac670ca@gmx.net>
Subject: Re: [PATCH] ath9k_htc: don't use HZ for usb msg timeouts
References: <20161128042757.8609-1-anthony.romano@coreos.com>
In-Reply-To: <20161128042757.8609-1-anthony.romano@coreos.com>

--p5DJlNFb5fsbv0OouQBMtH2HMEe8QtS9u
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Anthony,

Am 28.11.2016 um 05:27 schrieb Anthony Romano:
> The usb_*_msg() functions expect a timeout in msecs but are given HZ,
> which is ticks per second. If HZ=3D100, firmware download often times o=
ut
> when there is modest USB utilization and the device fails to initialize=
=2E

> Replaces HZ in usb_*_msg timeouts with 1000 msec since HZ is one second=

> for timeouts in jiffies.

wow..
This fix allow you use 4 adapter at same time?

> Signed-off-by: Anthony Romano <anthony.romano@coreos.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 9 +++++----
>  drivers/net/wireless/ath/ath9k/hif_usb.h | 2 ++
>  2 files changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wir=
eless/ath/ath9k/hif_usb.c
> index e1c338cb9cb5..de2d212f39ec 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -997,7 +997,8 @@ static int ath9k_hif_usb_download_fw(struct hif_dev=
ice_usb *hif_dev)
>  		err =3D usb_control_msg(hif_dev->udev,
>  				      usb_sndctrlpipe(hif_dev->udev, 0),
>  				      FIRMWARE_DOWNLOAD, 0x40 | USB_DIR_OUT,
> -				      addr >> 8, 0, buf, transfer, HZ);
> +				      addr >> 8, 0, buf, transfer,
> +				      USB_MSG_TIMEOUT);
>  		if (err < 0) {
>  			kfree(buf);
>  			return err;
> @@ -1020,7 +1021,7 @@ static int ath9k_hif_usb_download_fw(struct hif_d=
evice_usb *hif_dev)
>  	err =3D usb_control_msg(hif_dev->udev, usb_sndctrlpipe(hif_dev->udev,=
 0),
>  			      FIRMWARE_DOWNLOAD_COMP,
>  			      0x40 | USB_DIR_OUT,
> -			      firm_offset >> 8, 0, NULL, 0, HZ);
> +			      firm_offset >> 8, 0, NULL, 0, USB_MSG_TIMEOUT);
>  	if (err)
>  		return -EIO;
> =20
> @@ -1249,7 +1250,7 @@ static int send_eject_command(struct usb_interfac=
e *interface)
> =20
>  	dev_info(&udev->dev, "Ejecting storage device...\n");
>  	r =3D usb_bulk_msg(udev, usb_sndbulkpipe(udev, bulk_out_ep),
> -		cmd, 31, NULL, 2000);
> +		cmd, 31, NULL, 2 * USB_MSG_TIMEOUT);
>  	kfree(cmd);
>  	if (r)
>  		return r;
> @@ -1314,7 +1315,7 @@ static void ath9k_hif_usb_reboot(struct usb_devic=
e *udev)
>  		return;
> =20
>  	ret =3D usb_interrupt_msg(udev, usb_sndintpipe(udev, USB_REG_OUT_PIPE=
),
> -			   buf, 4, NULL, HZ);
> +			   buf, 4, NULL, USB_MSG_TIMEOUT);
>  	if (ret)
>  		dev_err(&udev->dev, "ath9k_htc: USB reboot failed\n");
> =20
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wir=
eless/ath/ath9k/hif_usb.h
> index 7c2ef7ecd98b..7846916aa01d 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.h
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
> @@ -71,6 +71,8 @@ extern int htc_use_dev_fw;
>  #define USB_REG_IN_PIPE   3
>  #define USB_REG_OUT_PIPE  4
> =20
> +#define USB_MSG_TIMEOUT 1000 /* (ms) */
> +
>  #define HIF_USB_MAX_RXPIPES 2
>  #define HIF_USB_MAX_TXPIPES 4
> =20
>=20



--p5DJlNFb5fsbv0OouQBMtH2HMEe8QtS9u--

--eM5331eh3RXhAmt7bTKdMxgcRjlcEr8Bg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlg8ToAACgkQHwImuRkmbWmkeAD+Mauaa8rhKiOkRminztr+707G
euAhjuxQssyRhHPML8IA/1KHM6N/q9i5lHvotdw70X42i3TcstRkMCL4E0VrbLpI
=CQYd
-----END PGP SIGNATURE-----

--eM5331eh3RXhAmt7bTKdMxgcRjlcEr8Bg--
