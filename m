Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61916 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaKZSaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 13:30:04 -0500
Message-ID: <54761C1D.9050207@rempel-privat.de> (sfid-20141126_193012_450752_4E111E63)
Date: Wed, 26 Nov 2014 19:29:49 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: David Lechner <david@lechnology.com>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
CC: anders.darander@gmail.com
Subject: Re: ath9k -> bogus usb xfer on at91
References: <54751EAC.4080402@lechnology.com>
In-Reply-To: <54751EAC.4080402@lechnology.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KWb6cmM54TmJUwcxpdu5Gpi3PKTlJGXNT"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KWb6cmM54TmJUwcxpdu5Gpi3PKTlJGXNT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 26.11.2014 um 01:28 schrieb David Lechner:
>> On 7 July 2014 17:08, Oleksij Rempel <linux@xxxxxxxxxxxxxxxx> wrote:
>> >/  Am 07.07.2014 15:40, schrieb Anders Darander:/
>> >/> On 4 July 2014 18:54, Oleksij Rempel <linux@xxxxxxxxxxxxxxxx> wrot=
e:/
>> >/>> Am 04.07.2014 18:30, schrieb Alan Stern:/
>> >/>>> On Fri, 4 Jul 2014, Anders Darander wrote:/
>> >/>>>> ~# usb 1-1: new full-speed USB device number 3 using at91_ohci/=

>> >/>>>> usb 1-1: ath9k_htc: Firmware htc_9271.fw requested/
>> >/>>>> usb 1-1: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272/
>> >/>>>> -----------[ cut here ]-----------/
>> >/>>>> WARNING: CPU: 0 PID: 93 at/
>> >/>>>>
>> /mnt/cs-builds/anders/oe-build/build-ccu/tmp-eglibc/work/ccu-oe-linux-=
gnueabi/linux-yocto-ccu/3.14+gitAUTOINC+7b03bd3dfd-r0/linux/drivers/usb/c=
ore/urb.c:450/
>>
>> >/>>>> usb_submit_urb+0x2ac/0x460()/
>> >/>>>> usb 1-1: BOGUS urb xfer, pipe 1 !=3D type 3/
>> >/>/
>> >/>>>/
>> >/>>> I can't tell exactly where the fault is, but this message means
>> that an/
>> >/>>> URB was submitted for a bulk endpoint with a pipe of type/
>> >/>>> PIPE_INTERRUPT./
>> >/>>/
>> >/>> Then kernel driver and firmware should be updated. There was some=
/
>> >/>> Bulk/Interrupt issues which was fixed last year./
>> >/>/
>> >/> Any pointers to the bulk/interrupt issues? Was it a general issue,=

>> or/
>> >/> related either to/
>> >/> at91-ohci or ar9271?/
>> >
>> >/  It is primary ar9271 issue. The interrupt EP has different
>> response time/
>> >/  on different host controllers. Initially as workaround ath9k was
>> forcing/
>> >/  Bulk traffic on Interrupt EP. But this workaround is working with
>> some/
>> >/  host controllers and completely fails on others. So i removed it.
>> The/
>> >/  patches are included in master kernel branch and git firmware
>> source./
>>
>> Thanks for the comments!
>> I'll take a look at it, though it might have to be scheduled after the=

>> upcoming vacations...
>>
>> I'll sure try to look into those workarounds (and your removal of
>> those). I guess that
>> it's the firmware in open-ath9-htc-firmware you're talking about.
>>
>> >/>/
>> >/> As far as I've been able to find out, I've got the latest firmware=
/
>> >/> (check again with linux-firmware)./
>> >/> I've also tried with the master from open-ath9k-htc-firmware./
>> >/>/
>> >/>> I hope this HW will not be used as AP./
>> >/>/
>> >/> Is this based on the use of at91- SoC, or based on the ar9271?/
>> >
>> >/  ar9271 can work as AP with limit on 8 stations but according to us=
er/
>> >/  reports it fails even with one station on at91/
>> >
>> >/> The primary use case is to run as a client, though there will like=
ly/
>> >/> be some instances where it'll/
>> >/> function as a AP. (Though primarily for M2M communications), thus/=

