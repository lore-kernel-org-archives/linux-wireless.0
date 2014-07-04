Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52393 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbaGDQzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2014 12:55:10 -0400
Message-ID: <53B6DC5F.3090304@rempel-privat.de> (sfid-20140704_185519_775362_31A1C755)
Date: Fri, 04 Jul 2014 18:54:55 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
	Anders Darander <anders.darander@gmail.com>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com
Subject: Re: ath9k -> bogus usb xfer on at91
References: <Pine.LNX.4.44L0.1407041225290.6607-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1407041225290.6607-100000@netrider.rowland.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jXPcFUHH4KGe2fAGer7BWdrqq8PQi8Ce2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jXPcFUHH4KGe2fAGer7BWdrqq8PQi8Ce2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 04.07.2014 18:30, schrieb Alan Stern:
> On Fri, 4 Jul 2014, Anders Darander wrote:
>=20
>> Hi,
>>
>> While porting an internal BSP (a design based on a at91sam9g20 SoC)
>> from 3.10 to 3.14, I got flooded with messages like:
>>
>> ~# usb 1-1: new full-speed USB device number 3 using at91_ohci
>> usb 1-1: ath9k_htc: Firmware htc_9271.fw requested
>> usb 1-1: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
>> -----------[ cut here ]-----------
>> WARNING: CPU: 0 PID: 93 at
>> /mnt/cs-builds/anders/oe-build/build-ccu/tmp-eglibc/work/ccu-oe-linux-=
gnueabi/linux-yocto-ccu/3.14+gitAUTOINC+7b03bd3dfd-r0/linux/drivers/usb/c=
ore/urb.c:450
>> usb_submit_urb+0x2ac/0x460()
>> usb 1-1: BOGUS urb xfer, pipe 1 !=3D type 3
>> Modules linked in: ath9k_htc ath9k_common ath9k_hw ath mac80211
>> cfg80211 ccudrv(O) at91_disable_wdt(O) at91_bootcount(O) at91_adc(O)
>> CPU: 0 PID: 93 Comm: kworker/0:3 Tainted: G W O 3.14.10-ccu #2
>> Workqueue: events request_firmware_work_func
>> [<c000d354>] (unwind_backtrace) from [<c000bb74>] (show_stack+0x10/0x1=
4)
>> [<c000bb74>] (show_stack) from [<c00155ac>] (warn_slowpath_common+0x60=
/0x80)
>> [<c00155ac>] (warn_slowpath_common) from [<c00155f8>]
>> (warn_slowpath_fmt+0x2c/0x3c)
>> [<c00155f8>] (warn_slowpath_fmt) from [<c01d9c14>] (usb_submit_urb+0x2=
ac/0x460)
>> [<c01d9c14>] (usb_submit_urb) from [<bf134e28>]
>> (hif_usb_send+0x268/0x2c8 [ath9k_htc])
>> [<bf134e28>] (hif_usb_send [ath9k_htc]) from [<bf133064>]
>> (htc_issue_send.constprop.4+0x64/0x68 [ath9k_htc])
>> [<bf133064>] (htc_issue_send.constprop.4 [ath9k_htc]) from
>> [<bf133354>] (htc_connect_service+0x170/0x1c8 [ath9k_htc])
>> [<bf133354>] (htc_connect_service [ath9k_htc]) from [<bf135484>]
>> (ath9k_wmi_connect+0x50/0x6c [ath9k_htc])
>> [<bf135484>] (ath9k_wmi_connect [ath9k_htc]) from [<bf13b2e0>]
>> (ath9k_init_htc_services.isra.10+0x20/0x280 [ath9k_htc])
>> [<bf13b2e0>] (ath9k_init_htc_services.isra.10 [ath9k_htc]) from
>> [<bf13b744>] (ath9k_htc_probe_device+0xe4/0x928 [ath9k_htc])
>> [<bf13b744>] (ath9k_htc_probe_device [ath9k_htc]) from [<bf13374c>]
>> (ath9k_htc_hw_init+0x10/0x30 [ath9k_htc])
>> [<bf13374c>] (ath9k_htc_hw_init [ath9k_htc]) from [<bf1345e0>]
>> (ath9k_hif_usb_firmware_cb+0x4cc/0x5c8 [ath9k_htc])
>> [<bf1345e0>] (ath9k_hif_usb_firmware_cb [ath9k_htc]) from [<c018993c>]=

>> (request_firmware_work_func+0x2c/0x4c)
>> [<c018993c>] (request_firmware_work_func) from [<c0026bd0>]
>> (process_one_work+0x20c/0x33c)
>> [<c0026bd0>] (process_one_work) from [<c002774c>] (worker_thread+0x234=
/0x384)
>> [<c002774c>] (worker_thread) from [<c002bea0>] (kthread+0xc0/0xd4)
>> [<c002bea0>] (kthread) from [<c00094d0>] (ret_from_fork+0x14/0x24)
>> --[ end trace b92d2c3cd165cd68 ]--
>> -----------[ cut here ]-----------
>=20
> I can't tell exactly where the fault is, but this message means that an=

> URB was submitted for a bulk endpoint with a pipe of type
> PIPE_INTERRUPT.

Then kernel driver and firmware should be updated. There was some
Bulk/Interrupt issues which was fixed last year.

I hope this HW will not be used as AP.

>> After temporarily reverting commit
>> 3482528e9aced9234d4e2a4a9538c882a9aa5aa2, which enables debug checks
>> on all USB urb's (previously is was only enabled for a
>> CONFIG_USB_DEBUG enabled kernel), the WiFi chip starts to work
>> correctly. The chip in question is a ar9721.
>>
>>  The same USB stick works without these messages on my laptop; while
>> another USB stick, based on an rtl8187 chip, works without these
>> messages on the target system (at91sam9g20)
>>
>> Any pointers to what it could be? Or suggestions on how to attack the =
issue?
>=20
> Fix the URB submission to use the correct pipe type.
>=20
> Alan Stern
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Regards,
Oleksij


--jXPcFUHH4KGe2fAGer7BWdrqq8PQi8Ce2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlO23GUACgkQHwImuRkmbWm/aQD/eUHZbVCsG89Mv1kpNe2eUVtq
hVAiKxerh+UwxuZuSnQA/31sTvc88tUkOsAC91tKm2CGl0QF8irhsJupx1nc3G5r
=cSx1
-----END PGP SIGNATURE-----

--jXPcFUHH4KGe2fAGer7BWdrqq8PQi8Ce2--
