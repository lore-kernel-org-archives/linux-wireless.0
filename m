Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56327 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbaJKHbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2014 03:31:16 -0400
Message-ID: <5438DCBF.5090404@rempel-privat.de> (sfid-20141011_093124_171291_7499B1A7)
Date: Sat, 11 Oct 2014 09:31:11 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "Schroer, Jens Peter" <jens.schroer@scypho.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Kernel Oops with ath9k_htc during AES decrypt on ARM / BeagleBone
 Black
References: <51054a8c690db75aa1efacb98e4379c9@scypho.com> <54368960.4040109@rempel-privat.de> <828b549f60c81155be705f5173fe0e11@scypho.com> <54369F07.9080705@rempel-privat.de> <1772bbe6a9db0760b4712cf8fad81fbc@scypho.com>
In-Reply-To: <1772bbe6a9db0760b4712cf8fad81fbc@scypho.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kQb2jpUIBV7IrWxaJ6qF5shgrOq9nWLA2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kQb2jpUIBV7IrWxaJ6qF5shgrOq9nWLA2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 10.10.2014 um 14:42 schrieb Schroer, Jens Peter:
> Hi Oleksij,
>=20
> I have tried to recover the full dmesg, but it seems to be lost.
> I am not sure if it disappeared with during the last reboot or was not
> synced back to the flash due to the kernel panic.
> I tried to reproduce the kernel oops, but get stuck with the problem I
> mentioned in my other email.
> Is there a way of printing / tracing bad packages, so that when this
> crash occures the next time, I have hopefully more information availabl=
e?
> Also, just for completeness, the issue that stops me from trying to
> reproduce the kernel oops:

I don't think this two reports are separate issues. In both cases it is
triggered by processing of broken RX packages. In one case, wrong rate,
in other case wrong length. Lets start with rate, since it seems to be
easier to reproduce.

Theoretically packets with brocken rate should be just filtered out by
ath9k_cmn_process_rate. Lets try this patch:

diff --git a/drivers/net/wireless/ath/ath9k/common.c
b/drivers/net/wireless/ath/
index c6dd7f1..f7c4db0 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -205,6 +205,7 @@ int ath9k_cmn_process_rate(struct ath_common *common,=

                }
        }

+       printk("Warning! Unsuported rate.\n");
        return -EINVAL;
 }
 EXPORT_SYMBOL(ath9k_cmn_process_rate);

--=20
Regards,
Oleksij


--kQb2jpUIBV7IrWxaJ6qF5shgrOq9nWLA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlQ43L8ACgkQHwImuRkmbWnsPQD8CEx6aA1cnG3GJ5oWTi4vSzR0
k6RAar8p/26zffteX5kBAInX1aUg1hebvwO/1PSj4tQCb1DAJnQTx9ln/az1PNwA
=lik6
-----END PGP SIGNATURE-----

--kQb2jpUIBV7IrWxaJ6qF5shgrOq9nWLA2--
