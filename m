Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49578 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaILGSj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 02:18:39 -0400
Message-ID: <54129018.70209@rempel-privat.de> (sfid-20140912_081843_807990_90DC0E66)
Date: Fri, 12 Sep 2014 08:18:00 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] Revert "ath9k: Calculate sleep duration"
References: <1410442548-15782-1-git-send-email-sujith@msujith.org> <20140911141338.GA21543@qca.qualcomm.com> <21521.45335.848659.125183@gargle.gargle.HOWL> <20140912060936.GA20575@qca.qualcomm.com>
In-Reply-To: <20140912060936.GA20575@qca.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ANnbxd9swKNa72shd2eSk2xpJmEXJ6J1S"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ANnbxd9swKNa72shd2eSk2xpJmEXJ6J1S
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 12.09.2014 um 08:09 schrieb Rajkumar Manoharan:
> On Thu, Sep 11, 2014 at 07:56:31PM +0530, Sujith Manoharan wrote:
>> Rajkumar Manoharan wrote:
>>> Some of the IOE customer using ath9k with power save enabled. IIRC th=
e
>>> expectation is that when the station is idle, it should wakeup on DTI=
M
>>> beacon not for every beacons. Are you seeing frequest bmiss events on=

>>> higher beacon interval?
>>
>> I don't think ath9k has ever been tested with longer sleep durations
>> based on dtim period. We have always programmed the hardware to wake u=
p
>> for every beacon interval, using the TIM_TIMER interrupt. And since th=
e
>> TIM bit needs to be checked for every beacon, the sleep duration has
>> to be the beacon interval.
>>
>> Also, the bmiss threshold needs to be adjusted based on the sleep
>> duration. We are hardcoding it currently in the driver using
>> ATH_DEFAULT_BMISS_LIMIT. This will break, too.
>>
>> Using dtim for PS needs more testing before it can be used,
>> so we can have the original behavior for now.
>>
> Sounds clear.
>=20
> Acked-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Just bisected that this patch caused kernel panic on ath9k_htc.
One more reason for revert ;)

--=20
Regards,
Oleksij


--ANnbxd9swKNa72shd2eSk2xpJmEXJ6J1S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlQSkBwACgkQHwImuRkmbWlrWwD/WNC1Q7JA6jRGiEt3x0QLWQLx
0lGJkCSdP9I7bhubJ4cBAIo4wUrdGybyjF4IIh5psGxrDAfLAvpRsP22IpMa/dFs
=NowH
-----END PGP SIGNATURE-----

--ANnbxd9swKNa72shd2eSk2xpJmEXJ6J1S--
