Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58383 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbaGGPJR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 11:09:17 -0400
Message-ID: <53BAB7F7.3060705@rempel-privat.de> (sfid-20140707_170927_934506_84885CFB)
Date: Mon, 07 Jul 2014 17:08:39 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Anders Darander <anders.darander@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: ath9k -> bogus usb xfer on at91
References: <Pine.LNX.4.44L0.1407041225290.6607-100000@netrider.rowland.org>	<53B6DC5F.3090304@rempel-privat.de> <CAE4k238pWc4nB1S1S7OJBVh-_bUnO+D6uQJ98wMTk-E7FZ4+yw@mail.gmail.com>
In-Reply-To: <CAE4k238pWc4nB1S1S7OJBVh-_bUnO+D6uQJ98wMTk-E7FZ4+yw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="titRmsLWf68lFFGP6Ckp7lwPfj6p7xqNR"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--titRmsLWf68lFFGP6Ckp7lwPfj6p7xqNR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 07.07.2014 15:40, schrieb Anders Darander:
> On 4 July 2014 18:54, Oleksij Rempel <linux@rempel-privat.de> wrote:
>> Am 04.07.2014 18:30, schrieb Alan Stern:
>>> On Fri, 4 Jul 2014, Anders Darander wrote:
>>>> ~# usb 1-1: new full-speed USB device number 3 using at91_ohci
>>>> usb 1-1: ath9k_htc: Firmware htc_9271.fw requested
>>>> usb 1-1: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
>>>> -----------[ cut here ]-----------
>>>> WARNING: CPU: 0 PID: 93 at
>>>> /mnt/cs-builds/anders/oe-build/build-ccu/tmp-eglibc/work/ccu-oe-linu=
x-gnueabi/linux-yocto-ccu/3.14+gitAUTOINC+7b03bd3dfd-r0/linux/drivers/usb=
/core/urb.c:450
>>>> usb_submit_urb+0x2ac/0x460()
>>>> usb 1-1: BOGUS urb xfer, pipe 1 !=3D type 3
>=20
>>>
>>> I can't tell exactly where the fault is, but this message means that =
an
>>> URB was submitted for a bulk endpoint with a pipe of type
>>> PIPE_INTERRUPT.
>>
>> Then kernel driver and firmware should be updated. There was some
>> Bulk/Interrupt issues which was fixed last year.
>=20
> Any pointers to the bulk/interrupt issues? Was it a general issue, or
> related either to
> at91-ohci or ar9271?

It is primary ar9271 issue. The interrupt EP has different response time
on different host controllers. Initially as workaround ath9k was forcing
Bulk traffic on Interrupt EP. But this workaround is working with some
host controllers and completely fails on others. So i removed it. The
patches are included in master kernel branch and git firmware source.

>=20
> As far as I've been able to find out, I've got the latest firmware
> (check again with linux-firmware).
> I've also tried with the master from open-ath9k-htc-firmware.
>=20
>> I hope this HW will not be used as AP.
>=20
> Is this based on the use of at91- SoC, or based on the ar9271?

ar9271 can work as AP with limit on 8 stations but according to user
reports it fails even with one station on at91

> The primary use case is to run as a client, though there will likely
> be some instances where it'll
> function as a AP. (Though primarily for M2M communications), thus
> pretty low traffic.

For AP usually should be created monitor mode interface for receiving
and transmitting management frames. Depending on location and STAs or
APs working on same channel, you will get a lot of traffic on this usb
interface.
Some users reported huge traffic drops on at91 based APs. Since i can't
debug it, i can't promise that it will be fixed any time soon.

--=20
Regards,
Oleksij


--titRmsLWf68lFFGP6Ckp7lwPfj6p7xqNR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlO6t/oACgkQHwImuRkmbWkzFAD8CVg32bNPqhNbwQpBsqNNUFcr
yK3HiGJr+AMtkrejUOcA/2fVtna1AcnYYwrVEdf/n2kCPgnWmNM/SGE8wfxbOvI0
=ZHYI
-----END PGP SIGNATURE-----

--titRmsLWf68lFFGP6Ckp7lwPfj6p7xqNR--
