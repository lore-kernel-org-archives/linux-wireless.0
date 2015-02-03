Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64207 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbbBCOf6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 09:35:58 -0500
Message-ID: <54D0DCAD.8060409@rempel-privat.de> (sfid-20150203_153601_485059_B2E20888)
Date: Tue, 03 Feb 2015 15:35:25 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>, yuweizheng@139.com
CC: linux-kernel@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	netdev@vger.kernel.org, Yuwei Zheng <zhengyuwei@360.cn>
Subject: Re: [PATCH] ath9k_htc: add adaptive usb flow control to repair soft
 lockup with monitor mode
References: <1422957585-19736-1-git-send-email-yuweizheng@139.com> <87fvanxldu.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fvanxldu.fsf@kamboji.qca.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iUpB7LPx2HInfLWVkAtsumNpumKIEm6uj"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iUpB7LPx2HInfLWVkAtsumNpumKIEm6uj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

It seems to work without noticeable regressions.

Am 03.02.2015 um 12:52 schrieb Kalle Valo:
> yuweizheng@139.com writes:
>=20
>> From: Yuwei Zheng <yuweizheng@139.com>
>>
>> In the environment with heavy wifi traffic, set the ar9271 into monito=
r mode, will
>> trigger a deadloop panic.
>> =20
>> The ath9k_hif_usb_rx_cb function excute on  the interrupt context, and=
 ath9k_rx_tasklet excute
>> on the soft irq context. In other words, the ath9k_hif_usb_rx_cb have =
more chance to excute than
>> ath9k_rx_tasklet.  So in the worst condition,  the rx.rxbuf receive li=
st is always full,
>> and the do {}while(true) loop will not be break. The kernel get a soft=
 lockup panic.=20
>=20
> The word wrapping is still wrong, please limit the width to 72 chars or=

> so. But no need to wrap log snippets, they can exceed the limit.
>=20
>> Signed-off-by: Yuwei Zheng <zhengyuwei@360.cn>
>> Signed-off-by: Yuwei Zheng <yuweizheng@139.com>
>=20
> Why two of these? Please use just one Signed-off-by line. Unless these
> are two different persons with the same name :)
>=20


--=20
Regards,
Oleksij


--iUpB7LPx2HInfLWVkAtsumNpumKIEm6uj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlTQ3LIACgkQHwImuRkmbWlnBQD/UqYjFgmRJJN5eTPDzTkqtBgh
1jOz1JyQN7UA3qOVSlwA/3fcKEeAExwgxbBjrCwv4YGxCffxeAYgPh8v1r6ICL//
=8qX6
-----END PGP SIGNATURE-----

--iUpB7LPx2HInfLWVkAtsumNpumKIEm6uj--
