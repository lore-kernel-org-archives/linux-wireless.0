Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:65514 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbaBCNMA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 08:12:00 -0500
Received: from [192.168.1.221] ([93.196.93.204]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0LbdE3-1VPC8D3wmx-00lABV for
 <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 14:11:59 +0100
Message-ID: <52EF9594.40303@rempel-privat.de> (sfid-20140203_141217_454709_A067CCFD)
Date: Mon, 03 Feb 2014 14:11:48 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>,
	Sujith Manoharan <sujith@msujith.org>
CC: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/13] ath9k_htc: add rx header converter to make it usable
 by ath9k
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>	<1391022424-21087-1-git-send-email-linux@rempel-privat.de>	<1391022424-21087-4-git-send-email-linux@rempel-privat.de> <21230.64089.741.909535@gargle.gargle.HOWL> <52EF7BEB.5080605@rempel-privat.de> <52EF8699.2000305@openwrt.org>
In-Reply-To: <52EF8699.2000305@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Vqn6C8eugs9fVsfCIcV7Mr1ocs3jNv69t"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Vqn6C8eugs9fVsfCIcV7Mr1ocs3jNv69t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 03.02.2014 13:07, schrieb Felix Fietkau:
> On 2014-02-03 12:22, Oleksij Rempel wrote:
>> Am 03.02.2014 03:09, schrieb Sujith Manoharan:
>>> Oleksij Rempel wrote:
>>>> +	rx_stats =3D kzalloc(sizeof(struct ath_rx_status), GFP_KERNEL);
>>>> +	if (unlikely(rx_stats =3D=3D NULL)) {
>>>> +		ath_err(common, "rx_stats allocation filed!\n");
>>>> +		goto err_nofree;
>>>> +	}
>>>> +	rx_status_htc_to_ath(rx_stats, &rxbuf->rxstatus);
>>>> +
>>
>>> This seems a little expensive, since this would happen for every pack=
et,
>>> and a memcpy is already done earlier, for storing the RX status in
>>> rxbuf->rxstatus. Instead of using 'struct ath_htc_rx_status' in
>>> 'struct ath9k_htc_rxbuf', why can't 'struct ath_rx_status' be used ?
>>> The values can be converted and stored directly, avoiding this alloc.=

>>
>> Do you mean kzalloc or converter?
>> then memcpy is removed by patch 12/13. Converter is not effective but =
it
>> should prevent from confusions. At least until FW use same flags and
>> struct ath_rx_status do.
>> But i'm open for other ideas too.
> You should at least keep rx_stats on stack instead of using kzalloc,
> that would make it much faster.

You right, i'll do it.

Beside what is the smallest stack size in kernel i need to count on?


--=20
Regards,
Oleksij


--Vqn6C8eugs9fVsfCIcV7Mr1ocs3jNv69t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLvlZsACgkQHwImuRkmbWkD7QD/d84/KeI7lqg414ky/IsIqGUf
lU4r6/P+aq+d8vTdxhIA/2LoQiu89WuAmYuiildH80PAd518w4V+NA6K9VazGx6u
=s18v
-----END PGP SIGNATURE-----

--Vqn6C8eugs9fVsfCIcV7Mr1ocs3jNv69t--