>> >/> pretty low traffic./
>> >
>> >/  For AP usually should be created monitor mode interface for
>> receiving/
>> >/  and transmitting management frames. Depending on location and STAs=

>> or/
>> >/  APs working on same channel, you will get a lot of traffic on this=

>> usb/
>> >/  interface./
>> >/  Some users reported huge traffic drops on at91 based APs. Since i
>> can't/
>> >/  debug it, i can't promise that it will be fixed any time soon./
>>
>> Again, thanks for the information.
>> I think I've got a much better understanding of the issues (both those=

>> that I've
>> seen, and those that you have mentioned / explained). I'll see
>> when/what I can
>> look into this and what I can find out.
>>
>> Cheers,
>> Anders
>=20
> Anders, did you ever have a chance to look at this? I am seeing this
> same warning that is filling up the kernel logs in v3.18-rc6.
>=20
> The device I am using is:
>=20
> |ID 0846:9030 NetGear, Inc. WNA1100 Wireless-N 150 [Atheros AR9271]||
>=20
> I found that if I revert kernel commit 2b72111 that the warning stops,
> but the device does not work very well.||If you are interested to know
> more about the symptoms we are seeing, there is a bug report here:
> <https://github.com/ev3dev/ev3dev/issues/152>. But, I figured at least
> knowing the kernel commit that introduced the problem would be helpful.=
|
>=20

i assume you mean this:

commit 2b721118b7821107757eb1d37af4b60e877b27e7
Author: Oleksij Rempel <linux@rempel-privat.de>
Date:   Tue Aug 13 21:10:19 2013 +0200

    ath9k_htc: do not use bulk on EP3 and EP4

    If usb auto suspend is enabled or system run in to suspend/resume
    cycle, ath9k-htc adapter will stop to response. It is reproducible
on xhci H

    Host part of problem:
    XHCI do timing calculation based on Transfer Type and bInterval,
    immediately after device was detected. Ath9k-htc try to overwrite
    this parameters on module probe and some changes in FW,
    since we do not initiate usb reset from the driver this changes
    are not took to account. So, before any kind of suspend or reset,
    host controller will operate with old parameters. Only after
suspend/resume
    and if interface id stay unchanged, new parameters will be applied. H=
ost
    will send bulk data with no intervals (?), which will cause
    overflow on FIFO of EP4.

    Firmware part of problem:
    By default, ath9k-htc adapters configured with EP3 and EP4
    as interrupt endpoints. Current firmware will try to overwrite
    ConfigDescriptor to make EP3 and EP4 bulk. FIFO for this endpoints
    stay not reconfigured, so under the hood it is still Int EP.

    This patch is revert of 4a0e8ecca4ee commit which trying to
    reduce CPU usage on some systems. Since it will produce more bug
    as fixes, we will need to find other way to fix it.

    here is comment from kernel source which has some more explanation:
    * Some buggy high speed devices have bulk endpoints using
    * maxpacket sizes other than 512.  High speed HCDs may not
    * be able to handle that particular bug, so let's warn...

    in our case EP3 and EP4 have maxpacket sizes =3D 64!!!

    Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>



>=20
> ||
> --=20
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Regards,
Oleksij


--KWb6cmM54TmJUwcxpdu5Gpi3PKTlJGXNT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlR2HB0ACgkQHwImuRkmbWkpwAEAjUnZOFsNbkxqOPpYzH1Gu/CP
7Zh9oc1H5k/dEzImtz0BAJZ07nOoP6AzsNgbLFOQQE9Bz0tpu/4VbX9B2PW6RJ8I
=Fmxg
-----END PGP SIGNATURE-----

--KWb6cmM54TmJUwcxpdu5Gpi3PKTlJGXNT--
