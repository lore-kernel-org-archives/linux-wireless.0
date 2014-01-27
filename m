Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50768 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbaA0TDI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 14:03:08 -0500
Received: from [192.168.1.221] ([93.196.93.204]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MSdNs-1VgOPW1NfY-00RdEU for
 <linux-wireless@vger.kernel.org>; Mon, 27 Jan 2014 20:03:06 +0100
Message-ID: <52E6AD5C.3020005@rempel-privat.de> (sfid-20140127_200312_613171_5D44AB4A)
Date: Mon, 27 Jan 2014 20:02:52 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: mail@fuerstflorian.de, ath9k-devel@lists.ath9k.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] [BUG] Atheros AR7010+AR9287: Scheduling while atomic:
 ksoftirqd/0/3/0x00000302
References: <trinity-b8018ef9-8037-4688-a363-2deb3aed68fc-1390501815918@3capp-1and1-bs02> <52E1712B.70202@rempel-privat.de>, <52E191B3.2070601@meshcoding.com>, <trinity-14f555a0-3945-448b-a908-b12f1cb532e3-1390546291559@3capp-1and1-bs03> <trinity-c1a620e7-f7e8-4bb0-b583-b36b6fa6bfd8-1390546555391@3capp-1and1-bs03>
In-Reply-To: <trinity-c1a620e7-f7e8-4bb0-b583-b36b6fa6bfd8-1390546555391@3capp-1and1-bs03>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4NdC4C7MrXOAroPap8N17dmWXSIh5dG7p"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4NdC4C7MrXOAroPap8N17dmWXSIh5dG7p
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

i found this bug report with your response:
https://bugzilla.redhat.com/show_bug.cgi?id=3D990955
"I don't think adding a workqueue is a good idea because that would
significantly delay the calls in many situations."

The problem on ath9k_htc is that the call is already dramatically
delayed. It will try to send WMI command over USB with delay of some
_msec_ not usec. There are two options right now, use workqueue or do
not support sta_rc_update.

Am 24.01.2014 07:55, schrieb mail@fuerstflorian.de:
> Hello Antonio,=20
> =20
>> Just as a generic suggestion, have you tried testing a slightly older
>> kernel versions to see if that makes any difference?
>=20
> Thanks for the suggestion. I will try to use a older kernel version, bu=
t it will take some days to be
> sure if it works again (and I naturally will report about).=20
> =20
> --
> Flo
>=20
>> On 23/01/14 23:03, Antonio Quartulli wrote:
>> Von: "Antonio Quartulli" <antonio@meshcoding.com>
>> An: "Oleksij Rempel" <linux@rempel-privat.de>, mail@fuerstflorian.de, =
ath9k-devel@lists.ath9k.org, "Antonio Quartulli" <ordex@autistici.org>
>> Betreff: Re: [ath9k-devel] [BUG] Atheros AR7010+AR9287: Scheduling whi=
le atomic: ksoftirqd/0/3/0x00000302
>>
>> Hi all,
>>
>> On 23/01/14 20:44, Oleksij Rempel wrote:
>>> Hi Antonio,
>>>
>>> You probably know more about this issue then me.
>>>
>>> Insight of this mutex are some WMI commands, which are incredible slo=
w
>>> on some USB 2.0 devices.
>>>
>>
>> I implemented the ath9k_htc_sta_rc_update() API but I don't really kno=
w
>> the internals of the ath9k_htc driver...therefore I don't know if thes=
e
>> WMI commands have any consequence on this..Could it be that this
>> slowness is triggering some reaction in the kernel (due to the fact th=
at
>> this part of the code is executed while holding a lock)?
>>
>> Sorry, but I can't really help.
>>
>> Just as a generic suggestion, have you tried testing a slightly older
>> kernel versions to see if that makes any difference?
>>
>>
>>
>> --=20
>> Antonio Quartulli


--=20
Regards,
Oleksij


--4NdC4C7MrXOAroPap8N17dmWXSIh5dG7p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLmrV8ACgkQHwImuRkmbWmYNAD/TXYjvAwVaZ+pvDkfiT0xRY9j
WSMbypxli3o4sva8+s4A/10nmhscYCyBHs78i6Dz5md3iGtnrGgTRLCZyLEFV1az
=NG1I
-----END PGP SIGNATURE-----

--4NdC4C7MrXOAroPap8N17dmWXSIh5dG7p--
