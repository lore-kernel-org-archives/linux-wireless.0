Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:43975 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbYATKod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 05:44:33 -0500
Received: from ironport-out-2.rz.rwth-aachen.de ([134.130.3.59])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JUX0091TV49WND0@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Sun, 20 Jan 2008 11:43:21 +0100 (CET)
Date: Sun, 20 Jan 2008 11:43:20 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: iwl3945 driver is still unusable!
In-reply-to: <D936D925018D154694D8A362EEB08920036F2DBF@orsmsx416.amr.corp.intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Message-id: <479325C8.3010705@archlinux.org> (sfid-20080120_104442_883671_27D7F45B)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig8C8B560A184573EBB00F65E2
References: <fmclu6$dvl$1@ger.gmane.org> <fmpigk$c57$1@ger.gmane.org>
 <D936D925018D154694D8A362EEB08920036F286F@orsmsx416.amr.corp.intel.com>
 <47910F33.2090505@archlinux.org>
 <D936D925018D154694D8A362EEB08920036F2DBF@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8C8B560A184573EBB00F65E2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Chatre, Reinette schrieb:
>> Which doesn't help anyone if it does not work. ipw3945 may be
>> deprecated in your eyes, but for me it is the only way to make my
>> wireless NIC work
>> reliably. From my point of view ipw3945 is stable and iwl3945
>> is _alpha_
>> software.
>=20
> Please understand that we need to focus limited resources. ipw3945 is d=
eprecated and we focus on iwlwifi, which supports both 3945 and 4965. Unf=
ortunately we have been unable to reproduce your problem.=20

Your unability to reproduce the bug is weird, as I can reproduce this
bug every time I try iwl3945, with every version I ever tried and with
every kernel I ever tried. Are there different revisions of the 3945
chip which behave differently and maybe you are trying another one?

[x86_64][11:24:49][thomas@artin ~]$ (lspci; lspci -n)|grep ^03\:00
03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
Network Connection (rev 02)
03:00.0 0280: 8086:4227 (rev 02)

Jerone suggested that it may be something in my software (although a
Debian user posted in the bug report that he is also affected, and his
"works for me" comment is based on iwl4965, not 3945). Which components
of my system are inolved here?

- wpa_supplicant: tried versions 0.5.7 to 0.5.9, all the same.
Associating always works (only data transmission after that fails), so
this seems unlikely.
- openssl (which wpa_supplicant depends on): unlikely, as it is only
involved in key negotiation - once the connection has been established,
it does not do anything related to the actual networking.
- glibc: I think I have had more than 5 different versions of glibc
installed since I first saw this bug, so a problem here seems unlikely.
- gcc: It is used to compile linux and the iwlwifi driver, I am
currently using version 4.2.2, I had some 4.1 releases before, all of
them with the same results. May compiling with a different version of
gcc make the bug go away? Which version are you using in your tests?
- linux: tried versions from 2.6.21 (with the Intel mac80211 patch) to
2.6.24, vanilla versions as well as the Archlinux kernel (which includes
some patches), all with the same results.
- the udev firmware loader: if the firmware is not loaded properly, it
may lead to bugs. However, it is simply a script that gives the kernel
the firmware data into sysfs, so if there is a problem here, it is in lin=
ux.
- The firmware files: I have these firmware files installed in
/lib/firmware: (with md5sums)
26d10014b09439dc5a8573c2a6f85b0a  /lib/firmware/iwlwifi-3945-1.ucode
3afbb112ade3ede3d02e03892ff8a201  /lib/firmware/iwlwifi-3945.ucode
I guess iwlwifi uses the first one now.

So what other problems could there be on my end? When you test your
driver, do you even try if actual data is transmitted after the
association process completed?

I may have time to test this with the Ubuntu Live CD soon (as he
suggested), but I don't think it will make a difference.

I am eager to solve this problem, but I don't know where to look anymore.=



--------------enig8C8B560A184573EBB00F65E2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkeTJcgACgkQEda5KzHP/VD1FgCeOYFU0NhqizfIkl8q1T4mlz4y
FfAAoILVkAeQsDg2UxOpgIpeOrJGSTVd
=1l1+
-----END PGP SIGNATURE-----

--------------enig8C8B560A184573EBB00F65E2--
