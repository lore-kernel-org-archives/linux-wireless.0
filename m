Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62060 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752080AbdJPNM2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 09:12:28 -0400
Subject: Re: Two rtlwifi drivers?
To: Kalle Valo <kvalo@codeaurora.org>
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
 <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
 <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
 <87k202qcjr.fsf@kamboji.qca.qualcomm.com> <20171011131310.GF32250@kroah.com>
 <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com> <20171012103450.GA24647@kroah.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
 <ed361ae7-864e-1179-c7da-3ff10f4c73e2@rempel-privat.de>
 <87fuajmeak.fsf@kamboji.qca.qualcomm.com>
Cc: Pkshih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <380282b8-39e2-1ec0-7b05-157187883653@rempel-privat.de> (sfid-20171016_151231_981420_1472C498)
Date: Mon, 16 Oct 2017 15:11:45 +0200
MIME-Version: 1.0
In-Reply-To: <87fuajmeak.fsf@kamboji.qca.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C8h7igGKkDF8IwqWuwGA0g8SPLv5IcfpC"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C8h7igGKkDF8IwqWuwGA0g8SPLv5IcfpC
Content-Type: multipart/mixed; boundary="Gm3dj6M8OUWOIrxaud9N5kXHdiDa4dnt2";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Pkshih <pkshih@realtek.com>, Larry Finger <Larry.Finger@lwfinger.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Carpenter <dan.carpenter@oracle.com>, =?UTF-8?B?6I6K5b2l5a6j?=
 <yhchuang@realtek.com>, Johannes Berg <johannes.berg@intel.com>,
 Souptick Joarder <jrdr.linux@gmail.com>,
 "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Message-ID: <380282b8-39e2-1ec0-7b05-157187883653@rempel-privat.de>
Subject: Re: Two rtlwifi drivers?
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
 <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
 <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
 <87k202qcjr.fsf@kamboji.qca.qualcomm.com> <20171011131310.GF32250@kroah.com>
 <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com> <20171012103450.GA24647@kroah.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
 <ed361ae7-864e-1179-c7da-3ff10f4c73e2@rempel-privat.de>
 <87fuajmeak.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fuajmeak.fsf@kamboji.qca.qualcomm.com>

--Gm3dj6M8OUWOIrxaud9N5kXHdiDa4dnt2
Content-Type: text/plain; charset=utf-8
Content-Language: ru
Content-Transfer-Encoding: quoted-printable

Am 16.10.2017 um 15:07 schrieb Kalle Valo:
> Oleksij Rempel <linux@rempel-privat.de> writes:
>=20
>>> 4) As Kalle mentioned, rtlwifi contains many magic numbers, and I=20
>>>    plan to fix them after rtl8723de and rtl8821ce. Because the driver=
s
>>>    are developing, the changes will make us hard to integrate. Howeve=
r,
>>>    I don't have plan to process the magic numbers in the module phydm=
,
>>>    because the most of BB/RF registers contain many functions. And
>>>    it doesn't have a register name but a bit field name instead.
>>>    Our BB team guys say the use of enumeration or defined name will
>>>    be unreadable, and the name is meaningless for most people.
>>
>> Experience with ath9k driver showed, that development was kind of
>> balanced between two groups, QCA and Community (Other companies,
>> researches, education and so on.). Saying: "you will not understand it=

>> any way" is nor really helpful :)
>> Please don't repeat bad experience of Broadcom.
>=20
> I agree with Oleksij here, but I want to still point out that there are=

> cases when using magic numbers are ok, for example look at
> ar5008_initvals.h from ath9k. So it depends on case by case.

Beside. It is probably offtopic. I assume this initvals related to BB.
Is it possible to force a 802.11n controller to work in 802.11b mode? I
can image, it should be possible by reconfiguring BB. Correct?
--=20
Regards,
Oleksij


--Gm3dj6M8OUWOIrxaud9N5kXHdiDa4dnt2--

--C8h7igGKkDF8IwqWuwGA0g8SPLv5IcfpC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF4EAREIAAYFAlnksBUACgkQHwImuRkmbWmmpQD5AZxf+GGndepWK7REytcfM98N
qh+R9fvtH6bhjDNFO8QA/2Xg/jNrfSTyFXgNZlCf2fS7jlnuMCPLv6VGsbQPkz0g
=8KRk
-----END PGP SIGNATURE-----

--C8h7igGKkDF8IwqWuwGA0g8SPLv5IcfpC--
