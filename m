Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:42138 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbZFQGrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 02:47:10 -0400
Message-ID: <4A38916B.90509@web.de>
Date: Wed, 17 Jun 2009 08:47:07 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Warp speed building
References: <4A30CE70.4050605@web.de> <200906112305.33675.mb@bu3sch.de> 	<43e72e890906111410n3766ceb7t4b4efda05730c693@mail.gmail.com> 	<200906112314.29464.mb@bu3sch.de> <69e28c910906111439o798b3298p63bd44e88358ea8a@mail.gmail.com> 	<43e72e890906111443h5758b74dk6f788b327b1cfe4c@mail.gmail.com> 	<4A3368F9.6060509@web.de> <4A37E6F1.4080003@hauke-m.de> <43e72e890906161307w1441e26dnec48bbb1f88c38fd@mail.gmail.com>
In-Reply-To: <43e72e890906161307w1441e26dnec48bbb1f88c38fd@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2778DB4C19BD535A448B3D9E"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2778DB4C19BD535A448B3D9E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Luis R. Rodriguez wrote:
> On Tue, Jun 16, 2009 at 11:39 AM, Hauke Mehrtens<hauke@hauke-m.de> wrot=
e:
>> Jan Kiszka wrote:
>>> Including config.mk again when kbuild called into the top level Makef=
ile
>>> slowed down the build process awfully. The reason for this were all t=
he
>>> dynamic, shell-based variable evaluations that were called over and o=
ver
>>> again. Fortunately, including config.mk only in the outer Makefile ru=
n
>>> appears to be enough. So let's remove this warp speed blocker.
>>>
>>> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>>> ---
>>>  Makefile |    2 --
>>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Makefile b/Makefile
>>> index 0ab7d27..49a786a 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -13,8 +13,6 @@ OLD_IWL=3D$(shell $(MODPROBE) -l iwl4965)
>>>
>>>  ifneq ($(KERNELRELEASE),)
>>>
>>> -include $(M)/$(COMPAT_CONFIG)
>>> -
>>>  NOSTDINC_FLAGS :=3D -I$(M)/include/ -include $(M)/include/net/compat=
=2Eh $(CFLAGS)
>>>
>>>  obj-y :=3D net/wireless/ net/mac80211/ net/rfkill/
>> Hi Jan,
>>
>> I have tested this patch and it reduced the build time for me from 3:3=
0
>> to 2:40 minutes on a dual core system. I can not see any changes, expe=
ct
>> the reduced build time on my system. The resulting modules are still t=
he
>> same.
>=20
> Reason for including the config.mk is if your current kernel config
> differs the makefiles won't pick up the new stuff.

I had tested this before, and it did work nicely. To my understanding,
the 'export' in config.mk should carry all the defines into the nested
make calls.

Moreover, I'm surprised about this minimal reduction in Hauke's test.
Already running 'make clean' (no -j used for this) goes down from

    real    3m12.564s
    user    3m2.675s
    sys     0m8.461s

to

    real    0m20.670s
    user    0m17.337s
    sys     0m2.656s

here.

Jan


--------------enig2778DB4C19BD535A448B3D9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAko4kW8ACgkQniDOoMHTA+luqgCePFsAGsqxdvKmQd6DZGQOGFfe
6aUAnit4sqjgrDl3jz1aD3Ft/RuSx7D/
=lT9r
-----END PGP SIGNATURE-----

--------------enig2778DB4C19BD535A448B3D9E--
