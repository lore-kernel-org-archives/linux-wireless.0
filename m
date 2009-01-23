Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33326 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZAWPIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 10:08:10 -0500
Message-ID: <4979DD39.9000601@hauke-m.de> (sfid-20090123_160815_724536_889F24BD)
Date: Fri, 23 Jan 2009 16:07:37 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix driver to return TX retry info for RTL8187L
References: <49790961.JdcKIZyYlMNFSiuO%Larry.Finger@lwfinger.net>
In-Reply-To: <49790961.JdcKIZyYlMNFSiuO%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig453E2D84C3DBA7610369FDAA"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig453E2D84C3DBA7610369FDAA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Larry Finger wrote:
> Current code for the RTL8187 is not returning valid retry information, =
thus the
> rate-setting mechanism is not functioning. As a further complication, t=
his info
> is only obtained by reading a register, which cannot be read while in i=
nterrupt
> context.
>=20
> This patch implements the TX status return to mac80211 through the use =
of a
> work queue.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Tested-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Tested-by: Mart=C3=ADn Ernesto Barreyro <barreyromartin@gmail.com>
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

I have tested this patch in compat-wireless-2009-01-23 (kernel 2.6.27,
ubuntu) with my rtl8187 card (build on Asus P5B Delux Wifi, 0bda:8187
Realtek Semiconductor Corp. RTL8187 Wireless Adapter) and for me it does
not work.

With this patch I get a connection to the AP, but the bandwidth is very
low. After a reboot it was connected to the AP, but the connection was
unusable for me, no traffic went through the connection at all.

Hauke


--------------enig453E2D84C3DBA7610369FDAA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJJed09AAoJEIZ0px9YPRMyD+IP/RY0Htlc2kbD5o7nBWUjOmBS
N6+7frfPTs8A6jyJzLGP4WK9C1R0iJONlkyqvACZI4tto96ayjkihc9wSyJwoxol
vJDqHBMkoNthKNXUWvmId9gaXn733nVBJxUnMBaPBeQUwZ+MxuLiuTl+vERvW5lV
3KvGYcxyMa+k/GUUM6TvUTXsSrXMItdgF99Wf59zlxKcRIKrdSSG3fumQpib+p+S
Y8cyV9xaJUd9euBM4fRmdGr+UuuKpa3pn67bHzjymaQAAA6lrTwXTnihlpwpmpiQ
Xyy46voGK2GykpWRkYC3hGPB8/McIv0Vd9d3UfEK+vumNv25SMIowQjSss0i+qJd
gj9l7cplUv1F6EcDlAmuozZ3jiT1oCV7zagkvn4DWNIvLcfIOfkbgP8dnaAZ5Nvz
UdwIamSNuYG321UXF//nXXJHEput+DRbLaDg8nYRM4eqa02EFdly4ICGVk3UHdk2
sv6gTu0BTu7Z/azPZySYQA3EsF/kfYhn4ssWeh742AYLvd7bwOUQZsBri939/las
HZ/7LLfYV7Jf2c+70/MdEPBUchT+0VydBbxfaQSaKqAdq4s5XlMuUK4ilzcCr0Ow
pK6incg1aFHNKlln+93tumaUDrmaRnVY6ier6KUocW98NNdb5aGVk/E8HYUeQZF1
UleHEdt0OrLTTDDOyuRM
=EfJG
-----END PGP SIGNATURE-----

--------------enig453E2D84C3DBA7610369FDAA--
