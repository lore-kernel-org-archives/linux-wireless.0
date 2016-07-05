Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63608 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbcGETCu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 15:02:50 -0400
Subject: Re: ath9k-htc on OHCI -> bogus usb xfer
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
References: <1467721137.3144.81.camel@synopsys.com>
 <577BED2D.7070209@rempel-privat.de> <1467739821.3086.13.camel@synopsys.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"anders.darander@gmail.com" <anders.darander@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"fixed-term.Oleksij.Rempel@de.bosch.com"
	<fixed-term.Oleksij.Rempel@de.bosch.com>,
	"linux-snps-arc@lists.infradead.org"
	<linux-snps-arc@lists.infradead.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <577C041C.7080905@rempel-privat.de> (sfid-20160705_210253_423577_CBC72DD9)
Date: Tue, 5 Jul 2016 21:01:48 +0200
MIME-Version: 1.0
In-Reply-To: <1467739821.3086.13.camel@synopsys.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lvdsiS0cNLASr6BO1ogqqNkEI4WHh9tSh"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lvdsiS0cNLASr6BO1ogqqNkEI4WHh9tSh
Content-Type: multipart/mixed; boundary="Qf4UidojRwOSH5bffJ5HnNxEiBcHp1CF3"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "anders.darander@gmail.com" <anders.darander@gmail.com>,
 "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
 "fixed-term.Oleksij.Rempel@de.bosch.com"
 <fixed-term.Oleksij.Rempel@de.bosch.com>,
 "linux-snps-arc@lists.infradead.org" <linux-snps-arc@lists.infradead.org>,
 "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Message-ID: <577C041C.7080905@rempel-privat.de>
Subject: Re: ath9k-htc on OHCI -> bogus usb xfer
References: <1467721137.3144.81.camel@synopsys.com>
 <577BED2D.7070209@rempel-privat.de> <1467739821.3086.13.camel@synopsys.com>
In-Reply-To: <1467739821.3086.13.camel@synopsys.com>

--Qf4UidojRwOSH5bffJ5HnNxEiBcHp1CF3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 05.07.2016 um 19:31 schrieb Alexey Brodkin:
> Hi Oleksij,
>=20
> On Tue, 2016-07-05 at 19:23 +0200, Oleksij Rempel wrote:
>> Hi,
>>
>> Am 05.07.2016 um 14:20 schrieb Alexey Brodkin:
>>>
>>> Hello,
>>>
>>> Looks like this is another manifestation of already seen problem with=
 ath9k-htc
>>> and OHCI controller.
>>>
>>> I'm trying to get USB Wi-Fi dongle based on Atheros AR9271 to work wi=
th our
>>> development board (this is Synopsys AXS103) and seeing a picture very=
 similar to
>>> what was discussed here http://thread.gmane.org/gmane.linux.usb.gener=
al/110847
>>>
>>> Below is what I see on insertion of the dongle.
>>> Note I have the most recent ath9k-htc firmware (see "ath9k_htc/htc_92=
71-1.4.0.fw"
>>> in the log below) and Linux kernel is 4.6.3 (latest stable as of toda=
y) but the same
>>> happens even on 4.4.
>>>
>>> Interesting enough if I simply remove or disable the warning like tha=
t
>>> ------------------------>8---------------------------
>>> diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
>>> index 3d27477..a317e1e 100644
>>> --- a/drivers/usb/core/urb.c
>>> +++ b/drivers/usb/core/urb.c
>>> @@ -443,11 +443,6 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_fl=
ags)
>>>          * cause problems in HCDs if they get it wrong.
>>>          */
>>> =20
>>> -       /* Check that the pipe's type matches the endpoint's type */
>>> -       if (usb_pipetype(urb->pipe) !=3D pipetypes[xfertype])
>>> -               dev_WARN(&dev->dev, "BOGUS urb xfer, pipe %x !=3D typ=
e %x\n",
>>> -                       usb_pipetype(urb->pipe), pipetypes[xfertype])=
;
>>> -
>>>         /* Check against a simple/standard policy */
>>>         allowed =3D (URB_NO_TRANSFER_DMA_MAP | URB_NO_INTERRUPT | URB=
_DIR_MASK |
>>>                         URB_FREE_BUFFER);
>>> ------------------------>8---------------------------
>>> everything seem to work quite nice.
>>>
>>> Any thoughts are much appreciated.
>>>
>>> That's the log itself:
>>> ------------------------>8---------------------------
>>> usb 1-1: new full-speed USB device number 2 using ohci-platform
>>> usb 1-1: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
>>> usb 1-1: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size=
: 51008
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb_submit_urb+0=
x162/0x404
>>> usb 1-1: BOGUS urb xfer, pipe 1 !=3D type 3
>>> Modules linked in:
>>> CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 4.6.3 #10
>>> Workqueue: events request_firmware_work_func
>>>
>>> Stack Trace:
>>>   arc_unwind_core.constprop.1+0x94/0x10c
>>> ---[ end trace 2249b79eac9991d1 ]---
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb_submit_urb+0=
x162/0x404
>>> usb 1-1: BOGUS urb xfer, pipe 1 !=3D type 3
>>> Modules linked in:
>>> CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G        W       4.6.3 #10
>>> Workqueue: events request_firmware_work_func
>>>
>>> Stack Trace:
>>>   arc_unwind_core.constprop.1+0x94/0x10c
>>> ---[ end trace 2249b79eac9991d2 ]---
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb_submit_urb+0=
x162/0x404
>>> usb 1-1: BOGUS urb xfer, pipe 1 !=3D type 3
>>> Modules linked in:
>>> CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G        W       4.6.3 #10
>>> Workqueue: events request_firmware_work_func
>>>
>>> Stack Trace:
>>>   arc_unwind_core.constprop.1+0x94/0x10c
>>> ---[ end trace 2249b79eac9991d3 ]---
>>>
>>
>> please send content of hif_usb_send_regout() from your source code.
>> It is located in drivers/net/wireless/ath/ath9k/hif_usb.c
>=20
> I use vanilla 4.6.3 tree so that's what I have is the same as
> http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tre=
e/drivers/net/wireless/ath/ath9k/hif_usb.c?h=3Dlinu
> x-4.6.y#n99

Interesting.
Can you please send lsusb -v for this adapter? and it will be
interesting to see, which usb endpoint was actualy used.

--=20
Regards,
Oleksij


--Qf4UidojRwOSH5bffJ5HnNxEiBcHp1CF3--

--lvdsiS0cNLASr6BO1ogqqNkEI4WHh9tSh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAld8BBwACgkQHwImuRkmbWkoNwD/UrM4yzzybeQLKJFofDdnSFnH
pUpFHr4lRDi9sdTHM1wA/js24emBWy5r+956u4Hzv4h92SLy7LdsxOOIVRcr1BZk
=C1Hx
-----END PGP SIGNATURE-----

--lvdsiS0cNLASr6BO1ogqqNkEI4WHh9tSh--
