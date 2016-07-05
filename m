Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57435 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbcGERYm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 13:24:42 -0400
Subject: Re: ath9k-htc on OHCI -> bogus usb xfer
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <1467721137.3144.81.camel@synopsys.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"anders.darander@gmail.com" <anders.darander@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-snps-arc@lists.infradead.org"
	<linux-snps-arc@lists.infradead.org>,
	"EXTERNAL Rempel Oleksij (Brunel, CM-AI/ECO3)"
	<fixed-term.Oleksij.Rempel@de.bosch.com>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <577BED2D.7070209@rempel-privat.de> (sfid-20160705_192446_460422_52844D61)
Date: Tue, 5 Jul 2016 19:23:57 +0200
MIME-Version: 1.0
In-Reply-To: <1467721137.3144.81.camel@synopsys.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="p8QiCSCnwArShOpCQPXVfFBKfFCkcRTqv"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--p8QiCSCnwArShOpCQPXVfFBKfFCkcRTqv
Content-Type: multipart/mixed; boundary="FBLb7TIb4R15BwXrdSNcmK3RtRcwvDuWB"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
 "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "anders.darander@gmail.com" <anders.darander@gmail.com>,
 "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
 "linux-snps-arc@lists.infradead.org" <linux-snps-arc@lists.infradead.org>,
 "EXTERNAL Rempel Oleksij (Brunel, CM-AI/ECO3)"
 <fixed-term.Oleksij.Rempel@de.bosch.com>
Message-ID: <577BED2D.7070209@rempel-privat.de>
Subject: Re: ath9k-htc on OHCI -> bogus usb xfer
References: <1467721137.3144.81.camel@synopsys.com>
In-Reply-To: <1467721137.3144.81.camel@synopsys.com>

--FBLb7TIb4R15BwXrdSNcmK3RtRcwvDuWB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Am 05.07.2016 um 14:20 schrieb Alexey Brodkin:
> Hello,
>=20
> Looks like this is another manifestation of already seen problem with a=
th9k-htc
> and OHCI controller.
>=20
> I'm trying to get USB Wi-Fi dongle based on Atheros AR9271 to work with=
 our
> development board (this is Synopsys AXS103) and seeing a picture very s=
imilar to
> what was discussed here http://thread.gmane.org/gmane.linux.usb.general=
/110847
>=20
> Below is what I see on insertion of the dongle.
> Note I have the most recent ath9k-htc firmware (see "ath9k_htc/htc_9271=
-1.4.0.fw"
> in the log below) and Linux kernel is 4.6.3 (latest stable as of today)=
 but the same
> happens even on 4.4.
>=20
> Interesting enough if I simply remove or disable the warning like that
> ------------------------>8---------------------------
> diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
> index 3d27477..a317e1e 100644
> --- a/drivers/usb/core/urb.c
> +++ b/drivers/usb/core/urb.c
> @@ -443,11 +443,6 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flag=
s)
>          * cause problems in HCDs if they get it wrong.
>          */
> =20
> -       /* Check that the pipe's type matches the endpoint's type */
> -       if (usb_pipetype(urb->pipe) !=3D pipetypes[xfertype])
> -               dev_WARN(&dev->dev, "BOGUS urb xfer, pipe %x !=3D type =
%x\n",
> -                       usb_pipetype(urb->pipe), pipetypes[xfertype]);
> -
>         /* Check against a simple/standard policy */
>         allowed =3D (URB_NO_TRANSFER_DMA_MAP | URB_NO_INTERRUPT | URB_D=
IR_MASK |
>                         URB_FREE_BUFFER);
> ------------------------>8---------------------------
> everything seem to work quite nice.
>=20
> Any thoughts are much appreciated.
>=20
> That's the log itself:
> ------------------------>8---------------------------
> usb 1-1: new full-speed USB device number 2 using ohci-platform
> usb 1-1: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
> usb 1-1: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size: =
51008
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb_submit_urb+0x1=
62/0x404
> usb 1-1: BOGUS urb xfer, pipe 1 !=3D type 3
> Modules linked in:
> CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 4.6.3 #10
> Workqueue: events request_firmware_work_func
>=20
> Stack Trace:
>   arc_unwind_core.constprop.1+0x94/0x10c
> ---[ end trace 2249b79eac9991d1 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb_submit_urb+0x1=
62/0x404
> usb 1-1: BOGUS urb xfer, pipe 1 !=3D type 3
> Modules linked in:
> CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G        W       4.6.3 #10
> Workqueue: events request_firmware_work_func
>=20
> Stack Trace:
>   arc_unwind_core.constprop.1+0x94/0x10c
> ---[ end trace 2249b79eac9991d2 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb_submit_urb+0x1=
62/0x404
> usb 1-1: BOGUS urb xfer, pipe 1 !=3D type 3
> Modules linked in:
> CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G        W       4.6.3 #10
> Workqueue: events request_firmware_work_func
>=20
> Stack Trace:
>   arc_unwind_core.constprop.1+0x94/0x10c
> ---[ end trace 2249b79eac9991d3 ]---
>=20


please send content of hif_usb_send_regout() from your source code.
It is located in drivers/net/wireless/ath/ath9k/hif_usb.c


--=20
Regards,
Oleksij


--FBLb7TIb4R15BwXrdSNcmK3RtRcwvDuWB--

--p8QiCSCnwArShOpCQPXVfFBKfFCkcRTqv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAld77S0ACgkQHwImuRkmbWlNowEAk9vn5TeCvPjD0ctVhUinqRp/
mAUgDfGiYLb/uAyWQjYBAJAWA4S1vCegCsz0WbTtrj7gnEgMNFoYlN5+ntIDZkAT
=vasK
-----END PGP SIGNATURE-----

--p8QiCSCnwArShOpCQPXVfFBKfFCkcRTqv--
