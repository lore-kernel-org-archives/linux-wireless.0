Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33118 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbZIXSeE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 14:34:04 -0400
Message-ID: <4ABBBB8C.8080401@hauke-m.de>
Date: Thu, 24 Sep 2009 20:33:48 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@canonical.com>
CC: Mauro Di Domenico <didomauro@tiscali.it>,
	bcm43xx-dev@lists.berlios.de,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: A problem loading ssb module
References: <1253811559.4579.44.camel@pc3.dido> <4ABBAB47.8040300@canonical.com>
In-Reply-To: <4ABBAB47.8040300@canonical.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4D001DDA35C471B64A659360"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4D001DDA35C471B64A659360
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Bryan Wu wrote:
> Mauro Di Domenico wrote:
>> Hi,
>> I'm testing new b43 modules for my 14e4:4315 broadcom card.
>> I've compiled and installed compat-wireless-2009-09-16 in a debian
>> machine with kernel version 2.6.30-6.
>>
>> During the boot I experience this problem:
>>
>> $ dmesg|egrep "b43|ssb"
>>
>> [    2.384463] b43-pci-bridge 0000:06:00.0: PCI INT A -> GSI 17 (level=
,
>> low) -> IRQ 17
>> [    2.384477] b43-pci-bridge 0000:06:00.0: setting latency timer to 6=
4
>> [    2.544344] ssb: Sonics Silicon Backplane found on PCI device
>> 0000:06:00.0
>> [    6.968981] b43: disagrees about version of symbol
>> ssb_device_is_enabled
>> [    6.968986] b43: Unknown symbol ssb_device_is_enabled
>> [    6.969280] b43: Unknown symbol ssb_pmu_set_ldo_paref
>> [    6.969407] b43: disagrees about version of symbol
>> ssb_pcicore_dev_irqvecs_enable
>> [    6.969410] b43: Unknown symbol ssb_pcicore_dev_irqvecs_enable
>> .....
>> ....
>> ...
>>
>=20
> I faced the exactly same issue as Mauro did. +1 from me, but currently =
have
> no time to take a deeper look.
>=20
> Thanks
Hi,

I had the same problem with the ssb module and compat-wireless in ubuntu
9.04. The problem is that the ssb module is integrated into the
initramfs image. The version out of the initramfs image is loaded on
startup and not the version of compat-wireless. Running "sudo
update-initramfs -u" after installing compat-wireless and restaing the
system fixes the problem for me. Either Debian/Ubuntu should remove ssb
form default initramfs image or compat-wireless should update the image
with the install command. At least the compat-wireless documentation
needs an update.

Hauke

(adding Luis and linux-wireless list)


--------------enig4D001DDA35C471B64A659360
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJKu7uRAAoJEIZ0px9YPRMyHqoP/iOU1UoEheuhmknx3RHCZI+u
7/RJ49T9mM/WpOS9Nbt5s2z0mmL9+OC3pehR0n+NRAOMDz1XTE/W8996x41/MFm1
Zb54Hqt7kc7qSpDSAlaAEhsuq9+nbAWozD6YJGDGa0dhU15btJ436dCjcVFgb6F3
6IBxBWSyM52SZeCSkc/TSSGfIfGZpoSsq99BBxUAz/iQeSi7DNbVj0S+e661+wWY
bnfl/nkzvemal+WDa75rIrmueKEyrQOm/bW62joLjT4qh8juwkXLP052sHbR1RpU
I8xtqrxBaMCvYmuWOTCW7OIt0pilF6XHCZeb/rWNQPqn6Gi2DHUmwHQkinuRJ9SM
QKTiqtrwQW21mS3QzqNRtCsvel3GDamQTejBaVB5JR2WMIRl/xWY8qAW2ERI8u5W
wBDHy5JXnvXeuUEsQwYiEordy8uzrxVPbQvIuyoD9tj+k+qit5pHiqkFXT/zoATa
FEMmF2lcD0GC2He04uMY84sb/X2asaNBSbRGz6j1Utge87cuHZwSmXGCvMCacIBY
wyIO8svwxne65diad5i6RmnYVZBt+7/FKLqk8LiC5hJieueSE34YEf0KM4ZiuZ7N
/FJguwrr0f9jqt1C1HFws3DY2yXAmMwZLgYuTnEg6zwIKB5EwWO5ULzw8nMJqz4p
+Ps5yEfNFwiywB2bsJZU
=rNVx
-----END PGP SIGNATURE-----

--------------enig4D001DDA35C471B64A659360--
