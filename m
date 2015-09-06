Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60555 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbbIFLBz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 07:01:55 -0400
Message-ID: <55EC1D0B.6090707@rempel-privat.de> (sfid-20150906_130216_241123_D7F4DABE)
Date: Sun, 06 Sep 2015 13:01:31 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] ath9k_htc: introduce support for different fw versions
References: <87oajhvaca.fsf@kamboji.qca.qualcomm.com>	<1439529178-3011-1-git-send-email-linux@rempel-privat.de> <87si6r3jhg.fsf@purkki.adurom.net>
In-Reply-To: <87si6r3jhg.fsf@purkki.adurom.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JcDd0ftN8nVeN7cdNMtDr2Qsqi6FI0dWP"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JcDd0ftN8nVeN7cdNMtDr2Qsqi6FI0dWP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 06.09.2015 um 12:55 schrieb Kalle Valo:
> Oleksij Rempel <linux@rempel-privat.de> writes:
>=20
>> Current kernel support only one fw name with theoretically only one
>> fw version located in =E2=80=9Cfirmware/htc_[9271|7010].fw=E2=80=9D. W=
hich is ok so
>> far we have only one fw version (1.3). After we realised new fw 1.4,
>> we faced compatibility problem which was decided to solve by firmware
>> name and location:
>>
>> - new firmware is located now in firmware/ath9k_htc/htc_[9271|7010]-1.=
4.0.fw
>> - old version 1.3 should be on old place, so old kernel have no issues=
 with it.
>> - new kernels including this patch should be able to try different sup=
ported (min..max) fw version.
>> - new kernel should be able to support old fw location too. At least f=
or now.
>=20
> Please word wrap the commit log.

ok.

>> At same time this patch will add new module option which should allow
>> user to play with development fw version without replacing stable one.=

>> If user will set =E2=80=9Cath9k_htc use_dev_fw=3D1=E2=80=9D module wil=
l try to find
>> firmware/ath9k_htc/htc_[9271|7010]-1.dev.0.fw first and if it fails,
>> use stable version: for example...1.4.0.fw.
>=20
> I'm not really sure if this module parameter makes sense and I haven't
> noticed any other wifi driver having a similar parameter. If user wants=

> to test a developemnt firmware he can override a stable firmware versio=
n
> with a simple cp operation. So why is the module parameter needed?
>=20
Sure, iwl module has CONFIG for this case, so you should recompile it.
The use case which i was thinking is the ability to provide a package
for dev FW, which will not conflict with main FW package.

The package just should provide 3 files, /etc/modules/ath9k_htc_params
and /lib/firmware/bla.fw
If dev package introduces some regressions i still can ask user to
reload module with other parameter.

--=20
Regards,
Oleksij


--JcDd0ftN8nVeN7cdNMtDr2Qsqi6FI0dWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlXsHRkACgkQHwImuRkmbWmwAQD+PcVPlZfi94xO7n9CX4qaRUAL
CqjoVvKowVM2yjTkVIYA+wXm/kBj5hh1anL+/zFO8hUAL839Q0Vp+G2y4vK5GL5L
=ZFGW
-----END PGP SIGNATURE-----

--JcDd0ftN8nVeN7cdNMtDr2Qsqi6FI0dWP--
