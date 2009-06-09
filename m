Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41954 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbZFII4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 04:56:33 -0400
Subject: Re: [PATCH] cfg80211: fix for duplicate response for driver reg
 request
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1244512477-6804-1-git-send-email-lrodriguez@atheros.com>
References: <1244512477-6804-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GiCuqB4EjMSL2DMKNzOR"
Date: Tue, 09 Jun 2009 10:56:01 +0200
Message-Id: <1244537761.4672.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GiCuqB4EjMSL2DMKNzOR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-08 at 18:54 -0700, Luis R. Rodriguez wrote:
> As Pavel puts userspace can be stupid and should not
> cause kernel crashes. In this case Pavel was able to
> find a crash here but unable to reproduce. Either way
> lets deal with this.

Yes. Userspace is allowed to be as stupid as it wants, and may _never_
cause a kernel bug.

johannes

> This should fix:
>=20
> ------------[ cut here ]------------
> kernel BUG at /home/proski/src/linux-2.6/net/wireless/reg.c:2132!
> Oops: Exception in kernel mode, sig: 5 [#1]
> PowerMac
> Modules linked in: ath5k ath [last unloaded: scsi_wait_scan]
> NIP: c02f3eac LR: c02f3d08 CTR: 00000000
> REGS: ef107aa0 TRAP: 0700   Not tainted  (2.6.30-rc8-wl)
> MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 88002442  XER: 20000000
> TASK =3D ef84acb0[834] 'crda' THREAD: ef106000
> GPR00: ef953840 ef107b50 ef84acb0 ef1380bc 00000006 c035a5c8 ef107b90 c03=
5a5c8
> GPR08: 00080005 efb68980 c0445628 ef130004 28002422 10019ce0 10012d3c 000=
00001
> GPR16: 1070b2ac 00000005 48023558 1070b380 4802304c 00000000 ef107ddc c03=
5a5c8
> GPR24: ef107b78 c0443350 ef8bcb00 00000005 ef138080 c04a6a70 c04a0000 ef8=
bcb00
> NIP [c02f3eac] set_regdom+0x4c4/0x4ec
> LR [c02f3d08] set_regdom+0x320/0x4ec
> Call Trace:
> [ef107b50] [c02f3d08] set_regdom+0x320/0x4ec (unreliable)
> [ef107b70] [c02f9d10] nl80211_set_reg+0x140/0x2d0
> [ef107bc0] [c02aa2b8] genl_rcv_msg+0x204/0x228
> [ef107c10] [c02a97cc] netlink_rcv_skb+0xe8/0x10c
> [ef107c30] [c02aa094] genl_rcv+0x3c/0x5c
> [ef107c40] [c02a9050] netlink_unicast+0x308/0x36c
> [ef107c80] [c02a92bc] netlink_sendmsg+0x208/0x2f0
> [ef107cd0] [c0282048] sock_sendmsg+0xac/0xe4
> [ef107db0] [c02822b4] sys_sendmsg+0x234/0x2d8
> [ef107f00] [c0283a88] sys_socketcall+0x108/0x258
> [ef107f40] [c0012790] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0xfa6b3b4
>    LR =3D 0xfb4b5d4
> Instruction dump:
> 80690000 4bffc1e9 2c030000 4182003c 88a30039 88830038 3c60c03c 38632a18
> 4802c20d 4bfffed0 7f83e378 8403003c <0f000000> 7fe4fb78 4bffe6d1 7c7b1b79
> ---[ end trace c8eebdfbe3eb31de ]---
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index ea4c299..5e14371 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2129,7 +2129,12 @@ static int __set_regdom(const struct ieee80211_reg=
domain *rd)
>  		 * driver wanted to the wiphy to deal with conflicts
>  		 */
> =20
> -		BUG_ON(request_wiphy->regd);
> +		/*
> +		 * Userspace could have sent two replies with only
> +		 * one kernel request.
> +		 */
> +		if (request_wiphy->regd)
> +			return -EALREADY;
> =20
>  		r =3D reg_copy_regd(&request_wiphy->regd, rd);
>  		if (r)

--=-GiCuqB4EjMSL2DMKNzOR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLiOeAAoJEODzc/N7+QmarU4P/jbycw1xMWMmBeBrUEBckzqI
GPSji4O+f0iL1IGTz62l9pHMQZON23h7A9CDHx6Hcyc22NSYWk2GV7GsaRMXF1k9
4x+b9+PCAxgxr05YTbtm95MIpX11Fg+ZG17bxXu0c8vU7GGRebGFyeKG0YUO6Cvh
emLdqigv672VmYD9WDIYQkOcBA5djdtYnaMlaayAaz58pEz3vbPUXnLNfBhVyQy0
8GUH6es7jIH20vyG1gHwf9ujC+1ZSHpU5I1qES1FtatZwOqr/sJANCSPJfNKWKda
GoafJKT0RzI1jSUna7/oPpH8841PPh1goKQywyUyRhBb55QFu3vkXSRZz1JmxQhu
dLiyuVkHG7Vp/WAKoRnjin65imfipqbGcDDSRoonmj6OuqIj7pwAt9pD/CcprlQY
pJqXBMXeo1ViNmf8PerlcA/dkaPry4yQycvRnxVnUW0FjqEysPeUhzdGYRR7M29c
6vUD99mRP5kfRt2keJHT3ZaTAjpWsu/18gGX3lSoIBGHHWj4lW25dRLyC2Yoprvw
x6gOXZ4md4T0nF4nyhslfG7apQjn+6RMipOVCrSkujevMZtYVxPqVu6S+Zz/Kbmj
TWPqbnZVREp7XTqUbIJ2vk0VzUIWohsgT0oWft/CM1vO3l4lstQlcNBVy0oxOb8c
QHf5HwB7T4acKWWk598Q
=I7IV
-----END PGP SIGNATURE-----

--=-GiCuqB4EjMSL2DMKNzOR--

