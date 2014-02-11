Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63214 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaBKH5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 02:57:39 -0500
Received: from [192.168.1.221] ([93.218.106.218]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0M4ScS-1VGcDW0Q60-00yl7t for
 <linux-wireless@vger.kernel.org>; Tue, 11 Feb 2014 08:57:38 +0100
Message-ID: <52F9D7EB.1080309@rempel-privat.de> (sfid-20140211_085742_379522_945DC446)
Date: Tue, 11 Feb 2014 08:57:31 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
CC: Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v2 00/13] eliminate some ath9k_htc code
References: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SsESVXm3Vs5sAWEIrrsxLCDADBeNJspVN"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SsESVXm3Vs5sAWEIrrsxLCDADBeNJspVN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello all,

what is about this change set? Should i resend it.

Am 04.02.2014 10:27, schrieb Oleksij Rempel:
> This patch set moves most common RX code from ath9k/recv.c to
> common.c without any additional changes and reworks ath9k_htc RX code=20
> to make use of new common functions.
> Since ath9k_htc part was more intrusive I made tests in STA and AP mode=
s. No noticeable regressions was introduced.=20
> Last patch is important for debugging FW crashes.
>=20
> Oleksij Rempel (13):
>   ath: add last_rssi to ath_common
>   ath9k: move ath9k_process_rssi to common.c
>   ath9k: move ath9k_process_rate to common.c
>   ath9k: move ath9k_rx_accept to common.c
>   ath9k_htc: add rx header converter to make it usable by ath9k
>   ath9k_htc: use ath9k_cmn_process_rssi
>   ath9k_htc: use ath9k_cmn_process_rate
>   ath9k_htc: use ath9k_cmn_rx_accept
>   ath9k_htc: sync rx_status-> related code with ath9k
>   ath9k: move ath9k_rx_skb_postprocess to common.c
>   ath9k_htc: use ath9k_cmn_rx_skb_postprocess
>   ath9k_htc: remove useless memcpy
>   ath9k_htc: catch fw panic pattern
>=20
>  drivers/net/wireless/ath/ath.h                |   2 +
>  drivers/net/wireless/ath/ath9k/ath9k.h        |   1 -
>  drivers/net/wireless/ath/ath9k/common.c       | 244 ++++++++++++++++++=
+++++
>  drivers/net/wireless/ath/ath9k/common.h       |  19 ++
>  drivers/net/wireless/ath/ath9k/htc.h          |   1 -
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |   1 +
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |   1 +
>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 176 ++++++-----------
>  drivers/net/wireless/ath/ath9k/htc_hst.c      |  36 ++++
>  drivers/net/wireless/ath/ath9k/htc_hst.h      |  12 ++
>  drivers/net/wireless/ath/ath9k/init.c         |   2 +-
>  drivers/net/wireless/ath/ath9k/mac.h          |   9 +-
>  drivers/net/wireless/ath/ath9k/main.c         |   2 +-
>  drivers/net/wireless/ath/ath9k/recv.c         | 266 ++----------------=
--------
>  14 files changed, 386 insertions(+), 386 deletions(-)
>=20


--=20
Regards,
Oleksij


--SsESVXm3Vs5sAWEIrrsxLCDADBeNJspVN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlL51/AACgkQHwImuRkmbWmcjwD/fWuMZ6vxLV76IZYzgr//dbBu
uex4kJ7Ge+6WfopTKqQBAJaq72u5OkIVt51Iqbuf698yPT7b4PFEzxmeR54RTmFh
=CNkG
-----END PGP SIGNATURE-----

--SsESVXm3Vs5sAWEIrrsxLCDADBeNJspVN--
