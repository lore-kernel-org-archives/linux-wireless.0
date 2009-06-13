Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:39094 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZFMIyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 04:54:05 -0400
Message-ID: <4A3368F9.6060509@web.de>
Date: Sat, 13 Jun 2009 10:53:13 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: [PATCH] Warp speed building
References: <4A30CE70.4050605@web.de> <200906112305.33675.mb@bu3sch.de> 	<43e72e890906111410n3766ceb7t4b4efda05730c693@mail.gmail.com> 	<200906112314.29464.mb@bu3sch.de> <69e28c910906111439o798b3298p63bd44e88358ea8a@mail.gmail.com> <43e72e890906111443h5758b74dk6f788b327b1cfe4c@mail.gmail.com>
In-Reply-To: <43e72e890906111443h5758b74dk6f788b327b1cfe4c@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig934DB18C54E85425AFCC4C81"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig934DB18C54E85425AFCC4C81
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Luis R. Rodriguez wrote:
> 2009/6/11 G=C3=A1bor Stefanik <netrolller.3d-Re5JQEeQqe8AvxtiuMwx3w@pub=
lic.gmane.org>:
>> On Thu, Jun 11, 2009 at 11:14 PM, Michael Buesch<mb-fseUSCV1ubazQB+pC5=
nmwQ@public.gmane.org> wrote:
>>> On Thursday 11 June 2009 23:10:52 Luis R. Rodriguez wrote:
>>>> On Thu, Jun 11, 2009 at 2:05 PM, Michael Buesch<mb-fseUSCV1ubazQB+pC=
5nmwQ@public.gmane.org> wrote:
>>>>> On Thursday 11 June 2009 20:48:13 Luis R. Rodriguez wrote:
>>>>>> On Thu, Jun 11, 2009 at 2:29 AM, Jan Kiszka<jan.kiszka-S0/GAf8tV78=
@public.gmane.org> wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> while watching compat-wireless-2009-06-11 doing baby-steps buildi=
ng all
>>>>>>> its modules, I wonder what slows this down so horribly. No other
>>>>>>> external module build package I know is that slow (I would say *a=
t
>>>>>>> least* one order of magnitude slower than normal). Is this really=
 required?
>>>>>>>
>>>>>>> [ Hurray, it's finished! ]
>>>>>> I think the many depmod -ae are the culprit. This is in place to
>>>>>> account for all the crap of madwifi which may be present or older
>>>>>> drivers which have been renamed.
>>>>>>
>>>>>> This could be improved. Patches are welcomed.
>>>>>>
>>>>>> Ps. Try building with make -j 2, etc.
>>>>> -j does not help. It will hardly build in parallel then.
>>>> It works swell for me. The only thing that does not build in parelle=
l
>>>> is the autoconf stuff but after its done with that step everything
>>>> builds as expected with -j 2.
>>>>
>>>>> There's something
>>>>> that serializes most of it (implicitly).
>>>> You certain its just not the first part? I had written some patches =
to
>>>> make the first autoconf step into another step to then allow make -j=

>>>> foo to work without a warning but that would involve another step. T=
he
>>>> -j option does work for me though.
>>> Well, I never measured it, but I don't see any advantage when using -=
jX. Maybe
>>> that is because forever equals forever+1.
>>>
>>> What I do see, though, is that the per-cpu load is much higher when b=
uilding the
>>> kernel itself with the same -j parameter.
>> Actually, most of the slowness comes from stage 2 of the module build.=

>> For me, stage 1 runs through rather fast (and -jX accelerates it quite=

>> well), but stage 2 is serialized, and there is a long wait between
>> individual files. This wait is about a second on 2.6.28 for me in
>> vmware, but over 5 seconds (!!!) on 2.6.29. I've tried multiple
>> distros, and the time difference is consistent. (BTW stage 2 is
>> serialized in a full kernel build as well, though there is no reason
>> why it should be so; but no "wait" between steps is observed - in
>> fact, the second stage of a full 2.6.29 kernel build completes faster
>> for me than the second stage of compat-wireless on 2.6.29!)
>=20
> Heh yeah we need to fix this, patches are welcomed, I'll treat a beer s=
ometime.
>=20

Unless this comes with a regressing, consider the beer claimed.

------------->

Including config.mk again when kbuild called into the top level Makefile
slowed down the build process awfully. The reason for this were all the
dynamic, shell-based variable evaluations that were called over and over
again. Fortunately, including config.mk only in the outer Makefile run
appears to be enough. So let's remove this warp speed blocker.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 Makefile |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 0ab7d27..49a786a 100644
--- a/Makefile
+++ b/Makefile
@@ -13,8 +13,6 @@ OLD_IWL=3D$(shell $(MODPROBE) -l iwl4965)
=20
 ifneq ($(KERNELRELEASE),)
=20
-include $(M)/$(COMPAT_CONFIG)
-
 NOSTDINC_FLAGS :=3D -I$(M)/include/ -include $(M)/include/net/compat.h $=
(CFLAGS)
=20
 obj-y :=3D net/wireless/ net/mac80211/ net/rfkill/
--=20
1.6.0.2


--------------enig934DB18C54E85425AFCC4C81
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkozaP4ACgkQniDOoMHTA+lysgCaA6cvDBgACM1IZ7V8o87B4MGC
t2QAnRQiuEDhJ1Hk13hyaJdtKKL8oUHN
=N2wN
-----END PGP SIGNATURE-----

--------------enig934DB18C54E85425AFCC4C81--
