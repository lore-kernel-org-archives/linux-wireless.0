Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:60719 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdJLGwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 02:52:16 -0400
Subject: Re: Atheros TL-721N adapter refuses to enumerate on the USB Bus
 (ath9k_htc)
To: M D <dsmm4444@gmail.com>, linux-wireless@vger.kernel.org
References: <CACUY3ep1s4OVZ-Fw3G4+aNjOxmLi1Rf+Zpnm__7c80KVPvr3fQ@mail.gmail.com>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <9b69844d-6f83-c29b-5c4d-aef5220ff847@rempel-privat.de> (sfid-20171012_085222_338374_A4E51632)
Date: Thu, 12 Oct 2017 08:52:08 +0200
MIME-Version: 1.0
In-Reply-To: <CACUY3ep1s4OVZ-Fw3G4+aNjOxmLi1Rf+Zpnm__7c80KVPvr3fQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VIpE6FH14UQcqqFGgMT5ppoKAt8A3MOH7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VIpE6FH14UQcqqFGgMT5ppoKAt8A3MOH7
Content-Type: multipart/mixed; boundary="arMih8O147SUAxEmDpFOHBW2EH9W7v1Iu";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: M D <dsmm4444@gmail.com>, linux-wireless@vger.kernel.org
Message-ID: <9b69844d-6f83-c29b-5c4d-aef5220ff847@rempel-privat.de>
Subject: Re: Atheros TL-721N adapter refuses to enumerate on the USB Bus
 (ath9k_htc)
References: <CACUY3ep1s4OVZ-Fw3G4+aNjOxmLi1Rf+Zpnm__7c80KVPvr3fQ@mail.gmail.com>
In-Reply-To: <CACUY3ep1s4OVZ-Fw3G4+aNjOxmLi1Rf+Zpnm__7c80KVPvr3fQ@mail.gmail.com>

--arMih8O147SUAxEmDpFOHBW2EH9W7v1Iu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 11.10.2017 um 20:17 schrieb M D:
> Hi,
> My system details are as follows
>=20
> Hardware:
> CPU                      :              ARM based platform, imx21
> USB                       :             USB Host Controller 1.1 Full Sp=
eed Mode
>=20
> Software:
> Firmware              :              /lib/firmware/htc_9271.fw
> (version 1.3 / version 1.4)
> Device Driver       :              Backports (v3.12.8-1)
> OS                        :              Linux Kernel 3.0.101, ARM
> Freescale IMX21ADS

Heh... I doubt this configuration can be more exotic :D

