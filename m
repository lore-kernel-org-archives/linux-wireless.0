Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60368 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbZIZPQD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 11:16:03 -0400
Message-ID: <4ABE3023.3020006@hauke-m.de>
Date: Sat, 26 Sep 2009 17:15:47 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: tim.gardner@canonical.com
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bryan Wu <bryan.wu@canonical.com>,
	Mauro Di Domenico <didomauro@tiscali.it>,
	bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: A problem loading ssb module
References: <1253811559.4579.44.camel@pc3.dido> <4ABBAB47.8040300@canonical.com> 	<4ABBBB8C.8080401@hauke-m.de> <43e72e890909241137o7e853edfxb9e159df34927d7b@mail.gmail.com> 	<4ABC08FA.8030104@canonical.com> <43e72e890909241708v55af30baia5f6fca8eb5d9d59@mail.gmail.com> <4ABC0B60.5070909@canonical.com>
In-Reply-To: <4ABC0B60.5070909@canonical.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD5B91B26DB044C516FC55B60"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD5B91B26DB044C516FC55B60
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Tim Gardner wrote:
> Luis R. Rodriguez wrote:
>> On Thu, Sep 24, 2009 at 5:04 PM, Tim Gardner
>> <tim.gardner@canonical.com> wrote:
>>> Luis R. Rodriguez wrote:
>>>> On Thu, Sep 24, 2009 at 11:33 AM, Hauke Mehrtens <hauke@hauke-m.de>
>>>> wrote:
>>>>> Bryan Wu wrote:
>>>>>> Mauro Di Domenico wrote:
>>>>>>> Hi,
>>>>>>> I'm testing new b43 modules for my 14e4:4315 broadcom card.
>>>>>>> I've compiled and installed compat-wireless-2009-09-16 in a debia=
n
>>>>>>> machine with kernel version 2.6.30-6.
>>>>>>>
>>>>>>> During the boot I experience this problem:
>>>>>>>
>>>>>>> $ dmesg|egrep "b43|ssb"
>>>>>>>
>>>>>>> [    2.384463] b43-pci-bridge 0000:06:00.0: PCI INT A -> GSI 17
>>>>>>> (level,
>>>>>>> low) -> IRQ 17
>>>>>>> [    2.384477] b43-pci-bridge 0000:06:00.0: setting latency timer=

>>>>>>> to 64
>>>>>>> [    2.544344] ssb: Sonics Silicon Backplane found on PCI device
>>>>>>> 0000:06:00.0
>>>>>>> [    6.968981] b43: disagrees about version of symbol
>>>>>>> ssb_device_is_enabled
>>>>>>> [    6.968986] b43: Unknown symbol ssb_device_is_enabled
>>>>>>> [    6.969280] b43: Unknown symbol ssb_pmu_set_ldo_paref
>>>>>>> [    6.969407] b43: disagrees about version of symbol
>>>>>>> ssb_pcicore_dev_irqvecs_enable
>>>>>>> [    6.969410] b43: Unknown symbol ssb_pcicore_dev_irqvecs_enable=

>>>>>>> .....
>>>>>>> ....
>>>>>>> ...
>>>>>>>
>>>>>> I faced the exactly same issue as Mauro did. +1 from me, but
>>>>>> currently
>>>>>> have
>>>>>> no time to take a deeper look.
>>>>>>
>>>>>> Thanks
>>>>> Hi,
>>>>>
>>>>> I had the same problem with the ssb module and compat-wireless in
>>>>> ubuntu
>>>>> 9.04. The problem is that the ssb module is integrated into the
>>>>> initramfs image. The version out of the initramfs image is loaded o=
n
>>>>> startup and not the version of compat-wireless. Running "sudo
>>>>> update-initramfs -u" after installing compat-wireless and restaing =
the
>>>>> system fixes the problem for me. Either Debian/Ubuntu should remove=

>>>>> ssb
>>>>> form default initramfs image or compat-wireless should update the
>>>>> image
>>>>> with the install command. At least the compat-wireless documentatio=
n
>>>>> needs an update.
>>>>>
>>>>> Hauke
>>>>>
>>>>> (adding Luis and linux-wireless list)
>>>> Tim, do you guys update the initramfs upon installation of lbm? If a=

>>>> user does not use lbm and uses compat-wireless I suppose we need to =
do
>>>> something similar.
>>>>
>>>>  Luis
>>> No, initramfs is not updated when LBM is installed. I think maybe its=

>>> a bug
>>> that ssb is in the initramfs modules list since AFAIK its not a boot
>>> essential device. Even in the netboot case, ssb/b44 should be in a ud=
eb.
>>
>> That would make life much easier.
>>
>>   Luis
>>
>=20
> I'm looking at the Karmic initramfs-tools package and am not seeing
> _any_ reference to ssb or b44.
>=20
Hi Tim,

I have decompressed initrd.img-2.6.31-11-generic from karmic and
initrd.img-2.6.28-15-generic form jaunty. In both packages I found the
ssb.ko and b44.ko module.

Hauke


--------------enigD5B91B26DB044C516FC55B60
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJKvjApAAoJEIZ0px9YPRMypdkQAIwCu6+zZ979RBEzFGlPGSrt
ypO5JLVK2YpsUsE6d2yg95KvrTXti4l+dOloMuFHr/8VFBNtyQaiiFTVXOyvJ5Ds
ZUlJs0TgKCORBQ+yJ0x4dEw9iFcUwzTRGD3lb1d8bxLJNEn27eSWNxKrwCgXvxeh
9ukkJvsABbrLl5r+T0zJ8wtxuOEZFviqyrrnyLerW8Wbf0wyyA7/DpVISvAq0kBr
OPeDS1GaYkIDMQTAhoaxs6JvEus8nvp6MLL6mD7DFbz/N8MWd+cWBH+mbEaH3eMi
HWzuo3SHtlbDE5FHwy9K54S0kD0VTqlCvAsslnqFrK+F1K8yshkLtKd/bSQCcoxG
O6lfSMkB0DkxbAH1674Cgv1oKj+hRVN8gQur+bR6dImgiiVAOs68q4Gpy+50rw1A
xXuuG3g2kb6JLYEvJ+qX4OF9YsL/geTkVGe4zsI9JpN/eNc/onQGjUx9uZrKvFKd
fH5fvF62S6tlaCw3fW4lOClWq3L5PKoE2RNT2xB+JSIPwa7OM7N5hteps3fVTbg8
e0mb17So1VBn2AEfOj0wbceHcZiLaHpLkWc3pXqe31N4HyRXj/TwtMu0bO7VIiPw
882NOo/AwNmggDX/OOH1KbFTl1NZv/FO77npyZ9cqtJWgKh+N13mNnglcfYAyXg3
Nf29cnjt5UY6//S1iebP
=lIv0
-----END PGP SIGNATURE-----

--------------enigD5B91B26DB044C516FC55B60--