> Problem Statement:
>=20
> -        The WiFi adapter is connected directly to the USB Port and is
> configured in Full Speed mode
> -        After it is plugged in, it is enumerated on the Bus (that is,
> executing the instruction lsusb shows the vendor and product
> information)
> -        After repeated reboots, after one random reboot the issue
> occurs. (usually 1 out of 5 times) the wlan0 node does not come up
> -        When the issue occurs the following details below describe
> the issue at best
>=20
>=20
> 1)  The adapter is visible on the USB bus (adapter gets enumerated)
> 2)  The required modules are loaded
> 3)  However the wireless networking node, wlan0 does not come up
> 4)  One of the threads created during the init goes into a D state
>=20
> root       1024  0.0  0.0      0     0 ?        D    11:06   0:00
> [firmware/htc_92]
>=20
> In the file drivers/net/wireless/ath/ath9k/hif_usb.c
> [
>=20
> hif_usb.c
> ...
>=20
> ret =3D request_firmware_nowait(THIS_MODULE, true, hif_dev->fw_name,
>       &hif_dev->udev->dev, GFP_KERNEL,
>       hif_dev, ath9k_hif_usb_firmware_cb);
>=20
>=20
> compat_firmware_class.c
> ...
> task =3D kthread_run(request_firmware_work_func, fw_work,
>     "firmware/%s", name);
> ]
>=20
>=20
> 5) This is recoverable only after manually unplugging out the Adapter.
>=20
> ROOT CAUSE OF THE ISSUE:
> 6) The underlying cause is due to the wifi adapter being configured in
> FULL SPEED mode. Due to this the endpoints 3 and 4 get configured as
> BULK and not INT.
>=20
>=20
> After some investigation, I made the following changes which helps to
> recover the adapter when the issue occurs,
>=20
> --- ../original-backports/backports-3.12.8-1/drivers/net/wireless/ath/a=
th9k/hif_usb.c
>   2017-10-11 10:50:05.043241000 -0700
> +++ drivers/net/wireless/ath/ath9k/hif_usb.c    2017-10-11
> 10:50:03.154255000 -0700
> @@ -24,6 +24,8 @@
>  MODULE_FIRMWARE(FIRMWARE_AR7010_1_1);
>  MODULE_FIRMWARE(FIRMWARE_AR9271);
>=20
> +static void ath9k_hif_usb_reboot(struct usb_device *udev);
> +
>=20
> @@ -1189,7 +1193,12 @@
>  {
>         struct usb_device *udev =3D interface_to_usbdev(interface);
>         struct hif_device_usb *hif_dev;
> -       int ret =3D 0;
> +
> +        struct usb_host_interface *alt ;
> +        struct usb_endpoint_descriptor *endp;
> +
> +       int ret;
> +       int idx, EP =3D 0;
>=20
>         if (id->driver_info =3D=3D STORAGE_DEVICE)
>                 return send_eject_command(interface);
> @@ -1212,6 +1221,44 @@
>=20
>         init_completion(&hif_dev->fw_done);
>=20
> +       alt =3D &hif_dev->interface->altsetting[0];
> +
> +
> +       for (idx =3D 0; idx < alt->desc.bNumEndpoints; idx++) {
> +                endp =3D &alt->endpoint[idx].desc;
> +                EP =3D idx + 1;
> +                printk (KERN_ALERT "EndPoint %d is conf as %d\n", EP,
> (endp->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK));
> +               /* First FIX EP3. EP3 should never show up as BULK.
> +                  If it does we have a serious problem.
> +               */
> +
> +               if (endp->bEndpointAddress=3D=3D0x83){
> +                  if ((endp->bmAttributes &
> USB_ENDPOINT_XFERTYPE_MASK) =3D=3D USB_ENDPOINT_XFER_BULK) {
> +                       endp->bmAttributes |=3D USB_ENDPOINT_XFER_INT;
> +                       endp->bInterval =3D 1;
> +                       ath9k_hif_usb_reboot(hif_dev->udev);
> +                       mdelay(1000);
> +                       ret =3D usb_reset_device(hif_dev->udev);
> +                       mdelay(1000);
> +                        if (ret)
> +                           return ret;
> +                   }
> +               }
> +
> +                if (endp->bEndpointAddress=3D=3D0x04){
> +                   if ((endp->bmAttributes &
> USB_ENDPOINT_XFERTYPE_MASK) =3D=3D USB_ENDPOINT_XFER_BULK) {
> +                        endp->bmAttributes |=3D USB_ENDPOINT_XFER_INT;=

> +                        endp->bInterval =3D 1;
> +                       ath9k_hif_usb_reboot(hif_dev->udev);
> +                       mdelay(1000);
> +                       ret =3D usb_reset_device(hif_dev->udev);
> +                       mdelay(1000);
> +                       if (ret)
> +                               return ret;
> +                  }
> +               }
> +       }
> +
>         /* Find out which firmware to load */
>=20
>         if (IS_AR7010_DEVICE(id->driver_info))
>=20
>=20
>=20
> I see the following output in dmesg
>=20
> EndPoint 1 is conf as 2
> EndPoint 2 is conf as 2
> EndPoint 3 is conf as 2
> usb 1-2: reset full speed USB device number 2 using imx21-hcd
> usb 1-2: device firmware changed
> usb 1-2: USB disconnect, device number 2
> usbcore: registered new interface driver ath9k_htc
> usb 1-2: new full speed USB device number 3 using imx21-hcd
> EndPoint 1 is conf as 2
> EndPoint 2 is conf as 2
> EndPoint 3 is conf as 3
> EndPoint 4 is conf as 2
> usb 1-2: reset full speed USB device number 3 using imx21-hcd
> EndPoint 5 is conf as 2
> EndPoint 6 is conf as 2
> usb 1-2: ath9k_htc: Firmware htc_9271.fw requested
> usb 1-2: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
> ath9k_htc 1-2:1.0: ath9k_htc: HTC initialized with 33 credits
> ath9k_htc 1-2:1.0: ath9k_htc: FW Version: 1.3
> Completed ath9k_init_firmware_version
> ath: EEPROM regdomain: 0x809c
> ath: EEPROM indicates we should expect a country code
> ath: doing EEPROM country->regdmn map search
> ath: country maps to regdmn code: 0x52
> ath: Country alpha2 being used: CN
> ath: Regpair used: 0x52
> ath9k_hw_set_reset_reg: 1
> ieee80211 phy0: Atheros AR9271 Rev:1
> Registered led device: ath9k_htc-phy0
>=20
> These code changes help to reconfigure the WiFi adapter many times.
> However at some point of reboot (say 30th reboot), I see
>=20
> usb 1-2: device descriptor read/64, error -110
> hub 1-0:1.0: unable to enumerate USB device on port 2
>=20
> When this happens, the only way to recover is to manually unplug the
> adapter from the USB port.
>=20
> Could anyone offer any suggestions as to how to overcome this problem?
> The issue occurs with both v1.3 and v1.4 htc_9271.fw.

I fear, you should debuge it:
- attach uart on TL-721N to get some debug information from firmware
- use usb analizer to see what is going on with usb traffic.

--=20
Regards,
Oleksij


--arMih8O147SUAxEmDpFOHBW2EH9W7v1Iu--

--VIpE6FH14UQcqqFGgMT5ppoKAt8A3MOH7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF4EAREIAAYFAlnfERgACgkQHwImuRkmbWki+gD+PrZawns4SEnNmy0ORNsn209O
dart4j0U52NOm4tuZ0gA/im54ohJKYJZrv1uC55jS8x6qVKtrTfHLac1tycz052D
=cnC4
-----END PGP SIGNATURE-----

--VIpE6FH14UQcqqFGgMT5ppoKAt8A3MOH7--
